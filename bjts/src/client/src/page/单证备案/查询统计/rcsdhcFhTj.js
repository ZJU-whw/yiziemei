var rcsdhcFhTj = require("./rcsdhcFhTj.html");
avalon.component('rcsdhcFhTj', {
  template: rcsdhcFhTj,
  defaults: {
    swjgmc: "",
    searchData: {
      swjgdm: "",
      timeStart: "",
      timeEnd: "",
      flglcd: "",
      jsmode: "",
      hcqk: "1",
      pageNo: 1,
      pageSize: 20,
    },
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
      $('.rcsdhc-fh-tj .datepicker.date-day').datetimepicker(options);
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".rcsdhc-fh-tj .form").height();
        if (h > 100) {
          $("#rcsdhc-fh-tj-table").jqGrid('setGridHeight', h - 101);
        }
      })
    },

    createTable: function () {
      var self = this;
      var columns = [
        { name: "swjgdm", label: "税务机关", index: "swjgdm", hidden: true },
        { name: "swjgmc", label: "税务机关", index: "swjgmc", width: 100, sortable: false },
        { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh", width: 135, sortable: false },
        { name: "nsrmc", label: "企业名称", index: "nsrmc", width: 135, sortable: false },
        { name: "qylx", label: "企业类型", index: "qylx", width: 120, align: "center", sortable: false },
        { name: "djzt", label: "登记状态", index: "djzt", width: 80, align: "center", sortable: false },
        {
          name: "hcYwbs", label: "核查业务笔数", index: "hcYwbs", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hcZcke", label: "核查总出口额(美元)", index: "hcZcke", width: 120, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcZtmse", label: "核查总退免税额", index: "hcZtmse", width: 120, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcYwbsWt", label: "核查问题业务笔数", index: "hcYwbsWt", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hcCkeWt", label: "问题业务出口额(美元)", index: "hcCkeWt", width: 130, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcTmseWt", label: "问题业务退免税额", index: "hcTmseWt", width: 120, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcYwbsYj", label: "核查业务笔数", index: "hcYwbsYj", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hcZckeYj", label: "核查总出口额(美元)", index: "hcZckeYj", width: 120, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcZtmseYj", label: "核查总退免税额", index: "hcZtmseYj", width: 120, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcYwbsWtYj", label: "核查问题业务笔数", index: "hcYwbsWtYj", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "hcCkeWtYj", label: "问题业务出口额(美元)", index: "hcCkeWtYj", width: 130, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "hcTmseWtYj", label: "问题业务退免税额", index: "hcTmseWtYj", width: 120, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
      ];
      $("#rcsdhc-fh-tj-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#rcsdhc-fh-tj-tablePager',
        shrinkToFit: false,
        width: "100%",
        // multiselect: true,
        // multiselectWidth:"30",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: 20,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".rcsdhc-fh-tj .form").height() - 101;
        })(),
        beforeSelectRow: function (rowid, e) {
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "rcsdhc-fh-tj-table");
          self.search(pageNo);
        }

      });
      $("#rcsdhc-fh-tj-table").jqGrid('setGroupHeaders', {
        useColSpanStyle: true,
        groupHeaders: [
          { "numberOfColumns": 6, "titleText": "其中涉及三新业务", "startColumnName": "hcYwbsYj" },
        ]
      });
      this.searchData.pageSize = $(".ui-pg-selbox", $('.rcsdhc-fh-tj')).val();
      this.search(1);
    },
    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize = $(".ui-pg-selbox", $('.rcsdhc-fh-tj')).val() || 20;
      self.searchData.pageNo = pageNo;
      var params = tools.clone(self.searchData);
      $("#rcsdhc-fh-tj-table").jqGrid('clearGridData')
      api.dzbaInspectDailySeparateList(params).done(function (res) {
        if (res.code == '0') {
          $("#rcsdhc-fh-tj-table")[0].addJSONData(res.data);
          $('.rcsdhc-fh-tj .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
          self.closeHyper();
        }
      })
    },
    showHyper: function () {
      $('.rcsdhc-fh-tj .select-sub').toggle();
      $('.rcsdhc-fh-tj .select-wrapper .icon').toggleClass("active");
      if ($('.rcsdhc-fh-tj .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
        $('.rcsdhc-fh-tj .select-wrapper .icon').attr("title", "收起查询条件");
      } else {
        $('.rcsdhc-fh-tj .select-wrapper .icon').attr("title", "展开查询条件")
      }
    },
    closeHyper: function () {
      $('.rcsdhc-fh-tj .select-sub').hide();
      $('.rcsdhc-fh-tj .select-wrapper .icon').removeClass('active');
      $('.rcsdhc-fh-tj .select-wrapper .icon').attr("title", "展开查询条件")
    },
    exform: function () {
      tools.ajaxExform(this.searchData, '/dzba/export/stat/inspect/daily/separate');
      // tools.exform(this.searchData, '/dzba/export/stat/inspect/daily/separate');
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
          $.fn.zTree.init($(".rcsdhc-fh-tj .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.rcsdhc-fh-tj').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }

      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.rcsdhc-fh-tj').off('click');
    },
    reset: function(){
      this.searchData = {
        swjgdm: avalonRoot.user.swjgDm,
        timeStart: tools.getYearStart(),
        timeEnd: tools.getToday(),
        flglcd: "",
        jsmode: "",
        hcqk: "1",
        pageNo: 1,
        pageSize: 20,
      }
      this.swjgmc = avalonRoot.user.swjgMc
    }
  }
});