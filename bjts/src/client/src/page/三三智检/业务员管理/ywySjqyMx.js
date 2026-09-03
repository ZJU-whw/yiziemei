var ywysjqymx=require("./ywysjqymx.html");
avalon.component('ywysjqymx', {
	template:ywysjqymx,
	defaults: {
		params:{},
		act:1,
		tcode: "ywybacx",
		swjgmc: "",
		selRows: [],
		searchData:{
			qybs:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		imgSrc: '',
		onReady:function(){
      this.searchData.qybs = this.params.nsrsbh;
			this.createTable();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "xm", label: "业务员姓名", index: "xm",width: 80, align:"left",sortable: true },
				{ name: "sex", label: "性别", index: "sex",width: 40, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '1': '男', '2': '女'};
					return map[cellvalue];
				} },
				{ name: "zjhm", label: "证件号码", index: "zjhm",width: 150, align:"left",sortable: false },
				{ name: "phone", label: "手机号码", index: "phone",width: 90, align:"left",sortable: true },
				{ name: "status", label: "业务员状态", index: "status",width: 70, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '1': '在职', '0': '离职'};
					return map[cellvalue];
				} },
				{ name: "gzrqQ", label: "工作日期起", index: "gzrqQ",width: 80, align:"center",sortable: true },
				{ name: "gzrqZ", label: "工作日期止", index: "gzrqZ",width: 80, align:"center",sortable: true },
				{ name: "ckcpfw", label: "出口产品范围", index: "ckcpfw",width: 80, align:"center",sortable: true },
				{ name: "sfqdldht", label: "是否签订劳动合同", index: "sfqdldht",width: 100, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				} },
				{ name: "sfdjsb", label: "是否代缴社保", index: "sfdjsb",width: 80, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				}},
				{ name: "ywyly", label: "业务员来源", index: "ywyly",width: 90, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '1': '他人介绍', '2': '招聘', '3': '企业法人/投资方/实际管理人', '4': '其他'};
					return map[cellvalue] || '';
				}  },
				{ name: "sjqyhs", label: "涉及企业户数", index: "sjqyhs",width: 80, align:"right",sortable: false},
				{ name: "sffxywy", label: "是否风险业务员", index: "sffxywy",width: 90, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				} },
				{ name: "zfbz", label: "作废标志", index: "zfbz",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				} },
				{ name: "bazt", label: "备案状态", index: "bazt",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '0': '未备案', '1': '备案中', '2': '已备案', '3': '备案退回'};
					return map[cellvalue] || '';
				} },
				{ name: "thyy", label: "退回原因", index: "thyy",width: 90, align:"left",sortable: true },
				{ name: "thsj", label: "退回时间", index: "thsj",width: 130, align:"center",sortable: true },
				{ name: "zfsj", label: "作废时间", index: "zfsj",width: 130, align:"center",sortable: true },
				{ name: "tjsj", label: "提交时间", index: "tjsj",width: 130, align:"center",sortable: true },
				{ name: "basj", label: "备案时间", index: "basj",width: 130, align:"center",sortable: true },
				{ name: "zp", label: "证件照片", index: "zp",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<span class='link fj' title='查看'>查看</span>";
				} },
				{ name: "sfjznr64", label: "base64图片内容", index: "sfjznr64", hidden: true, formatter: function(cellvalue, options, rowObject){
					return cellvalue ? cellvalue : '';
				}}
			];
			$("#ywysjqymx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#ywysjqymx-tablePager',
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
					return $(".ywysjqymx .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if($(e.target).hasClass('fj')){
						var imgSrc = getCellData("ywysjqymx-table", rowid, 'sfjznr64')
						if (imgSrc) {
							self.imgSrc = 'data:image/png;base64,'+ imgSrc
						} else {
							self.imgSrc = ''
						}
						self.showModel();
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
					var pageNo=tools.getPageNo(pgButton,"ywysjqymx-table");
					self.search(pageNo);
				}
			});
			this.searchData.pageSize = $(".ui-pg-selbox", $('.ywysjqymx')).val();
			self.search(1);
		},
		showModel: function(){
			$('.model').show();
			$('.ywysjqymx .page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.ywysjqymx .page-model').hide();
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.ywysjqymx')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#ywysjqymx-table").jqGrid('clearGridData')
			ajax("POST","/sszj/ywyba/list",params).done(function(res){
				if(res.code=='0'){
					$("#ywysjqymx-table").resetSelection();
					$("#ywysjqymx-table")[0].addJSONData(res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
	}
});