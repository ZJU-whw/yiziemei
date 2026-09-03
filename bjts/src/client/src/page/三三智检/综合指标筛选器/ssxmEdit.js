var ssxmEdit=require("./ssxmEdit.html");
var fxjsCommonFun = require('../../../config/fxjsCommonFun.js');
avalon.component('ssxmEdit', {
	template:ssxmEdit,
	defaults: {
		$id: 'ssxmEdit',
		params:{},
		act:1,
		tcode: "ssxmEditcx",
		swjgmc: "",
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
    formData: {},
		previewData: {
			qyxx: ''
		},
		modelData: {
			id: '',
			xmmc: '',
			note: '',
			tsjsfsDm: '',
			swjg: '',
			swjgStr: '',
			ybqy: '',
			flglcd: '',
			flglcdStr: '',
			djzclx: '',
			djzclxStr: '',
			hy: '',
			hyStr: '',
			nsrzt: '',
			nsrztStr: '',
			ckgm: '',
			ckgmStr: ''
		},
		dataList: [],
		addTitle: '',
    tabList: [
			{ name: '目标企业', activeName: '1', isFirst: true },
			{ name: '规则维护', activeName: '2', isFirst: true, func: 'createTableGzwh' },
			{ name: '批次结果', activeName: '3', isFirst: true, func: 'initPcResult' }
    ],
    activeName: '1',
    ystjMap: [
      { name: '行业类型', key: 'hyStr'},
      { name: '登记类型', key: 'djzclxStr'},
      { name: '企业状态', key: 'nsrztStr'},
      { name: '出口规模', key: 'ckgmStr'},
      { name: '分类管理类别', key: 'flglcdStr'},
    ],
		gzbjqVisible: false,
		ruleData:{
			id: '',
			rulename: '',
			expression: [],
			note: '',
			showorder: '',
			yxbz: 'Y',
			expressionCname: [],
			fxqType: '',
			fxqOffset: '-1',
			fxqRange: '',
		},
		selGzRows: [],
		selPcRulesRows: [],
		gzwhData: {
			rulename: '',
			note: ''
		},
		previewGzExpression: '',
		sxData: {
			ssq: '',
			relyPc: ''
		},
		relyPcList: [],
		uuid: '',
		allFlag: '',
		gxlx: '0',
		isOnlyEditRules: false,
		importFaData: {
			famc: ''
		},
		isCreateTableImportFa: false, // 是否创建过载入方案列表
		addTitleGz: '',
		shareFaVisible: false,
		swjgIds: '',
		swjgStr: '',
		fxqRangeList: [],
		onInit: function (e) {
      components.ssxmEdit = e.vmodel;
    },
		onReady:function(){
			this.fxqRangeList = new Array(12)
			this.initTree();
			this.getDictList();
			this.importCallBack();
			this.initDate();
		},
		// 获取项目信息详情
    getXmmx: function(){
      var self = this
      ajax("POST","/sszj/xmgl/xmmx",{id: this.params.id}).done(function(res){
        if(res.code=='0'){
          self.formData = tools.clone(res.data)
          self.modelData = tools.clone(res.data)
					self.createTablePreview();
					var isDisabled = self.formData.status != '0'
					self.recordsHandler(isDisabled);
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
		createTablePreview:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 160, align:"left",sortable: false },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 200, align:"left",sortable: false},
				{ name: "tsjsfs", label: "退税计算方式", index: "tsjsfs",width: 80, align:"center",sortable: false },
				{ name: "flglcd", label: "分类管理", index: "flglcd",width: 60, align:"center",sortable: false },
				{ name: "nsrzt", label: "纳税人状态", index: "nsrzt",width: 80, align:"center",sortable: false },
				{ name: "djzclx", label: "登记类型", index: "djzclx",width: 120, align:"left",sortable: false },
				{ name: "hy", label: "行业", index: "hy",width: 200, align:"left",sortable: false },
				{ name: "ckgm", label: "出口规模", index: "ckgm",width: 200, align:"center",sortable: false },
			];
			$("#ssxmEdit-target-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#ssxmEdit-target-tablePager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
				width:"100%",
				height: (function(){
					return $(".ssxmEdit").height() - 230;
				})(),
				beforeSelectRow:function(rowid,e){
					if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
						return false;
					}else{
						return true;
					}
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"ssxmEdit-target-table");
					self.getPreviewList(pageNo);
				}
			});
			if (this.formData.status != '0') {
				this.getPreviewList(1);
			}
		},
    createTableGzwh:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "id",hidden:true },
				{ name: "expression", label: "英文表达式", index: "expression",hidden:true },
				{ name: "expressionCname", label: "中文表达式", index: "expressionCname",hidden:true },
				{ name: "rulename", label: "规则名称", index: "rulename",width: 300, align:"left",sortable: false },
				{ name: "yxbz", label: "启用标志", index: "yxbz",hidden:true },
				{ name: "yxbzName", label: "启用标志", index: "yxbzName",width: 60, align:"center",sortable: false,formatter: function(cellvalue, options, rowObject){
					var map = {'Y': '有效', 'N': '无效'}
					return map[rowObject.yxbz] || '';
				}},
				{ name: "syzt", label: "使用状态", index: "syzt",width: 60, align:"center",sortable: false },
				{ name: "showorder", label: "显示顺序", index: "showorder",width: 60, align:"left",sortable: false },
				{ name: "expressionCnameTmp", label: "规则表达式", index: "expressionCnameTmp",width: 160, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
					if (rowObject.expressionCname) {
						return JSON.parse(rowObject.expressionCname).join('')
					} else {
						return ''
					}
				} },
				{ name: "note", label: "业务描述", index: "note",width: 140, align:"left",sortable: false },
				{ name: "fxqType", label: "分析期偏移类型", index: "fxqType",hidden: true },
				{ name: "fxqTypeStr", label: "分析期偏移类型", index: "fxqTypeStr",width: 90, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = {
						'0': '月',
						'1': '季',
						'2': '年',
					}
					return map[rowObject.fxqType] || ''
				} },
				{ name: "fxqOffset", label: "分析期偏移量", index: "fxqOffset",width: 80, align:"center",sortable: false },
				{ name: "fxqRange", label: "分析期月跨度", index: "fxqRange",width: 80, align:"center",sortable: false },
        { name: "op", label: "操作", index: "op",width: 120, formatter: function(cellvalue, options, rowObject){
					var op = "<div style='text-align:center;'><div class='btn op-edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn op-del "+(rowObject.syzt=='未用' ? '': 'disabled')+"' style='float: none;display: inline-block;' title='删除'>删除</div>";
					op +="</div>";
					return op;
				} },
			];
			$("#ssxmEdit-gzwh-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				multiselect: true,
				multiselectWidth:"40",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: 10000,
				width:"100%",
				height: (function(){
					return $(".ssxmEdit").height() - 270;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#ssxmEdit-gzwh-table").jqGrid("getRowData", rowid)
					if ($(e.target).hasClass('disabled')) return false;
					if ($(e.target).hasClass('op-edit')){
						self.showGzModel('编辑');
						self.ruleData = {
							id: row.id,
							rulename: row.rulename,
							expression: row.expression ? JSON.parse(row.expression) : [],
							note: row.note,
							showorder: row.showorder,
							yxbz: row.yxbz,
							expressionCname: row.expressionCname ? JSON.parse(row.expressionCname) : [],
							fxqType: row.fxqType,
							fxqOffset: row.fxqOffset,
							fxqRange: row.fxqRange,
						}
						return false;
					} else if ($(e.target).hasClass('op-del')){
						tools.confirm('是否确定执行删除操作？','确定',function(){
							var params = {
								zid: self.params.id,
								id: row.id
							}
							ajax("POST","/sszj/sxgn/deleteRule",params).done(function(res){
								if(res.code=='0'){
									tools.info('删除成功！');
									self.getXmRules(1);
								}else{
									tools.info(res.msg);
								}
							}).fail(function(err){
								tools.info(err);
							})
						})
						return false;
					} else if(e.target.nodeName=="TD"){
						self.previewGzExpression = row.expressionCname ? JSON.parse(row.expressionCname).join('') : ''
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
						return false;
					}else{
						return true;
					}
				},
				onSelectRow: function (rowid, status) {
          var index = self.selGzRows.indexOf(rowid);
          if (status) {
            self.selGzRows.push(rowid)
          } else {
            self.selGzRows.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          if (status) {
            self.selGzRows = JSON.parse(JSON.stringify(rowids));
          } else {
            self.selGzRows = [];
          }
        }
			});
			this.getXmRules(1);
		},
    createTablePc:function(){
			var self=this;
			var columns = [
				{ name: "uuid", label: "主键id", index: "uuid",hidden:true },
				{ name: "pc", label: "筛选批次", index: "pc",width: 80, align:"center",sortable: false },
				{ name: "ssq", label: "所属期", index: "ssq",width: 80, align:"center",sortable: false },
				{ name: "ztbzStr", label: "状态", index: "ztbzStr",width: 60, align:"center",sortable: false },
				{ name: "startTime", label: "开始时间", index: "startTime",width: 130, align:"center",sortable: false },
				{ name: "endTime", label: "结束时间", index: "endTime",width: 130, align:"center",sortable: false },
				{ name: "relyPc", label: "依赖批次", index: "relyPc",width: 80, align:"center",sortable: false },
        { name: "op", label: "操作", index: "op",width: 160,sortable: false, formatter: function(cellvalue, options, rowObject){
					var op = "<div style='text-align:center;'><div class='btn op-executePc "+(rowObject.ztbz=='1' ? 'disabled': '')+"' style='float: none;display: inline-block;' title='重新筛选'>重新筛选</div><div class='btn op-del "+(rowObject.ztbz=='1' ? 'disabled': '')+"' style='float: none;display: inline-block;' title='删除批次'>删除批次</div>";
					op +="</div>";
					return op;
				} },
			];
			$("#ssxmEdit-pc-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:false,
				pager: '#ssxmEdit-pc-tablePager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
				width:"100%",
				height: (function(){
					return $(".ssxmEdit").height() / 2 - 130;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#ssxmEdit-pc-table").jqGrid("getRowData", rowid)
					if ($(e.target).hasClass('disabled')) return false;
					if ($(e.target).hasClass('op-executePc')){
						tools.confirm('确定进行重新执行筛选操作？','确定', function(){
							var params = {
								uuid: row.uuid,
								zid: self.params.id
							}
							ajax("POST","/sszj/sxgn/executePc",params).done(function(res){
								if(res.code=='0'){
									tools.info('操作完成！');
									self.getXmPcList(1);
								}else{
									tools.info(res.msg);
								}
							}).fail(function(err){
								tools.info(err);
							})
						})
					} else if ($(e.target).hasClass('op-del')){
						tools.confirm('确定进行删除批次操作？','确定', function(){
							var params = {
								uuid: row.uuid,
								zid: self.params.id
							}
							ajax("POST","/sszj/sxgn/deletePc",params).done(function(res){
								if(res.code=='0'){
									tools.info('操作完成！');
									self.getXmPcList(1);
								}else{
									tools.info(res.msg);
								}
							}).fail(function(err){
								tools.info(err);
							})
						})
					} else if(e.target.nodeName=="TD"){
						self.uuid = row.uuid
						self.getPcRules()
						self.allFlag = '1'
						self.getPcResult(1)
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
						return false;
					}else{
						return true;
					}
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"ssxmEdit-pc-table");
					self.getXmPcList(pageNo);
				}
			});
			this.getXmPcList(1);
		},
		createTablePcRules:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "id",hidden:true },
				{ name: "expression", label: "英文表达式", index: "expression",hidden:true },
				{ name: "expressionCname", label: "中文表达式", index: "expressionCname",hidden:true },
				{ name: "rulename", label: "规则名称", index: "rulename",width: 220, align:"left",sortable: false },
				{ name: "expressionMc", label: "规则表达式", index: "expressionMc",width: 120, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
					if (rowObject.expressionCname) {
						return JSON.parse(rowObject.expressionCname).join('')
					} else {
						return ''
					}
				} },
				{ name: "fxqQ", label: "分析期起", index: "fxqQ",width: 80, align:"left",sortable: false },
				{ name: "fxqZ", label: "分析期止", index: "fxqZ",width: 80, align:"left",sortable: false },
				{ name: "status", label: "执行状态", index: "status",width: 80, align:"left",sortable: false },
        { name: "op", label: "操作", index: "op",width: 80, formatter: function(cellvalue, options, rowObject){
					var op = "<div style='text-align:center;'><div class='btn op-edit' style='float: none;display: inline-block;' title='编辑规则'>编辑规则</div>";
					op +="</div>";
					return op;
				} },
			];
			$("#ssxmEdit-pcRules-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				multiselect: true,
				multiselectWidth:"40",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: 10000,
				width:"100%",
				height: (function(){
					return $(".ssxmEdit").height() / 2 - 120;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#ssxmEdit-pcRules-table").jqGrid("getRowData", rowid)
					if ($(e.target).hasClass('disabled')) return false;
					if ($(e.target).hasClass('op-edit')){
						$('.model').show();
						self.ruleData = {
							id: row.id,
							rulename: '',
							expression: row.expression ? JSON.parse(row.expression) : [],
							expressionCname: row.expressionCname ? JSON.parse(row.expressionCname) : [],
							note: '',
							showorder: '',
							yxbz: '',
							fxqType: '',
							fxqOffset: '-1',
							fxqRange: '',
						}
						self.isOnlyEditRules = true;
						self.addGz();
						return false;
					} else if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
						return false;
					}else{
						return true;
					}
				},
				onSelectRow: function (rowid, status) {
					self.allFlag = '0'
          var index = self.selPcRulesRows.indexOf(rowid);
          if (status) {
            self.selPcRulesRows.push(rowid)
          } else {
            self.selPcRulesRows.splice(index, 1);
          }
					self.getPcResult(1);
        },
        onSelectAll: function (rowids, status) {
					self.allFlag = '0'
          if (status) {
            self.selPcRulesRows = JSON.parse(JSON.stringify(rowids));
          } else {
            self.selPcRulesRows = [];
          }
					self.getPcResult(1);
        }
			});
		},
		createTablePcResult:function(){
			var self=this;
			var columns = [
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 150, align:"left",sortable: false },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 170, align:"left",sortable: false},
				{ name: "mzsl", label: "命中数量", index: "mzsl",width: 70, align:"right",sortable: false }
			];
			$("#ssxmEdit-pcResult-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#ssxmEdit-pcResult-tablePager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
				width:"100%",
				height: (function(){
					return $(".ssxmEdit").height() - 217;
				})(),
				beforeSelectRow:function(rowid,e){
					if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
						return false;
					}else{
						return true;
					}
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"ssxmEdit-pcResult-table");
					self.getPcResult(pageNo);
				}
			});
		},
		createTableImportFa:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true },
				{ name: "famc", label: "方案名称", index: "famc",width: 90, align:"left",sortable: true },
				{ name: "tsjsfs", label: "退税计算方式", index: "tsjsfs",width: 80, align:"center",sortable: true },
				{ name: "crUser", label: "创建人", index: "crUser",width: 80, align:"left",sortable: false },
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 180, align:"left",sortable: true },
				{ name: "note", label: "备注说明", index: "note",width: 220, align:"left",sortable: true },
				{ name: "op", label: "操作", index: "op",width: 60, formatter: function(cellvalue, options, rowObject){
					var op = "<div style='text-align:center;'><div class='btn op-import' style='float: none;display: inline-block;' title='载入'>载入</div>";
					op +="</div>";
					return op;
				} },
			];
			$("#ssxmEdit-importFa-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#ssxmEdit-importFa-tablePager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
				width:"100%",
				height:270,
				beforeSelectRow:function(rowid,e){
					var id = getCellData("ssxmEdit-importFa-table", rowid, 'id');
					if($(e.target).hasClass('disabled')) return false;
					if($(e.target).hasClass('op-import')){
						var params = {
							gid: id,
							zid: self.params.id
						}
						ajax("POST","/sszj/xmgl/importFa",params).done(function(res){
							if(res.code=='0'){
								tools.info('载入成功！');
								self.hideFaModel();
								self.getXmmx();
								if (!self.tabList[1].isFirst) {
									self.getXmRules(1);
								}
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
					self.searchData.orderSql = orderSql;
					self.getImportFaList(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"ssxmEdit-importFa-table");
					self.getImportFaList(pageNo);
				}
			});
			this.isCreateTableImportFa = true
			this.getImportFaList(1);
		},
		// 获取规则列表
		getXmRules: function(pageNo){
			var self = this
			var params = {
				zid: this.params.id,
				rulename: this.gzwhData.rulename,
				note: this.gzwhData.note
			}
			$("#ssxmEdit-gzwh-table").jqGrid('clearGridData')
      ajax("POST","/sszj/sxgn/getXmRules",params).done(function(res){
        if(res.code=='0'){
					$("#ssxmEdit-gzwh-table").resetSelection();
					$("#ssxmEdit-gzwh-table")[0].addJSONData(res.data);
          self.previewGzExpression = ''
					self.selGzRows = []
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
		},
		resetModelData: function(){
			// this.resetSelectMc(this.dictList)
			this.modelData = {
				id: '',
				xmmc: '',
				note: '',
				tsjsfsDm: '',
				swjg: '',
				swjgStr: '',
				ybqy: '',
				flglcd: '',
				flglcdStr: '',
				djzclx: '',
				djzclxStr: '',
				hy: '',
				hyStr: '',
				nsrzt: '',
				nsrztStr: '',
				ckgm: '',
				ckgmStr: ''
			}
		},
		initTree:function() {
			var self = this;
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				self.swjgList = data
				self.initSelectTree('dj.swjg', data,{key:{children:"item",name:"text"}})
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.ssxmEdit .select-sub').toggle();
			$('.ssxmEdit .select-wrapper .icon').toggleClass("active");
			if ($('.ssxmEdit .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.ssxmEdit .select-wrapper .icon').attr("title","收起");
			} else {
				$('.ssxmEdit .select-wrapper .icon').attr("title","展开")
			}
		},
		closeHyper:function(){
			$('.ssxmEdit .select-sub').hide();
			$('.ssxmEdit .select-wrapper .icon').removeClass('active');
			$('.ssxmEdit .select-wrapper .icon').attr("title","展开");
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.ssxmEdit').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.ssxmEdit').off('click');
		},
		exformModel:function(){
			tools.exform({}, '/sszj/export/ybqy/template')
		},
		getDictList: function(){
			var self = this
			var params = {
				zbdldm: '1',
				zbxms: ["dj.hy","dj.djzclx","dj.nsrzt","dj.ckgm","dj.flglcd"]
			}
			ajax("POST","/sszj/xmgl/dynamic/init/other",params).done(function(res){
				if(res.code=='0'){
					var data = res.data.fzItemsOther
					var order = ['dj.hy','dj.djzclx','dj.nsrzt','dj.ckgm','dj.flglcd']
					self.dictList = []
					for (var i=0;i<order.length;i++) {
						for (var j=0;j<data.length;j++) {
							if (order[i] == data[j].zbxmbm) {
								self.dictList.push(data[j])
							}
						}
					}
					self.resetSelectMc(self.dictList)
					self.initSelect(self.dictList)
					components.shareFa.dictList = self.dictList
					components.shareFa.resetSelectMc(self.dictList)
					components.shareFa.initSelect(self.dictList)
          self.getXmmx();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		initSelect: function(selectList){
			for (var i=0;i<selectList.length;i++) {
				let item = selectList[i]
				if (item.isTree == '1') {
					if (item.zbxmbm == 'dj.djzclx') {
						this.initSelectTree(item.zbxmbm, item.values[0])
					} else {
						this.initSelectTree(item.zbxmbm, item.values)
					}
				} else {
					this.initMultiselect(item)
				}
			}
		},
		// 多选下拉框
		initMultiselect: function(item){
			var self = this
			let id = '#ssxmEdit_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
			let options = []
			for(var i=0;i<item.values.length;i++) {
				let tmp = item.values[i]
				options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: false})
			}
			$(id).multiselect({
				nonSelectedText: '',
				nSelectedText: '项已选择',
				allSelectedText: '全部选中',
				onChange: function(option, checked, select) {
					let val = $(option).val()
					let values = self.selectMc[item.zbxmbm].value
					if (checked) {
						values.push(val)
					} else {
						let i = values.indexOf(val)
						values.splice(i,1)
					}
					self.selectMc[item.zbxmbm].value = values
				}
			});
			$(id).multiselect('dataprovider', options);
		},
		initSelectTree:function(zbxmbm, treelist, data) {
			var self = this;
			var domId = 'ssxmEdit_tree_'+zbxmbm.split('.')[0]+'_'+zbxmbm.split('.')[1]
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
			if (zbxmbm == 'dj.swjg') {
				var res = this.swjgGetFootNode(nodes)
				this.swjgDataHandler(nodes)
			} else {
				var res = fxjsCommonFun.getFootNode(nodes)
			}
			this.selectMc[zbxmbm].value = []
			var nameArr = []
			for (var i=0;i<res.length;i++) {
				if (zbxmbm == 'dj.swjg') {
					this.selectMc[zbxmbm].value.push(res[i].id)
					nameArr.push(res[i].text)
				} else {
					this.selectMc[zbxmbm].value.push(res[i].code)
					nameArr.push(res[i].name)
				}
			}
			this.selectMc[zbxmbm].name = nameArr.join(',')
		},
		swjgGetFootNode: function(arrVal){
			var arr = []
			for(var i=0;i<arrVal.length;i++) {
				if (arrVal[i].id != '') {
					arr.push(arrVal[i])
				}
			}
			var parentTIds = []
			var tIds = []
			for (var i=0;i<arr.length;i++) {
				parentTIds.push(arr[i].parentTId)
				tIds.push(arr[i].tId)
			}
			var res = tools.clone(arr)
			for (var j=0;j<tIds.length;j++) {
				var index = parentTIds.indexOf(tIds[j])
				if ( index > -1) {
					tIds.splice(j,1)
					res.splice(j,1)
					j--
				}
			}
			return res
		},
		swjgDataHandler: function(arrVal){
			var arr = []
			for(var i=0;i<arrVal.length;i++) {
				if (arrVal[i].id != '' && !arrVal[i].getCheckStatus().half) {
					arr.push(arrVal[i])
				}
			}
			var parentTIds = []
			var tIds = []
			for (var i=0;i<arr.length;i++) {
				parentTIds.push(arr[i].parentTId)
				tIds.push(arr[i].tId)
			}
			var res = tools.clone(arr)
			for (var j=0;j<parentTIds.length;j++) {
				var index = tIds.indexOf(parentTIds[j])
				if ( index > -1) {
					parentTIds.splice(j,1)
					res.splice(j,1)
					j--
				}
			}
			var swjgs = []
			var nameArr = []
			for (var i=0;i<res.length;i++) {
				swjgs.push(res[i].id)
				nameArr.push(res[i].text)
			}
			this.swjgIds = swjgs.join(',')
			this.swjgStr = nameArr.join(',')
		},
		// 重置分组指标选中内容
		resetSelectMc: function(allSelectList){
			var obj = {}
			for (var i=0;i<allSelectList.length;i++) {
				let item = allSelectList[i].zbxmbm
				obj[item] = { name: '', value: []}
			}
			obj['dj.swjg'] = { name: '', value: []}
			this.selectMc = obj
		},
		recordsHandler: function(isDisabled){
			for(var i=0;i<this.dictList.length;i++) {
				let item = this.dictList[i]
				var key = item.zbxmbm.split('.')[1]
				this.selectMc[item.zbxmbm].name = this.modelData[key+'Str']
				var values = this.modelData[key] && this.modelData[key].split(',') || []
				this.selectMc[item.zbxmbm].value = values
				if (item.isTree == '1') { // 下拉树形多选
					let domId = 'ssxmEdit_tree_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
					var treeObj = $.fn.zTree.getZTreeObj(domId);
					for (var j=0;j<values.length;j++) {
						let node = treeObj.getNodesByParam("code", values[j], null)[0];
						treeObj.checkNode(node, true, true);
					}
					if (isDisabled) {
						var nodes = treeObj.transformToArray(treeObj.getNodes());
						for (var k=0, l=nodes.length; k < l; k++) {
							treeObj.setChkDisabled(nodes[k], true);
						}
					}
				} else { // 下拉多选
					let domId = '#ssxmEdit_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
					let options = []
					for(var j=0;j<item.values.length;j++) {
						let tmp = item.values[j]
						let selected = values.indexOf(tmp.code) > -1
						options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: selected, disabled: isDisabled})
					}
					$(domId).multiselect('dataprovider', options);
				}
			}
			var values = this.modelData.swjg && this.modelData.swjg.split(',') || []
			var treeObj = $.fn.zTree.getZTreeObj('ssxmEdit_tree_dj_swjg');
			for (var j=0;j<values.length;j++) {
				let node = treeObj.getNodesByParam("id", values[j], null)[0];
				treeObj.checkNode(node, true, true);
			}
			this.treeCheckHandler('ssxmEdit_tree_dj_swjg', 'dj.swjg')
			if (isDisabled) {
				var nodes = treeObj.transformToArray(treeObj.getNodes());
				for (var k=0, l=nodes.length; k < l; k++) {
					treeObj.setChkDisabled(nodes[k], true);
				}
			}
		},
		// 预览
		preview: function(){
			if (this.modelData.tsjsfsDm == '') {
				tools.info('退税计算方式不能为空！');
				return;
			}
			this.dataHandler()
			this.previewData.qyxx = ''
			this.getPreviewList(1)
      this.activeName = '1'
		},
		getPreviewList:function(pageNo){
			var params = tools.clone(this.modelData);
			params.qyxx = this.previewData.qyxx
			params.pageNo=pageNo;
			params.pageSize = $(".ui-pg-selbox", $('.ssxmEdit .preview')).val() || 20;
      $("#ssxmEdit-target-table").jqGrid('clearGridData');
			ajax("POST","/sszj/xmgl/mbqyyl",params).done(function(res){
				if(res.code=='0'){
					$("#ssxmEdit-target-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		previewExform: function(){
			if($('#ssxmEdit-target-table').jqGrid('getRowData').length<=0){
				tools.info("请先查询列表");
				return ;
			}
			var params = tools.clone(this.modelData);
			params.qyxx = this.previewData.qyxx
			tools.exform(params,'/sszj/export/mbqy/list')
		},
		// 数据处理
		dataHandler: function(){
			var arr = ['djzclx','hy']
      var multiselectArr = ['nsrzt','ckgm','flglcd']
			this.modelData.swjg = this.swjgIds
			this.modelData.swjgStr = this.swjgStr
			for (var i=0;i<arr.length;i++) {
				var obj = this.selectMc['dj.'+arr[i]]
				if (obj.value.length>0) {
					this.modelData[arr[i]] = obj.value.join(',');
					this.modelData[arr[i]+'Str'] = obj.name;
				} else {
					this.modelData[arr[i]] = '';
					this.modelData[arr[i]+'Str'] = '';
				}
			}
      for (var j=0;j<multiselectArr.length;j++) {
				var obj = this.selectMc['dj.'+multiselectArr[j]]
        if (obj.value.length>0) {
          for(var k=0;k<this.dictList.length;k++) {
            if ('dj.'+multiselectArr[j] == this.dictList[k].zbxmbm) {
              var list = this.dictList[k].values
              var names = []
              for (var n=0;n<list.length;n++) {
                if (obj.value.indexOf(list[n].code) > -1) {
                  names.push(list[n].name)
                }
              }
              this.modelData[multiselectArr[j]] = obj.value.join(',');
					    this.modelData[multiselectArr[j]+'Str'] = names.join(',');
            }
          }
        } else {
					this.modelData[multiselectArr[j]] = '';
					this.modelData[multiselectArr[j]+'Str'] = '';
				}
      }
		},
		// 校验必填项
		checkValid: function(){
			var rules = [
        { name: 'xmmc',  message: '项目名称不能为空！'},
        { name: 'tsjsfsDm',  message: '退税计算方式不能为空！'}
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return false;
        }
      }
			return true;
		},
		// 创建 
		// action 0-不启动，1-启动
		saveModel: function(action){
			if (this.formData.status != '0') return;
			var self = this
			var valid = this.checkValid()
			if (valid){
				this.dataHandler()
				var params = tools.clone(this.modelData)
				params.action = action
				ajax("POST","/sszj/xmgl/save",params).done(function(res){
					if(res.code=='0'){
						tools.info('操作成功！');
						self.closeHyper();
            self.getXmmx();
					}else{
						tools.info(res.msg);
					}
				}).fail(function(err){
					tools.info(err);
				})
			}
		},
		// 启动
		start: function(){
			var self = this
			if (this.formData.status != '0') return;
			ajax("POST","/sszj/xmgl/start",{id: this.params.id}).done(function(res){
				if(res.code=='0'){
					tools.info('启动成功！');
					self.getXmmx();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		importCallBack: function(){
      var self = this;
      $('#ssxmEditFileupload').fileupload({
        dataType: 'json',
        acceptFileTypes: /(xls|xlsx)$/i,
        maxFileSize: 4000000, // 限制大小4M
				add: function (e, data) {
					//将赋值完毕的参数实体，再赋值给插件formData属性
					data.formData = {id: self.modelData.id};
					data.submit(); 
				},
        done: function (e, data) {
          if (data.result.code == "0") {
						self.modelData.ybqy = data.result.data
						tools.info("导入成功!");
          } else {
            tools.info(data.result.msg);
          }
        }
      }).on('fileuploadadd', function(e, data){
        $('.app-loading').show();
      }).on('fileuploadalways', function(e, data){
        $('.app-loading').hide();
      })
    },
    changeTab: function(index){
      var item = this.tabList[index]
      this.activeName = item.activeName
      if (item.isFirst && item.func) {
        this[item.func]();
        this.tabList[index].isFirst = false;
      }
    },
		showGzModel: function(title){
			this.addTitleGz = title
			$('.model').show();
			$('.ssxmEdit .editgz-page-model').show();
		},
		hideGzModel: function(){
			$('.model').hide();
			$('.ssxmEdit .editgz-page-model').hide();
			this.gzbjqVisible = false;
			this.resetRuleData();
		},
		resetRuleData: function() {
			this.ruleData = {
				id: '',
				rulename: '',
				expression: [],
				note: '',
				showorder: '',
				yxbz: 'Y',
				expressionCname: [],
				fxqType: '',
				fxqOffset: '-1',
				fxqRange: '',
			}
		},
		// 弹出规则表达式弹框
		addGz: function(){
			this.gzbjqVisible = true
			components.gzbjq.zid = this.params.id
			components.gzbjq.expressionDmList = tools.clone(this.ruleData.expression)
			components.gzbjq.expressionMcList = tools.clone(this.ruleData.expressionCname)
			components.gzbjq.expressionMc =	this.ruleData.expressionCname.join('')
		},
		saveGzModel: function(){
			var self = this
      var rules = [
        { name: 'rulename', message: '规则名称不能为空！' },
        { name: 'yxbz', message: '有效标志不能为空！' },
        { name: 'fxqType', message: '分析期偏移类型不能为空！' },
        { name: 'fxqOffset', message: '分析期偏移量不能为空！' },
        { name: 'fxqRange', message: '分析期月跨度不能为空！' },
      ]
      for (var i=0;i<rules.length;i++) {
				if (this.ruleData[rules[i].name] == '') {
					tools.info(rules[i].message);
					return;
				}
      }
			var params = {
				id: this.ruleData.id,
				zid: this.params.id,
				rulename: this.ruleData.rulename,
				expression: this.ruleData.expression.length >0 ? JSON.stringify(this.ruleData.expression) : '',
				expressionCname: this.ruleData.expressionCname.length >0 ? JSON.stringify(this.ruleData.expressionCname) : '',
				note: this.ruleData.note,
				showorder: this.ruleData.showorder,
				yxbz: this.ruleData.yxbz,
				fxqType: this.ruleData.fxqType,
				fxqOffset: this.ruleData.fxqOffset,
				fxqRange: this.ruleData.fxqRange,
			}
      ajax("POST","/sszj/sxgn/saveRule",params).done(function(res){
				if(res.code=='0'){
					tools.info('保存成功！');
          self.hideGzModel();
          self.getXmRules(1);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		initDate: function(){
			$('.ssxmEdit .datepicker.date-month').datetimepicker({
				language:'zh-CN',
				format: 'yyyy-mm',
				weekStart: 1,
				todayBtn: 1,
				autoclose: 1,
				todayHighlight: 1,
				startView: 3, // 这里就设置了默认视图为年视图
				minView: 3, // 设置最小视图为年视图
				forceParse: 0
			})
		},
		// 获取项目可依赖的筛选批次
		getRelyPc: function(){
			var self = this
			ajax("POST","/sszj/sxgn/getRelyPc",{zid: this.params.id}).done(function(res){
				if(res.code=='0'){
					self.relyPcList = res.data
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		showSxModel: function(){
			if (this.formData.status == '0') return;
			if (this.selGzRows.length<=0) {
				tools.info('请先选择要执行筛选的规则！')
				return false;
			}
			this.getRelyPc();
			$('.model').show();
			$('.ssxmEdit .sx-page-model').show();
		},
		hideSxModel: function(){
			$('.model').hide();
			$('.ssxmEdit .sx-page-model').hide();
			this.sxData = {
				ssq: '',
				relyPc: ''
			}
		},
		saveSxModel: function(){
			var self = this
			var rules = [
        { name: 'ssq', message: '所属期不能为空！' },
      ]
      for (var i=0;i<rules.length;i++) {
				if (this.sxData[rules[i].name] == '') {
					tools.info(rules[i].message);
					return;
				}
      }
			var params = tools.clone(this.sxData)
			params.zid = this.params.id
			var ids = []
			for (var i=0;i<this.selGzRows.length;i++) {
				var row = $("#ssxmEdit-gzwh-table").jqGrid("getRowData", this.selGzRows[i])
				ids.push(row.id)
			}
			params.rules = ids.join(',')
			ajax("POST","/sszj/sxgn/savePcInfo",params).done(function(res){
				if(res.code=='0'){
					tools.info('执行筛选成功！');
					self.hideSxModel();
					if (!self.tabList[2].isFirst) {
						self.getXmPcList(1);
					}
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		initPcResult: function(){
			this.createTablePc();
			this.createTablePcRules();
			this.createTablePcResult();
		},
		// 项目筛选批次列表查询
		getXmPcList: function(pageNo){
			var params = {
				zid: this.params.id
			}
			params.pageNo=pageNo;
			params.pageSize = $(".ui-pg-selbox", $('.ssxmEdit .pc')).val() || 20;
			$("#ssxmEdit-pc-table").jqGrid('clearGridData');
			ajax("POST","/sszj/sxgn/getXmPcList",params).done(function(res){
				if(res.code=='0'){
					$("#ssxmEdit-pc-table")[0].addJSONData(res.data);
					$("#ssxmEdit-pcRules-table").resetSelection();
					$("#ssxmEdit-pcRules-table").jqGrid('clearGridData');
					self.selPcRulesRows = []
					$("#ssxmEdit-pcResult-table").jqGrid('clearGridData');
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		// 查询筛选批次使用的规则
		getPcRules: function(){
			var self = this
			var params = {
				zid: this.params.id,
				uuid: this.uuid
			}
			$("#ssxmEdit-pcRules-table").jqGrid('clearGridData');
			ajax("POST","/sszj/sxgn/getPcRules",params).done(function(res){
				if(res.code=='0'){
					$("#ssxmEdit-pcRules-table").resetSelection();
					$("#ssxmEdit-pcRules-table")[0].addJSONData(res.data);
					self.selPcRulesRows = $('#ssxmEdit-pcRules-table').jqGrid('getDataIDs');
					for(var i=0;i<self.selPcRulesRows.length;i++) {
						$('#ssxmEdit-pcRules-table').setSelection(self.selPcRulesRows[i],false)
					}
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		// 查询筛选批次使用的规则
		getPcResult: function(pageNo){
			var ids = []
			if (this.allFlag == '0') {
				for (var i=0;i<this.selPcRulesRows.length;i++) {
					var row = $("#ssxmEdit-pcRules-table").jqGrid("getRowData", this.selPcRulesRows[i])
					ids.push(row.id)
				}
			}
			var params = {
				zid: this.params.id,
				uuid: this.uuid,
				allFlag: this.allFlag, //1-查询满足所有规则的结果企业，0-查询满足指定规则的结果企业，默认为0
				rules: ids.join(',')
			}
			params.pageNo=pageNo;
			params.pageSize = $(".ui-pg-selbox", $('.ssxmEdit .pcResult')).val() || 20;
			$("#ssxmEdit-pcResult-table").jqGrid('clearGridData');
			ajax("POST","/sszj/sxgn/getPcResult",params).done(function(res){
				if(res.code=='0'){
					$("#ssxmEdit-pcResult-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		exformPcResult: function(){
			if($('#ssxmEdit-pcResult-table').jqGrid('getRowData').length<=0){
				tools.info("暂无可导出项！");
				return ;
			}
			var ids = []
			if (this.allFlag == '0') {
				for (var i=0;i<this.selPcRulesRows.length;i++) {
					var row = $("#ssxmEdit-pcRules-table").jqGrid("getRowData", this.selPcRulesRows[i])
					ids.push(row.id)
				}
			}
			var params = {
				zid: this.params.id,
				uuid: this.uuid,
				allFlag: this.allFlag, //1-查询满足所有规则的结果企业，0-查询满足指定规则的结果企业，默认为0
				rules: ids.join(',')
			}
			tools.exform(params, '/sszj/export/jgqy/list')
		},
		sharePlan: function(){
			if (this.selGzRows.length<=0) {
				tools.info('请先选择要方案共享的规则！')
				return false;
			}
			$('.model').show();
			this.shareFaVisible = true
			components.shareFa.modelData = tools.clone(this.formData)
			components.shareFa.gxlx = '0'
			var ids = []
			for (var i=0;i<this.selGzRows.length;i++) {
				var row = $("#ssxmEdit-gzwh-table").jqGrid("getRowData", this.selGzRows[i])
				ids.push(row.id)
			}
			components.shareFa.rules = ids.join(',')
			components.shareFa.recordsHandler();
		},
		// 隐藏规则编辑器时触发
		hideGzbjq: function(){
			var self = this
			if (!this.isOnlyEditRules) {
				this.gzbjqVisible = false;
				components.gzbjq.hideModel();
				return;
			};
			var params = {
				uuid: this.uuid,
				id: this.ruleData.id,
				zid: this.params.id,
				expression: this.ruleData.expression.length > 0 ? JSON.stringify(this.ruleData.expression) : '',
				expressionCname: this.ruleData.expressionCname.length > 0 ? JSON.stringify(this.ruleData.expressionCname) : ''
			}
			ajax("POST","/sszj/sxgn/savePcRule",params).done(function(res){
				if(res.code=='0'){
					tools.info('修改成功!');
					self.isOnlyEditRules = false;
					$('.model').hide();
					self.gzbjqVisible = false;
					self.getPcRules();
					self.resetRuleData();
					components.gzbjq.hideModel();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		// 载入方案弹框
		showFaModel: function(){
			$('.model').show();
			$('.ssxmEdit .importFa-page-model').show();
			if (!this.isCreateTableImportFa) {
				this.createTableImportFa()
			} else {
				this.getImportFaList(1)
			}
		},
		hideFaModel: function(){
			$('.model').hide();
			$('.ssxmEdit .importFa-page-model').hide();
			this.importFaData = {
				famc: ''
			}
		},
		getImportFaList:function(pageNo){
			var params = {
				famc: this.importFaData.famc,
				pageNo: pageNo,
				pageSize: $(".ui-pg-selbox", $('.ssxmEdit .importFa-page-model')).val() || 20
			}
			$("#shareFaCx-table").jqGrid('clearGridData')
			ajax("POST","/sszj/xmgl/gxList",params).done(function(res){
				if(res.code=='0'){
					$("#ssxmEdit-importFa-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		fxqTypeChange: function(){
			if (this.ruleData.fxqType == '0') {
				this.ruleData.fxqRange = '1'
			} else if (this.ruleData.fxqType == '1') {
				this.ruleData.fxqRange = '3'
			} else if (this.ruleData.fxqType == '2') {
				this.ruleData.fxqRange = '12'
			}
		},
		fxqOffsetChange: function(){
			var t = this.ruleData.fxqOffset.charAt(0)
			this.ruleData.fxqOffset = this.ruleData.fxqOffset.replace(/[^\d]/g,'');
			if (t === '-') {
				this.ruleData.fxqOffset = '-' + this.ruleData.fxqOffset
			}
		}
	}
});