var fxywywh=require("./fxywywh.html");
avalon.component('fxywywh', {
	template:fxywywh,
	defaults: {
		params:{},
		act:1,
		tcode: "fxywywhcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			qybs:"",
			zjhm:"",
			xm:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
      zjhm:"",
      xm:"",
      fxlx:"1",
      fxqkms:"",
			sjqyhs: ""
    },
    addTitle:"新增",
    oldZjhm:"",
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjg_dm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
			this.createTable();
      this.importCallBack();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "xm", label: "业务员姓名", index: "xm",width: 80, align:"left",sortable: true },
				{ name: "zjhm", label: "证件号码", index: "zjhm",width: 150, align:"left",sortable: true },
				{ name: "sjqyhs", label: "备案企业户数", index: "sjqyhs",width: 80, align:"right",sortable: true },
				{ name: "fxlx", label: "风险情况", index: "fxlx",hidden: true },
				{ name: "fxlxName", label: "风险情况", index: "fxlxName",width: 80, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
					var fxlxMap = {'1': '骗税', '2': '违规退税', '3': '出口风险商品', '4': '其他'}
					return fxlxMap[rowObject.fxlx] || '';
				} },
				{ name: "fxqkms", label: "风险具体情况", index: "fxqkms",width: 160, align:"left",sortable: true },
				{ name: "swjgDm", label: "录入税务机关", index: "swjgDm",width: 90, align:"center",sortable: true },
				{ name: "op", label: "操作", index: "op",width: 116, formatter: function(cellvalue, options, rowObject){
					return "<div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn del' style='float: none;display: inline-block;' title='删除'>删除</div>";
				} },
			];
			$("#fxywywh-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#fxywywh-tablePager',
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
					return $(".fxywywh .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#fxywywh-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('edit')){
						self.modelData = {
							id: row.id,
							zjhm: row.zjhm,
							xm: row.xm,
							fxlx: row.fxlx,
							fxqkms: row.fxqkms,
							sjqyhs: row.sjqyhs
						}
						self.showModel('编辑');
						return false;
					}else if($(e.target).hasClass('del')){
						tools.confirm('是否确定删除该条业务员数据？', '确定', function(){
							ajax("POST","/sszj/fxywy/del",{id: row.id}).done(function(res){
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
					var pageNo=tools.getPageNo(pgButton,"fxywywh-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		showModel: function(title){
      this.addTitle = title
			$('.model').show();
			$('.fxywywh .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.fxywywh .add-page-model').hide();
			this.modelData = {
				zjhm:"",
				xm:"",
				fxlx:"1",
				fxqkms:"",
				sjqyhs: ""
			}
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.fxywywh')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#fxywywh-table").jqGrid('clearGridData')
			ajax("POST","/sszj/fxywy/list",params).done(function(res){
				if(res.code=='0'){
					$("#fxywywh-table").resetSelection();
					$("#fxywywh-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
    exformModel:function(){
			var self=this;
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/sszj/export/fxqymc/template");
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
				qybs:"",
				zjhm:"",
				xm:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= avalonRoot.user.swjgMc;
		},
    getYwyxx: function(){
      if (this.modelData.zjhm == this.oldZjhm) return;
      this.oldZjhm = this.modelData.zjhm
			ajax("POST","/sszj/ywyba/getxm",{zjhm:this.modelData.zjhm}).done(function(res){
				if(res.code=='0' && res.data){
					this.modelData.xm = res.data.xm;
					this.modelData.sjqyhs = res.data.sjqyhs;
				}
			})
    },
    saveModel: function(){
			var self = this
      var rules = [
				{ name: 'zjhm', message: '证件号码不能为空！' },
				{ name: 'xm', message: '业务员姓名不能为空！' },
				{ name: 'fxlx', message: '风险情况不能为空！' }
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return;
        }
      }
			ajax("POST","/sszj/fxywy/update",this.modelData).done(function(res){
				if(res.code=='0'){
					self.search(1);
					self.hideModel();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    },
    showImportModel: function(){
      $('.model').show();
			$('.fxywywh .import-page-model').show();
    },
    hideImportModel: function(){
      $('.model').hide();
			$('.fxywywh .import-page-model').hide();
    },
    importCallBack: function(){
      var self = this;
      $('#fxywywhFileupload').fileupload({
        dataType: 'json',
        acceptFileTypes: /(xls|xlsx)$/i,
        maxFileSize: 4000000, // 限制大小4M
        done: function (e, data) {
          if (data.result.code == "0") {
              tools.info("导入成功!");
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
		numberLimit: function(){
			this.modelData.sjqyhs = this.modelData.sjqyhs.replace(/\D/g,'');
		}
	}
});