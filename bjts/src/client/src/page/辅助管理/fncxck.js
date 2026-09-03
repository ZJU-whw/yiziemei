var fncxck=require("./fncxck.html");
avalon.component('fncxck', {
	template:fncxck,
	defaults: {
		params:{},
		act:1,
		swjgmc: "",
		searchData:{
			nsrsbh:"",
			swjg_dm:"",
			lrrqq:"",
			lrrqz:"",
			seq:"",
			sez:"",
            xh_flag:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
        tableData:{
            sumData:{}
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
            $('.fncxck .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.fncxck .datepicker.date-month').datepicker({
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
		checkIsNum: function(e) {
			var data=e.target.value;
			var res = data;
            if(!/^[\.0-9]*$/.test(data)){
				tools.info("应补缴税额输入错误");
				res="";
			}
			e.target.value=res;
			return ;
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 180, align:"left",sortable: true },
				{ name: "zsxm_dm", label: "征收项目代码", index: "zsxm_dm",width: 80, align:"center",sortable: true },
				{ name: "yt_amt", label: "应补缴税额", index: "yt_amt",width: 150, align:"right",sortable: true },
				{ name: "sb_ym", label: "申报年月", index: "sb_ym",width: 60, align:"center",sortable: true },
				{ name: "sb_pc", label: "申报批次", index: "sb_pc",width: 60, align:"center",sortable: true },
				{ name: "yzhyy_code", label: "应追回原因代码", index: "yzhyy_code",width: 90, align:"center",sortable: true },
				{ name: "yzh_reason", label: "应追回原因", index: "yzh_reason",width: 180, align:"left",sortable: true },
				{ name: "xh_flag", label: "销号标志", index: "xh_flag",width: 60, align:"center",sortable: true },
				{ name: "xh_date", label: "销号日期", index: "xh_date",width: 80, align:"center",sortable: true },
				{ name: "pzxh_ckts", label: "凭证序号", index: "pzxh_ckts",width: 100, align:"center",sortable: true },
				{ name: "op_date", label: "录入日期", index: "op_date",width: 80, align:"center",sortable: true },
				{ name: "sjtb_date", label: "数据同步时间", index: "sjtb_date",width: 80, align:"center",sortable: true },
				{ name: "swjgmc", label: "税务机关", index: "swjgmc",width: 200, align:"center",sortable: true },
			];
			$("#fncxck-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#fncxck-tablePager',
                shrinkToFit: false,
                autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				footerrow:true,
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
                width:"100%",
				height:(function(){
					return $(".fncxck .form").height() -60-30;
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
                }, gridComplete: function(){
                    var sumData=self.tableData.sumData;
                    sumData["nsrsbh"]="合计";
                    $("#fncxck-table").footerData('set', sumData);
                },
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"fncxck-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.fncxck')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
            $("#fncxck-table").jqGrid('clearGridData')
			ajax("POST","/glfw/fnxxcx4ck/select",params).done(function(res){
				if(res.code=='0'){
                    self.tableData=res.data;
					$("#fncxck-table")[0].addJSONData(res.data);
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
				$.fn.zTree.init($(".fncxck .treeDiv"), setting1,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.fncxck .select-sub').toggle();
			$('.fncxck .select-wrapper .icon').toggleClass("active");
			if ($('.fncxck .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.fncxck .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.fncxck .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.fncxck .select-sub').hide();
            $('.fncxck .select-wrapper .icon').removeClass('active');
            $('.fncxck .select-wrapper .icon').attr("title","展开查询条件")
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.fncxck').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}

			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.fncxck').off('click');
		},
		exform:function(){
			var self=this;
            if($('#fncxck-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/glfw/export/fnxxcx4ck");
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
				nsrsbh:"",
				swjg_dm:avalonRoot.user.swjgDm,
				lrrqq:"",
				lrrqz:"",
				seq:"",
				sez:"",
				xh_flag:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc = avalonRoot.user.swjgMc;
		},
		sychonize: function() {
			ajax("POST","/glfw/fnxxcx4ck/sync",{}).done(function(res){
				if(res.code=='0'){
					tools.info("同步成功")
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		}
	}
});