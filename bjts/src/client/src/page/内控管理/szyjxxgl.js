var szyjxxgl = require("./szyjxxgl.html");

avalon.component('szyjxxgl', {
  template: szyjxxgl,
  defaults: {
    activeIndex: '0',
    swjgList: ["13300000000","13301000000","13302000000","13303000000","13304000000","13305000000","13306000000","13307000000","13308000000","13309000000","13310000000","13311000000"], // 省市级税务机关代码列表
    hasHsPermission: false, // 是否有核实处理权限
    columns: [
      { name: "uuid", label: "内控业务关键字", index: "uuid",hidden:true },
      { name: "nkzbmc", label: "内控指标名称", index: "nkzbmc",width: 300, align:"left",sortable: true },
      { name: "nkywms", label: "内控业务描述", index: "nkywms",width: 400, align:"left",sortable: true },
      { name: "area", label: "所属地区", index: "area",width: 140, align:"left",sortable: true },
    ],
    searchData: {
      zbbh: "",
      fssjQ: "",
      fssjZ: "",
      orderSql: "",
      pageNo: 1,
      pageSize: 20,
      cldz:''
    },
    modelData: {},
    dataList: [],
    tempNode:'',
    onInit: function (e) {
      avalonRoot.szyjxxgl = e.vmodel;
    },
    onReady: function () {
      this.initDate()
      this.initTree();
      // this.hasHsPermission = this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1
      this.hasHsPermission = false
      this.createTableWwc()
    },
    initDate: function(){
			var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
			$('.szyjxxgl .datepicker.date-day').datetimepicker(options);
    },
    createTableWwc: function(){
      var btnName = this.hasHsPermission?'核实处理':'查看'
      var wwcColumns = [
        { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh" },
        { name: "nsrmc", label: "纳税人名称", index: "nsrmc" },
        { name: "uuid", label: "内控业务关键字", index: "uuid",hidden:true },
        { name: "nkzbbh", label: "内控指标编号", index: "nkzbbh",hidden:true },
        { name: "nkzbmc", label: "内控指标名称", index: "nkzbmc",width: 300, align:"left",sortable: true },
        { name: "nkywms", label: "内控业务描述", index: "nkywms",width: 400, align:"left",sortable: true },
        { name: "area", label: "所属地区", index: "area",width: 140, align:"left",sortable: true },
        { name: "cfsj", label: "触发时间", index: "cfsj",width: 140, align:"left" },
        { name: "cldz", label: "处理动作", index: "cldz",width: 140, align:"left" },
        { name: "op", label: "操作", index: "op",width: 100, sortable: false, formatter: function(cellvalue, options, rowObject){
          var op = "<div style='text-align:center;'><div style='text-align:center;'><div class='btn op-hscl' style='float: none;display: inline-block;' title='"+btnName+"'>"+btnName+"</div>";
          op +="</div>";
          return op;
        } }
      ]
      this.createTable(wwcColumns, 'szyjxxgl-wwc-table');
    },
    createTableYwc: function(){
      var btnName = this.hasHsPermission?'核实处理':'查看'
      var ywcColumns = [
        { name: "op2", label: "操作", index: "op",width: 0,frozen: true,align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
          var op = "<div style='text-align:center;'><div style='text-align:center;'><div class='btn op-hscl' style='float: none;display: inline-block;' title='"+btnName+"'>"+btnName+"</div>";
          op +="</div>";
          return op;
        } },
        { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh" },
        { name: "nsrmc", label: "纳税人名称", index: "nsrmc" },
        { name: "uuid", label: "内控业务关键字", index: "uuid",hidden:true },
        { name: "nkzbbh", label: "内控指标编号", index: "nkzbbh",hidden:true },
        { name: "nkzbmc", label: "内控指标名称", index: "nkzbmc",width: 300, align:"left",sortable: true },
        { name: "nkywms", label: "内控业务描述", index: "nkywms",width: 400, align:"left",sortable: true },
        { name: "area", label: "所属地区", index: "area",width: 140, align:"left",sortable: true },
        { name: "nkclsm", label: "内控处理说明", index: "nkclsm",width: 140, align:"left",sortable: true },
        { name: "nkclry", label: "内控处理人员", index: "nkclry",width: 140, align:"left",sortable: true },
        { name: "nkclsj", label: "内控处理时间", index: "nkclsj",width: 140, align:"center",sortable: true },
				{ name: "op", label: "操作", width: 110, align: "center", resizable: false, search: false, sortable: false }
      ]
      this.createTable(ywcColumns, 'szyjxxgl-ywc-table');
			$("#szyjxxgl-ywc-table").jqGrid('setFrozenColumns');
			tools.HeiKjNoSel('szyjxxgl', 'szyjxxgl-ywc-table');
    },
    initTree: function () {
      var self = this;
      var setting = {
        view: {
          showIcon: false,
        },
        callback: {
          onClick: function (e, id, node) {
            self.searchData.zbbh = node.zbbh
            self.search(1)
            return;
          }
        },
        data: { key: { children: "items", name: "zbmc" } }
      };
      api.getTsgzSecondETree({
        nklx:"2",
        qssj: this.searchData.fssjQ,
        jzsj: this.searchData.fssjZ,
        cldz:this.searchData.cldz
      }).done(function (res) {
        if (res.code == '0') {
          $.fn.zTree.init($("#szyjTree"), setting, res.data);
          var treeObj = $.fn.zTree.getZTreeObj('szyjTree');//ztree树的ID
          var node = treeObj.getNodeByParam("zbbh", self.searchData.zbbh);//根据ID找到该节点
          treeObj.selectNode(node)
          // self.searchData.zbbh = res.data.zbbh
        }
      })
    },
    changeTab: function(index){
      // this.activeIndex = index
      this.search(1)
      // if (this.activeIndex == '1') {
      //   // $("#szyjxxgl-ywc-table").setGridWidth($('.szyj-right').width());
      //   this.createTableYwc()
      // }
    },
    createTable:function(columns, id){
			var self=this;
			$('#'+id).jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#'+id+'Pager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				altclass: "altclasscss",
				// lastsort: 1,
				rowNum: config.pageSize,
				width:"100%",
				height:(function(){
					return $(".szyjxxgl .szyj-right").height() -130;
				})(),
				beforeSelectRow:function(rowid,e){
					// var uuid = getCellData(id, rowid, 'uuid');
					// var nkzbbh = getCellData(id, rowid, 'nkzbbh');
					if($(e.target).hasClass('disabled')) return false;
					if($(e.target).hasClass('op-hscl')){
            self.getTsgzSecondEClMxSingle(rowid);
					}else if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
						return false;	
					}else{
						return true;
					}
				},
				onSortCol: function (index, iCol, sortorder) {
					var orderSql = index + ' ' + sortorder;
					self.searchData.orderSql = orderSql;
					self.search(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,id);
					self.search(pageNo);
				}
			});
		},
    showModel: function(){
      $('.model').show()
      $('.szyjxxgl .hscl-page-model').show()
    },
    hideModel: function(){
      $('.model').hide()
      $('.szyjxxgl .hscl-page-model').hide()
    },
    search: function (pageNo) {
      if (!this.searchData.zbbh) return;
      var self = this;
      var valid = tools.checkDate(this.searchData.fssjQ,this.searchData.fssjZ)
			if (!valid) {
				tools.info('发生时间止不能小于发生时间起！');
				return;
			}
      this.searchData.pageSize = $(".ui-pg-selbox", $('.szyjxxgl')).val() || 20;
      self.searchData.pageNo = pageNo;
      var params = tools.clone(self.searchData);
      // params.nkclzt = this.activeIndex
      // var id = this.activeIndex == '0' ? '#szyjxxgl-wwc-table' : '#szyjxxgl-ywc-table'
      var id = '#szyjxxgl-wwc-table'
      // $(id).jqGrid('clearGridData')
      let searchParam = {}
      searchParam.zbbh = params.zbbh
      searchParam.qxzt = params.nkclzt
      searchParam.cfsjQ = params.fssjQ
      searchParam.cfsjZ = params.fssjZ
      searchParam.pageNo = params.pageNo
      searchParam.pageSize = params.pageSize
      searchParam.cldz = params.cldz
      api.getSzyjResult(searchParam).done(function (res) {
        if (res.code == '0') {
          self.dataList = res.data.rows
          $(id)[0].addJSONData(res.data);
          $(id).setGridWidth($('.szyj-right').width());
          if (self.activeIndex == '1'){
            tools.HeiKjNoSel('szyjxxgl', 'szyjxxgl-ywc-table')
          }
          self.initTree()
        }
      })
    },
    getTsgzSecondEClMxSingle: function(rowid){
      this.dataList[rowid-1].nkywms = this.dataList[rowid-1].hxczsm?this.dataList[rowid-1].nkywms:''
      this.dataList[rowid-1].hxczsm = this.dataList[rowid-1].hxczsm?this.dataList[rowid-1].hxczsm:''
      this.modelData = this.dataList[rowid-1]
      this.showModel();
    },
    saveModel: function(){
      var self = this
      if (this.modelData.nkclsm == '') {
        tools.info('内控处理说明不能为空！');
        return;
      }
      var params = {
        uuid: this.modelData.uuid,
        nkzbbh: this.modelData.nkzbbh,
        nkclzt: this.modelData.nkclzt,
        nkclsm: this.modelData.nkclsm
      }
      api.getTsgzSecondESaveResult(params).done(function (res) {
        if (res.code == '0') {
          tools.info('保存成功！');
          self.hideModel();
          self.initTree();
        }
      })
    },
    exportHandler: function(){
      if (this.dataList.length == 0) {
        tools.info('暂无可导出的数据');
        return;
      };
      var params = {
        zbbh: this.searchData.zbbh,
        nkclzt: this.activeIndex,
        pageNo: 1,
        pageSize: 20,
        cfsjQ:this.searchData.fssjQ,
        cfsjZ:this.searchData.fssjZ,
        cldz:this.searchData.cldz
      }
      tools.exform(params, '/cxfw/nkgl/sz/query/export')
    },
    filDate:function(e){
			var date=e.target.value;
			var res=tools.DateCheup(date);
			if(res===false){
				tools.info("日期输入错误");
				res=""
			}
			e.target.value=res;
			return ;
		},
  }
})