var fncxdz=require("./fncxdz.html");
avalon.component('fncxdz', {
	template:fncxdz,
	defaults: {
		params:{},
		act:1,
		swjgmc: "",
		searchData:{
			nsrsbh:"",
			swjg_dm:"",
			dzjg:"",
			clbz:"",
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
                { name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 150, align:"center",sortable: true },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 180, align:"left",sortable: true },
				{ name: "zsxm_dm", label: "征收项目代码", index: "zsxm_dm",width: 90, align:"center",sortable: true },
				{ name: "yt_amt", label: "应补缴税额", index: "yt_amt",width: 130, align:"right",sortable: true },
				{ name: "sb_ym", label: "申报年月", index: "sb_ym",width:60, align:"center",sortable: true },
				{ name: "sb_pc", label: "申报批次", index: "sb_pc",width: 60, align:"center",sortable: true },
				{ name: "xh_flag", label: "销号标志", index: "xh_flag",width: 60, align:"center",sortable: true },
				{ name: "xh_date", label: "销号日期", index: "xh_date",width: 80, align:"center",sortable: true },
				{ name: "zg_se", label: "返纳税额", index: "zg_se",width: 100, align:"right",sortable: true },
				{ name: "zg_sjyjse", label: "实际应缴税额", index: "zg_sjyjse",width: 100, align:"right",sortable: true },
				{ name: "zg_rkse", label: "实际入库税额", index: "zg_rkse",width: 100, align:"right",sortable: true },
				{ name: "swjgmc", label: "税务机关", index: "swjgmc",width: 200, align:"center",sortable: true },
				{ name: "dzjg", label: "对账结果", index: "dzjg",width: 180, align:"left",sortable: true },
				{ name: "clbz", label: "处理标志", index: "clbz",width: 80, align:"center",sortable: true,
                    formatter: function(cellvalue, options, rowObject){
				        if(rowObject.dzjg == '对账结果正确'){
                            return cellvalue
                        }else{
                            return "<div class='btn edit' style='float: none;display: inline-block;'>录入意见</div>"}
                        }

                },
				{ name: "pzxh", label: "凭证序号", index: "pzxh",width: 180, align:"center",sortable: true },
				{ name: "cl_user", label: "处理人", index: "cl_user",width: 60, align:"left",sortable: true },
				{ name: "cl_date", label: "处理时间", index: "cl_date",width: 100, align:"center",sortable: true },
				{ name: "clyj", label: "处理意见", index: "clyj",width: 120, align:"left",sortable: true },
			];
			$("#fncxdz-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#fncxdz-tablePager',
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
					return $(".fncxdz .form").height() -60-30;
				})(),
				beforeSelectRow:function(rowid,e){
					if($(e.target).hasClass('edit')){
						$.dialog({
							title: "录入处理",
							content: '<div style="margin-bottom: 20px;">处理标志：<select type="text" id="deal-sign" style="    width: 155px;">'+
													'<option value="" selected></option>'+
													'<option value="1">以征管为准</option>'+
													'<option value="2">以出口为准</option>'+
													'<option value="3">无效</option>'+
													'</select></div>' + 
											 '<div><span style="position: relative; top: -90px; left: 0;">处理意见：</span><textarea id="deal-suggest" style="height: 100px;"></textarea></div>',
							lock: true,
							button: [
									{
											value: '确认',
											callback: function () {
													var dealSign = $('#deal-sign').val();
													var dealSuggest = $('#deal-suggest').val();
													if(!dealSign){
														tools.info('处理标志不能为空，请选择处理标志。');
														return
													}
													var params = {
														id: rowid,
														clbz: dealSign
													}
													!!dealSuggest? params['clyj']=dealSuggest: null;
													ajax("POST","/glfw/cktsfndz/clbz",params).done(function(res){
														if(res.code=='0'){
															self.search(1);
														}else{
															tools.info(res.msg);
														}
													}).fail(function(err){
														tools.info(err);
													})
											}
									},
									{
											value: '取消'
									}
							]
						})
					}
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
                    $("#fncxdz-table").footerData('set', sumData);
                },
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"fncxdz-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.fncxdz')).val() || 20;
			var params=tools.clone(self.searchData);
			//对账结果为正确是空格，所以特殊处理
			if (params.dzjg == "10") {
				params.dzjg = " ";
			}
			//处理标志为正确是空格，所以特殊处理
			if (params.clbz == "2") {
				params.clbz = " ";
			}
			params.pageNo=pageNo;
            $("#fncxdz-table").jqGrid('clearGridData')
			ajax("POST","/glfw/cktsfndz/select",params).done(function(res){
				if(res.code=='0'){
                    self.tableData=res.data;
					$("#fncxdz-table")[0].addJSONData(res.data);
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
				$.fn.zTree.init($(".fncxdz .treeDiv"), setting1,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.fncxdz .select-sub').toggle();
			$('.fncxdz .select-wrapper .icon').toggleClass("active");
			if ($('.fncxdz .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.fncxdz .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.fncxdz .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.fncxdz .select-sub').hide();
            $('.fncxdz .select-wrapper .icon').removeClass('active');
            $('.fncxdz .select-wrapper .icon').attr("title","展开查询条件")
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.fncxdz').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}

			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.fncxdz').off('click');
		},
		check: function() {
			ajax("POST","/glfw/cktsfndz/dz",{}).done(function(res){
				if(res.code=='0'){
					tools.info("对账成功")
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		exform:function(){
			var self=this;
            if($("#fncxdz-table").jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
			var params = tools.clone(self.searchData);
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/glfw/export/fnxxcx4dz");
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
				dzjg:"",
				clbz:"",
				seq:"",
				sez:"",
				xh_flag:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc = avalonRoot.user.swjgMc;
		}
	}
});