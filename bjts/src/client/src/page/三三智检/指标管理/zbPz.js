var zbpz=require("./zbpz.html");
avalon.component('zbpz', {
	template:zbpz,
	defaults: {
		params:{},
		act:1,
		tcode: "zbpz",
		searchData:{
      zbCname:"",
      ywflDm:"",
      applyQy:"",
      refreshCycle:"",
      yxbz:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
      zbId: '',
      zbCname: '',
      zbSname: '',
      zbType: '',
      ywflDm: '',
      datatype: '',
      showformat: '0',
      applyQy: '',
      zbFomula: '',
      refreshCycle: '',
      ywms: '',
      bbh: '',
      jsYxj: '',
      yxbz: 'Y',
			operation: '',
			rsType: ''
    },
    addTitle:"新增",
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
				{ name: "op2", label:"操作", width: 0, frozen: true, align:"center", resizable: false, sortable: false,formatter: function(cellvalue, options, rowObject){
					return "<div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn del' style='float: none;display: inline-block;' title='删除'>删除</div>";
				}},
				{ name: "zbId", label: "指标标识", index: "zbId",width: 80, align:"left",sortable: true },
				{ name: "zbCname", label: "指标名称", index: "zbCname", hidden: true },
				{ name: "zbCnameTmp", label: "指标名称", index: "zbCnameTmp",width: 150, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<span class='link'>"+rowObject.zbCname+"</span>";
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
				{ name: "op", label: "操作", width: 160, align: "center", resizable: false, search: false, sortable: false},
			];
			if (!this.isAdmin) {
				columns.splice(0,1);
				columns.splice(-1,1);
			}
			$("#zbpz-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#zbpz-tablePager',
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
					return $(".zbpz .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#zbpz-table").jqGrid("getRowData", rowid)
          if($(e.target).hasClass('link')){
						var params = {
							zbId: row.zbId,
							zbCname: row.zbCname,
							datatype: row.datatype,
							ywms: row.ywms,
							zbFomula: row.zbFomula
						}
						avalonRoot.addTab({title:"指标配置详情",component:"zbpzmx",params:params});
						return false;
					}else if($(e.target).hasClass('edit')){
						for (var key in self.modelData) {
							self.modelData[key] = row[key]
						}
						self.showModel('2');
						return false;
					}else if($(e.target).hasClass('del')){
						tools.confirm('是否确定删除该条数据？', '确定', function(){
              var params = {
                zbId: row.zbId
              }
							ajax("POST","/sszj/zbgl/zb/del",params).done(function(res){
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
					var pageNo=tools.getPageNo(pgButton,"zbpz-table");
					self.search(pageNo);
				}
			});
			
			$("#zbpz-table").jqGrid('setFrozenColumns');
			if (this.isAdmin) {
				tools.HeiKjNoSel('zbpz', 'zbpz-table');
			}
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		showModel: function(operation){
      this.addTitle = operation == '1' ? '新增' : '编辑'
			this.modelData.operation = operation
			$('.model').show();
			$('.zbpz .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.zbpz .add-page-model').hide();
      this.modelData = {
        zbId: '',
        zbCname: '',
        zbSname: '',
        zbType: '',
        ywflDm: '',
        datatype: '',
        showformat: '0',
        applyQy: '',
        zbFomula: '',
        refreshCycle: '',
        ywms: '',
        bbh: '',
        jsYxj: '',
        yxbz: 'Y',
				operation: '',
				rsType: ''
      }
		},
    showHyper:function(){
			$('.zbpz .select-sub').toggle();
			$('.zbpz .select-wrapper .icon').toggleClass("active");
			if ($('.zbpz .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.zbpz .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.zbpz .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
    closeHyper:function(){
      $('.zbpz .select-sub').hide();
      $('.zbpz .select-wrapper .icon').removeClass('active');
      $('.zbpz .select-wrapper .icon').attr("title","展开查询条件");
    },
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.zbpz')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#zbpz-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/zb/list",params).done(function(res){
				if(res.code=='0'){
					$("#zbpz-table").resetSelection();
					$("#zbpz-table")[0].addJSONData(res.data);
					if (self.isAdmin) {
						tools.HeiKjNoSel('zbpz', 'zbpz-table');
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
			if($('#zbpz-table').jqGrid('getRowData').length<=0){
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
    saveModel: function(){
      var self = this
      var rules = [
        { name: 'zbId', message: '指标标识不能为空！' },
        { name: 'zbCname', message: '指标名称不能为空！' },
        { name: 'zbSname', message: '指标简称不能为空！' },
        { name: 'zbType', message: '指标类型不能为空！' },
        { name: 'ywflDm', message: '业务分类代码不能为空！' },
        { name: 'datatype', message: '数据类型不能为空！' },
        { name: 'showformat', message: '显示格式不能为空！' },
        { name: 'applyQy', message: '适用企业不能为空！' },
        { name: 'zbFomula', message: '指标公式不能为空！' },
        { name: 'refreshCycle', message: '刷新周期不能为空！' },
        { name: 'ywms', message: '业务描述不能为空！' },
        { name: 'bbh', message: '版本号不能为空！' },
        { name: 'jsYxj', message: '计算优先级不能为空！' },
        { name: 'yxbz', message: '有效标志不能为空！' },
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return;
        }
      }
			var params = tools.clone(this.modelData)
      ajax("POST","/sszj/zbgl/zb/update",params).done(function(res){
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
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.zbpz').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.zbpz').off('click');
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
		},
		numberLimit: function(){
			this.modelData.jsYxj = this.modelData.jsYxj.replace(/\D/g,'');
		}
	}
});