var fhhctj = require("./fhhctj.html");
avalon.component('fhhctj', {
  template: fhhctj,
  defaults: {
    swjgmc: "",
    searchData: {
      swjg_dm: "",
      qyhgdm: "",
      nsrsbh: "",
      nsrmc: "",
      examineTimeStart: "",
      examineTimeEnd: "",
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
      this.initDate();
      this.initHeight();
      this.initTree()
      this.createTable();
    },

    // 初始化时间输入框
    initDate: function () {
      $('.fhhctj .datepicker').datepicker({
        dateFormat: 'yy-mm-dd'
      });
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        $("#fhhctj-table").jqGrid('setGridHeight', $(".fhhctj .form").height() - 60);
      })
    },

    createTable: function () {
      var self = this;
      var columns = [
        { name: "id", label: "id", index: "id", hidden: true, width: 100, align: "left", sortable: true },
        { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh", width: 140, align: "center", sortable: true },
        { name: "nsrmc", label: "企业名称", index: "nsrmc", width: 180, align: "center", sortable: true },
        { name: "gllb", label: "管理类别", index: "gllb", width: 60, align: "center", sortable: true },
        { name: "tsjsfs", label: "退税方式", index: "tsjsfs", width: 70, align: "center", sortable: true },
        { name: "hccs", label: "核查次数", index: "hccs", width: 70, align: "right", sortable: true },
        { name: "jlzc", label: "结论正常", index: "jlzc", width: 70, align: "right", sortable: true },
        { name: "jlyc", label: "结论异常", index: "jlyc", width: 70, align: "right", sortable: true },
        { name: "hcywbs", label: "核查业务笔数", index: "hcywbs", width: 80, align: "right", sortable: true },
        { name: "zcbs", label: "正常笔数", index: "zcbs", width: 70, align: "right", sortable: true },
        { name: "ycbs", label: "异常笔数", index: "ycbs", width: 70, align: "right", sortable: true },
        { name: "tmse", label: "退免税额", index: "tmse", width: 130, align: "right", sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} },
        { name: "yctse", label: "异常退税额", index: "yctse", width: 130, align: "right", sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} },
      ];
      $("#fhhctj-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#fhhctj-tablePager',
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
          return $(".fhhctj .form").height() - 60;
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
          var pageNo = tools.getPageNo(pgButton, "fhhctj-table");
          self.search(pageNo);
        }

      })
      this.searchData.pageSize = $(".ui-pg-selbox", $('.fhhctj')).val();
      // self.search(1)
    },
    search: function (pageNo) {
      var self = this;
      var dateValid = tools.checkDate(this.searchData.examineTimeStart, this.searchData.examineTimeEnd)
      if (!dateValid) {
        tools.info('审核时间截止时间必须大于起始时间')
        return false
      }
      var fields = [
        { name: "qyhgdm", rules: 'max_length[10]', message: "企业海关代码最大长度为10" },
        { name: "nsrmc", rules: 'max_length[30]', message: "企业名称最大长度为30" },
      ];
      var isValid = tools.validate("fhhctj-form", fields);
      if (isValid) {
        this.searchData.pageSize = $(".ui-pg-selbox", $('.fhhctj')).val() || 20;
        var params = tools.clone(self.searchData);
        params.pageNo = pageNo
        $("#fhhctj-table").jqGrid('clearGridData')
        ajax("POST", "/dzba/inspect/stat/separate/list", params).done(function (res) {
          if (res.code == '0') {
            $("#fhhctj-table").resetSelection();
            $("#fhhctj-table")[0].addJSONData(res.data);
            self.tableData = res.data;
            self.closeHyper()
          } else {
            tools.info(res.msg);
          }
        }).fail(function (err) {
          tools.info(err);
        })
      }
    },
    showHyper: function () {
      $('.fhhctj .select-sub').toggle();
      $('.fhhctj .select-wrapper .icon').toggleClass("active");
      if ($('.fhhctj .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
        $('.fhhctj .select-wrapper .icon').attr("title", "收起查询条件");
      } else {
        $('.fhhctj .select-wrapper .icon').attr("title", "展开查询条件")
      }
    },
    closeHyper:function(){
      $('.fhhctj .select-sub').hide();
      $('.fhhctj .select-wrapper .icon').removeClass('active');
      $('.fhhctj .select-wrapper .icon').attr("title","展开查询条件")
    },
    exform: function () {
      var self = this;
      if ($('#fhhctj-table').jqGrid('getRowData').length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData)
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/dzba/export/inspect/stat/separate");
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
        qyhgdm: "",
        nsrsbh: "",
        nsrmc: "",
        examineTimeStart: "",
        examineTimeEnd: "",
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
              $.fn.zTree.init($(".fhhctj .treeDiv"), setting, res.data);
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
      $('.fhhctj').on('click',function(e){
          var e=e||window.event;
          if($('.treeDiv').find($(e.target)).length<=0){
              self.hideTree();
          }

      })
    },
    hideTree:function(){
      $(".treeDiv").hide();
      $('.fhhctj').off('click');
    },
  }
});