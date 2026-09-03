
var zhzbfzhztj=require("./zhzbfzhztj.html");
var jdglinfo = require('../../config/jdglinfo.js');
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component('zhzbfzhztj', {
    template:zhzbfzhztj,
    defaults: {
      params:{},
      act:1,
      tcode:"zhzbfzhztj",
	    swjgmc: "",
      swjgList: [],
      defaultSsny: {},
      searchData:{
        swjgDm:"",
        ssnyStart: "",
        ssnyEnd: "",
        zid: "",
        hzItems: [],
        fzItems: [],
        isHaveTb: '0',
        title: '',
        hztype: '',
        tjbbType: '01',
        pid: '',
        orderSql:"",
        pageNo: 1,
        pageSize:config.pageSize,
      },
      hzItemsMc: '',
      typeObj: {
        'hzItemsBl': '办理类',
        'hzItemsTs': '退税类',
        'hzItemsCk': '出口类'
      },
      sjlx: 'hzItemsBl',
      sjlxList: ['hzItemsBl','hzItemsTs','hzItemsCk'],
      selectMc: {},
      allSelectList: [],
      fzItemsList: [
        { name: '登记类', key: 'fzItemsDj', show: ['hzItemsCk','hzItemsTs','hzItemsBl']},
        { name: '等级类', key: 'fzItemsCw', show: ['hzItemsCk','hzItemsTs','hzItemsBl']},
        { name: '出口类', key: 'fzItemsCk', show: ['hzItemsCk']},
        { name: '退税类', key: 'fzItemsTs', show: ['hzItemsTs']},
      ],
      hzItems: {
        hzItemsCk: [],
        hzItemsTs: [],
        hzItemsBl: [],
      },
      fzItems: {
        fzItemsDj: [],
        fzItemsCk: [],
        fzItemsTs: [],
        fzItemsCw: []
      },
      checkList: [],
      dataList: {},
      title: [],
      total: 0,
      exformParams: {},
      qyfzList: [],
      historyConfig: {
        parent: 'zhzbfzhztj',
        tjbbType: '01'
      },
      ckspList: jdglinfo.ckspList,
      tableData: {},
      dataSsny: {},
      psize: '',
      tableHeight: '',
      startDate: '',
      endDate: '',
      dateCrossYearFlag: '',
      timer: null,
      tipDialog: null,
      onInit:function(e){
        avalonRoot.zhzbfzhztj = e.vmodel;
      },
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.dataSsny = avalonRoot.dataSsny
        this.tableHeight = $(".zhzbfzhztj .form").height() - 90
        this.getDateCrossYearFlag()
        this.getQueryCriteria()
      },
      getDateCrossYearFlag: function(){
        var self = this
        ajax("POST","/bjtssw/sjjc/param/init").done(function(res){
          if(res.code=='0'){
            self.dateCrossYearFlag = res.data.dateCrossYearFlag
            self.dataSsny = {
              dataSsnyStart: res.data.dataSsnyStart,
              dataSsnyEnd: res.data.dataSsnyEnd
            }
            self.initDate('ssnyStart')
            self.initDate('ssnyEnd')
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      initDate: function(key){
        this.startDate = this.dataSsny.dataSsnyStart.substr(0,4)+'-'+this.dataSsny.dataSsnyStart.substr(4,2)
        this.endDate = this.dataSsny.dataSsnyEnd.substr(0,4)+'-'+this.dataSsny.dataSsnyEnd.substr(4,2)
        var ssnyEnd = tools.getMonth()
        if (ssnyEnd > this.dataSsny.dataSsnyEnd) {
          ssnyEnd = this.dataSsny.dataSsnyEnd
        }
        var ssnyStart = ssnyEnd.substr(0,4) + '01'
        if (ssnyStart < this.dataSsny.dataSsnyStart) {
          ssnyStart = this.dataSsny.dataSsnyStart
        }
        this.defaultSsny = {
          ssnyStart: ssnyStart,
          ssnyEnd: ssnyEnd
        }
        this.searchData.ssnyStart = ssnyStart
        this.searchData.ssnyEnd = ssnyEnd

        var firstDate = this.searchData[key].substr(0,4)+'-'+this.searchData[key].substr(4,2)
        $('.zhzbfzhztj .datepicker.date-month.'+key).datetimepicker({
          language:'zh-CN',
          format: 'yyyymm',
          weekStart: 1,
          // todayBtn: true,
          // clearBtn: true,
          autoclose: 1,
          todayHighlight: true,
          startDate: this.startDate,
          endDate: this.endDate,
          startView: 3, // 这里就设置了默认视图为年视图
          minView: 3, // 设置最小视图为年视图
          forceParse: 0
        }).datetimepicker('setDate', new Date(firstDate)).on('show',function(e){
          var val = e.target.value
          var date = val.substr(0,4) + '-' + val.substr(4,2)
          $(e.target).datetimepicker('update', date)
        })
        
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
      // 数据类型变化
      sjlxChange: function(){
        this.searchData.hzItems = []
        var resetArr =  []
        // 清空分组指标下出口类、退税类
        var arr = this.fzItems.fzItemsCk.concat(this.fzItems.fzItemsTs)
        for (var i=0;i<arr.length;i++) {
          var zbxmbm = arr[i].zbxmbm
          var index = this.checkList.indexOf(zbxmbm)
          if (index > -1) {
            resetArr.push(arr[i])
            this.checkList.splice(index,1)
            i--
          } else if (index == -1 && this.selectMc[zbxmbm].range!='') {
            resetArr.push(arr[i])
          }
          this.selectMc[zbxmbm]={ name: '', value: [], range: ''}
        }
        this.initSelect(resetArr)
        // 数据项目重置
        this.initMultiselectSjxm(this.sjlx)
        this.hzItemsMc = ''
      },
      getQueryCriteria: function(){
        var self = this
        ajax("POST","/bjtssw/sjjc/dynamic/init").done(function(res){
          if(res.code=='0'){
            self.initTree()
            self.getQyfzList()
            self.showHyper()
            var data = res.data
            self.fzItems = {
              fzItemsCk: data.fzItemsCk,
              fzItemsCw: data.fzItemsCw,
              fzItemsDj: data.fzItemsDj,
              fzItemsTs: data.fzItemsTs
            }
            // 退税率下拉列表为空时，赋前端定义的值
            for (var i=0;i<self.fzItems.fzItemsCk.length;i++) {
              let item = self.fzItems.fzItemsCk[i]
              if (item.zbxmbm == 'fzck.tslv' && item.values.length == 0) {
                item.values = jdglinfo.tslv
              }
            }
            for (var i=0;i<self.fzItems.fzItemsTs.length;i++) {
              let item = self.fzItems.fzItemsTs[i]
              if (item.zbxmbm == 'fzts.tslv' && item.values.length == 0) {
                item.values = jdglinfo.tslv
              }
            }
            self.hzItems = {
              hzItemsCk: data.hzItemsCk,
              hzItemsTs: data.hzItemsTs,
              hzItemsBl: data.hzItemsBl
            }
            self.allSelectList = self.fzItems.fzItemsDj.concat(self.fzItems.fzItemsCk,self.fzItems.fzItemsTs,self.fzItems.fzItemsCw)
            self.resetSelectMc(self.allSelectList)
            self.initSelect(self.allSelectList)
            for(var z=0;z<self.sjlxList.length;z++){
              self.initMultiselectSjxm(self.sjlxList[z])
            }
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      initSelect: function(selectList){
        for (var i=0;i<selectList.length;i++) {
          let item = selectList[i]
          
          if (item.zbxmbm == 'fzts.cksp' || item.zbxmbm == 'fzck.cksp' ){
            // console.log(item,'initSelectTree');
            this.initSelectTree(item.zbxmbm,'&level=01', true)
          } else {
            if (item.isTree == '1') {
              // console.log(item,'item.isTree',item.zbxmbm,item.values);
                this.initSelectTree(item.zbxmbm, item.values)
            } else {
              // console.log(item,'else');
              this.initMultiselect(item)
            }
          }
        }
      },
      // 多选下拉框
      initMultiselect: function(item){
        var self = this
        let id = '#zhzbfzhztj_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
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
      // 多选下拉框
      initMultiselectSjxm: function(sjlx){
        var self = this
        let id = '#zhzbfzhztj-sjxm-'+sjlx
        let options = []
        for(var i=0;i<this.hzItems[sjlx].length;i++) {
          let tmp = this.hzItems[sjlx][i]
          options.push({label: tmp.zbxmmc, title: tmp.zbxmmc, value: tmp.zbxmbm, selected: false})
        }
        $(id).multiselect({
          buttonText: function(options, select) {
            return '选择';
          },
          onChange: function(option, checked, select) {
            let val = $(option).val()
            let values = self.searchData.hzItems
            if (checked) {
              values.push(val)
            } else {
              let i = values.indexOf(val)
              values.splice(i,1)
            }
            self.searchData.hzItems = values
            var mcArr = []
            for (var i=0;i<self.hzItems[self.sjlx].length;i++) {
              var item = self.hzItems[self.sjlx][i]
              console.log(item)
              if (self.searchData.hzItems.indexOf(item.zbxmbm) > -1) {
                mcArr.push(item.zbxmmc)
              }
            }
            self.hzItemsMc = mcArr.join(',')
          }
        });
        $(id).multiselect('dataprovider', options);
      },
      resetTableCol: function(){
        var columns = []
        var keys = this.title
        for (var i=0;i<this.dataList.length;i++) {
          for(var j=0;j<keys.length;j++) {
            let item = keys[j]
            let isNumArr = item.split('#')
            let isNum = isNumArr[1] == '千'
            let alignArr = isNumArr[0].split('_')
            let align = alignArr[1] == '左' ? 'left' : (alignArr[1] == '右' ? 'right' : 'center')
            let name = alignArr[0]
            var contentWidth = tools.textSize(this.dataList[i][item]).width + 20
            var keyWidth = tools.textSize(name).width + 20
            contentWidth = contentWidth < 100 ? 100 : contentWidth
            keyWidth = keyWidth < 100 ? 100 : keyWidth
            var width = contentWidth < keyWidth ? keyWidth : contentWidth
            width = width > 200 ? 200 : width
            if (columns.length < keys.length) {
              let obj = {}
              if (name.indexOf('同比-') > -1) {
                obj = {name: item, label: '同比(%)', index: item, width: width, align: 'right', sortable: false}
                if (j== 0) {
                  obj.formatter = function(cellvalue, options, rowObject){
                    let val = cellvalue? Math.round(cellvalue*100)/100 : '-'
                    return '<span class="toMx link">'+val+'</span>'
                  }
                } else {
                  obj.formatter = function(cellvalue, options, rowObject){
                    let val = cellvalue? Math.round(cellvalue*100)/100 : '-'
                    return val
                  }
                }
              } else {
                obj = {name: item, label: name, index: item, width: width, align: align, sortable: false}
                if (j==0) {
                  if (isNum){
                    obj.formatter = function(cellvalue, options, rowObject){
                      let val = avalon.filters.number(cellvalue,2)
                      return '<span class="toMx link">'+val+'</span>'
                    }
                  } else {
                    obj.formatter = function(cellvalue, options, rowObject){
                      let val = typeof(cellvalue) == 'undefined' ? '' : cellvalue 
                      return '<span class="toMx link">'+val+'</span>'
                    }
                  }
                } else {
                  if (isNum){
                    obj.formatter = function(cellvalue, options, rowObject){
                      let val = avalon.filters.number(cellvalue,2)
                      return val
                    }
                  }
                }
              }
              columns.push(obj)
            } else {
              if (columns[j].width < width) {
                columns[j].width = width
              }
            }
          }
        }
        columns.push({name: 'fzhash', label: 'fzhash', index: 'fzhash', hidden: true})
        return columns
      },
      createTable:function(){
        var self=this;
        var columns = this.resetTableCol()
        $("#zhzbfzhztj-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            pager: '#zhzbfzhztj-tablePager',
            shrinkToFit: false,
            width:"100%",
            // multiselect: true,
            // multiselectWidth:"40",
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
              var fzhash = $('#zhzbfzhztj-table').getRowData(rowid).fzhash
              var datas = self.tableData.list.rows
              var tmp = {}
              for (var i=0;i<datas.length;i++) {
                if (datas[i].fzhash == fzhash) {
                  tmp = datas[i]
                }
              }
              var keys = Object.keys(tmp)
              var row = {}
              for (var i=0;i<keys.length;i++) {
                if (keys[i] == 'ROW_ID') {
                  row[keys[i]] = tmp[keys[i]]
                } else {
                  let name = keys[i].split('#')[0].split('_')[0]
                  row[name] = tmp[keys[i]]
                }
              }
              if($(e.target).hasClass('toMx')){
                var fzItems = []
                for (var i=0;i<self.exformParams.fzItems.length;i++) {
                  let item = self.exformParams.fzItems[i]
                  var val = ''
                  if (item.zbxmbm.indexOf('cksp') > -1) {
                    let name = ''
                    for (var k=0;k<jdglinfo.ckspList.length;k++) {
                      if (jdglinfo.ckspList[k].value == item.zbxmbm) {
                        name = jdglinfo.ckspList[k].key
                      }
                    }
                    val = row[name].split('-')[0]
                    fzItems.push({zbxmbm: item.zbxmbm, values: [val]})
                    break;
                  }
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
                var params = tools.clone(self.exformParams)
                params.fzItems = fzItems
                params.flushFlag = '0'
                avalonRoot.addTab({title:"综合指标分组汇总统计明细表",component:"zhzbfzhztjmx",params:params});
                return true;
              }
              return true;
            },
            gridComplete: function(){
              var sumData = {}
              for (var key in self.tableData.hj) {
                sumData[key] = self.tableData.hj[key] == undefined ? '' : self.tableData.hj[key]
              }
              sumData['rn']="合计";
              $("#zhzbfzhztj-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
              self.searchData.orderSql = index + ' ' + sortorder;
              self.search(1);
              return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton,"zhzbfzhztj-table");
              self.search(pageNo);
            }
        })
        this.searchData.pageSize = $(".ui-pg-selbox", $('.zhzbfzhztj')).val();
      },
      search:function(pageNo, isRefresh, isShowTips){
        var self=this;
        if (this.dateCrossYearFlag == '0' && this.searchData.isHaveTb == '1') { // 不允许跨年
          let startY = this.searchData.ssnyStart.substr(0,4)
          let endY = this.searchData.ssnyEnd.substr(0,4)
          if (startY != endY){
            tools.info('查询统计【同比】数据，时间区间请选择同一年份')
            return false
          }
        }
        var dateValid = tools.checkDate(this.searchData.ssnyStart, this.searchData.ssnyEnd)
        if (!dateValid) {
          tools.info('统计年月截止时间必须大于起始时间')
          return false
        }
        if (this.searchData.hzItems.length==0) {
          tools.info('请先勾选数据项目！')
          return false
        }
        var fzItems = []
        this.checkList.sort()
        for (var i=0;i<this.checkList.length;i++) {
          let item = this.checkList[i]
          fzItems.push({
            zbxmbm: item.indexOf('cksp')>-1 ? (this.selectMc[item].range || 'cksp.01') : item,
            range: '',
            values: this.selectMc[item].value,
            name: this.selectMc[item].name
          })
        }
        this.searchData.fzItems = fzItems
        var titleArr = [this.typeObj[this.sjlx], this.swjgmc, this.searchData.ssnyStart, this.searchData.ssnyEnd]
        if (this.searchData.zid) {
          for( var j=0;j<this.qyfzList.length;j++) {
            if (this.qyfzList[j].zid == this.searchData.zid) {
              titleArr.push(this.qyfzList[j].sname)
              break;
            }
          }
        }
        this.searchData.title = titleArr.join('_')
        this.searchData.hztype = this.sjlx
        this.searchData.pageNo = pageNo
        if (pageNo == 1) {
          this.searchData.pid = ''
        }
        this.searchData.pageSize = this.psize == '' ? ($(".ui-pg-selbox", $('.zhzbfzhztj')).val() || 20): this.psize;
        this.psize = ''
        this.exformParams = tools.clone(this.searchData)
        var params = tools.clone(this.searchData)
        params.flushFlag = isRefresh ? '1' : '0'
        this.tableHeight = $(".zhzbfzhztj .form").height() - 90
        $('.zhzbfzhztj .mask').show()
        $("#zhzbfzhztj-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/dynamic",params, true, false, true).done(function(res){
          $('.zhzbfzhztj .mask').hide()
          if(res.code=='0'){
            self.title = res.data.title
            self.total = res.data.list.count
            self.dataList = tools.clone(res.data.list.rows)
            self.searchData.pid = res.data.pid
            var data = tools.clone(res.data.list)
            if (self.total == 0) data.rows = []
            self.tableData.hj={};
            self.selRows = [];
            $("#zhzbfzhztj-table").jqGrid('GridUnload')
            self.createTable()
            if (res.data.tips && res.data.tips != '' && isShowTips) {
              var dialog = $.dialog({
                title: "提示",
                content: res.data.tips,
                okValue: '直接查看',
                lock:true,
                ok: function(){
                  self.tableData=tools.clone(res.data);
                  $("#zhzbfzhztj-table")[0].addJSONData(data);
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
              $("#zhzbfzhztj-table")[0].addJSONData(data);
            }
            self.closeHyper()
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          $('.zhzbfzhztj .mask').hide()
          tools.info(err);
        })
      },
      showHyper:function(){
        $('.zhzbfzhztj .select-sub').toggle();
        $('.zhzbfzhztj .select-wrapper .icon').toggleClass("active");
        if ($('.zhzbfzhztj .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
          $('.zhzbfzhztj .select-wrapper .icon').attr("title","收起查询条件");
        } else {
          $('.zhzbfzhztj .select-wrapper .icon').attr("title","展开查询条件")
        }
      },
      closeHyper:function(){
        $('.zhzbfzhztj .select-sub').hide();
        $('.zhzbfzhztj .select-wrapper .icon').removeClass('active');
        $('.zhzbfzhztj .select-wrapper .icon').attr("title","展开查询条件")
      },
	    reset: function() {
		    this.searchData = {
          swjgDm:avalonRoot.user.swjgDm,
          ssnyStart: this.defaultSsny.ssnyStart,
          ssnyEnd: this.defaultSsny.ssnyEnd,
          zid: "",
          fzItems: [],
          hzItems: [],
          isHaveTb: "0",
          hztype: "",
          tjbbType: '01',
          pid: '',
          orderSql:"",
          pageNo: "1",
          pageSize:config.pageSize,
        };
        this.sjlx = 'hzItemsBl',
		    this.swjgmc = this.searchData.swjgDm == this.swjgList[0].id ? this.swjgList[0].text :  avalonRoot.user.swjgMc;
        this.resetSelectMc(this.allSelectList)
        this.initSelect(this.allSelectList)
        this.initMultiselectSjxm(this.sjlx)
        this.checkList = []
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
            $.fn.zTree.init($("#zhzbfzhztjTree"), setting, res.data);
            self.swjgList = res.data
            if (avalonRoot.user.swjgDm == self.swjgList[0].id) {
              self.swjgmc = self.swjgList[0].text
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
        $('.zhzbfzhztj').on('click',function(e){
          var e=e||window.event;
          if($('.treeDiv').find($(e.target)).length<=0){
            self.hideTree();
          }
        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.zhzbfzhztj').off('click');
      },
      // 下拉列表树
      // isAsync: true-异步加载时 listOrParams-参数
      //          false时 listOrParams-树形数据
      initSelectTree:function(zbxmbm, treelistOrParams, isAsync) {
        var self = this;
        var domId = 'zhzbfzhztj_tree_'+zbxmbm.split('.')[0]+'_'+zbxmbm.split('.')[1]
      if(zbxmbm=='fzts.myfs'){
        console.log(domId,'domId');
        console.log(treelistOrParams,'treelistOrParams');
      }
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
          if(zbxmbm=='fzts.myfs'){
            console.log(setting,treelistOrParams);
          }
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
        console.log(res,this.checkList);
        
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
        console.log(this.selectMc,'this.selectMc');
        
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
        this.sjlx = reqParam.hztype
        var arr = []
        if (this.sjlx == 'hzItemsBl') {
          arr = this.fzItems.fzItemsDj.concat(this.fzItems.fzItemsCw)
        } else if (this.sjlx == 'hzItemsTs') {
          arr = this.fzItems.fzItemsDj.concat(this.fzItems.fzItemsCw,this.fzItems.fzItemsTs)
        } else if (this.sjlx == 'hzItemsCk') {
          arr = this.fzItems.fzItemsDj.concat(this.fzItems.fzItemsCw,this.fzItems.fzItemsCk)
        }
        this.resetSelectMc(this.allSelectList)
        this.initSelect(arr)
        this.searchData = tools.clone(reqParam)
        this.psize = this.searchData.pageSize
        this.swjgmc = reqParam.title.split('_')[1]
        this.checkList = []
        for(var i=0;i<reqParam.fzItems.length;i++) {
          let item = reqParam.fzItems[i]
          let isCksp = item.zbxmbm.indexOf('cksp') > -1
          if (isCksp) {
            let range = item.zbxmbm
            item.zbxmbm = self.sjlx == 'hzItemsTs' ? 'fzts.cksp' : 'fzck.cksp'
            item.range = range
            let val = item.values.join(',')
            let params = val + '&level='+range.split('.')[1]
            self.initSelectTree(item.zbxmbm,params,true) // 下拉树形多选异步加载
          } 
          self.checkList.push(item.zbxmbm)
          self.selectMc[item.zbxmbm].name = item.name
          self.selectMc[item.zbxmbm].value = item.values
          self.selectMc[item.zbxmbm].range = item.range
          if (isCksp) continue;
          let obj = {}
          for (var n=0;n<self.allSelectList.length;n++) {
            if (self.allSelectList[n].zbxmbm == item.zbxmbm) {
              obj = self.allSelectList[n]
            }
          }
          if (obj.isTree == '1') { // 下拉树形多选
            let domId = 'zhzbfzhztj_tree_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
            var treeObj = $.fn.zTree.getZTreeObj(domId);
            for (var j=0;j<item.values.length;j++) {
              let node = treeObj.getNodesByParam("code", item.values[j], null)[0];
              treeObj.checkNode(node, true, true);
            }
          } else { // 下拉多选
            let domId = '#zhzbfzhztj_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
            let options = []
            for(var j=0;j<obj.values.length;j++) {
              let tmp = obj.values[j]
              let selected = item.values.indexOf(tmp.code) > -1
              options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: selected})
            }
            $(domId).multiselect('dataprovider', options);
          }
        }
        // 数据项目
        let domId = '#zhzbfzhztj-sjxm-'+this.sjlx
        let options = []
        var mcArr = []
        for(var j=0;j<this.hzItems[this.sjlx].length;j++) {
          let tmp = this.hzItems[this.sjlx][j]
          let selected = this.searchData.hzItems.indexOf(tmp.zbxmbm) > -1
          if (selected) {
            mcArr.push(tmp.zbxmmc)
          }
          options.push({label: tmp.zbxmmc, title: tmp.zbxmmc, value: tmp.zbxmbm, selected: selected})
        }
        self.hzItemsMc = mcArr.join(',')
        $(domId).multiselect('dataprovider', options);
        self.search(1, false, true)
      },
      ckspLevelChange: function(zbxmbm){
        this.selectMc[zbxmbm].name = ''
        this.selectMc[zbxmbm].value = []
        var params = '&level='+this.selectMc[zbxmbm].range.split('.')[1]
        this.initSelectTree(zbxmbm, params, true)
      },
      checkListChange: function(e){
        var zbxmbm = e.target.value
        if (!e.target.checked) {
          var obj = {}
          for(var i=0;i<this.allSelectList.length;i++) {
            if (this.allSelectList[i].zbxmbm == zbxmbm) {
              obj = this.allSelectList[i]
              break;
            }
          }
          this.initSelect([obj])
          this.selectMc[zbxmbm] = { name: '', value: [], range: ''}
        }
      },
      filDate: function (e, key) {
        var date = e.target.value;
        if (date == '') {
          res = this.defaultSsny[key]
        } else {
          var res = tools.MonCheup(date);
          if (res === false) {
            tools.info("日期输入错误");
            res = this.defaultSsny[key]
          } else {
            if (res < this.startDate || res >this.endDate) {
              res = this.defaultSsny[key]
            }
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
      showDropdown: function (e) {
        var self = this;
        $(".dropdown-menu", e.target).show();
        $('.zhzbfzhztj').on('click', function (e) {
          var e = e || window.event;
          if ($('.dropdown-menu').find($(e.target)).length <= 0) {
            self.hideDropdown();
          }
        })
      },
      hideDropdown: function () {
        $(".dropdown-menu").hide();
        $('.zhzbfzhztj').off('click');
      },
      exformAll: function(){
        if($('#zhzbfzhztj-table').jqGrid('getRowData').length<=0){
          tools.info("请先查询列表");
          return ;
        }
        this.hideDropdown();
        var self=this;
        var params = tools.clone(self.exformParams);
        params.flushFlag='0';
        params.tjbbType='XLS01';
        this.exformTimer(params,true)
      },
      exformTimer: function(params,isFirst){
        var self = this
        ajax("POST","/bjtssw/sjjc/export/dynamic/init",params).done(function(res){
          if(res.code=='0'){
            var pages = res.data.pages
            if (pages == 0 && isFirst) {
              if (isFirst) {
                var d = $.dialog({
                  title: '提示',
                  content: '正在生成导出文件，请耐心等候...',
                  lock:true,
                  cancel: false,
                  button: [
                    {
                      value: '取消',
                      callback: function () {
                        clearTimeout(self.timer)
                      }
                    }
                  ]
                })
              }
              self.timer = setTimeout(function(){
                self.exformTimer(params)
              },2000)
            } else if (pages != 0) {
              d&&d.close().remove();
              var d2 = $.dialog({
                title: "提示",
                content: '导出文件生成完毕，正在下载',
                okValue: "确定",
                lock:true,
                ok: function () {}
              })
              for (var i=0;i<pages;i++) {
                (function(j) {
                  setTimeout(function(){
                    self.exform(j+1,res.data.pid)
                    if (j==pages-1){
                      setTimeout(function(){
                        d2&&d2.close();
                      },1000);
                    }
                  },1000*i);
                })(i)
              }
            }
          } else {
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      exformCurrentPage: function(){
        if($('#zhzbfzhztj-table').jqGrid('getRowData').length<=0){
          tools.info("请先查询列表");
          return;
        }
        this.hideDropdown();
        this.exform();
      },
      exform:function(pageNo,pid){
        var self=this;
        var params = tools.clone(self.exformParams);
        params.flushFlag='0';
        if (pageNo) {
          params.pageNo = pageNo;
          params.pid = pid;
          params.tjbbType = 'XLS01';
          delete params.pageSize;
        }
        tools.exform(params,"/bjtssw/sjjc/saveDynamicExcel")
      }
    }
});