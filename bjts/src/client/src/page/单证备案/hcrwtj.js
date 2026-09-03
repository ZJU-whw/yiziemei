var hcrwtj = require("./hcrwtj.html");
avalon.component('hcrwtj', {
  template: hcrwtj,
  defaults: {
    swjgmc: "",
    searchData: {
      swjg_dm: "",
      inspectTimeStart: "",
      inspectTimeEnd: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    tableData: {},
    onReady: function () {
      try {
        this.searchData.swjg_dm = avalonRoot.user.swjgDm;
        this.swjgmc=avalonRoot.user.swjgMc;
      } catch (e) {

      }
      this.searchData.inspectTimeStart = tools.getMonStart();
      this.searchData.inspectTimeEnd = tools.getToday();
      this.initDate();
      this.initHeight();
      this.initTree()
      this.createTable();
    },

    // 初始化时间输入框
    initDate: function () {
      $('.hcrwtj .datepicker').datepicker({
        dateFormat: 'yy-mm-dd'
      });
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        $("#hcrwtj-table").jqGrid('setGridHeight', $(".hcrwtj .form").height() - 100);
      })
    },

    createTable: function () {
      var self = this;
      var columns = [
        { name: "id", label: "id", index: "id", hidden: true, width: 100, align: "left", sortable: true },
        { name: "tsjsfs", label: "退税方式", index: "tsjsfs", width: 100, align: "center", sortable: true },
        { name: "gllb", label: "分类管理", index: "gllb", width: 100, align: "center", sortable: true },
        { name: "qyhs", label: "企业户数", index: "qyhs", width: 100, align: "right", sortable: true },
        { name: "hcrwZs", label: "总数", index: "hcrwZs", width: 100, align: "right", sortable: true },
        { name: "hcrwWzh", label: "无纸化", index: "hcrwWzh", width: 100, align: "right", sortable: true },
        { name: "hcrwWZhZb", label: "占比(%)", index: "hcrwWZhZb", width: 100, align: "right", sortable: true },
        { name: "jlzcHs", label: "户数", index: "jlzcHs", width: 100, align: "right", sortable: true },
        { name: "jlzcRws", label: "任务数", index: "jlzcRws", width: 100, align: "right", sortable: true },
        { name: "jlycHs", label: "户数", index: "jlycHs", width: 100, align: "right", sortable: true },
        { name: "jlycRws", label: "任务数", index: "jlycRws", width: 100, align: "right", sortable: true },
      ];
      $("#hcrwtj-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#hcrwtj-tablePager',
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
          return $(".hcrwtj .form").height() - 100;
        })(),
        beforeSelectRow: function (rowid, e) {
          return;
        },
        onSortCol: function (index, iCol, sortorder) {
          self.searchData.orderSql = index + ' ' + sortorder;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "hcrwtj-table");
          self.search(pageNo);
        }

      });
      $("#hcrwtj-table").jqGrid('setGroupHeaders', {
        useColSpanStyle: true,
        groupHeaders: [
          { "numberOfColumns": 3, "titleText": "核查任务", "startColumnName": "hcrwZs" },
          { "numberOfColumns": 2, "titleText": "结论正常", "startColumnName": "jlzcHs" },
          { "numberOfColumns": 2, "titleText": "结论异常", "startColumnName": "jlycHs" },
        ]
      });
      this.searchData.pageSize = $(".ui-pg-selbox", $('.hcrwtj')).val();
      // self.search(1)
    },
    search: function (pageNo) {
      var self = this;
      if (self.searchData.inspectTimeStart && self.searchData.inspectTimeEnd && (self.searchData.inspectTimeStart > self.searchData.inspectTimeEnd)) {
        tools.info('截止时间应大于开始时间。');
        return
      }
      var fields = [
        { name: "qyhgdm", rules: 'max_length[10]', message: "海关代码最大长度为10" },
        { name: "nsrmc", rules: 'max_length[30]', message: "企业名称最大长度为30" },
      ];
      var isValid = tools.validate("hcrwtj-form", fields);
      if (isValid) {
        this.searchData.pageSize = $(".ui-pg-selbox", $('.hcrwtj')).val() || 20;
        var params = tools.clone(self.searchData);
        params.pageNo = pageNo
        $("#hcrwtj-table").jqGrid('clearGridData')
        ajax("POST", "/dzba/inspect/stat/list", params).done(function (res) {
          if (res.code == '0') {
            $("#hcrwtj-table").resetSelection();
            $("#hcrwtj-table")[0].addJSONData(res.data);
            self.tableData = res.data;
          } else {
            tools.info(res.msg);
          }
        }).fail(function (err) {
          tools.info(err);
        })
      }
    },
    showHyper: function () {
      $('.hcrwtj .select-sub').toggle();
      $('.hcrwtj .select-wrapper .icon').toggleClass("active");
      if ($('.hcrwtj .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
        $('.hcrwtj .select-wrapper .icon').attr("title", "收起查询条件");
      } else {
        $('.hcrwtj .select-wrapper .icon').attr("title", "展开查询条件")
      }
    },
    exform: function () {
      var self = this;
      if ($('#hcrwtj-table').jqGrid('getRowData').length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData)
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/dzba/export/inspect/stat");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form); //将表单放置在web中
      form.append(input1);
      form.submit();
      form.remove();
    },
    reset: function () {
      this.searchData = {
        swjg_dm: avalonRoot.user.swjgDm,
        inspectTimeStart: "",
        inspectTimeEnd: "",
        orderSql: "",
        pageSize: config.pageSize,
      };
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
    
    initTree:function() {
      var self = this;
      var setting = {
          callback:{
              onClick:function(e,id,node){
                  self.searchData.swjg_dm = node.id;
                  self.swjgmc = node.text;
                  self.hideTree();
                  return;
              },
              onDblClick:function(e,id,node){
                  self.searchData.swjg_dm = node.id;
                  self.swjgmc = node.text;
                  self.hideTree();
                  return;
              }
          },
          data:{key:{children:"item",name:"text"}}
      };

      ajax("POST","/cxfw/export/readtree",{nodeType:"3"}).done(function(res){
          if(res.code=='0'){
              $.fn.zTree.init($(".hcrwtj .treeDiv"), setting, res.data);
          }else{
              tools.info(res.msg)
          }
      }).fail(function(err){
          tools.info(err)
      })
    },
    showTree:function(e){
      var self=this;
      $(".treeDiv",$(e.target).parent()).show();
      $('.hcrwtj').on('click',function(e){
          var e=e||window.event;
          if($('.treeDiv').find($(e.target)).length<=0){
              self.hideTree();
          }

      })
    },
    hideTree:function(){
      $(".treeDiv").hide();
      $('.hcrwtj').off('click');
    },
  }
});