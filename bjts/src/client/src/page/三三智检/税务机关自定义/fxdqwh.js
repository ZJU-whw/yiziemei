var fxdqwh=require("./fxdqwh.html");
avalon.component('fxdqwh', {
	template:fxdqwh,
	defaults: {
		params:{},
		act:1,
		tcode: "fxdqwhcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			swjgDm:"",
			xzqh:"",
			yxqQ:"",
			yxqZ:"",
			qybz:"Y",
			fxms:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    xzqh: '',
    modelData: {
      id: '',
      xzqhDm: '',
      xzqhMc: '',
      yxqQ: '',
      yxqZ: '',
      qybz: 'Y',
      fxms: ''
    },
    addTitle: '',
    tableData: [],
		onReady:function(){
			this.initTree();
      this.getXzqh();
			this.createTable();
      this.initDate();
		},
    initDate: function(){
      $('.fxdqwh .datepicker.date-day').datepicker({
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
				{ name: "xzqhDm", label: "行政区划", index: "xzqhDm",width: 80, align:"center",sortable: true },
				{ name: "xzqhMc", label: "地区名称", index: "xzqhMc",width: 100, align:"left",sortable: true },
				{ name: "yxqQ", label: "有效期起", index: "yxqQ",width: 70, align:"center",sortable: true },
				{ name: "yxqZ", label: "有效期止", index: "yxqZ",width: 70, align:"center",sortable: true },
				{ name: "fxms", label: "风险描述", index: "fxms",width: 140, align:"left",sortable: false },
				{ name: "qybz", label: "启用标志", index: "qybz",hidden: true },
				{ name: "qybzMc", label: "启用标志", index: "qybzMc",width: 50, align:"center",sortable: false },
				{ name: "crCzrymc", label: "录入人", index: "crCzrymc",width: 70, align:"left",sortable: true },
				{ name: "crTime", label: "录入时间", index: "crTime",width: 128, align:"center",sortable: true },
				{ name: "upCzrymc", label: "修改人", index: "upCzrymc",width: 70, align:"left",sortable: true },
				{ name: "upTime", label: "修改时间", index: "upTime",width: 128, align:"center",sortable: true },
				{ name: "op", label: "操作", width: 130, align: "center", resizable: false, search: false, sortable: false}
			];
			$("#fxdqwh-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#fxdqwh-tablePager',
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
					return $(".fxdqwh .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
          var row = $("#fxdqwh-table").jqGrid("getRowData", rowid)
          if($(e.target).hasClass('disabled')) return false;
					if($(e.target).hasClass('edit')){
            self.modelData = {
              id: row.id,
              xzqhDm: row.xzqhDm,
              xzqhMc: row.xzqhMc,
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
					var pageNo=tools.getPageNo(pgButton,"fxdqwh-table");
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
          var ids = $("#fxdqwh-table").getDataIDs();
          for (var i = 0; i<ids.length; i++) {
            var rowData = $("#fxdqwh-table").getRowData(ids[i]);
            if (rowData.qybz == "N") { // 有效标志=N的指标记录用浅灰背景色
              $('#' + ids[i]).find("td").css("background", '#eee');
            } else if (rowData.swjgDm != avalonRoot.user.swjgDm) {
              $('#' + ids[i]).find("td").css("background", '#d9ecff');
            }
          }
        }
			});
			$("#fxdqwh-table").jqGrid('setFrozenColumns');
			tools.HeiKj('fxdqwh', 'fxdqwh-table');
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
    // 初始化多选框，注销或录入税务机关不是当前用户所属税务机关的禁止勾选
    checkboxInit: function(data){
			var self = this
      setTimeout(function(){
        if(data){
          for(var i=0; i<data.length; i++){
            var curRow = data[i];
            if (curRow.qybz == "N" || curRow.swjgDm != avalonRoot.user.swjgDm){
              $('#jqg_fxdqwh-table_'+curRow.id).attr('disabled', true);
              $('#jqg_fxdqwh-table_'+curRow.id).attr('checked', false);
            }
          }
        }
      }, 100)
    },
		showModel: function(title){
			this.addTitle = title
			$('.model').show();
			$('.fxdqwh .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.fxdqwh .add-page-model').hide();
      this.modelData = {
        id: '',
        xzqhDm: '',
        xzqhMc: '',
        yxqQ: '',
        yxqZ: '',
        qybz: 'Y',
        fxms: '',
        crCzrymc: '',
        upCzrymc: ''
      }
		},
		search:function(pageNo){
			var self=this;
			if(self.searchData.yxqQ && self.searchData.yxqZ && self.searchData.yxqZ<self.searchData.yxqQ){
				tools.info('有效期截止日期必须大于起始日期');
				return
			}
			this.searchData.pageSize = $(".ui-pg-selbox", $('.fxdqwh')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
			$("#fxdqwh-table").jqGrid('clearGridData')
			ajax("POST","/sszj/fxdq/list",params).done(function(res){
				if(res.code=='0'){
          self.tableData = res.data.rows
					$("#fxdqwh-table")[0].addJSONData(res.data);
					tools.HeiKj('fxdqwh', 'fxdqwh-table');
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
				$.fn.zTree.init($(".fxdqwh .fxdqwhSwjgTree"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.fxdqwh .select-sub').toggle();
			$('.fxdqwh .select-wrapper .icon').toggleClass("active");
			if ($('.fxdqwh .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.fxdqwh .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.fxdqwh .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.fxdqwh .select-sub').hide();
            $('.fxdqwh .select-wrapper .icon').removeClass('active');
            $('.fxdqwh .select-wrapper .icon').attr("title","展开查询条件");
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.fxdqwh').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.fxdqwh').off('click');
		},
		exform:function(){
			var self=this;
			if($('#fxdqwh-table').jqGrid('getRowData').length<=0){
					tools.info("请先查询列表");
					return ;
			}
			var params = tools.clone(self.searchData)
			tools.exform(params, '/sszj/export/fxdq/list')
		},
		reset: function() {
			this.searchData = {
        swjgDm:"",
        xzqh:"",
        yxqQ:"",
        yxqZ:"",
        qybz:"Y",
        fxms:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= '';
      this.xzqh = ''
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
    getXzqh: function(){
      var self = this
      var setting = {
				callback:{
          beforeClick: function(treeId, treeNode, clickFlag){
            return treeNode.xzqhjc != '1';
          },
          beforeDblClick: function(treeId, treeNode){
            return treeNode.xzqhjc != '1';
          },
					onClick:function(e,id,node){
            self.modelData.xzqhDm = node.xzqhDm;
            self.modelData.xzqhMc = node.xzqhmc;
            self.hideTree();
						return;
					},
					onDblClick:function(e,id,node){
            self.modelData.xzqhDm = node.xzqhDm;
            self.modelData.xzqhMc = node.xzqhmc;
            self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"xzqhmc", id: 'xzqhDm'}}
			};
      ajax("POST","/sszj/fxdq/getXzqh",{}).done(function(res){
				if(res.code=='0'){
					$.fn.zTree.init($(".fxdqwh .fxdqwhXzqhTreeAdd"), setting,res.data);
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    },
    saveModel: function(){
      var self = this
      var rules = [
        { name: 'xzqhDm', message: '行政区划不能为空！' },
        { name: 'qybz', message: '启用标志不能为空！' },
      ]
      for (var i=0;i<rules.length;i++) {
        if (this.modelData[rules[i].name] == '') {
          tools.info(rules[i].message);
          return;
        }
      }
			var params = tools.clone(this.modelData)
      ajax("POST","/sszj/fxdq/save",params).done(function(res){
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
					let row = $("#fxdqwh-table").jqGrid("getRowData", this.selRows[i])
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
				ajax("POST","/sszj/fxdq/cancel",{ids:ids}).done(function(res){
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
    }
	}
});