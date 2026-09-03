var atfxzycx = require("./atfxzycx.html");

avalon.component('atfxzycx', {
  template: atfxzycx,
  defaults: {
    params: {
    },
    searchData: {
    },
    dbArr: [],
    djxh: '',
    activeDb: null,
    curNode: {},
    tableData: [],
    colModel: [],
    colNames: [],
    fList: [],
    total: 0,
    pageSize: 20,
    pageNo: 1,
    showFilterRow: false,
    filterValues: {},
    // 树结构数据
    treeData: [],
    // 默认选中的节点
    checkedKeys: [],
    orderSql: '',
    onInit(e) {
      components.atfxzycx = e.vmodel;
    },
    // 在 atfxzycx.js 的 defaults 中添加以下方法
    onReady: function () {
      var self = this;
      // 监听窗口大小变化，重新调整表格大小
      $(window).on('resize.atfxzycx', function () {
        self.changeH()
      });
    },
    init() {
      var self = this;
      // 初始化树结构
      self.initTree();
      // 初始化表格
      self.initTable();
    },
    onDispose: function () {
      $(window).off('resize.atfxzycx');
    },
    exportList: function () {
      var self = this;
      if ($("#atfxzycx-grid").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      let selParamList = []
      let params = {
        tableName: self.curNode.tableName,
        djxh: self.djxh,

      }
      for (var key in self.filterValues) {
        selParamList.push({
          selKey: key,
          selValue: self.filterValues[key]
        })
      }
      params.selParamList = selParamList
      params.orderSql = self.orderSql
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/dynamic/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form); //将表单放置在web中
      form.append(input1);
      form.submit();
      form.remove();
    },
    changeH() {
      if ($.isFunction($("#atfxzycx-grid").jqGrid)) {
        var containerHeight = $('.grid-container').height();
        var pagerHeight = $('#atfxzycx-pager').outerHeight() || 30;
        let h = this.showFilterRow ? 70 : 40
        var tableHeight = containerHeight - pagerHeight - h;

        if (tableHeight > 0) {
          $("#atfxzycx-grid").jqGrid('setGridHeight', tableHeight);
        }
        // 始终设置网格宽度以确保水平滚动
        $("#atfxzycx-grid").jqGrid('setGridWidth', $('.grid-container').width(), false);

        // 确保容器有正确的滚动样式
        $("#atfxzycx-grid").closest(".ui-jqgrid-view").css("overflow-x", "auto");
        $("#atfxzycx-grid").closest(".ui-jqgrid-bdiv").css("overflow-x", "auto");
      }
    },
    initTree: function () {
      var self = this;
      var setting = {
        view: {
          showIcon: false,
        },
        callback: {
          onClick: function (e, id, node) {
            var treeObj = $.fn.zTree.getZTreeObj('atfxzycxTree');
            // 如果是父节点，只展开/折叠
            if (node.isParent) {
              treeObj.expandNode(node);
              return;
            }
            // 如果是叶子节点，选中它并取消其他节点的选中状态
            treeObj.selectNode(node);
            self.activeDb = null
            // 更新选中的节点信息
            self.updateSelectedNode(node);
            return;
          }
        },
        data: { key: { children: "items", name: "tableCname" } }
      };
      ajax("POST", "/cxfw/atfx/query/tables").done(function (res) {
        if (res.code == '0') {
          let arr = []
          let dbArr = []
          for (let i in res.data) {
            if (res.data[i].tableName !== 'M_0_QLC') {
              arr.push(res.data[i])
            } else {
              dbArr.push(res.data[i])
            }
          }
          self.dbArr = dbArr
          console.log(self.dbArr)
          let info = arr;
          $.fn.zTree.init($("#atfxzycxTree"), setting, info);
          var treeObj = $.fn.zTree.getZTreeObj('atfxzycxTree');//ztree树的ID
          var node = treeObj.getNodeByParam("zbbh", self.searchData.zbbh);//根据ID找到该节点
          treeObj.selectNode(node)
          var nodes = treeObj.getNodes();
          if (nodes.length > 0) {
            treeObj.expandNode(nodes[0], true, false, false);
            // 自动选中第一个叶子节点
            var firstLeafNode = self.findFirstLeafNode(nodes[0]);
            if (firstLeafNode) {
              treeObj.selectNode(firstLeafNode);
              self.updateSelectedNode(firstLeafNode);
            }
          }
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    },
    searchDb(item) {
      this.activeDb = item.tableName
      var treeObj = $.fn.zTree.getZTreeObj('atfxzycxTree');
      var nodes = treeObj.getSelectedNodes(); // 获取所有选中的节点
      for (var i = 0; i < nodes.length; i++) {
        treeObj.cancelSelectedNode(nodes[i]); // 取消每个节点的选中状态
      }
      let selectedNode = {
        isParent: false,
        fieldList: item.fieldList,
        tableName: item.tableName,
        tableCname: item.tableCname,
        zbbh: item.zbbh,
        isParent: false
      }
      this.updateSelectedNode(selectedNode)
    },
    updateSelectedNode: function (selectedNode) {
      console.log(selectedNode, 'selectedNode')
      var self = this;
      self.filterValues = {}
      // 清空现有列
      self.colNames = [];
      self.colModel = [];
      let list = selectedNode.fieldList
      this.curNode = selectedNode
      this.fList = list
      // 只处理叶子节点
      if (!selectedNode.isParent) {

        for (let i in list) {
          let item = list[i]
          self.colNames.push(item.fieldCname);
          let colConfig = {
            name: item.fieldName,
            index: item.fieldName,
            label: item.fieldCname,
            // width: item.showLength,
            sortable: selectedNode.tableName != 'ATFX_JC_YS_NSRJCXX',
            dataType: item.dataType,
            align: self.getAlign(item.showFormat, item.dataType),
          };
          if (item.showLength && item.showLength > 0) {
            colConfig.width = item.showLength
          }
          if (item.showFormat == '1') {
            colConfig.formatter = function (cellVal, op, row) {
              if (cellVal === undefined || cellVal === null || cellVal === '') {
                return ''
              }
              if (item.dataType == '5') {
                if (cellVal) cellVal = avalon.filters.number(cellVal,2);
              } else {
                if (cellVal) cellVal = self.formatAmount(cellVal);
              }
              return cellVal
            }
          } else if (item.showFormat == '3') {
            colConfig.formatter = function (cellVal, op, row) {
              if (cellVal === undefined || cellVal === null || cellVal === '') {
                return ''
              }
              cellVal = cellVal ? cellVal : 0
              return cellVal + '%'
            }
          }
          self.colModel.push(colConfig);
        }
        self.tableData = {}
        self.forceRebuildTable();
        // self.searchInfo(1)
      }
    },
    formatAmount(amount, maxFractionDigits = 8) {
      // 处理无效值
      if (amount === null || amount === undefined || isNaN(Number(amount))) {
        return "-"; // 或返回空字符串，根据业务需求调整
      }

      // 转换为数字
      const num = Number(amount);

      // 配置格式化选项：千分位 + 最小2位小数 + 最大maxFractionDigits位小数
      const options = {
        useGrouping: true, // 千分位分隔
        minimumFractionDigits: 0, // 最小保留0位小数（不足补零）
        maximumFractionDigits: maxFractionDigits, // 最大保留位数（四舍五入）
      };

      // 用toLocaleString格式化（支持负数、零等边缘情况）
      return num.toLocaleString("zh-CN", options);
    },
    searchInfo(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxzycx')).val();
      self.pageSize = pageSize ? pageSize : 20
      let selParamList = []
      if (!self.curNode.tableName) {
        tools.info('请选择数据表!')
        return
      }
      let params = {
        tableName: self.curNode.tableName,
        djxh: self.djxh,

      }
      for (var key in self.filterValues) {
        // self.filterValues[key] = '';
        selParamList.push({
          selKey: key,
          selValue: self.filterValues[key]
        })
      }
      params.selParamList = selParamList
      params.orderSql = this.orderSql
      params.pageNo = pageNo
      params.pageSize = $(".ui-pg-selbox", $('.atfxzycx')).val();
      ajax("POST", "/cxfw/atfx/query/table/data", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };

          // 重新构建表格
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxzycx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          // 重置分页信息
          self.tableData = [];
          // 重新构建表格
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        // 重新构建表格
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    forceRebuildTable: function () {
      this.orderSql = ''
      var self = this;
      // 销毁现有的表格
      if ($("#atfxzycx-grid").hasClass("ui-jqgrid-btable")) {
        $("#atfxzycx-grid").jqGrid('GridUnload');
      }
      // 获取 grid-container 的高度来计算表格高度
      var containerHeight = $('.grid-container').height();
      var pagerHeight = $('#atfxzycx-pager').outerHeight() || 30;
      var tableHeight = containerHeight - pagerHeight - 55; // 减去一些边距
      // 确保DOM更新后再渲染
      setTimeout(function () {
        $("#atfxzycx-grid").jqGrid({
          // data: self.tableData,
          colNames: self.colNames,
          colModel: self.colModel,
          datatype: "local",
          gridview: true,
          viewrecords: true,
          rownumbers: true,
          rownumWidth: 60,
          pager: '#atfxzycx-pager',
          shrinkToFit: false,
          width: "100%",
          autowidth: true,
          forceFit: true,
          altRows: true,
          altclass: "altclasscss",
          lastsort: 1,
          height: tableHeight > 0 ? tableHeight : 'auto',
          rowNum: self.pageSize,
          rowList: [20, 50, 100, 500],
          loadComplete: function () {
            setTimeout(function () {
              $("#atfxzycx-grid")[0].addJSONData(self.tableData)
            }, 0);
            // 加载完成后添加筛选行
            if (self.showFilterRow) {
              setTimeout(function () {
                if (self.showFilterRow && $("#filter-row").length === 0) {
                  self.addCustomFilterRow();

                }
              }, 0);
            }
            self.changeH()

          },
          onSortCol: function (index, iCol, sortorder) {
            var orderSql = index + " " + sortorder;
            self.orderSql = orderSql;
            self.searchInfo(1,true);
            return;
          },
          onPaging: function (pgButton) {
            self.pageNo = tools.getPageNo2(pgButton, "atfxzycx-pager");
            self.searchInfo(self.pageNo, true);
          }
        });
        // 确保表格容器始终具有水平滚动样式
        $("#atfxzycx-grid").css({
          "min-height": "1px"
        });
        $("#atfxzycx-grid").closest(".ui-jqgrid-view").css({
          "overflow-x": "auto",
          "overflow-y": "hidden"
        });

        // 为表格的tbody区域也设置滚动样式
        $("#atfxzycx-grid").closest(".ui-jqgrid-bdiv").css("overflow-x", "auto");

      }, 200);
    },

    rebuildTable: function () {
      var self = this;

      // 销毁现有的表格
      if ($("#atfxzycx-grid").hasClass("ui-jqgrid")) {
        $("#atfxzycx-grid").jqGrid('GridUnload');
      }

      // 重新初始化表格
      self.initTable();
    },



    // 查找第一个叶子节点
    findFirstLeafNode: function(node) {
      if (!node.isParent && !node.items) {
        return node;
      }
      if (node.items && node.items.length > 0) {
        return this.findFirstLeafNode(node.items[0]);
      }
      return null;
    },
    // 更新关联节点（父子节点联动）
    updateRelatedNodes: function (nodes, nodeId) {
      var self = this;

      // 查找被点击的节点
      var targetNode = self.findNodeById(nodes, nodeId);
      if (!targetNode) return;

      // 如果是父节点，同步子节点状态
      if (targetNode.children && targetNode.children.length > 0) {
        for (var i = 0; i < targetNode.children.length; i++) {
          targetNode.children[i].checked = targetNode.checked;
        }
      }

      // 更新所有父节点的选中状态
      self.updateAllParentCheckedState(nodes);
    },

    // 查找节点
    findNodeById: function (nodes, nodeId) {
      var self = this;
      for (var i = 0; i < nodes.length; i++) {
        var node = nodes[i];
        if (node.id === nodeId) {
          return node;
        }
        if (node.children && node.children.length > 0) {
          var found = self.findNodeById(node.children, nodeId);
          if (found) return found;
        }
      }
      return null;
    },



    initTable: function () {
      var self = this;

      // 根据选中的节点构建列信息
      self.buildColumns();

      let list = self.fList
      // 初始化过滤值对象
      for (let i in list) {
        let item = list[i]
        self.colNames.push(item.fieldCname);
        let colConfig = {
          name: item.fieldName,
          index: item.fieldName,
          label: item.fieldCname,
          // width: item.showLength,
          sortable: false,
          dataType: item.dataType,
          align: self.getAlign(item.showFormat),
        };
        if (item.showFormat == '1') {
          colConfig.formatter = function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        } else if (item.showFormat == '3') {
          colConfig.formatter = function (cellVal, op, row) {
            cellVal = cellVal ? cellVal : 0
            return cellVal + '%'
          }
        }
        self.colModel.push(colConfig);
      }

      // 确保在每次初始化前都销毁之前的表格
      if ($("#atfxzycx-grid").hasClass("ui-jqgrid")) {
        $("#atfxzycx-grid").jqGrid('GridUnload');
      }

      // 初始化jqGrid
      self.renderTable();
    },

    // 根据选中节点构建列信息
    buildColumns: function () {
      var self = this;

      // 清空现有列
      self.colNames = [];
      self.colModel = [];

      // 遍历树结构，构建选中列
      self.buildColumnsFromTree(self.treeData);
    },

    // 递归构建列信息
    buildColumnsFromTree: function (nodes) {
      var self = this;

      for (var i = 0; i < nodes.length; i++) {
        var node = nodes[i];

        // 如果是叶子节点且被选中
        if (!node.children && node.checked) {
          self.colNames.push(node.name);

          var colConfig = {
            name: node.id,
            index: node.id,
            width: 500,
            sortable: true
          };
          self.colModel.push(colConfig);
        }

        // 如果有子节点，递归处理
        if (node.children && node.children.length > 0) {
          self.buildColumnsFromTree(node.children);
        }
      }
    },
    renderTable: function () {
      var self = this;
      // 销毁已存在的表格
      if ($("#atfxzycx-grid").hasClass("ui-jqgrid")) {
        $("#atfxzycx-grid").jqGrid('GridUnload');
      }

      // 获取 grid-container 的高度来计算表格高度
      var containerHeight = $('.grid-container').height();
      var pagerHeight = $('#atfxzycx-pager').outerHeight() || 30;
      var tableHeight = containerHeight - pagerHeight - 50; // 减去一些边距

      $("#atfxzycx-grid").jqGrid({
        // data: self.tableData,
        colNames: self.colNames,
        colModel: self.colModel,
        datatype: "local",
        gridview: true,
        viewrecords: true,
        rownumbers: true,
        pager: '#atfxzycx-pager',
        shrinkToFit: true,
        width: "100%",
        autowidth: true,
        forceFit: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        height: tableHeight > 0 ? tableHeight : 'auto',
        rowNum: self.pageSize,
        rowList: [20, 50, 100, 500],
        loadComplete: function () {

          // 加载完成后添加筛选行（只在需要时添加一次）
          if (self.showFilterRow) {
            // 延期执行，确保DOM完全加载
            setTimeout(function () {
              if (self.showFilterRow && $("#filter-row").length === 0) {
                self.addCustomFilterRow();
              }
            }, 0);
          }

          setTimeout(function () {
            $("#atfxzycx-grid")[0].addJSONData(self.tableData)
          }, 0);
        },
        onSortCol: function (index, iCol, sortorder) {
          var orderSql = index + " " + sortorder;
          self.orderSql = orderSql;
          self.searchInfo(1, true);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo2(pgButton, "atfxzycx-pager");
          self.searchInfo(pageNo, true);
        }
      });


    },

    toggleFilterRow: function () {
      var self = this;
      self.showFilterRow = !self.showFilterRow;

      if (self.showFilterRow) {
        self.addCustomFilterRow();
      } else {
        for (var key in self.filterValues) {
          self.filterValues[key] = '';
        }
        self.removeCustomFilterRow();
      }
      setTimeout(() => {
        self.changeH()

      }, 100)
    },

    addCustomFilterRow: function () {
      var self = this;
      var grid = $("#atfxzycx-grid");

      // 检查是否已经存在筛选行，避免重复添加
      if ($("#filter-row").length > 0) {
        return;
      }

      var toolbar = $("<tr id='filter-row'></tr>");

      // 添加空的序号列
      toolbar.append("<th></th>");
      console.log(self.colModel, 99)
      // 为每一列添加输入框（基于当前表格的列）
      for (var i = 0; i < self.colModel.length; i++) {
        var cm = self.colModel[i];
        var input;

        // 根据dataType决定使用哪种输入控件
        if (cm.dataType == '3') {
          // 日期类型字段，创建日期选择框
          input = $("<input type='text' class='filter-input date-filter datepicker' placeholder='选择日期...' readonly />");
          input.attr("data-column", cm.name);
          input.val(self.filterValues[cm.name] || '');

          // 绑定日期选择事件
          input.on('change', function () {
            var $this = $(this);
            var column = $(this).attr("data-column");
            var value = $(this).val();
            self.filterValues[column] = value;
            // self.applyFilter();
          });
        } else {
          // 其他类型的字段，保持原来的文本输入框
          input = $("<input type='text' class='filter-input' placeholder='搜索...' />");
          input.attr("data-column", cm.name);
          input.val(self.filterValues[cm.name] || '');
          // 绑定输入事件，使用防抖处理
          input.on('keyup', self.debounce(function () {
            var column = $(this).attr("data-column");
            var value = $(this).val();
            self.filterValues[column] = value;
            // self.applyFilter();
          }, 300));
        }


        var th = $("<th></th>").append(input);
        toolbar.append(th);

        self.initDatepicker()
      }

      // 添加到表头
      grid.closest(".ui-jqgrid-view")
        .find(".ui-jqgrid-hbox")
        .find(".ui-jqgrid-htable")
        .find("thead")
        .append(toolbar);
    },
    initDatepicker() {
      setTimeout(() => {
        var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2, endDate: new Date(), };
        // 初始化日期控件
        $('.atfxzycx .datepicker').datetimepicker(options);
      }, 100)
    },
    removeCustomFilterRow: function () {
      $("#filter-row").remove();
    },

    // 防抖函数，避免频繁触发筛选
    debounce: function (func, wait) {
      let timeout;
      return function executedFunction(...args) {
        const later = () => {
          clearTimeout(timeout);
          func.apply(this, args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
      };
    },

    applyFilter: function () {
      var self = this;
      var grid = $("#atfxzycx-grid");
      // 构建过滤条件
      var rules = [];
      for (var key in self.filterValues) {
        if (self.filterValues[key] && self.filterValues[key].trim() !== '') {
          rules.push({
            field: key,
            op: 'cn',
            data: self.filterValues[key]
          });
        }
      }

      if (rules.length > 0) {
        var postData = grid.jqGrid('getGridParam', 'postData');
        $.extend(postData, {
          filters: JSON.stringify({
            groupOp: "AND",
            rules: rules
          })
        });
        grid.jqGrid('setGridParam', { search: true, postData: postData });
      } else {
        grid.jqGrid('setGridParam', { search: false });
      }

      grid.trigger("reloadGrid", [{ page: 1 }]);
    },
    getAlign(e, dataType) {
      if (e == '1' || e == '3') {
        return 'right'
      } else if (e == '2') {
        return 'center'
      } else {
        if (dataType == '3') {
          return 'center'
        } else {
          return 'left'
        }
      }
    },
    // refreshTable: function () {
    //   var self = this;
    //   let params = {
    //     page: 1,
    //     rows: self.pageSize,
    //     sort: self.sortName,
    //     order: self.sortOrder,
    //     ...self.filterValues
    //   }
    //   // 重置筛选条件
    //   for (var key in self.filterValues) {
    //     self.filterValues[key] = '';
    //   }
    //   // 重新渲染筛选行
    //   if (self.showFilterRow) {
    //     self.removeCustomFilterRow();
    //     // 延迟执行，确保表格已重新渲染
    //     setTimeout(function () {
    //       self.addCustomFilterRow();
    //     }, 100);
    //   }
    //   // 刷新表格
    //   self.initTable(); // 重新初始化而不是仅仅渲染
    // }
  }
});