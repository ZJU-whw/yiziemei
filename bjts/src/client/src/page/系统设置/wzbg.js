var wzbg=require("./wzbg.html");
avalon.component('wzbg', {
	template:wzbg,
	defaults: {
		params:{},
		act:1,
		tcode: "wzbgcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			qybs:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		imgSrc: '',
		onReady:function(){
			this.createTable();
      this.importCallBack();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "templateName", label: "模板文件", index: "templateName",width: 150, align:"left",sortable: true },
				{ name: "cjr", label: "创建人", index: "cjr",width: 90, align:"left",sortable: true},
				{ name: "crtime", label: "创建时间", index: "crtime",width: 140, align:"left",sortable: true },
				{ name: "remark", label: "备注", index: "remark",width: 140, align:"left",sortable: true },
				{ name: "op", label: "操作", width: 140, align: "center", resizable: false, search: false, sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<div class='btn op-template' style='float: none;display: inline-block;' title='模板'>模板</div><div class='btn op-report' style='float: none;display: inline-block;' title='生成'>生成</div>";
				} }
			];
			$("#wzbg-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#wzbg-tablePager',
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
					return $(".wzbg .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#wzbg-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('op-template')){
            tools.exform({fileName: row.templateName},"/sszj/chart/download/template")
						return false;
					}else if($(e.target).hasClass('op-report')){
            tools.exform({id: row.id},"/sszj/chart/generate/report")
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
					var pageNo=tools.getPageNo(pgButton,"wzbg-table");
					self.search(pageNo);
				}
			});
			this.searchData.pageSize = $(".ui-pg-selbox", $('.wzbg')).val();
			self.search(1);
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.wzbg')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#wzbg-table").jqGrid('clearGridData')
			ajax("POST","/sszj/chart/template/list",params).done(function(res){
				if(res.code=='0'){
					$("#wzbg-table").resetSelection();
					$("#wzbg-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
    
    importCallBack: function(){
      var self = this;
      $('#wzbgFileupload').fileupload({
        dataType: 'json',
        acceptFileTypes: /(xls|xlsx)$/i,
        maxFileSize: 4000000, // 限制大小4M
        done: function (e, data) {
          if (data.result.code == "0") {
              tools.info("上传成功!");
              self.search(1);
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
	}
});