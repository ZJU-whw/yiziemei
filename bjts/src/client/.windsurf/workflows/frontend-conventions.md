---
description: 本项目页面开发规范与通用写法模式，涵盖组件结构、jqGrid表格、查询条件、导出等
---

# 本项目页面开发规范

本项目基于 **avalon2** 组件框架 + **jqGrid** 表格 + **zTree** 树形控件，所有页面遵循统一的写法模式。

---

## 一、文件结构

每个页面由两个文件组成，放在同一目录下：

- `xxx.js` - 组件逻辑
- `xxx.html` - 组件模板

JS 文件开头 require 同名 HTML：
```javascript
var xxx = require("./xxx.html");
avalon.component('xxx', {
    template: xxx,
    defaults: { ... }
});
```

---

## 二、组件结构（defaults 内的标准属性/方法）

### 2.1 基础属性

```javascript
defaults: {
    params: {},              // 外部传入参数
    act: 1,                  // 当前激活的 tab
    tcode: "xxx",            // 列配置编码（对应后端 columprofile 接口）
    swjgDm: "",              // 税务机关代码
    swjgMc: "",              // 税务机关名称
    searchData: {            // 查询条件对象
        qybs: "",
        qymc: "",
        swjgDm: "",
        swjgMc: "",
        orderSql: "cl_date desc",  // 排序字段
        pageSize: config.pageSize, // 每页条数
    },
    tableArr: [],            // jqGrid 列模型数组
    tableOption: [],         // 可配置显示/隐藏的列
    tableData: { sumData: {} }, // 表格数据 + 合计行
    yjList: [],              // 下拉选项数据
    zbList: [],
    timer: null,             // 防抖定时器
}
```

### 2.2 生命周期方法

```javascript
onReady: function() {
    var self = this;
    // 1. 设置用户权限/税务机关
    this.hasHsPermission = this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
    this.searchData.swjgDm = avalonRoot.user.swjgDm;
    // 2. 处理外部传入参数 (self.params)
    // 3. 初始化列配置 -> 必须调用
    this.getTableRow();
    // 4. 初始化树
    self.initTree();
    // 5. 初始化日期选择器
    $('.xxx .datepicker.date-day').datepicker({ dateFormat: 'yy-mm-dd' });
    $('.xxx .datepicker.date-month').datepicker({ dateFormat: 'yymm' });
    // 6. 加载下拉数据
    this.initYjList();
},
```

---

## 三、jqGrid 表格

表格分为两种模式：**动态列（后端配置，可配置列显示/隐藏）** 和 **静态列（前端硬编码，不可配置）**。

### 3.0 两种模式对比

| 特征 | 动态列模式 | 静态列模式 |
|------|-----------|-----------|
| **列定义来源** | 后端 `columprofile` 接口返回 | 前端代码硬编码 `colNames`/`colModel` |
| **列配置按钮** | 有（"配置表格▼" 下拉菜单） | 无 |
| **用户可配置列** | 是，`is_fixed=='0'` 的列可显示/隐藏，配置保存到后端 | 否 |
| **核心方法** | `getTableRow` → `createTable` → `search` | `buildColumns` → `forceRebuildTable` → `searchInfo` |
| **表格重建** | `createTable` 一次初始化 | `forceRebuildTable` 先 `GridUnload` 再重建 |
| **复合表头** | 不支持（列动态生成） | 支持 `setGroupHeaders` |
| **适用场景** | 通用查询页面，列可能变化，用户需自定义显示列 | 固定业务页面，列结构稳定，需要复合表头 |
| **典型页面** | 预警信息综合查询、退税返纳查询等 | 出口链路模型维护、出口链路参数查询等 |

---

### 模式一：动态列（后端配置 + 可配置列）

#### 3.1 getTableRow - 从后端获取列配置

调用 `/cxfw/basis/columprofile` 接口获取列定义，动态构建 colModel：

```javascript
getTableRow: function() {
    var self = this;
    ajax("POST", "/cxfw/basis/columprofile", { tcode: self.tcode }).done(function(res) {
        if (res.code == "0") {
            if (!res.data) { return; }
            var arr = res.data.profiles;
            var tableArr = [];
            var tableOption = [];
            for (var i = 0; i < arr.length; i++) {
                var obj = {
                    name: arr[i].t_c_code,
                    label: arr[i].t_c_name,
                    index: arr[i].t_c_code,
                    sortable: arr[i].is_order == 0 ? false : true,
                    hidden: false,
                    width: arr[i].c_std_size,
                    align: arr[i].align == 0 ? "left" : arr[i].align == 1 ? "center" : "right",
                };
                // 特殊列 formatter：链接列
                if (obj.name == 'nsrsbh') {
                    obj.formatter = function(cellvalue, options, rowObject) {
                        return "<span style='color:#0000ff;text-decoration:underline;cursor:pointer;' class='openMx'>" + cellvalue + "</span>";
                    };
                }
                // 数值列 formatter：degree 控制小数位数（注意空值处理）
                if (arr[i].degree) {
                    var degree = arr[i].degree;
                    obj.formatter = function(cellvalue, options, rowObject) {
                        if (cellvalue === "" || cellvalue === null || cellvalue === undefined) {
                            return "";
                        }
                        return avalon.filters.number(cellvalue, degree);
                    };
                }
                tableArr.push(obj);
                // is_fixed=='0' 的列加入可配置列表
                if (arr[i].is_fixed == '0') {
                    tableOption.push({
                        name: arr[i].t_c_code,
                        label: arr[i].t_c_name,
                        show: false
                    });
                }
            }
            self.tableArr = tableArr;
            self.tableOption = tableOption;
            if (tableArr.length > 0) {
                self.createTable(tableArr);
            }
            // 恢复用户已选列
            var selected = res.data.select.split(",");
            for (var j = 0; j < selected.length; j++) {
                for (var k = 0; k < self.tableOption.length; k++) {
                    if (selected[j] == self.tableOption[k].name) {
                        self.tableOption[k].show = true;
                    }
                }
            }
            self.resetTable();
        } else {
            tools.info(res.msg);
        }
    }).fail(function(err) {
        tools.info(err);
    });
},
```

> **else 分支含义**: `code != '0'` 为接口报错，用 `tools.info(res.msg)` 提示；`code == '0'` 但 `!res.data` 为返回值为空，直接 `return` 不报错。

#### 3.2 createTable - 初始化 jqGrid

```javascript
createTable: function(arr) {
    var self = this;
    var cm = [];
    for (var i = 0; i < arr.length; i++) {
        cm[i] = tools.clone(arr[i]);
    }
    $("#xxx-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: cm,
        viewrecords: true,
        rownumbers: true,            // 序号列
        pager: '#xxx-tablePager',    // 分页器
        shrinkToFit: false,
        width: "100%",
        autowidth: true,
        altRows: true,               // 斑马纹
        altclass: "altclasscss",
        footerrow: true,             // 合计行（按需）
        sortname: 'cl_date',
        sortorder: 'desc',
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function() {
            return $(".xxx .form").height() - 60 - 30;
        })(),
        // 行点击事件：链接跳转 / 行高亮
        beforeSelectRow: function(rowid, e) {
            if ($(e.target).hasClass('openMx')) {
                avalonRoot.addTab({ title: "...", component: "xxx", params: {...} });
                return false;
            } else if (e.target.nodeName == "TD") {
                $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                return false;
            } else {
                return true;
            }
        },
        // 排序
        onSortCol: function(index, iCol, sortorder) {
            self.searchData.orderSql = index + ' ' + sortorder;
            self.search(1);
            return;
        },
        // 合计行赋值
        gridComplete: function() {
            var sumData = self.tableData.sumData;
            sumData[self.tableArr[0].name] = "合计";
            $("#xxx-table").footerData('set', sumData);
        },
        // 分页
        onPaging: function(pgButton) {
            var pageNo = tools.getPageNo(pgButton, "xxx-table");
            self.search(pageNo);
        },
    });
    this.searchData.pageSize = $(".ui-pg-selbox", $('.xxx')).val();
    self.search(1);
},
```

#### 3.3 search - 查询数据

```javascript
search: function(pageNo) {
    var self = this;
    this.searchData.pageSize = $(".ui-pg-selbox", $('.xxx')).val();
    var params = tools.clone(self.searchData);
    params.pageNo = pageNo;
    $("#xxx-table").jqGrid('clearGridData');
    ajax("POST", "/bjtssw/xxx/list", params).done(function(res) {
        if (res.code == '0') {
            if (!res.data) { return; }
            self.tableData = res.data;
            $("#xxx-table").resetSelection();
            $("#xxx-table")[0].addJSONData(res.data);
            self.closeHyper();
        } else {
            tools.info(res.msg);
        }
    }).fail(function(err) {
        tools.info(err);
    });
},
```

#### 3.4 列显示/隐藏配置（仅动态列模式）

```javascript
setTableOption: function() {
    var self = this;
    setTimeout(function() { self.resetTable(); }, 200);
    // 防抖：2秒后提交列配置到后端
    if (self.timer == null) {
        self.timer = setTimeout(function() {
            self.updataOption();
            clearTimeout(self.timer);
            self.timer = null;
        }, 2000);
    } else {
        clearTimeout(self.timer);
        self.timer = setTimeout(function() {
            self.updataOption();
            clearTimeout(self.timer);
            self.timer = null;
        }, 2000);
    }
},
updataOption: function() {
    var self = this;
    var cs = [];
    for (var i = 0; i < self.tableOption.length; i++) {
        if (self.tableOption[i].show == true) {
            cs.push(self.tableOption[i].name);
        }
    }
    ajax("POST", "/bjtssw/basis/columprofile/update", {
        tcode: this.tcode,
        cs: cs.join(',')
    }).done(function(res) {
        if (res.code != '0') tools.info(res.msg);
    }).fail(function(err) { tools.info(err); });
},
resetTable: function() {
    var self = this;
    for (var i = 0; i < self.tableOption.length; i++) {
        if (self.tableOption[i].show == true) {
            $("#xxx-table").showCol(self.tableOption[i].name);
        } else {
            $("#xxx-table").hideCol(self.tableOption[i].name);
        }
    }
    $("#xxx-table").setGridWidth($('.xxx').width());
},
```

---

## 四、查询条件区

查询条件区有两种样式模式：**可折叠** 和 **不折叠**。

### 4.1 模式一：可折叠（select-main + select-sub + icon）

常用条件放在 `select-main` 中始终显示，更多条件放在 `select-sub` 中默认隐藏，通过点击 icon 展开/收起。

**HTML 结构：**
```html
<div class="select-wrapper">
    <span class="reset" title="重置查询条件" ms-click="@reset">重置：</span>
    <i class="icon" ms-click="showHyper" title="展开查询条件"></i>
    <div class="select-main">
        <!-- 常用查询条件（始终显示） -->
        <div class="select-item" style="position: relative;">
            <label class="width-s">退税机关</label>
            <input class="width-m" type="text" ms-duplex="searchData.swjgMc" ms-click="showTree">
            <ul class='ztree treeDiv' style="left: 40%;top:100%;"></ul>
        </div>
        <div class="select-item">
            <label class="width-s">企业标识</label>
            <input class="width-m" type="text" ms-duplex="searchData.qybs">
        </div>
        <div class="select-item">
            <label class="width-s">处理标志</label>
            <select class="width-m" ms-duplex="@searchData.clFlag">
                <option value="">　</option>
                <option value="1">已处理</option>
                <option value="0">未处理</option>
            </select>
        </div>
    </div>
    <div class="select-sub">
        <!-- 更多查询条件（默认隐藏，点击 icon 展开） -->
        <div class="select-item">
            <label class="width-s">预警项</label>
            <select class="width-m" ms-duplex="searchData.yjcode" ms-on-change="setZbList($event)">
                <option value=""></option>
                <option ms-for="item in yjList" ms-attr="{'value':item.yjcode}">{{"("+item.yjcode+")"+item.yjname}}</option>
            </select>
        </div>
        <div class="select-item">
            <label class="width-s">申报年月</label>
            <input type="text" class="datepicker date-month width-m" ms-duplex="@searchData.sbym" ms-on-change="@filMon($event)">
        </div>
        <div class="select-item">
            <label class="width-s">预警日期</label>
            <div class="select-item-inner">
                <input class="datepicker date-day width-s" type="text" ms-duplex="searchData.clrqq" ms-on-change="@filDate($event)">
                <span>-</span>
                <input class="datepicker date-day width-s" type="text" ms-duplex="searchData.clrqz" ms-on-change="@filDate($event)">
            </div>
        </div>
    </div>
</div>
```

**JS 方法：**
```javascript
showHyper: function() {
    $('.xxx .select-sub').toggle();
    $('.xxx .select-wrapper .icon').toggleClass("active");
    if ($('.xxx .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
        $('.xxx .select-wrapper .icon').attr("title", "收起查询条件");
    } else {
        $('.xxx .select-wrapper .icon').attr("title", "展开查询条件");
    }
},
closeHyper: function() {
    $('.xxx .select-sub').hide();
    $('.xxx .select-wrapper .icon').removeClass('active');
    $('.xxx .select-wrapper .icon').attr("title", "展开查询条件");
},
```

> 查询成功后通常调用 `self.closeHyper()` 自动收起。

### 4.2 模式二：不折叠（多个 select-main 平铺，无 icon 无 select-sub）

所有条件平铺在多个 `select-main` 中，始终显示，无展开/收起按钮。

**HTML 结构：**
```html
<div class="select-wrapper">
    <span class="reset" title="重置查询条件" ms-click="@resetSearchData">重置：</span>
    <div class="select-main">
        <!-- 第一行条件 -->
        <div class="select-item">
            <label title="税务机关">税务机关</label>
            <input readonly type="text" class="bt-form-control" ms-duplex="swjgmc" ms-click="@showTree">
            <ul class='ztree treeDiv'></ul>
        </div>
        <div class="select-item">
            <label title="企业标识">企业标识</label>
            <input type="text" class="bt-form-control" ms-duplex="@searchData.qybs">
        </div>
        <div class="select-item">
            <label title="申报业务种类">申报业务种类</label>
            <select class="bt-form-control width-m" ms-duplex="searchData.sbywb">
                <option value=""></option>
                <option ms-for="ywb in sbywbMap" ms-attr="{value: ywb.value}">{{ywb.label}}</option>
            </select>
        </div>
    </div>
    <div class="select-main">
        <!-- 第二行条件 -->
        <div class="select-item">
            <label title="所属期">所属期</label>
            <div class="select-item-inner">
                <input type="text" readonly class="bt-form-control datepicker date-month" ms-duplex="@searchData.sssqStart">
                <span>止</span>
                <input type="text" readonly class="bt-form-control datepicker date-month" ms-duplex="@searchData.sssqEnd">
            </div>
        </div>
        <div class="select-item">
            <label title="上传日期">上传日期</label>
            <div class="select-item-inner">
                <input type="text" readonly class="bt-form-control datepicker date-day" ms-duplex="@searchData.yxscrqq">
                <span>止</span>
                <input type="text" readonly class="bt-form-control datepicker date-day" ms-duplex="@searchData.yxscrqz">
            </div>
        </div>
    </div>
</div>
```

> 不折叠模式无需 `showHyper` / `closeHyper` 方法，无需 `<i class="icon">` 元素，无需 `select-sub` 容器。

### 4.3 两种模式对比

| 特征 | 可折叠模式 | 不折叠模式 |
|------|-----------|-----------|
| **icon 按钮** | 有 `<i class="icon" ms-click="showHyper">` | 无 |
| **select-sub** | 有，存放更多条件，默认隐藏 | 无 |
| **select-main** | 一个，存放常用条件 | 多个，平铺所有条件 |
| **showHyper/closeHyper** | 需要 | 不需要 |
| **查询后自动收起** | `self.closeHyper()` | 无 |
| **适用场景** | 查询条件多（>6个），需要收起节省空间 | 查询条件少（≤6个），全部展示 |
| **input 样式** | `width-m` / `width-s` | `bt-form-control` |

### 4.4 日期校验

```javascript
filDate: function(e) {
    var date = e.target.value;
    var res = tools.DateCheup(date);
    if (res === false) { tools.info("日期输入错误"); res = ""; }
    e.target.value = res;
},
filMon: function(e) {
    var date = e.target.value;
    var res = tools.MonCheup(date);
    if (res === false) { tools.info("申报年月输入错误"); res = ""; }
    e.target.value = res;
},
```

### 4.5 金额格式化

```javascript
filNum2: function(e) {
    var date = e.target.value;
    e.target.value = date ? avalon.filters.number(date, 2) : date;
    return false;
},
```

### 4.6 重置

```javascript
reset: function() {
    var self = this;
    self.searchData = {
        qybs: "",
        qymc: "",
        swjgDm: avalonRoot.user.swjgDm,
        swjgMc: avalonRoot.user.swjgMc,
        orderSql: "cl_date desc",
        pageSize: config.pageSize,
    };
},
```

---

## 五、zTree 树形控件

```javascript
initTree: function() {
    var self = this;
    var setting = {
        callback: {
            onClick: function(e, id, node) {
                self.searchData.swjgDm = node.id;
                self.searchData.swjgMc = node.text;
                self.hideTree();
            },
            onDblClick: function(e, id, node) {
                self.searchData.swjgDm = node.id;
                self.searchData.swjgMc = node.text;
                self.hideTree();
            }
        },
        data: { key: { children: "item", name: "text" } }
    };
    tools.getCachedSwjg(avalonRoot, ajax).done(function(data) {
        $.fn.zTree.init($(".xxx .treeDiv"), setting, data);
    }).fail(function(err) { tools.info(err); });
},
showTree: function(e) {
    var self = this;
    $(".treeDiv", $(e.target).parent()).show();
    $('.xxx').on('click', function(e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
            self.hideTree();
        }
    });
},
hideTree: function() {
    $(".treeDiv").hide();
    $('.xxx').off('click');
},
```

---

## 六、导出

```javascript
exform: function() {
    var self = this;
    if ($("#xxx-table").jqGrid('getRowData').length <= 0) {
        tools.info("请先查询列表");
        return;
    }
    var params = tools.clone(self.searchData);
    var form = $("<form>");
    form.attr("style", "display:none");
    form.attr("method", "post");
    form.attr("action", "/bjtssw/xxx/export");
    var input1 = $("<input>");
    input1.attr("type", "hidden");
    input1.attr("name", "data");
    input1.attr("value", JSON.stringify(params));
    $("body").append(form);
    form.append(input1);
    form.submit();
    form.remove();
},
```

---

## 七、HTML 模板结构

```html
<div class="xxx">
    <div class="pageTabs">
        <div class="pageTitle">页面标题</div>
        <div class="btns" ms-if="@act==1">
            <div class="btn" ms-click="@search(1)">查询</div>
            <div class="btn" ms-click="@exform">导出</div>
            <div class="btn dropdown" ms-on-click="showMenu">
                配置表格▼
                <ul class="dropdown-menu">
                    <li ms-for="(index,item) in @tableOption">
                        <label><input type="checkbox" ms-duplex-checked="item.show" ms-on-click="@setTableOption(item,$event)">{{item.label}}</label>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div ms-class="['page',@act==1&&'active']">
        <div class="select-wrapper">
            <span class="reset" title="重置查询条件" ms-click="@reset">重置：</span>
            <i class="icon" ms-click="showHyper" title="展开查询条件"></i>
            <div class="select-main">
                <!-- 常用查询条件 -->
                <div class="select-item" style="position: relative;">
                    <label class="width-s">标签</label>
                    <input class="width-m" type="text" ms-duplex="searchData.xxx">
                </div>
            </div>
            <div class="select-sub">
                <!-- 折叠的更多查询条件 -->
            </div>
        </div>
        <div class="form" style="padding-top: 54px;">
            <table id="xxx-table"></table>
            <div id="xxx-tablePager"></div>
        </div>
    </div>
</div>
```

---

## 八、模式二：静态列（前端硬编码）

部分页面（如风险管理模块）不使用 columprofile 接口，而是在前端硬编码列定义，用 `forceRebuildTable` 重建表格。

### 8.1 buildColumns - 前端定义列

```javascript
buildColumns: function() {
    var self = this;
    self.colNames = ['序号', '企业名称', '海关代码', '出口金额', '...'];
    self.colModel = [
        { name: 'rn', index: 'rn', width: 50, align: 'center', sortable: false },
        { name: 'qymc', index: 'qymc', width: 200, align: 'left' },
        { name: 'hgdm', index: 'hgdm', width: 120, align: 'center' },
        { name: 'ckje', index: 'ckje', width: 120, align: 'right',
          formatter: function(cellvalue) {
              if (cellvalue === "" || cellvalue === null || cellvalue === undefined) return "";
              return avalon.filters.number(cellvalue, 2);
          }
        },
        // ...
    ];
},
```

### 8.2 forceRebuildTable - 销毁并重建 jqGrid

```javascript
forceRebuildTable: function() {
    var self = this;
    if ($("#xxx-grid").hasClass("ui-jqgrid-btable")) {
        $("#xxx-grid").jqGrid('GridUnload');
    }
    // 计算 height ...
    setTimeout(function() {
        $("#xxx-grid").jqGrid({
            colNames: self.colNames,
            colModel: self.colModel,
            datatype: "local",
            gridview: true,
            viewrecords: true,
            rownumbers: true,
            pager: '#xxx-pager',
            shrinkToFit: false,
            width: "100%",
            autowidth: true,
            altRows: true,
            altclass: "altclasscss",
            rowNum: config.pageSize,
            rowList: config.pageSizeList,
            height: (function() {
                return $(".xxx .form").height() - 60 - 30;
            })(),
            loadComplete: function() {
                setTimeout(function() {
                    $("#xxx-grid")[0].addJSONData(self.tableData);
                }, 0);
                self.changeH();
            },
            onSortCol: function(index, iCol, sortorder) {
                self.searchData.orderSql = index + ' ' + sortorder;
                self.searchInfo(1, true);
                return;
            },
            onPaging: function(pgButton) {
                self.pageNo = tools.getPageNo2(pgButton, "xxx-pager");
                self.searchInfo(self.pageNo, true);
            }
        });
        // 复合表头（按需）
        $("#xxx-grid").jqGrid('setGroupHeaders', {
            useColSpanStyle: true,
            groupHeaders: [
                { startColumnName: 'col1', numberOfColumns: 3, titleText: '一组表头' },
                { startColumnName: 'col4', numberOfColumns: 2, titleText: '二组表头' },
            ]
        });
    }, 200);
},
```

### 8.3 searchInfo - 查询数据

```javascript
searchInfo: function(pageNo, isPaging) {
    var self = this;
    this.searchData.pageSize = $(".ui-pg-selbox", $('.xxx')).val();
    var params = tools.clone(self.searchData);
    params.pageNo = pageNo;
    if (!isPaging) {
        $("#xxx-grid").jqGrid('clearGridData');
    }
    ajax("POST", "/bjtssw/xxx/list", params).done(function(res) {
        if (res.code == '0') {
            if (!res.data) { return; }
            self.tableData = res.data;
            if (!$("#xxx-grid").hasClass("ui-jqgrid-btable")) {
                self.forceRebuildTable();
            } else {
                $("#xxx-grid")[0].addJSONData(res.data);
            }
        } else {
            tools.info(res.msg);
        }
    }).fail(function(err) {
        tools.info(err);
    });
},
```

> 静态列模式无 `tableOption`/`setTableOption`/`updataOption`/`resetTable` 方法，无 "配置表格▼" 按钮。

---

## 九、公共方法优先复用（`static/js/tools.js`）

项目中所有公共工具方法统一维护在 `@/static/js/tools.js`，开发新页面时**优先从中复用**，不要在组件内重复实现。

### 9.1 日期相关

| 方法 | 签名 | 说明 |
|------|------|------|
| `tools.DateCheup(date)` | `(str) → "YYYY-MM-DD" \| false` | 校验并标准化日期格式，支持 `-`/`/`/`.` 分隔符或纯数字（6位/8位） |
| `tools.MonCheup(date)` | `(str) → "YYYYMM" \| false` | 校验并标准化年月格式 |
| `tools.checkDate(start, end)` | `(str, str) → boolean` | 校验结束日期不早于开始日期 |
| `tools.getToday(date?)` | `(Date?) → "YYYY-MM-DD"` | 获取今天日期字符串 |
| `tools.getPreviousDay()` | `() → "YYYY-MM-DD"` | 获取昨天日期 |
| `tools.getFirstDayOfYear()` | `() → "YYYY-01-01"` | 获取当年第一天 |
| `tools.getYearStart()` | `() → "YYYY-01-01"` | 获取当年第一天（同上） |
| `tools.getDateStr(n)` | `(number) → "YYYY-MM-DD"` | 获取 n 天后/前的日期 |
| `tools.getNextDay(n)` | `(number) → "YYYY-MM-DD"` | 获取 n 天后/前的日期（同上） |
| `tools.getTodayYM(date?)` | `(Date?) → "YYYYMM"` | 获取今天年月 |
| `tools.getFirstMounth(date?)` | `(Date?) → "YYYY01"` | 获取当年1月 |
| `tools.getMonth(time?, symbol?)` | `(str?, str?) → "YYYY[symbol]MM"` | 获取指定时间的年月，可带分隔符 |
| `tools.getMonthFormat(symbol?)` | `(str?) → "YYYY[symbol]MM"` | 获取当前年月，可带分隔符 |
| `tools.getMonStart(time?)` | `(str?) → "YYYY-MM-01"` | 获取月份第一天 |
| `tools.getMonthLast(time?)` | `(str?) → "YYYY-MM-DD"` | 获取月份最后一天 |
| `tools.getPrevMonth(time?)` | `(str?) → "YYYYMM"` | 获取上个月 |
| `tools.getFontMonths(months, date?)` | `(num, Date?) → "YYYY-MM-DD"` | 获取 n 个月前的日期 |
| `tools.getNextMonths(months, date?)` | `(num, Date?) → "YYYY-MM-DD"` | 获取 n 个月后的日期 |
| `tools.getQuarterStartDate(year, season)` | `(str, str) → "YYYY-MM-DD"` | 获取季度开始日期 |
| `tools.getQuarterEndDate(year, season)` | `(str, str) → "YYYY-MM-DD"` | 获取季度结束日期 |
| `tools.betweenYear(start, end)` | `(str, str) → boolean` | 判断两个日期是否在同一年或相差不超过1年 |

### 9.2 弹窗/提示

| 方法 | 签名 | 说明 |
|------|------|------|
| `tools.info(text, fn?)` | `(str, function?)` | 信息提示弹窗（模态），可带回调 |
| `tools.success(text)` | `(str)` | 成功提示，2秒自动关闭 |
| `tools.confirm(text, okVal, ok, cancel?, cancelVal?)` | `(str, str, fn, fn?, str?)` | 确认对话框 |
| `tools.infoList(arr, okVal, ok, cancel?, cancelVal?)` | `(array, ...)` | 表格形式的信息列表弹窗 |

### 9.3 分页

| 方法 | 签名 | 说明 |
|------|------|------|
| `tools.getPageNo(pgButton, tableName)` | `(str, str) → number` | jqGrid onPaging 获取页码（table ID 格式：`xxx-table`） |
| `tools.getPageNo2(pgButton, tableName)` | `(str, str) → number` | jqGrid onPaging 获取页码（table ID 格式：`xxx-pager`） |

### 9.4 数据处理

| 方法 | 签名 | 说明 |
|------|------|------|
| `tools.clone(data)` | `(obj/array) → deep copy` | 深拷贝（兼容 avalon `$model`） |
| `tools.toDecimal2(x)` | `(number) → "0.00"` | 保留两位小数（支持负数） |
| `tools.Num2CN(money)` | `(number) → "壹仟元整"` | 数字转中文大写金额 |
| `tools.pieSelect(list, len)` | `(array, num) → array` | 饼图数据聚合，超过 len 的合并为"其他" |
| `tools.getVis(list, addV?)` | `(array, num?) → [min, max]` | 获取图表可视区间 |
| `tools.validate(formName, fields)` | `(str, array) → boolean` | 表单校验 |

### 9.5 导出

| 方法 | 签名 | 说明 |
|------|------|------|
| `tools.exform(params, url)` | `(obj, str)` | 表单提交方式导出（兼容旧浏览器） |
| `tools.ajaxExform(params, url)` | `(obj, str) → Promise` | XHR 方式导出（支持 Blob 下载、错误提示） |

### 9.6 税务机关树

| 方法 | 签名 | 说明 |
|------|------|------|
| `tools.getCachedSwjg(avalonRoot, ajax)` | `(obj, fn) → Promise` | 获取税务机关树数据（带缓存，3级） |
| `tools.getCachedSwjg4J(avalonRoot, ajax)` | `(obj, fn) → Promise` | 获取税务机关树数据（带缓存，4级） |
| `tools.getPreSwjgdm(swjgDm)` | `(str) → str` | 截取税务机关代码（去末尾0） |
| `tools.isXianju(swjgDm)` | `(str) → boolean` | 判断是否为县局 |

### 9.7 其他

| 方法 | 签名 | 说明 |
|------|------|------|
| `tools.GetQueryString(name)` | `(str) → str \| null` | 获取 URL hash 参数 |
| `tools.checkPhone(phone)` | `(str) → str` | 校验联系电话，返回错误信息（空=合法） |
| `tools.checkVersion(current, need)` | `(str, str) → boolean` | 版本号比较（如 `3.0.0.6` vs `12.0.0.6`） |
| `tools.isWindows()` | `() → boolean` | 判断当前操作系统是否为 Windows |
| `tools.getBrowserInfo()` | `() → boolean \| undefined` | 判断是否为 IE9 及以下浏览器 |
| `tools.isIE8()` | `() → boolean` | 判断是否为 IE8 及以下 |
| `tools.dataURLtoBlob(dataurl)` | `(str) → Blob` | base64 转 Blob |
| `tools.downloadByBlob(pdfSrc, name)` | `(str, str)` | 根据 base64 下载 PDF 文件 |
| `tools.textSize(text)` | `(str) → {width, height}` | 获取文本像素宽高 |
| `tools.getScrollBarWidth()` | `() → number` | 获取滚动条宽度 |
| `tools.HeiKj(clas, id)` | `(str, str)` | jqGrid 操作栏靠右（有多选框） |
| `tools.HeiKjNoSel(clas, id)` | `(str, str)` | jqGrid 操作栏靠右（无多选框） |
| `tools.pdfOptions()` | `() → obj` | PDF 预览参数配置 |

### 9.8 全局配置（`config`）

```javascript
var config = {
    pageSize: 20,           // 分页默认每页条数
    pageSizeList: [20, 50, 100], // 可选每页条数
};
```

页面中 `searchData.pageSize` 默认取 `config.pageSize`。

---

## 十、注意事项

1. **公共方法优先复用**: 开发新功能前先查 `@/static/js/tools.js` 是否已有对应方法，避免重复造轮子
2. **列值空值处理**: 后端返回空值（`""`/`null`/`undefined`）时，前端展示空字符串 `""`，**不自动补 0**。**仅金额类列需要 formatter 格式化**（配置了 `degree` 的列），其他列不需要。`avalon.filters.number` 会将空值格式化为 `0.00`，金额列 formatter 必须先判空再格式化：
    ```javascript
    // ✅ 正确：仅金额列配置 formatter，先判空，空值返回 ""
    if (arr[i].degree) {
        var degree = arr[i].degree;
        obj.formatter = function(cellvalue) {
            if (cellvalue === "" || cellvalue === null || cellvalue === undefined) {
                return "";
            }
            return avalon.filters.number(cellvalue, degree);
        };
    }
    // ❌ 错误：空值被格式化为 0.00
    obj.formatter = function(cellvalue) {
        return avalon.filters.number(cellvalue, degree);
    };
    ```
3. **闭包陷阱**: 在循环中创建 formatter 时，`degree` 需要用闭包或 `let` 捕获，避免引用循环最后的值
4. **CSS 类名约定**: 组件根元素的 class 名与组件名一致（如 `.yjxxzhcx`），所有 jQuery 选择器都基于此根元素
5. **table ID 约定**: `xxx-table` + `xxx-tablePager`，确保全页唯一
6. **ajax 封装**: 统一使用全局 `ajax(method, url, params)` 函数（`@/static/js/ajax.js`），返回 Promise。**注意：`ajax` 封装只处理 HTTP 层错误（401 未登录、网络异常），不处理 `code != '0'` 的业务错误**，因此组件内必须自己写 `else { tools.info(res.msg) }` 和 `.fail(function(err){ tools.info(err) })`。标准写法：
    ```javascript
    ajax("POST", "/bjtssw/xxx/list", params).done(function(res) {
        if (res.code == '0') {
            if (!res.data) { return; }  // 返回值为空，静默退出
            // 正常处理 res.data
        } else {
            tools.info(res.msg);        // 接口报错，组件内提示
        }
    }).fail(function(err) {
        tools.info(err);                // 网络异常，组件内提示
    });
    ```
    > 项目中另有 `apiAjax`（`@/static/js/api.js`）封装了自动错误提示，但**统一约定使用 `ajax`**，错误提示由组件自行控制。
7. **提示信息**: 统一使用 `tools.info(msg)` 而非 `alert`
8. **分页工具**: `tools.getPageNo` / `tools.getPageNo2` 处理 jqGrid 分页按钮
9. **导出优先用 `tools.exform` 或 `tools.ajaxExform`**: 不要在组件内手写 form 提交逻辑
10. **接口返回值分层校验**: `code != '0'` 为接口报错，走 `else` 分支用 `tools.info(res.msg)` 提示；`code == '0'` 但 `!res.data` 为返回值为空，直接 `return` 不报错（见第 6 条标准写法）
11. **页面布局结构不可自创，必须遵循全局约定（踩坑记录）**: 全局样式（`@/static/css/common.css` + `@/static/css/app.css`）已固定了页面的绝对定位布局，新页面**必须**严格照搬「七、HTML 模板结构」，否则查询条件会被表格遮挡。三个关键点：
    - **`.pageTabs` 必须是 `.page` 的同级兄弟节点**，放在 `.page` 外面（`.work` 直接子级）。全局 `.work .pageTabs` 是 `position:absolute; top:0`，`.work` 用 `padding-top:37px` 为它让位。若误把 `.pageTabs` 塞进 `.page` 内，布局会错乱。
    - **`.select-wrapper` 是 `position:absolute`（不占文档流）**，所以其后的 `.form` 必须写 `style="padding-top: 54px"` 给绝对定位的查询条留出空间；否则 `.form`（全局 `height:100%`）会直接从顶部铺满，把查询条盖在下面。
    - **不要在页面 css 里用 flex 重写 `.page` / `.form` 的布局**（如 `display:flex` + `.form{flex:1;height:auto;padding:0}`），会破坏全局绝对定位约定，导致 `.form` 失去 `padding-top` 而遮挡查询条。页面 css 只应写微调（如输入框宽度），布局交给全局。
12. **`addJSONData` 直接传 `res.data`，不要手动拼分页对象（踩坑记录）**: 后端返回的 `res.data` 已包含 jqGrid 所需的全部分页字段（`rows`/`page`/`records`/`total`），应直接 `$("#xxx-table")[0].addJSONData(res.data)` 传入。**不要**手动提取 `rows`/`records`/`total` 再重新组装成 `{ rows, page, records, total }` 传入——手动组装时 `page` 容易传错（如始终传 `pageNo` 而非后端返回的实际页码），导致分页器页码显示异常。标准写法见 `@/src/page/案头分析/atfxtz.js:452` 和 `@/src/page/事前预警/风险报关行/fxbgh.js:101`。
