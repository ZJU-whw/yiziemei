
var cktstjzb=require("./cktstjzb.html");
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component('cktstjzb', {
    template:cktstjzb,
    defaults: {
      params:{},
      act:1,
      tcode:"cktstjzb",
	    swjgmc: "",
      searchData:{
        swjgDm:"",
        ssnyStart: "",
        ssnyEnd: "",
        orderSql:"",
        pageSize:config.pageSize,
      },
      tableData:{},
      exformParams: {},
      swjgList: [],
      dateCrossYearFlag: '',
      onReady:function(){
        try {
          this.searchData.swjgDm=avalonRoot.user.swjgDm;
          this.swjgmc=avalonRoot.user.swjgMc;
        } catch (e) {}
        this.initDate()
        this.initTree()
        this.createTable();
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
        $('.cktstjzb .datepicker.date-month').datetimepicker({
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
      createTable:function(){
        var self=this;
        var columns = [
          { name: "税务机关", label: "税务机关", index: "税务机关",width: 160, align:"left",sortable: false, formatter:function(cellvalue, options, rowObject){
            var node = fxjsCommonFun.getItemByIdInTree(cellvalue, self.swjgList)
            return node ? node.text : cellvalue;
          }},
          { name: "户数", label: "户数", index: "户数",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name, true)
          }},
          { name: "同比-0", label: "同比%", index: "同比-0",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = self.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "申报户数", label: "户数", index: "申报户数",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name, true)
          }},
          { name: "同比-1", label: "同比%", index: "同比-1",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = self.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "申报退税额", label: "退税额", index: "申报退税额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name)
          }},
          { name: "同比-2", label: "同比%", index: "同比-2",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = self.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "申报免抵额", label: "免抵额", index: "申报免抵额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name)
          }},
          { name: "同比-3", label: "同比%", index: "同比-4",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = self.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "核准户数", label: "户数", index: "核准户数",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name, true)
          }},
          { name: "同比-4", label: "同比%", index: "同比-4",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = self.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "核准退税额", label: "退税额", index: "核准退税额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name)
          }},
          { name: "同比-5", label: "同比%", index: "同比-5",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = self.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "核准免抵额", label: "免抵额", index: "核准免抵额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name)
          }},
          { name: "同比-6", label: "同比%", index: "同比-6",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = self.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "办理户数", label: "户数", index: "办理户数",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name, true)
          }},
          { name: "同比-7", label: "同比%", index: "同比-7",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = self.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "办理退税额", label: "退税额", index: "办理退税额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name)
          }},
          { name: "同比-8", label: "同比%", index: "同比-8",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = self.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
          { name: "办理免抵额", label: "免抵额", index: "办理免抵额",width: 160, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            return self.getFormatter(rowObject, options.colModel.name)
          }},
          { name: "同比-9", label: "同比%", index: "同比-9",width: 90, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
            var val = self.getFormatter(rowObject, options.colModel.name, true);
            return parseFloat(val).toFixed(2);
          }},
        ];
        $("#cktstjzb-table").jqGrid({
            datatype: "local",
            gridview: true,
            colModel: columns,
            viewrecords: true,
            rownumbers:true,
            pager: '#cktstjzb-tablePager',
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
                return $(".cktstjzb .form").height() - 120;
            })(),
            beforeSelectRow:function(rowid,e){
              if($(e.target).hasClass('check')){ // 查看
              
              } 
              return true;
            },
            gridComplete: function(){
              // var sumData=self.tableData.sumData;
              var sumData = {}
              sumData['rn']="合计";
              var key = ['户数', '申报户数', '申报退税额', '申报免抵额', '核准户数', '核准退税额', '核准免抵额', '办理户数', '办理退税额', '办理免抵额', ]
              var rows = self.tableData.list ? self.tableData.list.rows : []
              for(var i=0;i<rows.length;i++) {
                let item = rows[i]
                let colKey = Object.keys(item)
                for (var j=0;j<colKey.length;j++) {
                  let name = colKey[j].split('#')[0].split('_')[0]
                  if (key.indexOf(name) > -1) {
                    sumData[name] = sumData[name] ? (sumData[name]+item[colKey[j]]): item[colKey[j]]
                  }
                }
              }
              $("#cktstjzb-table").footerData('set', sumData);
            },
            onSortCol: function (index, iCol, sortorder) {
                self.searchData.orderSql = index + ' ' + sortorder;
                self.search(1);
                return;
            },
            onPaging:function(pgButton){
              var pageNo=tools.getPageNo(pgButton,"cktstjzb-table");
              self.search(pageNo);
            }

        })
        $("#cktstjzb-table").jqGrid('setGroupHeaders', {
          useColSpanStyle: true,
          groupHeaders:[
              {startColumnName:'户数', numberOfColumns:2, titleText: '备案'},
              {startColumnName:'申报户数', numberOfColumns:6, titleText: '申报'},
              {startColumnName:'核准户数', numberOfColumns:6, titleText: '核准'},
              {startColumnName:'办理户数', numberOfColumns:6, titleText: '办理'}
          ]
        });
        this.searchData.pageSize = $(".ui-pg-selbox", $('.cktstjzb')).val();
        this.search(1)
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
          tools.info('退还日期截止时间必须大于起始时间')
          return false
        }
        this.searchData.pageSize = $(".ui-pg-selbox", $('.cktstjzb')).val() || 20;
        var params = tools.clone(this.searchData)
        params.pageNo=pageNo;
        this.exformParams = tools.clone(params)
        $("#cktstjzb-table").jqGrid('clearGridData')
        ajax("POST","/bjtssw/sjjc/query/cktms",params).done(function(res){
          if(res.code=='0'){
            self.tableData=res.data;
            $("#cktstjzb-table")[0].addJSONData(res.data.list);
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
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
            self.swjgList = res.data
            $.fn.zTree.init($(".cktstjzb .treeDiv"), setting, res.data);
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
        $('.cktstjzb').on('click',function(e){
          var e=e||window.event;
          if($('.treeDiv').find($(e.target)).length<=0){
              self.hideTree();
          }
        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.cktstjzb').off('click');
      },
      exform:function(){
        if($('#cktstjzb-table').jqGrid('getRowData').length<=0){
          tools.info("无导出数据！");
          return ;
        }
        var self=this;
        var params = tools.clone(self.exformParams);
        params.tjbbType = '02'
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
        return;
      },
      // 日期选择框多次点击会隐藏的bug修复
      showDatetimepicker: function(e){
        $(e.target).datetimepicker('show');
      },
    }
});