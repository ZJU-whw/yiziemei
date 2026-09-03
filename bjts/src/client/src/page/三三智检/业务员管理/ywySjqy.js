var ywysjqy=require("./ywysjqy.html");
avalon.component('ywysjqy', {
	template:ywysjqy,
	defaults: {
		params:{},
		act:1,
		tcode: "ywysjqy",
		swjgmc: "",
		selRows: [],
		searchData:{
			zjhm: "",
			orderSql:"",
			pageSize:config.pageSize,
		},
		onReady:function(){
			this.searchData.zjhm = this.params.zjhm
			this.createTable();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",hidden: true },
				{ name: "nsrmcLink", label: "企业名称", index: "nsrmcLink",width: 260, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<span class='link toSjqyMx'>"+rowObject.nsrmc+"</span>";
				} },
				{ name: "swjgmc", label: "税务机关名称", index: "swjgmc",width: 120, align:"left",sortable: true }
			];
			$("#ywysjqy-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#ywysjqy-tablePager',
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
					return $(".ywysjqy .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if($(e.target).hasClass('toSjqyMx')){
						var row = $("#ywysjqy-table").jqGrid("getRowData", rowid)
						avalonRoot.addTab({title:"企业明细",component:"ywysjqymx",params:row});
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
					if (index == 'tjsj') {
						orderSql = 't.'+orderSql;
					}
					self.searchData.orderSql = orderSql;
					self.search(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"ywysjqy-table");
					self.search(pageNo);
				}
			});
			this.searchData.pageSize = $(".ui-pg-selbox", $('.ywysjqy')).val();
			self.search(1);
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.ywysjqy')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#ywysjqy-table").jqGrid('clearGridData')
			ajax("POST","/sszj/ywyba/list",params).done(function(res){
				if(res.code=='0'){
					$("#ywysjqy-table").resetSelection();
					$("#ywysjqy-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
	}
});