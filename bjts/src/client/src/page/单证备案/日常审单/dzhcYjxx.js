var dzhcYjxx = require("./dzhcYjxx.html");

avalon.component('dzhcYjxx', {
  template: dzhcYjxx,
  defaults: {
    // 父组件传参
    templateName: 'page-model-init-yjxx',

    searchData: {
      id: '',
      pageSize: 20,
      pageNo: 1,
      orderSql: '',
    },
    curRow: {},

    onInit: function (e) {
      avalonRoot[this.templateName + '-yjxx'] = e.vmodel;
    },
    onReady: function () {
      this.createTable();
    },

    initParam: function (row) {
      this.searchData.id = row.id;
      this.search(1);
    },

    createTable: function () {
      var self = this;
      var columns = [
        { name: "yjcode", label: "预警代码", index: "yjcode", width: 80, align: "center", sortable: false },
        { name: "zbcode", label: "预警指标", index: "zbcode", width: 160, sortable: false },
        { name: "yjObject", label: "预警对象值", index: "yjObject", width: 100, sortable: false },
        {
          name: "yjCount", label: "预警笔数", index: "yjCount", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "yjAmt", label: "预警金额", index: "yjAmt", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "yjTax", label: "预警税额", index: "yjTax", width: 70, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        { name: "yjRecord", label: "关联号", index: "yjRecord", width: 120, sortable: false },
        { name: "yjMsg", label: "预警描述", index: "yjMsg", width: 302, align: "centere", sortable: false },
      ];
      $("#"+self.templateName).jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: true,
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        height: 400,
        pager: '#'+self.templateName+'Pager',
        autowidth: true,
        rowNum: 20,
        rowList: [20, 50, 100, 500],
        beforeSelectRow: function (rowid, e) {
          return true;
        },
        onSortCol: function (index, iCol, sortorder) {
          self.searchData.orderSql = index + ' ' + sortorder;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, self.templateName);
          self.search(pageNo);
        },
      })
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-yjxx')).val();
    },

    search: function (pageNo) {
      var self = this;
      this.showYjxx();
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-yjxx')).val() || 20;
      self.searchData.pageNo = pageNo;
      var params = tools.clone(self.searchData);
      $("#"+self.templateName).jqGrid('clearGridData')
      api.dzbaDailyYjxxList(params).done(function (res) {
        if (res.code == '0') {
          $("#"+self.templateName)[0].addJSONData(res.data);
          self.tableData = res.data;
          $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },

    showYjxx: function () {
      $('.model').show();
      $('.page-model.page-model-yjxx').show();
    },

    hideYjxx: function () {
      $('.model').hide()
      $('.page-model.page-model-yjxx').hide();
    },
  }
});