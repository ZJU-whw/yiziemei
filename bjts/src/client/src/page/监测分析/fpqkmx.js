
var fpqkmx=require("./fpqkmx.html");
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component('fpqkmx', {
    template:fpqkmx,
    defaults: {
      params:{},
      act:1,
      tcode:"fpqkmx",
	    swjgmc: "",
      searchData:{
        swjgDm:"",
        ssnyStart: "",
        ssnyEnd: "",
        hzItems: ['fp.fp_xxje_ck','fp.fp_xxje_zy','fp.fp_jxje_zy','fp.fp_jxje_dianfei','fp.fp_xxje_dianfei'],
        fzItems: [],
        isHaveTb: '1',
        orderSql:"",
        pageNo: 1,
        pageSize:config.pageSize,
      },
      tableData:{
        hj: {}
      },
      total: 0,
      title: [],
      defaultItems: [
        { zbxmbm: "dj.shxydm", values: []},
        { zbxmbm: "dj.nsrmc", values: []},
      ],
      trendTitle: ['出口金额'], // 表头动态部分
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.tableHeight = $(".fpqkmx .form").height() - 90
        this.searchData = tools.clone(this.params)
        this.searchData.hzItems = ['fp.fp_xxje_ck','fp.fp_xxje_zy','fp.fp_jxje_zy','fp.fp_jxje_dianfei','fp.fp_xxje_dianfei']
        this.searchData.fzItems = this.searchData.fzItems.concat(this.defaultItems)
        this.searchData.tjbbType = 'x05'
        this.search(1)
      },
      getColumns: function(){
        var self = this
        var defaultColumns = [
          { name: "社会信用代码", label: "统一社会信用代码", index: "社会信用代码",width: 140, align:"center",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "企业名称", label: "纳税人名称", index: "企业名称",width: 180, align:"left",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "发票出口金额", label: "本期出口额", index: "发票出口金额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "发票内销金额", label: "本期内销金额", index: "发票内销金额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "发票购进金额", label: "本期购进金额", index: "发票购进金额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "用电金额", label: "用电金额", index: "用电金额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var keys = Object.keys(rowObject)
            var jxdf = 0, xxdf = 0
            for (var i=0;i<keys.length;i++) {
              let keyName = keys[i].split('#')[0].split('_')[0]
              if (keyName == '进项电费') jxdf = rowObject[keys[i]]
              if (keyName == '销项电费') xxdf = rowObject[keys[i]]
            }
            var je = jxdf - xxdf
            return avalon.filters.number(je,2);
          }},
        ]
        // return defaultColumns
        var defaultTitle = defaultColumns.map(function(item,index,arr){return item.name})
        var trendColumsLen = this.title.length - 5
        var trendColumns = fxjsCommonFun.getTrendColumns(this.tableData.list.rows, this.title, defaultTitle, trendColumsLen)
        var columns = trendColumns.concat(defaultColumns)   
        return columns
      },
      createTable:function(){
        var self=this;
        var columns = this.getColumns();
        $("#fpqkmx-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            rownumWidth: 50,
            pager: '#fpqkmx-tablePager',
            shrinkToFit: false,
            width:"100%",
            // multiselect: true,
            // multiselectWidth:"30",
            autowidth:true,
            altRows: true,
            footerrow:true,
            altclass: "altclasscss",
            lastsort: 1,
            rowNum: config.pageSize,
            rowList: [20,50,100,500],
            height:(function(){
                return self.tableHeight;
            })(),
            beforeSelectRow:function(rowid,e){
              if($(e.target).hasClass('check')){ // 查看
              
              } 
              return true;
            },
            gridComplete: function(){
              var sumData = {}
              for (var key in self.tableData.hj) {
                let name = key.split('#')[0].split('_')[0]
                sumData[name] = self.tableData.hj[key] == undefined ? '' : self.tableData.hj[key]
              }
              sumData['rn']="合计";
              $("#fpqkmx-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
                self.searchData.orderSql = index + ' ' + sortorder;
                self.search(1);
                return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton,"fpqkmx-table");
              self.search(pageNo);
            }

        })
        $("#fpqkmx-table").jqGrid('setLabel','rn', '序号', {'text-align':'center'},'')
        this.searchData.pageSize = $(".ui-pg-selbox", $('.fpqkmx')).val();
      },
      getFormatter: function(rowObject, name, notNumber){
        var keys = Object.keys(rowObject)
        for (var i=0;i<keys.length;i++) {
          let keyName = keys[i].split('#')[0].split('_')[0]
          if (keyName == name) {
            if (notNumber) {
              return rowObject[keys[i]]
            } else {
              return avalon.filters.number(rowObject[keys[i]],2);
            }
          }
        }
        return avalon.filters.number(rowObject[name],2);
      },
      search:function(pageNo){
        var self=this;
        this.searchData.pageSize = $(".ui-pg-selbox", $('.fpqkmx')).val() || 20;
        var params = tools.clone(this.searchData)
        params.pageNo=pageNo;
        $('.fpqkmx .mask').show()
        $("#fpqkmx-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/dynamic",params,true, false, true).done(function(res){
          $('.fpqkmx .mask').hide()
          if(res.code=='0'){
            self.title = res.data.title
            var spliceArr = ['户数','同比-0','同比-1','同比-2','同比-3','同比-4','同比-5','进项电费','销项电费']
            var tmpTitle = self.title.map(function(item){
              return item.split('#')[0].split('_')[0]
            })
            for (var i=0;i<spliceArr.length;i++) {
              let index = tmpTitle.indexOf(spliceArr[i])
              if (index>-1) {
                tmpTitle.splice(index,1)
                self.title.splice(index,1)
              }
            }
            self.total = res.data.list.count
            var data = tools.clone(res.data.list)
            if (self.total == 0) data.rows = []
            self.tableData=res.data;
            self.createTable()
            $("#fpqkmx-table")[0].addJSONData(data);
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          $('.fpqkmx .mask').hide()
          tools.info(err);
        })
      },
	    reset: function() {
		    this.searchData = {
          swjgDm:avalonRoot.user.swjgDm,
          ssnyStart: new Date().getFullYear() + '01',
          ssnyEnd: tools.getMonth(),
          orderSql:"",
          pageSize:config.pageSize,
        };
		    this.swjgmc = avalonRoot.user.swjgMc;
        this.checkList = []
	    },
      exform:function(){
        if($('#fpqkmx-table').jqGrid('getRowData').length<=0){
          tools.info("无导出数据！");
          return ;
        }
        var self=this;
        var params = tools.clone(self.searchData);
        var form = $("<form>"); //定义一个form表单
        form.attr("style", "display:none");
        // form.attr("target", "hiddenframe");
        // form.attr("target", "_blank")
        form.attr("method", "post");
        form.attr("action", "/bjtssw/sjjc/saveDynamicExcel");
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
});