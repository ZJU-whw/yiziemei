
var cwqkmx=require("./cwqkmx.html");
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component('cwqkmx', {
    template:cwqkmx,
    defaults: {
      params:{},
      act:1,
      tcode:"cwqkmx",
	    swjgmc: "",
      searchData:{
        swjgDm:"",
        ssnyStart: "",
        ssnyEnd: "",
        orderSql:"",
        pageSize:config.pageSize,
      },
      tableData:{
        hj: {}
      },
      total: 0,
      title: [],
      defaultItems: [
        {zbxmbm: 'dj.nsrmc', values: []},
        {zbxmbm: 'dj.shxydm', values: []}
      ],
      tableHeight: '',
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.tableHeight = $(".cwqkmx .form").height() - 90
        this.searchData = tools.clone(this.params)
        this.searchData.fzItems = this.searchData.fzItems.concat(this.defaultItems)
        this.searchData.tjbbType = 'x06'
        this.createTable()
        this.search(1)
      },
      getColumns: function(){
        var self = this
        var defaultColumns = [
          { name: "社会信用代码", label: "统一社会信用代码", index: "社会信用代码",width: 140, align:"center",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "企业名称", label: "纳税人名称", index: "企业名称",width: 180, align:"center",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "主营业务收入", label: "主营业务收入", index: "主营业务收入",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "主营业务成本", label: "主营业务成本", index: "主营业务成本",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "营业税金及附加", label: "营业税金及附加", index: "营业税金及附加",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "销售费用", label: "销售费用", index: "销售费用",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "管理费用", label: "管理费用", index: "管理费用",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "财务费用", label: "财务费用", index: "财务费用",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "利润总额", label: "利润总额", index: "利润总额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "净利润", label: "净利润", index: "净利润",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "社保缴纳人数", label: "社保缴费人数", index: "社保缴纳人数",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "社保缴纳基数", label: "社保缴费基数", index: "社保缴纳基数",width: 120, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "毛利率", label: "毛利率（%）", index: "毛利率",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var keys = Object.keys(rowObject)
            var income = 0, cost = 0
            for (var i=0;i<keys.length;i++) {
              let keyName = keys[i].split('#')[0].split('_')[0]
              if (keyName == '主营业务收入') income = rowObject[keys[i]]
              if (keyName == '主营业务成本') cost = rowObject[keys[i]]
            }
            var je = (income - cost) / income * 100
            return avalon.filters.number(je,2);
          }},
          { name: "成本费用利润率", label: "成本费用利润率（%）", index: "成本费用利润率",width: 120, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var keys = Object.keys(rowObject)
            var obj = {
              '利润总额': 0,
              '主营业务成本': 0,
              '销售费用': 0,
              '管理费用': 0,
              '财务费用': 0
            }
            for (var i=0;i<keys.length;i++) {
              let keyName = keys[i].split('#')[0].split('_')[0]
              obj[keyName] = rowObject[keys[i]]
            }
            var je = obj['利润总额'] / (obj['主营业务成本']+obj['销售费用']+obj['管理费用']+obj['财务费用']) * 100
            return avalon.filters.number(je,2);
          }},
          { name: "销售净利率", label: "销售净利率（%）", index: "销售净利率",width: 120, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var keys = Object.keys(rowObject)
            var obj = {
              '净利润': 0,
              '销售费用': 0
            }
            for (var i=0;i<keys.length;i++) {
              let keyName = keys[i].split('#')[0].split('_')[0]
              obj[keyName] = rowObject[keys[i]]
            }
            var je = obj['净利润'] / obj['销售费用'] * 100
            return avalon.filters.number(je,2);
          }},
        ]
        return defaultColumns
      },
      createTable:function(){
        var self=this;
        var columns = this.getColumns();
        $("#cwqkmx-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            rownumWidth: 50,
            pager: '#cwqkmx-tablePager',
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
              return true;
            },
            gridComplete: function(){
              var sumData = {}
              for (var key in self.tableData.hj) {
                let name = key.split('#')[0].split('_')[0]
                sumData[name] = self.tableData.hj[key] == undefined ? '' : self.tableData.hj[key]
              }
              sumData['rn']="合计";
              $("#cwqkmx-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
                self.searchData.orderSql = index + ' ' + sortorder;
                self.search(1);
                return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton,"cwqkmx-table");
              self.search(pageNo);
            }

        })
        $("#cwqkmx-table").jqGrid('setLabel','rn', '序号', {'text-align':'center'},'')
        this.searchData.pageSize = $(".ui-pg-selbox", $('.cwqkmx')).val();
      },
      search:function(pageNo){
        var self=this;
        this.searchData.pageSize = $(".ui-pg-selbox", $('.cwqkmx')).val() || 20;
        var params = tools.clone(this.searchData)
        params.pageNo=pageNo;
        $('.cwqkmx .mask').show()
        $("#cwqkmx-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/dynamic",params,true,false,true).done(function(res){
          $('.cwqkmx .mask').hide()
          if(res.code=='0'){
            self.title = res.data.title
            self.total = res.data.list.count
            var data = tools.clone(res.data.list)
            if (self.total == 0) data.rows = []
            self.tableData=res.data;
            $("#cwqkmx-table")[0].addJSONData(data);
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          $('.cwqkmx .mask').hide()
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
        if($('#cwqkmx-table').jqGrid('getRowData').length<=0){
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