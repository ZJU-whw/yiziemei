var shareFaCx=require("./shareFaCx.html");
avalon.component('shareFaCx', {
	template:shareFaCx,
	defaults: {
		params:{},
		act:1,
		tcode: "shareFaCxcx",
		selRows: [],
		searchData:{
			famc:"",
			crTimeQ:"",
			crTimeZ:"",
			tsjsfsDm:"",
			note:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		dictList: [],
		dataList: [],
		addTitle: '',
		onReady:function(){
			this.initDate();
			this.createTable();
		},
		initDate: function(){
			var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
			var optionsY = { language: "zh-CN", format: "yyyy", autoclose: true, clearBtn: true, startView: 4, minView: 4, forceParse: 0 };
			$('.shareFaCx .datepicker.date-day').datetimepicker(options);
			$('.shareFaCx .datepicker.date-year').datetimepicker(optionsY);
    },
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true },
				{ name: "famc", label: "方案名称", index: "famc",width: 140, align:"left",sortable: true },
				{ name: "tsjsfs", label: "企业类型", index: "tsjsfs",width: 80, align:"center",sortable: true },
				{ name: "crUser", label: "创建人", index: "crUser",width: 80, align:"left",sortable: false },
				{ name: "crTime", label: "创建时间", index: "crTime",width: 130, align:"center",sortable: false },
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 180, align:"left",sortable: true },
				{ name: "gxlx", label: "共享类型", index: "gxlx",width: 80, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
          var map = {0: '私有', 1:'公有'}
          return map[cellvalue] || ''
        } },
				{ name: "note", label: "备注说明", index: "note",width: 220, align:"left",sortable: true },
				{ name: "op", label: "操作", index: "op",width: 190, formatter: function(cellvalue, options, rowObject){
					var op = "<div style='text-align:center;'><div class='btn op-edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn op-del "+(rowObject.isDelete=='0' ? 'disabled' : '')+"' style='float: none;display: inline-block;' title='删除'>删除</div><div class='btn op-gxgx "+(rowObject.gxlx=='0' ? 'disabled' : '')+"' style='float: none;display: inline-block;' title='共享关系'>共享关系</div>";
					op +="</div>";
					return op;
				} },
			];
			$("#shareFaCx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#shareFaCx-tablePager',
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
					return $(".shareFaCx .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var id = getCellData("shareFaCx-table", rowid, 'id');
					if($(e.target).hasClass('disabled')) return false;
					if($(e.target).hasClass('op-edit')){
						avalonRoot.addTab({title:"共享方案编辑",component:"shareFaEdit",params:{id:id}});
						return false;
					}else if($(e.target).hasClass('op-del')){
						tools.confirm('是否确定进行删除操作？','确定', function(){
							ajax("POST","/sszj/xmgl/fa/delete",{id: id}).done(function(res){
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
					}else if($(e.target).hasClass('op-gxgx')){
						avalonRoot.addTab({title:"共享关系查询",component:"gxgx",params:{id:id}});
						return false;
					} else if(e.target.nodeName=="TD"){
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
					var pageNo=tools.getPageNo(pgButton,"shareFaCx-table");
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
			this.searchData.pageSize = $(".ui-pg-selbox", $('.shareFaCx .list')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#shareFaCx-table").jqGrid('clearGridData')
			ajax("POST","/sszj/xmgl/gxList",params).done(function(res){
				if(res.code=='0'){
					self.dataList = res.data.rows
					$("#shareFaCx-table").resetSelection();
					$("#shareFaCx-table")[0].addJSONData(res.data);
					self.closeHyper()
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		showHyper:function(){
			$('.shareFaCx .select-sub').toggle();
			$('.shareFaCx .select-wrapper .icon').toggleClass("active");
			if ($('.shareFaCx .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.shareFaCx .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.shareFaCx .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
		closeHyper:function(){
			$('.shareFaCx .select-sub').hide();
			$('.shareFaCx .select-wrapper .icon').removeClass('active');
			$('.shareFaCx .select-wrapper .icon').attr("title","展开查询条件");
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.shareFaCx').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.shareFaCx').off('click');
		},
		exformModel:function(){
			tools.exform({}, '/sszj/export/ybqy/template')
		},
		reset: function() {
			this.searchData = {
				famc:"",
				crTimeQ:"",
				crTimeZ:"",
				tsjsfsDm:"",
				note:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
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
		}
	}
});