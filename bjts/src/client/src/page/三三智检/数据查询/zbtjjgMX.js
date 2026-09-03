var zbtjjgMX=require("./zbtjjgMX.html");
avalon.component('zbtjjgMX', {
	template:zbtjjgMX,
	defaults: {
		params:{
			djxh: '',
			bgqId: '',
			bgqIdJq: ''
		},
		act:1,
		tcode: "zbtjjgMX",
		activeName: 'jcxx',
		tabNum: '1',
		orderSqlObj: {},
		searchMxData: {
			pageSize: 20,
			orderSql: ''
		},
		tabList: [
			{ name: '基础信息', activeName: 'jcxx', isFirst: true, columns: 'jcxxColumns', url: '/sszj/zbdata/qyxx', isPager: false, tabNum: '1', hasTotal: false},
			{ name: '指标数据', activeName: 'zbsj', isFirst: true, columns: 'zbsjColumns', url: '/sszj/zbdata/zbxx', isPager: true, tabNum: '2', hasTotal: false},
			{ name: '年度单项数据', activeName: 'nddxsj', isFirst: true, columns: 'nddxsjColumns', url: '/sszj/zbdata/zbu4year', isPager: false, tabNum: '3', hasTotal: false},
			{ name: '按出口国别', activeName: 'ackgb', isFirst: true, columns: 'ackgbColumns', url: '/sszj/zbdata/ckgb', isPager: true, tabNum: '4', hasTotal: true},
			{ name: '按出口商品', activeName: 'acksp', isFirst: true, columns: 'ackspColumns', url: '/sszj/zbdata/cksp', isPager: true, tabNum: '5', hasTotal: true},
			{ name: '按出口口岸', activeName: 'ackka', isFirst: true, columns: 'ackkaColumns', url: '/sszj/zbdata/ckka', isPager: true, tabNum: '6', hasTotal: true},
			{ name: '按退税商品', activeName: 'atssp', isFirst: true, columns: 'atsspColumns', url: '/sszj/zbdata/tssp', isPager: true, tabNum: '7', hasTotal: true},
			{ name: '按退税供货', activeName: 'atsgh', isFirst: true, columns: 'atsghColumns', url: '/sszj/zbdata/tsghf', isPager: true, tabNum: '8', hasTotal: false},
			{ name: '按底账商品进项', activeName: 'adzspjx', isFirst: true, columns: 'adzspColumns', url: '/sszj/zbdata/dzspjx', isPager: true, tabNum: '9', hasTotal: false},
			{ name: '按底账商品销项', activeName: 'adzspxx', isFirst: true, columns: 'adzspColumns', url: '/sszj/zbdata/dzspxx', isPager: true, tabNum: '10', hasTotal: false},
			{ name: '按发票上游', activeName: 'afpsy', isFirst: true, columns: 'afpsyColumns', url: '/sszj/zbdata/zbudzxf', isPager: true, tabNum: '11', hasTotal: false},
			{ name: '按发票下游', activeName: 'afpxy', isFirst: true, columns: 'afpxyColumns', url: '/sszj/zbdata/zbudzgf', isPager: true, tabNum: '12', hasTotal: false},
		],
		jcxxColumns: [
			{ name: "dataId", label: "数据标识", index: "dataId",width: 100, align:"left",sortable: true },
			{ name: "dataName", label: "数据名称", index: "dataName",width: 200, align:"left",sortable: true },
			{ name: "bgqValue", label: "报告期值", index: "bgqValue",width: 200, align:"left",sortable: false },
			{ name: "jqValue", label: "基期值", index: "jqValue",width: 200, align:"left",sortable: false },
		],
		zbsjColumns: [
			{ name: "zbId", label: "指标Id", index: "zbId",width: 80, align:"left",sortable: true },
			{ name: "zbSname", label: "指标名称", index: "zbSname",width: 200, align:"left",sortable: true },
			{ name: "rsType", label: "结果类型", index: "rsType",width: 100, align:"center",sortable: true },
			{ name: "zbVal", label: "报告期值", index: "zbVal",width: 100, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
				if (rowObject.zbVal) {
					return "<div class='link op-showResult'>"+rowObject.zbVal+"</div>";
				} else {
					return "";
				}
			}  },
			{ name: "badpoint", label: "坏点", index: "badpoint",width: 60, align:"center",sortable: true },
			{ name: "zbValJq", label: "基期值", index: "zbValJq",width: 100, align:"center",sortable: true },
			{ name: "badpointJq", label: "基期坏点", index: "badpointJq",width: 60, align:"center",sortable: true },
			{ name: "ywms", label: "指标描述", index: "ywms",width: 300, align:"center",sortable: true },
		],
		nddxsjColumns: [
			{ name: "dataId", label: "数据标识", index: "dataId",width: 140, align:"left",sortable: true },
			{ name: "dataName", label: "数据名称", index: "dataName",width: 200, align:"left",sortable: true },
			{ name: "bgqValue", label: "报告期值", index: "bgqValue",width: 200, align:"right",sortable: true },
			{ name: "jqValue", label: "基期值", index: "jqValue",width: 200, align:"right",sortable: true },
		],
		ackgbColumns: [
			{ name: "gbDm", label: "国别代码", index: "gbDm",width: 100, align:"left",sortable: true },
			{ name: "gbMc", label: "国别名称", index: "gbMc",width: 100, align:"left",sortable: true },
			{ name: "ckeusd", label: "出口额USD", index: "ckeusd",width: 140, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} , isTotal: true},
			{ name: "ckermb", label: "出口额", index: "ckermb",width: 140, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} , isTotal: true},
			{ name: "ckezb", label: "出口额占比(%)", index: "ckezb",width: 140, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return cellvalue !== '' && avalon.filters.number(cellvalue,2);}},
			{ name: "kasl", label: "口岸数量", index: "kasl",width: 100, align:"right",sortable: true, formatter: function(cellvalue, options, rowObject){
				if (rowObject.kasl) {
					return "<div class='link op-showCkgb' data-mxType='1' data-type='gbDm' data-code='gbDm'>"+rowObject.kasl+"</div>";
				} else {
					return "";
				}
			}},
			{ name: "sbdwsl", label: "申报单位数量", index: "sbdwsl",width: 100, align:"right",sortable: true, formatter: function(cellvalue, options, rowObject){
				if (rowObject.sbdwsl) {
					return "<div class='link op-showCkgb' data-mxType='2' data-type='gbDm' data-code='gbDm'>"+rowObject.sbdwsl+"</div>";
				} else {
					return "";
				}
			}},
			{ name: "ysfssl", label: "运输方式数量", index: "ysfssl",width: 100, align:"right",sortable: true, formatter: function(cellvalue, options, rowObject){
				if (rowObject.ysfssl) {
					return "<div class='link op-showCkgb' data-mxType='3' data-type='gbDm' data-code='gbDm'>"+rowObject.ysfssl+"</div>";
				} else {
					return "";
				}
			}},
			{ name: "mgbz", label: "敏感标志", index: "mgbz",width: 100, align:"center",sortable: true },
		],
		ackspColumns: [
			{ name: "spdm", label: "商品代码", index: "spdm",width: 100, align:"left",sortable: true },
			{ name: "spmc", label: "商品名称", index: "spmc",width: 200, align:"left",sortable: true },
			{ name: "ckeusd", label: "出口额USD", index: "ckeusd",width: 140, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);}  , isTotal: true},
			{ name: "ckermb", label: "出口额", index: "ckermb",width: 140, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);}  , isTotal: true},
			{ name: "ckezb", label: "出口额占比(%)", index: "ckezb",width: 140, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return cellvalue !== '' && avalon.filters.number(cellvalue,2);}},
			{ name: "ckdj", label: "出口单价", index: "ckdj",width: 100, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return cellvalue !== '' && avalon.filters.number(cellvalue,2);}},
			{ name: "cksl", label: "出口数量", index: "cksl",width: 100, align:"right",sortable: true },
			{ name: "mgbz", label: "敏感标志", index: "mgbz",width: 100, align:"center",sortable: true },
			{ name: "newbz", label: "跨大类标志", index: "newbz",width: 80, align:"center",sortable: true },
		],
		ackkaColumns: [
			{ name: "ckkadm", label: "口岸代码", index: "ckkadm",width: 100, align:"left",sortable: true },
			{ name: "ckkamc", label: "口岸名称", index: "ckkamc",width: 200, align:"left",sortable: true },
			{ name: "ckeusd", label: "出口额USD", index: "ckeusd",width: 100, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);}  , isTotal: true},
			{ name: "ckermb", label: "出口额", index: "ckermb",width: 100, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);}  , isTotal: true},
			{ name: "ckezb", label: "出口额占比(%)", index: "ckezb",width: 140, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return cellvalue !== '' && avalon.filters.number(cellvalue,2);}},
			{ name: "sbdwsl", label: "申报单位数量", index: "sbdwsl",width: 100, align:"right",sortable: true, formatter: function(cellvalue, options, rowObject){
				if (rowObject.sbdwsl) {
					return "<div class='link op-showCkgb' data-mxType='2' data-type='kaDm' data-code='ckkadm'>"+rowObject.sbdwsl+"</div>";
				} else {
					return "";
				}
			}},
			{ name: "mgbz", label: "敏感标志", index: "mgbz",width: 100, align:"center",sortable: true },
		], 
		atsspColumns: [
			{ name: "ckspdm", label: "商品代码", index: "ckspdm",width: 80, align:"left",sortable: true },
			{ name: "ckspmc", label: "商品名称", index: "ckspmc",width: 140, align:"left",sortable: true },
			{ name: "ckeusd", label: "出口额USD", index: "ckeusd",width: 100, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);}  , isTotal: true},
			{ name: "ckermb", label: "出口额", index: "ckermb",width: 100, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);}  , isTotal: true},
			{ name: "ckezb", label: "出口额占比(%)", index: "ckezb",width: 140, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return cellvalue !== '' && avalon.filters.number(cellvalue,2);}},
			{ name: "ckermbStzc", label: "视同自产出口额", index: "ckermbStzc",width: 100, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);}  , isTotal: true},
			{ name: "cksl", label: "出口数量", index: "cksl",width: 90, align:"right",sortable: true },
			{ name: "ckdj", label: "出口单价(USD)", index: "ckdj",width: 100, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return cellvalue !== '' && avalon.filters.number(cellvalue,2);}},
			{ name: "ckdjrmb", label: "出口单价(CNY)", index: "ckdjrmb",width: 100, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){
				var ckdjrmb =  rowObject.ckermb /  rowObject.cksl
				return rowObject.ckdj !== '' && avalon.filters.number(ckdjrmb,2);
			}},
			{ name: "sbtmse", label: "申报退免税额", index: "sbtmse",width: 100, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);}  , isTotal: true},
			{ name: "jhje", label: "进货金额", index: "jhje",width: 100, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);}  , isTotal: true},
			{ name: "jhdj", label: "进货单价(CNY)", index: "jhdj",width: 100, align:"right",sortable: true , formatter:function(cellvalue, options, rowObject){return cellvalue !== '' && avalon.filters.number(cellvalue,2);}},
			{ name: "mmylr", label: "每美元利润", index: "mmylr",width: 80, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return cellvalue !== '' && avalon.filters.number(cellvalue,2);}},
			{ name: "mgbz", label: "敏感标志", index: "mgbz",width: 60, align:"center",sortable: true },
		], 
		atsghColumns: [
			{ name: "ghfsh", label: "供货企业税号", index: "ghfsh",width: 160, align:"left",sortable: true },
			{ name: "qymc", label: "供货企业名称", index: "qymc",width: 160, align:"left",sortable: true },
			{ name: "sfmc", label: "省份名称", index: "sfmc",width: 80, align:"left",sortable: true },
			{ name: "jhje", label: "供货金额", index: "jhje",width: 120, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} },
			{ name: "tse", label: "退税额", index: "tse",width: 100, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} },
			{ name: "fxqybz", label: "风险企业标志", index: "fxqybz",width: 100, align:"center",sortable: true },
			{ name: "fxdqbz", label: "风险地区标志", index: "fxdqbz",width: 100, align:"center",sortable: true },
			{ name: "snwbz", label: "省内外标志", index: "snwbz",width: 100, align:"center",sortable: true },
			{ name: "fzchbz", label: "非正常户标志", index: "fzchbz",width: 100, align:"center",sortable: true },
			{ name: "newbz", label: "新增标志", index: "newbz",width: 80, align:"center",sortable: true },
			{ name: "swjgdm", label: "税务机关代码", index: "swjgdm",width: 100, align:"left",sortable: true },
		], 
		adzspColumns: [
			{ name: "spmc", label: "商品名称", index: "spmc",width: 200, align:"left",sortable: true },
			{ name: "spsm", label: "商品税目", index: "spsm",width: 160, align:"left",sortable: true },
			{ name: "je", label: "金额", index: "je",width: 160, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} },
			{ name: "se", label: "税额", index: "se",width: 160, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} }
		], 
		afpsyColumns: [
			{ name: "xfsbh", label: "销方税号", index: "xfsbh",width: 180, align:"left",sortable: true },
			{ name: "xfmc", label: "销方名称", index: "xfmc",width: 210, align:"left",sortable: true },
			{ name: "fs", label: "发票份数", index: "fs",width: 80, align:"right",sortable: true },
			{ name: "je", label: "金额", index: "je",width: 160, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} },
			{ name: "se", label: "税额", index: "se",width: 140, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} },
			{ name: "zyspmc", label: "主要商品名称", index: "zyspmc",width: 210, align:"left",sortable: true },
			{ name: "zyspje", label: "主要商品金额", index: "zyspje",width: 160, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} }
		], 
		afpxyColumns: [
			{ name: "gfsbh", label: "购方税号", index: "gfsbh",width: 180, align:"left",sortable: true },
			{ name: "gfmc", label: "购方名称", index: "gfmc",width: 210, align:"left",sortable: true },
			{ name: "fs", label: "发票份数", index: "fs",width: 80, align:"right",sortable: true },
			{ name: "je", label: "金额", index: "je",width: 160, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} },
			{ name: "se", label: "税额", index: "se",width: 140, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} },
			{ name: "zyspmc", label: "主要商品名称", index: "zyspmc",width: 210, align:"left",sortable: true },
			{ name: "zyspje", label: "主要商品金额", index: "zyspje",width: 160, align:"right",sortable: true, formatter:function(cellvalue, options, rowObject){return avalon.filters.number(cellvalue,2);} }
		], 
		activeBarWidth: '0',
		activeBarX: '0',
		countList: ['CK_BGDSL','CK_BGDSL_DE','CK_BGDSL_ST','CK_PXBGDSL','CK_ZXBGDSL','CK_SBDW_SL','CK_GB_SL','TS_JHFP_FS_DG','TS_JHFP_FS','TS_JHFP_FS_CQ1','TS_JHFP_FS_CQ2','TS_GHS_NUM'],
		zbsjObj: {},
		zbsjXzDataList: [],
		gbkaObj: {},
		onReady:function(){
			var self = this
			this.changeTab('jcxx',0, '1')
			for (var i=0;i<this.nddxsjColumns.length;i++) {
				var item = this.nddxsjColumns[i]
				if (item.name == 'bgqValue' || item.name == 'jqValue') {
					item.formatter = function(cellvalue, options, rowObject){
						if (!cellvalue&&cellvalue!=0){ // 值为null时显示空
							return '';
						}
						if (self.countList.indexOf(rowObject.dataId) > -1) { // 非金额项
							return cellvalue;
						} else {
							return avalon.filters.number(cellvalue,2);
						}
					}
				}
			}
			this.createTableGbkaMx()
		},
		//copy bg
		createTable:function(item){
			var self = this
			var columns = this[item.columns]
			var id = item.activeName+'-table'
			var url = item.url
			$("#"+id).jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#'+id+'Pager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				footerrow: item.hasTotal,
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: item.isPager? config.pageSize:9999,
				width:"100%",
				height:(function(){
					return $(".zbtjjgMX .form").height() - $(".zbtjjgMX .msg").height() - (item.isPager ? (item.hasTotal ? 150 : 130) : 110);
				})(),
				beforeSelectRow:function(rowid,e){
          var row = $("#"+id).jqGrid("getRowData", rowid)
					if($(e.target).hasClass('op-showResult')){
						self.zbsjObj = row
            self.showModelResult(row)
						return false;
					} else if($(e.target).hasClass('op-showCkgb')){
						var code = e.target.dataset.code
						self.gbkaObj = {
							mxType: e.target.dataset.mxtype,
							type: e.target.dataset.type,
							dm: row[code]
						}
            self.showModelGbKa(row)
						return false;
					}else if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
							return false;
					}else{
						return true;
					}
				},
				gridComplete: function () {
					var sumData = {}
					for (var i = 0; i < columns.length; i++) {
							if (columns[i].isTotal) {
									var sum = 0;
									$("#"+id).getCol(columns[i].name, false).map(function (a) { sum += (a.replace(/\,/g, '') - 0) });
									sumData[columns[i].name] = avalon.filters.number(sum, 2);
							} else {
									sumData[columns[i].name] = ""
							}
					}
					sumData[columns[0].name] = "当前页合计";
					$("#"+id).footerData('set', sumData);
				},
				onSortCol: function (index, iCol, sortorder) {
					var orderSql = index + ' ' + sortorder;
					self.orderSqlObj[id] = orderSql
					self.search(id, url, 1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,id);
					self.search(id, url,pageNo);
				}
			});
			this.search(id, url,1, '')
		},
		createTableGbkaMx:function(item){
			var self = this
			var columns = [
				{ name: "CODE", label: "代码", index: "CODE",width: 180, align:"left",sortable: true },
				{ name: "MC", label: "名称", index: "MC",width: 210, align:"left",sortable: true }
			]
			$("#gbkamx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#gbkamx-tablePager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
				width:"100%",
				height: 230,
				onSortCol: function (index, iCol, sortorder) {
					var orderSql = index + ' ' + sortorder;
					self.searchMxData.orderSql = orderSql;
					self.searchMx(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,id);
					self.searchMx(pageNo);
				}
			});
		},
		showModelResult: function(row){
			var self = this
			api.jkmpdGetZbFfMxXz({nsrsbh:this.params.nsrsbh, zbId: row.zbId, bgqId: this.params.bgqId}).done(function(res){
				if(res.code=='0'){
					$('.model').show();
					$('.zbtjjgMX .result-page-model').show();
					self.zbsjXzDataList = res.data.dataList || []
				}
			})
		},
		hideModelResult: function(){
			$('.model').hide();
			$('.zbtjjgMX .result-page-model').hide();
		},
		showModelGbKa: function(row){
			this.searchMx(1).done(function(res){
				$('.model').show();
				$('.zbtjjgMX .gbkamx-page-model').show();
			})
		},
		hideModelGbKa: function(){
			$('.model').hide();
			$('.zbtjjgMX .gbkamx-page-model').hide();
		},
		search:function(id, url,pageNo){
			var self=this;
			var params = {
				djxh: this.params.djxh,
				bgqId: this.params.bgqId,
				bgqIdJq: this.params.bgqIdJq,
				pageNo: pageNo,
				orderSql: this.orderSqlObj[id] || ''
			}
			if ($('#'+id+'Pager').length>0) {
				params.pageSize = 20
			}
			$("#"+id).jqGrid('clearGridData')
			ajax("POST",url,params).done(function(res){
				if(res.code=='0'){
					var data = res.data
					for (var i=0;i<data.length;i++) {
						if (data[i].dataId == 'BGQID') {
							data.splice(i,1);
							break;
						}
					}
					$("#"+id)[0].addJSONData(data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		searchMx:function(pageNo){
			var self=this;
			var deferred = $.Deferred();
			this.searchMxData.pageSize = $(".ui-pg-selbox", $('.zbtjjg .gbkamx-page-model')).val() || 20;
			var params=tools.clone(self.searchMxData);
			params.pageNo=pageNo;
			params.djxh = this.params.djxh
			params.bgqId = this.params.bgqId
			console.log(this.gbkaObj)
			params[this.gbkaObj.type] = this.gbkaObj.dm
			params.mxType = this.gbkaObj.mxType
			$("#gbkamx-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbdata/ckgb/mx",params).done(function(res){
				if(res.code=='0'){
					$("#gbkamx-table")[0].addJSONData(res.data);
					deferred.resolve();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
			return deferred.promise();
		},
		changeTab: function(activeName, index,tabNum){
			this.activeName = activeName
			this.tabNum = tabNum
			this.activeBarX = $('.'+activeName).position().left + 10;
			this.activeBarWidth = $('.'+activeName).outerWidth() - 20;
			var item = this.tabList[index]
			if (item.isFirst) { // 首次点击时
				this.createTable(item)
				this.tabList[index].isFirst = false
			}
		},
		exform: function(){
			var params = {
				djxh: this.params.djxh,
				bgqId: this.params.bgqId,
				bgqIdJq: this.params.bgqIdJq,
				nsrsbh: this.params.nsrsbh,
				bgqYear: new Date(this.params.bgqQ).getFullYear(),
				tabNum: this.tabNum,
			}
			tools.exform(params,'/sszj/export/zbdata')
		}
	}
});