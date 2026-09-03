var zbcssz=require("./zbcssz.html");
avalon.component('zbcssz', {
	template:zbcssz,
	defaults: {
		params:{},
		act:1,
		tcode: "zbcssz",
		searchData:{
      zbCname:"",
      ywflDm:"",
      applyQy:"",
      refreshCycle:"",
      yxbz:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		ywflList: [],
		hyList: [],
		isAdmin: false,
		onReady:function(){
			this.isAdmin = ['super','admin'].indexOf(avalonRoot.user.roleDm) > -1
			this.createTable();
			this.getYwfl();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "op2", label:"操作", width: 100, frozen: true, align:"center", resizable: false, sortable: false,formatter: function(cellvalue, options, rowObject){
					return "<div class='btn toMx "+(rowObject.yxbz == 'N' ? 'disabled' : '')+"' style='float: none;display: inline-block;' title='配置'>配置</div>";
				}},
				{ name: "zbId", label: "指标标识", index: "zbId",width: 80, align:"left",sortable: true },
				{ name: "zbCname", label: "指标名称", index: "zbCname", hidden: true },
				{ name: "zbCnameTmp", label: "指标名称", index: "zbCnameTmp",width: 150, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
          if (rowObject.yxbz == 'Y') {
            return "<span class='link toMx'>"+rowObject.zbCname+"</span>";
          } else {
            return rowObject.zbCname
          }
				} },
				{ name: "zbSname", label: "指标简称", index: "zbSname",width: 140, align:"left",sortable: true },
				{ name: "ywflDm", label: "业务分类代码", index: "ywflDm",hidden: true },
				{ name: "ywflDmName", label: "业务分类", index: "ywflDmName",width: 80, align:"center",sortable: false },
				{ name: "applyQy", label: "适用企业", index: "applyQy",hidden: true },
				{ name: "applyQyName", label: "适用企业", index: "applyQyName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = {'0': '通用', '1': '生产', '2': '外贸'};
					return map[rowObject.applyQy] || '';
				} },
				{ name: "zbType", label: "指标类型", index: "zbType",width: 60, align:"center",sortable: true },
				{ name: "rsType", label: "结果类型", index: "rsType",width: 60, align:"center",sortable: true },
				{ name: "refreshCycle", label: "刷新周期", index: "refreshCycle",width: 60, align:"center",sortable: true },
				{ name: "yxbz", label: "有效标志", index: "yxbz",hidden: true },
				{ name: "yxbzName", label: "有效标志", index: "yxbzName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var yxbzMap = { 'Y': '有效', 'N': '无效'};
					return yxbzMap[rowObject.yxbz] || '';
				} },
				{ name: "ywms", label: "业务描述", index: "ywms",width: 140, align:"left",sortable: true },
				{ name: "zbFomula", label: "指标公式", index: "zbFomula",width: 140, align:"left",sortable: true },
				{ name: "datatype", label: "数据类型", index: "datatype",hidden: true },
				{ name: "datatypeName", label: "数据类型", index: "datatypeName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = {'1': '字符型', '2': '数值型', '3': '日期型', '4': '逻辑性'};
					return map[rowObject.datatype] || '';
				} },
				{ name: "showformat", label: "显示格式", index: "showformat",hidden: true },
				{ name: "showformatName", label: "显示格式", index: "showformatName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = {'0': '默认', '1': '百分比', '2': '金额', '3': '整数'};
					return map[rowObject.showformat] || '';
				} },
				{ name: "bbh", label: "版本号", index: "bbh",width: 50, align:"left",sortable: true },
				{ name: "jsYxj", label: "计算优先级", index: "jsYxj",width: 70, align:"left",sortable: true },
				{ name: "op", label: "操作", width: 100, align: "center", resizable: false, search: false, sortable: false},
			];
			if (!this.isAdmin) {
				columns.splice(0,1);
				columns.splice(-1,1);
			}
			$("#zbcssz-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#zbcssz-tablePager',
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
					return $(".zbcssz .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#zbcssz-table").jqGrid("getRowData", rowid)
          if($(e.target).hasClass('disabled')) return;
          if($(e.target).hasClass('toMx')){
						var params = {
							zbId: row.zbId,
							zbCname: row.zbCname,
							applyQy: row.applyQy,
							ywms: row.ywms,
							zbFomula: row.zbFomula,
							refreshCycle: row.refreshCycle
						}
						avalonRoot.addTab({title:"指标参数设置详情",component:"zbcsszMx",params:params});
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
					var pageNo=tools.getPageNo(pgButton,"zbcssz-table");
					self.search(pageNo);
				},
        gridComplete: function(){
          var ids = $("#zbcssz-table").getDataIDs();
          for (var i = 0; i<ids.length; i++) {
            var rowData = $("#zbcssz-table").getRowData(ids[i]);
            if (rowData.yxbz == "N") { // 有效标志=N的指标记录用浅灰背景色
              $('#' + ids[i]).find("td").css("background", '#eee');
            }
          }
        }
			});
			if (this.isAdmin) {
				$("#zbcssz-table").jqGrid('setFrozenColumns');
				tools.HeiKjNoSel('zbcssz', 'zbcssz-table');
			}
			self.search(1);
		},
    showHyper:function(){
			$('.zbcssz .select-sub').toggle();
			$('.zbcssz .select-wrapper .icon').toggleClass("active");
			if ($('.zbcssz .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.zbcssz .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.zbcssz .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
    closeHyper:function(){
      $('.zbcssz .select-sub').hide();
      $('.zbcssz .select-wrapper .icon').removeClass('active');
      $('.zbcssz .select-wrapper .icon').attr("title","展开查询条件");
    },
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.zbcssz')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#zbcssz-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/zb/list",params).done(function(res){
				if(res.code=='0'){
					$("#zbcssz-table").resetSelection();
					$("#zbcssz-table")[0].addJSONData(res.data);
					if (self.isAdmin) {
						tools.HeiKjNoSel('zbcssz', 'zbcssz-table');
					}
          self.closeHyper();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
    exform:function(){
			var self=this;
			if($('#zbcssz-table').jqGrid('getRowData').length<=0){
				tools.info("请先查询列表");
				return ;
			}
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/sszj/export/zbgl/zb");
			var input1 = $("<input>");
			input1.attr("type", "hidden");
			input1.attr("name", "data");
			input1.attr("value", JSON.stringify(params));
			$("body").append(form); //将表单放置在web中
			form.append(input1);
			form.submit();
			form.remove();
		},
		reset: function() {
			this.searchData = {
        zbCname:"",
        ywflDm:"",
        applyQy:"",
        refreshCycle:"",
        yxbz:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.zbcssz').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.zbcssz').off('click');
		},
		getYwfl: function(){
			var self = this
			ajax("POST","/sszj/zbgl/zb/getYwfl",{}).done(function(res){
				if(res.code=='0'){
					self.ywflList = res.data
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		}
	}
});