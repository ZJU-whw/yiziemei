var zbpzmx=require("./zbpzmx.html");
avalon.component('zbpzmx', {
	template:zbpzmx,
	defaults: {
		params:{
			zbId: '',
			zbCname: '',
			datatype: '',
			ywms: '',
			zbFomula: ''
		},
		act:1,
		tcode: "zbpzmx",
		searchYcffData:{
      zbId:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		searchCsData:{
      zbId:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelYcffData: {
			xh: '',
			ycpdtj: '',
			lwgz: '',
			badpoint: '',
			score: '',
			note: '',
			yxbz: 'Y',
			operation: ''
    },
		modelCsData: {
			csbm: '',
			csmc: '',
			datatype: '',
			valDef: '',
			note: '',
			yxbz: 'Y',
			operation: '',
			cstype: ''
		},
    addTitle:"新增",
		isAdmin: false,
		dataTypeMap: {'1': '字符型', '2': '数值型', '3': '日期型', '4': '逻辑性'},
		onReady:function(){
			this.isAdmin = ['super','admin'].indexOf(avalonRoot.user.roleDm) > -1
			this.searchYcffData.zbId = this.params.zbId
			this.searchCsData.zbId = this.params.zbId
			this.createTableYcff();
      this.createTableCs();
			var el1 = $('.zbpzmx .more1')[0];
			var el2 = $('.zbpzmx .more2')[0];
			this.setEllipsis(el1);
			this.setEllipsis(el2);
		},
		//copy bg
		createTableYcff:function(){
			var self=this;
			var columns = [
				{ name: "zbId", label: "指标标识", index: "zbId", hidden: true },
				{ name: "xh", label: "序号", index: "xh", hidden: true },
				{ name: "ycpdtj", label: "异常判定条件", index: "ycpdtj",width: 270, align:"left",sortable: true },
				{ name: "lwgz", label: "例外规则", index: "lwgz",width: 80, align:"left",sortable: true },
				{ name: "badpoint", label: "坏点标志", index: "badpoint",hidden: true },
				{ name: "badpointName", label: "坏点标志", index: "badpointName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[rowObject.badpoint];
				} },
				{ name: "score", label: "健康码赋分", index: "score",width: 80, align:"right",sortable: true },
				{ name: "note", label: "异常描述", index: "note",width: 270, align:"left",sortable: true },
				{ name: "yxbz", label: "有效标志", index: "yxbz",hidden: true },
				{ name: "yxbzName", label: "有效标志", index: "yxbzName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var yxbzMap = { 'Y': '有效', 'N': '无效'};
					return yxbzMap[rowObject.yxbz];
				} },
				{ name: "op", label: "操作", index: "op",width: 116, formatter: function(cellvalue, options, rowObject){
					var op = "<div style='text-align:center;'><div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div>";
					op += "<div class='btn del' style='float: none;display: inline-block;' title='删除'>删除</div>";
					op +="</div>";
					return op;
				} },
			];
			if (!self.isAdmin) {
				columns.splice(-1,1)
			}
			$("#zbpzmx-ycff-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#zbpzmx-ycff-tablePager',
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
					return ($(".zbpzmx .form").height() - $(".zbpzmx .msg").height() - 189) / 2;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#zbpzmx-ycff-table").jqGrid("getRowData", rowid)
          if($(e.target).hasClass('edit')){
						for (var key in self.modelYcffData) {
							self.modelYcffData[key] = row[key]
						}
						self.showModelYcff('2');
						return false;
					}else if($(e.target).hasClass('del')){
						tools.confirm('是否确定删除该条数据？', '确定', function(){
              var params = {
                zbId: row.zbId,
                xh: row.xh
              }
							ajax("POST","/sszj/zbgl/zb/ycff/del",params).done(function(res){
								if(res.code=='0'){
									self.searchYcff(1);
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
					self.searchYcffData.orderSql = index + ' ' + sortorder;
					self.searchYcff(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"zbpzmx-ycff-table");
					self.searchYcff(pageNo);
				}
			});
			this.searchYcffData.pageSize = $(".ui-pg-selbox", $('.zbpzmx')).val();
			self.searchYcff(1);
		},
    createTableCs:function(){
			var self=this;
			var columns = [
				{ name: "zbId", label: "指标标识", index: "zbId", hidden: true },
				{ name: "csbm", label: "参数编码", index: "csbm",width: 230, align:"left",sortable: true },
				{ name: "csmc", label: "参数名称", index: "csmc",width: 200, align:"left",sortable: true },
				{ name: "datatype", label: "数据类型", index: "datatype",hidden: true },
				// { name: "datatypeName", label: "数据类型", index: "datatypeName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
				// 	var map = {'1': '字符型', '2': '数值型', '3': '日期型', '4': '逻辑性'};
				// 	return map[rowObject.datatype] || '';
				// } },
				{ name: "cstype", label: "参数类型", index: "cstype",width: 80, align:"center",sortable: true },
				{ name: "valDef", label: "参数值", index: "valDef",width: 80, align:"center",sortable: true },
				{ name: "note", label: "说明", index: "note",width: 230, align:"left",sortable: true },
				{ name: "yxbz", label: "有效标志", index: "yxbz",hidden: true },
				{ name: "yxbzName", label: "有效标志", index: "yxbzName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var yxbzMap = { 'Y': '有效', 'N': '无效'};
					return yxbzMap[rowObject.yxbz] || '';
				} },
				{ name: "op", label: "操作", index: "op",width: 116, formatter: function(cellvalue, options, rowObject){
					var op = "<div style='text-align:center;'><div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div>";
					op += "<div class='btn del' style='float: none;display: inline-block;' title='删除'>删除</div>";
					op +="</div>";
					return op;
				} },
			];
			if (!self.isAdmin) {
				columns.splice(-1,1)
			}
			$("#zbpzmx-cs-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#zbpzmx-cs-tablePager',
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
					return ($(".zbpzmx .form").height() - $(".zbpzmx .msg").height() - 189) / 2;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#zbpzmx-cs-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('edit')){
						for (var key in self.modelCsData) {
							self.modelCsData[key] = row[key]
						}
						self.showModelCs('2');
						return false;
					}else if($(e.target).hasClass('del')){
						tools.confirm('是否确定删除该条数据？', '确定', function(){
              var params = {
                zbId: row.zbId,
                csbm: row.csbm
              }
							ajax("POST","/sszj/zbgl/zb/cs/del",params).done(function(res){
								if(res.code=='0'){
									self.searchCs(1);
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
					var orderSql = index + ' ' + sortorder
					if (index == 'valDef') {
						self.searchCsData.orderSql = 'a.'+orderSql;
					} else {
						self.searchCsData.orderSql = orderSql;
					}
					self.searchCs(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"zbpzmx-cs-table");
					self.searchCs(pageNo);
				}
			});
			this.searchCsData.pageSize = $(".ui-pg-selbox", $('.zbpzmx')).val();
			self.searchCs(1);
		},
		showModelYcff: function(operation){
      this.addTitle = operation == '1' ? '新增' : '编辑'
			this.modelYcffData.operation = operation
			$('.model').show();
			$('.zbpzmx .ycff-page-model').show();
		},
		hideModelYcff: function(){
			$('.model').hide();
			$('.zbpzmx .ycff-page-model').hide();
      this.modelYcffData = {
				xh: '',
				ycpdtj: '',
				lwgz: '',
				badpoint: '',
				score: '',
				note: '',
				yxbz: 'Y',
				operation: ''
			}
		},
		showModelCs: function(operation){
      this.addTitle = operation == '1' ? '新增' : '编辑'
			this.modelCsData.operation = operation
			$('.model').show();
			$('.zbpzmx .cs-page-model').show();
		},
		hideModelCs: function(){
			$('.model').hide();
			$('.zbpzmx .cs-page-model').hide();
      this.modelCsData = {
				csbm: '',
				csmc: '',
				datatype: '',
				valDef: '',
				note: '',
				yxbz: 'Y',
				operation: '',
				cstype: ''
			}
		},
		searchYcff:function(pageNo){
			var self=this;
			this.searchYcffData.pageSize = $(".ui-pg-selbox", $('.zbpzmx .ycff')).val() || 20;
			var params=tools.clone(self.searchYcffData);
			params.pageNo=pageNo;
			$("#zbpzmx-ycff-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/zb/ycff/swjg/list",params).done(function(res){
				if(res.code=='0'){
					$("#zbpzmx-ycff-table").resetSelection();
					$("#zbpzmx-ycff-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		searchCs:function(pageNo){
			var self=this;
			this.searchCsData.pageSize = $(".ui-pg-selbox", $('.zbpzmx .cs')).val() || 20;
			var params=tools.clone(self.searchCsData);
			params.pageNo=pageNo;
			$("#zbpzmx-cs-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/zb/cs/swjg/list",params).done(function(res){
				if(res.code=='0'){
					$("#zbpzmx-cs-table").resetSelection();
					$("#zbpzmx-cs-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
    saveModelYcff: function(){
      var self = this
			var rules = []
			var url = ''
			rules = [
				{ name: 'ycpdtj', message: '异常判定条件不能为空！' },
				{ name: 'lwgz', message: '例外规则不能为空！' },
				{ name: 'badpoint', message: '坏点标志不能为空！' },
				{ name: 'score', message: '健康码赋分不能为空！' },
				{ name: 'note', message: '异常描述不能为空！' },
				{ name: 'yxbz', message: '有效标志不能为空！' }
			]
			url = '/sszj/zbgl/zb/ycff/update'
      for (var i=0;i<rules.length;i++) {
        if (this.modelYcffData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return;
        }
      }
			this.modelYcffData.zbId = this.params.zbId
      ajax("POST",url,this.modelYcffData).done(function(res){
				if(res.code=='0'){
					tools.info('保存成功！');
          self.hideModelYcff();
          self.searchYcff(1);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    },
    saveModelCs: function(){
      var self = this
			var rules = []
			var url = ''
			rules = [
				{ name: 'csbm', message: '参数编码不能为空！' },
				{ name: 'csmc', message: '参数名称不能为空！' },
				{ name: 'datatype', message: '数据类型不能为空！' },
				{ name: 'valDef', message: '参数值不能为空！' },
				{ name: 'note', message: '说明不能为空！' }
			]
			url = '/sszj/zbgl/zb/cs/update'
      for (var i=0;i<rules.length;i++) {
        if (this.modelCsData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return;
        }
      }
			this.modelCsData.zbId = this.params.zbId
      ajax("POST",url,this.modelCsData).done(function(res){
				if(res.code=='0'){
					tools.info('保存成功！');
          self.hideModelCs();
          self.searchCs(1);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    },
		numberLimit: function(){
			this.modelYcffData.score = this.modelYcffData.score.replace(/\D/g,'');
		},
		setEllipsis: function(el){
			var offsetHeight = el.offsetHeight;
			var innerHTML = el.innerHTML;
			for(var i=0;i<innerHTML.length;i++){
				el.innerHTML = innerHTML.substr(0,i);
				if (offsetHeight < el.scrollHeight) {
					el.style.overflow = 'hidden';
					el.innerHTML = innerHTML.substr(0,i-3) + '...';
					break;
				}
			}
		}
	}
});