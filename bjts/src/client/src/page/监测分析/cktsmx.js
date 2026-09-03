
var cktsmx=require("./cktsmx.html");
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component('cktsmx', {
    template:cktsmx,
    defaults: {
      params:{},
      act:1,
      tcode:"cktsmx",
	    swjgmc: "",
      searchData:{
        swjgDm:"",
        ssnyStart: "",
        ssnyEnd: "",
        orderSql:"",
        pageSize:config.pageSize,
      },
      tableData:{},
      total: 0,
      defaultItems: [
        {zbxmbm: 'dj.nsrmc', values: []},
        {zbxmbm: 'dj.shxydm', values: []},
        {zbxmbm: 'dj.swjgdm', values: []},
      ],
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.searchData = tools.clone(this.params.searchData)
        this.searchData.fzItems = this.searchData.fzItems.concat(this.defaultItems)
        this.searchData.tjbbType = 'x03'
        this.createTable();
      },
      getSbrqTableCol:function(){
        var columns = [
          { name: "出口销售（美元）", label: "申报出口销售额（美元）", index: "出口销售（美元）",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-1", label: "同比%", index: "同比-1",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "计税金额（外贸）", label: "退税计税金额", index: "计税金额（外贸）",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-2", label: "同比%", index: "同比-2",width: 90, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "申报退免税额", label: "申报退（免）税额", index: "申报退免税额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-3", label: "同比%", index: "同比-3",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
        ];
        return columns;
      },
      getYwhzrqTableCol:function(){
        var columns = [
          { name: "核准退税额", label: "核准退税计税依据（人民币）", index: "核准退税额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-1", label: "同比%", index: "同比-1",width: 90, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "核准免抵额", label: "核准退（免）税额", index: "核准免抵额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-2", label: "同比%", index: "同比-2",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
        ];
        return columns;
      },
      createTable:function(){
        var self=this;
        var mxCol = [
          { name: "社会信用代码", label: "社会信用代码", index: "社会信用代码",width: 140, align:"center",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "企业名称", label: "企业名称", index: "企业名称",width: 180, align:"left",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "主管税务机关", label: "主管税务机关", index: "主管税务机关",width: 160, align:"left",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            var node = fxjsCommonFun.getItemByIdInTree(val, self.params.swjgList)
            return node ? node.text : cellvalue;
          }}
        ];
        var defaultColumns = this.params.tjlx == '0' ? this.getSbrqTableCol() : this.getYwhzrqTableCol()
        var columns = mxCol.concat(defaultColumns)
        $("#cktsmx-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            rownumWidth: 50,
            pager: '#cktsmx-tablePager',
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
                return $(".cktsmx .form").height() - 120;
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
              $("#cktsmx-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
                self.searchData.orderSql = index + ' ' + sortorder;
                self.search(1);
                return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton,"cktsmx-table");
              self.search(pageNo);
            }

        })
        $("#cktsmx-table").jqGrid('setLabel','rn', '序号', {'text-align':'center'},'')
        var groupHeaders = []
        if (this.params.tjlx == '0') {
          groupHeaders = [
            {startColumnName:'出口销售（美元）', numberOfColumns:2, titleText: '出口销售额（美元）'},
            {startColumnName:'计税金额（外贸）', numberOfColumns:2, titleText: '退税计税金额'},
            {startColumnName:'申报退免税额', numberOfColumns:2, titleText: '退（免）税额'}
          ]
        } else {
          groupHeaders = [
            {startColumnName:'核准退税额', numberOfColumns:2, titleText: '退税计税金额'},
            {startColumnName:'核准免抵额', numberOfColumns:2, titleText: '退（免）税额'}
          ]
        }
        $("#cktsmx-table").jqGrid('setGroupHeaders', {
          useColSpanStyle: true,
          groupHeaders: groupHeaders
        });
        this.searchData.pageSize = $(".ui-pg-selbox", $('.cktsmx')).val();
        this.search(1)
      },
      search:function(pageNo){
        var self=this;
        this.searchData.pageSize = $(".ui-pg-selbox", $('.cktsmx')).val() || 20;
        var params = tools.clone(this.searchData)
        params.pageNo=pageNo;
        $('.cktsmx .mask').show()
        $("#cktsmx-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/dynamic",params, true, false, true).done(function(res){
          $('.cktsmx .mask').hide()
          if(res.code=='0'){
            self.total = res.data.list.count
            var data = tools.clone(res.data.list)
            if (self.total == 0) data.rows = []
            self.tableData=res.data;
            $("#cktsmx-table")[0].addJSONData(data);
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          $('.cktsmx .mask').hide()
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
        if($('#cktsmx-table').jqGrid('getRowData').length<=0){
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