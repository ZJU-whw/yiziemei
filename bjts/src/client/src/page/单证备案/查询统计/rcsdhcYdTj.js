var rcsdhcYdTj = require("./rcsdhcYdTj.html");
avalon.component('rcsdhcYdTj', {
  template: rcsdhcYdTj,
  defaults: {
    swjgmc: "",
    searchData: {
      swjgdm: "",
      timeStart: "",
      timeEnd: "",
      releaser: "",
      groupSet: "",
    },
    groupChecked: [],
    releaserList: [],
    mergeInfo: {},
    sumData: {},
    onInit: function(e){
      avalonRoot.rcsdhcYdTj = e.vmodel;
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
        self.resetSwjgmc(avalonRoot.user.swjgMc, avalonRoot.user.swjgDm);
      } else {
        api.preLogin().done(function (res) {
          if (res.code == '0') {
            avalonRoot.user = res.data;
            self.searchData.swjgdm = avalonRoot.user.swjgDm;
            self.resetSwjgmc(avalonRoot.user.swjgMc, avalonRoot.user.swjgDm);
          }
        })
      }
    },

    // 初始化时间输入框
    initDate: function () {
      this.searchData.timeStart = tools.getMonth(tools.getYearStart(), '-');
      this.searchData.timeEnd = tools.getMonth(null, '-');
      var optionsM = {
        language: 'zh-CN',
        format: 'yyyy-mm',
        weekStart: 1,
        // todayBtn: true,
        clearBtn: true,
        autoclose: 1,
        todayHighlight: 1,
        startView: 3, // 这里就设置了默认视图为年视图
        minView: 3, // 设置最小视图为年视图
        endDate: new Date(),
        forceParse: 0,
      };
      $('.rcsdhc-yd-tj .datepicker.date-month').datetimepicker(optionsM);
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".rcsdhc-yd-tj .form").height();
        if (h > 100) {
          $("#rcsdhc-yd-tj-table").jqGrid('setGridHeight', h - 101);
        }
      })
    },

    createTable: function () {
      var self = this;
      var columns = [
        { name: "swjgdm", label: "税务机关", index: "swjgdm", hidden: true },
        { name: "swjgmc", label: "税务机关名称", index: "swjgmc", width: 120, sortable: false },
        { name: "month", label: "月度", index: "month", width: 80, sortable: false, align: 'center' },
        { name: "releaser", label: "下达人", index: "releaser", width: 100, sortable: false },
        {
          name: "hcYwbs", label: "核查业务笔数", index: "hcYwbs", width: 60, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = (cellVal === null || cellVal === '') ? '' : cellVal;
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
      $("#rcsdhc-yd-tj-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        // rownumbers: true,
        shrinkToFit: false,
        width: "100%",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: 2000,
        footerrow:true,
        height: (function () {
          return $(".rcsdhc-yd-tj .form").height() - 101;
        })(),
        gridComplete: function(){
          $("#rcsdhc-yd-tj-table").footerData('set', self.sumData);
          if(self.groupChecked.length > 0){
            self.mergeRowsSwjg(1, 'swjgmcLine');
          }
          if(self.groupChecked.length > 1){
            self.mergeRowsMonth(2, 'monthLine');
          }
        },
      });
      $("#rcsdhc-yd-tj-table").jqGrid('setGroupHeaders', {
        useColSpanStyle: true,
        groupHeaders: [
          { "numberOfColumns": 6, "titleText": "其中涉及三新业务", "startColumnName": "hcYwbsYj" },
        ]
      });
    },
    resetCol: function(){
      if(this.groupChecked.indexOf('1')>-1){
        $("#rcsdhc-yd-tj-table").showCol('month');
      } else{
        $("#rcsdhc-yd-tj-table").hideCol('month');
      }
      if(this.groupChecked.indexOf('2')>-1){
        $("#rcsdhc-yd-tj-table").showCol('releaser');
      } else{
        $("#rcsdhc-yd-tj-table").hideCol('releaser');
      }
    },
    // 行合并  税务机关列
    mergeRowsSwjg: function(cols, lineItem){
      var rows = $('#rcsdhc-yd-tj-table tr');
      // 税务机关列
      for(var i=1; i<rows.length;){
        var cur_i_td = rows.eq(i).children('td');
        var swjgdm = cur_i_td.eq(0).html();
        var colsMc = cur_i_td.eq(cols).html();
        var mergeInfo = this.getMergeBySwjgdm(swjgdm);
        var mergeNum = mergeInfo[lineItem];
        if(colsMc=='小计' || colsMc=='/' || !mergeNum || mergeNum<2) {
          i++;
          continue;
        }
        cur_i_td.eq(cols).attr('rowspan', mergeNum);
        for(var j=1; j<mergeNum; j++){
          var cur_i_td_hide = rows.eq(i+1).children('td');
          cur_i_td_hide.eq(cols).css('display', 'none');
          i++;
        }
        i++;
      }
    },
    // 行合并  月度列
    mergeRowsMonth: function(cols, lineItem){
      var rows = $('#rcsdhc-yd-tj-table tr');
      // 税务机关列
      for(var i=1; i<rows.length;){
        var cur_i_td = rows.eq(i).children('td');
        var swjgdm = cur_i_td.eq(0).html();
        var colsMc = cur_i_td.eq(cols).html();
        var mergeInfo = this.getMergeBySwjgdm(swjgdm);
        var monthMergeList = mergeInfo['monthLine'] || [];
        if(colsMc=='小计' || colsMc=='/' || monthMergeList.length==0) {
          i++;
          continue;
        }
        for(var m=0; m<monthMergeList.length; m++){
          var cur_i_td_m = rows.eq(i).children('td');
          var month_k = cur_i_td_m.eq(cols).html();
          var month_i = monthMergeList[m];
          var mergeNum = month_i[month_k] || 1;
          if(!mergeNum || mergeNum<2) {
            i++;
            continue;
          }
          cur_i_td_m.eq(cols).attr('rowspan', mergeNum);
          for(var j=1; j<mergeNum; j++){
            var cur_i_td_hide = rows.eq(i+1).children('td');
            cur_i_td_hide.eq(cols).css('display', 'none');
            i++;
          }
          i++;
        }
      }
    },
    getMergeBySwjgdm: function(swjgdm){
      var res = {};
      for(var i=0; i<this.mergeInfo.length; i++){
        if(this.mergeInfo[i].swjgdm == swjgdm) {
          return this.mergeInfo[i];
        }
      }
      return res
    },
    search: function (pageNo) {
      var self = this;
      if(!this.searchData.swjgdm){
        tools.info('税务机关不能为空');
        return
      }
      if(!this.searchData.timeStart || !this.searchData.timeEnd){
        tools.info('统计日期起止不能为空');
        return
      }
      if(this.searchData.timeStart > this.searchData.timeEnd){
        tools.info('起始日期不能超过截止日期');
        return
      }
      // 处理动态表头
      this.resetCol();
      this.searchData.groupSet = this.groupChecked.join(',');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.rcsdhc-yd-tj')).val() || 20;
      self.searchData.pageNo = pageNo;
      var params = tools.clone(self.searchData);
      params.timeStart = tools.getMonStart(params.timeStart);
      params.timeEnd = tools.getMonthLast(params.timeEnd);
      $("#rcsdhc-yd-tj-table").jqGrid('clearGridData');
      api.dzbaInspectDailyMonthList(params).done(function (res) {
        if (res.code == '0' && res.data) {
          var statData = res.data.statData || [];
          if(statData.length>0) {
            var lastData = statData[statData.length-1];
            if(lastData.swjgmc=='合计'){
              self.sumData = lastData;
              statData.splice(statData.length-1, 1);
            }
          }
          self.mergeInfo = res.data.mergeInfo || {};
          $("#rcsdhc-yd-tj-table")[0].addJSONData(res.data.statData);
          $('.rcsdhc-yd-tj .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },
    // 获取下达人列表
    getReleaserList: function(){
      var self = this;
      var params = {
        swjgdm: this.searchData.swjgdm
      }
      api.getReleaserList(params).done(function(res){
        if(res.code == '0'){
          self.searchData.releaser = '';
          self.releaserList = res.data || [];
        }
      })
    },
    exform: function () {
      var params = tools.clone(this.searchData);
      params.timeStart = tools.getMonStart(params.timeStart);
      params.timeEnd = tools.getMonthLast(params.timeEnd);
      tools.ajaxExform(params, '/dzba/export/stat/inspect/daily/month');
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
            self.resetSwjgmc(node.text, node.id);
            self.hideTree();
            return;
          },
          onDblClick: function (e, id, node) {
            self.searchData.swjgdm = node.id;
            self.resetSwjgmc(node.text, node.id);
            self.hideTree();
            return;
          }
        },
        data: { key: { children: "item", name: "text" } }
      };

      api.dzbaExportReadtree({ nodeType: "3" }).done(function (res) {
        if (res.code == '0') {
          $.fn.zTree.init($(".rcsdhc-yd-tj .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.rcsdhc-yd-tj').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }

      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.rcsdhc-yd-tj').off('click');
    },
    reset: function(){
      this.searchData = {
        swjgdm: avalonRoot.user.swjgDm,
        timeStart: '',
        timeEnd: '',
        releaser: "",
        groupSet: "",
        pageNo: 1,
        pageSize: 20,
      }
      this.searchData.timeStart = tools.getMonth(tools.getYearStart(), '-');
      this.searchData.timeEnd = tools.getMonth(null, '-');
      this.resetSwjgmc(avalonRoot.user.swjgMc, avalonRoot.user.swjgDm);
      this.groupChecked = [];
    },
    resetSwjgmc: function(swjgMc, swjgDm){
      this.swjgmc = swjgMc;
      // 如果是省局，则月度和下达人分组不可选
      if(swjgDm=='13300000000'){
        $('.rcsdhc-yd-tj .yd-sj-disabled').attr('disabled', true);
        this.groupChecked.splice(0, 2);
        this.searchData.releaser = '';
        var releaserLen = this.releaserList.length;
        this.releaserList.splice(0, releaserLen);
      } else{
        this.getReleaserList();
        $('.rcsdhc-yd-tj .yd-sj-disabled').attr('disabled', false);
      }
    },
  }
});