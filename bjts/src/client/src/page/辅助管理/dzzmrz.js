var dzzmrz=require("./dzzmrz.html");
avalon.component('dzzmrz', {
	template:dzzmrz,
	defaults: {
		params:{},
		act:1,
		tcode: "dzzmrzcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			qyhgdm:"",
			nsrsbh:"",
			swjg_dm:"",
			qylx:"",
			dzlx:"",
			cjrqq:"",
			cjrqz:"",
			cjr:"",
			zfbz:"",
			bdbz:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjg_dm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
			this.initTree();
			this.createTable();
            $('.dzzmrz .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.dzzmrz .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
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
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "qyhgdm", label: "海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 140, align:"left",sortable: true },
				{ name: "swjgmc", label: "税务机关名称", index: "swjgmc",width: 120, align:"left",sortable: true },
				{ name: "qylx", label: "企业类型", index: "qylx",width: 95, align:"left",sortable: true },
				{ name: "swjgmc", label: "税务机关名称", index: "swjgmc",width: 120, align:"left",sortable: true },
				{ name: "dzlx", label: "单证类型", index: "dzlx",width: 150, align:"left",sortable: true },
				{ name: "zmbh", label: "证明编号", index: "zmbh",width: 100, align:"center",sortable: true },
				{ name: "sbym", label: "申报年月", index: "sbym",width: 80, align:"center",sortable: true },
				{ name: "sbpc", label: "申报批次", index: "sbpc",width: 80, align:"center",sortable: true },
				{ name: "zcdyrq", label: "正常打印日期", index: "zcdyrq",width: 120, align:"center",sortable: true },
				{ name: "bdcs", label: "补打次数", index: "bdcs",width: 80, align:"left",sortable: true },
				{ name: "bdrq", label: "补打日期", index: "bdrq",width: 120, align:"center",sortable: true },
				{ name: "bdbz", label: "补打标志", index: "bdbz",width: 70, align:"center",sortable: true },
				{ name: "zfrq", label: "作废日期", index: "zfrq",width: 120, align:"left",sortable: true },
				{ name: "zfr", label: "作废人", index: "zfr",width: 80, align:"left",sortable: true },
				{ name: "cjrq", label: "出具日期", index: "cjrq",width: 120, align:"center",sortable: true },
				{ name: "cjr", label: "出具人员", index: "cjr",width: 80, align:"left",sortable: true },
			];
			$("#dzzmrz-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#dzzmrz-tablePager',
                shrinkToFit: false,
                autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
                width:"100%",
				height:(function(){
					return $(".dzzmrz .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
						return false;
					}else{
						return true;
					}

				},onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"dzzmrz-table");
					self.search(pageNo);
				}
			});
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.dzzmrz')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
            $("#dzzmrz-table").jqGrid('clearGridData')
			ajax("POST","/glfw/dzzmrzcx/select",params).done(function(res){
				if(res.code=='0'){
					$("#dzzmrz-table")[0].addJSONData(res.data);
					self.closeHyper()
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		initTree:function() {
			var self = this;
			var setting1 = {
				callback:{
					onClick:function(e,id,node){
						self.searchData.swjg_dm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					},
					onDblClick:function(e,id,node){
						self.searchData.swjg_dm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			};
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				$.fn.zTree.init($(".dzzmrz .treeDiv"), setting1,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.dzzmrz .select-sub').toggle();
			$('.dzzmrz .select-wrapper .icon').toggleClass("active");
			if ($('.dzzmrz .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.dzzmrz .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.dzzmrz .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.dzzmrz .select-sub').hide();
            $('.dzzmrz .select-wrapper .icon').removeClass('active');
            $('.dzzmrz .select-wrapper .icon').attr("title","展开查询条件")
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.dzzmrz').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}

			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.dzzmrz').off('click');
		},
		exform:function(){
			var self=this;
            if($("#dzzmrz-table").jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/glfw/export/dzzmrzqd");
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
				swjg_dm:avalonRoot.user.swjgDm,
				qylx:"",
				dzlx:"",
				cjrqq:"",
				cjrqz:"",
				cjr:"",
				zfbz:"",
				bdbz:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc =avalonRoot.user.swjgMc;
		}
	}
});