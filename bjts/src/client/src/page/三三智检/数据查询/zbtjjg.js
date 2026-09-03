var zbtjjg=require("./zbtjjg.html");
avalon.component('zbtjjg', {
	template:zbtjjg,
	defaults: {
		params:{},
		act:1,
		tcode: "zbtjjgcx",
		searchData:{
      swjg: "",
			nsrbs:"",
      tsjsfs: "",
			bgqQ: "",
			bgqZ: "",
			sqDateQ: "",
			sqDateZ: "",
			nsrzt: [],
			zqlx: "年",
			zxFlag: "",
			qylx: "",
			orderSql:"",
			pageSize:config.pageSize,
		},
    tableData: [],
    nsrsbhList: [],
    showNsrsbhList: false,
    activeBgIndex: 0,
    swjgmc: '',
		nsrztList: [],
    nsrztMap: {},
		bgqList: [],
		bgqY: '',
		bgqJd: '',
		onReady:function(){
      try {
				this.searchData.swjg=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
      this.getDictList();
			this.initTree();
			this.createTable();
			this.initDate();
			this.getBgqList();
		},
    initParams: function(){
      if(this.params.nsrbs){
        this.searchData.nsrbs = this.params.nsrbs;
				this.search(1);
      }
    },
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "op2", label: "操作", index: "op2",width: 0, frozen: true, sortable: false,formatter: function(cellvalue, options, rowObject){
          var op = "<div style='text-align:center;'><div class='btn op-refresh' style='float: none;display: inline-block;' title='刷新'>刷新</div>";
					op +="</div>";
					return op;
        } },
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"left",sortable: true },
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 200, align:"left",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 160, align:"left",sortable: true },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 200, align:"left",sortable: true },
				{ name: "tsjsfs", label: "退税计算方式", index: "tsjsfs",width: 80, align:"center",sortable: true },
				{ name: "bgqQ", label: "报告期起", index: "bgqQ",width: 80, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
            return "<span class='link toMx'>"+cellvalue+"</span>";
				} },
				{ name: "bgqZ", label: "报告期止", index: "bgqZ",width: 80, align:"center",sortable: true, formatter: function(cellvalue, options, rowObject){
          return "<span class='link toMx'>"+cellvalue+"</span>";
        } },
				{ name: "sxzt", label: "状态", index: "sxzt",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
          return (rowObject.rwzt ? (rowObject.rwzt || '') :( rowObject.sxzt || ''));
        } },
				{ name: "sxsj", label: "时间", index: "sxsj",width: 140, align:"center",sortable: false },
				{ name: "sqDate", label: "备案日期", index: "sqDate",width: 80, align:"center",sortable: false },
				{ name: "nsrzt", label: "纳税人状态", index: "nsrzt",width: 90, align:"center",sortable: false },
				{ name: "qylx", label: "企业类型", index: "qylx",width: 60, align:"center",sortable: false },
				{ name: "bazt", label: "备案撤回标志", index: "bazt",width: 90, align:"center",sortable: false },
				{ name: "djxh", label: "登记序号", index: "djxh",hidden: true },
				{ name: "bgqId", label: "报告期Id", index: "bgqId",hidden: true },
				{ name: "bgqIdJq", label: "报告期基期Id", index: "bgqIdJq",hidden: true },
				{ name: "jqQ", label: "基期起", index: "jqQ",hidden: true },
				{ name: "jqZ", label: "基期止", index: "jqZ",hidden: true },
				{ name: "swjgDm", label: "税务机关代码", index: "swjgDm",hidden: true },
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",hidden: true },
				{ name: "op", label: "操作", width: 130, align: "center", resizable: false, search: false, sortable: false}
			];
			$("#zbtjjg-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#zbtjjg-tablePager',
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
					return $(".zbtjjg .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
          var row = $("#zbtjjg-table").jqGrid("getRowData", rowid)
          if($(e.target).hasClass('disabled')) return false;
					if($(e.target).hasClass('toMx')){
            var item = {}
            for (var i=0;i<self.tableData.length;i++) {
              if (row.bgqId == self.tableData[i].bgqId) {
                item = self.tableData[i]
                break;
              }
            }
						var params = tools.clone(item)
						avalonRoot.addTab({title:"出口企业指标统计（一户式）结果详情",component:"zbtjjgMX",params:params});
						return false;
					}else if($(e.target).hasClass('op-refresh')){
      			api.zbdataRefresh({bgqId:row.bgqId}).done(function(res){
							if(res.code=='0'){
								tools.info('刷新成功！');
								self.search(1);
							}
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
					var orderSql = index + ' ' + sortorder;
					self.searchData.orderSql = orderSql;
					self.search(1);
					return;
				},
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"zbtjjg-table");
					self.search(pageNo);
				}
			});
			$("#zbtjjg-table").jqGrid('setFrozenColumns');
			tools.HeiKjNoSel('zbtjjg', 'zbtjjg-table');
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
			this.initParams();
		},
		search:function(pageNo){
			var self=this;
			if (this.searchData.zqlx == '季' && this.bgqY && this.bgqJd == '') {
				tools.info('请选择报告期季度!');
				return;
			}
			if (this.bgqY != '') {
				this.bgqHandle()
			}
			var valid = tools.checkDate(this.searchData.sqDateQ,this.searchData.sqDateZ)
			if (!valid) {
				tools.info('备案日期止不能小于备案日期起！');
				return;
			}
			this.searchData.pageSize = $(".ui-pg-selbox", $('.zbtjjg')).val() || 20;
			var params=tools.clone(self.searchData);
			var nsrzt = params.nsrzt.map(function(item){return "'"+item+"'"})
			params.nsrzt = nsrzt.join(',');
			params.pageNo=pageNo;
			$("#zbtjjg-table").jqGrid('clearGridData')
			ajax("POST","/sszj/zbdata/result/list",params).done(function(res){
				if(res.code=='0'){
          self.tableData = res.data.rows
					$("#zbtjjg-table")[0].addJSONData(res.data);
          tools.HeiKjNoSel('zbtjjg', 'zbtjjg-table');
					self.closeHyper()
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		reset: function() {
			this.searchData = {
        swjg: avalonRoot.user.swjgDm,
			  nsrbs:"",
        tsjsfs: "",
				bgqQ: "",
				bgqZ: "",
				sqDateQ: "",
				sqDateZ: "",
				nsrzt: [],
				zqlx: "年",
				zxFlag: "",
				qylx: "",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.bgqY = "";
			this.bgqJd = "";
			this.swjgmc= avalonRoot.user.swjgMc;
			this.initMultiselect()
		},
    // 模糊查询税号，获取税号列表
    inpChangeNsrsbh: function(key){
      this[key].nsrsbh = this[key].nsrsbh.trim()
      var nsrsbh = this[key].nsrsbh
      if (nsrsbh.length<4) {
        return;
      }
      var params = {
        qybs: nsrsbh
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
          this.searchData.nsrsbh = item.nsrsbh
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
    setNsrsbh: function(item, key){
      this[key].nsrsbh = item.nsrsbh
      this.showNsrsbhList = false
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
				$.fn.zTree.init($(".zbtjjg .treeDiv"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
    showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.zbtjjg').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.zbtjjg').off('click');
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
		initDate: function(){
			var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
			$('.zbtjjg .datepicker.date-day').datetimepicker(options)
		},
		showHyper:function(){
			$('.zbtjjg .select-sub').toggle();
			$('.zbtjjg .select-wrapper .icon').toggleClass("active");
			if ($('.zbtjjg .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.zbtjjg .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.zbtjjg .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
    closeHyper:function(){
      $('.zbtjjg .select-sub').hide();
      $('.zbtjjg .select-wrapper .icon').removeClass('active');
      $('.zbtjjg .select-wrapper .icon').attr("title","展开查询条件");
    },
		getDictList: function(){
			var self = this
			var params = {
				zbdldm: '1',
				zbxms: ["dj.nsrzt"]
			}
			ajax("POST","/sszj/xmgl/dynamic/init/other",params).done(function(res){
				if(res.code=='0'){
					var data = res.data.fzItemsOther
          self.nsrztList = data[0].values
          for (var i=0;i<self.nsrztList.length;i++) {
            var item = self.nsrztList[i]
            self.nsrztMap[item.code] = item.name
          }
					self.initMultiselect(self.nsrztList)
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
			let id = '#zbtjjg_select_nsrzt'
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
					let values = self.searchData.nsrzt
					if (checked) {
						values.push(val)
					} else {
						let i = values.indexOf(val)
						values.splice(i,1)
					}
					self.searchData.nsrzt = values
				}
			});
			$(id).multiselect('dataprovider', options);
		},
		getBgqList: function(){
			var currentY = new Date().getFullYear();
			var len = currentY - 2018
			this.bgqList = []
			for (var i=0;i<len;i++) {
				this.bgqList.push(2019+i)
			}
		},
		bgqHandle: function(){
			if (this.searchData.zqlx == '年') {
				this.searchData.bgqQ = this.bgqY + '-01-01'
				this.searchData.bgqZ = this.bgqY + '-12-31'
			} else {
				this.searchData.bgqQ = tools.getQuarterStartDate(this.bgqY, this.bgqJd)
				this.searchData.bgqZ = tools.getQuarterEndDate(this.bgqY, this.bgqJd)
			}
		}
	}
});