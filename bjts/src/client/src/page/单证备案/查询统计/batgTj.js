var batgTj = require("./batgTj.html");
avalon.component('batgTj', {
  template: batgTj,
  defaults: {
    swjgmc: "",
    searchData: {
      swjgdm: "",
      tjnyStart: "",
      tjnyEnd: "",
    },
    totalNum: 0,
    onReady: function () {
      this.initUser();
      this.initDate();
      this.initHeight();
      this.initTree()
      this.createTable();
    },

    // 初始化用户数据
    initUser: function () {
      var self = this;
      if (avalonRoot.user && avalonRoot.user.swjgDm) {
        this.searchData.swjgdm = avalonRoot.user.swjgDm;
        this.swjgmc = avalonRoot.user.swjgMc;
      } else {
        api.preLogin().done(function (res) {
          if (res.code == '0') {
            avalonRoot.user = res.data;
            self.searchData.swjgdm = avalonRoot.user.swjgDm;
            self.swjgmc = avalonRoot.user.swjgMc;
          }
        })
      }
    },

    // 初始化时间输入框
    initDate: function () {
      this.searchData.tjnyStart = tools.getMonthFormat('-');
      this.searchData.tjnyEnd = tools.getMonthFormat('-');
      var optionsMonth = {
        language: 'zh-CN',
        format: 'yyyy-mm',
        weekStart: 1,
        // todayBtn: true,
        clearBtn: true,
        autoclose: 1,
        todayHighlight: 1,
        startView: 3, // 这里就设置了默认视图为年视图
        minView: 3, // 设置最小视图为年视图
        forceParse: 0,
        startDate: '2021-01',
        endDate: this.searchData.tjnyEnd,
      }
      $('.batg-tj .datepicker.date-month').datetimepicker(optionsMonth).on('change', function(){
        $('.batg-tj .datepicker.date-month').datetimepicker('setStartDate', '2021-01');
      })
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".batg-tj .form").height();
        if (h > 100) {
          $("#batg-tj-table").jqGrid('setGridHeight', h - 110);
        }
      })
    },

    createTable: function () {
      var self = this;
      var columns = [
        { name: "swjgdm", label: "税务机关代码", index: "swjgdm", hidden: true },
        {
          name: "district", label: "地区", index: "district", width: 80, sortable: false },
        {
          name: "ckqyhsSnd", label: "1", index: "ckqyhsSnd", width: 50, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "szhDjhsZs", label: "2", index: "szhDjhsZs", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ktbl21", label: "3=2/1", index: "ktbl21", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "ybaHs", label: "4", index: "ybaHs", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ktbl42", label: "5=4/2", index: "ktbl42", width: 110, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "szhDjhs", label: "6", index: "szhDjhs", width: 55, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "sbpcZs", label: "7", index: "sbpcZs", width: 45, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "dbaPcs", label: "8", index: "dbaPcs", width: 45, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ybaPcs", label: "9", index: "ybaPcs", width: 45, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "babl97", label: "10=9/7", index: "babl97", width: 90, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "babl98", label: "11=9/8", index: "babl98", width: 90, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "dbaYws", label: "12", index: "dbaYws", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ybaYws", label: "13", index: "ybaYws", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ybaYwZb", label: "14=13/12", index: "ybaYwZb", width: 50, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "sbTmse", label: "15", index: "sbTmse", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "dbaTmse", label: "16", index: "dbaTmse", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "ybaTmse", label: "17", index: "ybaTmse", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "tmseZb1715", label: "18=17/15", index: "tmseZb1715", width: 85, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "tmseZb1716", label: "19=17/16", index: "tmseZb1716", width: 85, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "baDzfs", label: "备案单证份数", index: "baDzfs", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
      ];
      $("#batg-tj-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        width: "100%",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: 100000,
        height: (function () {
          return $(".batg-tj .form").height() - 110;
        })(),
        beforeSelectRow: function (rowid, e) {
          return;
        },

      });
      $("#batg-tj-table").jqGrid('setGroupHeaders', {
        useColSpanStyle: true,
        groupHeaders: [
          { "numberOfColumns": 1, "titleText": "2022年 申报户数", "startColumnName": "ckqyhsSnd" },
          { "numberOfColumns": 1, "titleText": "总开通户数", "startColumnName": "szhDjhsZs" },
          { "numberOfColumns": 1, "titleText": "总开通比列", "startColumnName": "ktbl21" },
          { "numberOfColumns": 1, "titleText": "已备案户数", "startColumnName": "ybaHs" },
          { "numberOfColumns": 1, "titleText": "已备案户与总开通户占比", "startColumnName": "ktbl42" },
          { "numberOfColumns": 1, "titleText": "统计期内开通户数", "startColumnName": "szhDjhs" },
          { "numberOfColumns": 1, "titleText": "总申报批次数", "startColumnName": "sbpcZs" },
          { "numberOfColumns": 1, "titleText": "应备案批次数", "startColumnName": "dbaPcs" },
          { "numberOfColumns": 1, "titleText": "已备案批次数", "startColumnName": "ybaPcs" },
          { "numberOfColumns": 1, "titleText": "已备案与总申报批次占比", "startColumnName": "babl97" },
          { "numberOfColumns": 1, "titleText": "已备案与应备案批次占比", "startColumnName": "babl98" },
          { "numberOfColumns": 1, "titleText": "应备案业务数", "startColumnName": "dbaYws" },
          { "numberOfColumns": 1, "titleText": "已备案业务数", "startColumnName": "ybaYws" },
          { "numberOfColumns": 1, "titleText": "已备案 业务占比", "startColumnName": "ybaYwZb" },
          { "numberOfColumns": 1, "titleText": "申报退免税额", "startColumnName": "sbTmse" },
          { "numberOfColumns": 1, "titleText": "应备案退免税额", "startColumnName": "dbaTmse" },
          { "numberOfColumns": 1, "titleText": "已备案退免税额", "startColumnName": "ybaTmse" },
          { "numberOfColumns": 1, "titleText": "已备案与总申报退免税额占比", "startColumnName": "tmseZb1715" },
          { "numberOfColumns": 1, "titleText": "已备案与应备案退免税额占比", "startColumnName": "tmseZb1716" },
        ]
      });
    },
    search: function () {
      var self = this;
      if(this.searchData.tjnyEnd && this.searchData.tjnyStart && this.searchData.tjnyEnd<this.searchData.tjnyStart){
        tools.info('统计月份起不可超过统计月份止');
        return
      }
      var params = tools.clone(this.searchData);
      $("#batg-tj-table").jqGrid('clearGridData')
      api.dzbaInspectSpreadList(params).done(function (res) {
        if (res.code == '0') {
          $("#batg-tj-table")[0].addJSONData(res.data);
          self.totalNum = res.data.length;
          $('.batg-tj .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },

    exform: function () {
      tools.exform(this.searchData, '/dzba/export/stat/inspect/spread');
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
          }
        },
        data: { key: { children: "item", name: "text" } }
      };

      api.dzbaExportReadtree({ nodeType: "3" }).done(function (res) {
        if (res.code == '0') {
          $.fn.zTree.init($(".batg-tj .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.batg-tj').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }

      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.batg-tj').off('click');
    },
  }
});