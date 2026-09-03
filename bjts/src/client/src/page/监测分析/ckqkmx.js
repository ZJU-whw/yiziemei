
var ckqkmx=require("./ckqkmx.html");
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component('ckqkmx', {
    template:ckqkmx,
    defaults: {
      params:{},
      act:1,
      tcode:"ckqkmx",
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
        {zbxmbm: 'dj.nsrlb', values: []},
        {zbxmbm: 'dj.hy', values: []},
        {zbxmbm: 'dj.ckqylx', values: []},
        {zbxmbm: 'dj.flglcd', values: []},
      ],
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.searchData = tools.clone(this.params.searchData)
        this.searchData.fzItems = this.searchData.fzItems.concat(this.defaultItems)
        this.searchData.tjbbType = 'x04'
        this.createTable();
      },
      createTable:function(){
        var self=this;
        var columns = [
          { name: "主管税务机关", label: "主管税务机关", index: "主管税务机关",width: 160, align:"left",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true)
            var node = fxjsCommonFun.getItemByIdInTree(val, self.params.swjgList)
            return node ? node.text : cellvalue;
          }},
          // { name: "退税机关", label: "退税机关", index: "退税机关",width: 90, align:"center",sortable: false, formatter:function(cellvalue, options, rowObject){
          //   return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          // }},
          { name: "社会信用代码", label: "统一社会信用代码", index: "社会信用代码",width: 140, align:"center",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "企业名称", label: "纳税人名称", index: "企业名称",width: 180, align:"left",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "纳税人类别", label: "纳税人类别", index: "纳税人类别",width: 140, align:"left",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "行业类型", label: "行业类型", index: "行业类型",width: 180, align:"left",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          } },
          { name: "出口企业类型", label: "出口企业类型", index: "出口企业类型",width: 180, align:"left",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "分类管理类别", label: "分类管理类别", index: "分类管理类别",width: 120, align:"center",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "出口销售（美元）", label: "本期出口额", index: "出口销售（美元）",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同期-0", label: "同期出口额", index: "同期-0",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-0", label: "同比变动", index: "同比-0",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "出口销售（可退税）", label: "本期可退税出口额", index: "出口销售（可退税）",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "出口销售（征税）", label: "征税商品出口额", index: "出口销售（征税）",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "出口销售（免税）", label: "免税商品出口额", index: "出口销售（免税）",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "出口销售（不退税）", label: "不退税贸易性质出口额", index: "出口销售（不退税）",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "小计", label: "小计", index: "小计",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var keys = Object.keys(rowObject)
            var hjKey = ['出口销售（征税）','出口销售（免税）','出口销售（不退税）']
            var sum = 0
            for (var i=0;i<keys.length;i++) {
              let keyName = keys[i].split('#')[0].split('_')[0]
              if (hjKey.indexOf(keyName) > -1) {
                sum += Number(rowObject[keys[i]])
              }
            }
            return avalon.filters.number(sum,2);
          }},
          { name: "出口销售（已申报退税）", label: "本期已申报出口额", index: "出口销售（已申报退税）",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "申报率", label: "申报率(%)", index: "申报率",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var keys = Object.keys(rowObject)
            var ysh = ''
            var kts = ''
            for (var i=0;i<keys.length;i++) {
              let keyName = keys[i].split('#')[0].split('_')[0]
              if (keyName == '出口销售（已申报退税）') {
                ysh = rowObject[keys[i]]
              } else if (keyName == '出口销售（可退税）') {
                kts = rowObject[keys[i]]
              }
            }
            var num = 0
            if (kts != 0) {
              num = ysh/kts *100
            }
            return avalon.filters.number(num,2);
          }},
        ];
        $("#ckqkmx-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            rownumWidth: 50,
            pager: '#ckqkmx-tablePager',
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
                return $(".ckqkmx .form").height() - 120;
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
              $("#ckqkmx-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
              self.searchData.orderSql = index + ' ' + sortorder;
              self.search(1);
              return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton,"ckqkmx-table");
              self.search(pageNo);
            }

        })
        $("#ckqkmx-table").jqGrid('setLabel','rn', '序号', {'text-align':'center'},'')
        $("#ckqkmx-table").jqGrid('setGroupHeaders', {
          useColSpanStyle: true,
          groupHeaders:[
            {startColumnName:'出口销售（征税）', numberOfColumns:4, titleText: '本期不退税出口额'}
          ]
        });
        this.searchData.pageSize = $(".ui-pg-selbox", $('.ckqkmx')).val();
        this.search(1)
      },
      search:function(pageNo){
        var self=this;
        this.searchData.pageSize = $(".ui-pg-selbox", $('.ckqkmx')).val() || 20;
        var params = tools.clone(this.searchData)
        params.pageNo=pageNo;
        $('.ckqkmx .mask').show()
        $("#ckqkmx-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/ckqk",params,true, false, true).done(function(res){
          $('.ckqkmx .mask').hide()
          if(res.code=='0'){
            self.total = res.data.list.count
            var data = tools.clone(res.data.list)
            if (self.total == 0) data.rows = []
            self.tableData=res.data;
            $("#ckqkmx-table")[0].addJSONData(data);
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          $('.ckqkmx .mask').hide()
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
        if($('#ckqkmx-table').jqGrid('getRowData').length<=0){
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
      }
    }
});