var ywyba=require("./ywyba.html");
avalon.component('ywyba', {
	template:ywyba,
	defaults: {
		params:{},
		act:1,
		tcode: "ywybacx",
		swjgmc: "",
		selRows: [],
		searchData:{
			swjg_dm:"",
			qybs:"",
			zjhm:"",
			xm:"",
			status:"",
			phone:"",
			zfbz:"",
			sjqyhs:"",
			sffxywy:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		imgSrc: '',
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
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 140, align:"left",sortable: true },
				{ name: "swjgmc", label: "税务机关名称", index: "swjgmc",width: 120, align:"left",sortable: true },
				{ name: "xm", label: "业务员姓名", index: "xm",width: 80, align:"left",sortable: true },
				{ name: "sex", label: "性别", index: "sex",width: 40, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '1': '男', '2': '女'};
					return map[cellvalue];
				} },
				{ name: "zjhm", label: "证件号码", index: "zjhm",width: 150, align:"left",sortable: false },
				{ name: "zjlx", label: "证件类型", index: "zjlx",width: 70, align:"center",sortable: false },
				{ name: "phone", label: "手机号码", index: "phone",width: 90, align:"left",sortable: true },
				{ name: "status", label: "业务员状态", index: "status",width: 70, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '1': '在职', '0': '离职'};
					return map[cellvalue];
				} },
				{ name: "gzrqQ", label: "工作日期起", index: "gzrqQ",width: 80, align:"center",sortable: true },
				{ name: "gzrqZ", label: "工作日期止", index: "gzrqZ",width: 80, align:"center",sortable: true },
				{ name: "ckcpfw", label: "出口产品范围", index: "ckcpfw",width: 80, align:"center",sortable: true },
				{ name: "sfqdldht", label: "是否签订劳动合同", index: "sfqdldht",width: 100, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				} },
				{ name: "sfdjsb", label: "是否代缴社保", index: "sfdjsb",width: 80, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				}},
				{ name: "ywyly", label: "业务员来源", index: "ywyly",width: 90, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '1': '他人介绍', '2': '招聘', '3': '企业法人/投资方/实际管理人', '4': '其他'};
					return map[cellvalue] || '';
				}  },
				{ name: "sjqyhs", label: "涉及企业户数", index: "sjqyhs",width: 80, align:"right",sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<span class='link toSjqy'>"+(cellvalue || '')+"</span>";
				} },
				{ name: "sffxywy", label: "是否风险业务员", index: "sffxywy",width: 90, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				} },
				{ name: "zfbz", label: "作废标志", index: "zfbz",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				} },
				{ name: "bazt", label: "备案状态", index: "bazt",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '0': '未备案', '1': '备案中', '2': '已备案', '3': '备案退回'};
					return map[cellvalue] || '';
				} },
				{ name: "zfsj", label: "作废时间", index: "zfsj",width: 130, align:"center",sortable: true },
				{ name: "tjsj", label: "提交时间", index: "tjsj",width: 130, align:"center",sortable: true },
				{ name: "basj", label: "备案时间", index: "basj",width: 130, align:"center",sortable: true },
				{ name: "zp", label: "证件照片", index: "zp",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<span class='link fj' title='查看'>查看</span>";
				} },
				{ name: "sfjznr64", label: "base64图片内容", index: "sfjznr64", hidden: true, formatter: function(cellvalue, options, rowObject){
					return cellvalue ? cellvalue : '';
				}}
			];
			$("#ywyba-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#ywyba-tablePager',
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
					return $(".ywyba .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if($(e.target).hasClass('toSjqy')){
						var zjhm = getCellData("ywyba-table", rowid, 'zjhm')
						avalonRoot.addTab({title:"业务员涉及企业",component:"ywysjqy",params:{zjhm:zjhm}});
						return false;
					}else if($(e.target).hasClass('fj')){
						var id = getCellData("ywyba-table", rowid, 'id')
						ajax("POST","/sszj/ywyba/getSfzj",{ywyId: id}).done(function(res){
							if(res.code=='0'){
								var imgSrc = res.data.sfzjnr64
								if (imgSrc) {
									self.imgSrc = 'data:image/png;base64,'+ imgSrc
								} else {
									self.imgSrc = ''
								}
								self.showModel();
							}else{
								tools.info(res.msg);
							}
						}).fail(function(err){
							tools.info(err);
						})
						return false;
					}else if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
							return false;
					}else{
							return true;
					}
				},
				onSortCol: function (index, iCol, sortorder) {
					var orderSql = index + ' ' + sortorder;
					if (index == 'tjsj') {
						orderSql = 't.'+orderSql;
					}
					self.searchData.orderSql = orderSql;
					self.search(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"ywyba-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		showModel: function(){
			$('.model').show();
			$('.ywyba .page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.ywyba .page-model').hide();
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.ywyba')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#ywyba-table").jqGrid('clearGridData')
			ajax("POST","/sszj/ywyba/list",params).done(function(res){
				if(res.code=='0'){
					$("#ywyba-table").resetSelection();
					$("#ywyba-table")[0].addJSONData(res.data);
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
				$.fn.zTree.init($(".ywyba .treeDiv"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.ywyba .select-sub').toggle();
			$('.ywyba .select-wrapper .icon').toggleClass("active");
			if ($('.ywyba .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.ywyba .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.ywyba .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.ywyba .select-sub').hide();
            $('.ywyba .select-wrapper .icon').removeClass('active');
            $('.ywyba .select-wrapper .icon').attr("title","展开查询条件");
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.ywyba').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.ywyba').off('click');
		},
		exform:function(){
			var self=this;
			if($('#ywyba-table').jqGrid('getRowData').length<=0){
					tools.info("请先查询列表");
					return ;
			}
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/sszj/export/ywybajgb");
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
				swjg_dm:avalonRoot.user.swjgDm,
				qybs:"",
				zjhm:"",
				xm:"",
				status:"",
				phone:"",
				zfbz:"",
				sjqyhs:"",
				sffxywy:"",
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