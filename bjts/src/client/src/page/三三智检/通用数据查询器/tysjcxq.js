var tysjcxq=require("./tysjcxq.html");
avalon.component('tysjcxq', {
	template:tysjcxq,
	defaults: {
		params: {},
		dataList: [
			// { lb: '(', dfId: 'id', cRelation: '=', cRelationMc:'=',  cTargetval: '123', rb: '', cLogic: 'AND' },
			// { lb: '', dfId: 'id', cRelation: '=', cRelationMc:'=',  cTargetval: '123', rb: ')', cLogic: '' },
		],
		cTargetval: '',
		cTargetval2: '',
		activeBz: '',
		activeLineIndex: '-1',
		dtsId: '',
		dtsList: [], // 数据源列表
		condList: ['id','pid'],
		defaultOutList: [],
		outList: [], // 所有动态表头列表
		selectOutList: [], // 选中的动态表头列表
		cRelationList: [
			{ value: '1', label: '包含' },
			{ value: '2', label: '左匹配' },
			{ value: '3', label: '右匹配' },
			{ value: '4', label: '在列表' },
			{ value: '5', label: '不在列表' },
			{ value: '6', label: '区间' },
			{ value: '7', label: '>' },
			{ value: '8', label: '>=' },
			{ value: '9', label: '=' },
			{ value: '10', label: '<' },
			{ value: '11', label: '<=' }
		],
		cLogicList: ['AND','OR'],
		top: '',
		left: '',
		condObj: {},
		savePlanData: {
			qpUuid: '',
			qpName: '',
			ywms: ''
		},
		planObj: {},
		orderSql: '',
		searchDataPlan: {
			orderSql: ''
		},
		searchDataFilter: {
			orderSql: ''
		},
		defaultSearchData: {},
		moveIndex: -1,
		transferAllChecked: false,
		transferSelectChecked: false,
		scxMc: '',
		pageNo: 1,
		addOrEdit: '',
		dictValue: '',
		targetIndex: '1',
		onReady: function(){
			this.initData();
			this.initDate();
		},
		initData: function(){
			this.getDtsList();
			this.createTablePlanList();
			this.createTableFilter();
		},
		getDtsList: function(){
			var self = this
			api.getDtsList().done(function(res){
				if(res.code=='0'){
          self.dtsList = res.data
					self.dtsId = self.dtsList[0].dtsId
					if(self.params.dtsId){ // 兼容“风险健康总览”页面跳转，指定数据源查询
						self.dtsId = self.params.dtsId;
					}
					self.getDtsPz();
        }
      })
		},
		getDtsPz: function(){
			var self = this
  		var deferred = $.Deferred();
			api.getDtsPz({dtsId: this.dtsId}).done(function(res){
				if(res.code=='0'){
					self.outList = []
					self.selectOutList = []
					self.scxMc = ''
					self.dataList = []
          self.defaultOutList = tools.clone(res.data.outList)
					for (var i=0;i<self.defaultOutList.length;i++) {
						var item = tools.clone(self.defaultOutList[i])
						item.checked = false
						self.outList.push(item)
					}
          self.condList = res.data.condList
    			deferred.resolve(res);
        }
      })
			return deferred.promise()
		},
		createTable:function(){
			var self=this;
			var columns = []
			for (var i=0;i<self.selectOutList.length;i++) {
				var item = self.selectOutList[i]
				var obj = {
					name: item.fieldname,
					label: item.dfName,
					index: item.fieldname,
					width: item.showlength * 15,
					align: item.align == '2' ? 'right' : (item.align == '3' ? 'center' : 'left'),
					sortable: item.allowOrder == '1' }
				columns.push(obj)
			}
			$("#tysjcxq-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#tysjcxq-tablePager',
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
					return $(".tysjcxq .table").height() - 70;
				})(),
				beforeSelectRow:function(rowid,e){
					// var row = $("#tysjcxq-table").jqGrid("getRowData", rowid)
					if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
            return false;
					}else{
            return true;
					}
				},
				onSortCol: function (index, iCol, sortorder) {
					self.orderSql = index + ' ' + sortorder;
					self.search(1,1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"tysjcxq-table");
					self.search(pageNo);
				}
			});
		},
		createTablePlanList:function(columns){
			var self=this;
			var columns = [
				{ name: "qpUuid", label: "ID标识", index: "qpUuid",hidden: true },
				{ name: "qpName", label: "方案名称", index: "qpName",width: 100, align:"left",sortable: false},
				{ name: "ywms", label: "业务描述", index: "ywms",width: 160, align:"left",sortable: false },
				{ name: "uptime", label: "修改时间", index: "uptime",width: 130, align:"left",sortable: true },
				{ name: "ownerMc", label: "所属用户", index: "ownerMc",width: 80, align:"left",sortable: true },
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 150, align:"left",sortable: true },
				{ name: "op", label: "操作", width: 60, align: "center", resizable: false, search: false, sortable: false,formatter: function(cellvalue, options, rowObject){
					return "<div class='btn op-use' style='float: none;display: inline-block;' title='载入'>载入</div>";
				}}
			]
			$("#tysjcxq-planlist-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#tysjcxq-planlist-tablePager',
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
					return 250;
				})(),
				beforeSelectRow:function(rowid,e){
					if($(e.target).hasClass('disabled')) return;
					var row = $("#tysjcxq-planlist-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('op-use')){
						self.getPlanDetail(row.qpUuid)
					} else if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
            return false;
					}else{
            return true;
					}
				},
				onSortCol: function (index, iCol, sortorder) {
					self.searchDataPlan.orderSql = index + ' ' + sortorder;
					self.getPlanList(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"tysjcxq-planlist-table");
					self.getPlanList(pageNo);
				}
			});
		},
		getActiveLineIndex: function(index){
			this.activeLineIndex = index
			var dfId = this.dataList[index].dfId
			for (var i=0;i<this.condList.length;i++) {
				if (this.condList[i].dfId == dfId) {
					this.condObj = this.condList[i]
					break;
				}
			}
		},
		showDropdown: function(activeBz,e,index){
			var self = this
			this.getActiveLineIndex(index)
			this.activeBz = activeBz
			// var obj = this.dataList[this.activeLineIndex]
			// if (obj.cRelation == '6') {
			// 	this.cTargetval = obj.cTargetval.split('|')[0] || ''
			// 	this.cTargetval2 = obj.cTargetval.split('|')[1] || ''
			// } else {
			// 	this.cTargetval = obj.cTargetval || ''
			// 	this.cTargetval2 = ''
			// }
			this.cTargetval = ''
			this.cTargetval2 = ''
			this.dictValue = ''
			if (activeBz == 'cTargetval' && this.condObj.dictEntry == '1') {
				this.getDfDict(1)
				this.targetIndex = '1'
			}
			var el = e.currentTarget
			this.top = $(el).offset().top - 150 + 'px'
			this.left = $(el).offset().left - 40 + 'px'

			$('.tysjcxq').on('click',function(e){
				var e=e||window.event;
				if($('.hasDropdown').find($(e.target)).length<=0){
					self.hideDropdown();
				}
			})
		},
		hideDropdown: function(){
			this.activeBz = ''
			$('.tysjcxq').off('click');
		},
		changeDfid: function(item){
			this.dataList[this.activeLineIndex].dfId = item.dfId
			this.dataList[this.activeLineIndex].dfName = item.dfName
			this.condObj = tools.clone(item)

			var cRelation = this.dataList[this.activeLineIndex].cRelation
			var cRelationMc = this.dataList[this.activeLineIndex].cRelationMc
			if (item.datatype == '1') {
				if (['1','2','3','4','5'].indexOf(cRelation) == -1) {
					cRelation = '1'
					cRelationMc = '包含'
				}
			} else {
				if (['6','7','8','9','10','11'].indexOf(cRelation) == -1) {
					cRelation = '6'
					cRelationMc = '区间'
				}
			}
			this.dataList[this.activeLineIndex].cRelation = cRelation
			this.dataList[this.activeLineIndex].cRelationMc = cRelationMc
			this.hideDropdown()
		},
		initDate: function(){
			var optionsD = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
			var optionM = { language:'zh-CN', format: 'yyyy-mm', weekStart: 1, todayBtn: 1, autoclose: 1, todayHighlight: 1, startView: 3, minView: 3,forceParse: 0 };
			var optionsMM = { language:'zh-CN', format: 'yyyymm', weekStart: 1, todayBtn: 1, autoclose: 1, todayHighlight: 1, startView: 3, minView: 3,forceParse: 0 };
			var optionsY = { language: "zh-CN", format: 'yyyy', clearBtn: true, autoclose: true, startView: 4, minView: 4,};
			$('.tysjcxq .datepicker.date-day').datetimepicker(optionsD);
			$('.tysjcxq .datepicker.date-month').datetimepicker(optionM);
			$('.tysjcxq .datepicker.date-mm').datetimepicker(optionsMM);
			$('.tysjcxq .datepicker.date-year').datetimepicker(optionsY);
		},
		changeCrelation: function(item){
			this.dataList[this.activeLineIndex].cRelation = item.value
			this.dataList[this.activeLineIndex].cRelationMc = item.label
			this.hideDropdown()
		},
		changecLogic: function(item){
			this.dataList[this.activeLineIndex].cLogic = item
			this.hideDropdown()
		},
		getcTargetval: function(){
			this.dataList[this.activeLineIndex].cTargetval = this.cTargetval
			if (this.dataList[this.activeLineIndex].cRelation=='6' && this.cTargetval2) { // 区间
				this.dataList[this.activeLineIndex].cTargetval += '|'+this.cTargetval2
			}
			this.hideDropdown()
		},
		addRow: function(){
			if (this.dataList.length == 0) {
				this.condObj = this.condList[0]
			} else {
				var lastItem = this.dataList[this.dataList.length-1]
				for(var i=0;i<this.condList.length;i++) {
					if(lastItem.dfId == this.condList[i].dfId) {
						this.condObj = this.condList[i+1] || this.condList[i]
					}
				}
				lastItem.cLogic = 'AND'
			}
			var cRelation = ''
			var cRelationMc = ''
			if (this.condObj.datatype == '1') {
				cRelation = '1'
				cRelationMc = '包含'
			} else {
				cRelation = '6'
				cRelationMc = '区间'
			}
			this.dataList.push({ lb: '', dfId: this.condObj.dfId, dfName: this.condObj.dfName, cRelation: cRelation, cRelationMc: cRelationMc,  cTargetval: '', rb: '', cLogic: '', checked: true })
		},
		delRow: function(){
			if (this.dataList.length == 0) return;
			this.dataList.splice(this.activeLineIndex,1)
			if (this.dataList.length>0) {
				this.dataList[this.dataList.length-1].cLogic = ''
			}
			if (this.activeLineIndex > 0) {
				this.activeLineIndex--
			}
			if (this.dataList.length == 0) {
				this.activeLineIndex = -1
			}
		},
		// 插入括号
		insertBracket: function(pos){
			var item = this.dataList[this.activeLineIndex]
			if (pos == 'left') {
				item.lb = item.lb+'('
			} else {
				item.rb = item.rb+')'
			}
		},
		// 删除括号
		delBracket: function(pos){
			var item = this.dataList[this.activeLineIndex]
			if (pos == 'left') {
				item.lb = item.lb.substring(1)
			} else {
				item.rb = item.rb.substring(1)
			}
		},
		// 条件上/下移
		toMove: function(dir){
			if (this.activeLineIndex == -1) return;
			var moveData = tools.clone(this.dataList)
			if (dir == 'up') {
				if (this.activeLineIndex != 0) {
					moveData[this.activeLineIndex] = moveData.splice(this.activeLineIndex - 1, 1, moveData[this.activeLineIndex])[0]
					this.activeLineIndex --
				} else {
					moveData.push(moveData.shift());
					this.activeLineIndex = moveData.length-1
				}
			} else {
				if (this.activeLineIndex != moveData.length - 1) {
					moveData[this.activeLineIndex] = moveData.splice(this.activeLineIndex + 1, 1, moveData[this.activeLineIndex])[0];
					this.activeLineIndex ++
				} else {
					moveData.unshift(moveData.splice(this.activeLineIndex, 1)[0]);
					this.activeLineIndex = 0
				}
			}
			for (var i=0;i<moveData.length;i++) {
				if (i<moveData.length-1) {
					if (moveData[i].cLogic == '') {
						moveData[i].cLogic = 'AND'
					}
				} else {
					moveData[i].cLogic = ''
				}
			}
			this.dataList = moveData
		},
		dataHandler: function(isSave){
			var checkList = []
			if (isSave) {
				checkList = tools.clone(this.dataList)
			} else {
				for (var i=0;i<this.dataList.length;i++) {
					if (this.dataList[i].checked) checkList.push(this.dataList[i])
				}
			}
			if (checkList.length == 0 && isSave) {
				tools.info('请先添加条件！');
				return false;
			}
			var condMx = []
			for (var i=0;i<checkList.length;i++) {
				var item = checkList[i]
				if (item.cTargetval=='') {
					tools.info('缺失表达式');
					return false;
				}
				var obj = {
					ch: i+1,
					lb: item.lb,
					dfId: item.dfId,
					cRelation: item.cRelation,
					cTargetval: item.cTargetval,
					cLogic: i == checkList.length - 1 ? '' : item.cLogic,
					rb: item.rb
				}
				condMx.push(obj)
			}
			var dfPzMx = []
			for (var k=0;k<this.selectOutList.length;k++) {
				dfPzMx.push({th: k+1, dfId: this.selectOutList[k].dfId})
			}
			return {
				condMx: condMx,
				dfPzMx: dfPzMx
			}
		},
		toSearch: function(){
			this.orderSql = ''
			$("#tysjcxq-table").GridUnload();
			this.createTable()
			this.search(1)
		},
		// 执行查询
		search: function(pageNo,flushFlag){
			var self = this
			var data = this.dataHandler()
			this.pageNo = pageNo
			var params= {
				dtsId: this.dtsId,
				flushFlag: this.orderSql ? '1' : (flushFlag || ''),
				condMx: data.condMx,
				dfPzMx: data.dfPzMx,
				orderSql: this.orderSql,
				pageSize: $(".ui-pg-selbox", $('.tysjcxq .table')).val() || 20,
				pageNo: pageNo
			}
			this.defaultSearchData = tools.clone(params)
			$("#tysjcxq-table").jqGrid('clearGridData')
			api.queryExecute(params).done(function(res){
				if(res.code=='0'){
					if (res.data.dataStatus == '1') {
						tools.confirm(res.data.tips,'立即查看',function(){
							$("#tysjcxq-table")[0].addJSONData(res.data.pageInfo);
						},function(){
							self.search(1,'1')
						})
					} else if (res.data.dataStatus == '2') {
						tools.info(res.data.tips)
						$("#tysjcxq-table")[0].addJSONData(res.data.pageInfo);
					} else {
						$("#tysjcxq-table")[0].addJSONData(res.data.pageInfo);
					}
        }
      })
		},
		savePlan: function(){
			var self = this
			if (this.savePlanData.qpName == '') {
				tools.info('请输入方案名称！');
				return;
			}
			var data = this.dataHandler(true)
			var params = {
				qpUuid: this.savePlanData.qpUuid,
				qpName: this.savePlanData.qpName,
				ywms: this.savePlanData.ywms,
				dtsId: this.dtsId,
				condMx: data.condMx,
				dfPzMx: data.dfPzMx,
			}
			api.cxqSavePlan(params).done(function(res){
				if(res.code=='0'){
					tools.info('保存成功！');
					self.hideModelSavePlan()
					if (self.addOrEdit == 'edit') {
						self.planObj = {
							qpUuid: res.data.qpUuid,
							qpName: self.savePlanData.qpName,
							ywms: self.savePlanData.ywms
						}

					}
        }
      })
		},
		showModelSavePlan: function(addOrEdit){
			this.addOrEdit = addOrEdit
			var res = this.dataHandler(true)
			if (!res) return;
 			$('.model').show();
			$('.tysjcxq .savePlan-page-model').show();
			var dtsName = ''
			for (var i=0;i<this.dtsList.length;i++) {
				if (this.dtsId == this.dtsList[i].dtsId) {
					dtsName = this.dtsList[i].dtsName
				}
			}
			if (addOrEdit=='add') {
				this.savePlanData = {
					qpUuid: '',
					qpName: '',
					ywms: '数据源：' + dtsName
				}
			} else {
				this.savePlanData = {
					qpUuid: this.planObj.qpUuid || '',
					qpName: this.planObj.qpName || '',
					ywms: this.planObj.ywms || '数据源：' + dtsName
				}
			}
		},
		hideModelSavePlan: function(){
			$('.model').hide();
			$('.tysjcxq .savePlan-page-model').hide();
		},
		showModelPlanList: function(){
			$('.model').show();
			$('.tysjcxq .planlist-page-model').show();
			this.getPlanList(1);
		},
		hideModelPlanList: function(){
			$('.model').hide();
			$('.tysjcxq .planlist-page-model').hide();
		},
		getPlanList: function(pageNo){
			var params = {
				type: '0',
				orderSql: this.searchDataPlan.orderSql,
				pageSize: $(".ui-pg-selbox", $('.tysjcxq .planlist-page-model')).val() || 20,
				pageNo: pageNo
			}
			$("#tysjcxq-planlist-table").jqGrid('clearGridData')
			api.getPlanList(params).done(function(res){
				if(res.code=='0'){
					$("#tysjcxq-planlist-table")[0].addJSONData(res.data);
        }
      })
		},
		getPlanDetail: function(qpUuid){
			var self = this
			var params = {
				qpUuid: qpUuid
			}
			api.getPlanDetail(params).done(function(res){
				if(res.code=='0'){
					self.hideModelPlanList()
					var data = res.data
					self.planObj = tools.clone(res.data)
					self.dtsId = data.dtsId
					self.getDtsPz().done(function(){
						self.selectOutList = []
						for(var j=0;j<data.dfPzMx.length;j++) {
							for (var i=0;i<self.outList.length;i++) {
								if (self.outList[i].dfId == data.dfPzMx[j].dfId) {
									self.selectOutList.push(self.outList[i])
									self.outList.splice(i,1)
									break;
								}
							}
						}
						var len = self.selectOutList.length
						self.scxMc = len==0 ? '':'已选'+len+'项'
						self.resetCondMx(data.condMx)
					});
        }
      })
		},
		resetCondMx: function(condMx){
			this.dataList = []
			for (var i=0;i<condMx.length;i++) {
				var item = condMx[i]
				var dfName = ''
				for(var k=0;k<this.condList.length;k++) {
					if (this.condList[k].dfId == item.dfId) {
						dfName = this.condList[k].dfName
						break;
					}
				}
				var cRelationMc = ''
				for (var j=0;j<this.cRelationList.length;j++) {
					if (this.cRelationList[j].value == item.cRelation) {
						cRelationMc = this.cRelationList[j].label
						break;
					}
				}
				this.dataList.push({
					lb: item.lb || '',
					dfId: item.dfId || '',
					dfName: dfName,
					cRelation: item.cRelation || '',
					cRelationMc: cRelationMc,
					cTargetval:item.cTargetval || '',
					rb: item.rb || '',
					cLogic: item.cLogic || '',
					checked: true
				})
			}
			this.condObj = condMx[i]
			this.activeLineIndex = 0
		},
		exform: function(){
			var self = this
			if($('#tysjcxq-table').jqGrid('getRowData').length<=0){
				tools.info("请先查询列表");
				return ;
			}
			api.exportCheckPer({}).done(function(res){
				if(res.code=='0'){
					tools.exform(self.defaultSearchData,'/sszj/export/queryExport')
        }
      })
		},
		showModelScx: function(){
			$('.model').show();
			$('.tysjcxq .scx-page-model').show();
		},
		hideModelScx: function(){
			$('.model').hide();
			$('.tysjcxq .scx-page-model').hide();
			var len = this.selectOutList.length
			this.scxMc = len==0 ? '':'已选'+len+'项'
		},
		toLeft: function(){
			this.moveIndex = -1
			var checkList = []
			for (var i=0;i<this.selectOutList.length;i++) {
				if (this.selectOutList[i].checked) {
					this.selectOutList[i].checked = false
					checkList.push(this.selectOutList[i])
					this.selectOutList.splice(i,1)
					i--
				}
			}
			this.outList = this.outList.concat(checkList)
			var arr = []
			for (var j=0;j<this.defaultOutList.length;j++) {
				for (var k=0;k<this.outList.length;k++) {
					if (this.defaultOutList[j].dfId == this.outList[k].dfId) {
						arr.push(this.outList[k])	
						break;
					}
				}
			}
			this.outList = arr
			this.transferSelectChecked = false
		},
		toRight: function(){
			this.moveIndex = -1
			var checkList = []
			for (var i=0;i<this.outList.length;i++) {
				if (this.outList[i].checked) {
					this.outList[i].checked = false
					checkList.push(this.outList[i])
					this.outList.splice(i,1)
					i--
				}
			}
			this.selectOutList = this.selectOutList.concat(checkList)
			this.transferAllChecked = false
		},
		// 上移
		toUp: function(){
			if (this.moveIndex == -1) return;
			var moveData = tools.clone(this.selectOutList)
			if (this.moveIndex != 0) {
				moveData[this.moveIndex] = moveData.splice(this.moveIndex - 1, 1, moveData[this.moveIndex])[0]
				this.moveIndex --
			} else {
				moveData.push(moveData.shift());
				this.moveIndex = moveData.length-1
			}
			this.selectOutList = moveData
		},
		// 下移
		toDown: function(){
			if (this.moveIndex == -1) return;
			var moveData = tools.clone(this.selectOutList)
			if (this.moveIndex != moveData.length - 1) {
				moveData[this.moveIndex] = moveData.splice(this.moveIndex + 1, 1, moveData[this.moveIndex])[0];
				this.moveIndex ++
			} else {
				moveData.unshift(moveData.splice(this.moveIndex, 1)[0]);
				this.moveIndex = 0
			}
			this.selectOutList = moveData
		},
		allChanged: function(){
			for (var i=0;i<this.outList.length;i++) {
				this.outList[i].checked = this.transferAllChecked
			}
		},
		selectAllChanged: function(){
			for (var i=0;i<this.selectOutList.length;i++) {
				this.selectOutList[i].checked = this.transferSelectChecked
			}
		},
		transferChangeAll: function(){
			var isAllChecked = true
			for (var i=0;i<this.outList.length;i++) {
				if (!this.outList[i].checked) {
					isAllChecked = false
				}
			}
			this.transferAllChecked = isAllChecked
		},
		transferChangeSelect: function(){
			var isAllChecked = true
			for (var i=0;i<this.selectOutList.length;i++) {
				if (!this.selectOutList[i].checked) {
					isAllChecked = false
				}
			}
			this.transferSelectChecked = isAllChecked
		},
		showSelect:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.tysjcxq').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideSelect();
				}
			})
		},
		hideSelect:function(){
			$(".treeDiv").hide();
			$('.tysjcxq').off('click');
		},
		showMenu:function(e){
			var self=this;
			$(".dropdown-menu",e.target).show();
			$('.tysjcxq').on('click',function(e){
				var e=e||window.event;
				if($('.dropdown-menu').find($(e.target)).length<=0){
					self.hideMenu();
				}
			})
		},
		hideMenu:function(){
			$(".dropdown-menu").hide();
			$('.tysjcxq').off('click');
		},
		showHyper:function(){
			$('.tysjcxq .expressArea .icon').toggleClass("active");
			if ($('.tysjcxq .expressArea .icon').attr("title").slice(0,2) === "展开") {
				$('.tysjcxq .expressArea .icon').attr("title","收起");
				$('.tysjcxq .expressArea-box').css('height', '140px');
				$(".tysjcxq .table").css('height', 'calc(100% - 200px)')
				$('#tysjcxq-table').setGridHeight($(".tysjcxq .table").height() - 70)
			} else {
				$('.tysjcxq .expressArea .icon').attr("title","展开")
				$('.tysjcxq .expressArea-box').css('height', '30px');
				$(".tysjcxq .table").css('height', 'calc(100% - 90px)')
				$('#tysjcxq-table').setGridHeight($(".tysjcxq .table").height() - 70)
			}
		},
		//copy bg
		createTableFilter:function(){
			var self=this;
			var columns = [
				{ name: "dictDm", label: "代码", index: "dictDm",width: 100, align:"left",sortable: true },
				{ name: "dictMc", label: "名称", index: "dictMc",width: 220, align:"left",sortable: true },
			];
			$("#tysjcxq-filter-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#tysjcxq-filter-tablePager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
  			rowList: [20, 50, 100],
				width:"100%",
				height:160,
				ondblClickRow: function(rowid,iRow,iCol,e){
					var row = $("#tysjcxq-filter-table").jqGrid("getRowData", rowid);
					console.log(row)
					if (self.targetIndex == '1') {
						self.cTargetval = self.cTargetval != '' ? self.cTargetval+'|'+row.dictDm : row.dictDm
					} else {
						self.cTargetval2 = self.cTargetval2 != '' ? self.cTargetval2+'|'+row.dictDm : row.dictDm
					}
				},
				onSortCol: function (index, iCol, sortorder) {
					self.searchDataFilter.orderSql = index + ' ' + sortorder;
					self.getDfDict(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"tysjcxq-filter-table");
					self.getDfDict(pageNo);
				}
			});
		},
		getDfDict: function(pageNo){
			var params = {
				dfId: this.condObj.dfId,
				dictValue: this.dictValue,
				orderSql: this.searchDataFilter.orderSql,
				pageSize: $(".ui-pg-selbox", $('.tysjcxq .filter')).val() || 20,
				pageNo: pageNo
			}
			$("#tysjcxq-filter-table").jqGrid('clearGridData')
			api.getDfDict(params).done(function(res){
				if(res.code=='0'){
					$("#tysjcxq-filter-table")[0].addJSONData(res.data);
        }
      })
		}
  }
})