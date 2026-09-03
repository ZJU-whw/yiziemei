var jkmPdFh=require("./jkmPdFh.html");
avalon.component('jkmPdFh', {
	template:jkmPdFh,
	defaults: {
		params:{},
		act:1,
		tcode: "jkmPdFhcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			swjgDm:"",
			qybs:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    pdData: {
      nsrsbh: '',
      nsrmc: '',
      jkmY: '',
      jkmN: '',
      yxq: '',
      pdyj: '',
      fhyj: ''
    },
    qybz: '',
    propsToPager: {
      componentsName: 'jkmPdFh',
			isEdit: false
    },
		isFirst: true,
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjgDm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
			this.initTree();
			this.createTable();
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
				{ name: "op2", label: "操作", index: "op",width: 0,frozen: true,align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<div class='btn op-pd' style='float: none;display: inline-block;' title='复核'>复核</div>";
				} },
				{ name: "pdUuid", label: "评定申请编号", index: "pdUuid",hidden: true },
				{ name: "fqlxStr", label: "发起类型", index: "fqlxStr",width: 60, align:"center",sortable: false},
				{ name: "qdsj", label: "启动时间", index: "qdsj",width: 120, align:"center",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 150, align:"left",sortable: true },
				{ name: "qyhgdm", label: "海关代码", index: "qyhgdm",width: 100, align:"left",sortable: true },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 150, align:"left",sortable: true },
				{ name: "jkmY", label: "原健康码", index: "jkmY",width: 50, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var colorMap = {
						'绿码': '#67C23A',
						'黄码': '#E6A23C',
						'红码': '#f56c6c'
					}
					return "<div style='background-color:"+ colorMap[cellvalue] +"'>"+cellvalue+"</div>";
				} },
				{ name: "jkmN", label: "新健康码", index: "jkmN",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var colorMap = {
						'绿码': '#67C23A',
						'黄码': '#E6A23C',
						'红码': '#f56c6c'
					}
					return "<div style='background-color:"+ colorMap[cellvalue] +"'>"+cellvalue+"</div>";
				} },
				{ name: "yxq", label: "评定有效期", index: "yxq",width: 80, align:"center",sortable: true },
				{ name: "pdztStr", label: "评定状态", index: "pdztStr",width: 60, align:"center",sortable: false},
				{ name: "pdjg", label: "评定结果", index: "pdjg",width: 60, align:"center",sortable: false},
				{ name: "pdrMc", label: "评定人", index: "pdrMc",width: 80, align:"center",sortable: false},
				{ name: "pdsj", label: "评定时间", index: "pdsj",width: 120, align:"center",sortable: true},
				{ name: "pdyj", label: "评定意见", index: "pdyj",width: 140, align:"left",sortable: false},
				{ name: "fhrMc", label: "复核人", index: "fhrMc",width: 80, align:"center",sortable: true},
				{ name: "fhyj", label: "复核意见", index: "fhyj",width: 140, align:"left",sortable: false},
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 130, align:"left",sortable: false},
				{ name: "op", label: "操作", width: 100, align: "center", resizable: false, search: false, sortable: false}
			];
			$("#jkmPdFh-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#jkmPdFh-tablePager',
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
					return $(".jkmPdFh .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if($(e.target).hasClass('op-pd')){
						var pdUuid = getCellData("jkmPdFh-table", rowid, 'pdUuid')
            self.showModelPd(pdUuid)
						return false;
					}else if($(e.target).hasClass('op-del')){
						var nsrsbh = getCellData("jkmPdFh-table", rowid, 'nsrsbh')
						avalonRoot.addTab({title:"历史健康码明细",component:"jkmHistoryMx",params:{nsrsbh: nsrsbh}});
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
					var pageNo=tools.getPageNo(pgButton,"jkmPdFh-table");
					self.search(pageNo);
				}
			});
			$("#jkmPdFh-table").jqGrid('setFrozenColumns');
			tools.HeiKjNoSel('jkmPdFh', 'jkmPdFh-table');
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jkmPdFh')).val();
			self.search(1);
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jkmPdFh')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#jkmPdFh-table").jqGrid('clearGridData')
			ajax("POST","/sszj/jkmpd/getFhList",params).done(function(res){
				if(res.code=='0'){
					$("#jkmPdFh-table").resetSelection();
					$("#jkmPdFh-table")[0].addJSONData(res.data);
          tools.HeiKjNoSel('jkmPdFh', 'jkmPdFh-table');
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
				$.fn.zTree.init($(".jkmPdFh .jkmPdFhswjgtree.treeDiv"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.jkmPdFh').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.jkmPdFh').off('click');
		},
		reset: function() {
			this.searchData = {
				swjgDm:avalonRoot.user.swjgDm,
				qybs:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= avalonRoot.user.swjgMc;
		},
    validHandler: function(rules, data){
      for(var i=0;i<rules.length;i++) {
        var rule = rules[i]
        if (data[rule.name] == '') {
          tools.info(rule.message)
          return false
        }
      }
      return true
    },
    showModelPd: function(pdUuid){
      var self = this
      ajax("POST","/sszj/jkmpd/getPdInfo",{pdUuid:pdUuid}).done(function(res){
        if(res.code=='0'){
          self.pdData = res.data
          self.pdData.pdUuid = pdUuid
          $('.model').show();
          $('.jkmPdFh .pd-page-model').show();
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    hideModelPd: function(){
      $('.model').hide();
      $('.jkmPdFh .pd-page-model').hide();
      this.pdData = {
        nsrsbh: '',
        nsrmc: '',
        jkmY: '',
        jkmN: '',
        yxq: '',
        pdyj: '',
        fhyj: ''
      }
    },
    submit: function(action){
      var self = this
      var params = {
        pdUuid: this.pdData.pdUuid,
        fhyj: this.pdData.fhyj,
        action: action
      }
      ajax("POST","/sszj/jkmpd/fhAgree",params).done(function(res){
        if(res.code=='0'){
          var msg = action == '1' ? '保存成功！' : '提交成功！'
          tools.info(msg);
          self.search(1);
          self.hideModelPd();
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    back: function(){
      var self = this
      var params = {
        pdUuid: this.pdData.pdUuid,
        fhyj: this.pdData.fhyj
      }
      var rules = [
        { name: 'fhyj', message: '复核意见不能为空！'}
      ]
      var validHandler = this.validHandler(rules,params)
      if (!validHandler) return;
      ajax("POST","/sszj/jkmpd/fhReject",params).done(function(res){
        if(res.code=='0'){
          tools.info('退回成功！');
          self.search(1);
          self.hideModelPd();
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    
    updateJkm: function(){
      $('.model').show();
      $('.jkmPdFh .updateJkm-page-model').show();
			components.updateJkmjkmPdFh.isFirst = this.isFirst
      components.updateJkmjkmPdFh.componentsName = this.propsToPager.componentsName
      components.updateJkmjkmPdFh.isEdit = this.propsToPager.isEdit
      components.updateJkmjkmPdFh.initData();
      components.updateJkmjkmPdFh.setNsrsbh({nsrsbh: this.pdData.nsrsbh,nsrmc:this.pdData.nsrMc});
      components.updateJkmjkmPdFh.modelData.jkmN = this.pdData.jkmN;
			this.isFirst = false;
    },
	}
});