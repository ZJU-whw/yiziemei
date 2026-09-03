var historyTable=require("./historyTable.html");
avalon.component('historyTable', {
  template:historyTable,
  defaults: {
    params:{},
    parent: '',
    tjbbType: '',
    searchData: {
      orderSql: 'crtime desc',
      pageSize: 20
    },
    onInit:function(e){
      avalonRoot.historyTable = e.vmodel;
    },
    onReady: function(){
      this.createHistoryTable()
    },
    showModel: function(){
      $('.model').show()
      $('.historyTable .page-model-history').show()
      this.searchHistory(1)
    },
    hideModel: function(){
      $('.model').hide()
      $('.historyTable .page-model-history').hide()
    },
    createHistoryTable: function(){
      var self=this;
      var columns = [
        { name: "reqParam", label: "查询条件", index: "reqParam", hidden: true },
        { name: "title", label: "标题", index: "title", width: 340, align:"left" },
        { name: "czryDm", label: "操作人员", index: "czryDm", width: 100, align:"center" },
        { name: "crtime", label: "查询时间", index: "crtime",width: 140, align:"center" },
        { name: "taskFlagName", label: "任务状态", index: "taskFlagName",width: 80, align:"center", formatter: function(cellvalue, options, rowObject){
          return rowObject.taskFlag == '2' ? '处理完成':'处理中'
        }},
        { name: "op", label:"操作", width:80, align:"center", sortable: false,formatter: function(cellvalue, options, rowObject){
          return "<div class='btn op-btn use "+ (rowObject.taskFlag == '2' ? "" : "disabled") +"' title='查看'>查看</div>"
        }},
      ]
      var id = this.parent+'-historyTable-table'
      $('#'+id).jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers:true,
        pager: '#'+id+'Pager',
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
          return $(".historyTable .page-model-history .model-content").height() -60;
        })(),
        beforeSelectRow:function(rowid,e){
          var row = $('#'+id).getRowData(rowid)
          if($(e.target).hasClass('disabled')) return;
          if($(e.target).hasClass('use')){
            var reqParam = JSON.parse(row.reqParam)
            avalonRoot[self.parent].recordsHandler(reqParam)
            self.hideModel()
          }
          return true;
        },
        onSortCol: function (index, iCol, sortorder) {
          self.searchData.orderSql = index + ' ' + sortorder;
          self.searchHistory(1);
          return;
        },
        onPaging:function(pgButton){
          var pageNo=tools.getPageNo(pgButton,id);
          self.searchHistory(pageNo);
        }
      })
      $("#"+id).jqGrid('setFrozenColumns');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.historyTable .page-model-history')).val();
    },
    searchHistory: function(pageNo){
      var id = this.parent+'-historyTable-table'
      var params = {
        tjbbType: this.tjbbType,
        orderSql: this.searchData.orderSql,
        pageNo: pageNo,
        pageSize: $(".ui-pg-selbox", $('.historyTable')).val() || 20
      }
      $("#"+id).jqGrid('clearGridData')
      ajax("POST","/bjtssw/sjjc/task/records",params).done(function(res){
        if(res.code=='0'){
          $("#"+id)[0].addJSONData(res.data);
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    }
  }
})