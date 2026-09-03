var jkmcx=require("./jkmcx.html");
var fxjsCommonFun = require('../../../config/fxjsCommonFun.js');
avalon.component('jkmcx', {
	template:jkmcx,
	defaults: {
		params:{},
		act:1,
		tcode: "jkmcxcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			swjg_dm:"",
			qybs:"",
			qylx:"",
			tsjsfs:"",
			glcd:"",
			djzclx:"",
			hy:"",
			jkmLevel: "",
			ywflDms: "",
			bazt: "",
			nsrzt: "",
			ckgm: "",
			pdzt: "",
			qyfz: "",
			orderSql:"",
			pageSize:config.pageSize,
		},
		yjkms: [],
		imgSrc: '',
		djzclx: '',
		hy: '',
		dictList: [],
		selectMc: {},
		colorMap: {
			'0': '#fff',
			'1': '#fff',
			'2': '#E6A23C',
			'3': '#f56c6c'
		},
		yjkmList: [],
		qyfzList: [],
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjg_dm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
			this.initTree();
			this.getDynamicInit();
			this.createTable();
			this.getYwfl();
			this.getQyjkmQyfz();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "djxh", label: "登记序号", index: "djxh",hidden: true },
				{ name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<div class='link toMx'>"+rowObject.qyhgdm+"</div>";
				} },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"left",sortable: true },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 140, align:"left",sortable: true },
				{ name: "jkmMc", label: "健康码", index: "jkmMc",width: 50, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
					var colorMap = {
						'绿码': '#67C23A',
						'黄码': '#E6A23C',
						'红码': '#f56c6c'
					}
					return "<div style='background-color:"+ colorMap[cellvalue] +"'>"+cellvalue+"</div>";
				} },
				{ name: "scoreZh", label: "综合", index: "scoreZh",width: 40, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
					return "<div style='background-color:"+ self.colorMap[rowObject.colorZh] +"'>"+cellvalue+"</div>";
				} },
				{ name: "score10", label: "信用", index: "score10",width: 40, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
					return "<div style='background-color:"+ self.colorMap[rowObject.color10] +"'>"+cellvalue+"</div>";
				}  },
				{ name: "score20", label: "退税", index: "score20",width: 40, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
					return "<div style='background-color:"+ self.colorMap[rowObject.color20] +"'>"+cellvalue+"</div>";
				}  },
				{ name: "score30", label: "出口", index: "score30",width: 40, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
					return "<div style='background-color:"+ self.colorMap[rowObject.color30] +"'>"+cellvalue+"</div>";
				}  },
				{ name: "score40", label: "发票", index: "score40",width: 40, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
					return "<div style='background-color:"+ self.colorMap[rowObject.color40] +"'>"+cellvalue+"</div>";
				}  },
				{ name: "score50", label: "财务", index: "score50",width: 40, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
					return "<div style='background-color:"+ self.colorMap[rowObject.color50] +"'>"+cellvalue+"</div>";
				}  },
				{ name: "score60", label: "其他", index: "score60",width: 40, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
					return "<div style='background-color:"+ self.colorMap[rowObject.color60] +"'>"+cellvalue+"</div>";
				}  },
				{ name: "rgfmLevel", label: "评定状态", index: "rgfmLevel",width: 70, align:"center",sortable: true },
				{ name: "fmyxq", label: "有效期", index: "fmyxq",width: 100, align:"center",sortable: true },
				{ name: "redTimes", label: "红码次数", index: "redTimes",width: 60, align:"right",sortable: true },
				{ name: "yelTimes", label: "黄码次数", index: "yelTimes",width: 60, align:"right",sortable: true },
				{ name: "qylx", label: "企业类型", index: "qylx",width: 60, align:"center",sortable: true },
				{ name: "tsjsfs", label: "退税计算方式", index: "tsjsfs",width: 80, align:"center",sortable: true },
				{ name: "glcd", label: "管理等级", index: "glcd",width: 60, align:"center",sortable: true },
				{ name: "djzclx", label: "登记注册类型", index: "djzclx",width: 110, align:"left",sortable: true },
				{ name: "hy", label: "行业类型", index: "hy",width: 90, align:"left",sortable: true },
				{ name: "bazt", label: "备案状态", index: "bazt",width: 60, align:"left",sortable: true },
				{ name: "nsrzt", label: "纳税人状态", index: "nsrzt",width: 90, align:"left",sortable: true },
				{ name: "ckgm", label: "出口规模", index: "ckgm",width: 90, align:"left",sortable: true },
				{ name: "uptime", label: "更新时间", index: "uptime",width: 130, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<div class='link toHistory'>"+rowObject.uptime+"</div>";
				} },
				{ name: "note", label: "预警科目", index: "note",width: 90, align:"left",sortable: false },
				{ name: "qyfz", label: "企业分组", index: "qyfz",width: 120, align:"left",sortable: false },
				{ name: "swjgMc", label: "税务机关", index: "swjgMc",width: 120, align:"left",sortable: true },
			];
			$("#jkmcx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#jkmcx-tablePager',
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
					return $(".jkmcx .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if($(e.target).hasClass('toMx')){
						var djxh = getCellData("jkmcx-table", rowid, 'djxh')
						var nsrsbh = getCellData("jkmcx-table", rowid, 'nsrsbh')
						var nsrmc = getCellData("jkmcx-table", rowid, 'nsrmc')
						var swjgMc = getCellData("jkmcx-table", rowid, 'swjgMc')
						avalonRoot.addTab({title:"健康码指标赋分明细",component:"jkmZbffMx",params:{djxh: djxh,nsrsbh:nsrsbh,nsrmc:nsrmc,swjgMc:swjgMc}});
						return false;
					}else if($(e.target).hasClass('toHistory')){
						var nsrsbh = getCellData("jkmcx-table", rowid, 'nsrsbh')
						avalonRoot.addTab({title:"历史健康码明细",component:"jkmHistoryMx",params:{nsrsbh: nsrsbh}});
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
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"jkmcx-table");
					self.search(pageNo);
				}
			});
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jkmcx')).val();
			self.search(1);
		},
		search:function(pageNo){
			console.log(this.selectMc)
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jkmcx')).val() || 20;
			this.searchData.ywflDms = this.yjkms.join(',')
			var params=tools.clone(self.searchData);
			var mapArr = [
				{ key: 'glcd', value: 'dj.flglcd'},
				{	key: 'djzclx', value: 'dj.djzclx'},
				{ key: 'hy', value: 'dj.hy'},
				{ key: 'nsrzt', value: 'dj.nsrzt'},
				{ key: 'ckgm', value: 'dj.ckgm'}
			]
			for (var i=0;i<mapArr.length;i++) {
				params[mapArr[i].key] = this.selectMc[mapArr[i].value] && this.selectMc[mapArr[i].value].value.join(',') || ''
			}
			params.pageNo=pageNo;
			$("#jkmcx-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/qyjkm/list",params).done(function(res){
				if(res.code=='0'){
					$("#jkmcx-table").resetSelection();
					$("#jkmcx-table")[0].addJSONData(res.data);
					self.closeHyper()
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		getDynamicInit:function(){
			var self = this
			var params = {
				zbdldm: '1',
				zbxms: ['dj.djzclx','dj.hy','dj.flglcd','dj.nsrzt','dj.ckgm']
			}
			ajax("POST","/sszj/xmgl/dynamic/init/other",params).done(function(res){
				if(res.code=='0'){
					var data = res.data.fzItemsOther
					var order = ['dj.flglcd','dj.djzclx','dj.nsrzt','dj.hy','dj.ckgm']
					self.dictList = []
					for (var i=0;i<order.length;i++) {
						for (var j=0;j<data.length;j++) {
							if (order[i] == data[j].zbxmbm) {
								if (data[j].zbxmbm == 'dj.djzclx') {
									data[j].values = data[j].values[0].item
								}
								self.dictList.push(data[j])
							}
						}
					}
					self.resetSelectMc(self.dictList)
					self.initSelect(self.dictList)
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		// 重置分组指标选中内容
		resetSelectMc: function(allSelectList){
			var obj = {}
			for (var i=0;i<allSelectList.length;i++) {
				var item = allSelectList[i].zbxmbm
				obj[item] = { name: '', value: []}
			}
			this.selectMc = obj
		},
		initSelect: function(selectList){
			for (var i=0;i<selectList.length;i++) {
				var item = selectList[i]
				if (item.isTree == '1') {
					this.initSelectTree(item.zbxmbm, item.values)
				} else {
					this.initMultiselectDict(item)
				}
			}
		},
		// 多选下拉框
		initMultiselectDict: function(item){
			var self = this
			var id = '#jkmCx_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
			var options = []
			for(var i=0;i<item.values.length;i++) {
				var tmp = item.values[i]
				options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: false})
			}
			$(id).multiselect({
				nonSelectedText: '',
				nSelectedText: '项已选择',
				allSelectedText: '全部选中',
				onChange: function(option, checked, select) {
					var val = $(option).val()
					var values = self.selectMc[item.zbxmbm].value
					if (checked) {
						values.push(val)
					} else {
						var i = values.indexOf(val)
						values.splice(i,1)
					}
					self.selectMc[item.zbxmbm].value = values
				}
			});
			$(id).multiselect('dataprovider', options);
		},
		initSelectTree:function(zbxmbm, treelist, data) {
			var self = this;
			var domId = 'jkmCx_tree_'+zbxmbm.split('.')[0]+'_'+zbxmbm.split('.')[1]
			var setting = {
				check:{
					enable: true
				},
				view: {
					selectedMulti: false
				},
				data: data || {
					simpleData:{
						enable: true,
						idKey: "code",
					},
					key:{children:"item",name:"name"}
				},
				callback:{
					onCheck:function(e,id,node){
						self.treeCheckHandler(domId, zbxmbm)
						return;
					}
				}
			};
			$.fn.zTree.init($('#'+domId), setting, treelist);
		},
		// 选中后赋值
		treeCheckHandler: function(domId, zbxmbm){
			var treeObj = $.fn.zTree.getZTreeObj(domId);
			var nodes = treeObj.getCheckedNodes(true); // 获取输入框被勾选的节点集合
      var res = fxjsCommonFun.getFootNode(nodes)
			this.selectMc[zbxmbm].value = []
			var nameArr = []
			for (var i=0;i<res.length;i++) {
        this.selectMc[zbxmbm].value.push(res[i].code)
        nameArr.push(res[i].name)
			}
			this.selectMc[zbxmbm].name = nameArr.join(',')
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
				$.fn.zTree.init($(".jkmcx .jkmcxswjgtree.treeDiv"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.jkmcx .select-sub').toggle();
			$('.jkmcx .select-wrapper .icon').toggleClass("active");
			if ($('.jkmcx .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.jkmcx .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.jkmcx .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
    closeHyper:function(){
      $('.jkmcx .select-sub').hide();
      $('.jkmcx .select-wrapper .icon').removeClass('active');
      $('.jkmcx .select-wrapper .icon').attr("title","展开查询条件");
    },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.jkmcx').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.jkmcx').off('click');
		},
		exform:function(){
			var self=this;
			if($('#jkmcx-table').jqGrid('getRowData').length<=0){
					tools.info("请先查询列表");
					return ;
			}
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/sszj/export/zbgl/jkm");
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
				qylx:"",
        tsjsfs:"",
        glcd:"",
        djzclx:"",
        hy:"",
				jkmLevel:"",
				ywflDms:"",
				bazt: "",
				nsrzt: "",
				ckgm: "",
				pdzt: "",
				qyfz: "",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= avalonRoot.user.swjgMc;
			this.djzclx = ''
			this.hy = ''
			this.initMultiselect()
		},
		// 多选下拉框
		initMultiselect: function(){
			var self = this
			this.yjkms = []
			var id = '#jkmcx-yjkm'
			var options = []
			for(var i=0;i<this.yjkmList.length;i++) {
				var tmp = this.yjkmList[i]
				options.push({label: tmp.ywflJc, title: tmp.ywflJc, value: tmp.ywflDm, selected: false})
			}
			$(id).multiselect({
				nonSelectedText: '',
				nSelectedText: '项已选择',
				allSelectedText: '全部选中',
				onChange: function(option, checked, select) {
					var val = $(option).val()
					var values = self.yjkms
					if (checked) {
						values.push(val)
					} else {
						var i = values.indexOf(val)
						values.splice(i,1)
					}
					self.yjkms = values
				}
			});
			$(id).multiselect('dataprovider', options);
		},
		jkmChange:function(){
			if (this.yjkms.length > 0 && ['2','3'].indexOf(this.searchData.jkmLevel) == -1) {
				this.initMultiselect()
			}
		},
		getYwfl: function(){
			var self = this
			ajax("POST","/sszj/zbgl/zb/getYwfl",{}).done(function(res){
				if(res.code=='0'){
					self.yjkmList = res.data
					self.yjkmList.unshift({ywflDm: "zh", ywflMc: "综合", ywflJc: "综合"})
					self.initMultiselect();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		getQyjkmQyfz: function(){
			var self = this
			api.getQyjkmQyfz({}).done(function(res){
				if(res.code=='0'){
					self.qyfzList = res.data
				}
			})
		}
	}
});