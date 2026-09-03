var blqyxxwh=require("./blqyxxwh.html");
avalon.component('blqyxxwh', {
	template:blqyxxwh,
	defaults: {
		params:{},
		act:1,
		tcode: "blqyxxwhcx",
		//1表示新增，2表示编辑
		addOrEdit: "1",
		selRows: [],
		searchData:{
			qyhgdm: "",
			nsrsbh: "",
			orderSql:"",
			pageSize:config.pageSize,
		},
		modalData: {
            nsr_swjg_dm:"",
            nsr_swjg_mc:"",
			qyhgdm:"",
			nsrsbh:"",
			sjlx:"",
			fxjb:"",
			blxxnr:"",
			fxms:"",
			rqq:"",
			rqz:"",
			bz:""
		},
		id: "",
		form: {
			qyxx: {
				qyhgdm:"",
				nsrsbh:"",
				shxydm:"",
				nsrmc:"",
				qylx:"",
				tsjsfs:"",
				gldj:"",
				hy:"",
				nsrswjg:"",
			},
			mx: {}
		},
		onReady:function(){
			var self = this;
			this.initTree();
			this.createTable();
            $('.blqyxxwh .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.blqyxxwh .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });
			$(".blqyxxwh .fileupload").fileupload({
				dataType:"json",
				url:"/glfw/blqyxxwh/import",
				add: function (e,data) {
                    if (self.form.qyxx && self.form.qyxx.nsrsbh !== "") {
                        data.submit();
                    }
                    else {
                        tools.info("请先输入企业标识并查询纳税人信息");
                        return
                    }
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
		toggle:function(){
			$(".tzgl .btn-container").toggleClass("active");
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "qyhgdm", label: "海关代码", index: "qyhgdm",hidden:true,width: 90, align:"center",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",hidden:true,width: 140, align:"center",sortable: true },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 200,hidden:true, align:"left",sortable: true },
				{ name: "sjlx", label: "事件类型", index: "sjlx",width: 80, align:"left",sortable: true },
				{ name: "blxxnr", label: "不良信息内容", index: "blxxnr",width: 200, align:"left",sortable: true },
				{ name: "fxjb", label: "风险级别", index: "fxjb",width: 100, align:"center",sortable: true },
				{ name: "fxms", label: "风险描述", index: "fxms",width: 140, align:"left",sortable: true },
				{ name: "rqq", label: "风险日期起", index: "rqq",width: 120, align:"center",sortable: true },
				{ name: "rqz", label: "风险日期止", index: "rqz",width: 120, align:"center",sortable: true },
				{ name: "nsrswjg", label: "纳税人税务机关", index: "nsrswjg",hidden:true,width: 120, align:"left",sortable: true },
				{ name: "lrr", label: "录入人", index: "lrr",width: 80, align:"left",sortable: true },
				{ name: "lrrq", label: "录入日期", index: "lrrq",width: 120, align:"center",sortable: true },
				{ name: "lrrswjg", label: "录入人税务机关", index: "lrrswjg",width: 120, align:"left",sortable: true },
				{ name: "bz", label: "备注", index: "bz",width: 120, align:"left",sortable: true },
			];
			$("#blqyxxwh-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#blqyxxwh-tablePager',
                shrinkToFit: false,
                autowidth:true,
				altRows: true,
				multiselect: true,
				multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
                width:"100%",
				height:(function(){
					return $(".blqyxxwh .form").height() -170;
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
				},onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"blqyxxwh-table");
					self.search(pageNo);
				}
			});
		},
		search:function(pageNo){
			var self=this;
			if (!this.searchData.qyhgdm && !this.searchData.nsrsbh) {
				tools.info("海关代码和纳税人识别号不能同时为空");
				return;
			}
			this.searchData.pageSize = $(".ui-pg-selbox", $('.blqyxxwh')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
            $("#blqyxxwh-table").jqGrid('clearGridData')
			ajax("POST","/glfw/blqyxxwh/select",params).done(function(res){
				if(res.code=='0'){
					self.selRows = [];
					$("#blqyxxwh-table").resetSelection();
					$("#blqyxxwh-table")[0].addJSONData(res.data.mx);
					self.form.qyxx=res.data.qyxx;
					self.closeHyper()
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		showHyper:function(){
			$('.blqyxxwh .select-sub').toggle();
			$('.blqyxxwh .select-wrapper .icon').toggleClass("active");
			if ($('.blqyxxwh .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.blqyxxwh .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.blqyxxwh .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.blqyxxwh .select-sub').hide();
            $('.blqyxxwh .select-wrapper .icon').removeClass('active');
            $('.blqyxxwh .select-wrapper .icon').attr("title","展开查询条件")
        },
		initTree:function() {
			var self = this;
			var setting = {
				callback:{
					onClick:function(e,id,node){
						self.modalData.nsr_swjg_dm = node.id;
						self.modalData.nsr_swjg_mc = node.text;
						self.hideTree();
						return;
					},
					onDblClick:function(e,id,node){
						self.modalData.nsr_swjg_dm = node.id;
                        self.modalData.nsr_swjg_mc = node.text;
						self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			};
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				$.fn.zTree.init($("#blqyxxwhZtree"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.blqyxxwh').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.blqyxxwh').off('click');
		},
		showModal: function(type) {
			this.addOrEdit = type;
			//新增
			if (type == "1") {
				if (this.form.qyxx && this.form.qyxx.nsrsbh !== "") {
					for(var prop in this.modalData) {
						this.modalData[prop] = "";
					}
                    this.modalData.nsr_swjg_dm = "";
                    this.modalData.nsr_swjg_mc = "";
					this.modalData.qyhgdm = this.form.qyxx.qyhgdm||"";
					this.modalData.nsrsbh = this.form.qyxx.nsrsbh||"";
					$(".model").show();
					$(".blqyxxwh .page-model").show();
				}
				else {
					tools.info("请先输入企业标识并查询纳税人信息");
					return
				}
			//编辑
			} else {
				if (this.form.qyxx && this.form.qyxx.nsrsbh == "") return
				if (this.selRows.length == 0) {
					tools.info("请先选择要编辑的数据");
					return
				} else if (this.selRows.length > 1) {
					tools.info("只能单条数据进行编辑");
					return
				} else {
					var data = $("#blqyxxwh-table").jqGrid("getRowData",this.selRows[0]);
                    var mapData1 = {
                        "函调":"1",
						"实地核查":"2",
						"稽查案件": "3" ,
						"评估核查":"4",
						"其他":"9",
                    };
                    var mapData2 = {
                        "一级风险-低":"1",
                        "二级风险-中":"2",
                       	"三级风险-高": "3"
                    };
                    if (!data.sjlx) {
                        this.modalData.sjlx = ""
					} else {
                        this.modalData.sjlx = mapData1[data.sjlx];
					}
					if (!data.fxjb) {
                        this.modalData.fxjb = "";
					} else {
                        this.modalData.fxjb = mapData2[data.fxjb];
					}
                    this.modalData.nsr_swjg_dm = this.form.qyxx.nsrswjg||"";
                    this.modalData.qyhgdm = data.qyhgdm || "";
                    this.modalData.nsrsbh = data.nsrsbh || "";
                    this.modalData.blxxnr = data.blxxnr || "";
                    this.modalData.fxms = data.fxms || "";
                    this.modalData.rqq = data.rqq || "";
                    this.modalData.rqz = data.rqz || "";
                    this.modalData.bz = data.bz || "";
					this.id  = data.id || "";
					$(".model").show();
					$(".blqyxxwh .page-model").show();
				}
			}

		},
		closeModal: function() {
			$(".model").hide();
			$(".blqyxxwh .page-model").hide();
		},
		submit: function() {
			var self = this;
			var params = {};
			if (this.addOrEdit == '2') {
				params.id = this.id;
			}
			params.qyhgdm = this.modalData.qyhgdm;
			params.nsr_swjg_dm = this.modalData.nsr_swjg_dm;
			params.nsrsbh = this.modalData.nsrsbh;
			params.sjlx = this.modalData.sjlx;
			params.fxjb = this.modalData.fxjb;
			params.blxxnr = this.modalData.blxxnr;
			params.fxms = this.modalData.fxms;
			params.rqq = this.modalData.rqq;
			params.rqz = this.modalData.rqz;
			params.bz = this.modalData.bz;
			if(!params.qyhgdm){
				tools.info("海关代码不能为空！")
				return ;
			}
            if(!/^[0-9a-zA-Z]{10}$/.test(params.qyhgdm)){
                tools.info("请输入正确的海关代码！")
                return ;
            }
            if(!params.nsrsbh){
                tools.info("纳税人识别号不能为空！")
                return ;
            }
            if(!/^[0-9a-zA-Z]{15}$/.test(params.nsrsbh)&&!/^[0-9a-zA-Z]{18}$/.test(params.nsrsbh)){
                tools.info("请输入正确的纳税人识别号！")
                return ;
            }
            if(!params.nsr_swjg_dm){
                tools.info("税务机关不能为空！")
                return ;
            }
            if(!params.sjlx){
                tools.info("事件类型不能为空！")
                return ;
            }
            if(!params.blxxnr){
                tools.info("不良信息内容不能为空！")
                return ;
            }
            if(!params.fxjb){
                tools.info("风险级别不能为空！")
                return ;
            }
            if(!params.rqq||!params.rqz){
                tools.info("风险日期不能为空！")
                return ;
            }
			var url = "/glfw/blqyxxwh/update";
			ajax("POST",url,params).done(function(res){
				if(res.code=='0'){
					//新增
					if (self.addOrEdit == "1") {
						tools.info("新增成功");
						self.closeModal();
						// self.search(1);
					//	编辑
					} else {
						tools.info("更新成功");
						self.closeModal();
						self.selRows = [];
						// self.search(1);
					}
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		delData: function() {
			var self = this;
			if (this.form.qyxx && this.form.qyxx.nsrsbh == "") return
			if (this.selRows.length == 0) {
				tools.info("请先选择要删除的不良企业信息");
				return
			}
			ajax("POST","/glfw/blqyxxwh/del",{ids: this.selRows.join(",")}).done(function(res){
				if(res.code=='0'){
					tools.info("删除成功");
					self.selRows = [];
					self.search(1);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		loadFile: function () {
            // var a = $("<a>");
            // a.attr('href', "/glfw/static/blqywh_template.xls");
            // a.attr('target',"_blank")
            // a.attr("style", "display:none");
            // $("body").append(a)
            // a.click();
            // a.remove();
			window.open("/glfw/static/blqywh_template.xls");
		},
	}
});