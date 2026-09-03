var ndhckhTj = require("./ndhckhTj.html");
avalon.component('ndhckhTj', {
  template: ndhckhTj,
  defaults: {
    swjgmc: "",
    searchData: {
      swjgdm: "",
      tjnd: "",
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
      this.searchData.tjnd = new Date().getFullYear() - 1 + '';
      var endDate = new Date().getFullYear() + '';
      $('.ndhckh-tj .datepicker.date-year').datetimepicker({
        format: 'yyyy',
        language: "zh-CN",
        clearBtn: false,
        autoclose: true,
        startView: 4, // 这里就设置了默认视图为年视图
        minView: 4, // 设置最小视图为年视图
        endDate: endDate,
      });
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".ndhckh-tj .form").height();
        if (h > 100) {
          $("#ndhckh-tj-table").jqGrid('setGridHeight', h - 100);
        }
      })
    },

    createTable: function () {
      var self = this;
      var columns = [
        { name: "swjgdm", label: "税务机关代码", index: "swjgdm", hidden: true },
        { name: "swjgmc", label: "税务机关", index: "swjgmc", width: 100, sortable: false },
        {
          name: "zsbHs", label: "总申报户数", index: "zsbHs", width: 70, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "szhDjhs", label: "数字化单证备案登记户数", index: "szhDjhs", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "szhCchs", label: "数字化备案企业", index: "szhCchs", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "zzCchs", label: "纸质备案企业", index: "zzCchs", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hjCchs", label: "抽查企业合计", index: "hjCchs", width: 90, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "zcclv", label: "总抽查率(%)", index: "zcclv", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "szhHghs", label: "数字化备案企业", index: "szhHghs", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "zzHghs", label: "纸质备案企业", index: "zzHghs", width: 90, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hjHghs", label: "抽查企业合计", index: "hjHghs", width: 90, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hglv", label: "单证备案企业合格率(%)", index: "hglv", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "ywzbsCcqk", label: "抽查业务总笔数", index: "ywzbsCcqk", width: 120, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hctgbsCcqk", label: "检查通过笔数", index: "hctgbsCcqk", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "zghtgbsCcqk", label: "整改后通过笔数", index: "zghtgbsCcqk", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "bhgywbsCcqk", label: "不合格业务笔数", index: "bhgywbsCcqk", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
      ];
      $("#ndhckh-tj-table").jqGrid({
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
          return $(".ndhckh-tj .form").height() - 100;
        })(),
        beforeSelectRow: function (rowid, e) {
          return;
        },

      });
      $("#ndhckh-tj-table").jqGrid('setGroupHeaders', {
        useColSpanStyle: true,
        groupHeaders: [
          { "numberOfColumns": 3, "titleText": "单证备案抽查户数", "startColumnName": "szhCchs" },
          { "numberOfColumns": 3, "titleText": "抽查合格企业户数", "startColumnName": "szhHghs" },
          { "numberOfColumns": 4, "titleText": "数字化备案业务抽查情况", "startColumnName": "ywzbsCcqk" },
        ]
      });
      self.search();
    },
    search: function () {
      var self = this;
      var params = tools.clone(self.searchData);
      $("#ndhckh-tj-table").jqGrid('clearGridData')
      api.dzbaInspectYearList(params).done(function (res) {
        if (res.code == '0') {
          $("#ndhckh-tj-table")[0].addJSONData(res.data);
          self.totalNum = res.data.length;
          $('.ndhckh-tj .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },
    
    exform: function () {
      tools.exform(this.searchData, '/dzba/export/stat/inspect/year');
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
          $.fn.zTree.init($(".ndhckh-tj .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.ndhckh-tj').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }

      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.ndhckh-tj').off('click');
    },
  }
});