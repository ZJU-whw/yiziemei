var baml=require("./baml.html");
avalon.component('baml', {
  template:baml,
  defaults: {
    // dataList: [{},{},{}],
    // activeIndex: -1,
    // openChange(index) {
    //   this.activeIndex = this.activeIndex == index ? -1 : index
    // }
    params: {
      inspectNo: ''
    },
    isCreated: false,
    info: {},
    searchDataMl: {
      orderSql: "",
      pageSize: config.pageSize
    },
    searchDataDz: {
      firstId: '',
      orderSql: "",
      pageSize: config.pageSize
    },
    modelData: {
      id: '',
      inspectResult: '1',
      resultState: '',
      processType: ''
    },
    onInit:function(e){
      avalonRoot.baml = e.vmodel;
      this.getInfo()
    },
    onReady:function () {
    },
    createTableBaml:function(){
      var self=this;
      this.isCreated = true
      var columns = [
        { name: "id", label: "id", index: "id", hidden:true,width: 100, align:"left",sortable: true },
        { name: "catalogId", label: "catalogId", index: "catalogId", hidden:true,width: 100, align:"left",sortable: true },
        { name: "firstId", label: "firstId", index: "firstId", hidden:true,width: 100, align:"left",sortable: true },
        { name: "sbywzl", label: "退税申报业务种类", index: "sbywzl",width: 160, align:"center",sortable: true },
        { name: "sbnypc", label: "退税申报批次", index: "sbnypc",width: 100, align:"center",sortable: true },
        { name: "entryId", label: "报关单号/代理证明号", index: "entryId",width: 170, align:"center",sortable: true },
        { name: "ckfpNo", label: "出口发票号", index: "ckfpNo",width: 180, align:"left",sortable: true },
        { name: "jhfpNo", label: "进货发票号", index: "jhfpNo",width: 180, align:"left",sortable: true },
        { name: "result", label: "审核结果", hidden:true, index: "result",width: 90, align:"center",sortable: true },
        { name: "resultName", label: "审核结果", index: "resultName",width: 90, align:"center",sortable: true },
        { name: "resultState", label: "审核意见", index: "resultState",width: 120, align:"center",sortable: true },
        { name: "op", label:"操作", width:140, align:"center", resizable: false, search: false, sortable: false,formatter: function(cellvalue, options, rowObject){
          return "<div class='btn check "+(rowObject.result!='1' && rowObject.result!='2' &&  self.info.status == '3' ? "" : "disabled")+"' style='float: none;display: inline-block;' title='审核'>审核</div>" + "<div class='btn saw "+(self.info.status=='3'|| self.info.status=='4' ? "" : "disabled")+"' style='float: none;display: inline-block;' title='查看'>查看</div>";
        }}
      ];
      $("#baml-table").jqGrid({
          datatype: "local",
          gridview: true,
          colModel: columns,
          viewrecords: true,
          rownumbers:true,
          pager: '#baml-tablePager',
          shrinkToFit: false,
          width:"100%",
          // multiselect: true,
          // multiselectWidth:"30",
          autowidth:true,
          altRows: true,
          altclass: "altclasscss",
          lastsort: 1,
          rowNum: config.pageSize,
          rowList: [20,50,100,500],
          height:(function(){
              return $(".baml .form").height() -84;
          })(),
          beforeSelectRow:function(rowid,e){
            var result = getCellData("baml-table", rowid, 'result')
            if($(e.target).hasClass('check') && result != '1' && self.info.status == '3'){ // 审核
              self.showModel()
              self.modelData.id = getCellData("baml-table", rowid, 'id')
            } 
            if((self.info.status=='3'|| self.info.status=='4') && $(e.target).hasClass('saw')){ // 查看
              // self.showModelDzlist()
              var firstId = getCellData("baml-table", rowid, 'firstId')
              self.searchDz(firstId)
            } 
            return true
          },
          onSortCol: function (index, iCol, sortorder) {
              self.searchDataMl.orderSql = index + ' ' + sortorder;
              self.searchMl(1);
              return;
          },
          onPaging:function(pgButton){
            var pageNo=tools.getPageNo(pgButton,"baml-table");
            self.searchMl(pageNo);
          }

      })
      this.searchDataMl.pageSize = $(".ui-pg-selbox", $('.baml .list')).val();
      // self.search(1)
    },
    getInfo:function () {
      var self = this
      ajax("POST","/dzba/inspect/view/status",{inspectNo: this.params.inspectNo}).done(function(res){
        if(res.code=='0'){
          self.info = res.data
          if (!self.isCreated) {
            self.createTableBaml()
          }
          self.searchMl(1)
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    searchMl:function(pageNo){
      var self=this;
      this.searchDataMl.pageSize = $(".ui-pg-selbox", $('.baml .list')).val() || 20;
      var params=tools.clone(self.searchDataMl);
      params.pageNo=pageNo
      params.inspectNo = this.params.inspectNo
      $("#baml-table").jqGrid('clearGridData')
      ajax("POST","/dzba/inspect/view/first",params).done(function(res){
        if(res.code=='0'){
          $("#baml-table").resetSelection();
          $("#baml-table")[0].addJSONData(res.data);
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    searchDz:function(firstId){
      var self=this;
      var params={
        firstId: firstId
      }
      ajax("POST","/dzba/inspect/view/second",params).done(function(res){
        if(res.code=='0'){
          var params = res.data
          apiClient.baywManage(params)
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    showModel:function(){
      $('.model').show();
      $('.baml .page-model-check').show();
    },
    hideModel:function(){
      $('.model').hide();
      $('.baml .page-model-check').hide();
      this.modelData={
        id: '',
        inspectResult: '1',
        resultState: '',
        processType: ''
      }
    },
    saveModel:function () {
      var self = this
      if(!this.modelData.processType && this.modelData.inspectResult=='2'){
        tools.info('请选择处理类型。');
        return
      }
      if(!this.modelData.resultState && this.modelData.inspectResult=='2'){
        tools.info('请输入审核意见。');
        return
      }
      ajax("POST","/dzba/inspect/view/examine",this.modelData).done(function(res){
        if(res.code=='0'){
          tools.info('操作成功！')
          self.hideModel();
          self.searchMl(1)
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    createPdf (url) {
      var options = {
        pdfOpenParams: {
          navpanes: 0,
          toolbar: 0,
          statusbar: 0,
          view: "FitV",
          pagemode: "thumbs",
          page: 1
        },
        forcePDFJS: true,
        PDFJS_URL: "../../jdgl/static/pdfjs/web/viewer.html"
      };

      var myPDF = PDFObject.embed(url, "#baml-pdf", options);

      var el = document.querySelector("#results");
      el.setAttribute("class", (myPDF) ? "success" : "fail");
      el.innerHTML = (myPDF) ? "" : "Uh-oh, the embed didn't work.";
    },
    showModelPdf (id){
      $('.baml .page-model-pdf').show();
      var params = {
        bizType: 'inspect',
        bizKey: id
      }
      var self = this
      ajax("POST","/dzba/file/viewPdf",params).done(function(res){
        if(res.code=='0'){
          self.createPdf(res.data.fileUrl)
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    hideModelPdf:function(){
      $('.baml .page-model-pdf').hide();
    },
    changeRadio: function(){
      if (this.modelData.inspectResult == '1') {
        this.modelData.processType = ''
      }
    },
    exform:function(){
      var params = {inspectNo: this.params.inspectNo}
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/dzba/export/inspect/view/first");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form); //将表单放置在web中
      form.append(input1);
      form.submit();
      form.remove();
    },
  }
})