var fxqywh=require("./fxqywh.html");
avalon.component('fxqywh', {
	template:fxqywh,
	defaults: {
		params:{},
		act:1,
		tcode: "fxqywhcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			swjgDm:"",
			fxqy:"",
			yxqQ:"",
			yxqZ:"",
			qybz:"Y",
			fxms:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
      id: '',
      qysbh: '',
      qymc: '',
      yxqQ: '',
      yxqZ: '',
      qybz: 'Y',
      fxms: ''
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
        this.searchData.swjgDm = this.params.swjgDm;
      }
    },
    initDate: function(){
      $('.fxqywh .datepicker.date-day').datepicker({
        dateFormat: 'yy-mm-dd'
      });
    },
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "op2", label: "操作", index: "op",width: 0,frozen: true, formatter: function(cellvalue, options, rowObject){
          var isOp = avalonRoot.user.swjgDm == rowObject.swjgDm
					var text = isOp ? '编辑' : '查看'
					return "<div class='btn edit' style='float: none;display: inline-block;' title='"+text+"'>"+text+"</div><div class='btn del "+ (isOp && rowObject.qybz !='N' ? '' : 'disabled') +"' style='float: none;display: inline-block;' title='注销'>注销</div>";
				} },
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "swjgDm", label: "税务机关代码", index: "swjgDm",width: 90, align:"center",sortable: true },
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 140, align:"left",sortable: true },
				{ name: "qysbh", label: "企业识别号", index: "qysbh",width: 140, align:"left",sortable: true },
				{ name: "qymc", label: "企业名称", index: "qymc",width: 160, align:"left",sortable: true },
				{ name: "yxqQ", label: "有效期起", index: "yxqQ",width: 80, align:"center",sortable: true },
				{ name: "yxqZ", label: "有效期止", index: "yxqZ",width: 80, align:"center",sortable: true },
				{ name: "fxms", label: "风险描述", index: "fxms",width: 120, align:"left",sortable: false },
				{ name: "qybz", label: "启用标志", index: "qybz",hidden: true },
				{ name: "qybzMc", label: "启用标志", index: "qybzMc",width: 50, align:"center",sortable: false },
				{ name: "crCzrymc", label: "录入人", index: "crCzrymc",width: 70, align:"left",sortable: true },
				{ name: "crTime", label: "录入时间", index: "crTime",width: 128, align:"center",sortable: true },
				{ name: "upCzrymc", label: "修改人", index: "upCzrymc",width: 70, align:"left",sortable: true },
				{ name: "upTime", label: "修改时间", index: "upTime",width: 128, align:"center",sortable: true },
				{ name: "op", label: "操作", width: 130, align: "center", resizable: false, search: false, sortable: false}
			];
			$("#fxqywh-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#fxqywh-tablePager',
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
					return $(".fxqywh .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
          var row = $("#fxqywh-table").jqGrid("getRowData", rowid)
          if($(e.target).hasClass('disabled')) return false;
					if($(e.target).hasClass('edit')){
            self.modelData = {
              id: row.id,
              qysbh: row.qysbh,
              qymc: row.qymc,
              yxqQ: row.yxqQ,
              yxqZ: row.yxqZ,
              qybz: row.qybz,
              fxms: row.fxms
            }
						var text = avalonRoot.user.swjgDm == row.swjgDm ? '编辑' : '查看'
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
					var pageNo=tools.getPageNo(pgButton,"fxqywh-table");
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
          self.checkboxInit(self.tableData);
        },
        gridComplete: function(){
          var ids = $("#fxqywh-table").getDataIDs();
          for (var i = 0; i<ids.length; i++) {
            var rowData = $("#fxqywh-table").getRowData(ids[i]);
            if (rowData.qybz == "N") { // 有效标志=N的指标记录用浅灰背景色
              $('#' + ids[i]).find("td").css("background", '#eee');
            } else if (rowData.swjgDm != avalonRoot.user.swjgDm) {
              $('#' + ids[i]).find("td").css("background", '#d9ecff');
            }
          }
        }
			});
			$("#fxqywh-table").jqGrid('setFrozenColumns');
			tools.HeiKj('fxqywh', 'fxqywh-table');
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
            if (curRow.qybz == "N" || curRow.swjgDm != avalonRoot.user.swjgDm){
              $('#jqg_fxqywh-table_'+curRow.id).attr('disabled', true);
              $('#jqg_fxqywh-table_'+curRow.id).attr('checked', false);
            }
          }
        }
      }, 100)
    },
		showModel: function(title){
			this.addTitle = title
			$('.model').show();
			$('.fxqywh .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.fxqywh .add-page-model').hide();
      this.modelData = {
        id: '',
        qysbh: '',
        qymc: '',
        yxqQ: '',
        yxqZ: '',
        qybz: 'Y',
        fxms: '',
        crCzrymc: '',
        upCzrymc: ''
      }
      this.nsrsbhList = []
      this.showNsrsbhList = false
      this.activeBgIndex = 0
		},
		search:function(pageNo){
			var self=this;
			if(self.searchData.yxqQ && self.searchData.yxqZ && self.searchData.yxqZ<self.searchData.yxqQ){
				tools.info('有效期截止日期必须大于起始日期');
				return
			}
			this.searchData.pageSize = $(".ui-pg-selbox", $('.fxqywh')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#fxqywh-table").jqGrid('clearGridData')
			ajax("POST","/sszj/fxqy/list",params).done(function(res){
				if(res.code=='0'){
          self.tableData = res.data.rows
					$("#fxqywh-table")[0].addJSONData(res.data);
					tools.HeiKj('fxqywh', 'fxqywh-table');
          self.checkboxInit(res.data && res.data.rows);
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
				$.fn.zTree.init($(".fxqywh .fxqywhSwjgTree"), setting,data);
        var treeObj = $.fn.zTree.getZTreeObj('fxqywhSwjgTree');//ztree树的ID
        var node = treeObj.getNodeByParam("id", self.searchData.swjgDm);//根据ID找到该节点
        self.swjgmc = node ? node.text : ''
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.fxqywh .select-sub').toggle();
			$('.fxqywh .select-wrapper .icon').toggleClass("active");
			if ($('.fxqywh .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.fxqywh .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.fxqywh .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.fxqywh .select-sub').hide();
            $('.fxqywh .select-wrapper .icon').removeClass('active');
            $('.fxqywh .select-wrapper .icon').attr("title","展开查询条件");
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.fxqywh').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.fxqywh').off('click');
		},
		exform:function(){
			var self=this;
			if($('#fxqywh-table').jqGrid('getRowData').length<=0){
					tools.info("请先查询列表");
					return ;
			}
			var params = tools.clone(self.searchData)
			tools.exform(params, '/sszj/export/fxqy/list')
		},
		exformModel:function(){
			tools.exform({}, '/sszj/export/fxqy/template')
		},
		reset: function() {
			this.searchData = {
        swjgDm:"",
        fxqy:"",
        yxqQ:"",
        yxqZ:"",
        qybz:"Y",
        fxms:"",
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
        { name: 'qysbh', message: '企业识别号不能为空！' },
        { name: 'qybz', message: '启用标志不能为空！' },
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return;
        }
      }
			var params = tools.clone(this.modelData)
      ajax("POST","/sszj/fxqy/save",params).done(function(res){
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
			var self = this
			var ids = ''
			if (id) {
				ids = id
			} else {
				var idsArr = []
				for (var i = 0; i < this.selRows.length;i++ ){
					let row = $("#fxqywh-table").jqGrid("getRowData", this.selRows[i])
					if (row.qybz == "Y" && row.swjgDm == avalonRoot.user.swjgDm) {
						idsArr.push(row.id);
					}
				}
				ids = idsArr.join(',')
				if (idsArr.length <= 0) {
					tools.info('请先选择要注销的项！');
					return;
				}
			}
			tools.confirm('确定执行注销操作？', '确定', function(){
				ajax("POST","/sszj/fxqy/cancel",{ids:ids}).done(function(res){
					if(res.code=='0'){
						tools.info('注销成功！');
						self.search(1);
					}else{
						tools.info(res.msg);
					}
				}).fail(function(err){
					tools.info(err);
				})
			})
    },
		showImportModel: function(){
      $('.model').show();
			$('.fxqywh .import-page-model').show();
    },
    hideImportModel: function(){
      $('.model').hide();
			$('.fxqywh .import-page-model').hide();
    },
    importCallBack: function(){
      var self = this;
      $('#fxqywhFileupload').fileupload({
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
      this[key].qymc = ''
      this[key].qysbh = this[key].qysbh.trim()
      var qysbh = this[key].qysbh
      if (qysbh.length<4) {
        return;
      }
      var params = {
        qybs: qysbh
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
          this.modelData.qysbh = item.nsrsbh
          this.modelData.qymc = item.nsrmc
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
      this[key].qysbh = item.nsrsbh
      this[key].qymc = item.nsrmc
      this.showNsrsbhList = false
    },
	}
});