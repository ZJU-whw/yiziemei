var ybqyzbfx=require("./ybqyzbfx.html");
avalon.component('ybqyzbfx', {
	template:ybqyzbfx,
	defaults: {
		params:{},
		act:1,
		tcode: "ybqyzbfxcx",
		swjgmc: "",
		searchData: {
			orderSql: ''
		},
		searchDataResult: {
			djxhs: [],
			orderSql: ''
		},
		searchDataMzqy: {
			type: '1',
			zbIds: [],
			djxhs: [],
			orderSql: '',
			pageSize: config.pageSize
		},
		modelData: {
			qysh: '',
      qysbh: '',
      qymc: ''
    },
    selRows: [],
    selResultRows: [],
		queryCode: '',
    nsrsbhList: [],
    showNsrsbhList: false,
    activeBgIndex: 0,
		resultParams: {},
		mzqyParams: {},
		ybqyList: [],
		onReady:function(){
			this.importCallBack();
			this.createTable();
			this.createTableResult();
      this.createTableMzqy();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "djxh", label: "登记序号", index: "djxh",hidden: true },
				{ name: "qysh", label: "纳税人识别号", index: "qysh",width: 140, align:"left",sortable: true },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 200, align:"left",sortable: true },
				{ name: "jkmLevel", label: "健康码", index: "jkmLevel",width: 50, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
					var colorMap = {
						'绿': '#67C23A',
						'黄': '#E6A23C',
						'红': '#f56c6c'
					}
					if (cellvalue) {
						return "<div style='background-color:"+ colorMap[cellvalue] +"'>"+cellvalue+"</div>";
					} else {
						return '';
					}
				} },
				{ name: "ycZbSl", label: "异常指标数", index: "ycZbSl",width: 90, align:"right",sortable: true },
				{ name: "qylx", label: "企业类型", index: "qylx",width: 60, align:"center",sortable: true },
				{ name: "ckgm", label: "出口规模", index: "ckgm",width: 200, align:"left",sortable: true },
        { name: "op", label: "操作", index: "op",width: 60,sortable: false, formatter: function(cellvalue, options, rowObject){
					var op = "<div style='text-align:center;'><div class='btn op-del' style='float: none;display: inline-block;' title='删除'>删除</div>";
					op +="</div>";
					return op;
				} },
			];
			$("#ybqyzbfx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				rownumWidth: 40,
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				multiselect: true,
				multiselectWidth:"40",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: 99999,
				width:"100%",
				height:(function(){
					return $(".ybqyzbfx").height() / 2 - 80;
				})(),
				beforeSelectRow:function(rowid,e){
          var row = $("#ybqyzbfx-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('op-del')){
						tools.confirm('是否确定删除该条数据？','确定',function(){
							var params = {
								qysh: row.qysh,
								queryCode: self.queryCode
							}
							ajax("POST","/sszj/zbfx/del",params).done(function(res){
								if(res.code=='0'){
									tools.info('删除成功!');
									self.search();
								} else if (res.code == '1007') {
									tools.confirm('样本企业数据已失效，是否刷新页面，重新添加样本企业','刷新', function(){
										self.selRows = [];
										self.selResultRows = [];
										self.queryCode = ''
										self.searchDataResult.djxhs = []
										self.searchDataMzqy.djxhs = []
										self.searchDataMzqy.zbIds = []
										$("#ybqyzbfx-table").jqGrid('clearGridData');
										$("#ybqyzbfx-result-table").jqGrid('clearGridData');
										$("#ybqyzbfx-mzqy-table").jqGrid('clearGridData');
									})
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
					self.searchData.orderSql = index + ' ' + sortorder;
					self.search();
					return;
				},
				onSelectRow: function (rowid, status) {
          var index = self.selRows.indexOf(rowid);
          if (status) {
            self.selRows.push(rowid)
          } else {
            self.selRows.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          if (status) {
            self.selRows = JSON.parse(JSON.stringify(rowids));
          } else {
            self.selRows = [];
          }
        }
			});
		},
		createTableResult:function(){
			var self=this;
			var columns = [
				{ name: "zbId", label: "指标ID", index: "zbId",width: 140, align:"left",sortable: true },
				{ name: "zbMc", label: "指标名称", index: "zbMc",width: 200, align:"left",sortable: true },
				{ name: "ybHs", label: "样本户数", index: "ybHs",width: 80, align:"right",sortable: true},
			];
			$("#ybqyzbfx-result-table").jqGrid({
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
				rowNum: 99999,
				width:"100%",
				height:(function(){
					return $(".ybqyzbfx").height() / 2 - 80;
				})(),
				beforeSelectRow:function(rowid,e){
          return true;
				},
				onSortCol: function (index, iCol, sortorder) {
					self.searchDataResult.orderSql = index + ' ' + sortorder;
					self.searchResult();
					return;
				},
				onSelectRow: function (rowid, status) {
          var index = self.selResultRows.indexOf(rowid);
          if (status) {
            self.selResultRows.push(rowid)
          } else {
            self.selResultRows.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          if (status) {
            self.selResultRows = JSON.parse(JSON.stringify(rowids));
          } else {
            self.selResultRows = [];
          }
        }
			});
		},
		createTableMzqy:function(){
			var self=this;
			var columns = [
				{ name: "djxh", label: "登记序号", index: "djxh",hidden: true },
				{ name: "qysh", label: "纳税人识别号", index: "qysh",width: 140, align:"left",sortable: true },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 200, align:"left",sortable: true },
				{ name: "jkmLevel", label: "健康码", index: "jkmLevel",width: 50, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
					var colorMap = {
						'绿': '#67C23A',
						'黄': '#E6A23C',
						'红': '#f56c6c'
					}
					if (cellvalue) {
						return "<div style='background-color:"+ colorMap[cellvalue] +"'>"+cellvalue+"</div>";
					} else {
						return '';
					}
				} },
				{ name: "zbs", label: "指标数", index: "zbs",width: 90, align:"right",sortable: true },
			];
			$("#ybqyzbfx-mzqy-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#ybqyzbfx-mzqy-tablePager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"40",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
				width:"100%",
				height:(function(){
					return $(".ybqyzbfx").height() / 2 - 106;
				})(),
				beforeSelectRow:function(rowid,e){
					return true;
				},
				onSortCol: function (index, iCol, sortorder) {
					self.searchDataMzqy.orderSql = index + ' ' + sortorder;
					self.searchMzqy(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"ybqyzbfx-mzqy-table");
					self.searchMzqy(pageNo);
				}
			});
		},
		search:function(qyshList){
			var self = this
      var params = {
				orderSql: this.searchData.orderSql,
				pageNo: 1,
				pageSize: 20,
				queryCode: this.queryCode
			}
			$("#ybqyzbfx-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbfx/ybqyList",params).done(function(res){
				if(res.code=='0'){
					self.ybqyList = res.data;
					$("#ybqyzbfx-table").resetSelection();
					$("#ybqyzbfx-table")[0].addJSONData(res.data);
					self.selRows = [];
					if (qyshList) {
						self.gridSelected('ybqyzbfx-table', qyshList)
					}
				} else if (res.code == '1007') {
					tools.confirm('样本企业数据已失效，是否刷新页面，重新添加样本企业','刷新', function(){
						self.selRows = [];
						self.selResultRows = [];
						self.queryCode = ''
						self.searchDataResult.djxhs = []
						self.searchDataMzqy.djxhs = []
						self.searchDataMzqy.zbIds = []
						$("#ybqyzbfx-table").jqGrid('clearGridData');
						$("#ybqyzbfx-result-table").jqGrid('clearGridData');
						$("#ybqyzbfx-mzqy-table").jqGrid('clearGridData');
					})
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		refreshResult: function(){
			if (this.selRows.length<=0) {
				tools.info('请先选择样本企业！')
				return;
			}
			var djxhs = []
			for (var i = 0; i < this.selRows.length;i++ ){
        var row = $("#ybqyzbfx-table").jqGrid("getRowData", this.selRows[i]);
				djxhs.push(row.djxh)
      }
			this.searchDataResult.djxhs = djxhs
			this.searchResult()
		},
		searchResult:function(){
			var self = this
			if (this.searchDataResult.djxhs.length <= 0) {
				tools.info('请先选择样本企业！')
				return;
			}
      var params = {
				orderSql: this.searchDataResult.orderSql,
				pageNo: 1,
				pageSize: 20,
				djxhs: this.searchDataResult.djxhs,
				queryCode: this.queryCode
			}
			this.resultParams = tools.clone(params)
			$("#ybqyzbfx-result-table").jqGrid('clearGridData')
			api.zbfxYczbList(params).done(function(res){
				if(res.code=='0'){
					$("#ybqyzbfx-result-table").resetSelection();
					$("#ybqyzbfx-result-table")[0].addJSONData(res.data);
					self.selResultRows = [];
				}
			})
		},
		refreshMzqy: function(){
			if (this.selResultRows.length<=0) {
				tools.info('请先选择异常指标统计结果！')
				return;
			}
			var zbIds = []
			for (var i = 0; i < this.selResultRows.length;i++ ){
        var row = $("#ybqyzbfx-result-table").jqGrid("getRowData", this.selResultRows[i]);
				zbIds.push(row.zbId)
      }
			this.searchDataMzqy.zbIds = zbIds
			var djxhs = []
			for (var i=0;i<this.ybqyList.length;i++) {
				djxhs.push(this.ybqyList[i].djxh)
			}
			this.searchDataMzqy.djxhs = djxhs
			this.searchMzqy(1)
		},
		searchMzqy: function(pageNo){
			if (this.searchDataMzqy.zbIds.length<=0) {
				tools.info('请先选择异常指标统计结果！')
				return;
			}
      var params = {
				orderSql: this.searchDataMzqy.orderSql,
				pageNo: pageNo,
				pageSize: $(".ui-pg-selbox", $('.ybqyzbfx .mzqy')).val() || 20,
				djxhs: this.searchDataMzqy.djxhs,
				zbIds: this.searchDataMzqy.zbIds,
				type: this.searchDataMzqy.type,
				queryCode: this.queryCode
			}
			this.mzqyParams = tools.clone(params)
			$("#ybqyzbfx-mzqy-table").jqGrid('clearGridData')
			api.zbfxHitQyList(params).done(function(res){
				if(res.code=='0'){
					$("#ybqyzbfx-mzqy-table").resetSelection();
					$("#ybqyzbfx-mzqy-table")[0].addJSONData(res.data);
				}
			})
		},
		exform:function(){
			if($('#ybqyzbfx-table').jqGrid('getRowData').length<=0){
        tools.info("导出列表为空！");
        return ;
			}
			var params = {
				orderSql: this.searchData.orderSql,
				pageNo: 1,
				pageSize: 20,
				queryCode: this.queryCode
			}
      tools.exform(params,"/sszj/export/zbfx/ybqy")
		},
		exformResult:function(){
			if($('#ybqyzbfx-result-table').jqGrid('getRowData').length<=0){
        tools.info("导出列表为空！");
        return ;
			}
      tools.exform(this.resultParams,"/sszj/export/zbfx/yczb")
		},
		exformMzqy:function(){
			if($('#ybqyzbfx-mzqy-table').jqGrid('getRowData').length<=0){
        tools.info("导出列表为空！");
        return ;
			}
      tools.exform(this.mzqyParams,"/sszj/export/zbfx/hitQy")
		},
		showImportModel: function(){
      $('.model').show();
			$('.ybqyzbfx .import-page-model').show();
    },
    hideImportModel: function(){
      $('.model').hide();
			$('.ybqyzbfx .import-page-model').hide();
    },
    importCallBack: function(){
      var self = this;
      $('#ybqyzbfxFileupload').fileupload({
        dataType: 'json',
        acceptFileTypes: /(xls|xlsx)$/i,
        maxFileSize: 4000000, // 限制大小4M
				add: function (e, data) {
					//将赋值完毕的参数实体，再赋值给插件formData属性
					data.formData = {queryCode: self.queryCode};
					data.submit(); 
				},
        done: function (e, data) {
          if (data.result.code == "0") {
						tools.info("导入成功!");
						self.queryCode = data.result.data.queryCode
						self.search(data.result.data.qyshList);
          } else if (data.result.code == '1007') {
						tools.confirm('样本企业数据已失效，是否刷新页面，重新添加样本企业','刷新', function(){
							self.selRows = [];
							self.selResultRows = [];
							self.queryCode = ''
							self.searchDataResult.djxhs = []
							self.searchDataMzqy.djxhs = []
							self.searchDataMzqy.zbIds = []
							$("#ybqyzbfx-table").jqGrid('clearGridData');
							$("#ybqyzbfx-result-table").jqGrid('clearGridData');
							$("#ybqyzbfx-mzqy-table").jqGrid('clearGridData');
						})
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
		exformModel:function(){
			tools.exform({},'/sszj/export/zbfx/template')
		},
		showModel: function(){
			$('.model').show();
			$('.ybqyzbfx .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.ybqyzbfx .add-page-model').hide();
      this.modelData = {
        qysbh: '',
				qysh: '',
				qymc: ''
      }
      this.nsrsbhList = []
      this.showNsrsbhList = false
      this.activeBgIndex = 0
		},
		// 模糊查询税号，获取税号列表
    inpChangeNsrsbh: function(key){
      this[key].qymc = ''
      this[key].qysbh = this[key].qysbh.trim()
      var qysbh = this[key].qysbh
      if (qysbh.length<4) {
        return;
      }
      var params = {
        qybs: qysbh
      }
      var self = this
      ajax("POST","/sszj/jkmpd/nsrxx/list",params, false, false, true ).done(function(res){
        if(res.code=='0'){
          self.nsrsbhList = res.data
          self.showNsrsbh()
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
          tools.info(err);
      })
    },
    // 显示纳税人识别号弹框
    showNsrsbh: function(){
      var list = this.nsrsbhList
      if (list&&list.length>0) {
        this.showNsrsbhList = true
      }
    },
    // 隐藏纳税人识别号弹框
    hideNsrsbh: function(e){
      if($(e.target).parent().hasClass('nsrsbh-group')) return
      this.showNsrsbhList = false
    },
    nsrsbhEnterSearch: function(e) {
      e.target.blur()
      this.showNsrsbhList = false
    },
    keydown: function(e, id){
      var index = this.activeBgIndex
      var len = this.nsrsbhList.length
      //38:上  40:下
      if (e.keyCode == 38) {
        if (index > 0) {
          index --
        } else {
          index = len - 1
        }
        this.stopDefault(e)
      } else if (e.keyCode == 40) {
        if (index < len-1) {
          index ++
        } else {
          index = 0
        }
        this.stopDefault(e)
      }
      this.activeBgIndex = index
      var pHeight = $('#'+id+' p:first').height() // p元素高度
      if (index > 2) {
        $("#"+id).scrollTop(pHeight * (index - 3) + 9)
      } else {
        $("#"+id).scrollTop(0)
      }
      if(e.keyCode==13){  // enter
        var item = {}
        item = this.nsrsbhList[index]
        if (item) {
					this.setNsrsbh(item,'modelData')
        }
      }
    },
    //阻止事件执行
    stopDefault:function (event) {
      //阻止默认浏览器动作(W3C)   
      if (event && event.preventDefault) {
          //火狐的 事件是传进来的e  
          event.preventDefault();
      }
      //IE中阻止函数器默认动作的方式   
      else {
          //ie 用的是默认的event  
          event.returnValue = false;
      }
    },
    setNsrsbh: function(item, key){
      this[key].qysh = item.nsrsbh
      this[key].qymc = item.nsrmc
      this.showNsrsbhList = false
    },
		saveModel: function(){
			var self = this
			if (this.modelData.qysh == ''){
				tools.info('企业税号不能为空！');
				return;
			}
			var params = {
				qysh: this.modelData.qysh,
				queryCode: this.queryCode
			}
			ajax("POST","/sszj/zbfx/add",params).done(function(res){
				if(res.code=='0'){
					tools.info('添加成功!');
					self.queryCode = res.data.queryCode
					self.hideModel();
					self.search([res.data.qysh]);
				} else if (res.code == '1007') {
					tools.confirm('样本企业数据已失效，是否刷新页面，重新添加样本企业','刷新', function(){
						self.selRows = [];
						self.selResultRows = [];
						self.queryCode = ''
						self.hideModel();
						self.searchDataResult.djxhs = []
						self.searchDataMzqy.djxhs = []
						self.searchDataMzqy.zbIds = []
						$("#ybqyzbfx-table").jqGrid('clearGridData');
						$("#ybqyzbfx-result-table").jqGrid('clearGridData');
						$("#ybqyzbfx-mzqy-table").jqGrid('clearGridData');
					})
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		gridSelected: function(tableId,qyshList){
			var rowIds = $('#'+tableId).jqGrid('getDataIDs');
			for(var k=0; k<rowIds.length; k++) {
				var curRowData = $('#'+tableId).jqGrid('getRowData', rowIds[k]);
				console.log(curRowData)
				console.log(qyshList)
				for(var i=0;i<qyshList.length;i++){
					if(curRowData.qysh == qyshList[i]){
						$('#'+tableId).setSelection(rowIds[k], true); 
					}
				}
			}
		}
	}
});