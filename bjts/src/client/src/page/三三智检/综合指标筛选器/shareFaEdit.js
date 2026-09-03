var shareFaEdit=require("./shareFaEdit.html");
var fxjsCommonFun = require('../../../config/fxjsCommonFun.js');
avalon.component('shareFaEdit', {
	template:shareFaEdit,
	defaults: {
		$id: 'shareFaEdit',
		params:{},
		act:1,
		tcode: "shareFaEditcx",
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
			ckgmStr: '',
			gxlx: ''
		},
		dataList: [],
		addTitle: '',
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
			expressionCname: []
		},
		selGzRows: [],
		gzwhData: {
			rulename: '',
			note: ''
		},
		previewGzExpression: '',
		onInit: function (e) {
      components.shareFaEdit = e.vmodel;
    },
		onReady:function(){
			this.initTree();
			this.getDictList();
			this.createTableGzwh();
		},
		// 获取项目信息详情
    getXmmx: function(){
      var self = this
      ajax("POST","/sszj/xmgl/famx",{id: this.params.id}).done(function(res){
        if(res.code=='0'){
          self.formData = tools.clone(res.data)
          self.modelData = tools.clone(res.data)
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    createTableGzwh:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "id",hidden:true },
				{ name: "expression", label: "英文表达式", index: "expression",hidden:true },
				{ name: "expressionCname", label: "中文表达式", index: "expressionCname",hidden:true },
				{ name: "rulename", label: "规则名称", index: "rulename",width: 140, align:"left",sortable: false },
				{ name: "yxbz", label: "启用标志", index: "yxbz",hidden:true },
				{ name: "yxbzName", label: "启用标志", index: "yxbzName",width: 60, align:"center",sortable: false,formatter: function(cellvalue, options, rowObject){
					var map = {'Y': '有效', 'N': '无效'}
					return map[rowObject.yxbz] || '';
				}},
				{ name: "syzt", label: "使用状态", index: "syzt",width: 60, align:"center",sortable: false },
				{ name: "expressionCnameTmp", label: "规则表达式", index: "expressionCnameTmp",width: 240, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
					if (rowObject.expressionCname) {
						return JSON.parse(rowObject.expressionCname).join('')
					} else {
						return ''
					}
				} },
				{ name: "showorder", label: "显示顺序", index: "showorder",width: 60, align:"left",sortable: false },
				{ name: "note", label: "业务描述", index: "note",width: 250, align:"left",sortable: false },
			];
			$("#shareFaEdit-gzwh-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#shareFaEdit-gzwh-tablePager',
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
					return $(".shareFaEdit").height() - 300;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#shareFaEdit-gzwh-table").jqGrid("getRowData", rowid)
					if ($(e.target).hasClass('disabled')) return false;
					if(e.target.nodeName=="TD"){
						self.previewGzExpression = JSON.parse(row.expressionCname).join('')
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
						return false;
					}else{
						return true;
					}
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"shareFaEdit-gzwh-table");
					self.getXmRules(pageNo);
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
		// 获取规则列表
		getXmRules: function(pageNo){
      var self = this
			var params = {
        pageNo: pageNo,
			  pageSize: $(".ui-pg-selbox", $('.shareFaEdit .pc')).val() || 20,
				gid: this.params.id,
				rulename: this.gzwhData.rulename,
				note: this.gzwhData.note
			}
			$("#shareFaEdit-gzwh-table").jqGrid('clearGridData')
      ajax("POST","/sszj/xmgl/getFaRules",params).done(function(res){
        if(res.code=='0'){
					$("#shareFaEdit-gzwh-table").resetSelection();
					$("#shareFaEdit-gzwh-table")[0].addJSONData(res.data);
          self.previewGzExpression = ''
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
		},
		showModel: function(title){
			this.addTitle = title
			$('.model').show();
			$('.shareFaEdit .add-page-model').show();
			this.modelData = tools.clone(this.formData)
      this.recordsHandler();
		},
		hideModel: function(){
			$('.model').hide();
			$('.shareFaEdit .add-page-model').hide();
		},
		initTree:function() {
			var self = this;
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				self.swjgList = data
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.shareFaEdit .select-sub').toggle();
			$('.shareFaEdit .select-wrapper .icon').toggleClass("active");
			if ($('.shareFaEdit .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.shareFaEdit .select-wrapper .icon').attr("title","收起");
			} else {
				$('.shareFaEdit .select-wrapper .icon').attr("title","展开")
			}
		},
		closeHyper:function(){
			$('.shareFaEdit .select-sub').hide();
			$('.shareFaEdit .select-wrapper .icon').removeClass('active');
			$('.shareFaEdit .select-wrapper .icon').attr("title","展开");
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.shareFaEdit').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.shareFaEdit').off('click');
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
					this.initSelectTree(item.zbxmbm, item.values)
				} else {
					this.initMultiselect(item)
				}
			}
		},
		// 多选下拉框
		initMultiselect: function(item){
			var self = this
			let id = '#shareFaEdit_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
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
			var domId = 'shareFaEdit_tree_'+zbxmbm.split('.')[0]+'_'+zbxmbm.split('.')[1]
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
		// 重置分组指标选中内容
		resetSelectMc: function(allSelectList){
			var obj = {}
			for (var i=0;i<allSelectList.length;i++) {
				let item = allSelectList[i].zbxmbm
				obj[item] = { name: '', value: []}
			}
			this.selectMc = obj
		},
		recordsHandler: function(){
			for(var i=0;i<this.dictList.length;i++) {
				let item = this.dictList[i]
				var key = item.zbxmbm.split('.')[1]
				this.selectMc[item.zbxmbm].name = this.modelData[key+'Str']
				var values = this.modelData[key] && this.modelData[key].split(',') || []
				this.selectMc[item.zbxmbm].value = values
				if (item.isTree == '1') { // 下拉树形多选
					let domId = 'shareFaEdit_tree_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
					var treeObj = $.fn.zTree.getZTreeObj(domId);
					for (var j=0;j<values.length;j++) {
						let node = treeObj.getNodesByParam("code", values[j], null)[0];
						treeObj.checkNode(node, true, true);
					}
					if (this.addTitle == '查看') {
						var nodes = treeObj.transformToArray(treeObj.getNodes());
						for (var k=0, l=nodes.length; k < l; k++) {
							treeObj.setChkDisabled(nodes[k], true);
						}
					}
				} else { // 下拉多选
					let domId = '#shareFaEdit_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
					let options = []
					for(var j=0;j<item.values.length;j++) {
						let tmp = item.values[j]
						let selected = values.indexOf(tmp.code) > -1
						let disabled = this.addTitle == '查看'
						options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: selected, disabled: disabled})
					}
					$(domId).multiselect('dataprovider', options);
				}
			}
		},
		// 数据处理
		dataHandler: function(){
			var arr = ['djzclx','hy']
      var multiselectArr = ['nsrzt','ckgm','flglcd']
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
		saveFa: function(){
			var self = this
			var rules = [
        { name: 'famc',  message: '方案名称不能为空！'},
        { name: 'gxlx',  message: '共享类型不能为空！'},
        { name: 'tsjsfsDm',  message: '退税计算方式不能为空！'},
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return false;
        }
      }
      this.dataHandler()
			var ids = []
			for (var i=0;i<this.selGzRows.length;i++) {
				var row = $("#shareFaEdit-gzwh-table").jqGrid("getRowData", this.selGzRows[i])
				ids.push(row.id)
			}
			var params = {
				gid: this.modelData.id,
				famc: this.modelData.famc, 	
				note: this.modelData.note, 	
				tsjsfsDm: this.modelData.tsjsfsDm, 	
				flglcd: this.modelData.flglcd, 	
				flglcdStr: this.modelData.flglcdStr, 	
				djzclx: this.modelData.djzclx, 	
				djzclxStr: this.modelData.djzclxStr, 	
				hy: this.modelData.hy, 	
				hyStr: this.modelData.hyStr, 	
				nsrzt: this.modelData.nsrzt, 	
				nsrztStr: this.modelData.nsrztStr, 	
				ckgm: this.modelData.ckgm, 	
				ckgmStr: this.modelData.ckgmStr, 	
				gxlx: this.modelData.gxlx, 
			}
      ajax("POST","/sszj/xmgl/upload",params).done(function(res){
        if(res.code=='0'){
          tools.info('操作成功！');
          self.hideModel();
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
		},
	}
});