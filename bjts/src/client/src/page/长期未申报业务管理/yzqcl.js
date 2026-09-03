var yzqcl=require("./yzqcl.html");
avalon.component('yzqcl', {
	template:yzqcl,
	defaults: {
		params:{},
		act:1,
		tcode: "yzqclcx",
		swjgmc: "",
		selRows: [],
    firstCreate:true,
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
      qyhgdm:'',
      ckpzhm:'',
      ckrqQ:'',
      ckrqZ:'',
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
      djxh: '',
      nsrsbh: '',
      nsrmc: '',
      tsjsffdm: '',
      ckbgdh: '',
      ckrq1: '',
      ckspDm: '',
      gfhhgspmc: '',
      jgfsDm: '',
      rmblaj: '',
      dyjldwDm: '',
      cksl: '',
      wsbsl: '',
      zsl: '',
      tsl: '',
      mylaj: '',
    },
    plData:{
      zmtbz: '1',
    },
    addTitle: '',
    tableData: [],
    nsrsbhList: [],
    showNsrsbhList: false,
    activeBgIndex: 0,
    activeIndex:0,
		onReady:function(){
      this.initParams();
			this.initTree();
			this.createTableWbsj();
      this.createTableYqz();
      this.initDate();
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
      $('.yzqcl .datepicker.date-day').datepicker({
        dateFormat: 'yy-mm-dd'
      });
    },
		//copy bg
		createTable:function(id){
			var self=this;
			var columns = [
				// { name: "op2", label: "操作", index: "op",width: 130,frozen: true, formatter: function(cellvalue, options, rowObject){
				// 	var text = this.hasHsPermission ? '编辑' : '查看'
				// 	return "<div class='btn edit' style='float: none;display: inline-block;' title='"+text+"'>"+text+"</div>";
				// } },
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: false },
				{ name: "djxh", label: "登记序号", index: "nsrsbh",hidden:true,width: 140, align:"left",sortable: false },
				{ name: "nsrsbh", label: "企业识别号", index: "nsrsbh",width: 140, align:"left",sortable: false },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 160, align:"left",sortable: false },
				{ name: "tsjsffdm", label: "退税计算方式", index: "nsrsbh",width: 90, align:"center",sortable: false },
				{ name: "ckbgdh", label: "报关单号/代理证明号", index: "nsrsbh",width: 160, align:"center",sortable: false },
				{ name: "ckrq1", label: "出口日期", index: "nsrsbh",width: 120, align:"center",sortable: false },
				{ name: "ckspDm", label: "商品代码", index: "nsrsbh",width: 120, align:"center",sortable: false },
				{ name: "gfhhgspmc", label: "商品名称", index: "nsrsbh",width: 140, align:"left",sortable: false },
				{ name: "jgfsMc", label: "监管方式", index: "nsrsbh",width: 90, align:"center",sortable: false },
				{ name: "mylaj", label: "美元离岸价", index: "nsrsbh",width: 100, align:"right",sortable: false,formatter:function(cellvalue, options, rowObject){
          return avalon.filters.number(cellvalue,2);
      } },
				{ name: "rmblaj", label: "人民币离岸价", index: "nsrsbh",width: 100, align:"right",sortable: false,formatter:function(cellvalue, options, rowObject){
          return avalon.filters.number(cellvalue,2);
      } },
				{ name: "jldwmc", label: "法定单位", index: "nsrsbh",width: 70, align:"center",sortable: false },
				{ name: "cksl", label: "出口数量", index: "nsrsbh",width: 70, align:"right",sortable: false },
				{ name: "wsbsl", label: "剩余未申报数量", index: "nsrsbh",width: 90, align:"right",sortable: false },
				{ name: "zssl", label: "征税率", index: "nsrsbh",width: 70, align:"right",sortable: false },
				{ name: "tsl", label: "退税率", index: "nsrsbh",width: 70, align:"right",sortable: false },
        { name: "zmtbz", label: "征免退标志",width: 140,align:"center", index: "qyqrZt",hidden:self.activeIndex=='0' },
        { name: "qyqrZt", label: "企业确认状态",width: 140,align:"center", index: "qyqrZt",hidden:self.activeIndex=='0' },
        { name: "swshZt", label: "审核状态",width: 140,align:"center", index: "swshZt",hidden:self.activeIndex=='0' },
			];
			$('#'+id).jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
        rownumWidth: 50,
				pager: '#'+id+'Pager',
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
					return $(".yzqcl .form").height() -150;
				})(),
				beforeSelectRow:function(rowid,e){
          var row = $('#'+id).jqGrid("getRowData", rowid)
          if($(e.target).hasClass('disabled')) return false;
					if($(e.target).hasClass('edit')){
            for (var key in self.modelData) {
							self.modelData[key] = row[key]
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
					var pageNo=tools.getPageNo(pgButton,id);
					self.search(pageNo,id);
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
        // gridComplete: function(){
        //   var ids = $("#yzqcl-table").getDataIDs();
        //   for (var i = 0; i<ids.length; i++) {
        //     var rowData = $("#yzqcl-table").getRowData(ids[i]);
        //     if (rowData.qybj == "N") { // 有效标志=N的指标记录用浅灰背景色
        //       $('#' + ids[i]).find("td").css("background", '#eee');
        //     } else if (rowData.swjgdm != avalonRoot.user.swjgDm) {
        //       $('#' + ids[i]).find("td").css("background", '#d9ecff');
        //     }
        //   }
        // }
			});
      $('#'+id).jqGrid("setGroupHeaders", {
        useColSpanStyle: true,
        groupHeaders: [
          {
            startColumnName: "nsrsbh",
            numberOfColumns: 3,
            titleText: "企业基本信息",
          },
          {
            startColumnName: "ckbgdh",
            numberOfColumns: 12,
            titleText: "报关单信息",
          },
        ],
      });
			$('#'+id).jqGrid('setFrozenColumns');
			// tools.HeiKj('yzqcl', 'yzqcl-table');
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
    // 初始化多选框，注销或录入税务机关不是当前用户所属税务机关的禁止勾选
    // checkboxInit: function(data){
		// 	var self = this
    //   setTimeout(function(){
    //     if(data){
    //       for(var i=0; i<data.length; i++){
    //         var curRow = data[i];
    //         if (curRow.qybj == "N" || curRow.swjgdm != avalonRoot.user.swjgDm){
    //           $('#jqg_yzqcl-table_'+curRow.id).attr('disabled', true);
    //           $('#jqg_yzqcl-table_'+curRow.id).attr('checked', false);
    //         }
    //       }
    //     }
    //   }, 100)
    // },
		showModel: function(title){
			this.addTitle = title
			$('.model').show();
			$('.yzqcl .add-page-model').show();
		},
		hideModel: function(){
			$('.model').hide();
			$('.yzqcl .add-page-model').hide();
      this.modelData = {
        djxh: '',
        nsrsbh: '',
        nsrmc: '',
        tsjsffdm: '',
        ckbgdh: '',
        ckrq1: '',
        ckspDm: '',
        gfhhgspmc: '',
        jgfsDm: '',
        rmblaj: '',
        dyjldwDm: '',
        cksl: '',
        wsbsl: '',
        zsl: '',
        tsl: '',
        mylaj: '',
      }
      this.nsrsbhList = []
      this.showNsrsbhList = false
      this.activeBgIndex = 0
		},
    showPlModel: function(){
			this.addTitle = '处理'
			$('.model').show();
			$('.yzqcl .page-model-end').show();
		},
		hidePlModel: function(){
			$('.model').hide();
			$('.yzqcl .page-model-end').hide();
      this.plData ={
        zmtbz: '1'
      }
		},
		search:function(pageNo,id){
			var self=this;
      // var id = this.activeIndex == '0' ? '#yzqcl-wbsj-table' : '#yzqcl-yqz-table'
			if(self.searchData.ckrqQ && self.searchData.ckrqZ && self.searchData.ckrqQ>self.searchData.ckrqZ){
				tools.info('出口截至日期必须大于起始日期');
				return
			}
      if(!self.searchData.nsrsbh&&!self.searchData.qyhgdm&&!self.searchData.nsrmc){
        tools.info('查询条件请至少输入企业税号、企业名称、企业海关代码其中之一');
        return
      }
			this.searchData.pageSize = $(".ui-pg-selbox", $('.yzqcl')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
      if(id&&id == 'yzqcl-wbsj-table'){
        $('#yzqcl-wbsj-table').jqGrid('clearGridData')
        ajax("POST", "/cxfw/cqwsb/yzqcl/list", params).done(function(res){
          if(res.code=='0'){
            self.tableData = res.data.rows
            $('#yzqcl-wbsj-table')[0].addJSONData(res.data);
            self.closeHyper()
            self.selRows = []
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      }else if(id&&id == 'yzqcl-yqz-table'){
        $('#yzqcl-yqz-table').jqGrid('clearGridData')
        ajax("POST", "/cxfw/cqwsb/yzqcl/ycl/list", params).done(function(res){
          if(res.code=='0'){
            self.tableData = res.data.rows
            $('#yzqcl-yqz-table')[0].addJSONData(res.data);
            self.closeHyper()
            self.selRows = []
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      }else{
        $('#yzqcl-wbsj-table').jqGrid('clearGridData')
        $('#yzqcl-yqz-table').jqGrid('clearGridData')
        ajax("POST", "/cxfw/cqwsb/yzqcl/list", params).done(function(res){
          if(res.code=='0'){
            self.tableData = res.data.rows
            $('#yzqcl-wbsj-table')[0].addJSONData(res.data);
            self.closeHyper()
            self.selRows = []
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
        ajax("POST", "/cxfw/cqwsb/yzqcl/ycl/list", params).done(function(res){
          if(res.code=='0'){
            self.tableData = res.data.rows
            $('#yzqcl-yqz-table')[0].addJSONData(res.data);
            self.closeHyper()
            self.selRows = []
          }else{
            tools.info(res.msg);
          }
        }).fail(function(err){
          tools.info(err);
        })
      }
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
				$.fn.zTree.init($(".yzqcl .yzqclSwjgTree"), setting,data);
        var treeObj = $.fn.zTree.getZTreeObj('yzqclSwjgTree');//ztree树的ID
        var node = treeObj.getNodeByParam("id", self.searchData.swjgdm);//根据ID找到该节点
        self.swjgmc = node.text
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.yzqcl .select-sub').toggle();
			$('.yzqcl .select-wrapper .icon').toggleClass("active");
			if ($('.yzqcl .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.yzqcl .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.yzqcl .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.yzqcl .select-sub').hide();
            $('.yzqcl .select-wrapper .icon').removeClass('active');
            $('.yzqcl .select-wrapper .icon').attr("title","展开查询条件");
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.yzqcl').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.yzqcl').off('click');
		},
		exform:function(){
			var self=this;
      if(self.activeIndex == '0'){
        if($('#yzqcl-wbsj-table').jqGrid('getRowData').length<=0){
            tools.info("请先查询列表");
            return ;
        }
      }else{
        if($('#yzqcl-yqz-table').jqGrid('getRowData').length<=0){
          tools.info("请先查询列表");
          return ;
      }
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
        qyhgdm:'',
        ckpzhm:'',
        ckrqQ:'',
        ckrqZ:'',
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= avalonRoot.user.swjgMc;
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
      if (this.selRows.length <= 0) {
        tools.info('请先选择要操作的项！');
        return;
      }
      this.showPlModel()
    },
    savePl(){
      var self = this
      var ckpzs = []
      for (var i = 0; i < this.selRows.length;i++ ){
        let obj = {}
        let djxh,ckbgdh
        if(self.activeIndex == '0'){
          djxh = getCellData("yzqcl-wbsj-table", this.selRows[i], 'djxh')
          ckbgdh = getCellData("yzqcl-wbsj-table", this.selRows[i], 'ckbgdh')
        }else{
          djxh = getCellData("yzqcl-yqz-table", this.selRows[i], 'djxh')
          ckbgdh = getCellData("yzqcl-yqz-table", this.selRows[i], 'ckbgdh')
        }
        obj.djxh = djxh
        obj.ckbgdh = ckbgdh
        ckpzs.push(obj);
      }
      	ajax("POST","/cxfw/cqwsb/yzqcl/submit",{ckpzs:ckpzs,zmtbz:self.plData.zmtbz}).done(function(res){
					if(res.code=='0'){
						tools.info('处理成功！');
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
			$('.yzqcl .import-page-model').show();
    },
    hideImportModel: function(){
      $('.model').hide();
			$('.yzqcl .import-page-model').hide();
    },
    changeTab: function (num) {
      this.activeIndex = num;
      this.selRows = []
      $("#yzqcl-wbsj-table").jqGrid('resetSelection');
      $("#yzqcl-yqz-table").jqGrid('resetSelection');
    },
    createTableWbsj: function(){
      this.createTable( 'yzqcl-wbsj-table');
    },
    createTableYqz: function(){
      this.createTable( 'yzqcl-yqz-table');
    },
	}
});