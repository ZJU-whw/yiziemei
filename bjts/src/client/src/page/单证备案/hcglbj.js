var hcglbj=require("./hcglbj.html");
avalon.component('hcglbj', {
    template:hcglbj,
    defaults: {
      params:{},
      act:1,
      tcode:"hcglbj",
	    swjgmc: "",
        selRows: [], // 选中项
        selRowsd: [],
        params: {
          inspectNo: '',
          nsrsbh: ''
        },
        nsrxx: {
          nsrsbh: '',
          nsrmc: '',
          qyhgdm: '',
          tsjsfs: '',
          gllb: '',
          jydz: '',
          lxr: '',
          lxrDh: '',
        },
        sbpcList: [],
        sbywzlOption: [],
        range: '',
        rangeList: ["0101","0102","0104"],	//核查单证类型范围
        dataList: [], 
        leftList: [],
        pcChooseList: [],
        dshpcList: [], // 待核查申报批次列表
        delShpcIdList: [],
        selShpcList: [],
        disabled: false,
        sbnypcList: [],
        pools: [],
        searchData:{
          nsrsbh:"",
          sbnypc:"",
          orderSql: "",
        },
        searchPcData: {
          sbywzl: '',
          sssq: '',
          sbpc: '',
          pageSize: config.pageSize
        },
        selRowsPc: [],
        statusOption: [
          { name: '未下达', value: '0' },
          { name: '已下达', value: '1' },
          { name: '已上报', value: '2' },
          { name: '已审核', value: '3' }
        ],
        typeTreeData: [],
        timer:null,
        tableArr:[],
        tableOption:[],
        setData:{
            zczt:"",
            ktpt:""
        },
        instance: null,
        isCheck: true,
        onReady:function(){
            try {
                this.swjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

          }
          this.getTypeTreeData()
          this.createTableSbpc();
          this.createTableDsbpc();
          this.createTablePcChoose()
          var self = this
          $('.hcglbj .datepicker.date-month').datetimepicker({
            language:'zh-CN',
            format: 'yyyymm',
            weekStart: 1,
            todayBtn: 1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 3, // 这里就设置了默认视图为年视图
            minView: 3, // 设置最小视图为年视图
            forceParse: 0
          })
        },
        getTypeTreeData: function() {
          var self = this
          ajax("POST","/dzba/inspect/tree").done(function(res){
            if(res.code=='0'){
              self.typeTreeData = res.data
              self.getInfo()
            }else{
              tools.info(res.msg);
            }
          }).fail(function(err){
            tools.info(err);
          })
        },
        getSbpcs: function() {
          var params = {
            nsrsbh: this.nsrxx.nsrsbh,
            sbywzl: this.searchPcData.sbywzl,
            sssq: this.searchPcData.sssq
          }
          var self = this
          ajax("POST","/dzba/inspect/task/available/sbpcs",params).done(function(res){
            if(res.code=='0'){
              self.sbpcList = (res.data&&res.data.sbpcs) || []
              self.searchPcData.sbpc = ''
            }else{
              self.sbpcList = []
              self.searchPcData.sbpc = ''
            }
          }).fail(function(err){
            tools.info(err);
          })
        },
        // 左边表格
        createTableSbpc:function(){
            var self=this;
            var columns =  [
              { name: "id", label: "id", index: "id",hidden: true,  width: 100, align:"left",sortable: false },
              { name: "sbnypc", label: "申报批次", index: "sbnypc",width: 140, align:"center",sortable: false },
              { name: "entryId", label: "报关单号/代理证明号", index: "entryId",width: 140, align:"center",sortable: false },
              { name: "tmse", label: "退免税额", index: "tmse",width: 140, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} }
            ]
            $("#hcglbj-sbpc-table").jqGrid({
                colModel: columns,
                datatype: "local",
                gridview: true,
                viewrecords: true,
                shrinkToFit: false,
                width:"100%",
                multiselect: true,
                multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                height:(function(){
                    return $(".hcglbj .form").height() - 74;
                })(),
                beforeSelectRow:function(rowid,e){
                  return true;
                },
                onSortCol: function (index, iCol, sortorder) {
                  self.searchData.orderSql = index + ' ' + sortorder;
                  self.search();
                  return;
                },
                onSelectRow: function(rowid,status){
                  var rowObj = $('#hcglbj-sbpc-table').getRowData(rowid)
                  var index = self.selRows.indexOf(rowid);
                  if (status) {
                    self.selRows.push(rowid)
                    self.selShpcList.push(rowObj)
                  } else {
                    self.selRows.splice(index,1);
                    self.selShpcList.splice(index,1)
                  }
                },
                onSelectAll: function(rowids,status) {
                  var rowArr = rowids.map(function(item){
                    return $('#hcglbj-sbpc-table').getRowData(item)
                  })
                  if (status) {
                    self.selRows = JSON.parse(JSON.stringify(rowids));
                    self.selShpcList = rowArr
                  } else {
                    self.selRows = [];
                    self.selShpcList = []
                  }
                }
            })
        },
        // 右边表格
        createTableDsbpc:function(){
          var self=this;
          var columns =  [
            { name: "id", label: "id", index: "id",hidden: true, width: 100, align:"left",sortable: false },
            { name: "sbnypc", label: "申报批次", index: "sbnypc",width: 140, align:"center",sortable: false },
            { name: "entryId", label: "报关单号/代理证明号", index: "entryId",width: 140, align:"center",sortable: false },
            { name: "tmse", label: "退免税额", index: "tmse",width: 140, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);}}
          ]
          $("#hcglbj-dsbpc-table").jqGrid({
              colModel: columns,
              datatype: "local",
              gridview: true,
              viewrecords: true,
              shrinkToFit: false,
              width:"100%",
              multiselect: true,
              multiselectWidth:"30",
              autowidth:true,
              altRows: true,
              altclass: "altclasscss",
              lastsort: 1,
              rowNum: config.pageSize,
              height:(function(){
                  return $(".hcglbj .form").height() -74;
              })(),
              beforeSelectRow:function(rowid,e){
                return true;
              },
              onSortCol: function (index, iCol, sortorder) {
                self.searchData.orderSql = index + ' ' + sortorder;
                return;
              },
              onSelectRow: function(rowid,status){
                var id = getCellData('hcglbj-dsbpc-table', rowid, 'id')
                var index = self.selRowsd.indexOf(rowid);
                if (status) {
                  self.selRowsd.push(rowid)
                  self.delShpcIdList.push(id)
                } else {
                  self.selRowsd.splice(index,1);
                  self.delShpcIdList.splice(index,1);
                }
              },
              onSelectAll: function(rowids,status) {
                var idArr = rowids.map(function(item){
                  return getCellData('hcglbj-dsbpc-table', item, 'id')
                })
                if (status) {
                  self.selRowsd = JSON.parse(JSON.stringify(rowids));
                  self.delShpcIdList = idArr;
                } else {
                  self.selRowsd = [];
                  self.delShpcIdList = [];
                }
              }
          })
        },
        // 筛选批次表格
        createTablePcChoose:function(){
          var self=this;
          var columns =  [
            { name: "inspectNo", label: "inspectNo", index: "inspectNo",hidden: true, width: 100, align:"left",sortable: false },
            { name: "sbywzl", label: "申报业务种类",hidden: true, index: "sbywzl",width: 160, align:"center",sortable: false },
            { name: "sbywzlName", label: "申报业务种类", index: "sbywzlName",width: 100, align:"center",sortable: false },
            { name: "sbnypc", label: "退税申报批次", index: "sbnypc",width: 80, align:"center",sortable: false },
            { name: "entryId", label: "报关单号/代理证明号", index: "entryId",width: 140, align:"center",sortable: false },
            { name: "je", label: "FOB价(美元)", index: "je", width: 100, align:"right",sortable: false,formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} },
            { name: "se", label: "退免税额", index: "se", width: 100, align:"right",sortable: false,formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} },
            { name: "ckfpNo", label: "出口发票号", index: "ckfpNo", width: 80, align:"center",sortable: false },
            { name: "jhfpNo", label: "进货发票号", index: "jhfpNo", width: 100, align:"center",sortable: false },
            { name: "sbrq", label: "退税申报日期", index: "sbrq", width: 80, align:"center",sortable: false },
            { name: "slrq", label: "退税受理日期", index: "slrq", width: 80, align:"center",sortable: false },
          ]
          $("#hcglbj-pc-table").jqGrid({
              colModel: columns,
              datatype: "local",
              gridview: true,
              viewrecords: true,
              rownumbers:true,
              pager: '#hcglbj-pc-tablePager',
              shrinkToFit: false,
              width:"100%",
              multiselect: true,
              multiselectWidth:"30",
              autowidth:true,
              altRows: true,
              altclass: "altclasscss",
              lastsort: 1,
              rowNum: config.pageSize,
              rowList: [20,50,100,500],
              height:200,
              onSortCol: function (index, iCol, sortorder) {
                self.searchPcData.orderSql = index + ' ' + sortorder;
                return;
              },
              onSelectRow: function(rowid,status){
                var rowObj = $('#hcglbj-pc-table').getRowData(rowid)
                var index = self.selRowsPc.indexOf(rowid);
                if (status) {
                  self.pcChooseList.push(rowObj)
                  self.selRowsPc.push(rowid)
                } else {
                  self.pcChooseList.splice(index,1);
                  self.selRowsPc.splice(index,1);
                }
              },
              onSelectAll: function(rowids,status) {
                var idArr = rowids.map(function(item){
                  return $('#hcglbj-pc-table').getRowData(item)
                })
                if (status) {
                  self.pcChooseList = idArr;
                } else {
                  self.pcChooseList = [];
                }
              },
              onPaging:function(pgButton){
                var pageNo=tools.getPageNo(pgButton,"hcglbj-pc-table");
                self.searchPc(pageNo);
              }
          })
          this.searchPcData.pageSize = $(".ui-pg-selbox", $('.hcglbj .page-model-pc')).val();
        },
        // 根据申报批次查询报关单池和已选择的报关单
        search:function(){
          var self=this;
          var params=tools.clone(self.searchData);
          params.nsrsbh=this.nsrxx.nsrsbh
          params.inspectNo=this.params.inspectNo
          $("#hcglbj-sbpc-table").jqGrid('clearGridData')
          self.selRows = []
          self.selShpcList = []
          ajax("POST","/dzba/inspect/task/interchange/list",params).done(function(res){
            if(res.code=='0'){
              self.dshpcList = tools.clone(res.data.choices || [])
              self.pools = tools.clone(res.data.pools || [] )
              $("#hcglbj-sbpc-table").resetSelection();
              $("#hcglbj-sbpc-table")[0].addJSONData(self.pools);
              $("#hcglbj-dsbpc-table").resetSelection();
              $("#hcglbj-dsbpc-table")[0].addJSONData(self.dshpcList);
            }else{
              tools.info(res.msg);
            }
          }).fail(function(err){
            tools.info(err);
          })
        },
        // 查询可用申报批次和报关单
        searchPc:function(pageNo){
          var self=this;
          this.searchPcData.pageSize = $(".ui-pg-selbox", $('.hcglbj .page-model-pc')).val() || 20;
          var params=tools.clone(self.searchPcData);
          params.nsrsbh=this.nsrxx.nsrsbh
          params.qyhgdm=this.nsrxx.qyhgdm
          params.inspectNo=this.params.inspectNo
          params.pageNo=pageNo
          $("#hcglbj-pc-table").jqGrid('clearGridData')
          $('.loading').show()
          ajax("POST","/dzba/inspect/task/available/list",params).done(function(res){
            if(res.code=='0'){
              $("#hcglbj-pc-table").resetSelection();
              $("#hcglbj-pc-table")[0].addJSONData(res.data);
              self.pcChooseList = []
            }else{
              tools.info(res.msg);
            }
            $('.loading').hide()
          }).fail(function(err){
            tools.info(err);
            $('.loading').hide()
          })
        },
      addItem: function () {
        if (this.selShpcList.length == 0) {
          tools.info("请选择报关单号/代理证明号");
          return false
        }
        var entryIds = this.selShpcList.map(function(item){
          return {id: item.id}
        })
        var params = {
          switchType: '1',
          entryIds
        }
        this.changeSwitch(params)
      },
      changeSwitch: function(params) {
        var self = this
        ajax("POST","/dzba/inspect/task/interchange/switch",params).done(function(res){
          if(res.code=='0'){
            self.search()
          } else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      delItem: function() {
        if (this.delShpcIdList.length == 0) {
          tools.info("请选择需要删除的申报批次");
          return false
        }
        var entryIds = this.delShpcIdList.map(function(item){
          return {id: item}
        })
        var params = {
          switchType: '2',
          entryIds
        }
        this.changeSwitch(params)
      },
      initTree:function() {
        var self = this;
        var setting = {
          view: {
            dblClickExpand: true,
            selectedMulti : true,//可以多选
            showLine: true
          },
          check: {  
            enable: true ,//显示复选框  
            chkStyle : "checkbox"
          },
          callback:{
            beforeCheck: function(){
              if (self.isCheck) {
                return true
              } else {
                return false
              }
            },
            onCheck:function onCheck(event, treeId, treeNode){
              if (treeNode.checked) {
                if (treeNode.value) {
                  self.rangeList.push(treeNode.value)
                } else {
                  var tmpArr = treeNode.item.map(function(item){return item.value})
                  self.rangeList = self.rangeList.concat(tmpArr)
                  self.rangeList = self.unique(self.rangeList)
                }
              } else {
                if (treeNode.value) {
                  var index = self.rangeList.indexOf(treeNode.value)
                  self.rangeList.splice(index,1)
                } else {
                  for (var i=0;i<self.rangeList.length;i++) {
                    for (var j=0;j<treeNode.item.length;j++) {
                      if (self.rangeList[i] == treeNode.item[j].value) {
                        self.rangeList.splice(i,1)
                        i--
                      }
                    }
                  }
                }
              }
              var params = {
                inspectNo: self.params.inspectNo,
                range: self.rangeList.join(',')
              }
              self.isCheck = false
              ajax("POST","/dzba/inspect/task/dzlx/save",params).done(function(res){
                if(res.code!='0'){
                  tools.info(res.msg);
                }
                self.isCheck = true
              }).fail(function(err){
                self.isCheck = true
                tools.info(err);
              })
            }
          },
          data:{key:{children:"item",name:"name"}}
        };
        $.fn.zTree.init($(".hcglbj .treeDiv"), setting, this.typeTreeData);
      },
      unique: function(arr) {
        return arr.filter(function(item, index, arr) {
          // 从数组0位开始查，如果当前元素在原始数组中的第一个索引==当前索引值，说明它是第一次出现。
          return arr.indexOf(item, 0) === index;
        });
      },
      getInfo:function() {
        var self = this
        var params = {
          inspectNo: this.params.inspectNo,
          nsrsbh: this.params.nsrsbh
        }
        ajax("POST","/dzba/inspect/task/open",params).done(function(res){
          if(res.code=='0'){
            self.nsrxx = res.data.nsrxx
            if (self.nsrxx.tsjsfs == '1' ) {
              self.sbywzlOption = [
                { value: "A0305001", name: "生产免抵退税" }
              ]
              self.searchPcData.sbywzl = 'A0305001'
            } else if (self.nsrxx.tsjsfs == '2' ) {
              self.sbywzlOption = [
                { value: "A0301001", name: "外贸免退税" },
                { value: "A0310001", name: "外综服代办退税" }
              ]
              self.searchPcData.sbywzl = 'A0301001'
            }
            self.range = res.data.range || '0101,0102,0104'
            self.rangeList = self.range.split(',')
            self.sbnypcList = res.data.sbnypcs || []
            self.pools = res.data.pools || []
            self.dshpcList = res.data.choices || []
            for(var i=0;i<self.typeTreeData.length;i++){
              var num = 0
              for(var j=0;j<self.typeTreeData[i].item.length;j++){
                for(var k=0;k<self.rangeList.length;k++){
                  if(self.typeTreeData[i].item[j].value == self.rangeList[k]){
                    self.typeTreeData[i].item[j].checked = true
                    num++
                  }
                }
              }
              if(num == self.typeTreeData[i].item.length){
                self.typeTreeData[i].checked = true
                self.typeTreeData[i].halfCheck = false
              }
            }
            self.initTree()
            $("#hcglbj-sbpc-table").resetSelection();
            $("#hcglbj-sbpc-table")[0].addJSONData(self.pools);
            $("#hcglbj-dsbpc-table").resetSelection();
            $("#hcglbj-dsbpc-table")[0].addJSONData(self.dshpcList);
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      add: function() { // 添加批次
        $('.model').show();
        $('.hcglbj .page-model-pc').show();
      },
      addPc: function() {
        var params = {
          nsrsbh: this.nsrxx.nsrsbh,
          inspectNo: this.params.inspectNo,
          inspectDatas: this.pcChooseList
        }
        var self = this
        ajax("POST","/dzba/inspect/task/available/add",params).done(function(res){
          if(res.code=='0'){
            self.sbnypcList = res.data.sbnypcs
            self.pools = res.data.pools
            $("#hcglbj-sbpc-table").resetSelection();
            $("#hcglbj-sbpc-table")[0].addJSONData(self.pools);
            self.hideModel()
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      },
      resetPc: function() {
        this.searchPcData = {
          sbywzl: this.nsrxx.tsjsfs == '1' ? 'A0305001': 'A0301001',
          sssq: '',
          sbpc: ''
        }
      },
      hideModel: function() {
        $('.model').hide();
        $('.hcglbj .page-model-pc').hide();
        this.resetPc()
        $("#hcglbj-pc-table").resetSelection();
        $("#hcglbj-pc-table")[0].addJSONData([]);
        this.pcChooseList = []
      }
    }
});