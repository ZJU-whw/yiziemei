var zbypz=require("./zbypz.html");
avalon.component('zbypz', {
	template:zbypz,
	defaults: {
		params:{},
		act:1,
		tcode: "zbypz",
		searchData:{
      zbuCname:"",
      ywflDm:"",
      dsId:"",
      tablename:"",
      fieldname:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
      zbuId: "",
      zbuCname: "",
      zbuSname: "",
      ywflDm: "",
      datatype: "",
      ywms: "",
      dsId: "",
      tablename: "",
      fieldname: "",
      xztj: "",
      bbh: "",
      yxbz: "Y",
    },
    addTitle:"新增",
		ywflList: [],
		dsNameList: [],
		tblNameList: [],
		fieldNameList: [],
		onReady:function(){
			this.createTable();
			this.getYwfl();
			this.getDsName();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "zbuId", label: "指标元标识", index: "zbuId",width: 140, align:"left",sortable: true },
				{ name: "zbuCname", label: "指标元全称", index: "zbuCname",width: 150, align:"left",sortable: true },
				{ name: "zbuSname", label: "指标元简称", index: "zbuSname",width: 140, align:"left",sortable: true },
				{ name: "ywflDm", label: "业务分类代码", index: "ywflDm", hidden: true },
				{ name: "ywflDmName", label: "业务分类", index: "ywflDmName",width: 60, align:"left",sortable: true },
				{ name: "ywms", label: "业务描述", index: "ywms",width: 100, align:"left",sortable: true },
				{ name: "yxbz", label: "有效标志", index: "yxbz",hidden: true },
				{ name: "yxbzName", label: "有效标志", index: "yxbzName",width: 50, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var yxbzMap = { 'Y': '有效', 'N': '无效'};
					return yxbzMap[rowObject.yxbz];
				} },
				{ name: "datatype", label: "数据类型", index: "datatype",hidden: true },
				{ name: "datatypeName", label: "数据类型", index: "datatypeName",width: 50, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = {'1': '字符型', '2': '数值型', '3': '日期型', '4': '逻辑性'};
					return map[rowObject.datatype] || '';
				} },
				{ name: "xztj", label: "限制条件", index: "xztj",width: 80, align:"left",sortable: true },
				{ name: "dsId", label: "数据源", index: "dsId",width: 100, align:"left",sortable: true },
				{ name: "tablename", label: "数据表", index: "tablename",width: 120, align:"left",sortable: true },
				{ name: "fieldname", label: "数据项", index: "fieldname",width: 120, align:"left",sortable: true },
				{ name: "bbh", label: "版本号", index: "bbh",width: 50, align:"left",sortable: true },
				{ name: "op", label: "操作", index: "op",width: 116, formatter: function(cellvalue, options, rowObject){
					return "<div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn del' style='float: none;display: inline-block;' title='删除'>删除</div>";
				} },
			];
			$("#zbypz-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#zbypz-tablePager',
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
					return $(".zbypz .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#zbypz-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('edit')){
						for (var key in self.modelData) {
							self.modelData[key] = row[key]
						}
						self.showModel('编辑');
						return false;
					}else if($(e.target).hasClass('del')){
						tools.confirm('是否确定删除该条数据？', '确定', function(){
              var params = {
                zbuId: row.zbuId
              }
							ajax("POST","/sszj/zbgl/zbu/del",params).done(function(res){
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
					var pageNo=tools.getPageNo(pgButton,"zbypz-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		showModel: function(title){
      this.addTitle = title
			this.tblNameList = []
			this.fieldNameList = []
			if (title == '编辑') {
				this.getTblName()
				this.getFieldName()
			}
			$('.model').show();
			$('.zbypz .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.zbypz .add-page-model').hide();
      this.modelData = {
        zbuId: "",
        zbuCname: "",
        zbuSname: "",
        ywflDm: "",
        datatype: "",
        ywms: "",
        dsId: "",
        tablename: "",
        fieldname: "",
        xztj: "",
        bbh: "",
        yxbz: "Y",
      }
		},
    showHyper:function(){
			$('.zbypz .select-sub').toggle();
			$('.zbypz .select-wrapper .icon').toggleClass("active");
			if ($('.zbypz .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.zbypz .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.zbypz .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
    closeHyper:function(){
      $('.zbypz .select-sub').hide();
      $('.zbypz .select-wrapper .icon').removeClass('active');
      $('.zbypz .select-wrapper .icon').attr("title","展开查询条件");
    },
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.zbypz')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#zbypz-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/zbu/list",params).done(function(res){
				if(res.code=='0'){
					$("#zbypz-table").resetSelection();
					$("#zbypz-table")[0].addJSONData(res.data);
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
			if($('#zbypz-table').jqGrid('getRowData').length<=0){
				tools.info("请先查询列表");
				return ;
			}
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/sszj/export/zbgl/zbu");
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
        zbuCname:"",
        ywflDm:"",
        dsId:"",
        tablename:"",
        fieldname:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
		},
    saveModel: function(){
      var self = this
      var rules = [
        { name: 'zbuCname', message: '指标元全称不能为空！' },
        { name: 'zbuSname', message: '指标元简称不能为空！' },
        { name: 'ywflDm', message: '业务分类代码不能为空！' },
        { name: 'datatype', message: '数据类型不能为空！' },
        { name: 'ywms', message: '业务描述不能为空！' },
        { name: 'dsId', message: '数据源不能为空！' },
        { name: 'tablename', message: '数据表不能为空！' },
        { name: 'fieldname', message: '数据项不能为空！' },
        { name: 'xztj', message: '限制条件不能为空！' },
        { name: 'bbh', message: '版本号不能为空！' },
        { name: 'yxbz', message: '有效标志不能为空！' },
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return;
        }
      }
      ajax("POST","/sszj/zbgl/zbu/update",this.modelData).done(function(res){
				if(res.code=='0'){
          self.hideModel();
					tools.info('保存成功！');
          self.search(1);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    },
		getYwfl: function(){
			var self = this
			ajax("POST","/sszj/zbgl/zb/getYwfl",{dsId: this.modelData.dsId}).done(function(res){
				if(res.code=='0'){
					self.ywflList = res.data
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
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
				}else{
					self.tblNameList = []
					tools.info(res.msg);
				}
			}).fail(function(err){
				self.tblNameList = []
				tools.info(err);
			})
		},
		dsChange: function(){
			this.modelData.tablename = ''
			if (this.modelData.dsId != '') {
				this.getTblName()
			} else {
				this.tblNameList = []
			}
			this.tblChange()
		},
		tblChange: function(){
			this.modelData.fieldname = ''
			if (this.modelData.dsId != '' && this.modelData.tablename !='') {
				this.getFieldName()
			} else {
				this.fieldNameList = []
			}
		},
		getFieldName: function(){
			var self = this
			var params = {
				dsId: this.modelData.dsId,
				tablename: this.modelData.tablename
			}
			ajax("POST","/sszj/zbgl/field/name",params).done(function(res){
				if(res.code=='0'){
					self.fieldNameList = res.data
				}else{
					self.fieldNameList = []
					tools.info(res.msg);
				}
			}).fail(function(err){
				self.fieldNameList = []
				tools.info(err);
			})
		}
	}
});