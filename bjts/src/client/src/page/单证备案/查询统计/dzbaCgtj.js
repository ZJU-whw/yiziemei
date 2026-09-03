var dzbaCgtj = require("./dzbaCgtj.html");
avalon.component('dzbaCgtj', {
  template: dzbaCgtj,
  defaults: {
    swjgmc: "",
    searchData: {
      swjgdm: "",
      // tjnyStart: "",
      // tjnyEnd: "",
    },
    totalNum: 0,
    onReady: function () {
      this.initUser();
      // this.initDate();
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
      $('.dzbacg-tj .datepicker.date-month').datetimepicker(optionsMonth).on('change', function(){
        $('.dzbacg-tj .datepicker.date-month').datetimepicker('setStartDate', '2021-01');
      })
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".dzbacg-tj .form").height();
        if (h > 100) {
          $("#dzbacg-tj-table").jqGrid('setGridHeight', h - 110);
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
          name: "snhyhs", label: "上年活跃户数", index: "snhyhs", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "bnxzKtbahs", label: "本年新增", index: "bnxzKtbahs", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ljKtbahs", label: "累计开通", index: "ljKtbahs", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "yzxKtbahs", label: "其中已注销", index: "yzxKtbahs", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hsBnxzba", label: "户数", index: "hsBnxzba", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "pcsBnxzba", label: "批次数", index: "pcsBnxzba", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ywbsBnxzba", label: "业务笔数", index: "ywbsBnxzba", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "dzfsBnxzba", label: "单证份数", index: "dzfsBnxzba", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "tmseBnxzba", label: "退免税额(万元)", index: "tmseBnxzba", width: 110, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hsLjba", label: "户数", index: "hsLjba", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "pcsLjba", label: "批次数", index: "pcsLjba", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ywbsLjba", label: "业务笔数", index: "ywbsLjba", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "dzfsLjba", label: "单证份数", index: "dzfsLjba", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "tmseLjba", label: "退免税额(万元)", index: "tmseLjba", width: 110, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
      ];
      $("#dzbacg-tj-table").jqGrid({
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
          return $(".dzbacg-tj .form").height() - 100;
        })(),
        beforeSelectRow: function (rowid, e) {
          return;
        },

      });
      $("#dzbacg-tj-table").jqGrid('setGroupHeaders', {
        useColSpanStyle: true,
        groupHeaders: [
          { "numberOfColumns": 3, "titleText": "开通备案户数", "startColumnName": "bnxzKtbahs" },
          { "numberOfColumns": 5, "titleText": "本年新增备案情况", "startColumnName": "hsBnxzba" },
          { "numberOfColumns": 5, "titleText": "累计备案情况", "startColumnName": "hsLjba" },
        ]
      });
    },
    search: function () {
      var self = this;
      var params = tools.clone(this.searchData);
      $("#dzbacg-tj-table").jqGrid('clearGridData')
      api.dzbaInspectOutcomeList(params).done(function (res) {
        if (res.code == '0') {
          $("#dzbacg-tj-table")[0].addJSONData(res.data);
          self.totalNum = res.data.length;
          $('.dzbacg-tj .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },

    exform: function () {
      tools.exform(this.searchData, '/dzba/export/stat/inspect/outcome');
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
          $.fn.zTree.init($(".dzbacg-tj .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.dzbacg-tj').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }

      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.dzbacg-tj').off('click');
    },
  }
});