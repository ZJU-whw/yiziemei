var fxbgh = require("./fxbgh.html");
require("./fxbgh.css");
avalon.component("fxbgh", {
  template: fxbgh,
  defaults: {
    params: {},
    dqList: [
      "安徽", "北京", "重庆", "大连", "福建", "甘肃", "广东", "广西",
      "贵州", "海南", "河北", "河南", "黑龙江", "湖北", "湖南", "吉林",
      "江苏", "江西", "辽宁", "内蒙古", "宁波", "宁夏", "青岛", "青海",
      "厦门", "山东", "山西", "陕西", "上海", "深圳", "四川", "天津",
      "西藏", "新疆", "云南", "浙江"
    ],
    searchData: {
      bghmc: "",
      bghdq: "",
      drnyBegin: "",
      drnyEnd: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    onInit: function (e) {
      components.fxbgh = e.vmodel;
    },
    onReady: function () {
      var self = this;
      self.createTable();
      $(".fxbgh .datepicker.date-month").datetimepicker({
        language: "zh-CN",
        format: "yyyymm",
        weekStart: 1,
        autoclose: 1,
        clearBtn: true,
        todayHighlight: 1,
        startView: 3,
        minView: 3,
        forceParse: 0,
      });
      $(".fxbgh .datepicker.date-month.begin").on("changeDate clearDate", function () {
        self.searchData.drnyBegin = this.value;
      });
      $(".fxbgh .datepicker.date-month.end").on("changeDate clearDate", function () {
        self.searchData.drnyEnd = this.value;
      });
    },
    createTable: function () {
      var self = this;
      var colModel = [
        { name: "id", label: "id", index: "id", hidden: true },
        { name: "bghmc", label: "风险报关行名称", index: "bghmc", width: 280, align: "left", sortable: false },
        { name: "bghdq", label: "报关行所在地", index: "bghdq", width: 180, align: "center", sortable: false },
        { name: "drny", label: "数据导入月份", index: "drny", width: 120, align: "center", sortable: false },
        { name: "yxbz", label: "有效标志", index: "yxbz", width: 100, align: "center", sortable: false }
      ];
      $("#fxbgh-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: colModel,
        viewrecords: true,
        rownumbers: true,
        pager: "#fxbgh-tablePager",
        shrinkToFit: false,
        width: "100%",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".fxbgh .form").height() - 70;
        })(),
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "fxbgh-table");
          self.search(pageNo);
        }
      });
    },
    normalSearch: function () {
      this.searchData.orderSql = "";
      $(".s-ico").hide();
      this.search(1);
    },
    search: function (pageNo) {
      var self = this;
      if (self.searchData.drnyBegin && self.searchData.drnyEnd) {
        var valid = tools.checkDate(self.searchData.drnyBegin, self.searchData.drnyEnd);
        if (!valid) {
          tools.info("数据导入月份截止时间必须大于起始时间");
          return false;
        }
      }
      var pageSize = $(".ui-pg-selbox", $(".fxbgh")).val() || config.pageSize;
      self.searchData.pageSize = pageSize;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      params.pageSize = pageSize;
      $("#fxbgh-table").jqGrid("clearGridData");
      ajax("POST", "/bjtssw/yj/fxbgh", params)
        .done(function (res) {
          if (res.code == "0") {
            $("#fxbgh-table")[0].addJSONData(res.data);
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    exform: function () {
      var self = this;
      if ($("#fxbgh-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData);
      delete params.pageNo;
      delete params.pageSize;
      delete params.orderSql;
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/bjtssw/yj/fxbgh/export");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    reset: function () {
      this.searchData = {
        bghmc: "",
        bghdq: "",
        drnyBegin: "",
        drnyEnd: "",
        orderSql: "",
        pageSize: config.pageSize,
      };
      $(".fxbgh .datepicker.date-month").datetimepicker("update", "");
    }
  }
});
