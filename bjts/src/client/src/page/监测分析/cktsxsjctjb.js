

var cktsxsjctjb=require("./cktsxsjctjb.html");
var jdglinfo = require('../../config/jdglinfo.js');
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component('cktsxsjctjb', {
    template:cktsxsjctjb,
    defaults: {
      params:{},
      act:1,
      tcode:"cktsxsjctjb",
	    swjgmc: "",
      swjgList: [],
      tjlx: '0',
      searchData:{
        swjgDm:"",
        ssnyStart: "",
        ssnyEnd: "",
        hzItems: [],
        fzItems: [],
        isHaveTb: '1',
        title: '',
        tjbbType: '03',
        pid: '',
        orderSql:"",
        pageNo: 1,
        pageSize:config.pageSize,
      },
      allSelectList: [
        { zbxmbm: "dj.djzclx", zbxmmc: '企业性质', isTree: '1', values: []},
        { zbxmbm: "dj.ckqylx", zbxmmc: '企业类型', isTree: '0', values: []},
        { zbxmbm: "cw.ckgm", zbxmmc: '企业规模', isTree: '0', values: []},
        { zbxmbm: "fzts.cksp", zbxmmc: '商品类别', isTree: '1', values: [], isDisabled: '1'},
        { zbxmbm: "dj.hy", zbxmmc: '行业', isTree: '1', values: []},
        { zbxmbm: "fzts.myfs", zbxmmc: '监管方式', isTree: '1', values: [], isDisabled: '1'},
        { zbxmbm: "fzts.ckgb", zbxmmc: '出口市场', isTree: '1', values: [], isDisabled: '1'},
        { zbxmbm: "fzts.tslv", zbxmmc: '退税率', isTree: '0', values: [], isDisabled: '1'},
      ],
      selectMc: {},
      fzItems: {
        fzItemsDj: [],
        fzItemsCk: [],
        fzItemsTs: [],
        fzItemsCw: []
      },
      tableData:{
        hj: {}
      },
      isShowSbrqTable: true,
      isShowYwhzrqTable: false,
      dataList: [],
      title: [],
      exformParams: {}, // 导出参
      sbrqDefaultTitle: ['户数','同比-0','出口销售（美元）','同比-1','计税金额（外贸）','同比-2','申报退免税额','同比-3'],
      ywhzrqDefaultTitle: ['户数','同比-0','核准退税额','同比-1','核准免抵额','同比-2'],
      historyConfig: {
        parent: 'cktsxsjctjb',
        tjbbType: '03'
      },
      ckspList: jdglinfo.ckspList,
      psize: '',
      tableHeight: '',
      dateCrossYearFlag: '',
      onInit:function(e){
        avalonRoot.cktsxsjctjb = e.vmodel;
      },
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.getQueryCriteria()
        this.initTree()
        this.initDate()
        this.tableHeight = $(".cktsxsjctjb .form").height() - 120
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
        $('.cktsxsjctjb .datepicker.date-month').datetimepicker({
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
                  if (item.zbxmbm == 'fzts.tslv' && item.values.length == 0) {
                    tmp.values = jdglinfo.tslv
                  } else {
                    tmp.values = item.values
                  }
                  tmp.zbxmmc = item.zbxmmc
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
            if (item.zbxmbm != 'fzts.cksp' && item.zbxmbm != 'fzck.cksp' ){ // 异步加载树
              this.initMultiselect(item)
            }
          }
        }
      },
      // 多选下拉框
      initMultiselect: function(item){
        var self = this
        let id = '#cktsxsjctjb_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
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
      // 切换统计类型
      tjlxChange: function(){
        for (var i=0;i<this.allSelectList.length;i++) {
          var item = this.allSelectList[i]
          if (item.isDisabled == '1') {
            var domId = '#cktsxsjctjb_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
            if (this.tjlx == '1') {
              this.selectMc[item.zbxmbm] = { name: '', value: [], range: ''}
              if (item.zbxmbm == 'fzts.cksp' || item.isTree == '1') continue;
              let options = []
              for(var i=0;i<item.values.length;i++) {
                let tmp = item.values[i]
                options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: false})
              }
              $(domId).multiselect('dataprovider', options);
              $(domId).multiselect('disable');
            } else {
              $(domId).multiselect('enable');
            }
          }
        }
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
      getSbrqTableCol:function(){
        var self = this
        var columns = [
          { name: "户数", label: "申报户数", index: "户数",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return '<span class="toMx link">'+val+'</span>';
          }},
          { name: "同比-0", label: "同比%", index: "同比-0",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
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
        var self = this
        var columns = [
          { name: "户数", label: "核准户数", index: "户数",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return '<span class="toMx text-blue" style="text-decoration: underline;cursor:pointer;">'+val+'</span>';
          }},
          { name: "同比-0", label: "同比%", index: "同比-0",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = fxjsCommonFun.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
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
      getColumns: function(){
        var defaultTitle = this.tjlx == '0'? this.sbrqDefaultTitle : this.ywhzrqDefaultTitle
        var trendColumsLen = this.title.length - defaultTitle.length
        var trendColumns = fxjsCommonFun.getTrendColumns(this.dataList, this.title, defaultTitle, trendColumsLen)
        var defaultColumns = this.tjlx == '0'? this.getSbrqTableCol() : this.getYwhzrqTableCol()
        var columns = trendColumns.concat(defaultColumns)
        columns.push({ name: "fzhash", label: "fzhash", index: "fzhash", hidden: true})
        return columns
      },
      createTable:function(){
        var self=this;
        var columns = this.getColumns()
        $("#cktsxsjctjb-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            pager: '#cktsxsjctjb-tablePager',
            shrinkToFit: false,
            width:"100%",
            // multiselect: true,
            // multiselectWidth:"30",
            autowidth:true,
            altRows: true,
            footerrow:true,
            userDataOnFooter: true,
            altclass: "altclasscss",
            lastsort: 1,
            rowNum: this.searchData.pageSize,
            rowList: [20,50,100,500],
            height:(function(){
                return self.tableHeight;
            })(),
            beforeSelectRow:function(rowid,e){
              var fzhash = $('#cktsxsjctjb-table').getRowData(rowid).fzhash
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
                      let tmpVal = row[self.allSelectList[j].zbxmmc]+''
                      val = tmpVal.split('-')[0]
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
                params.tjlx = self.tjlx
                avalonRoot.addTab({title:"企业出口退（免）税明细表",component:"cktsmx",params:params});
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
              $("#cktsxsjctjb-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
              self.searchData.orderSql = index + ' ' + sortorder;
              self.search(1);
              return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton, 'cktsxsjctjb-table');
              self.search(pageNo);
            }
        })

        var groupHeaders = []
        if (this.tjlx == '0') {
          groupHeaders = [
            {startColumnName:'户数', numberOfColumns:2, titleText: '企业户数'},
            {startColumnName:'出口销售（美元）', numberOfColumns:2, titleText: '出口销售额（美元）'},
            {startColumnName:'计税金额（外贸）', numberOfColumns:2, titleText: '退税计税金额'},
            {startColumnName:'申报退免税额', numberOfColumns:2, titleText: '退（免）税额'}
          ]
        } else {
          groupHeaders = [
            {startColumnName:'户数', numberOfColumns:2, titleText: '企业户数'},
            {startColumnName:'核准退税额', numberOfColumns:2, titleText: '退税计税金额'},
            {startColumnName:'核准免抵额', numberOfColumns:2, titleText: '退（免）税额'}
          ]
        }
        $("#cktsxsjctjb-table").jqGrid('setGroupHeaders', {
          useColSpanStyle: true,
          groupHeaders: groupHeaders
        });
        this.searchData.pageSize = $(".ui-pg-selbox", $('.cktsxsjctjb')).val();
      },
      search:function(pageNo, isRefresh, isShowTips){
        var self=this;
        if (this.dateCrossYearFlag == '0') { // 不允许跨年
          let startY = this.searchData.ssnyStart.substr(0,4)
          let endY = this.searchData.ssnyEnd.substr(0,4)
          console.log(startY)
          console.log(endY)
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
        var hzItems = []
        if (this.tjlx == '1') {
          hzItems = ['bl.ck_hz_tse', 'bl.ck_hz_mde']
        } else {
          hzItems = ['ts.amt_usd', 'ts.jsje', 'ts.sbtmse']
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
        this.searchData.hzItems = hzItems
        this.searchData.fzItems = fzItems
        this.searchData.title = this.swjgmc+'_'+this.searchData.ssnyStart+'_'+this.searchData.ssnyEnd
        this.searchData.pageNo = pageNo
        if (pageNo == 1) {
          this.searchData.pid = ''
        }
        this.searchData.pageSize = this.psize == '' ? ($(".ui-pg-selbox", $('.cktsxsjctjb')).val() || 20): this.psize;
        this.psize = ''
        this.exformParams = tools.clone(this.searchData)
        var params = tools.clone(this.searchData)
        params.flushFlag = isRefresh ? '1' : '0'
        $('.cktsxsjctjb .mask').show()
        $("#cktsxsjctjb-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/dynamic",params,true, false, true).done(function(res){
          $('.cktsxsjctjb .mask').hide()
          if(res.code=='0'){
            self.title = res.data.title
            self.total = res.data.list.count
            self.dataList = res.data.list.rows
            self.searchData.pid = res.data.pid
            var data = tools.clone(res.data.list)
            if (self.total == 0) data.rows = []
            self.tableData.hj={};
            $("#cktsxsjctjb-table").jqGrid('GridUnload')
            self.createTable()
            if (res.data.tips && res.data.tips != '' && isShowTips) {
              var dialog = $.dialog({
                title: "提示",
                content: res.data.tips,
                okValue: '直接查看',
                lock:true,
                ok: function(){
                  self.tableData=tools.clone(res.data);
                  $("#cktsxsjctjb-table")[0].addJSONData(data);
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
              $("#cktsxsjctjb-table")[0].addJSONData(data);
            }
            self.closeHyper()
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          $('.cktsxsjctjb .mask').hide()
          tools.info(err);
        })
      },
	    reset: function() {
		    this.searchData = {
          swjgDm: avalonRoot.user.swjgDm,
          ssnyStart: new Date().getFullYear() + '01',
          ssnyEnd: tools.getMonth(),
          hzItems: [],
          fzItems: [],
          isHaveTb: '1',
          title: '',
          tjbbType: '03',
          pid: '',
          orderSql:"",
          pageNo: 1,
          pageSize:config.pageSize,
        };
        this.tjlx = '0'
		    this.swjgmc = this.searchData.swjgDm == this.swjgList[0].id ? this.swjgList[0].text :  avalonRoot.user.swjgMc;
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
            $.fn.zTree.init($("#cktsxsjctjbTree"), setting, res.data);
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
        if ($(e.target).hasClass('disabled')) return;
        $(".treeDiv",$(e.target).parent()).show();
        $('.cktsxsjctjb').on('click',function(e){
          var e=e||window.event;
          if($('.treeDiv').find($(e.target)).length<=0){
              self.hideTree();
          }
        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.cktsxsjctjb').off('click');
      },
      // 下拉列表树
      initSelectTree:function(zbxmbm, treelistOrParams, isAsync) {
        var self = this;
        var domId = 'cktsxsjctjb_tree_'+zbxmbm.split('.')[0]+'_'+zbxmbm.split('.')[1]
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
        this.selectMc[zbxmbm].value = []
        var nameArr = []
        for (var i=0;i<res.length;i++) {
          this.selectMc[zbxmbm].value.push(res[i].code)
          nameArr.push(res[i].name)
        }
        this.selectMc[zbxmbm].name = nameArr.join(',')
      },
      showHyper:function(){
        $('.cktsxsjctjb .select-sub').toggle();
        $('.cktsxsjctjb .select-wrapper .icon').toggleClass("active");
        if ($('.cktsxsjctjb .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
          $('.cktsxsjctjb .select-wrapper .icon').attr("title","收起查询条件");
        } else {
          $('.cktsxsjctjb .select-wrapper .icon').attr("title","展开查询条件")
        }
      },
      closeHyper:function(){
        $('.cktsxsjctjb .select-sub').hide();
        $('.cktsxsjctjb .select-wrapper .icon').removeClass('active');
        $('.cktsxsjctjb .select-wrapper .icon').attr("title","展开查询条件")
      },
      exform:function(){
        if($('#cktsxsjctjb-table').jqGrid('getRowData').length<=0){
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
            item.zbxmbm = 'fzts.cksp'
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
            let domId = 'cktsxsjctjb_tree_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
            var treeObj = $.fn.zTree.getZTreeObj(domId);
            for (var j=0;j<item.values.length;j++) {
              let node = treeObj.getNodesByParam("code", item.values[j], null)[0];
              treeObj.checkNode(node, true, true);
            }
          } else { // 下拉多选
            let domId = '#cktsxsjctjb_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
            let options = []
            for(var j=0;j<obj.values.length;j++) {
              let tmp = obj.values[j]
              let selected = item.values.indexOf(tmp.code) > -1
              options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: selected})
            }
            $(domId).multiselect('dataprovider', options);
          }
        }
        if (['ts.amt_usd', 'ts.jsje', 'ts.sbtmse'].indexOf(reqParam.hzItems[0]) > -1) {
          this.tjlx = '0'
        } else {
          this.tjlx = '1'
        }
        this.tjlxChange()
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
      filDate: function (e,key) {
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