var ywybacx=require("./ywybacx.html");
avalon.component('ywybacx', {
	template:ywybacx,
	defaults: {
		params:{},
		act:1,
		tcode: "ywybacx",
		swjgmc: "",
		selRows: [],
		searchData:{
			qyhgdm:"",
			nsrsbh:"",
			year:"",
			swjg_dm:"",
			qylx:"",
			gllb:"",
			ywyxm:"",
			sfzh:"",
			sfsxgk:"",
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
		},
		changeTab:function(num){
			this.act=num;
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 140, align:"left",sortable: true },
				{ name: "year", label: "备案年度", index: "year",width: 80, align:"center",sortable: true },
				{ name: "qylx", label: "企业类型", index: "qylx",width: 100, align:"center",sortable: true },
				{ name: "gllb", label: "管理类别", index: "gllb",width: 80, align:"center",sortable: true },
				{ name: "swjgmc", label: "税务机关名称", index: "swjgmc",width: 120, align:"left",sortable: true },
				{ name: "ywyxm", label: "业务员姓名", index: "ywyxm",width: 80, align:"left",sortable: true },
				{ name: "sex", label: "性别", index: "sex",width: 40, align:"center",sortable: true },
				{ name: "sfzh", label: "身份证号码", index: "sfzh",width: 130, align:"center",sortable: true },
				{ name: "gzrqq", label: "工作日期起", index: "gzrqq",width: 120, align:"center",sortable: true },
				{ name: "gzrqz", label: "工作日期止", index: "gzrqz",width: 120, align:"center",sortable: true },
				{ name: "sfqdldht", label: "是否签订劳动合同", index: "sfqdldht",width: 100, align:"center",sortable: true },
				{ name: "sfdjbx", label: "是否代缴保险", index: "sfdjbx",width: 90, align:"center",sortable: true },
				{ name: "sncke", label: "上年出口额", index: "sncke",width: 100, align:"right",sortable: true ,formatter: function (val) {
						if(val===""||isNaN(val)){
							return val;
						}
						return avalon.filters.number(val,2);
					}},
				{ name: "bncke", label: "本年出口额", index: "bncke",width: 100, align:"right",sortable: true ,formatter: function (val) {
                        if(val===""||isNaN(val)){
                            return val;
                        }
						return avalon.filters.number(val,2);
					}},
				{ name: "tbzf", label: "同比增幅", index: "tbzf",width: 80, align:"center",sortable: true },
				{ name: "snzycksp", label: "上年主出口商品", index: "snzycksp",width: 120, align:"left",sortable: true },
				{ name: "snzyckg", label: "上年主要出口国", index: "snzyckg",width: 120, align:"left",sortable: true },
				{ name: "snzyghd", label: "上年主要购货地", index: "snzyghd",width: 120, align:"left",sortable: true },
				{ name: "qyhs", label: "涉及企业户数", index: "qyhs",width: 80, align:"left",sortable: true },
				{ name: "sfsxgk", label: "是否涉嫌挂靠", index: "sfsxgk",width: 80, align:"center",sortable: true },
			];
			$("#ywybacx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#ywybacx-tablePager',
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
					return $(".ywybacx .form").height() -60;
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
					var pageNo=tools.getPageNo(pgButton,"ywybacx-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},

		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.ywybacx')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
            $("#ywybacx-table").jqGrid('clearGridData')
			ajax("POST","/glfw/ywyba/select",params).done(function(res){
				if(res.code=='0'){
					$("#ywybacx-table").resetSelection();
					$("#ywybacx-table")[0].addJSONData(res.data);
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
			var setting = {
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
				$.fn.zTree.init($(".ywybacx .treeDiv"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.ywybacx .select-sub').toggle();
			$('.ywybacx .select-wrapper .icon').toggleClass("active");
			if ($('.ywybacx .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.ywybacx .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.ywybacx .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.ywybacx .select-sub').hide();
            $('.ywybacx .select-wrapper .icon').removeClass('active');
            $('.ywybacx .select-wrapper .icon').attr("title","展开查询条件");
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.ywybacx').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.ywybacx').off('click');
		},
		exform:function(){
			var self=this;
            if($('#ywybacx-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/glfw/export/ywybaqd");
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
				year:"",
				swjg_dm:avalonRoot.user.swjgDm,
				qylx:"",
				gllb:"",
				ywyxm:"",
				sfzh:"",
				sfsxgk:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= avalonRoot.user.swjgMc;
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
});