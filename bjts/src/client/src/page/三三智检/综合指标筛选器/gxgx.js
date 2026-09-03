var gxgx=require("./gxgx.html");
avalon.component('gxgx', {
	template:gxgx,
	defaults: {
		params:{},
		act:1,
		tcode: "gxgxcx",
		searchData:{
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
      action: '',
      id: '',
      gxfw: '',
      dxlx: 'SWJG',
      qybz: 'Y'
    },
    gxfwMc: '',
		onReady:function(){
			this.initTree();
			this.createTable();
		},
		initDate: function(){
			var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
			var optionsY = { language: "zh-CN", format: "yyyy", autoclose: true, clearBtn: true, startView: 4, minView: 4, forceParse: 0 };
			$('.gxgx .datepicker.date-day').datetimepicker(options);
			$('.gxgx .datepicker.date-year').datetimepicker(optionsY);
    },
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true },
				{ name: "gxfw", label: "共享范围代码", index: "gxfw",hidden:true },
				{ name: "gxfwMc", label: "共享范围名称", index: "gxfwMc",width: 240, align:"left",sortable: false },
				{ name: "dxlx", label: "对象类型", index: "dxlx",hidden:true },
				{ name: "dxlxStr", label: "对象类型", index: "dxlxStr",width: 80, align:"left",sortable: false },
				{ name: "qybz", label: "启用标志", index: "qybz", hidden:true  },
				{ name: "qybzStr", label: "启用标志", index: "qybzStr",width: 80, align:"center",sortable: false },
				{ name: "crUser", label: "创建人名称", index: "crUser",width: 100, align:"left",sortable: false },
				{ name: "crTime", label: "创建时间", index: "crTime",width: 130, align:"left",sortable: true },
				{ name: "upUser", label: "修改人名称", index: "upUser",width: 100, align:"left",sortable: false },
				{ name: "upTime", label: "修改时间", index: "upTime",width: 130, align:"left",sortable: true },
				{ name: "op", label: "操作", index: "op",width: 120, formatter: function(cellvalue, options, rowObject){
					var op = "<div style='text-align:center;'><div class='btn op-edit "+(rowObject.isEdit=='0' ? 'disabled' : '')+"' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn op-del "+(rowObject.isEdit=='0' ? 'disabled' : '')+"' style='float: none;display: inline-block;' title='删除'>删除</div>";
					op +="</div>";
					return op;
				} },
			];
			$("#gxgx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#gxgx-tablePager',
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
					return $(".gxgx .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#gxgx-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('disabled')) return false;
					if($(e.target).hasClass('op-edit')){
            self.modelData = {
              action: row.action,
              id: row.id,
              gxfw: row.gxfw,
              dxlx: row.dxlx,
              qybz: row.qybz
            }
            self.gxfwMc = row.gxfwMc
						self.showModel('2')
						return false;
					}else if($(e.target).hasClass('op-del')){
						tools.confirm('是否确定进行删除操作？','确定', function(){
							ajax("POST","/sszj/xmgl/deleteGxgx",{id: row.id, gid: self.params.id}).done(function(res){
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
					self.searchData.orderSql = orderSql;
					self.search(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"gxgx-table");
					self.search(pageNo);
				}
			});
      this.search(1);
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.gxgx')).val() || 20;
			var params=tools.clone(self.searchData);
      params.gid = this.params.id
			params.pageNo=pageNo;
			$("#gxgx-table").jqGrid('clearGridData')
			ajax("POST","/sszj/xmgl/getGxgx",params).done(function(res){
				if(res.code=='0'){
					$("#gxgx-table").resetSelection();
					$("#gxgx-table")[0].addJSONData(res.data);
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
						self.modelData.gxfw = node.id;
						self.gxfwMc = node.text;
						self.hideTree();
						return;
					},
					onDblClick:function(e,id,node){
						self.modelData.gxfw = node.id;
						self.gxfwMc = node.text;
						self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			};
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				$.fn.zTree.init($("#gxgxTree"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.gxgx').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.gxgx').off('click');
		},
		exformModel:function(){
			tools.exform({}, '/sszj/export/ybqy/template')
		},
		reset: function() {
			this.searchData = {
				swjgDm:avalonRoot.user.swjgDm,
				famc:"",
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
    showModel: function(action){
      this.modelData.action = action
      $('.model').show();
      $('.gxgx .edit-page-model').show();
    },
    hideModel: function(){
      $('.model').hide();
      $('.gxgx .edit-page-model').hide();
      this.modelData = {
        action: '',
        id: '',
        gxfw: '',
        dxlx: 'SWJG',
        qybz: 'Y'
      }
      this.gxfwMc = ''
    },
    saveModel: function(){
      var self = this
			var rules = [
        { name: 'gxfw',  message: '共享范围不能为空！'},
        { name: 'dxlx',  message: '对象类型不能为空！'},
        { name: 'qybz',  message: '启用标志不能为空！'}
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return false;
        }
      }
      var params = tools.clone(this.modelData)
      params.gid = this.params.id
      ajax("POST","/sszj/xmgl/saveGxgx",params).done(function(res){
				if(res.code=='0'){
          tools.info('操作成功！');
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