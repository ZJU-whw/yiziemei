var fztswh=require("./fztswh.html");
avalon.component('fztswh', {
	template:fztswh,
	defaults: {
		params:{},
		act:1,
		selRows: [],
		SH01:[],// 受理岗 1
		SH02:[],// 审核岗 2
		SH03:[],// 复审岗 3
		SH04:[],// 核准岗 4
		SH05:[],//发放岗 5
		searchData:{
			qybs:"",
			slg:"",
			shg:"",
			fhg:"",
			hzg:"",
			qylx:"",
			qyzt:"",
			bazt:"",
			gllb:"",
			wzhqy:"",
			jybz:"",
            orderSql:"",
			pageSize:config.pageSize,
		},
		modalData: {
			id:"",
			qyhgdm:"",
			nsrmc:"",
			slg:"",
			shg:"",
			fhg:"",
			hzg:"",
			ffg:"",
			gllb:"",
			wzhqy:"",
			bazt:"",
			qyzt:"",
			note:"",
		},
		onReady:function(){
			var self = this;
			self.initStationCode();
			$(".fztswh .fileupload").fileupload({
				dataType:"json",
				url:"/glfw/fztsqyqd/import",
				add: function (e,data) {
					tools.confirm("请确认，本次导入将先清除原先已导入且未校验入库的企业清册信息。","确定",function() {
						data.submit();
					});
				},
				done: function (e,data) {
					if (data.result.code == "0") {
						tools.info("导入成功");
						self.search(1);
					} else {
						tools.info(data.result.msg);
					}
				}
			});
			this.createTable();
			$('.fztswh .datepicker.date-day').datepicker({
				dateFormat: 'yy-mm-dd'
			});
			$('.fztswh .datepicker.date-month').datepicker({
				dateFormat: 'yymm'
			});
		},
        initStationCode:function(){
			this.getStationCode("SH01")
			this.getStationCode("SH02")
			this.getStationCode("SH03")
			this.getStationCode("SH04")
			this.getStationCode("SH05")
		},
		changeTab:function(num){
			this.act=num;
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
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "qyhgdm", label: "海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 180, align:"center",sortable: true },
				{ name: "slg", label: "申报受理岗", index: "slg",width: 80, align:"left",sortable: true,hidden:true},
				{ name: "slgMc", label: "申报受理岗", index: "slgMc",width: 80, align:"left",sortable: true },
				{ name: "shg", label: "审核岗", index: "shg",width: 80, align:"left",sortable: true,hidden:true },
				{ name: "shgMc", label: "审核岗", index: "shgMc",width: 80, align:"left",sortable: true },
				{ name: "fhg", label: "复审岗", index: "fhg",width: 80, align:"left",sortable: true,hidden:true },
				{ name: "fhgMc", label: "复审岗", index: "fhgMc",width: 80, align:"left",sortable: true },
				{ name: "hzg", label: "核准岗", index: "hzg",width: 80, align:"left",sortable: true,hidden:true },
				{ name: "hzgMc", label: "核准岗", index: "hzgMc",width: 80, align:"left",sortable: true },
				{ name: "ffg", label: "发放岗", index: "ffg",width: 80, align:"left",sortable: true,hidden:true },
				{ name: "ffgMc", label: "发放岗", index: "ffgMc",width: 80, align:"left",sortable: true },
				{ name: "qylx", label: "企业类型", index: "qylx",width: 120, align:"center",sortable: true },
				{ name: "gllb", label: "管理类别", index: "gllb",width: 90, align:"center",sortable: true },
				{ name: "wzhqy", label: "无纸化标志", index: "wzhqy",width: 70, align:"center",sortable: true },
				{ name: "bazt", label: "备案状态", index: "bazt",width: 80, align:"center",sortable: true },
				{ name: "qyzt", label: "企业状态", index: "qyzt",width: 80, align:"center",sortable: true },
				{ name: "jybz", label: "校验标志", index: "jybz",width: 80, align:"center",sortable: true },
				{ name: "note", label: "校验结果", index: "note",width: 80, align:"left",sortable: true },
			];
			$("#fztswh-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#fztswh-tablePager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				multiselect: true,
				multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				pgbuttons:false,
				pginput:false,
				rowNum: -1,
				width:"100%",
				height:(function(){
					return $(".fztswh .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
						return false;
					}else{
						return true;
					}

				},
				onSelectRow: function(rowid,status){
					var index = self.selRows.indexOf(rowid);
					if (status) {
						self.selRows.push(rowid)
					} else {
						self.selRows.splice(index,1);
					}
				},
				onSelectAll: function(rowids,status) {
					if (status) {
						self.selRows = rowids;
					} else {
						self.selRows = [];
					}
				},
                onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"fztswh-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		search:function(){
			var self=this;
			this.searchData.pageSize = 9999;
			var params=tools.clone(self.searchData);
			params.pageNo=1;
            $("#fztswh-table").jqGrid('clearGridData');
			ajax("POST","/glfw/fztsqyqd/select",params).done(function(res){
				if(res.code=='0'){
					$("#fztswh-table").resetSelection();
					$("#fztswh-table")[0].addJSONData(res.data.mx);
					self.selRows=[];
                    self.initStationCode();
                    self.closeHyper();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		//获取岗位代码
		getStationCode: function(gwdm) {
			var self = this;
			var params = {type: "1",shgwdm:gwdm};
			ajax("POST","/glfw/fzts/gwxxbox",params).done(function(res){
				if(res.code=='0'){
					self[gwdm] = res.data;
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			});
		},
		confirm: function() {
			var self = this;
			var params = {};
			params.id = this.modalData.id;
			params.qyhgdm = this.modalData.qyhgdm;
			params.nsrmc = this.modalData.nsrmc;
			params.slg = this.modalData.slg;
			params.shg = this.modalData.shg;
			params.fhg = this.modalData.fhg;
			params.hzg = this.modalData.hzg;
			params.ffg = this.modalData.ffg;
			ajax("POST","/glfw/fztsqyqd/edit",params).done(function(res){
				if(res.code=='0'){
					self.closeModal();
					self.selRows = [];
					self.search();
					tools.info("修改成功");
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			});
		},
		showModal: function() {
			if (this.selRows.length == 0) {
				tools.info("请先选择需要修改的数据");
				return;
			}
			if (this.selRows.length > 1) {
				tools.info("只能单条修改");
				return;
			}
			var id = this.selRows[0];
			var rowData = $("#fztswh-table").jqGrid("getRowData",id);
			for(var prop in this.modalData) {
				if (this.modalData.hasOwnProperty(prop)) {
					this.modalData[prop] = rowData[prop];
				}
			}
			$(".model").show();
			$(".fztswh .page-model").show();
		},
		closeModal: function() {
			$(".model").hide();
			$(".fztswh .page-model").hide();
		},
		validate: function() {
			var self=this;
			ajax("POST","/glfw/fztsqyqd/check",{}).done(function(res){
				if(res.code=='0'){
					self.search(1)
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			});
		},
		toggle:function(){
			$(".fztswh.tzgl .btn-container").toggleClass("active");
		},
		loadFile: function () {
			// var a = document.createElement("a");
			// a.href = "/glfw/static/fztsqc_template.xls";
			// a.click();
			window.open("/glfw/static/fztsqc_template.xls")
		},
		save: function() {
			tools.confirm("请确认，是否将校验通过的企业信息保存到分组推送岗位人员参数表？","确定",function() {
				ajax("POST","/glfw/fztsqyqd/save",{}).done(function(res){
					if(res.code=='0'){
						tools.info("保存成功");
						self.search();
					}else{
						tools.info(res.msg);
					}
				}).fail(function(err){
					tools.info(err);
				});
			});
		},
		delItem: function() {
			if (this.selRows.length == 0) {
				tools.info("请先勾选需要删除的数据");
				return;
			}
			var self = this;
			tools.confirm("确定删除？","确定",function() {
				ajax("POST","/glfw/fztsqyqd/delete",{ids: self.selRows.join(",")}).done(function(res){
					if(res.code=='0'){
						tools.info("删除成功");
						self.selRows = [];
						self.search(1);
					}else{
						tools.info(res.msg);
					}
				}).fail(function(err){
					tools.info(err);
				});
			});
		},
		showHyper:function(){
			$('.fztswh .select-sub').toggle();
			$('.fztswh .select-wrapper .icon').toggleClass("active");
			if ($('.fztswh .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.fztswh .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.fztswh .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.fztswh .select-sub').hide();
            $('.fztswh .select-wrapper .icon').removeClass("active");
            $('.fztswh .select-wrapper .icon').attr("title","展开查询条件")
        },
		exform:function(){
            if($('#fztswh-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
			var self=this;
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/glfw/export/fztsqyqd");
			var input1 = $("<input>");
			input1.attr("type", "hidden");
			input1.attr("name", "data");
			input1.attr("value", JSON.stringify(params));
			$("body").append(form); //将表单放置在web中
			form.append(input1);
			form.submit();
			form.remove();
		},
		reset: function() {
			this.searchData = {
				qyhgdm:"",
				nsrsbh:"",
				nsr_swjg_dm:avalonRoot.user.swjgDm,
				swjg_dm:avalonRoot.user.swjgDm,
				sjlx:"",
				fxjb:"",
				lrrqq:"",
				lrrqz:"",
				rqq:"",
				rqz:"",
				yxbz:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc1 = avalonRoot.user.swjgMc;
			this.swjgmc2 = avalonRoot.user.swjgMc;
		}
	}
});