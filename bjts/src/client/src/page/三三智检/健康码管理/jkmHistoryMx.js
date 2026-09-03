var jkmHistoryMx=require("./jkmHistoryMx.html");
avalon.component('jkmHistoryMx', {
	template:jkmHistoryMx,
	defaults: {
		params:{},
		act:1,
		tcode: "jkmHistoryMxcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			qybs:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		imgSrc: '',
		onReady:function(){
      this.searchData.qybs = this.params.nsrsbh
			this.createTable();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "djxh", label: "登记序号", index: "djxh",width: 150, align:"left",sortable: true },
				{ name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"left",sortable: true},
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"left",sortable: true },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 140, align:"left",sortable: true },
				{ name: "swjgMc", label: "税务机关", index: "swjgMc",width: 120, align:"left",sortable: true },
				{ name: "jkmMc", label: "健康码", index: "jkmMc",width: 50, align:"center",sortable: true },
				{ name: "scoreZh", label: "综合分数", index: "scoreZh",width: 60, align:"center",sortable: true },
				{ name: "score10", label: "信用", index: "score10",width: 40, align:"center",sortable: true },
				{ name: "score20", label: "退税", index: "score20",width: 40, align:"center",sortable: true },
				{ name: "score30", label: "出口", index: "score30",width: 40, align:"center",sortable: true },
				{ name: "score40", label: "发票", index: "score40",width: 40, align:"center",sortable: true },
				{ name: "score50", label: "财务", index: "score50",width: 40, align:"center",sortable: true },
				{ name: "score60", label: "其他", index: "score60",width: 40, align:"center",sortable: true },
				{ name: "ckqylx", label: "企业类型", index: "ckqylx",width: 80, align:"center",sortable: true },
				{ name: "glcd", label: "管理等级", index: "glcd",width: 60, align:"center",sortable: true },
				{ name: "djzclx", label: "登记注册类型", index: "djzclx",width: 90, align:"left",sortable: true },
				{ name: "hy", label: "行业类型", index: "hy",width: 90, align:"left",sortable: true },
				{ name: "uptime", label: "更新时间", index: "uptime",width: 140, align:"center",sortable: true},
			];
			$("#jkmHistoryMx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#jkmHistoryMx-tablePager',
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
					return $(".jkmHistoryMx .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if(e.target.nodeName=="TD"){
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
					var pageNo=tools.getPageNo(pgButton,"jkmHistoryMx-table");
					self.search(pageNo);
				}
			});
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jkmHistoryMx')).val();
			self.search(1);
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jkmHistoryMx')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#jkmHistoryMx-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/qyjkm/list/history",params).done(function(res){
				if(res.code=='0'){
					$("#jkmHistoryMx-table").resetSelection();
					$("#jkmHistoryMx-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		exform:function(){
			var self=this;
			if($('#jkmHistoryMx-table').jqGrid('getRowData').length<=0){
					tools.info("请先查询列表");
					return ;
			}
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/sszj/export/zbgl/jkm/history");
			var input1 = $("<input>");
			input1.attr("type", "hidden");
			input1.attr("name", "data");
			input1.attr("value", JSON.stringify(params));
			$("body").append(form); //将表单放置在web中
			form.append(input1);
			form.submit();
			form.remove();
		}
	}
});