var rcsdhcTj = require("./rcsdhcTj.html");
avalon.component('rcsdhcTj', {
  template: rcsdhcTj,
  defaults: {
    swjgmc: "",
    searchData: {
      swjgdm: "",
      timeStart: "",
      timeEnd: "",
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
      this.searchData.timeStart = tools.getYearStart();
      this.searchData.timeEnd = tools.getToday();
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: false, startView: 2, minView: 2, endDate: new Date() };
      $('.rcsdhc-tj .datepicker.date-day').datetimepicker(options);
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".rcsdhc-tj .form").height();
        if (h > 100) {
          $("#rcsdhc-tj-table").jqGrid('setGridHeight', h - 100);
        }
      })
    },

    createTable: function () {
      var columns = [
        { name: "qylx", label: "企业类型", index: "qylx", width: 80, align: "center", sortable: false },
        { name: "swjgdm", label: "税务机关", index: "swjgdm", hidden: true },
        { name: "swjgmc", label: "税务机关", index: "swjgmc", width: 90, sortable: false },
        {
          name: "hcYwbs", label: "核查业务笔数", index: "hcYwbs", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hcZcke", label: "核查总出口额(美元)", index: "hcZcke", width: 120, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcZtmse", label: "核查总退免税额", index: "hcZtmse", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcYwbsWt", label: "核查问题业务笔数", index: "hcYwbsWt", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hcCkeWt", label: "问题业务出口额(美元)", index: "hcCkeWt", width: 130, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcTmseWt", label: "问题业务退免税额", index: "hcTmseWt", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcYwbsYj", label: "核查业务笔数", index: "hcYwbsYj", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hcZckeYj", label: "核查总出口额(美元)", index: "hcZckeYj", width: 120, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcZtmseYj", label: "核查总退免税额", index: "hcZtmseYj", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcYwbsWtYj", label: "核查问题业务笔数", index: "hcYwbsWtYj", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hcCkeWtYj", label: "问题业务出口额(美元)", index: "hcCkeWtYj", width: 130, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcTmseWtYj", label: "问题业务退免税额", index: "hcTmseWtYj", width: 100, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
      ];
      $("#rcsdhc-tj-table").jqGrid({
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
        rowNum: 100000,
        height: (function () {
          return $(".rcsdhc-tj .form").height() - 100;
        })(),
        beforeSelectRow: function (rowid, e) {
          return;
        },

      });
      $("#rcsdhc-tj-table").jqGrid('setGroupHeaders', {
        useColSpanStyle: true,
        groupHeaders: [
          { "numberOfColumns": 6, "titleText": "其中涉及三新业务", "startColumnName": "hcYwbsYj" },
        ]
      });
      this.search();
    },
    search: function () {
      var self = this;
      var params = tools.clone(self.searchData);
      $("#rcsdhc-tj-table").jqGrid('clearGridData')
      api.dzbaInspectDailyList(params).done(function (res) {
        if (res.code == '0') {
          $("#rcsdhc-tj-table")[0].addJSONData(res.data);
          self.totalNum = res.data.length;
          $('.rcsdhc-tj .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },
    showHyper: function () {
      $('.rcsdhc-tj .select-sub').toggle();
      $('.rcsdhc-tj .select-wrapper .icon').toggleClass("active");
      if ($('.rcsdhc-tj .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
        $('.rcsdhc-tj .select-wrapper .icon').attr("title", "收起查询条件");
      } else {
        $('.rcsdhc-tj .select-wrapper .icon').attr("title", "展开查询条件")
      }
    },

    exform: function () {
      tools.exform(this.searchData, '/dzba/export/stat/inspect/daily');
    },
    
    filDate: function (e) {
      var date = e.target.value;
      var res = tools.DateCheup(date);
      if (res === false) {
        tools.info("日期输入错误");
        res = ""
      }
      e.target.value = res;
      return;
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
          $.fn.zTree.init($(".rcsdhc-tj .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.rcsdhc-tj').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }

      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.rcsdhc-tj').off('click');
    },
  }
});