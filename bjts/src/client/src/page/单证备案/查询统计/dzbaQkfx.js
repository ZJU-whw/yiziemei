var dzbaQkfx = require("./dzbaQkfx.html");
avalon.component('dzbaQkfx', {
  template: dzbaQkfx,
  defaults: {
    swjgmc: "",
    searchData: {
      swjgdm: "",
      sbqq: "",
      sbqz: "",
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
      var curMonth = tools.getMonthFormat('-');
      var optionsMonth = {
        language: 'zh-CN',
        format: 'yyyymm',
        weekStart: 1,
        // todayBtn: true,
        clearBtn: true,
        autoclose: 1,
        todayHighlight: 1,
        startView: 3, // 这里就设置了默认视图为年视图
        minView: 3, // 设置最小视图为年视图
        forceParse: 0,
        startDate: '2021-01',
        endDate: curMonth,
      }
      $('.dzbaqkfx--tj .datepicker.date-month').datetimepicker(optionsMonth);
      $('.dzbaqkfx--tj .datepicker.date-month.sbqq').datetimepicker('update', curMonth);
      $('.dzbaqkfx--tj .datepicker.date-month.sbqz').datetimepicker('update', curMonth);
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".dzbaqkfx--tj .form").height();
        if (h > 100) {
          $("#dzbaqkfx--tj-table").jqGrid('setGridHeight', h - 130);
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
          name: "zsbsHstj", label: "总申报数", index: "zsbsHstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "zsYktHstj", label: "总数", index: "zsYktHstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ybaYktHstj", label: "存在备案", index: "ybaYktHstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "wbaYktHstj", label: "存在未备案", index: "wbaYktHstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "cqbaYktHstj", label: "存在超期备案", index: "cqbaYktHstj", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "wktsHstj", label: "未开通数", index: "wktsHstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "zsbsPcstj", label: "总申报数", index: "zsbsPcstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ybasPcstj", label: "应备案数", index: "ybasPcstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "zcbaPcstj", label: "正常备案", index: "zcbaPcstj", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "cqbaPcstj", label: "超期备案", index: "cqbaPcstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "wbaPcstj", label: "未备案", index: "wbaPcstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ybasYwstj", label: "应备案数", index: "ybasYwstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "zcbaYwstj", label: "正常备案", index: "zcbaYwstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "cqbaYwstj", label: "超期备案", index: "cqbaYwstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "wbaYwstj", label: "未备案", index: "wbaYwstj", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ybasTmsetj", label: "应备案数(万元)", index: "ybasTmsetj", width: 110, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "zcbaTmsetj", label: "正常备案(万元)", index: "zcbaTmsetj", width: 110, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "cqbaTmsetj", label: "超期备案(万元)", index: "cqbaTmsetj", width: 110, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "wbaTmsetj", label: "未备案(万元)", index: "wbaTmsetj", width: 110, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "baDzfs", label: "备案单证份数", index: "baDzfs", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
      ];
      $("#dzbaqkfx--tj-table").jqGrid({
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
          return $(".dzbaqkfx--tj .form").height() - 130;
        })(),
        beforeSelectRow: function (rowid, e) {
          return;
        },

      });
      $("#dzbaqkfx--tj-table").jqGrid('setGroupHeaders', {
        useColSpanStyle: true,
        groupHeaders: [
          { "numberOfColumns": 6, "titleText": "户数统计", "startColumnName": "zsbsHstj" },
          { "numberOfColumns": 5, "titleText": "批次数统计", "startColumnName": "zsbsPcstj" },
          { "numberOfColumns": 4, "titleText": "业务数统计", "startColumnName": "ybasYwstj" },
          { "numberOfColumns": 4, "titleText": "退免税额统计", "startColumnName": "ybasTmsetj" },
        ]
      });
      $("#dzbaqkfx--tj-table").jqGrid('setGroupHeaders', {
        useColSpanStyle: true,
        groupHeaders: [
          { "numberOfColumns": 4, "titleText": "已开通", "startColumnName": "zsYktHstj" },
          { "numberOfColumns": 3, "titleText": "其中", "startColumnName": "zcbaPcstj" },
          { "numberOfColumns": 3, "titleText": "其中", "startColumnName": "zcbaYwstj" },
          { "numberOfColumns": 3, "titleText": "其中", "startColumnName": "zcbaTmsetj" },
        ]
      });
    },
    serializeParams: function(params){
      if(params.sbqq){
        params.sbqq = params.sbqq.slice(0, 4) + '-' + params.sbqq.slice(4, 6);
      }
      if(params.sbqz){
        params.sbqz = params.sbqz.slice(0, 4) + '-' + params.sbqz.slice(4, 6);
      }
    },
    search: function () {
      if(this.searchData.sbqq && this.searchData.sbqz && this.searchData.sbqz<this.searchData.sbqq){
        tools.info('申报期起不可超过申报期止');
        return
      }
      var self = this;
      var params = tools.clone(this.searchData);
      this.serializeParams(params);
      $("#dzbaqkfx--tj-table").jqGrid('clearGridData')
      api.dzbaInspectAnalysisList(params).done(function (res) {
        if (res.code == '0') {
          $("#dzbaqkfx--tj-table")[0].addJSONData(res.data);
          self.totalNum = res.data.length;
          $('.dzbaqkfx--tj .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },

    exform: function () {
      if(this.searchData.sbqq && this.searchData.sbqz && this.searchData.sbqz<this.searchData.sbqq){
        tools.info('申报期起不可超过申报期止');
        return
      }
      var params = tools.clone(this.searchData);
      this.serializeParams(params);
      tools.exform(params, '/dzba/export/stat/inspect/analysis');
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
          $.fn.zTree.init($(".dzbaqkfx--tj .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.dzbaqkfx--tj').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }

      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.dzbaqkfx--tj').off('click');
    },
  }
});