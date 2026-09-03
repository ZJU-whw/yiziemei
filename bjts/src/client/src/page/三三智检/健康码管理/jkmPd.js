var jkmPd=require("./jkmPd.html");
avalon.component('jkmPd', {
	template:jkmPd,
	defaults: {
		params:{},
		act:1,
		tcode: "jkmPdcx",
		swjgmc: "",
		selRows: [],
    propsToPager: {
      componentsName: 'jkmPd',
			isEdit: true
    },
		searchData:{
			swjgDm:"",
			qybs:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		modelData: {
      nsrsbh: '',
      nsrmc: '',
      jkmY: '',
      yxq: ''
    },
    pdData: {
      nsrsbh: '',
      nsrMc: '',
      jkmY: '',
      jkmN: '',
      yxq: '',
      pdyj: ''
    },
		isFirst: true,
		nsrsbhList: [],
    showNsrsbhList: false,
    activeBgIndex: 0,
    qybz: '',
    pdzt: '',
    onInit: function onInit(e) {
      components.jkmPd = e.vmodel;
    },
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjgDm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
      this.initDate();
			this.initTree();
			this.searchData.qybs = this.params.qybs || ''
			this.createTable();
		},
    
		initDate: function(){
			var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
			$('.jkmPd .datepicker.date-day').datetimepicker(options);
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
					return "<div class='btn op-pd "+(rowObject.pdzt==2 ? 'disabled' : '')+"' style='float: none;display: inline-block;' title='评定'>评定</div><div class='btn op-del "+(rowObject.fqlx==1 && rowObject.pdzt==0 ? '' : 'disabled')+"' style='float: none;display: inline-block;' title='删除'>删除</div>";
				} },
				{ name: "pdUuid", label: "评定申请编号", index: "pdUuid",hidden: true },
				{ name: "fqlxStr", label: "发起类型", index: "fqlxStr",width: 60, align:"left",sortable: false},
				{ name: "qdsj", label: "启动时间", index: "qdsj",width: 130, align:"left",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 130, align:"left",sortable: true },
				{ name: "qyhgdm", label: "海关代码", index: "qyhgdm",width: 80, align:"left",sortable: true },
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
					if (cellvalue) {
						return "<div style='background-color:"+ colorMap[cellvalue] +"'>"+cellvalue+"</div>";
					} else {
						return '';
					}
				} },
				{ name: "yxq", label: "评定有效期", index: "yxq",width: 80, align:"center",sortable: true },
				{ name: "pdzt", label: "评定状态", index: "pdzt",hidden: true},
				{ name: "pdztStr", label: "评定状态", index: "pdztStr",width: 60, align:"center",sortable: false},
				{ name: "pdjg", label: "评定结果", index: "pdjg",width: 60, align:"center",sortable: false},
				{ name: "pdrMc", label: "评定人", index: "pdrMc",width: 80, align:"center",sortable: false},
				{ name: "pdyj", label: "评定意见", index: "pdyj",width: 140, align:"left",sortable: false},
				{ name: "fhyj", label: "复核意见", index: "fhyj",width: 140, align:"left",sortable: false},
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 100, align:"left",sortable: false},
				{ name: "op", label: "操作", width: 140, align: "center", resizable: false, search: false, sortable: false}
			];
			$("#jkmPd-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#jkmPd-tablePager',
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
					return $(".jkmPd .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
          if($(e.target).hasClass('disabled')) return;
          var pdUuid = getCellData("jkmPd-table", rowid, 'pdUuid')
          self.pdzt = getCellData("jkmPd-table", rowid, 'pdzt')
					if($(e.target).hasClass('op-pd')){
            self.showModelPd(pdUuid)
						return false;
					}else if($(e.target).hasClass('op-del')){
            self.delHandler(pdUuid)
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
					var pageNo=tools.getPageNo(pgButton,"jkmPd-table");
					self.search(pageNo);
				}
			});
			$("#jkmPd-table").jqGrid('setFrozenColumns');
			tools.HeiKjNoSel('jkmPd', 'jkmPd-table');
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jkmPd')).val();
			this.search(1);
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.jkmPd')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#jkmPd-table").jqGrid('clearGridData')
			ajax("POST","/sszj/jkmpd/getPdList",params).done(function(res){
				if(res.code=='0'){
					$("#jkmPd-table").resetSelection();
					$("#jkmPd-table")[0].addJSONData(res.data);
          tools.HeiKjNoSel('jkmPd', 'jkmPd-table');
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
				$.fn.zTree.init($(".jkmPd .jkmPdswjgtree.treeDiv"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.jkmPd').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.jkmPd').off('click');
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
    add: function(){
      $('.model').show();
      $('.jkmPd .add-page-model').show();
      this.activeBgIndex = 0
      this.qybz = ''
      this.nsrsbhList = []
			this.modelData = {
				nsrsbh: '',
				nsrmc: '',
				jkmY: '',
				yxq: ''
			}
    },
    updateJkm: function(){
      $('.model').show();
      $('.jkmPd .updateJkm-page-model').show();
			components.updateJkmjkmPd.isFirst = this.isFirst
      components.updateJkmjkmPd.componentsName = this.propsToPager.componentsName
      components.updateJkmjkmPd.isEdit = this.propsToPager.isEdit
      components.updateJkmjkmPd.initData();
      components.updateJkmjkmPd.setNsrsbh({nsrsbh: this.pdData.nsrsbh,nsrmc:this.pdData.nsrMc});
      components.updateJkmjkmPd.modelData.jkmN = this.pdData.jkmN;
			this.isFirst = false;
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
          $('.jkmPd .pd-page-model').show();
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    hideModelPd: function(){
      $('.model').hide();
      $('.jkmPd .pd-page-model').hide();
      this.pdData = {
        nsrsbh: '',
        nsrmc: '',
        jkmY: '',
        jkmN: '',
        yxq: '',
        pdyj: ''
      }
    },
    savePd: function(){
      var self = this
      var params = {
        pdUuid: this.pdData.pdUuid,
        yxq: this.pdData.yxq,
        pdyj: this.pdData.pdyj,
        jkmN: this.pdData.jkmN
      }
      ajax("POST","/sszj/jkmpd/pdSave",params).done(function(res){
        if(res.code=='0'){
          tools.info('保存成功！');
          self.search(1);
          self.hideModelPd();
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    submit: function(){
      var self = this
      var params = {
        pdUuid: this.pdData.pdUuid,
        yxq: this.pdData.yxq,
        pdyj: this.pdData.pdyj,
        jkmN: this.pdData.jkmN
      }
      var rules = [
        { name: 'yxq', message: '评定有效期不能为空！'},
        { name: 'pdyj', message: '评定意见不能为空！'},
        { name: 'jkmN', message: '新健康码不能为空！'},
      ]
      var validHandler = this.validHandler(rules,params)
      if (!validHandler) return;
      ajax("POST","/sszj/jkmpd/pdAgree",params).done(function(res){
        if(res.code=='0'){
          tools.info('提交成功！');
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
        yxq: this.pdData.yxq,
        pdyj: this.pdData.pdyj
      }
      var rules = [
        { name: 'pdyj', message: '评定意见不能为空！'}
      ]
      var validHandler = this.validHandler(rules,params)
      if (!validHandler) return;
      ajax("POST","/sszj/jkmpd/pdReject",params).done(function(res){
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
    delHandler: function(pdUuid){
      var self = this
      tools.confirm('是否确定进行删除操作？', '确定', function(){
        ajax("POST","/sszj/jkmpd/delete",{pdUuid:pdUuid}).done(function(res){
          if(res.code=='0'){
            tools.info('删除成功！');
            self.search(1);
          }else{
            tools.info(res.msg);
          }
        })
      })
    },
		
    // 模糊查询税号，获取税号列表
    inpChangeNsrsbh: function(key){
      this.qybz = this.qybz.trim()
      var qybz = this.qybz
      // 根据企业标志查询，如果使用税号和海关代码查询，至少需要4位，如果使用企业名称，则至少需要2位
      if(/[\u4e00-\u9fa5]/.test(qybz)){
        if(qybz.length<2) return
      } else if (qybz.length < 4) {
        return;
      }
      var params = {
        qybs: qybz
      }
      var self = this
      ajax("POST","/sszj/jkmpd/nsrxx/list",params, false, false, true ).done(function(res){
        if(res.code=='0'){
          self.nsrsbhList = res.data
          self.showNsrsbh()
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    // 显示纳税人识别号弹框
    showNsrsbh: function(){
      var list = this.nsrsbhList
      if (list&&list.length>0) {
        this.showNsrsbhList = true
      }
    },
    // 隐藏纳税人识别号弹框
    hideNsrsbh: function(e){
      if($(e.target).parent().hasClass('nsrsbh-group')) return
      this.showNsrsbhList = false
    },
    nsrsbhEnterSearch: function(e) {
      e.target.blur()
      this.showNsrsbhList = false
    },
    keydown: function(e, id){
      var index = this.activeBgIndex
      var len = this.nsrsbhList.length
      //38:上  40:下
      if (e.keyCode == 38) {
        if (index > 0) {
          index --
        } else {
          index = len - 1
        }
        this.stopDefault(e)
      } else if (e.keyCode == 40) {
        if (index < len-1) {
          index ++
        } else {
          index = 0
        }
        this.stopDefault(e)
      }
      this.activeBgIndex = index
      var pHeight = $('#'+id+' p:first').height() // p元素高度
      if (index > 2) {
        $("#"+id).scrollTop(pHeight * (index - 3) + 9)
      } else {
        $("#"+id).scrollTop(0)
      }
      if(e.keyCode==13){  // enter
        var item = {}
        item = this.nsrsbhList[index]
        if (item) {
          this.setNsrsbh(item)
        }
      }
    },
    //阻止事件执行
    stopDefault:function (event) {
      //阻止默认浏览器动作(W3C)   
      if (event && event.preventDefault) {
          //火狐的 事件是传进来的e  
          event.preventDefault();
      }
      //IE中阻止函数器默认动作的方式   
      else {
          //ie 用的是默认的event  
          event.returnValue = false;
      }
    },
    setNsrsbh: function(item){
      var self = this
			this.modelData.nsrmc = ''
			api.jkmpdCheckJkmPd({nsrsbh:item.nsrsbh}).done(function(res){
				if(res.code=='0'){
          self.modelData.nsrsbh = item.nsrsbh
          self.modelData.nsrmc = item.nsrmc
          self.showNsrsbhList = false
					self.getJkmY();
        }
      })
    },
    blur: function(){
      var self = this
      setTimeout(function(){
        self.showNsrsbhList = false
      },500)
    },
		saveAdd: function(){
			var self = this
			var rules = [
        { name: 'nsrsbh', message: '纳税人识别号不能为空！'},
        { name: 'jkmY', message: '原健康码不能为空！'}
      ]
      var validHandler = this.validHandler(rules,this.modelData)
      if (!validHandler) return;
			api.jkmpdAdd(this.modelData).done(function(res){
				if(res.code=='0'){
					tools.info('新增成功！');
					self.hideModelAdd();
          self.search(1);
        }
      })
		},
		hideModelAdd: function(){
      $('.model').hide();
      $('.jkmPd .add-page-model').hide();
		},
		getJkmY: function(){
			var self = this
			api.getJkmY({nsrsbh: this.modelData.nsrsbh}).done(function(res){
				if(res.code=='0'){
					self.modelData.jkmY = res.data.jkmY
        }
      })
		}
	}
});