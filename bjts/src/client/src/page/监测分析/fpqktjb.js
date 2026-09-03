

var fpqktjb=require("./fpqktjb.html");
var jdglinfo = require('../../config/jdglinfo.js');
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component('fpqktjb', {
    template:fpqktjb,
    defaults: {
      params:{},
      act:1,
      tcode:"fpqktjb",
	    swjgmc: "",
      searchData:{
        swjgDm:"",
        ssnyStart: "",
        ssnyEnd: "",
        hzItems: ['fp.fp_xxje_ck','fp.fp_xxje_zy','fp.fp_jxje_zy'],
        fzItems: [],
        isHaveTb: '1',
        zid: "",
        title: '',
        tjbbType: '05',
        pid: '',
        orderSql:"",
        pageNo: 1,
        pageSize:config.pageSize,
      },
      psize: '',
      allSelectList: [
        { zbxmbm: "cw.ckgm", zbxmmc: '出口规模', isTree: '0', values: []}
      ],
      selectMc: {},
      fzItems: {
        fzItemsDj: [],
        fzItemsCk: [],
        fzItemsTs: [],
        fzItemsCw: []
      },
      dataList: [],
      tableData:{
        hj: {}
      },
      title: [],
      exformParams: {}, // 导出参
      trendTitle: ['出口金额'], // 表头动态部分
      qyfzList: [],
      swjgList: [],
      historyConfig: {
        parent: 'fpqktjb',
        tjbbType: '05'
      },
      tableHeight: '',
      dateCrossYearFlag: '',
      onInit:function(e){
        avalonRoot.fpqktjb = e.vmodel;
      },
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.tableHeight = $(".fpqktjb .form").height() - 90
        this.createTable()
        this.getQueryCriteria()
        this.initTree()
        this.initDate()
        this.getQyfzList()
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
        $('.fpqktjb .datepicker.date-month').datetimepicker({
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
      getQueryCriteria: function(){
        var self = this
        ajax("POST","/bjtssw/sjjc/dynamic/init").done(function(res){
          if(res.code=='0'){
            var data = res.data
            self.fzItems = {
              fzItemsCk: data.fzItemsCk,
              fzItemsCw: data.fzItemsCw,
              fzItemsDj: data.fzItemsDj,
              fzItemsTs: data.fzItemsTs
            }
            var tmpArr = self.fzItems.fzItemsDj.concat(self.fzItems.fzItemsCk,self.fzItems.fzItemsTs,self.fzItems.fzItemsCw)
            for (var i=0;i<tmpArr.length;i++) {
              var item = tmpArr[i]
              for (var j=0; j<self.allSelectList.length;j++) {
                var tmp = self.allSelectList[j]
                if (item.zbxmbm == tmp.zbxmbm) {
                  if (item.zbxmbm == 'fzck.tslv' && item.values.length == 0) {
                    tmp.values = jdglinfo.tslv
                  } else {
                    tmp.values = item.values
                  }
                  tmp.isTree = item.isTree
                }
              }
            }
            self.resetSelectMc(self.allSelectList)
            self.initSelect()
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      initSelect: function(){
        for (var i=0;i<this.allSelectList.length;i++) {
          let item = this.allSelectList[i]
          if (item.isTree == '1') {
            this.initSelectTree(item.zbxmbm, item.values)
          } else {
            if (item.zbxmbm == 'fzts.cksp' || item.zbxmbm == 'fzck.cksp' ){
              this.initSelectTree(item.zbxmbm, '', true)
            } else {
              this.initMultiselect(item)
            }
          }
        }
      },
      // 下拉列表树
      initSelectTree:function(zbxmbm, treelistOrParams, isAsync) {
        var self = this;
        var domId = 'fpqktjb_tree_'+zbxmbm.split('.')[0]+'_'+zbxmbm.split('.')[1]
        var setting = {
          check:{
            enable: true
          },
          view: {
            selectedMulti: false
          },
          data:{
            simpleData:{
              enable: true,
              idKey: "code",
            },
            key:{children:"item",name:"name"}
          },
          callback:{
            onCheck:function(e,id,node){
              self.treeCheckHandler(domId, zbxmbm)
              return;
            }
          }
        };
        if (!isAsync) {
          $.fn.zTree.init($('#'+domId), setting, treelistOrParams);
        } else {
          setting.async = { // 属性配置
            enable: true, 
            url:"/bjtssw/sjjc/dynamic/init/spdmtree?codes="+treelistOrParams, 
            autoParam:["id=code", "name=name", "children=item"], 
            type: 'get',
            dataFilter: function(treeId, parentNode, responseData){
              return responseData.data;
            }
          }
          var zTreeObj = $.fn.zTree.init($('#'+domId), setting);
          // 解决初始化选中子节点，父节点未选中问题
          setTimeout(function(){
            var nodes = zTreeObj.getCheckedNodes();
            for (var i = 0, l = nodes.length; i < l; i++) {
              zTreeObj.checkNode(nodes[i], true, true);
            }
          },1000)
        }
      },
      // 选中后赋值
      treeCheckHandler: function(domId, zbxmbm){
        var treeObj = $.fn.zTree.getZTreeObj(domId);
        var nodes = treeObj.getCheckedNodes(true); // 获取输入框被勾选的节点集合
        var res = fxjsCommonFun.getFootNode(nodes)
        this.selectMc[zbxmbm].value = []
        var nameArr = []
        for (var i=0;i<res.length;i++) {
          this.selectMc[zbxmbm].value.push(res[i].code)
          nameArr.push(res[i].name)
        }
        this.selectMc[zbxmbm].name = nameArr.join(',')
      },
      // 多选下拉框
      initMultiselect: function(item){
        var self = this
        let id = '#fpqktjb_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
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
            let values = self.selectMc[item.zbxmbm].value
            if (checked) {
              values.push(val)
            } else {
              let i = values.indexOf(val)
              values.splice(i,1)
            }
            self.selectMc[item.zbxmbm].value = values
          }
        });
        $(id).multiselect('dataprovider', options);
      },
      // 重置分组指标选中内容
      resetSelectMc: function(allSelectList){
        var obj = {}
        for (var i=0;i<allSelectList.length;i++) {
            let item = allSelectList[i].zbxmbm
            obj[item] = { name: '', value: [], range: ''}
        }
        this.selectMc = obj
      },
      
      getColumns: function(){
        var defaultColumns = [
          { name: "fzhash", label: "fzhash", index: "fzhash", hidden: true},
          { name: "户数", label: "涉及企业户数", index: "户数",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return '<span class="toMx link">'+val+'</span>';
          }},
          { name: "发票出口金额", label: "发票出口金额", index: "发票出口金额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-1", label: "同比（%）", index: "同比-1",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "发票内销金额", label: "发票内销金额", index: "发票内销金额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-2", label: "同比（%）", index: "同比-2",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "发票购进金额", label: "发票购进金额", index: "发票购进金额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return fxjsCommonFun.getFormatter(rowObject, options.colModel.name);
          }},
          { name: "同比-3", label: "同比（%）", index: "同比-3",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
        ]
        var defaultTitle = defaultColumns.map(function(item,index,arr){return item.name})
        var trendColumsLen = this.title.length - 7
        var trendColumns = fxjsCommonFun.getTrendColumns(this.dataList, this.title, defaultTitle, trendColumsLen)
        var columns = trendColumns.concat(defaultColumns)   
        return columns
      },
      createTable:function(){
        var self = this
        var columns = this.getColumns()
        $("#fpqktjb-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            pager: '#fpqktjb-tablePager',
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
              var fzhash = $('#fpqktjb-table').getRowData(rowid).fzhash
              var datas = self.dataList
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
                avalonRoot.addTab({title:"企业发票情况明细表",component:"fpqkmx",params:params});
                return true;
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
              $("#fpqktjb-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
              self.searchData.orderSql = index + ' ' + sortorder;
              self.search(1);
              return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton, 'fpqktjb-table');
              self.search(pageNo);
            }
        })
        this.searchData.pageSize = $(".ui-pg-selbox", $('.fpqktjb')).val();
      },
      search:function(pageNo, isRefresh, isShowTips){
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
          tools.info('出口年月截止时间必须大于起始时间')
          return false
        }
        var fzItems = []
        for (var key in this.selectMc) {
          if (this.selectMc[key].value.length>0) {
            fzItems.push({zbxmbm: key, values: this.selectMc[key].value})
          }
        }
        this.searchData.fzItems = fzItems
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
        this.searchData.pageSize = this.psize == '' ? ($(".ui-pg-selbox", $('.fpqktjb')).val() || 20): this.psize;
        this.psize = ''
        this.exformParams = tools.clone(this.searchData)
        var params = tools.clone(this.searchData)
        params.flushFlag = isRefresh ? '1' : '0'
        $('.fpqktjb .mask').show()
        $("#fpqktjb-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/dynamic",params, true, false, true).done(function(res){
          $('.fpqktjb .mask').hide()
          if(res.code=='0'){
            self.title = res.data.title
            var tmpTitle = self.title.map(function(item){
              return item.split('#')[0].split('_')[0]
            })
            var tbIndex = tmpTitle.indexOf('同比-0')
            self.title.splice(tbIndex,1)
            self.total = res.data.list.count
            self.dataList = res.data.list.rows
            self.searchData.pid = res.data.pid
            var data = tools.clone(res.data.list)
            if (self.total == 0) data.rows = []
            self.tableData.hj={};
            $("#fpqktjb-table").jqGrid('GridUnload')
            self.createTable()
            if (res.data.tips && res.data.tips != ''&& isShowTips) {
              var dialog = $.dialog({
                title: "提示",
                content: res.data.tips,
                okValue: '直接查看',
                lock:true,
                ok: function(){
                  self.tableData=tools.clone(res.data);
                  $("#fpqktjb-table")[0].addJSONData(data);
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
              $("#fpqktjb-table")[0].addJSONData(data);
            }
            self.closeHyper()
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          $('.fpqktjb .mask').hide()
          tools.info(err);
        })
      },
	    reset: function() {
		    this.searchData = {
          swjgDm: avalonRoot.user.swjgDm,
          ssnyStart: new Date().getFullYear() + '01',
          ssnyEnd: tools.getMonth(),
          hzItems: ['fp.fp_xxje_ck','fp.fp_xxje_zy','fp.fp_jxje_zy'],
          fzItems: [],
          isHaveTb: '1',
          zid: '',
          title: '',
          tjbbType: '05',
          pid: '',
          orderSql:"",
          pageNo: 1,
          pageSize:config.pageSize,
        };
		    this.swjgmc = this.searchData.swjgDm == this.swjgList[0].id ? this.swjgList[0].text : avalonRoot.user.swjgMc;
        this.resetSelectMc(this.allSelectList)
        this.initSelect()
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
            $.fn.zTree.init($(".fpqktjb .treeDiv"), setting, res.data);
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
        $('.fpqktjb').on('click',function(e){
          var e=e||window.event;
          if($('.treeDiv').find($(e.target)).length<=0){
              self.hideTree();
          }
        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.fpqktjb').off('click');
      },
      showHyper:function(){
        $('.fpqktjb .select-sub').toggle();
        $('.fpqktjb .select-wrapper .icon').toggleClass("active");
        if ($('.fpqktjb .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
          $('.fpqktjb .select-wrapper .icon').attr("title","收起查询条件");
        } else {
          $('.fpqktjb .select-wrapper .icon').attr("title","展开查询条件")
        }
      },
      closeHyper:function(){
        $('.fpqktjb .select-sub').hide();
        $('.fpqktjb .select-wrapper .icon').removeClass('active');
        $('.fpqktjb .select-wrapper .icon').attr("title","展开查询条件")
      },
      exform:function(){
        if($('#fpqktjb-table').jqGrid('getRowData').length<=0){
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
        var self = this
        this.resetSelectMc(self.allSelectList)
        this.initSelect()
        this.searchData = tools.clone(reqParam)
        this.psize = this.searchData.pageSize
        this.swjgmc = reqParam.title.split('_')[0]
        for(var i=0;i<reqParam.fzItems.length;i++) {
          let item = reqParam.fzItems[i]
          self.selectMc[item.zbxmbm].name = item.name
          self.selectMc[item.zbxmbm].value = item.values
          self.selectMc[item.zbxmbm].range = item.range
          if (['fzck.cksp', 'fzts.cksp'].indexOf(item.zbxmbm) > -1) { // 下拉树形多选异步加载
            let val = item.values.join(',')
            self.initSelectTree(item.zbxmbm,val,true)
            continue;
          }
          let obj = self.allSelectList.find(function(obj){return obj.zbxmbm == item.zbxmbm})
          if (obj.isTree == '1') { // 下拉树形多选
            let domId = 'fpqktjb_tree_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
            var treeObj = $.fn.zTree.getZTreeObj(domId);
            for (var j=0;j<item.values.length;j++) {
              let node = treeObj.getNodesByParam("code", item.values[j], null)[0];
              treeObj.checkNode(node, true, true);
            }
          } else { // 下拉多选
            let domId = '#fpqktjb_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
            let options = []
            for(var j=0;j<obj.values.length;j++) {
              let tmp = obj.values[j]
              let selected = item.values.indexOf(tmp.code) > -1
              options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: selected})
            }
            $(domId).multiselect('dataprovider', options);
          }
        }
        self.search(1, false, true)
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
        return;
      },
      // 日期选择框多次点击会隐藏的bug修复
      showDatetimepicker: function(e){
        $(e.target).datetimepicker('show');
      },
    }
});