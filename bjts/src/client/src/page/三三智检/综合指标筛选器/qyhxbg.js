var qyhxbg=require("./qyhxbg.html");
var fxjsCommonFun = require('../../../config/fxjsCommonFun.js');
avalon.component('qyhxbg', {
	template:qyhxbg,
	defaults: {
		params:{},
		act:1,
		tcode: "qyhxbgcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			qybs: "",
			bgnd: "",
			ztbz: "",
			sqr: "",
      swjgDm:"",
			qylx:"",
			flglcd:"",
      ckgm: "",
      bazt: "",
      nsrzt: "",
      djzclx: "",
      hy: "",
			sqsjQ: "",
			sqsjZ: "",
			orderSql:"",
			pageSize:config.pageSize,
		},
		searchDataXzjl: {
			djxh: '',
			bgnd: '',
			bglx: '',
			orderSql:"",
			pageSize:config.pageSize
		},
    fzItemsList: [],
    selectMc: {},
		dafaultSearchData: {},
		bgqList: [],
		zbxmmcMap: {
			'dj.flglcd': '分类管理类别',
			'dj.hy': '行业类型',
			'dj.djzclx': '登记类型',
			'dj.nsrzt': '纳税人状态',
			'dj.ckgm': '出口规模'
		},
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjgDm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
      this.initDate();
			this.getBgqList();
      this.getDictList();
			this.initTree();
			this.createTable();
			this.createTableRz();
			this.initParams();
		},
		initParams: function(){
			if(this.params.nsrsbh){
				this.searchData.qybs = this.params.nsrsbh;
				this.search(1);
			}
			if(this.params.doSearch){ // 风险健康总览跳转，doSearch为true，需要查询一次
				this.searchData.bgnd = '';
				this.searchData.ztbz = '2';
				this.search(1);
			}
		},
    initDate: function(){
			var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
			$('.qyhxbg .datepicker.date-day').datetimepicker(options);
    },
    filDate:function(e){
			var date=e.target.value;
			var res=tools.DateCheup(date);
			if(res===false){
				tools.info("日期输入错误");
				res=""
			}
			e.target.value=res;

			return ;
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "djxh", label: "登记序号", index: "djxh", hidden: true },
				{ name: "swjgDm", label: "税务机关代码", index: "swjgDm", hidden: true },
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 160, align:"left",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 160, align:"left",sortable: true },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 200, align:"left",sortable: true },
				{ name: "bglx", label: "报告类型", index: "bglx", hidden: true },
				{ name: "bglxStr", label: "报告类型", index: "bglxStr",width: 60, align:"center",sortable: true },
				{ name: "bgnd", label: "报告年度", index: "bgnd",width: 60, align:"center",sortable: true },
				{ name: "sqr", label: "申请人", index: "sqr",width: 70, align:"center",sortable: true },
				{ name: "sqrq", label: "申请日期", index: "sqrq",width: 80, align:"center",sortable: true },
				{ name: "ztbz", label: "状态标志", index: "ztbz", hidden: true },
				{ name: "ztbzStr", label: "状态标志", index: "ztbzStr",width: 60, align:"center",sortable: true,formatter: function(cellvalue, options, rowObject){
					if (cellvalue) {
						return '<div title="申请时间：'+(rowObject.sqsj || '')+'\n处理开始：'+(rowObject.clkssj || '')+'\n结束时间：'+(rowObject.clwcsj || '')+'">'+cellvalue+'</div>'
					} else {
						return ''
					}
				}},
				{ name: "fileFmt", label: "文件格式", index: "fileFmt", hidden: true },
				{ name: "wjxz", label: "文件下载", index: "wjxz",width: 120, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
					if (rowObject.fileFmt) {
						return '<span class="link op-download">下载'+rowObject.fileFmt+'('+rowObject.fileSize+'K)</span>'
					} else {
						return ''
					}
				}},
				{ name: "xzcs", label: "下载次数", index: "xzcs",width: 60, align:"right",sortable: true, formatter: function(cellvalue, options, rowObject){
					if (cellvalue) {
						return '<div class="link op-rzmsg">'+cellvalue+'</div>'
					} else {
						return ''
					}
				}},
				{ name: "qylx", label: "企业类型", index: "qylx",width: 60, align:"center",sortable: true},
				{ name: "flglcd", label: "分类管理等级", index: "flglcd",width: 80, align:"center",sortable: true},
				{ name: "bazt", label: "备案状态", index: "bazt",width: 70, align:"center",sortable: false },
				{ name: "nsrzt", label: "纳税人状态", index: "nsrzt",width: 80, align:"center",sortable: false },
				{ name: "hy", label: "行业", index: "hy",width: 130, align:"left",sortable: false },
				{ name: "djzclx", label: "登记注册类型", index: "djzclx",width: 130, align:"left",sortable: false },
				{ name: "ckgm", label: "出口规模", index: "ckgm",width: 200, align:"left",sortable: true }
			];
			$("#qyhxbg-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				rownumWidth: 45,
				pager: '#qyhxbg-tablePager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				multiselect: true,
				multiselectWidth:"40",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
				width:"100%",
				height:(function(){
					return $(".qyhxbg .form").height() - 60;
				})(),
				beforeSelectRow:function(rowid,e){
          if($(e.target).hasClass('disabled')) return;
					var row = $("#qyhxbg-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('op-download')){
						var params = {
							bgnd: row.bgnd,
							bglx: row.bglx,
							djxh: row.djxh,
							nsrsbh: row.nsrsbh,
							nsrmc: row.nsrmc,
							fileFmt: row.fileFmt
						}
						tools.ajaxExform(params,'/sszj/report/download').done(function(){
							self.search(1);
						})
						return false;
					}else if($(e.target).hasClass('op-rzmsg')){
						self.searchDataXzjl.djxh = row.djxh
						self.searchDataXzjl.bgnd = row.bgnd
						self.searchDataXzjl.bglx = row.bglx
						self.showModel();
						self.searchDownloadRecord(1);
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
					var pageNo=tools.getPageNo(pgButton,"qyhxbg-table");
					self.search(pageNo);
				},
				onSelectRow: function (rowid, status) {
          var index = self.selRows.indexOf(rowid);
          if (status) {
						var curRowData =$("#qyhxbg-table").jqGrid('getRowData', rowid);
						if(curRowData.ztbz != '10') {
							$("#qyhxbg-table").jqGrid("setSelection", rowid,false);
						} else {
							self.selRows.push(rowid)
						}
          } else {
            self.selRows.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
					var rowIds = $("#qyhxbg-table").jqGrid('getDataIDs')
					self.selRows = [];
          if (status) {
						for(var k=0; k<rowIds.length; k++) {
							var curRowData = $("#qyhxbg-table").jqGrid('getRowData', rowIds[k]);
							if(curRowData.ztbz != '10') {
								$("#qyhxbg-table").jqGrid("setSelection", rowIds[k],false);
							} else {
								self.selRows.push(rowIds[k])
							}
						}
          } else {
						self.selRows = [];
          }
        },
				gridComplete: function(){
					var ids = $("#qyhxbg-table").jqGrid('getDataIDs');
					for(var i=0;i < ids.length;i++){
						var rowId = ids[i];
						var ztbz = $("#qyhxbg-table").jqGrid('getCell',ids[i],'ztbz');
						if(ztbz != '10'){
							$("#jqg_qyhxbg-table_"+rowId).attr("disabled", true);
						}
					}
				}
			});
		},
		createTableRz:function(){
			var self=this;
			var columns = [
				{ name: "xzrSwjgDm", label: "下载税务机关代码", index: "xzrSwjgDm", hidden: true },
				{ name: "xzrSwjgMc", label: "下载税务机关名称", index: "xzrSwjgMc",width: 160, align:"left",sortable: true },
				{ name: "xzrDm", label: "下载人代码", index: "xzrDm",width: 80, align:"left",sortable: true },
				{ name: "xzrMc", label: "下载人名称", index: "xzrMc",width: 100, align:"left",sortable: true },
				{ name: "xzsj", label: "下载时间", index: "xzsj",width: 140, align:"center",sortable: true },
			];
			$("#qyhxbg-rz-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#qyhxbg-rz-tablePager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"40",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
				width:"100%",
				height:(function(){
					return 240;
				})(),
				beforeSelectRow:function(rowid,e){
          if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
            return false;
					}else{
            return true;
					}
				},
				onSortCol: function (index, iCol, sortorder) {
					self.searchDataXzjl.orderSql = index + ' ' + sortorder;
					self.searchDownloadRecord(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"qyhxbg-rz-table");
					self.searchDownloadRecord(pageNo);
				}
			});
		},
		search:function(pageNo){
			var self=this;
      this.searchData.flglcd = this.selectMc['dj.flglcd'] && this.selectMc['dj.flglcd'].value.join(',') || '';
      this.searchData.nsrzt = this.selectMc['dj.nsrzt'] && this.selectMc['dj.nsrzt'].value.join(',') || '';
      this.searchData.djzclx = this.selectMc['dj.djzclx'] && this.selectMc['dj.djzclx'].value.join(',') || '';
      this.searchData.hy = this.selectMc['dj.hy'] && this.selectMc['dj.hy'].value.join(',') || '';
      this.searchData.ckgm = this.selectMc['dj.ckgm'] && this.selectMc['dj.ckgm'].value.join(',') || '';
			this.searchData.pageSize = $(".ui-pg-selbox", $('.qyhxbg')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			this.dafaultSearchData = tools.clone(params)
			$("#qyhxbg-table").jqGrid('clearGridData')
			api.qyReportList(params).done(function(res){
				if(res.code=='0'){
					self.selRows = []
					$("#qyhxbg-table").resetSelection();
					$("#qyhxbg-table")[0].addJSONData(res.data);
					self.closeHyper()
				}
			})
		},
		// 查询报告下载记录
		searchDownloadRecord:function(pageNo){
			var self=this;
			this.searchDataXzjl.pageSize = $(".ui-pg-selbox", $('.qyhxbg')).val() || 20;
			var params=tools.clone(self.searchDataXzjl);
			params.pageNo=pageNo;
			$("#qyhxbg-rz-table").jqGrid('clearGridData')
			api.qyReportDownloadList(params).done(function(res){
				if(res.code=='0'){
					$("#qyhxbg-rz-table").resetSelection();
					$("#qyhxbg-rz-table")[0].addJSONData(res.data);
				}
			})
		},
		initTree:function() {
			var self = this;
			var setting = {
				callback:{
					onClick:function(e,id,node){
						self.searchData.swjgDm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					},
					onDblClick:function(e,id,node){
						self.searchData.swjgDm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			};
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				$.fn.zTree.init($(".qyhxbg .swjgTree"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.qyhxbg .select-sub').toggle();
			$('.qyhxbg .select-wrapper .icon').toggleClass("active");
			if ($('.qyhxbg .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.qyhxbg .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.qyhxbg .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
    closeHyper:function(){
      $('.qyhxbg .select-sub').hide();
      $('.qyhxbg .select-wrapper .icon').removeClass('active');
      $('.qyhxbg .select-wrapper .icon').attr("title","展开查询条件");
    },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.qyhxbg').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.qyhxbg').off('click');
		},
		reset: function() {
			this.searchData = {
				qybs: "",
				bgnd: this.bgqList[this.bgqList.length-1],
				ztbz: "",
				sqr: "",
				swjgDm: avalonRoot.user.swjgDm,
				qylx:"",
				flglcd:"",
				ckgm: "",
				bazt: "",
				nsrzt: "",
				djzclx: "",
				hy: "",
				sqsjQ: "",
				sqsjZ: "",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= avalonRoot.user.swjgMc;
      this.resetSelectMc(this.fzItemsList)
      this.initSelect(this.fzItemsList)
		},
    getDictList: function(){
			var self = this
      var zbxms = ["dj.flglcd", "dj.nsrzt", "dj.djzclx", "dj.hy", "dj.ckgm"]
			var params = {
				zbdldm: '1',
				zbxms: zbxms
			}
      this.fzItemsList = []
			ajax("POST","/sszj/xmgl/dynamic/init/other",params).done(function(res){
				if(res.code=='0'){
					var fzItemsOther = res.data.fzItemsOther
          for (var i=0; i<zbxms.length;i++) {
            for (var j=0; j<fzItemsOther.length;j++) {
              if (zbxms[i] == fzItemsOther[j].zbxmbm) {
                self.fzItemsList.push(fzItemsOther[j])
              }
            }
          }
          self.initSelect(self.fzItemsList)
          self.resetSelectMc(self.fzItemsList)
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		initSelect: function(selectList){
      for (var i=0;i<selectList.length;i++) {
        let item = selectList[i]
        if (item.isTree == '1') {
          if (item.zbxmbm == 'dj.djzclx') {
						this.initSelectTree(item.zbxmbm, item.values[0])
					} else {
						this.initSelectTree(item.zbxmbm, item.values)
					}
        } else {
          this.initMultiselect(item)
        }
      }
    },
    // 多选下拉框
    initMultiselect: function(item){
      var self = this
      let id = '#qyhxbg_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
      let options = []
      for(var i=0;i<item.values.length;i++) {
        let tmp = item.values[i]
        options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: false})
      }
      $(id).multiselect({
        nonSelectedText: '',
        nSelectedText: '项已选择',
        allSelectedText: '全部选中',
        onChange: function(option, checked, select) {
          let val = $(option).val()
          let values = self.selectMc[item.zbxmbm].value
          if (checked) {
            values.push(val)
          } else {
            let i = values.indexOf(val)
            values.splice(i,1)
          }
          self.selectMc[item.zbxmbm].value = values
        }
      });
      $(id).multiselect('dataprovider', options);
    },
    // 下拉列表树
    // listOrParams-树形数据
    initSelectTree:function(zbxmbm, treelistOrParams) {
      var self = this;
      var domId = 'qyhxbg_tree_'+zbxmbm.split('.')[0]+'_'+zbxmbm.split('.')[1]
      var setting = {
        check:{
          enable: true
        },
        view: {
          selectedMulti: false
        },
        data:{
          simpleData:{
            enable: true,
            idKey: "code",
          },
          key:{children:"item",name:"name"}
        },
        callback:{
          onCheck:function(e,id,node){
            self.treeCheckHandler(domId, zbxmbm)
            return;
          }
        }
      };
      $.fn.zTree.init($('#'+domId), setting, treelistOrParams);
    },
    // 选中后赋值
    treeCheckHandler: function(domId, zbxmbm){
      var treeObj = $.fn.zTree.getZTreeObj(domId);
      var nodes = treeObj.getCheckedNodes(true); // 获取输入框被勾选的节点集合
      var res = fxjsCommonFun.getFootNode(nodes)
      this.selectMc[zbxmbm].value = []
      var nameArr = []
      for (var i=0;i<res.length;i++) {
        this.selectMc[zbxmbm].value.push(res[i].code)
        nameArr.push(res[i].name)
      }
      this.selectMc[zbxmbm].name = nameArr.join(',')
    },
    // 重置分组指标选中内容
    resetSelectMc: function(allSelectList){
      var obj = {}
      for (var i=0;i<allSelectList.length;i++) {
        let item = allSelectList[i].zbxmbm
        obj[item] = { name: '', value: [], range: ''}
      }
      this.selectMc = obj
    },
    // 从2019开始，结束年度根据当前月份来判定，若<=6月则结束年度=上年，否则结束年度=本年
		getBgqList: function(){
      var date = new Date()
			var currentY = date.getFullYear();
      var currentM = date.getMonth()+1;
      var len = 0
      if (currentM<=6) {
        len = currentY - 1 - 2018
      } else {
        len = currentY - 2018
      }
			this.bgqList = []
			for (var i=0;i<len;i++) {
				this.bgqList.push(2019+i)
			}
			this.searchData.bgnd = this.bgqList[this.bgqList.length-1]
		},
		// 生成报告
		generateReport: function(){
			var self = this
			if (this.searchData.bgnd == '') {
				tools.info('请先选择报告年度！');
				return;
			}
			if (this.selRows.length <=0) {
				tools.info('请先选择要生成报告的项！');
				return;
			}
			var bgInfoList = []
      for (var i = 0; i < this.selRows.length;i++ ){
        var row = $("#qyhxbg-table").jqGrid("getRowData", this.selRows[i])
        bgInfoList.push({djxh: row.djxh, nsrsbh: row.nsrsbh, swjgDm: row.swjgDm});
      }
			var params = {
				bgnd: this.searchData.bgnd,
				bglx: '1',
				bgInfoList: bgInfoList
			}
			api.qyReportGenerate(params).done(function(res){
				if(res.code=='0'){
					tools.info('生成成功！');
					self.search(1);
				}
			})
		},
		showModel: function(){
			$('.model').show();
			$('.qyhxbg .rz-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.qyhxbg .rz-page-model').hide();
		}
	}
});