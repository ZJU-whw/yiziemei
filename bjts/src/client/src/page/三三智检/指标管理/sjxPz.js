var sjxpz=require("./sjxpz.html");
avalon.component('sjxpz', {
	template:sjxpz,
	defaults: {
		params:{},
		act:1,
		tcode: "sjxpz",
		swjgmc: "",
		selRows: [],
		searchData:{
      dsId:"",
      tablename:"",
      fieldname:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
			action: '',
      dsId:"",
      tablename:"",
      fieldname: "",
      fieldcname: "",
      datatype: "",
      showformat: "0",
      showlength: "",
      showorder:"",
      yxbz:"Y",
    },
    addTitle:"新增",
		dsNameList: [], // 所有数据源的标识和名称列表
		tblNameList: [], // 指定数据源内所有数据表的表名和中文名
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
				{ name: "tablename", label: "数据表名", index: "tablename",hidden: true },
				{ name: "tablenameAndCname", label: "数据表名", index: "tablenameAndCname",width: 260, align:"left",sortable: true },
				{ name: "fieldname", label: "数据项名", index: "fieldname",width: 120, align:"left",sortable: true },
				{ name: "fieldcname", label: "数据项名称", index: "fieldcname",width: 140, align:"left",sortable: true },
				{ name: "datatype", label: "数据类型", index: "datatype",hidden: true },
				{ name: "datatypeName", label: "数据类型", index: "datatypeName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = {'1': '字符型', '2': '数值型', '3': '日期型', '4': '逻辑性'};
					return map[rowObject.datatype] || '';
				} },
				{ name: "showformat", label: "数据格式", index: "showformat",hidden: true },
				{ name: "showformatName", label: "数据格式", index: "showformatName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = {'0': '默认', '1': '金额', '2': '整数', '3': '百分比'};
					return map[rowObject.showformat] || '';
				} },
				{ name: "showlength", label: "显示长度", index: "showlength",width: 60, align:"center",sortable: true },
				{ name: "showorder", label: "显示顺序", index: "showorder",width: 60, align:"center",sortable: true },
				{ name: "yxbz", label: "有效标志", index: "yxbz",hidden: true },
				{ name: "yxbzName", label: "有效标志", index: "yxbzName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var yxbzMap = { 'Y': '有效', 'N': '无效'};
					return yxbzMap[rowObject.yxbz];
				} },
				{ name: "op", label: "操作", index: "op",width: 116, formatter: function(cellvalue, options, rowObject){
					return "<div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn del' style='float: none;display: inline-block;' title='删除'>删除</div>";
				} },
			];
			$("#sjxpz-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#sjxpz-tablePager',
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
					return $(".sjxpz .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#sjxpz-table").jqGrid("getRowData", rowid)
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
                tablename: row.tablename,
                fieldname: row.fieldname
              }
							ajax("POST","/sszj/zbgl/field/del",params).done(function(res){
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
					self.searchData.orderSql = index + ' ' + sortorder;
					self.search(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"sjxpz-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		showModel: function(title){
      this.addTitle = title
			this.modelData.action = title == '新增' ? '1' : '2'
			this.tblNameList = []
			$('.model').show();
			$('.sjxpz .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.sjxpz .add-page-model').hide();
      this.modelData = {
				action:"",
        dsId:"",
        tablename:"",
        fieldname: "",
        fieldcname: "",
        datatype: "",
        showformat: "0",
        showlength: "",
        showorder:"",
        yxbz:"Y",
      }
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.sjxpz')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#sjxpz-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/field/list",params).done(function(res){
				if(res.code=='0'){
					$("#sjxpz-table").resetSelection();
					$("#sjxpz-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
    exform:function(){
			var self=this;
			if($('#sjxpz-table').jqGrid('getRowData').length<=0){
				tools.info("请先查询列表");
				return ;
			}
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/sszj/export/zbgl/field");
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
        fieldname:"",
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
        { name: 'fieldname', message: '数据项名不能为空！'},
        { name: 'fieldcname', message: '数据项名称不能为空！'},
        { name: 'datatype', message: '数据类型不能为空！'},
        { name: 'showformat', message: '数据格式不能为空！'},
        { name: 'showlength', message: '显示长度不能为空！'},
        { name: 'showorder',  message: '显示顺序不能为空！'},
        { name: 'yxbz',  message: '有效标志不能为空！'},
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return;
        }
      }
      ajax("POST","/sszj/zbgl/field/update",this.modelData).done(function(res){
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
		showlengthChange: function(){
			if (this.modelData.showlength.length == 1) {
				this.modelData.showlength = this.modelData.showlength.replace(/[^1-9]/g,'');
			} else {
				this.modelData.showorder = this.modelData.showorder.replace(/\D/g,'');
			}
			if (this.modelData.showlength > 100) {
				this.modelData.showlength = 100
			}
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
		},
		getTblName: function(){
			var self = this
			ajax("POST","/sszj/zbgl/tbl/name",{dsId: this.modelData.dsId}).done(function(res){
				if(res.code=='0'){
					self.tblNameList = res.data
					self.modelData.tablename = ''
				}else{
					self.tblNameList = []
					self.modelData.tablename = ''
					tools.info(res.msg);
				}
			}).fail(function(err){
				self.tblNameList = []
				self.modelData.tablename = ''
				tools.info(err);
			})
		},
		dsChange: function(){
			if (this.modelData.dsId != '') {
				this.getTblName()
			} else {
				this.tblNameList = []
				this.modelData.tablename = ''
			}
		}
	}
});