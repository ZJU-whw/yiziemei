

var ckqytsywxx=require("./ckqytsywxx.html");
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component('ckqytsywxx', {
    template:ckqytsywxx,
    defaults: {
      params:{},
      act:1,
      tcode:"ckqytsywxx",
	    swjgmc: "",
      searchData:{
        swjgDm:"",
        ssnyStart: "",
        ssnyEnd: "",
        fzItems: [],
        tjbbType: '07',
        orderSql:"",
        pageNo: 1,
        pageSize:config.pageSize,
      },
      tableData:{},
      exformParams: {}, // 导出参
      tsywObj: {},
      tsyw: {
        value: [],
        name: ''
      },
      dateCrossYearFlag: '',
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.getTsywList()
        this.createTable()
        this.initTree()
        this.initDate()
        this.search(1)
        this.getDateCrossYearFlag()
      },
      getDateCrossYearFlag: function(){
        var self = this
        ajax("POST","/bjtssw/sjjc/param/init").done(function(res){
          if(res.code=='0'){
            self.dateCrossYearFlag = res.data.dateCrossYearFlag
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      initDate: function(){
        $('.ckqytsywxx .datepicker.date-month').datetimepicker({
          language:'zh-CN',
          format: 'yyyymm',
          weekStart: 1,
          // todayBtn: true,
          // clearBtn: true,
          autoclose: 1,
          todayHighlight: 1,
          startView: 3, // 这里就设置了默认视图为年视图
          minView: 3, // 设置最小视图为年视图
          forceParse: 0,
        }).on('show',function(e){
          var val = e.target.value
          var date = val.substr(0,4) + '-' + val.substr(4,2)
          $(e.target).datetimepicker('update', date)
        })
        this.searchData.ssnyStart = new Date().getFullYear() + '01'
        this.searchData.ssnyEnd = tools.getMonth()
      },
      getTsywList: function(){
        var self = this
        ajax("POST","/bjtssw/sjjc/dynamic/init/other", {zbxms: ['cx.tsyw']}).done(function(res){
          if(res.code=='0'){
            var fzItemsOther = res.data.fzItemsOther
            self.tsywObj = fzItemsOther.find(function(item){return item.zbxmbm == 'cx.tsyw'})
            self.initMultiselect(self.tsywObj)
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      // 多选下拉框
      initMultiselect: function(item){
        var self = this
        let id = '#ckqytsywxx_select_cx_tsyw'
        let options = []
        for(var i=0;i<item.values.length;i++) {
          let tmp = item.values[i]
          options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: false})
        }
        $(id).multiselect({
          nonSelectedText: '',
          nSelectedText: '项已选择',
          allSelectedText: '全部选中',
          onChange: function(option, checked, select) {
            let val = $(option).val()
            let values = self.tsyw.value
            if (checked) {
              values.push(val)
            } else {
              let i = values.indexOf(val)
              values.splice(i,1)
            }
            self.tsyw.value = values
          }
        });
        $(id).multiselect('dataprovider', options);
      },
      getColumns: function(){
        var defaultColumns = [
          { name: "退税机关代码", label: "退税税务机关代码", index: "退税机关",width: 120, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
          }},
          { name: "特殊业务", label: "特殊业务", index: "特殊业务",width: 120, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return '<span class="toMx link">'+val+'</span>';
          }},
          { name: "申报出口额（美元）", label: "申报出口额", index: "申报出口额（美元）",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-0", label: "同比增减幅%（±）", index: "同比-0",width: 110, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "申报出口额（人民币）", label: "申报出口额", index: "申报出口额（人民币）",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-1", label: "同比增减幅%（±）", index: "同比-1",width: 110, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "申报退（免）税额", label: "申报退（免）税额", index: "申报退（免）税额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-2", label: "同比增减幅%（±）", index: "同比-2",width: 110, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "业务核准退（免）税额", label: "业务核准退（免）税额", index: "业务核准退（免）税额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-3", label: "同比增减幅%（±）", index: "同比-3",width: 110, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
        ]
        return defaultColumns
      },
      createTable:function(){
        var self = this
        var columns = this.getColumns()
        $("#ckqytsywxx-table").jqGrid({
          datatype: "local",
          gridview: true,
          colModel: columns,
          viewrecords: true,
          rownumbers:true,
          pager: '#ckqytsywxx-tablePager',
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
              return $(".ckqytsywxx .form").height() - 100;
          })(),
          beforeSelectRow:function(rowid,e){
            var fzhash = $('#zhzbfzhztj-table').getRowData(rowid).fzhash
            var datas = self.tableData.list.rows
            var row = datas.find(function(item){
              return item.fzhash == fzhash
            })
            if($(e.target).hasClass('toMx')){
              var fzItems = []
              for (var i=0;i<self.exformParams.fzItems.length;i++) {
                let item = self.exformParams.fzItems[i]
                var val = ''
                for (var j=0;j<self.allSelectList.length;j++) {
                  let tmp = self.allSelectList[j]
                  if (item.zbxmbm == tmp.zbxmbm) {
                    val = row[self.allSelectList[j].zbxmmc].split('-')[0]
                    fzItems.push({zbxmbm: item.zbxmbm, values: [val]})
                    break;
                  }
                }
              }
              var params = tools.clone(self.exformParams)
              params.fzItems = fzItems
              params.flushFlag = '0'
              var params = tools.clone(self.exformParams)
              avalonRoot.addTab({title:"企业发票情况明细表",component:"fpqkmx",params:params});
              return true;
            }
            return true;
          },
          onSortCol: function (index, iCol, sortorder) {
            self.searchData.orderSql = index + ' ' + sortorder;
            self.search(1);
            return;
          },
          onPaging:function(pgButton){
            var pageNo=tools.getPageNo(pgButton, 'ckqytsywxx-table');
            self.search(pageNo);
          }
        })
        $("#ckqytsywxx-table").jqGrid('setGroupHeaders', {
          useColSpanStyle: true,
          groupHeaders: [
            {startColumnName:'申报出口额（美元）', numberOfColumns:2, titleText: '申报出口额（美元）'},
            {startColumnName:'申报出口额（人民币）', numberOfColumns:2, titleText: '申报出口额（人民币）'},
            {startColumnName:'申报退（免）税额', numberOfColumns:2, titleText: '申报退（免）税额'},
            {startColumnName:'业务核准退（免）税额', numberOfColumns:2, titleText: '业务核准退（免）税额'},
          ]
        });
        this.searchData.pageSize = $(".ui-pg-selbox", $('.ckqytsywxx')).val();
      },
      search:function(pageNo){
        var self=this;
        if (this.dateCrossYearFlag == '0') { // 不允许跨年
          let startY = this.searchData.ssnyStart.substr(0,4)
          let endY = this.searchData.ssnyEnd.substr(0,4)
          if (startY != endY){
            tools.info('查询统计【同比】数据，时间区间请选择同一年份')
            return false
          }
        }
        var dateValid = tools.checkDate(this.searchData.ssnyStart, this.searchData.ssnyEnd)
        if (!dateValid) {
          tools.info('统计日期截止时间必须大于起始时间')
          return false
        }
        var fzItems = []
        if (this.tsyw.value.length>0) {
          fzItems.push({
            zbxmbm: 'cx.tsyw',
            values: this.tsyw.value
          })
        }
        this.searchData.fzItems = fzItems
        this.searchData.pageNo = pageNo
        this.searchData.pageSize = $(".ui-pg-selbox", $('.ckqytsywxx')).val() || 20;
        this.exformParams = tools.clone(this.searchData)
        var params = tools.clone(this.searchData)
        $("#ckqytsywxx-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/tsywxx",params).done(function(res){
          if(res.code=='0'){
            self.total = res.data.list.count
            var data = tools.clone(res.data.list)
            if (self.total == 0) data.rows = []
            self.tableData=tools.clone(res.data);
            $("#ckqytsywxx-table")[0].addJSONData(data);
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
	    reset: function() {
		    this.searchData = {
          swjgDm: avalonRoot.user.swjgDm,
          ssnyStart: new Date().getFullYear() + '01',
          ssnyEnd: tools.getMonth(),
          fzItems: [],
          tjbbType: '07',
          orderSql:"",
          pageNo: 1,
          pageSize:config.pageSize,
        };
		    this.swjgmc = avalonRoot.user.swjgMc;
        this.tsyw =  {
          value: [],
          name: ''
        }
        this.initMultiselect(this.tsywObj)
	    },
      initTree:function() {
        var self = this;
        var setting = {
          callback:{
            onClick:function(e,id,node){
              self.searchData.swjgDm = node.id;
              self.swjgmc = node.text;
              self.hideTree();
              return;
            },
            onDblClick:function(e,id,node){
              self.searchData.swjgDm = node.id;
              self.swjgmc = node.text;
              self.hideTree();
              return;
            }
          },
          data:{key:{children:"item",name:"text"}}
        };
        ajax("POST","/cxfw/export/readtree",{nodeType:"3"}).done(function(res){
          if(res.code=='0'){
            $.fn.zTree.init($(".ckqytsywxx .treeDiv"), setting, res.data);
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
        $('.ckqytsywxx').on('click',function(e){
          var e=e||window.event;
          if($('.treeDiv').find($(e.target)).length<=0){
              self.hideTree();
          }
        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.ckqytsywxx').off('click');
      },
      exform:function(){
        if($('#ckqytsywxx-table').jqGrid('getRowData').length<=0){
          tools.info("请先查询列表");
          return ;
        }
        var self=this;
        var params = tools.clone(self.exformParams);
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
      filDate: function (e, key) {
        var date = e.target.value;
        var errorRes = ''
        if (key == 'ssnyStart') {
          errorRes = new Date().getFullYear() + '01'
        } else if (key == 'ssnyEnd') {
          errorRes = tools.getMonth()
        }
        if (date == '') {
          res = errorRes
        } else {
          var res = tools.MonCheup(date);
          if (res === false) {
            tools.info("日期输入错误");
            res = errorRes
          }
        }
        e.target.value = res;
        this.searchData[key] = res
        console.log(res)

        return;
      },
      // 日期选择框多次点击会隐藏的bug修复
      showDatetimepicker: function(e){
        $(e.target).datetimepicker('show');
      },
    }
});