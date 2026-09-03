var jkmPdRecord=require("./jkmPdRecord.html");
avalon.component('jkmPdRecord', {
	template:jkmPdRecord,
	defaults: {
		params:{},
		act:1,
		tcode: "jkmPdRecordcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			swjgDm:"",
			qybs:"",
			fqlx:"",
			pdjg:"",
			jkmY:"",
			jkmN:"",
			tsjsfs:"",
			yxqQ:"",
			yxqZ:"",
			pdrqQ:"",
			pdrqZ:"",
			fhrqQ:"",
			fhrqZ:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    dafaultSearchData: {},
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjgDm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
      this.initDate();
			this.initTree();
			this.createTable();
		},
		initDate: function(){
			var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
			$('.jkmPdRecord .datepicker.date-day').datetimepicker(options);
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
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "pdUuid", label: "评定申请编号", index: "pdUuid",hidden: true },
				{ name: "fqlxStr", label: "发起类型", index: "fqlxStr",width: 60, align:"left",sortable: false},
				{ name: "qdsj", label: "启动时间", index: "qdsj",width: 130, align:"left",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 150, align:"left",sortable: true },
				{ name: "qyhgdm", label: "海关代码", index: "qyhgdm",width: 100, align:"left",sortable: true },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 150, align:"left",sortable: true },
				{ name: "jkmY", label: "原健康码", index: "jkmY",width: 50, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var colorMap = {
						'绿码': '#67C23A',
						'黄码': '#E6A23C',
						'红码': '#f56c6c'
					}
					return "<div style='background-color:"+ colorMap[cellvalue] +"'>"+cellvalue+"</div>";
				} },
				{ name: "jkmN", label: "新健康码", index: "jkmN",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var colorMap = {
						'绿码': '#67C23A',
						'黄码': '#E6A23C',
						'红码': '#f56c6c'
					}
					return "<div style='background-color:"+ colorMap[cellvalue] +"'>"+cellvalue+"</div>";
				} },
				{ name: "yxq", label: "评定有效期", index: "yxq",width: 80, align:"center",sortable: true },
				{ name: "pdztStr", label: "评定状态", index: "pdztStr",width: 100, align:"center",sortable: false},
				{ name: "pdjg", label: "评定结果", index: "pdjg",width: 60, align:"center",sortable: false},
				{ name: "pdrMc", label: "评定人", index: "pdrMc",width: 80, align:"center",sortable: false},
				{ name: "pdsj", label: "评定时间", index: "pdsj",width: 130, align:"center",sortable: true},
				{ name: "fhrMc", label: "复核人", index: "fhrMc",width: 80, align:"center",sortable: false},
				{ name: "fhsj", label: "复核时间", index: "fhsj",width: 130, align:"center",sortable: true},
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 130, align:"center",sortable: false}
			];
			$("#jkmPdRecord-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#jkmPdRecord-tablePager',
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
					return $(".jkmPdRecord .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if($(e.target).hasClass('op-pd')){
						var pdUuid = getCellData("jkmPdRecord-table", rowid, 'pdUuid')
            self.showModelPd(pdUuid)
						return false;
					}else if($(e.target).hasClass('op-del')){
						var nsrsbh = getCellData("jkmPdRecord-table", rowid, 'nsrsbh')
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
					var pageNo=tools.getPageNo(pgButton,"jkmPdRecord-table");
					self.search(pageNo);
				}
			});
		},
		search:function(pageNo){
			var self=this;
      var valid1 = tools.checkDate(this.searchData.yxqQ, this.searchData.yxqZ)
      if (!valid1) {
        tools.info('有效期起始日期不能大于截止日期！');
        return false;
      }
      var valid2 = tools.checkDate(this.searchData.pdrqQ, this.searchData.pdrqZ)
      if (!valid2) {
        tools.info('评定日期起不能大于截止日期！');
        return false;
      }
      var valid3 = tools.checkDate(this.searchData.fhrqQ, this.searchData.fhrqZ)
      if (!valid3) {
        tools.info('复核日期起不能大于截止日期！');
        return false;
      }
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jkmPdRecord')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
      this.dafaultSearchData = tools.clone(this.searchData)
			$("#jkmPdRecord-table").jqGrid('clearGridData')
			ajax("POST","/sszj/jkmpd/getHistoryList",params).done(function(res){
				if(res.code=='0'){
					$("#jkmPdRecord-table").resetSelection();
					$("#jkmPdRecord-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
    showHyper:function(){
			$('.jkmPdRecord .select-sub').toggle();
			$('.jkmPdRecord .select-wrapper .icon').toggleClass("active");
			if ($('.jkmPdRecord .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.jkmPdRecord .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.jkmPdRecord .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
    closeHyper:function(){
      $('.jkmPdRecord .select-sub').hide();
      $('.jkmPdRecord .select-wrapper .icon').removeClass('active');
      $('.jkmPdRecord .select-wrapper .icon').attr("title","展开查询条件");
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
				$.fn.zTree.init($(".jkmPdRecord .jkmPdRecordswjgtree.treeDiv"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.jkmPdRecord').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.jkmPdRecord').off('click');
		},
		reset: function() {
			this.searchData = {
				swjgDm:avalonRoot.user.swjgDm,
				qybs:"",
        fqlx:"",
        pdjg:"",
        jkmY:"",
        jkmN:"",
        tsjsfs:"",
        yxqQ:"",
        yxqZ:"",
        pdrqQ:"",
        pdrqZ:"",
        fhrqQ:"",
        fhrqZ:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= avalonRoot.user.swjgMc;
		},
    exform:function(){
			var self=this;
			if($('#jkmPdRecord-table').jqGrid('getRowData').length<=0){
					tools.info("请先查询列表");
					return ;
			}
			var params = tools.clone(self.dafaultSearchData)
			tools.exform(params, '/sszj/export/jkmPd/list')
		},
	}
});