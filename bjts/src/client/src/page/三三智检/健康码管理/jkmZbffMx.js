var jkmZbffMx=require("./jkmZbffMx.html");
avalon.component('jkmZbffMx', {
	template:jkmZbffMx,
	defaults: {
		params:{},
		act:1,
		tcode: "jkmZbffMxcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			djxh:"",
			zbFf:"",
			zbpd:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		imgSrc: '',
		dataForm: {},
		xzDataList: [],
		modelData: {
			nsrsbh: '',
			nsrmc: '',
			jkmY: '',
			yxq: ''
		},
    onInit: function onInit(e) {
      components.jkmZbffMx = e.vmodel;
    },
		onReady:function(){
      this.searchData.djxh = this.params.djxh
			this.createTable();
			this.getJkmY();
			this.initDate();
		},
		initDate: function(){
			var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
			$('.jkmZbffMx .datepicker.date-day').datetimepicker(options);
    },
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "djxh", label: "登记序号", index: "djxh",hidden: true },
				{ name: "zbSname", label: "指标简称", index: "zbSname",hidden: true },
				{ name: "ywflJc", label: "分类", index: "ywflJc",width: 60, align:"left",sortable: false},
				{ name: "zbId", label: "指标编号", index: "zbId",width: 90, align:"left",sortable: true},
				{ name: "zbCname", label: "指标名称", index: "zbCname",width: 200, align:"left",sortable: true },
				{ name: "zbVal", label: "结果值", index: "zbVal",width: 80, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
					if (rowObject.zbVal) {
						return "<div class='link op-showResult'>"+rowObject.zbVal+"</div>";
					} else {
						return "";
					}
				}  },
				{ name: "rsType", label: "结果类型", index: "rsType",width: 60, align:"center",sortable: true },
				{ name: "score", label: "指标赋分", index: "score",width: 60, align:"center",sortable: true },
				{ name: "uptime", label: "更新时间", index: "uptime",width: 140, align:"center",sortable: false },
				{ name: "hcjgStr", label: "评定结果", index: "hcjgStr",width: 80, align:"center",sortable: false },
				{ name: "hcyj", label: "情况描述", index: "hcyj",width: 140, align:"left",sortable: false },
				{ name: "hcr", label: "评定人", index: "hcr",width: 80, align:"center",sortable: false },
				{ name: "applyQy", label: "适用", index: "applyQy",width: 60, align:"center",sortable: false },
				{ name: "ywms", label: "指标描述", index: "ywms",width: 300, align:"left",sortable: false },
			];
			$("#jkmZbffMx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: 9999,
				width:"100%",
				height:(function(){
					return $(".jkmZbffMx .form").height() -40;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#jkmZbffMx-table").jqGrid("getRowData", rowid);
					if($(e.target).hasClass('op-showResult')){
						self.dataForm = row
            self.showModelResult()
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
				}
			});
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jkmZbffMx')).val();
			self.search(1);
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jkmZbffMx')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#jkmZbffMx-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbgl/qyjkm/mx/list",params).done(function(res){
				if(res.code=='0'){
					$("#jkmZbffMx-table").resetSelection();
					$("#jkmZbffMx-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		reset: function() {
			this.searchData = {
				djxh:this.params.djxh,
				zbFf:"",
				zbpd:"",
				orderSql:"",
				pageSize:config.pageSize
			}
		},
		add: function(){
      var self = this
			api.jkmpdCheckJkmPd({nsrsbh:this.params.nsrsbh}).done(function(res){
				if(res.code=='0'){
					$('.model').show();
					$('.jkmZbffMx .add-page-model').show();
					self.modelData = {
						nsrsbh: self.params.nsrsbh,
						nsrmc: self.params.nsrmc,
						jkmY: self.modelData.jkmY,
						yxq: ''
					}
				}
			})
    },
		showModelResult: function(){
			var self = this
			api.jkmpdGetZbFfMxXz({nsrsbh:this.params.nsrsbh, zbId: this.dataForm.zbId}).done(function(res){
				if(res.code=='0'){
					$('.model').show();
					$('.jkmZbffMx .result-page-model').show();
					self.xzDataList = res.data.dataList || []
				}
			})
		},
		hideModelResult: function(){
			$('.model').hide();
			$('.jkmZbffMx .result-page-model').hide();
		},
		saveAdd: function(){
			var self = this
			api.jkmpdAdd(this.modelData).done(function(res){
				if(res.code=='0'){
					self.hideModelAdd();
					tools.confirm('评定记录新增成功，是否跳转至健康码评定页面进行评定？','确定',function(){
						avalonRoot.addTab({title:"健康码评定",component:"jkmPd",params:{qybs:self.params.nsrsbh}});
					});
        }
      })
		},
		hideModelAdd: function(){
      $('.model').hide();
      $('.jkmZbffMx .add-page-model').hide();
		},
		getJkmY: function(){
			var self = this
			api.getJkmY({nsrsbh: this.params.nsrsbh}).done(function(res){
				if(res.code=='0'){
					self.modelData.jkmY = res.data.jkmY
        }
      })
		}
	}
});