var kjdssd=require("./kjdssd.html");
avalon.component('kjdssd', {
	template:kjdssd,
	defaults: {
		params:{},
		act:1,
		tcode: "kjdssdcx",
		swjgmc: "",
		selRows: [],
    swjgList: [
      "13300000000",
      "13301000000",
      "13302000000",
      "13303000000",
      "13304000000",
      "13305000000",
      "13306000000",
      "13307000000",
      "13308000000",
      "13309000000",
      "13310000000",
      "13311000000",
    ], // 省市级税务机关代码列表
    hasHsPermission: false, // 是否有核实处理权限
		searchData:{
			swjgdm:"",
      nsrsbh:'',
      nsrmc:'',
			// fxqy:"",
			// yxqQ:"",
			// yxqZ:"",
			// qybj:"Y",
			// fxms:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
      id: '',
      nsrsbh: '',
      nsrmc: '',
      // yxqQ: '',
      // yxqZ: '',
      qybj: 'Y',
      // fxms: ''
    },
    plData:{
      qybj: 'Y',
    },
    addTitle: '',
    tableData: [],
    nsrsbhList: [],
    showNsrsbhList: false,
    activeBgIndex: 0,
		onReady:function(){
      this.initParams();
			this.initTree();
			this.createTable();
      this.initDate();
			this.importCallBack();
		},
    initParams: function(){
      if(this.params.swjgDm){
        this.searchData.swjgdm = this.params.swjgDm;
      }else{
        this.searchData.swjgdm = avalonRoot.user.swjgDm;
        this.swjgmc = avalonRoot.user.swjgMc;
      }
      this.hasHsPermission =
          this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
    },
    initDate: function(){
      $('.kjdssd .datepicker.date-day').datepicker({
        dateFormat: 'yy-mm-dd'
      });
    },
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				// { name: "op2", label: "操作", index: "op",width: 130,frozen: true, formatter: function(cellvalue, options, rowObject){
				// 	var text = this.hasHsPermission ? '编辑' : '查看'
				// 	return "<div class='btn edit' style='float: none;display: inline-block;' title='"+text+"'>"+text+"</div>";
				// } },
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "nsrsbh", label: "企业识别号", index: "nsrsbh",width: 140, align:"left",sortable: true },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 160, align:"left",sortable: true },
        { name: "swjgdm", label: "税务机关代码", index: "swjgdm",width: 90, align:"center",sortable: true },
        { name: "qybj", label: "启用标志",width: 60,align:"center", index: "qybj",hidden: false,formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '启用', 'N': '注销'};
					return map[cellvalue];
				} },
				{ name: "cjr", label: "创建人", index: "cjr",width: 80, align:"center",sortable: true },
				{ name: "crtime", label: "创建日期", index: "yxqQ",width: 80, align:"center",sortable: true },
				{ name: "uptime", label: "更新日期", index: "yxqZ",width: 80, align:"center",sortable: true },
				{ name: "op", label: "操作", width: 130, align: "center", resizable: false, search: false, sortable: false,formatter: function(cellvalue, options, rowObject){
					var text = self.hasHsPermission ? '编辑' : '查看'
					return "<div class='btn edit' style='float: none;display: inline-block;' title='"+text+"'>"+text+"</div>";
				}}
			];
			$("#kjdssd-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#kjdssd-tablePager',
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
					return $(".kjdssd .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
          var row = $("#kjdssd-table").jqGrid("getRowData", rowid)
          if($(e.target).hasClass('disabled')) return false;
					if($(e.target).hasClass('edit')){
            let obj = {
              '注销':'N',
              '启用':'Y'
            }
            self.modelData = {
              id: row.id,
              nsrsbh: row.nsrsbh,
              nsrmc: row.nsrmc,
              qybj: obj[row.qybj]?obj[row.qybj]:'Y',
            }
						var text = avalonRoot.user.swjgDm == row.swjgdm ? '编辑' : '查看'
            self.showModel(text);
          }else if($(e.target).hasClass('del')){
						self.delHandler(row.id);
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
					var pageNo=tools.getPageNo(pgButton,"kjdssd-table");
					self.search(pageNo);
				},
        onSelectRow: function (rowid, status) {
          var index = self.selRows.indexOf(rowid);
          if (status) {
            self.selRows.push(rowid)
          } else {
            self.selRows.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          if (status) {
            self.selRows = JSON.parse(JSON.stringify(rowids));
          } else {
            self.selRows = [];
          }
          // self.checkboxInit(self.tableData);
        },
        gridComplete: function(){
          var ids = $("#kjdssd-table").getDataIDs();
          for (var i = 0; i<ids.length; i++) {
            var rowData = $("#kjdssd-table").getRowData(ids[i]);
            if (rowData.qybj == "N") { // 有效标志=N的指标记录用浅灰背景色
              $('#' + ids[i]).find("td").css("background", '#eee');
            } else if (rowData.swjgdm != avalonRoot.user.swjgDm) {
              $('#' + ids[i]).find("td").css("background", '#d9ecff');
            }
          }
        }
			});
			$("#kjdssd-table").jqGrid('setFrozenColumns');
			tools.HeiKj('kjdssd', 'kjdssd-table');
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			self.search(1);
		},
    // 初始化多选框，注销或录入税务机关不是当前用户所属税务机关的禁止勾选
    checkboxInit: function(data){
			var self = this
      setTimeout(function(){
        if(data){
          for(var i=0; i<data.length; i++){
            var curRow = data[i];
            if (curRow.qybj == "N" || curRow.swjgdm != avalonRoot.user.swjgDm){
              $('#jqg_kjdssd-table_'+curRow.id).attr('disabled', true);
              $('#jqg_kjdssd-table_'+curRow.id).attr('checked', false);
            }
          }
        }
      }, 100)
    },
		showModel: function(title){
			this.addTitle = title
			$('.model').show();
			$('.kjdssd .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.kjdssd .add-page-model').hide();
      this.modelData = {
        id: '',
        nsrsbh: '',
        nsrmc: '',
        qybj: 'Y',
      }
      this.nsrsbhList = []
      this.showNsrsbhList = false
      this.activeBgIndex = 0
		},
    showPlModel: function(){
			this.addTitle = '批量操作'
			$('.model').show();
			$('.kjdssd .page-model-end').show();
		},
		hidePlModel: function(){
			$('.model').hide();
			$('.kjdssd .page-model-end').hide();
      this.plData = {
        qybj: 'Y',
      }
		},
		search:function(pageNo){
			var self=this;
			if(self.searchData.yxqQ && self.searchData.yxqZ && self.searchData.yxqZ<self.searchData.yxqQ){
				tools.info('有效期截止日期必须大于起始日期');
				return
			}
			this.searchData.pageSize = $(".ui-pg-selbox", $('.kjdssd')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#kjdssd-table").jqGrid('clearGridData')
			ajax("POST","/cxfw/sdqy/list",params).done(function(res){
				if(res.code=='0'){
          self.tableData = res.data.rows
					$("#kjdssd-table")[0].addJSONData(res.data);
					tools.HeiKj('kjdssd', 'kjdssd-table');
          // self.checkboxInit(res.data && res.data.rows);
					self.closeHyper()
          self.selRows = []
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
						self.searchData.swjgdm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					},
					onDblClick:function(e,id,node){
						self.searchData.swjgdm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			};
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				$.fn.zTree.init($(".kjdssd .kjdssdSwjgTree"), setting,data);
        var treeObj = $.fn.zTree.getZTreeObj('kjdssdSwjgTree');//ztree树的ID
        var node = treeObj.getNodeByParam("id", self.searchData.swjgdm);//根据ID找到该节点
        self.swjgmc = node.text
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.kjdssd .select-sub').toggle();
			$('.kjdssd .select-wrapper .icon').toggleClass("active");
			if ($('.kjdssd .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.kjdssd .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.kjdssd .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.kjdssd .select-sub').hide();
            $('.kjdssd .select-wrapper .icon').removeClass('active');
            $('.kjdssd .select-wrapper .icon').attr("title","展开查询条件");
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.kjdssd').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.kjdssd').off('click');
		},
		exform:function(){
			var self=this;
			if($('#kjdssd-table').jqGrid('getRowData').length<=0){
					tools.info("请先查询列表");
					return ;
			}
			var params = tools.clone(self.searchData)
			tools.exform(params, '/cxfw/sdqy/list/export')
		},
		exformModel:function(){
			tools.exform({}, '/cxfw/sdqy/template')
		},
		reset: function() {
			this.searchData = {
        swjgdm:"",
        nsrsbh:'',
        nsrmc:'',
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= '';
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
    saveModel: function(){
      var self = this
      var rules = [
        { name: 'nsrsbh', message: '企业识别号不能为空！' },
        { name: 'qybj', message: '启用标志不能为空！' },
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return;
        }
      }
			var params = tools.clone(this.modelData)
      var id = params.id
      var qybj = params.qybj
    if(!params.id){
      delete params.id
    }
    var url = ''
    if(self.addTitle == '新增'){
      url = '/cxfw/sdqy/add'
    }else if(self.addTitle == '编辑'){
      url = '/cxfw/sdqy/update'
      params = {
        ids:[id],
        qybj:qybj
      }
    }
      ajax("POST",url,params).done(function(res){
				if(res.code=='0'){
					tools.info('保存成功！');
          self.hideModel();
          self.search(1);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    },
    delHandler: function(id){
      this.showPlModel()
    },
    savePl(){
      var self = this
      if (this.selRows.length <= 0) {
        tools.info('请先选择要操作的项！');
        return;
      }
      	ajax("POST","/cxfw/sdqy/update",{ids:this.selRows,qybj:self.plData.qybj}).done(function(res){
					if(res.code=='0'){
						tools.info('注销成功！');
						self.search(1);
            self.hidePlModel()
					}else{
						tools.info(res.msg);
					}
				}).fail(function(err){
					tools.info(err);
				})
    },
		showImportModel: function(){
      $('.model').show();
			$('.kjdssd .import-page-model').show();
    },
    hideImportModel: function(){
      $('.model').hide();
			$('.kjdssd .import-page-model').hide();
    },
    importCallBack: function(){
      var self = this;
      $('#kjdssdFileupload').fileupload({
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
    // 模糊查询税号，获取税号列表
    inpChangeNsrsbh: function(key){
      this[key].nsrmc = ''
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
          this.modelData.nsrsbh = item.nsrsbh
          this.modelData.nsrmc = item.nsrmc
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
      this[key].nsrmc = item.nsrmc
      this.showNsrsbhList = false
    },
	}
});