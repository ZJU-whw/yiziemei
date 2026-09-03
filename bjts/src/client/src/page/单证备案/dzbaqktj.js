var dzbaqktj = require("./dzbaqktj.html");
avalon.component('dzbaqktj', {
  template: dzbaqktj,
  defaults: {
    swjgmc: "",
    tableData: {},
    onReady: function () {
      this.initHeight();
      this.createTable();
    },
    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        $("#dzbaqktj-table").jqGrid('setGridHeight', $(".dzbaqktj .form").height() - 40);
      })
    },
    createTable: function () {
      var self = this;
      var columns = [
        { name: "district", label: "地区", index: "district", width: 100, align: "center", sortable: false },
        { name: "ckqyhs", label: "出口企业户数", index: "ckqyhs", width: 100, align: "right", sortable: false },
        { name: "djhs", label: "数字化备案户数", index: "djhs", width: 100, align: "right", sortable: false },
        { name: "ybaSbpc", label: "已备案申报批次", index: "ybaSbpc", width: 100, align: "right", sortable: false },
        { name: "yhcYwbs", label: "已核查业务笔数", index: "yhcYwbs", width: 100, align: "right", sortable: false }
      ];
      $("#dzbaqktj-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        width: "100%",
        // multiselect: true,
        // multiselectWidth:"30",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".dzbaqktj .form").height() - 40;
        })(),
        beforeSelectRow: function (rowid, e) {
          return;
        }
      });
      this.search()
    },
    search: function () {
      var self = this;
      $("#dzbaqktj-table").jqGrid('clearGridData')
      ajax("POST", "/dzba/inspect/stat/district/list", {}).done(function (res) {
        if (res.code == '0') {
          $("#dzbaqktj-table").resetSelection();
          $("#dzbaqktj-table")[0].addJSONData(res.data);
          self.tableData = res.data;
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    },
    exform: function () {
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/dzba/export/inspect/stat/district");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify({}));
      $("body").append(form); //将表单放置在web中
      form.append(input1);
      form.submit();
      form.remove();
    },
  }
});