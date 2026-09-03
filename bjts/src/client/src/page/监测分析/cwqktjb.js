

var cwqktjb=require("./cwqktjb.html");
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component('cwqktjb', {
    template:cwqktjb,
    defaults: {
      params:{},
      act:1,
      tcode:"cwqktjb",
	    swjgmc: "",
      searchData:{
        swjgDm:"",
        ssnyStart: "",
        ssnyEnd: "",
        hzItems: ['cz.cz_gdzc', 'cz.cz_zczz', 'cz.cz_fzzz', 'cl.cl_zysr', 'cl.cl_zycb', 'cl.cl_yysj', 'cl.cl_xsfy', 'cl.cl_glfy', 'cl.cl_cwfy', 'cl.cl_lrze', 'cl.cl_jlr', 'sb.sb_jfrs', 'sb.sb_jfjs'],
        fzItems: [],
        isHaveTb: '0',
        zid: "",
        title: '',
        tjbbType: '06',
        pid: '',
        orderSql:"",
        pageNo: 1,
        pageSize:config.pageSize,
      },
      psize: '',
      tableData:{
        list: {
          rows: []
        },
        hj: {}
      },
      title: [],
      exformParams: {}, // 导出参
      qyfzList: [],
      swjgList: [],
      historyConfig: {
        parent: 'cwqktjb',
        tjbbType: '06'
      },
      tableHeight: '',
      onInit:function(e){
        avalonRoot.cwqktjb = e.vmodel;
      },
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.tableHeight = $(".cwqktjb .form").height() - 90
        this.createTable()
        this.initTree()
        this.initDate()
        this.getQyfzList()
      },
      initDate: function(){
        $('.cwqktjb .datepicker.date-month').datetimepicker({
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
      getColumns: function(){
        var self = this
        var defaultColumns = [
          { name: "fzhash", label: "fzhash", index: "fzhash", hidden: true},
          { name: "户数", label: "涉及企业户数", index: "户数",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            let val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return '<span class="toMx link">'+val+'</span>';
          }},
          { name: "固定资产", label: "固定资产", index: "固定资产",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "资产总值", label: "资产总值", index: "资产总值",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "负债总值", label: "负债总值", index: "负债总值",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "毛利率", label: "毛利率（%）", index: "毛利率",width: 120, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
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
        var self = this
        var columns = this.getColumns()
        $("#cwqktjb-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            pager: '#cwqktjb-tablePager',
            shrinkToFit: false,
            width:"100%",
            // multiselect: true,
            // multiselectWidth:"30",
            autowidth:true,
            altRows: true,
            footerrow:true,
            altclass: "altclasscss",
            lastsort: 1,
            rowNum: this.searchData.pageSize,
            rowList: [20,50,100,500],
            height:(function(){
                return self.tableHeight;
            })(),
            beforeSelectRow:function(rowid,e){
              var fzhash = $('#cwqktjb-table').getRowData(rowid).fzhash
              var datas = self.tableData.list.rows
              var row = {}
              for (var i=0;i<datas.length;i++) {
                if (datas[i].fzhash == fzhash) {
                  row = datas[i]
                }
              }
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
                avalonRoot.addTab({title:"企业财务情况明细表",component:"cwqkmx",params:params});
                return true;
              }
              return true;
            },
            gridComplete: function(){
              var sumData = {}
              var tqName = ''
              for (var key in self.tableData.hj) {
                let name = key.split('#')[0].split('_')[0]
                sumData[name] = self.tableData.hj[key] == undefined ? '' : self.tableData.hj[key]
                if (name == '同期-0') {
                  tqName = key
                }
              }
              sumData['小计'] = sumData['出口销售（征税）'] + sumData['出口销售（免税）'] + sumData['出口销售（不退税）']
              sumData['rn']="合计";
              if (self.total > 0) {
                var total_count = 0
                for(var i = 0, l = self.tableData.list.rows.length; i<l; i++) {
                  let item = self.tableData.list.rows[i]
                  total_count += (item[tqName] - 0);
                }
                sumData['同期-0'] = total_count
              }
              $("#cwqktjb-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
              self.searchData.orderSql = index + ' ' + sortorder;
              self.search(1);
              return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton, 'cwqktjb-table');
              self.search(pageNo);
            }
        })
        this.searchData.pageSize = $(".ui-pg-selbox", $('.cwqktjb')).val();
      },
      search:function(pageNo, isRefresh, isShowTips){
        var self=this;
        var dateValid = tools.checkDate(this.searchData.ssnyStart, this.searchData.ssnyEnd)
        if (!dateValid) {
          tools.info('出口年月截止时间必须大于起始时间')
          return false
        }
        var titleArr = [this.swjgmc, this.searchData.ssnyStart, this.searchData.ssnyEnd]
        if (this.searchData.zid) {
          for( var j=0;j<this.qyfzList.length;j++) {
            if (this.qyfzList[j].zid == this.searchData.zid) {
              titleArr.push(this.qyfzList[j].sname)
              break;
            }
          }
        }
        this.searchData.title = titleArr.join('_')
        this.searchData.pageNo = pageNo
        if (pageNo == 1) {
          this.searchData.pid = ''
        }
        this.searchData.pageSize = this.psize == '' ? ($(".ui-pg-selbox", $('.cwqktjb')).val() || 20): this.psize;
        this.psize = ''
        this.exformParams = tools.clone(this.searchData)
        var params = tools.clone(this.searchData)
        params.flushFlag = isRefresh ? '1' : '0'
        $('.cwqktjb .mask').show()
        $("#cwqktjb-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/dynamic",params,true,false,true).done(function(res){
          $('.cwqktjb .mask').hide()
          if(res.code=='0'){
            self.title = res.data.title
            self.total = res.data.list.count
            self.searchData.pid = res.data.pid
            var data = tools.clone(res.data.list)
            if (self.total == 0) data.rows = []
            self.tableData.hj={};
            $("#cwqktjb-table").jqGrid('GridUnload')
            self.createTable()
            if (res.data.tips && res.data.tips != '' && isShowTips) {
              var dialog = $.dialog({
                title: "提示",
                content: res.data.tips,
                okValue: '直接查看',
                lock:true,
                ok: function(){
                  self.tableData=tools.clone(res.data);
                  $("#cwqktjb-table")[0].addJSONData(data);
                },
                button: [{value:'重新统计',callback:function(){
                  self.search(1,'1');
                  dialog.close();
                  return false;
                }}]
              })
              $('.d-close').css('display','none');
            } else {
              self.tableData=tools.clone(res.data);
              $("#cwqktjb-table")[0].addJSONData(data);
            }
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          $('.cwqktjb .mask').hide()
          tools.info(err);
        })
      },
	    reset: function() {
		    this.searchData = {
          swjgDm: avalonRoot.user.swjgDm,
          ssnyStart: new Date().getFullYear() + '01',
          ssnyEnd: tools.getMonth(),
          hzItems: ['cz.cz_gdzc', 'cz.cz_zczz', 'cz.cz_fzzz', 'cl.cl_zysr', 'cl.cl_zycb', 'cl.cl_yysj', 'cl.cl_xsfy', 'cl.cl_glfy', 'cl.cl_cwfy', 'cl.cl_lrze', 'cl.cl_jlr', 'sb.sb_jfrs', 'sb.sb_jfjs'],
          fzItems: [],
          isHaveTb: '0',
          zid: '',
          title: '',
          tjbbType: '06',
          pid: '',
          orderSql: '',
          pageNo: 1,
          pageSize:config.pageSize,
        };
		    this.swjgmc = this.searchData.swjgDm == this.swjgList[0].id ? this.swjgList[0].text : avalonRoot.user.swjgMc;
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
            $.fn.zTree.init($(".cwqktjb .treeDiv"), setting, res.data);
            self.swjgList = res.data
            if (avalonRoot.user.swjgDm == res.data[0].id) {
              self.swjgmc = res.data[0].text
            }
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
        $('.cwqktjb').on('click',function(e){
          var e=e||window.event;
          if($('.treeDiv').find($(e.target)).length<=0){
              self.hideTree();
          }
        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.cwqktjb').off('click');
      },
      exform:function(){
        if($('#cwqktjb-table').jqGrid('getRowData').length<=0){
          tools.info("请先查询列表");
          return ;
        }
        var self=this;
        var params = tools.clone(self.exformParams);
        params.flushFlag='0';
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
      getQyfzList: function(){
        var self = this
        var params = {
          pageSize: 9999,
          pageNo: 1
        }
        ajax("POST","/bjtssw/sjjc/nsr/sample",params).done(function(res){
          if(res.code=='0'){
            var data = res.data.rows || []
            self.qyfzList = []
            for (var i=0;i<data.length;i++) {
              if (data[i].qybz == 'Y') {
                self.qyfzList.push(data[i])
              }
            }
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      toYbqywh: function(){
        avalonRoot.addTab({title:"样本企业维护",component:"ybqywh",params:{}});
      },
      
      showModel: function(){
        $('.model').show()
        avalonRoot.historyTable.parent = this.historyConfig.parent
        avalonRoot.historyTable.tjbbType = this.historyConfig.tjbbType
        avalonRoot.historyTable.showModel()
      },
      recordsHandler: function(reqParam){
        this.searchData = tools.clone(reqParam)
        this.psize = this.searchData.pageSize
        this.swjgmc = reqParam.title.split('_')[0]
        this.search(1, false, true)
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