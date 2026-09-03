var sxxmgl=require("./sxxmgl.html");
var fxjsCommonFun = require('../../../config/fxjsCommonFun.js');
avalon.component('sxxmgl', {
	template:sxxmgl,
	defaults: {
		params:{},
		act:1,
		tcode: "sxxmglcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			swjgDm:"",
			xmmc:"",
			crTimeQ:"",
			crTimeZ:"",
			tsjsfsDm:"",
			note:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		dictList: [],
		swjgList: [],
		selectMc: {},
		step: '1',
		modelData: {
			id: '',
			xmmc: '',
			note: '',
			tsjsfsDm: ''
		},
		dataList: [],
		addTitle: '',
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjgDm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
			this.initTree();
			this.initDate();
			this.createTable();
		},
		initDate: function(){
			var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
			var optionsY = { language: "zh-CN", format: "yyyy", autoclose: true, clearBtn: true, startView: 4, minView: 4, forceParse: 0 };
			$('.sxxmgl .datepicker.date-day').datetimepicker(options);
			$('.sxxmgl .datepicker.date-year').datetimepicker(optionsY);
    },
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true },
				{ name: "xmmc", label: "项目名称", index: "xmmc",width: 140, align:"left",sortable: true },
				{ name: "tsjsfs", label: "企业类型", index: "tsjsfs",width: 80, align:"center",sortable: true },
				{ name: "tsjsfsDm", label: "企业类型代码", hidden:true },
				{ name: "statusStr", label: "项目状态", index: "statusStr",width: 80, align:"center",sortable: true },
				{ name: "crUser", label: "创建人", index: "crUser",width: 80, align:"left",sortable: false },
				{ name: "crTime", label: "创建时间", index: "crTime",width: 140, align:"center",sortable: false },
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 180, align:"left",sortable: true },
				{ name: "note", label: "备注说明", index: "note",width: 220, align:"left",sortable: false },
				{ name: "op", label: "操作", index: "op",width: 170, formatter: function(cellvalue, options, rowObject){
					var op = "<div style='text-align:center;'><div style='text-align:center;'><div class='btn op-edit "+(rowObject.isMyself=='1' && rowObject.status=='0' ? '' : 'disabled')+"' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn op-sx "+(rowObject.isMyself=='0' ? 'disabled' : '')+"' style='float: none;display: inline-block;' title='筛选'>筛选</div><div class='btn op-del "+(rowObject.isDelete=='0' ? 'disabled' : '')+"' style='float: none;display: inline-block;' title='删除'>删除</div>";
					op +="</div>";
					return op;
				} },
			];
			$("#sxxmgl-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#sxxmgl-tablePager',
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
					return $(".sxxmgl .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var id = getCellData("sxxmgl-table", rowid, 'id');
					var row = $("#sxxmgl-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('disabled')) return false;
					if($(e.target).hasClass('op-edit')){
						self.showModel('编辑');
						self.modelData = {
							id: row.id,
							xmmc: row.xmmc,
							note: row.note,
							tsjsfsDm: row.tsjsfsDm
						}
					}else if($(e.target).hasClass('op-sx')){
						avalonRoot.addTab({title:"筛选项目编辑",component:"ssxmEdit",params:{id:id}});
						return false;
					}else if($(e.target).hasClass('op-del')){
						tools.confirm('是否确定进行删除操作？','确定', function(){
							ajax("POST","/sszj/xmgl/delete",{id: id}).done(function(res){
								if(res.code=='0'){
									tools.info('删除成功！');
									self.search(1);
								}else{
									tools.info(res.msg);
								}
							}).fail(function(err){
								tools.info(err);
							})
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
					var pageNo=tools.getPageNo(pgButton,"sxxmgl-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
			if(self.params.doSearch){
				self.search(1);
			}
		},
		search:function(pageNo){
			var self=this;
			var valid = tools.checkDate(this.searchData.crTimeQ, this.searchData.crTimeZ)
			if (!valid) {
				tools.info('创建日期截止时间应不小于起始时间');
				return false;
			}
			this.searchData.pageSize = $(".ui-pg-selbox", $('.sxxmgl .list')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#sxxmgl-table").jqGrid('clearGridData')
			ajax("POST","/sszj/xmgl/list",params).done(function(res){
				if(res.code=='0'){
					self.dataList = res.data.rows
					$("#sxxmgl-table").resetSelection();
					$("#sxxmgl-table")[0].addJSONData(res.data);
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
						self.searchData.swjgDm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					},
					onDblClick:function(e,id,node){
						self.searchData.swjgDm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			};
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				self.swjgList = data
				$.fn.zTree.init($("#sxxmglTree"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.sxxmgl .select-sub').toggle();
			$('.sxxmgl .select-wrapper .icon').toggleClass("active");
			if ($('.sxxmgl .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.sxxmgl .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.sxxmgl .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
		closeHyper:function(){
			$('.sxxmgl .select-sub').hide();
			$('.sxxmgl .select-wrapper .icon').removeClass('active');
			$('.sxxmgl .select-wrapper .icon').attr("title","展开查询条件");
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.sxxmgl').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.sxxmgl').off('click');
		},
		exformModel:function(){
			tools.exform({}, '/sszj/export/ybqy/template')
		},
		reset: function() {
			this.searchData = {
				swjgDm:avalonRoot.user.swjgDm,
				xmmc:"",
				crTimeQ:"",
				crTimeZ:"",
				tsjsfsDm:"",
				note:"",
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
		// 创建项目
		showModel: function(title){
			this.addTitle = title
			$('.model').show();
			$('.sxxmgl .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.sxxmgl .add-page-model').hide();
			this.modelData = {
				id: '',
				xmmc: '',
				note: '',
				tsjsfsDm: ''
			}
		},
		saveModel: function(){
			var self = this
			var rules = [
        { name: 'xmmc',  message: '项目名称不能为空！'},
        { name: 'tsjsfsDm',  message: '企业类型不能为空！'}
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return false;
        }
      }
      var params = tools.clone(this.modelData)
      ajax("POST","/sszj/xmgl/saveXm",params).done(function(res){
				if(res.code=='0'){
          tools.info('保存成功！');
          self.hideModel();
					self.search(1);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		}
	}
});