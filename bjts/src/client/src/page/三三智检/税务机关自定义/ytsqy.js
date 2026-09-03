var ytsqy = require("./ytsqy.html");
avalon.component("ytsqy", {
  template: ytsqy,
  defaults: {
    params: {},
    act: 1,
    tcode: "ytsqycx",
    swjgmc: "",
    selRows: [],
    swjgList: [
      "13300000000",
      "13301000000",
      "13302000000",
      "13303000000",
      "13304000000",
      "13305000000",
      "13306000000",
      "13307000000",
      "13308000000",
      "13309000000",
      "13310000000",
      "13311000000",
    ], // 省市级税务机关代码列表
    hasHsPermission: false, // 是否有核实处理权限
    searchData: {
      swjgdm: "",
      sbrqq: "",
      sbrqz: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    modelData: {
      id: "",
      nsrsbh: "",
      nsrmc: "",
      // yxqQ: '',
      // yxqZ: '',
      qybj: "Y",
      // fxms: ''
    },
    plData: {
      qybj: "Y",
    },
    addTitle: "",
    tableData: [],
    nsrsbhList: [],
    showNsrsbhList: false,
    activeBgIndex: 0,
    onReady: function () {
      this.initParams();
      this.initTree();
      this.initDate();
      this.createTable();
      // this.importCallBack();
    },
    initParams: function () {
      if (this.params.swjgDm) {
        this.searchData.swjgdm = this.params.swjgDm;
      } else {
        this.searchData.swjgdm = avalonRoot.user.swjgDm;
        this.swjgmc = avalonRoot.user.swjgMc;
      }
      this.hasHsPermission =
        this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
    },
    initDate: function () {
      this.searchData.sbrqq = tools.getFirstDayOfYear();
      this.searchData.sbrqz = tools.getPreviousDay();
      // 设置日期选择器的默认参数
      var today = new Date(); // 获取今天的日期
      var yesterday = new Date(today); // 创建昨天日期的对象
      yesterday.setDate(today.getDate() - 1); // 将日期设置为昨天
      // 设置最小日期（2025-01-01）和最大日期（昨天）
      var minDate = new Date(2025, 0, 1); // 注意：月份是从0开始计数的，因此1月是0
      var maxDate = yesterday;
      $(".ytsqy .datepicker.date-day").datepicker({
        dateFormat: "yy-mm-dd",
        minDate: minDate, // 最小日期不可小于2025年01月01日
        maxDate: maxDate, // 最大日期不可超过当前日期前一天
      });
      // 初始化起始日期选择器
      // $(".ytsqy .datepicker.date-day.start-date").datepicker({
      //   dateFormat: "yy-mm-dd",
      //   defaultDate: minDate, // 默认值为当年首日
      //   minDate: minDate, // 最小日期不可小于2025年01月01日
      //   maxDate: maxDate, // 最大日期不可超过当前日期前一天
      //   onSelect: function (selectedDate) {
      //     // 当选择起始日期时，更新结束日期选择器的最小日期
      //     var startDate = $(this).datepicker("getDate");
      //     var endDatePicker = $(".ytsqy .datepicker.date-day.end-date");
      //     var currentDate = new Date();
      //     var yesterdayForEndDate = new Date(currentDate);
      //     yesterdayForEndDate.setDate(currentDate.getDate() - 1);

      //     // 确保结束日期的最大值不超过昨天，并且不小于选定的起始日期
      //     endDatePicker.datepicker("option", "minDate", startDate);
      //     endDatePicker.datepicker("option", "maxDate", yesterdayForEndDate);
      //   },
      // });

      // // 初始化结束日期选择器
      // $(".ytsqy .datepicker.date-day.end-date").datepicker({
      //   dateFormat: "yy-mm-dd",
      //   defaultDate: maxDate, // 默认值为当前日期前一天
      //   minDate: minDate, // 最小日期不可小于2025年01月01日
      //   maxDate: maxDate, // 最大日期不可超过当前日期前一天
      //   beforeShow: function () {
      //     var startDatePicker = $(".ytsqy .datepicker.date-day.start-date");
      //     var startDate = startDatePicker.datepicker("getDate");

      //     if (startDate) {
      //       // 如果已选择起始日期，则设置结束日期选择器的最小日期
      //       $(this).datepicker("option", "minDate", startDate);
      //     }
      //   },
      // });
    },
    //copy bg
    createTable: function () {
      var self = this;
      var columns = [
        {
          name: "id",
          label: "主键id",
          index: "主键id",
          hidden: true,
          align: "left",
          sortable: true,
        },
        {
          name: "swjgdm",
          label: "退税税务机关代码",
          index: "swjgdm",
          width: 120,
          align: "center",
          sortable: true,
        },
        {
          name: "swjgmc",
          label: "税务机关名称",
          index: "swjgmc",
          width: 120,
          align: "center",
          sortable: true,
        },
        {
          name: "nsrsbh",
          label: "企业税号",
          index: "nsrsbh",
          width: 160,
          align: "left",
          sortable: true,
        },
        {
          name: "nsrmc",
          label: "企业名称",
          index: "nsrmc",
          width: 200,
          align: "left",
          sortable: true,
        },
        {
          name: "djxh",
          label: "登记序号",
          index: "djxh",
          width: 160,
          align: "left",
          sortable: true,
          hidden: true,
        },
        {
          name: "sbrq",
          label: "预退税业务最早申报日期",
          index: "sbrq",
          width: 160,
          align: "center",
          sortable: true,
        },
        {
          name: "sbpcs",
          label: "预退税业务申报批次数",
          index: "sbpcs",
          width: 130,
          align: "left",
          sortable: true,
        },
        {
          name: "cnt",
          label: "申报笔数",
          index: "cnt",
          width: 80,
          align: "left",
          sortable: true,
        },
        {
          name: "mylaj",
          label: "申报美元离岸价",
          index: "mylaj",
          width: 120,
          align: "right",
          formatter: function (cellvalue, options, rowObject) {
            return avalon.filters.number(cellvalue, 2);
          },
        },
        {
          name: "tse",
          label: "申报退税额",
          index: "tse",
          width: 120,
          align: "right",
          formatter: function (cellvalue, options, rowObject) {
            return avalon.filters.number(cellvalue, 2);
          },
        },
      ];
      $("#ytsqy-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: "#ytsqy-tablePager",
        shrinkToFit: false,
        autowidth: true,
        altRows: true,
        multiselect: true,
        multiselectWidth: "40",
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        width: "100%",
        height: (function () {
          return $(".ytsqy .form").height() - 60;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#ytsqy-table").jqGrid("getRowData", rowid);
          if ($(e.target).hasClass("disabled")) return false;
          if ($(e.target).hasClass("edit")) {
            let obj = {
              注销: "N",
              启用: "Y",
            };
            self.modelData = {
              id: row.id,
              nsrsbh: row.nsrsbh,
              nsrmc: row.nsrmc,
              qybj: obj[row.qybj] ? obj[row.qybj] : "Y",
            };
            var text = avalonRoot.user.swjgDm == row.swjgdm ? "编辑" : "查看";
            self.showModel(text);
          } else if ($(e.target).hasClass("del")) {
            self.delHandler(row.id);
          } else if (e.target.nodeName == "TD") {
            $(e.target)
              .parent()
              .addClass("ui-state-highlight")
              .siblings()
              .removeClass("ui-state-highlight");
            return false;
          } else {
            return true;
          }
        },
        onSortCol: function (index, iCol, sortorder) {
          var orderSql = index + " " + sortorder;
          self.searchData.orderSql = orderSql;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "ytsqy-table");
          self.search(pageNo);
        },
        onSelectRow: function (rowid, status) {
          var index = self.selRows.indexOf(rowid);
          if (status) {
            self.selRows.push(rowid);
          } else {
            self.selRows.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          if (status) {
            self.selRows = JSON.parse(JSON.stringify(rowids));
          } else {
            self.selRows = [];
          }
        },
      });
      $("#ytsqy-table").jqGrid("setFrozenColumns");
      tools.HeiKj("ytsqy", "ytsqy-table");
      // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
      self.search(1);
    },
    // 初始化多选框，注销或录入税务机关不是当前用户所属税务机关的禁止勾选
    checkboxInit: function (data) {
      var self = this;
      setTimeout(function () {
        if (data) {
          for (var i = 0; i < data.length; i++) {
            var curRow = data[i];
            if (curRow.qybj == "N" || curRow.swjgdm != avalonRoot.user.swjgDm) {
              $("#jqg_ytsqy-table_" + curRow.id).attr("disabled", true);
              $("#jqg_ytsqy-table_" + curRow.id).attr("checked", false);
            }
          }
        }
      }, 100);
    },
    showModel: function (title) {
      this.addTitle = title;
      $(".model").show();
      $(".ytsqy .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".ytsqy .add-page-model").hide();
      this.modelData = {
        id: "",
        nsrsbh: "",
        nsrmc: "",
        qybj: "Y",
      };
      this.nsrsbhList = [];
      this.showNsrsbhList = false;
      this.activeBgIndex = 0;
    },
    showPlModel: function () {
      this.addTitle = "批量操作";
      $(".model").show();
      $(".ytsqy .page-model-end").show();
    },
    hidePlModel: function () {
      $(".model").hide();
      $(".ytsqy .page-model-end").hide();
      this.plData = {
        qybj: "Y",
      };
    },
    search: function (pageNo) {
      var self = this;
      const startDate = new Date(self.searchData.sbrqq);
      const endDate = new Date(self.searchData.sbrqz);
      if (startDate >= endDate) {
        tools.info("申报日期截止日期必须大于起始日期");
        return false;
    }
    // 计算两个日期之间的差值，转换为年
    const diffTime = Math.abs(endDate - startDate);
    const diffYears = diffTime / (1000 * 60 * 60 * 24 * 365);
    // 判断是否相差不超过一年
    if (diffYears > 1) {
        tools.info("申报日期范围相差不能超过一年");
        return false;
    }
      this.searchData.pageSize = $(".ui-pg-selbox", $(".ytsqy")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      $("#ytsqy-table").jqGrid("clearGridData");
      ajax("POST", "/cxfw/sdqy/list/ytsqy", params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data.rows;
            $("#ytsqy-table")[0].addJSONData(res.data);
            tools.HeiKj("ytsqy", "ytsqy-table");
            // self.checkboxInit(res.data && res.data.rows);
            self.closeHyper();
            self.selRows = [];
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    initTree: function () {
      var self = this;
      var setting = {
        callback: {
          onClick: function (e, id, node) {
            self.searchData.swjgdm = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            return;
          },
          onDblClick: function (e, id, node) {
            self.searchData.swjgdm = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            return;
          },
        },
        data: { key: { children: "item", name: "text" } },
      };
      tools
        .getCachedSwjg(avalonRoot, ajax)
        .done(function (data) {
          $.fn.zTree.init($(".ytsqy .ytsqySwjgTree"), setting, data);
          var treeObj = $.fn.zTree.getZTreeObj("ytsqySwjgTree"); //ztree树的ID
          var node = treeObj.getNodeByParam("id", self.searchData.swjgdm); //根据ID找到该节点
          self.swjgmc = node.text;
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showHyper: function () {
      $(".ytsqy .select-sub").toggle();
      $(".ytsqy .select-wrapper .icon").toggleClass("active");
      if (
        $(".ytsqy .select-wrapper .icon").attr("title").slice(0, 2) === "展开"
      ) {
        $(".ytsqy .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".ytsqy .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".ytsqy .select-sub").hide();
      $(".ytsqy .select-wrapper .icon").removeClass("active");
      $(".ytsqy .select-wrapper .icon").attr("title", "展开查询条件");
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".ytsqy").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".ytsqy").off("click");
    },
    exform: function () {
      var self = this;
      if ($("#ytsqy-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData);
      tools.exform(params, "/cxfw/sdqy/list/ytsqy/export");
    },
    // exformModel: function () {
    //   tools.exform({}, "/cxfw/sdqy/template");
    // },
    reset: function () {
      this.searchData = {
        swjgdm: avalonRoot.user.swjgDm,
        sbrqq: "",
        sbrqz: "",
        orderSql: "",
        pageSize: config.pageSize,
      };
      this.swjgmc = avalonRoot.user.swjgMc;
      this.searchData.sbrqq = tools.getFirstDayOfYear();
      this.searchData.sbrqz = tools.getPreviousDay();
    },
    filDate: function (e) {
      var date = e.target.value;
      var res = tools.DateCheup(date);
      if (res === false) {
        tools.info("日期输入错误");
        res = "";
      }
      e.target.value = res;

      return;
    },
    saveModel: function () {
      var self = this;
      var rules = [
        { name: "nsrsbh", message: "企业识别号不能为空！" },
        { name: "qybj", message: "启用标志不能为空！" },
      ];
      for (var i = 0; i < rules.length; i++) {
        if (this.modelData[rules[i].name] == "") {
          tools.info(rules[i].message);
          return;
        }
      }
      var params = tools.clone(this.modelData);
      var id = params.id;
      var qybj = params.qybj;
      if (!params.id) {
        delete params.id;
      }
      var url = "";
      if (self.addTitle == "新增") {
        url = "/cxfw/sdqy/add";
      } else if (self.addTitle == "编辑") {
        url = "/cxfw/sdqy/update";
        params = {
          ids: [id],
          qybj: qybj,
        };
      }
      ajax("POST", url, params)
        .done(function (res) {
          if (res.code == "0") {
            tools.info("保存成功！");
            self.hideModel();
            self.search(1);
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    delHandler: function (id) {
      this.showPlModel();
    },
    savePl() {
      var self = this;
      if (this.selRows.length <= 0) {
        tools.info("请先选择要操作的项！");
        return;
      }
      ajax("POST", "/cxfw/sdqy/update", {
        ids: this.selRows,
        qybj: self.plData.qybj,
      })
        .done(function (res) {
          if (res.code == "0") {
            tools.info("注销成功！");
            self.search(1);
            self.hidePlModel();
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showImportModel: function () {
      $(".model").show();
      $(".ytsqy .import-page-model").show();
    },
    hideImportModel: function () {
      $(".model").hide();
      $(".ytsqy .import-page-model").hide();
    },
    importCallBack: function () {
      var self = this;
      $("#ytsqyFileupload")
        .fileupload({
          dataType: "json",
          acceptFileTypes: /(xls|xlsx)$/i,
          maxFileSize: 4000000, // 限制大小4M
          done: function (e, data) {
            if (data.result.code == "0") {
              tools.info("导入成功!");
              self.search(1);
            } else {
              tools.info(data.result.msg);
            }
          },
        })
        .on("fileuploadadd", function (e, data) {
          $(".app-loading").show();
        })
        .on("fileuploadalways", function (e, data) {
          $(".app-loading").hide();
        });
    },
    // 模糊查询税号，获取税号列表
    inpChangeNsrsbh: function (key) {
      this[key].nsrmc = "";
      this[key].nsrsbh = this[key].nsrsbh.trim();
      var nsrsbh = this[key].nsrsbh;
      if (nsrsbh.length < 4) {
        return;
      }
      var params = {
        qybs: nsrsbh,
      };
      var self = this;
      ajax("POST", "/sszj/jkmpd/nsrxx/list", params, false, false, true)
        .done(function (res) {
          if (res.code == "0") {
            self.nsrsbhList = res.data;
            self.showNsrsbh();
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    // 显示纳税人识别号弹框
    showNsrsbh: function () {
      var list = this.nsrsbhList;
      if (list && list.length > 0) {
        this.showNsrsbhList = true;
      }
    },
    // 隐藏纳税人识别号弹框
    hideNsrsbh: function (e) {
      if ($(e.target).parent().hasClass("nsrsbh-group")) return;
      this.showNsrsbhList = false;
    },
    nsrsbhEnterSearch: function (e) {
      e.target.blur();
      this.showNsrsbhList = false;
    },
    keydown: function (e, id) {
      var index = this.activeBgIndex;
      var len = this.nsrsbhList.length;
      //38:上  40:下
      if (e.keyCode == 38) {
        if (index > 0) {
          index--;
        } else {
          index = len - 1;
        }
        this.stopDefault(e);
      } else if (e.keyCode == 40) {
        if (index < len - 1) {
          index++;
        } else {
          index = 0;
        }
        this.stopDefault(e);
      }
      this.activeBgIndex = index;
      var pHeight = $("#" + id + " p:first").height(); // p元素高度
      if (index > 2) {
        $("#" + id).scrollTop(pHeight * (index - 3) + 9);
      } else {
        $("#" + id).scrollTop(0);
      }
      if (e.keyCode == 13) {
        // enter
        var item = {};
        item = this.nsrsbhList[index];
        if (item) {
          this.modelData.nsrsbh = item.nsrsbh;
          this.modelData.nsrmc = item.nsrmc;
        }
      }
    },
    //阻止事件执行
    stopDefault: function (event) {
      //阻止默认浏览器动作(W3C)
      if (event && event.preventDefault) {
        //火狐的 事件是传进来的e
        event.preventDefault();
      }
      //IE中阻止函数器默认动作的方式
      else {
        //ie 用的是默认的event
        event.returnValue = false;
      }
    },
    setNsrsbh: function (item, key) {
      this[key].nsrsbh = item.nsrsbh;
      this[key].nsrmc = item.nsrmc;
      this.showNsrsbhList = false;
    },
  },
});
