var fztscxxg=require("./fztscxxg.html");
avalon.component('fztscxxg', {
	template:fztscxxg,
	defaults: {
		params:{},
		act:1,
		addOrEdit:1,
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
			qylx:"",
			qyzt:"",
		},
		onReady:function(){
			var self = this;
			this.createTable();
			this.initStationCode();
			$('.fztscxxg .datepicker.date-day').datepicker({
				dateFormat: 'yy-mm-dd'
			});
			$('.fztscxxg .datepicker.date-month').datepicker({
				dateFormat: 'yymm'
			});
		},
		onActive:function(){

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
			];
			$("#fztscxxg-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#fztscxxg-tablePager',
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
					return $(".fztscxxg .form").height() -60;
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
					var pageNo=tools.getPageNo(pgButton,"fztscxxg-table");
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
            $("#fztscxxg-table").jqGrid('clearGridData')
			ajax("POST","/glfw/fztscxxg/select",params).done(function(res){
				if(res.code=='0'){
					$("#fztscxxg-table").resetSelection();
					$("#fztscxxg-table")[0].addJSONData(res.data.mx);
                    self.initStationCode();
                    self.selRows=[]
                    self.closeHyper()
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
			var params = {type: "2",shgwdm:gwdm};
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
			params.id = this.modalData.id || "";
			params.qyhgdm = this.modalData.qyhgdm;
			params.nsrmc = this.modalData.nsrmc;
			params.slg = this.modalData.slg;
			params.shg = this.modalData.shg;
			params.fhg = this.modalData.fhg;
			params.hzg = this.modalData.hzg;
			params.ffg = this.modalData.ffg;
			ajax("POST","/glfw/fztscxxg/save",params).done(function(res){
				if(res.code=='0'){
					self.closeModal();
					self.selRows = [];
					self.search();
					if (self.addOrEdit == 1) {
						tools.info("新增成功");
					} else {
						tools.info("修改成功");
					}
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			});
		},
		showModal: function(type) {
			this.addOrEdit = type;
			if (this.addOrEdit == 1) {
				for(var prop in this.modalData) {
					if (this.modalData.hasOwnProperty(prop)) {
						this.modalData[prop] = "";
					}
				}
			} else {
				if (this.selRows.length == 0) {
					tools.info("请先选择需要修改的数据");
					return;
				}
				if (this.selRows.length > 1) {
					tools.info("只能单条修改");
					return;
				}
				var id = this.selRows[0];
				var rowData = $("#fztscxxg-table").jqGrid("getRowData",id);
				for(var prop in this.modalData) {
					if (this.modalData.hasOwnProperty(prop)) {
						this.modalData[prop] = rowData[prop];
					}
				}
			}
			$(".model").show();
			$(".fztscxxg .page-model").show();
		},
		closeModal: function() {
			$(".model").hide();
			$(".fztscxxg .page-model").hide();
		},
		toggle:function(){
			$(".fztscxxg.tzgl .btn-container").toggleClass("active");
		},
		delItem: function() {
			if (this.selRows.length == 0) {
				tools.info("请先勾选需要删除的数据");
				return;
			}
			var self = this;
			tools.confirm("确定删除？","确定",function() {
				ajax("POST","/glfw/fztscxxg/delete",{ids: self.selRows.join(",")}).done(function(res){
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
			$('.fztscxxg .select-sub').toggle();
			$('.fztscxxg .select-wrapper .icon').toggleClass("active");
			if ($('.fztscxxg .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.fztscxxg .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.fztscxxg .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.fztscxxg .select-sub').hide();
            $('.fztscxxg .select-wrapper .icon').removeClass('active');
            $('.fztscxxg .select-wrapper .icon').attr("title","展开查询条件")
        },
		exform:function(){
			var self=this;
            if($('#fztscxxg-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/glfw/export/fztscxxg");
			var input1 = $("<input>");
			input1.attr("type", "hidden");
			input1.attr("name", "data");
			input1.attr("value", JSON.stringify(params));
			$("body").append(form); //将表单放置在web中
			form.append(input1);
			form.submit();
			form.remove();
		},
		getNsrxx: function(e) {
			var self = this;
			var qyhgdm = e.target.value;
			if (!qyhgdm) return;
			ajax("POST","/glfw/fzts/getnsrxx",{qyhgdm:qyhgdm}).done(function(res){
				if(res.code=='0'){
					var data = res.data;
					self.modalData.nsrmc = data.nsrmc || "";
					self.modalData.gllb = data.gllb || "";
					self.modalData.wzhqy = data.wzhqy || "";
					self.modalData.bazt = data.bazt || "";
					self.modalData.qyzt = data.qyzt || "";
					self.modalData.qylx = data.qylx || "";
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			});
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