var updateJkm=require("./updateJkm.html");
avalon.component('updateJkm', {
	template:updateJkm,
	defaults: {
    componentsName: '',
    isEdit: true,

    nsrsbhList: [],
    showNsrsbhList: false,
    activeBgIndex: 0,
    qybz: '',
		modelData: {
      nsrsbh: '',
      nsrmc: '',
      jkmY: '',
      jkmN: '',
      yxq: ''
    },
    searchData: {
      zbFf: '1',
      zbpd: '',
      orderSql: ''
    },
    step: '1',
    isFirst: true,
    hcData: {
      nsrsbh: '',
      zbId: '',
      hcjg: '',
      hcyj: ''
    },
    onInit: function onInit(e) {
      components['updateJkm'+this.componentsName] = e.vmodel;
    },
    onReady: function(){
    },
    initData: function(){
      this.searchData = {
        zbFf: '1',
        zbpd: '',
        orderSql: ''
      }
      this.modelData = {
        nsrsbh: '',
        nsrmc: '',
        jkmY: '',
        jkmN: '',
        yxq: ''
      }
      if (this.isFirst) {
        this.createTable();
      } else {
        $("#"+this.componentsName+"-updateJkm-table").jqGrid('clearGridData');
        if (this.isEdit) {
			    tools.HeiKjNoSel('updateJkm', this.componentsName+'-updateJkm-table');
        }
      }
    },
    createTable:function(){
			var self=this;
			var columns = [
				{ name: "op2", label: "操作", index: "op",width: 80,frozen: true,align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<div class='btn op-hc' style='float: none;display: inline-block;' title='核查'>核查</div>";
				} },
				{ name: "ywflJc", label: "分类", index: "ywflJc",width: 40, align:"left",sortable: false},
				{ name: "zbId", label: "指标编号", index: "zbId",width: 80, align:"left",sortable: false},
				{ name: "zbCname", label: "指标名称", index: "zbCname",width: 200, align:"left",sortable: false },
				{ name: "zbVal", label: "结果值", index: "zbVal",width: 60, align:"center",sortable: false },
				{ name: "rsType", label: "结果类型", index: "rsType",width: 60, align:"center",sortable: false },
				{ name: "score", label: "指标赋分", index: "score",width: 60, align:"center",sortable: false },
				{ name: "uptime", label: "更新时间", index: "uptime",width: 130, align:"center",sortable: false },
        { name: "hcjgStr", label: "评定结果", index: "hcjgStr",width: 80, align:"center",sortable: false },
				{ name: "hcyj", label: "情况描述", index: "hcyj",width: 140, align:"left",sortable: false },
				{ name: "hcr", label: "评定人", index: "hcr",width: 80, align:"center",sortable: false },
				{ name: "applyQy", label: "适用", index: "applyQy",width: 60, align:"center",sortable: false },
				{ name: "ywms", label: "指标描述", index: "ywms",width: 300, align:"left",sortable: false },
				{ name: "hctime", label: "评定时间", index: "hctime",width: 130, align:"left",sortable: false },
				{ name: "op", label: "操作", width: 120, align: "center", resizable: false, search: false, sortable: false}
			];
      if (!this.isEdit) {
        columns.splice(0,1);
        columns.splice(-1,1);
      } 
			$("#"+this.componentsName+"-updateJkm-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: 9999,
				width:"100%",
				height: this.isEdit ? 230: 250,
				beforeSelectRow:function(rowid,e){
          if($(e.target).hasClass('disabled')) return;
          var zbId = getCellData(self.componentsName+"-updateJkm-table", rowid, 'zbId')
					if($(e.target).hasClass('op-hc')){
            self.hcData.zbId = zbId
            self.hcData.nsrsbh = self.modelData.nsrsbh
            self.showModelHc()
						return false;
					}else if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
            return false;
					}else{
            return true;
					}
				},
				onSortCol: function (index, iCol, sortorder) {
					self.searchData.orderSql = index + ' ' + sortorder;
					self.search(1);
					return;
				}
			});
      if (this.isEdit) {
			  $("#"+this.componentsName+"-updateJkm-table").jqGrid('setFrozenColumns');
        tools.HeiKjNoSel('updateJkm', self.componentsName+'-updateJkm-table');
      }
		},
		search:function(pageNo){
			var self=this;
      var params = {
        nsrsbh: this.modelData.nsrsbh,
        pageSize: $(".ui-pg-selbox", $('.updateJkm')).val() || 20,
        pageNo: pageNo,
        zbFf: this.searchData.zbFf,
        zbpd: this.searchData.zbpd,
        orderSql: this.searchData.orderSql
      }
			$("#"+this.componentsName+"-updateJkm-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/qyjkm/mx/list",params).done(function(res){
				if(res.code=='0'){
					$("#"+self.componentsName+"-updateJkm-table").resetSelection();
					$("#"+self.componentsName+"-updateJkm-table")[0].addJSONData(res.data);
          if (self.isEdit) {
            tools.HeiKjNoSel('updateJkm', self.componentsName+'-updateJkm-table');
          }
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
    hideModel: function(){
      $('.updateJkm-page-model').hide();
    },
    getJkmY: function(){
      var self = this
			ajax("POST","/sszj/jkmpd/getJkmY",{nsrsbh:this.modelData.nsrsbh}).done(function(res){
				if(res.code=='0'){
					self.modelData.jkmY = res.data.jkmY
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    },
    setNsrsbh: function(item){
      this.modelData.nsrsbh = item.nsrsbh
      this.modelData.nsrmc = item.nsrmc
      this.getJkmY();
      this.search(1);
    },
    // 获取新健康码
    refreshJkm: function(){
      var self = this
      if (this.modelData.nsrsbh == '') {
        tools.info('纳税人识别号不能为空！');
        return;
      }
      api.getJkmN({nsrsbh:this.modelData.nsrsbh}).done(function(res){
				if(res.code=='0'){
					self.modelData.jkmN = res.data.jkmN
				}
			})
    },
    showModelHc: function(){
      $('.updateJkm .updateJkm-hc-page-model').show();
    },
    hideModelHc: function(){
      this.hcData = {
        nsrsbh: '',
        zbId: '',
        hcjg: '',
        hcyj: ''
      }
      $('.updateJkm .updateJkm-hc-page-model').hide();
    },
    saveHc: function(){
      var self = this
      if (this.hcData.hcjg == '') {
        tools.info('请选择评定结果！');
        return false;
      }
      api.jkmpdZbhc(this.hcData).done(function(res){
        if(res.code=='0'){
          tools.info('操作成功！');
          self.hideModelHc();
          self.search(1);
        }
      })
    },
    confirm: function(){
      $('.updateJkm-page-model').hide();
      components[this.componentsName].pdData.jkmN = this.modelData.jkmN
    }
  }
})