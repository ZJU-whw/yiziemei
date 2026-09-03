var dxzbsjcxfx=require("./dxzbsjcxfx.html");
var fxjsCommonFun = require('../../../config/fxjsCommonFun.js');
avalon.component('dxzbsjcxfx', {
	template:dxzbsjcxfx,
	defaults: {
		params:{},
		act:1,
		tcode: "dxzbsjcxfxcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			qylx: "",
			tsjsfs:"",
      code:"",
			name:"",
      type:"",
			swjg:"",
      bgqQ:"",
      bgqZ:"",
			qybs:"",
			flglcd:"",
      bazt: "",
      nsrzt: "",
      djzclx: "",
      hy: "",
      ckgm: "",
			bgqTyp: '1',
			includeZero: "0",
			orderSql:"",
			pageSize:config.pageSize,
		},
		bgqY: '',
		bgqJd: '',
    flglcdList: [],
    codeName: '',
    fzItemsList: [],
    selectMc: {},
    zbxx: {},
    jhfx: {},
		dafaultSearchData: {},
		bgqList: [],
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjg=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
			this.getBgqList();
      this.getDictList();
			this.initTree();
			this.createTable();
      $(window).resize(function () {
        self.setGridHeight();
      });
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 160, align:"left",sortable: true },
				{ name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 160, align:"left",sortable: true },
				{ name: "bgqVal", label: "报告期值", index: "bgqVal",width: 80, align:"left",sortable: true },
				{ name: "qylx", label: "企业类型", index: "qylx",width: 60, align:"center",sortable: true },
				{ name: "tsjsfs", label: "退税计算方式", index: "tsjsfs",width: 80, align:"center",sortable: true },
				{ name: "flglcd", label: "管理等级", index: "flglcd",width: 60, align:"center",sortable: true},
				{ name: "ckgm", label: "出口规模", index: "ckgm",width: 120, align:"left",sortable: true },
				{ name: "bazt", label: "备案状态", index: "bazt",width: 80, align:"center",sortable: false },
				{ name: "nsrzt", label: "纳税人状态", index: "nsrzt",width: 80, align:"center",sortable: false },
				{ name: "hy", label: "行业", index: "hy",width: 130, align:"left",sortable: false },
				{ name: "djzclx", label: "登记注册类型", index: "djzclx",width: 130, align:"left",sortable: false },
				{ name: "swjgMc", label: "税务机关", index: "swjgMc",width: 130, align:"left",sortable: false },
			];
			$("#dxzbsjcxfx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#dxzbsjcxfx-tablePager',
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
					return $(".dxzbsjcxfx .form").height() - 114 - $(".dxzbsjcxfx .zbxx").height();
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#dxzbsjcxfx-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('toMx')){
            var params = {
              djxh: row.djxh,
              zlbdlx: row.zlbdlx
            }
						avalonRoot.addTab({title:"出口企业基础资料采集表详情",component:"dxzbsjcxfxMx",params:params});
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
					var pageNo=tools.getPageNo(pgButton,"dxzbsjcxfx-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		search:function(pageNo){
			var self=this;
			if (this.searchData.bgqTyp == '2' && this.bgqY && this.bgqJd == '') {
				tools.info('请选择报告期季度!');
				return;
			}
			if (this.bgqY != '') {
				this.bgqHandle()
			}
      this.searchData.flglcd = this.selectMc['dj.flglcd'].value.join(',')
      this.searchData.nsrzt = this.selectMc['dj.nsrzt'].value.join(',')
      this.searchData.djzclx = this.selectMc['dj.djzclx'].value.join(',')
      this.searchData.hy = this.selectMc['dj.hy'].value.join(',')
      this.searchData.ckgm = this.selectMc['dj.ckgm'].value.join(',')
			this.searchData.pageSize = $(".ui-pg-selbox", $('.dxzbsjcxfx')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			this.dafaultSearchData = tools.clone(params)
			$("#dxzbsjcxfx-table").jqGrid('clearGridData')
			ajax("POST","/sszj/sxgn/getSingleZbResult",params).done(function(res){
				if(res.code=='0'){
          self.jhfx = {
            median: res.data.median,
            average: res.data.average,
            stddev: res.data.stddev,
            stdval: res.data.stdval,
            minval: res.data.minval,
            maxval: res.data.maxval,
          }
					$("#dxzbsjcxfx-table").resetSelection();
					$("#dxzbsjcxfx-table")[0].addJSONData(res.data);
					self.closeHyper()
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		bgqHandle: function(){
			if (this.searchData.bgqTyp == '1') {
				this.searchData.bgqQ = this.bgqY + '-01-01'
				this.searchData.bgqZ = this.bgqY + '-12-31'
			} else {
				this.searchData.bgqQ = tools.getQuarterStartDate(this.bgqY, this.bgqJd)
				this.searchData.bgqZ = tools.getQuarterEndDate(this.bgqY, this.bgqJd)
			}
		},
		initTree:function() {
			var self = this;
			var setting = {
				callback:{
					onClick:function(e,id,node){
						self.searchData.swjg = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					},
					onDblClick:function(e,id,node){
						self.searchData.swjg = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			};
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				$.fn.zTree.init($(".dxzbsjcxfx .swjgTree"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
    initZbTree: function(){
      var self = this;
			var setting = {
				callback:{
          beforeClick: function(id,node){
            return !!node.code
          },
					onClick:function(e,id,node){
            if (!node.code) return;
						self.searchData.code = node.code;
						self.searchData.name = node.name;
						self.searchData.type = node.type;
						self.codeName = node.name;
            self.getZbInfo({code:self.searchData.code,type:self.searchData.type})
						self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"name"}}
			};
      ajax("POST","/sszj/sxgn/getZbTree",{tsjsfs: this.searchData.qylx}).done(function(res){
				if(res.code=='0'){
					$.fn.zTree.init($(".dxzbsjcxfx .zbTree"), setting,res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    },
    getZbInfo: function(params){
      var self = this
      ajax("POST","/sszj/sxgn/getZbInfo",params).done(function(res){
				if(res.code=='0'){
          self.zbxx = res.data
          self.setGridHeight();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    },
    setGridHeight: function(){
      $("#dxzbsjcxfx-table").jqGrid('setGridHeight', $(".dxzbsjcxfx .form").height() - 114 - $(".dxzbsjcxfx .zbxx").height());
    },
    qylxChange: function(){
      if (this.searchData.qylx != '') {
        this.initZbTree()
      }
      this.codeName = ''
      this.searchData.code = ''
      this.searchData.type = ''
    },
		showHyper:function(){
			$('.dxzbsjcxfx .select-sub').toggle();
			$('.dxzbsjcxfx .select-wrapper .icon').toggleClass("active");
			if ($('.dxzbsjcxfx .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.dxzbsjcxfx .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.dxzbsjcxfx .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
    closeHyper:function(){
      $('.dxzbsjcxfx .select-sub').hide();
      $('.dxzbsjcxfx .select-wrapper .icon').removeClass('active');
      $('.dxzbsjcxfx .select-wrapper .icon').attr("title","展开查询条件");
    },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.dxzbsjcxfx').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.dxzbsjcxfx').off('click');
		},
		reset: function() {
			this.searchData = {
				swjg:avalonRoot.user.swjgDm,
				qylx: "",
				tsjsfs:"",
        code:"",
				name:"",
        type:"",
        bgqQ:"",
        bgqZ:"",
        qybs:"",
        flglcd:"",
        bazt: "",
        nsrzt: "",
        djzclx: "",
        hy: "",
        ckgm: "",
				includeZero: "0",
				bgqTyp: "1",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.bgqY = "";
			this.bgqJd = "";
			this.swjgmc= avalonRoot.user.swjgMc;
      this.codeName = ''
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
      let id = '#dxzbsjcxfx_select_'+item.zbxmbm.split('.')[0]+'_'+item.zbxmbm.split('.')[1]
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
      var domId = 'dxzbsjcxfx_tree_'+zbxmbm.split('.')[0]+'_'+zbxmbm.split('.')[1]
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
		getChart: function(sampleType){
			var self = this
			if($('#dxzbsjcxfx-table').jqGrid('getRowData').length<=0){
				tools.info("请先查询列表");
				return ;
			}
			var params = tools.clone(this.dafaultSearchData)
			params.sampleType = sampleType
			ajax("POST","/sszj/sxgn/getChart",params).done(function(res){
				if(res.code=='0'){
					self.hideMenu();
					avalonRoot.addTab({title:"正态分布图",component:"ztfb",params:{data:res.data.bgqVal}});
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		exform:function(){
			var self=this;
			if($('#dxzbsjcxfx-table').jqGrid('getRowData').length<=0){
					tools.info("请先查询列表");
					return ;
			}
			var params = tools.clone(self.dafaultSearchData)
			tools.exform(params, '/sszj/export/exportZbResult')
		},
		showMenu:function(e){
			var self=this;
			$(".dropdown-menu",e.target).show();
			$('.dxzbsjcxfx').on('click',function(e){
				var e=e||window.event;
				if($('.dropdown-menu').find($(e.target)).length<=0){
					self.hideMenu();
				}
			})
		},
		hideMenu:function(){
			$(".dropdown-menu").hide();
			$('.dxzbsjcxfx').off('click');
		},
		getBgqList: function(){
			var currentY = new Date().getFullYear();
			var len = currentY - 2018
			this.bgqList = []
			for (var i=0;i<len;i++) {
				this.bgqList.push(2019+i)
			}
		}
	}
});