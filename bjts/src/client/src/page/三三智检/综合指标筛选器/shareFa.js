var shareFa=require("./shareFa.html");
var fxjsCommonFun = require('../../../config/fxjsCommonFun.js');
avalon.component('shareFa', {
	template:shareFa,
	defaults: {
    dictList: [],
    selectMc: {},
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
    gxlx: '0',
    rules: '',
    onInit: function (e) {
      components.shareFa = e.vmodel;
    },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.shareFa').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.shareFa').off('click');
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
			let id = '#shareFa_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
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
			var domId = 'shareFa_tree_'+zbxmbm.split('.')[0]+'_'+zbxmbm.split('.')[1]
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
		recordsHandler: function(){
			for(var i=0;i<this.dictList.length;i++) {
				let item = this.dictList[i]
				var key = item.zbxmbm.split('.')[1]
				this.selectMc[item.zbxmbm].name = this.modelData[key+'Str']
				var values = this.modelData[key] && this.modelData[key].split(',') || []
				this.selectMc[item.zbxmbm].value = values
				if (item.isTree == '1') { // 下拉树形多选
					let domId = 'shareFa_tree_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
					var treeObj = $.fn.zTree.getZTreeObj(domId);
					for (var j=0;j<values.length;j++) {
						let node = treeObj.getNodesByParam("code", values[j], null)[0];
						treeObj.checkNode(node, true, true);
					}
				} else { // 下拉多选
					let domId = '#shareFa_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
					let options = []
					for(var j=0;j<item.values.length;j++) {
						let tmp = item.values[j]
						let selected = values.indexOf(tmp.code) > -1
						options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: selected})
					}
					$(domId).multiselect('dataprovider', options);
				}
			}
		},
    hideModel:function(){
      $('.model').hide()
      components.ssxmEdit.shareFaVisible = false
    },
    // 数据处理
		dataHandler: function(){
			var arr = ['djzclx','hy']
      var multiselectArr = ['nsrzt','ckgm','flglcd']
      console.log(this.selectMc)
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
      console.log(111111)
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
        { name: 'xmmc',  message: '方案名称不能为空！'},
        { name: 'tsjsfsDm',  message: '退税计算方式不能为空！'},
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return false;
        }
      }
			if (this.gxlx == '') {
				tools.info('共享类型不能为空！');
				return false;
			}
      this.dataHandler()
			var params = {
				famc: this.modelData.xmmc, 	
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
				rules: this.rules, 	
				gxlx: this.gxlx, 
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
})