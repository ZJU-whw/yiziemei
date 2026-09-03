var ybqywh=require("./ybqywh.html");
avalon.component('ybqywh', {
  template:ybqywh,
  defaults: {
    params:{},
    swjgmc: '',
    searchDataQyfz: {
      orderSql: '',
      pageNo: 1
    },
    zid: '',
    qyfzRowId: 1,
    searchDataQyml: {
      nsrmc: '',
      nsrsbh: '',
      qyhgdm: '',
      orderSql: ''
    },
    searchDataYxqy: {
      orderSql: ''
    },
    modelData: {
      sname: '',
      syfwSwjg: ''
    },
    editData: {
      sname: '',
      qybz: ''
    },
    selRows: [],
    delRows: [],
    onReady:function(){
      try {
        this.modelData.syfwSwjg=avalonRoot.user.swjgDm;
        this.swjgmc=avalonRoot.user.swjgMc;
      } catch (e) {}
      this.initTree()
      this.initHeight()
      this.createTableQyfz()
      this.searchQyfz(1)
      this.createTableYxqy(1)
      this.importHandle()
    },
    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        $("#ybqywh-qyfz-table").jqGrid('setGridHeight', $(".ybqywh .qyfz").height() - 100);
        $("#ybqywh-yxqy-table").jqGrid('setGridHeight', $(".ybqywh .qyfz").height() - 100);
      })
    },
    initSwitchBtn: function(){
      $('.easyswitch').empty()
      $('.easyswitch').removeClass('on')
      $('.easyswitch').removeClass('off')
      $('.easyswitch').easyswitch()
    },
    // 样本企业分组表
    createTableQyfz:function(){
      var self=this;
      var columns = [
        { name: "zid", label: "zid", index: "zid", hidden: true },
        { name: "sname", label: "样本名称", index: "sname",width: 180, align:"center",sortable: false },
        { name: "syfwSwjg", label: "适用范围", index: "syfwSwjg",width: 120, align:"center",sortable: false },
        { name: "qybz", label: "启用标志", index: "qybz", hidden: true },
        { name: "qybzName", label: "是否启用", index: "qybzName",width: 80, align:"center",sortable: false, formatter:function(cellvalue, options, rowObject){
          var qybz = rowObject.qybz == 'Y' ? '是' : '否'
          return qybz;
        }},
        { name: "op", label:"操作", width: 120, align:"center", resizable: false, search: false, sortable: false,formatter: function(cellvalue, options, rowObject){
          return "<div class='btn op-btn edit' title='编辑'>编辑</div><div class='btn op-btn del' title='删除'>删除</div>";
        }}
      ]
      $("#ybqywh-qyfz-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers:true,
        pager: '#ybqywh-qyfz-tablePager',
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
          return $(".ybqywh .qyfz").height() - 100;
        })(),
        beforeSelectRow:function(rowid,e){
          var row = $('#ybqywh-qyfz-table').jqGrid('getRowData',rowid); 
          self.qyfzRowId = rowid
          if ($(e.target).hasClass('del')){
            tools.confirm('删除企业分组将同时移除企业分组下的企业，是否确认删除？','确定', function(){
              ajax("POST","/bjtssw/sjjc/nsr/sample/del",{zid: row.zid}).done(function(res){
                if(res.code=='0'){
                  self.searchQyfz(1);
                  self.qyfzRowId = 1
                } else {
                  tools.info(res.msg);
                }
              }).fail(function(err){
                tools.info(err);
              })
            })
            return true;
          } else if ($(e.target).hasClass('edit')){
            self.editData = {
              sname: row.sname,
              qybz: row.qybz == 'Y' ? 1 : 0,
              zid: row.zid
            }
            self.initSwitchBtn()
            $('.model').show();
            $('.ybqywh .page-model-edit').show();
            return true;
          }
          return true;
        },
        onSelectRow: function(rowid,status){
          var row = $('#ybqywh-qyfz-table').jqGrid('getRowData',rowid); 
          self.zid = row.zid
          self.searchYxqy(1)
        },
        onSortCol: function (index, iCol, sortorder) {
          self.searchDataQyfz.orderSql = index + ' ' + sortorder;
          self.searchQyfz(1);
          return;
        },
        onPaging:function(pgButton){
          var pageNo=tools.getPageNo(pgButton,"ybqywh-qyfz-table");
          self.searchDataQyfz.pageNo = pageNo
          self.searchQyfz(pageNo);
        }
      })
      $('.easyswitch').easyswitch()
    },
    // 已选企业表格
    createTableYxqy:function(){
      var self=this;
      var columns = [
        { name: "id", label: "id", index: "id", hidden: true },
        { name: "zid", label: "zid", index: "zid", hidden: true },
        { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: false },
        { name: "nsrmc", label: "	纳税人名称", index: "nsrmc",width: 180, align:"center",sortable: false }
      ]
      $("#ybqywh-yxqy-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers:true,
        pager: '#ybqywh-yxqy-tablePager',
        shrinkToFit: false,
        width:"100%",
        multiselect: true,
        multiselectWidth:"40",
        autowidth:true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        rowList: [20,50,100,500],
        height:(function(){
          return $(".ybqywh .qyfz").height() - 100;
        })(),
        beforeSelectRow:function(rowid,e){
          var row = $('#ybqywh-yxqy-table').jqGrid('getRowData',rowid); 
          
          return true;
        },
        onSortCol: function (index, iCol, sortorder) {
          self.searchDataYxqy.orderSql = index + ' ' + sortorder;
          self.searchYxqy(1);
          return;
        },
        onPaging:function(pgButton){
          var pageNo=tools.getPageNo(pgButton,"ybqywh-yxqy-table");
          self.searchYxqy(pageNo);
        },
        onSelectRow: function(rowid,status){
          var index = self.delRows.indexOf(rowid);
          if (status) {
            self.delRows.push(rowid)
          } else {
            self.delRows.splice(index,1);
          }
        },
        onSelectAll: function(rowids,status) {
          if (status) {
            self.delRows = JSON.parse(JSON.stringify(rowids));
          } else {
            self.delRows = [];
          }
        }
      })
    },
    // 企业分组列表
    searchQyfz:function(pageNo){
      var self = this
      var params = tools.clone(this.searchDataQyfz)
      params.pageSize = $(".qyfz .ui-pg-selbox", $('.ybqywh')).val() || 20
      params.pageNo = pageNo
      $("#ybqywh-qyfz-table").jqGrid('clearGridData')
      ajax("POST","/bjtssw/sjjc/nsr/sample",params).done(function(res){
        if(res.code=='0'){
          $("#ybqywh-qyfz-table")[0].addJSONData(res.data);
          if (res.data.rows.length>0) {
            $("#ybqywh-qyfz-table").jqGrid('setSelection', self.qyfzRowId)
          } else {
            self.zid = ''
            $("#ybqywh-yxqy-table").jqGrid('clearGridData')
          }
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    // 已选企业列表
    searchYxqy:function(pageNo){
      var self = this
      var params = tools.clone(this.searchDataYxqy)
      params.zid = this.zid
      params.pageSize = $(".yxqy .ui-pg-selbox", $('.ybqywh')).val() || 20
      params.pageNo = pageNo
      $("#ybqywh-yxqy-table").jqGrid('clearGridData')
      ajax("POST","/bjtssw/sjjc/nsr/sample/sub",params).done(function(res){
        if(res.code=='0'){
          $("#ybqywh-yxqy-table").resetSelection();
          $("#ybqywh-yxqy-table")[0].addJSONData(res.data);
          self.delRows = []
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    addQyfz: function(){
      $('.model').show();
      $('.ybqywh .page-model-add').show();
      this.modelData = {
        sname: '',
        syfwSwjg: avalonRoot.user.swjgDm
      }
    },
    saveModel: function(){
      var self = this
      ajax("POST","/bjtssw/sjjc/nsr/sample/add", this.modelData).done(function(res){
        if(res.code=='0'){
          tools.info('添加成功！')
          self.hideModel('page-model-add')
          self.searchQyfz(1)
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    saveEditModel: function(){
      var self = this
      var qybz = $('.ybqywh .onSwitch').hasClass('on') ? 'Y' : 'N'
      var params = {
        zid: this.editData.zid,
        sname: this.editData.sname,
        qybz: qybz,
      }
      ajax("POST","/bjtssw/sjjc/nsr/sample/update", params).done(function(res){
        if(res.code=='0'){
          tools.info('编辑成功！')
          self.hideModel('page-model-edit')
          self.searchQyfz(1)
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    hideModel: function(hideClass){
      $('.model').hide();
      $('.ybqywh .'+hideClass).hide();
    },
    delYxqy: function(){
      var self = this
      if (this.delRows.length <=0) {
        tools.info("请至少选择一条记录！");
        return false;
      }
      tools.confirm('是否确定移除选择的企业？', '确定', function(){
        var ids = []
        for (var i = 0; i < self.delRows.length;i++ ){
          let id = getCellData("ybqywh-yxqy-table", self.delRows[i], 'id')
          ids.push(id);
        }
        ajax("POST","/bjtssw/sjjc/nsr/sample/sub/del",{zid: self.zid,ids:ids}).done(function(res){
          if(res.code=='0'){
            tools.info('移除成功！')
            self.searchYxqy(1)
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      })
    },
    initTree:function() {
      var self = this;
      var setting = {
        callback:{
          onClick:function(e,id,node){
            self.modelData.syfwSwjg = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            return;
          },
          onDblClick:function(e,id,node){
            self.modelData.syfwSwjg = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            return;
          }
        },
        data:{key:{children:"item",name:"text"}}
      };
      ajax("POST","/cxfw/export/readtree",{nodeType:"3"}).done(function(res){
        if(res.code=='0'){
          $.fn.zTree.init($(".ybqywh .treeDiv"), setting, res.data);
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
      $('.ybqywh').on('click',function(e){
        var e=e||window.event;
        if($('.treeDiv').find($(e.target)).length<=0){
            self.hideTree();
        }
      })
    },
    hideTree:function(){
      $(".treeDiv").hide();
      $('.ybqywh').off('click');
    },
    beforeImport: function(){
      if (this.zid == '') {
        tools.info('请先选择企业样本！')
        $('#ybqywh-fileupload').attr('type', 'text')
        return;
      }
      $('#ybqywh-fileupload').attr('type', 'file')
    },
    importHandle: function(){
      var self = this
      $('#ybqywh-fileupload').fileupload({
        dataType: 'json',
        done: function (e, data) {
          if(data.result.code == "0"){
            tools.info("导入成功!");
            self.searchYxqy(1);
          }else{
            tools.info(data.result.msg);
          }
        }
      });
      $('#ybqywh-fileupload').bind('fileuploadsubmit', function (e, data) {
        data.formData = { zid: self.zid };  //如果需要额外添加参数可以在这里添加
      });
    },
    exportHandler: function(url, params){
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      // form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", url);
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form); //将表单放置在web中
      form.append(input1);
      form.submit();
      form.remove();
    },
    downMB: function(){
      this.exportHandler('/bjtssw/export/sjjcfx/qyxx/template', {})
    },
    exportYxqy: function(){
      if($('#ybqywh-yxqy-table').jqGrid('getRowData').length<=0){
        tools.info("已选企业为空！");
        return ;
      }
      var params = {
        zid: this.zid,
        pageNo: 1,
        pageSize: 9999
      }
      this.exportHandler('/bjtssw/export/sjjcfx/qyxx', params)
    }
  }
})