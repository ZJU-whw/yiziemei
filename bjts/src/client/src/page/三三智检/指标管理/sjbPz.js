var sjbpz=require("./sjbpz.html");
avalon.component('sjbpz', {
	template:sjbpz,
	defaults: {
		params:{},
		act:1,
		tcode: "sjbpz",
		swjgmc: "",
		selRows: [],
		searchData:{
      dsId:"",
      tablename:"",
      tablecname:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
      dsId:"",
			action: "",
      tablename:"",
      dsSchema:"",
      tablecname:"",
      isDict:"Y",
      showorder:"",
      yxbz:"Y",
    },
    addTitle:"新增",
		dsNameList: [], // 所有数据源的标识和名称列表
		onReady:function(){
			this.createTable();
			this.getDsName();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "dsId", label: "数据源标识", index: "dsId",hidden: true },
				{ name: "dsIdAndName", label: "数据源标识", index: "dsIdAndName",width: 140, align:"left",sortable: true },
				{ name: "dsSchema", label: "数据源用户", index: "dsSchema",width: 80, align:"left",sortable: true },
				{ name: "tablename", label: "数据表名", index: "tablename",width: 150, align:"left",sortable: true },
				{ name: "tablecname", label: "数据表中文名", index: "tablecname",width: 160, align:"left",sortable: true },
				{ name: "isDict", label: "是否为代码表", index: "isDict",hidden: true },
				{ name: "isDictName", label: "是否为代码表", index: "isDictName",width: 80, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[rowObject.yxbz] || '';
				} },
				{ name: "showorder", label: "显示顺序", index: "showorder",width: 60, align:"center",sortable: true },
				{ name: "yxbz", label: "有效标志", index: "yxbz",hidden: true },
				{ name: "yxbzName", label: "有效标志", index: "yxbzName",width: 80, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var yxbzMap = { 'Y': '有效', 'N': '无效'};
					return yxbzMap[rowObject.yxbz] || '';
				} },
				{ name: "op", label: "操作", index: "op",width: 116, formatter: function(cellvalue, options, rowObject){
					return "<div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn del' style='float: none;display: inline-block;' title='删除'>删除</div>";
				} },
			];
			$("#sjbpz-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#sjbpz-tablePager',
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
					return $(".sjbpz .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#sjbpz-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('edit')){
						for (var key in self.modelData) {
							self.modelData[key] = row[key]
						}
						self.showModel('编辑');
						return false;
					}else if($(e.target).hasClass('del')){
						tools.confirm('是否确定删除该条数据？', '确定', function(){
              var params = {
                dsId: row.dsId,
                tablename: row.tablename
              }
							ajax("POST","/sszj/zbgl/tbl/del",params).done(function(res){
								if(res.code=='0'){
									tools.info('删除成功!');
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
					var pageNo=tools.getPageNo(pgButton,"sjbpz-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		showModel: function(title){
      this.addTitle = title
			this.modelData.action = title == '新增' ? '1' : '2'
			$('.model').show();
			$('.sjbpz .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.sjbpz .add-page-model').hide();
      this.modelData = {
        dsId:"",
				action: "",
        tablename:"",
        dsSchema:"",
        tablecname:"",
        isDict:"Y",
        showorder:"",
        yxbz:"Y",
      }
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.sjbpz')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#sjbpz-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/tbl/list",params).done(function(res){
				if(res.code=='0'){
					$("#sjbpz-table").resetSelection();
					$("#sjbpz-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
    exform:function(){
			var self=this;
			if($('#sjbpz-table').jqGrid('getRowData').length<=0){
				tools.info("请先查询列表");
				return ;
			}
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/sszj/export/zbgl/tbl");
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
        dsId:"",
        tablename:"",
        tablecname:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= avalonRoot.user.swjgMc;
		},
    saveModel: function(){
      var self = this
      var rules = [
        { name: 'dsId',  message: '数据源标识不能为空！'},
        { name: 'tablename',  message: '数据表名不能为空！'},
        { name: 'dsSchema',  message: '数据源用户不能为空！'},
        { name: 'tablecname',  message: '数据表中文名不能为空！'},
        { name: 'isDict',  message: '是否为代码表不能为空！'},
        { name: 'showorder',  message: '显示顺序不能为空！'},
        { name: 'yxbz',  message: '有效标志不能为空！'},
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return;
        }
      }
      ajax("POST","/sszj/zbgl/tbl/update",this.modelData).done(function(res){
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
		},
		getDsName: function(){
			var self = this
			ajax("POST","/sszj/zbgl/ds/name",{}).done(function(res){
				if(res.code=='0'){
					self.dsNameList = res.data
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		}
	}
});