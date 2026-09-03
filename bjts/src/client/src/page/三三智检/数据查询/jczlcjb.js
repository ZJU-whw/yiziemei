var jczlcjb=require("./jczlcjb.html");
avalon.component('jczlcjb', {
	template:jczlcjb,
	defaults: {
		params:{},
		act:1,
		tcode: "jczlcjbcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			swjgDm:"",
			qybs:"",
			tsjsfs:"",
			flglcd:[],
      cjzt: "",
			orderSql:"",
			pageSize:config.pageSize,
		},
    flglcdList: [],
    flglcdMap: {},
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjgDm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
      this.getDictList();
			this.initTree();
			this.createTable();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "djxh", label: "登记序号", index: "djxh",hidden:true },
				{ name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 200, align:"left",sortable: true },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 200, align:"left",sortable: true },
				{ name: "flglcd", label: "管理等级", index: "flglcd",width: 60, align:"center",sortable: true,  formatter: function(cellvalue, options, rowObject){
          return self.flglcdMap[cellvalue] || ''
				} },
				{ name: "tsjsfs", label: "退税计算方式", index: "tsjsfs", hidden: true },
				{ name: "tsjsfsStr", label: "退税计算方式", index: "tsjsfsStr",width: 80, align:"center",sortable: true },
				{ name: "swjgMc", label: "税务机关", index: "swjgMc",width: 120, align:"left",sortable: true },
				{ name: "zlbdlx", label: "资料表单类型", index: "zlbdlx", hidden:true },
				{ name: "zlbdlxStr", label: "资料表单类型", index: "zlbdlxStr",width: 120, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
          if (rowObject.zlbdlx) {
            return "<span class='link toMx'>"+cellvalue+"</span>";
          } else {
            return '';
          }
				} },
				{ name: "bssj", label: "报送时间", index: "bssj",width: 130, align:"left",sortable: false },
				{ name: "snLjcke", label: "上年累计出口额（美元）", index: "snLjcke",width: 130, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
					if (cellvalue!== null) {
						return avalon.filters.number(cellvalue,2);
					}
					return ''
				}  },
				{ name: "bnLjcke", label: "本年累计出口额（美元）", index: "bnLjcke",width: 130, align:"right",sortable: false, formatter:function(cellvalue, options, rowObject){
					if (cellvalue!== null) {
						return avalon.filters.number(cellvalue,2);
					}
					return ''
				}  },
			];
			$("#jczlcjb-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#jczlcjb-tablePager',
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
					return $(".jczlcjb .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					var row = $("#jczlcjb-table").jqGrid("getRowData", rowid)
					if($(e.target).hasClass('toMx')){
            var params = {
              djxh: row.djxh,
              zlbdlx: row.zlbdlx,
							nsrsbh: row.nsrsbh,
							tsjsfs: row.tsjsfs
            }
						if (row.zlbdlx == 'a') {
							console.log(params)
							avalonRoot.addTab({title:"出口企业基础资料采集表详情",component:"jczlcjbMxbByCkqyxxcj",params:params});
						} else {
							avalonRoot.addTab({title:"出口企业基础资料采集表详情",component:"jczlcjbMx",params:params});
						}
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
					var pageNo=tools.getPageNo(pgButton,"jczlcjb-table");
					self.search(pageNo);
				}
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jczlcjb')).val() || 20;
			var params=tools.clone(self.searchData);
      params.flglcd = self.searchData.flglcd.join(',')
			params.pageNo=pageNo;
			$("#jczlcjb-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbdata/cjbList",params).done(function(res){
				if(res.code=='0'){
					$("#jczlcjb-table").resetSelection();
					$("#jczlcjb-table")[0].addJSONData(res.data);
					self.closeHyper()
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
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
				$.fn.zTree.init($(".jczlcjb .treeDiv"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.jczlcjb .select-sub').toggle();
			$('.jczlcjb .select-wrapper .icon').toggleClass("active");
			if ($('.jczlcjb .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.jczlcjb .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.jczlcjb .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
    closeHyper:function(){
      $('.jczlcjb .select-sub').hide();
      $('.jczlcjb .select-wrapper .icon').removeClass('active');
      $('.jczlcjb .select-wrapper .icon').attr("title","展开查询条件");
    },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.jczlcjb').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.jczlcjb').off('click');
		},
		reset: function() {
			this.searchData = {
				swjgDm:avalonRoot.user.swjgDm,
				qybs:"",
				tsjsfs:"",
			  flglcd:[],
        cjzt: "",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= avalonRoot.user.swjgMc;
      this.initMultiselect(this.flglcdList)
		},
    getDictList: function(){
			var self = this
			var params = {
				zbdldm: '1',
				zbxms: ["dj.flglcd"]
			}
			ajax("POST","/sszj/xmgl/dynamic/init/other",params).done(function(res){
				if(res.code=='0'){
					var data = res.data.fzItemsOther
          self.flglcdList = data[0].values
          for (var i=0;i<self.flglcdList.length;i++) {
            var item = self.flglcdList[i]
            self.flglcdMap[item.code] = item.name
          }
					self.initMultiselect(self.flglcdList)
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		// 多选下拉框
		initMultiselect: function(item){
			var self = this
			let id = '#jczlcjb_select_gllb'
			let options = []
			for(var i=0;i<item.length;i++) {
				let tmp = item[i]
				options.push({label: tmp.name, title: tmp.name, value: tmp.code, selected: false})
			}
			$(id).multiselect({
				nonSelectedText: '',
				nSelectedText: '项已选择',
				allSelectedText: '全部选中',
				onChange: function(option, checked, select) {
					let val = $(option).val()
					let values = self.searchData.flglcd
					if (checked) {
						values.push(val)
					} else {
						let i = values.indexOf(val)
						values.splice(i,1)
					}
					self.searchData.flglcd = values
				}
			});
			$(id).multiselect('dataprovider', options);
		},
	}
});