var blqyxxcx=require("./blqyxxcx.html");
avalon.component('blqyxxcx', {
	template:blqyxxcx,
	defaults: {
		params:{},
		act:1,
		swjgmc1: "",
		swjgmc2: "",
		selRows: [],
		searchData:{
			qyhgdm:"",
			nsrsbh:"",
			nsr_swjg_dm:"",
			swjg_dm:"",
			sjlx:"",
			fxjb:"",
			lrrqq:"",
			lrrqz:"",
			rqq:"",
			rqz:"",
			yxbz:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		onReady:function(){
			var self = this;
			try {
				this.searchData.nsr_swjg_dm=avalonRoot.user.swjgDm;
				this.searchData.swjg_dm=avalonRoot.user.swjgDm;
				this.swjgmc1=avalonRoot.user.swjgMc;
				this.swjgmc2=avalonRoot.user.swjgMc;
			} catch (e) {

			}
			this.initTree();
			this.createTable();
            $('.blqyxxcx .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.blqyxxcx .datepicker.date-month').datepicker({
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
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 180, align:"left",sortable: true },
				{ name: "sjlx", label: "事件类型", index: "sjlx",width: 80, align:"left",sortable: true },
				{ name: "blxxnr", label: "不良信息内容", index: "blxxnr",width: 200, align:"left",sortable: true },
				{ name: "fxjb", label: "风险级别", index: "fxjb",width: 90, align:"center",sortable: true },
				{ name: "fxms", label: "风险描述", index: "fxms",width: 140, align:"left",sortable: true },
				{ name: "rqq", label: "风险日期起", index: "rqq",width: 120, align:"center",sortable: true },
				{ name: "rqz", label: "风险日期止", index: "rqz",width: 120, align:"center",sortable: true },
				{ name: "nsrswjg", label: "纳税人税务机关", index: "nsrswjg",width: 120, align:"left",sortable: true },
				{ name: "lrr", label: "录入人", index: "lrr",width: 70, align:"left",sortable: true },
				{ name: "lrrq", label: "录入日期", index: "lrrq",width: 120, align:"center",sortable: true },
				{ name: "lrrswjg", label: "录入人税务机关", index: "lrrswjg",width: 120, align:"left",sortable: true },
			];
			$("#blqyxxcx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#blqyxxcx-tablePager',
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
					return $(".blqyxxcx .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if(e.target.nodeName=="TD"){
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
                },
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"blqyxxcx-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.blqyxxcx')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
            $("#blqyxxcx-table").jqGrid('clearGridData')
			ajax("POST","/glfw/blqyxxcx/select",params).done(function(res){
				if(res.code=='0'){
					$("#blqyxxcx-table").resetSelection();
					$("#blqyxxcx-table")[0].addJSONData(res.data);
					self.form=res.data;
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
						self.searchData.nsr_swjg_dm = node.id;
						self.swjgmc1 = node.text;
						self.hideTree();
						return;
					},
					onDblClick:function(e,id,node){
						self.searchData.nsr_swjg_dm = node.id;
						self.swjgmc1 = node.text;
						self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			};
			var setting2 = {
				callback:{
					onClick:function(e,id,node){
						self.searchData.swjg_dm = node.id;
						self.swjgmc2 = node.text;
						self.hideTree();
						return;
					},
					onDblClick:function(e,id,node){
						self.searchData.swjg_dm = node.id;
						self.swjgmc2 = node.text;
						self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			}
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				$.fn.zTree.init($(".blqyxxcx .swjg1"), setting1,data);
				$.fn.zTree.init($(".blqyxxcx .swjg2"), setting2,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.blqyxxcx .select-sub').toggle();
			$('.blqyxxcx .select-wrapper .icon').toggleClass("active");
			if ($('.blqyxxcx .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.blqyxxcx .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.blqyxxcx .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.blqyxxcx .select-sub').hide();
            $('.blqyxxcx .select-wrapper .icon').removeClass('active');
            $('.blqyxxcx .select-wrapper .icon').attr("title","展开查询条件");
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.blqyxxcx').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}

			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.blqyxxcx').off('click');
		},
		exform:function(){
			var self=this;
            if($('#blqyxxcx-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/glfw/export/blqyxxcxqd");
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