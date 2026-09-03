var sjypz=require("./sjypz.html");
avalon.component('sjypz', {
	template:sjypz,
	defaults: {
		params:{},
		act:1,
		tcode: "sjypz",
		searchData:{
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
      dsId:"",
      dsName:"",
      dsType:"",
      showorder:"",
			yxbz: "Y"
    },
    addTitle:"新增",
		onReady:function(){
			this.createTable();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "dsId", label: "数据源标识", index: "dsId",width: 80, align:"left",sortable: true },
				{ name: "dsName", label: "数据源名称", index: "dsName",width: 150, align:"left",sortable: true },
				{ name: "dsType", label: "数据源类型", index: "dsType",width: 80, align:"left",sortable: true },
				{ name: "showorder", label: "显示顺序", index: "showorder",width: 80, align:"center",sortable: true },
				{ name: "yxbz", label: "有效标志", index: "yxbz",hidden: true },
				{ name: "yxbzName", label: "有效标志", index: "yxbzName",width: 80, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var yxbzMap = { 'Y': '有效', 'N': '无效'};
					return yxbzMap[rowObject.yxbz];
				} },
				{ name: "op", label: "操作", index: "op",width: 116, formatter: function(cellvalue, options, rowObject){
					return "<div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn del' style='float: none;display: inline-block;' title='删除'>删除</div>";
				} },
			];
			$("#sjypz-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#sjypz-tablePager',
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
					return $(".sjypz .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#sjypz-table").jqGrid("getRowData", rowid)
          for (var key in self.modelData) {
            self.modelData[key] = row[key]
          }
					if($(e.target).hasClass('edit')){
						self.showModel('编辑');
						return false;
					}else if($(e.target).hasClass('del')){
            var params = {
              dsId: row.dsId
            }
						tools.confirm('是否确定删除该条数据？', '确定', function(){
							ajax("POST","/sszj/zbgl/ds/del",params).done(function(res){
								if(res.code=='0'){
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
					self.searchData.orderSql = index + ' ' + sortorder;
					self.search(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"sjypz-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		showModel: function(title){
      this.addTitle = title
			$('.model').show();
			$('.sjypz .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.sjypz .add-page-model').hide();
      this.modelData = {
        dsId:"",
        dsName:"",
        dsType:"",
        showorder:"",
        yxbz: "Y"
      }
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.sjypz')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#sjypz-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/ds/list",params).done(function(res){
				if(res.code=='0'){
					$("#sjypz-table").resetSelection();
					$("#sjypz-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
    exform:function(){
			var self=this;
			if($('#sjypz-table').jqGrid('getRowData').length<=0){
				tools.info("请先查询列表");
				return ;
			}
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/sszj/export/zbgl/ds");
			var input1 = $("<input>");
			input1.attr("type", "hidden");
			input1.attr("name", "data");
			input1.attr("value", JSON.stringify(params));
			$("body").append(form); //将表单放置在web中
			form.append(input1);
			form.submit();
			form.remove();
		},
    saveModel: function(){
      var self = this
      var rules = [
        { name: 'dsId',  message: '数据源标识不能为空！'},
        { name: 'dsName',  message: '数据源名称不能为空！'},
        { name: 'dsType',  message: '数据源类型不能为空！'},
        { name: 'showorder',  message: '显示顺序不能为空！'},
        { name: 'yxbz',  message: '有效标志不能为空！'},
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return;
        }
      }
      ajax("POST","/sszj/zbgl/ds/update",this.modelData).done(function(res){
				if(res.code=='0'){
					tools.info('保存成功！');
          self.hideModel();
          self.search(1);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    },
		numberLimit: function(){
			this.modelData.showorder = this.modelData.showorder.replace(/\D/g,'');
		}
	}
});