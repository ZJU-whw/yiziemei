

var ckqktjb=require("./ckqktjb.html");
var jdglinfo = require('../../config/jdglinfo.js');
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component('ckqktjb', {
    template:ckqktjb,
    defaults: {
      params:{},
      act:1,
      tcode:"ckqktjb",
	    swjgmc: "",
      swjgList: [],
      searchData:{
        swjgDm:"",
        ssnyStart: "",
        ssnyEnd: "",
        hzItems: ['ck.amt_usd','ck.amt_ts','ck.amt_zs','ck.amt_ms','ck.amt_bts','ck.amt_sb'],
        fzItems: [],
        isHaveTb: '1',
        tjbbType: '04',
        title: '',
        pid: '',
        hztype: 'hzItemsCk',
        orderSql:"",
        pageNo: 1,
        pageSize:config.pageSize,
      },
      psize: '',
      allSelectList: [
        { zbxmbm: "dj.ckqylx", zbxmmc: '出口企业类型', isTree: '0', values: [], label: '出口企业类型'},
        { zbxmbm: "fzck.myfs", zbxmmc: '贸易方式', isTree: '0', values: [], label: '监管方式'},
        { zbxmbm: "fzck.ckka", zbxmmc: '出口口岸', isTree: '0', values: [], label: '出口口岸'},
        { zbxmbm: "fzck.cksp", zbxmmc: '商品类别', isTree: '0', values: [], label: '商品类别'},
        { zbxmbm: "dj.hy", zbxmmc: '行业类型', isTree: '0', values: [], label: '行业类型'},
        { zbxmbm: "fzck.ckgb", zbxmmc: '出口国别', isTree: '0', values: [], label: '出口市场'},
        { zbxmbm: "dj.flglcd", zbxmmc: '分类管理类别', isTree: '0', values: [], label: '分类管理类别'}
      ],
      selectMc: {},
      isShowSelectArr: {},
      fzItems: {
        fzItemsDj: [],
        fzItemsCk: [],
        fzItemsTs: [],
        fzItemsCw: []
      },
      checkList: [],
      dataList: [],
      tableData:{
        hj: {}
      },
      title: [],
      exformParams: {}, // 导出参
      historyConfig: {
        parent: 'ckqktjb',
        tjbbType: '04'
      },
      ckspList: jdglinfo.ckspList,
      tableHeight: '',
      dateCrossYearFlag: '',
      onInit:function(e){
        avalonRoot.ckqktjb = e.vmodel;
      },
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.tableHeight = $(".ckqktjb .form").height() - 120
        this.getQueryCriteria()
        this.initTree()
        this.initDate()
        this.createTable()
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
        $('.ckqktjb .datepicker.date-month').datetimepicker({
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
              fzItemsCw: data.fzItemsCk,
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
            if (item.zbxmbm != 'fzts.cksp' && item.zbxmbm != 'fzck.cksp' ){
              this.initMultiselect(item)
            }
          }
        }
      },
      // 下拉列表树
      initSelectTree:function(zbxmbm, treelistOrParams, isAsync) {
        var self = this;
        var domId = 'ckqktjb_tree_'+zbxmbm.split('.')[0]+'_'+zbxmbm.split('.')[1]
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
        var nodes = treeObj.getCheckedNodes(true);
        var res = fxjsCommonFun.getFootNode(nodes)
        if (res.length>0 && (this.checkList.indexOf(zbxmbm) == -1)) {
          this.checkList.push(zbxmbm)
        }
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
        let id = '#ckqktjb_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
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
            if (self.checkList.indexOf(item.zbxmbm) == -1){
              self.checkList.push(item.zbxmbm)
            }
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
        var self = this
        var defaultColumns = [
          { name: "fzhash", label: "fzhash", index: "fzhash", hidden: true},
          { name: "户数", label: "涉及企业户数", index: "户数",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return '<span class="toMx link">'+val+'</span>';
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
        ]
        var defaultTitle = defaultColumns.map(function(item,index,arr){return item.name})
        var trendColumsLen = this.title.length - 9
        var trendColumns = fxjsCommonFun.getTrendColumns(this.dataList, this.title, defaultTitle, trendColumsLen)
        var columns = trendColumns.concat(defaultColumns)        
        return columns
      },
      createTable:function(){
        var self = this
        var columns = this.getColumns()
        $("#ckqktjb-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            pager: '#ckqktjb-tablePager',
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
              var fzhash = $('#ckqktjb-table').getRowData(rowid).fzhash
              var datas = self.dataList
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
                var params = {}
                params.searchData = tools.clone(self.exformParams)
                params.searchData.fzItems = fzItems
                params.searchData.flushFlag = '0'
                params.swjgList = self.swjgList
                avalonRoot.addTab({title:"企业出口情况明细表",component:"ckqkmx",params:params});
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
                for(var i = 0, l = self.dataList.length; i<l; i++) {
                  let item = self.dataList[i]
                  total_count += (item[tqName] - 0);
                }
                sumData['同期-0'] = total_count
              }
              $("#ckqktjb-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
                self.searchData.orderSql = index + ' ' + sortorder;
                self.search(1);
                return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton, 'ckqktjb-table');
              self.search(pageNo);
            }
        })
        $("#ckqktjb-table").jqGrid('setGroupHeaders', {
          useColSpanStyle: true,
          groupHeaders: [
            {startColumnName:'出口销售（征税）', numberOfColumns:4, titleText: '本期不退税出口额'}
          ]
        });
        this.searchData.pageSize = $(".ui-pg-selbox", $('.ckqktjb')).val();
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
          if (this.selectMc[key].value.length>0 || (key.indexOf('cksp')>-1 && this.selectMc[key].range != '')) {
            fzItems.push({
              zbxmbm: key.indexOf('cksp')>-1 ? this.selectMc[key].range : key,
              values: this.selectMc[key].value,
              name: this.selectMc[key].name
            })
          }
        }
        this.searchData.fzItems = fzItems
        this.searchData.title = this.swjgmc+'_'+this.searchData.ssnyStart+'_'+this.searchData.ssnyEnd
        this.searchData.pageNo = pageNo
        if (pageNo == 1) {
          this.searchData.pid = ''
        }
        this.searchData.pageSize = this.psize == '' ? ($(".ui-pg-selbox", $('.ckqktjb')).val() || 20): this.psize;
        this.psize = ''
        this.exformParams = tools.clone(this.searchData)
        var params = tools.clone(this.searchData)
        params.flushFlag = isRefresh ? '1' : '0'
        $('.ckqktjb .mask').show()
        $("#ckqktjb-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/ckqk",params, true, false, true).done(function(res){
          $('.ckqktjb .mask').hide()
          if(res.code=='0'){
            self.title = res.data.title
            self.total = res.data.list.count
            self.dataList = tools.clone(res.data.list.rows)
            self.searchData.pid = res.data.pid
            var data = tools.clone(res.data.list)
            if (self.total == 0) data.rows = []
            self.tableData.hj={};
            $("#ckqktjb-table").jqGrid('GridUnload')
            self.createTable()
            if (res.data.tips && res.data.tips != ''&& isShowTips) {
              var dialog = $.dialog({
                title: "提示",
                content: res.data.tips,
                okValue: '直接查看',
                lock:true,
                ok: function(){
                  self.tableData=tools.clone(res.data);
                  $("#ckqktjb-table")[0].addJSONData(data);
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
              $("#ckqktjb-table")[0].addJSONData(data);
            }
            self.closeHyper()
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          $('.ckqktjb .mask').hide()
          tools.info(err);
        })
      },
	    reset: function() {
		    this.searchData = {
          swjgDm: avalonRoot.user.swjgDm,
          ssnyStart: new Date().getFullYear() + '01',
          ssnyEnd: tools.getMonth(),
          hzItems: ['ck.amt_usd','ck.amt_ts','ck.amt_zs','ck.amt_ms','ck.amt_bts','ck.amt_sb'],
          fzItems: [],
          isHaveTb: '1',
          tjbbType: '04',
          title: '',
          pid: '',
          hztype: 'hzItemsCk',
          orderSql: '',
          pageNo: 1,
          pageSize:config.pageSize,
        };
		    this.swjgmc = this.searchData.swjgDm == this.swjgList[0].id ? this.swjgList[0].text :  avalonRoot.user.swjgMc;
        this.checkList = []
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
            $.fn.zTree.init($(".ckqktjb .treeDiv"), setting, res.data);
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
      showTree:function(e, zbxmbm){
        if (zbxmbm&&zbxmbm.indexOf('cksp')>-1 && this.selectMc[zbxmbm].range == '') {
          return false
        }
        var self=this;
        $(".treeDiv",$(e.target).parent()).show();
        $('.ckqktjb').on('click',function(e){
          var e=e||window.event;
          if($('.treeDiv').find($(e.target)).length<=0){
              self.hideTree();
          }
        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.ckqktjb').off('click');
      },
      showHyper:function(){
        $('.ckqktjb .select-sub').toggle();
        $('.ckqktjb .select-wrapper .icon').toggleClass("active");
        if ($('.ckqktjb .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
          $('.ckqktjb .select-wrapper .icon').attr("title","收起查询条件");
        } else {
          $('.ckqktjb .select-wrapper .icon').attr("title","展开查询条件")
        }
      },
      closeHyper:function(){
        $('.ckqktjb .select-sub').hide();
        $('.ckqktjb .select-wrapper .icon').removeClass('active');
        $('.ckqktjb .select-wrapper .icon').attr("title","展开查询条件")
      },
      exform:function(){
        if($('#ckqktjb-table').jqGrid('getRowData').length<=0){
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
      showModel: function(){
        $('.model').show()
        avalonRoot.historyTable.parent = this.historyConfig.parent
        avalonRoot.historyTable.tjbbType = this.historyConfig.tjbbType
        avalonRoot.historyTable.showModel()
      },
      recordsHandler: function(reqParam){
        var self = this
        this.resetSelectMc(this.allSelectList)
        this.initSelect()
        this.searchData = tools.clone(reqParam)
        this.psize = this.searchData.pageSize
        this.swjgmc = reqParam.title.split('_')[0]
        for(var i=0;i<reqParam.fzItems.length;i++) {
          let item = reqParam.fzItems[i]
          let isCksp = item.zbxmbm.indexOf('cksp') > -1
          if (isCksp) {
            let range = item.zbxmbm
            item.zbxmbm = 'fzck.cksp'
            item.range = range
            let val = item.values.join(',')
            let params = val + '&level='+range.split('.')[1]
            self.initSelectTree(item.zbxmbm,params,true) // 下拉树形多选异步加载
          } 
          self.selectMc[item.zbxmbm].name = item.name
          self.selectMc[item.zbxmbm].value = item.values
          self.selectMc[item.zbxmbm].range = item.range
          if (isCksp) continue;
          let obj = self.allSelectList.find(function(obj){return obj.zbxmbm == item.zbxmbm})
          if (obj.isTree == '1') { // 下拉树形多选
            let domId = 'ckqktjb_tree_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
            var treeObj = $.fn.zTree.getZTreeObj(domId);
            for (var j=0;j<item.values.length;j++) {
              let node = treeObj.getNodesByParam("code", item.values[j], null)[0];
              treeObj.checkNode(node, true, true);
            }
          } else { // 下拉多选
            let domId = '#ckqktjb_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
            let options = []
            for(var j=0;j<obj.values.length;j++) {
              let tmp = obj.values[j]
              let selected = item.values.indexOf(tmp.code) > -1
              options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: selected})
            }
            $(domId).multiselect('dataprovider', options);
          }
        }
        this.search(1, false, true)
      },
      ckspLevelChange: function(zbxmbm){
        this.selectMc[zbxmbm].name = ''
        this.selectMc[zbxmbm].value = []
        if (this.selectMc[zbxmbm].range != '') {
          var params = '&level='+this.selectMc[zbxmbm].range.split('.')[1]
          this.initSelectTree(zbxmbm, params, true)
        }
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