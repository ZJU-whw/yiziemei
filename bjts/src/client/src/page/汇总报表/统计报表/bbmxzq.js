var bbmxzq=require("./bbmxzq.html");
avalon.component('bbmxzq', {
  template:bbmxzq,
  defaults: {
    params:{
      bbdm: '',
      bblc: '',
      ssny: '',
      location: ''
    },
    searchData: {},
    cols: [],
    title: {},
    total: 0,
    onReady: function(){
      this.search(1, true)
    },
    createTable:function(){
      var self=this;
      var columns = []
      var keys = this.title
      for (var i=0;i<this.cols.length;i++) {
        for(var j=0;j<keys.length;j++) {
          var item = keys[j]
          var keyArr = item.split('_')
          var temp = keyArr[0]
          var contentWidth = this.textSize(this.cols[i][item]).width + 20
          var keyWidth = this.textSize(temp).width + 20
          contentWidth = contentWidth < 100 ? 100 : contentWidth
          keyWidth = keyWidth < 100 ? 100 : keyWidth
          var width = contentWidth < keyWidth ? keyWidth : contentWidth
          if (columns.length < keys.length) {
            var align = keyArr[1] == '左' ? 'left' : (keyArr[1] == '右' ? 'right' : 'center')
            var obj = {name: item, label: temp, index: item, width: width, align: align, sortable: false}
            columns.push(obj)
          } else {
            if (columns[j].width < width) {
              columns[j].width = width
            }
          }
        }
      }
      $("#bbmxzq-table").jqGrid({
          datatype: "local",
          gridview: true,
          colModel: columns,
          viewrecords: true,
          rownumbers:true,
          pager: '#bbmxzq-tablePager',
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
              return $(".bbmxzq .form").height() -60;
          })(),
          beforeSelectRow:function(rowid,e){
            return;
          },
          onSortCol: function (index, iCol, sortorder) {
              self.searchData.orderSql = index + ' ' + sortorder;
              self.search(1);
              return;
          },
          onPaging:function(pgButton){
            var pageNo=tools.getPageNo(pgButton,"bbmxzq-table");
            self.search(pageNo);
          }

      })
      this.searchData.pageSize = $(".ui-pg-selbox", $('.bbmxzq')).val();
    },
    textSize: function(text) {
      var span = document.createElement("span");
      var result = {};
      result.width = span.offsetWidth;
      result.height = span.offsetWidth; 
      span.style.visibility = "hidden";
      document.body.appendChild(span);
      if (typeof span.textContent != "undefined")
          span.textContent = text;
      else span.innerText = text;
      result.width = span.offsetWidth - result.width;
      result.height = span.offsetHeight - result.height;
      span.parentNode.removeChild(span);
      return result;
    },
    search:function(pageNo, isFirst){
      var self=this;
      this.searchData.pageSize = $(".ui-pg-selbox", $('.bbmxzq')).val() || 20;
      var params={
        bblc: this.params.bblc,
        bbdm: this.params.bbdm,
        ssny: this.params.ssny,
        location: this.params.location,
        pageSize: this.searchData.pageSize,
        pageNo: pageNo
      }
      $("#bbmxzq-table").jqGrid('clearGridData')
      ajax("POST","/bjtssw/tjbb/loaddata/dynamic",params).done(function(res){
        if(res.code=='0'){
          self.title = res.data.title
          self.cols = res.data.list.rows
          if (isFirst) {
            self.createTable()
          }
          $("#bbmxzq-table").clearGridData();
          $("#bbmxzq-table").resetSelection();
          self.total = res.data.list.count
          var data = self.total == 0 ? [] : res.data.list
          $("#bbmxzq-table")[0].addJSONData(data);
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    exform:function(){

      var self=this;
      var params = {
        bbdm: this.params.bbdm,
        bblc: this.params.bblc,
        ssny: this.params.ssny,
        location: this.params.location,
        pageSize: this.total,
        pageNo: 1
      }
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/bjtssw/tjbb/saveDynamicExcel");
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