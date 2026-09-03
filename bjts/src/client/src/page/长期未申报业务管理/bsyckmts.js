var bsyckmts=require("./bsyckmts.html");
avalon.component('bsyckmts', {
	template:bsyckmts,
	defaults: {
		params:{},
		act:1,
		tcode: "bsyckmtscx",
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
      fqsjQ:'',
      fqsjZ:'',
      type:'1',
      sjly:'2',
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
    qySearchType:'ckrq',
    addTitle: '',
    tableData: [],
    nsrsbhList: [],
    showNsrsbhList: false,
    activeBgIndex: 0,
    activeIndex:0,
		onReady:function(){
      this.initParams();
			this.initTree();
			this.createTableSwjg();
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
      this.searchData.fqsjQ = tools.getFirstDayOfYear();
      this.searchData.fqsjZ = tools.getToday();
    },
    initDate: function(){
      $('.bsyckmts .datepicker.date-day').datepicker({
        dateFormat: 'yy-mm-dd'
      });
    },
		//copy bg
		createTable:function(id){
			var self=this;
      var swjgFlag = id=='bsyckmts-swjg-table'
      var qyfzFlag = id=='bsyckmts-qyfz-table'
      var mxcxFlag = id=='bsyckmts-mxcx-table'
			var columns = [
				// { name: "op2", label: "操作", index: "op",width: 130,frozen: true, formatter: function(cellvalue, options, rowObject){
				// 	var text = this.hasHsPermission ? '编辑' : '查看'
				// 	return "<div class='btn edit' style='float: none;display: inline-block;' title='"+text+"'>"+text+"</div>";
				// } },
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: false },
				{ name: "SWJGDM", label: "税务机关代码", index: "SWJGDM",hidden:false,width: 100, align:"center",sortable: false },
				{ name: "SWJGJC", label: "税务机关名称", index: "SWJGJC",hidden:false,width: 140, align:"left",sortable: false },
				{ name: "NSRSBH", label: "纳税人识别号", index: "NSRSBH",hidden:swjgFlag,width: 140, align:"left",sortable: false },
				{ name: "HGQY_DM", label: "企业海关代码", index: "HGQY_DM",hidden:swjgFlag,width: 140, align:"center",sortable: false },
				{ name: "NSRMC", label: "纳税人名称", index: "NSRMC",hidden:swjgFlag,width: 140, align:"left",sortable: false },
				{ name: "HS", label: "户数", index: "HS",hidden:mxcxFlag,width: 70, align:"right",sortable: false },
				{ name: "ZS", label: "记录条数", index: "ZS",hidden:mxcxFlag,width: 70, align:"right",sortable: false },
				{ name: "CJZJ", label: "成交总价", index: "CJZJ",hidden:mxcxFlag,width: 100, align:"right",sortable: false,formatter:function(cellvalue, options, rowObject){
          return avalon.filters.number(cellvalue,2);
      } },
				{ name: "JYZSHS", label: "其中建议征税户数", index: "JYZSHS",hidden:mxcxFlag,width: 130, align:"right",sortable: false },
				{ name: "JYZSZS", label: "其中建议征税记录条数", index: "JYZSZS",hidden:mxcxFlag,width: 130, align:"right",sortable: false },
				{ name: "JYZSCJZJ", label: "其中建议征税成交总价", index: "JYZSCJZJ",hidden:mxcxFlag,width: 130, align:"right",sortable: false,formatter:function(cellvalue, options, rowObject){
          return avalon.filters.number(cellvalue,2);
      } },
				{ name: "JYMSHS", label: "其中建议免税户数", index: "JYMSHS",hidden:mxcxFlag,width: 130, align:"right",sortable: false },
				{ name: "JYMSZS", label: "其中建议免税记录条数", index: "JYMSZS",hidden:mxcxFlag,width: 130, align:"right",sortable: false },
				{ name: "JYMSCJZJ", label: "其中建议免税成交总价", index: "JYMSCJZJ",hidden:mxcxFlag,width: 130, align:"right",sortable: false,formatter:function(cellvalue, options, rowObject){
          return avalon.filters.number(cellvalue,2);
      } },
				{ name: "CKPZHM", label: "出口报关单号/代理证明号", index: "CKPZHM",hidden:!mxcxFlag,width: 170, align:"center",sortable: false },
				{ name: "CKRQ", label: "出口日期", index: "CKRQ",hidden:!mxcxFlag,width: 100, align:"center",sortable: false },
				{ name: "CKSP_DM", label: "出口商品代码", index: "CKSP_DM",hidden:!mxcxFlag,width: 150, align:"center",sortable: false },
				{ name: "CKSP_MC", label: "出口商品名称", index: "CKSP_MC",hidden:!mxcxFlag,width: 140, align:"left",sortable: false },
				{ name: "JGFS_DM", label: "监管方式代码", index: "JGFS_DM",hidden:!mxcxFlag,width: 100, align:"center",sortable: false },
				{ name: "HGCJFS_DM", label: "海关成交方式代码", index: "HGCJFS_DM",hidden:!mxcxFlag,width: 100, align:"center",sortable: false },
				{ name: "HGJLDW_DM", label: "海关计量单位代码", index: "HGJLDW_DM",hidden:!mxcxFlag,width: 100, align:"center",sortable: false },
				{ name: "CJHGHBSZ_DM", label: "成交海关货币数字代码", index: "CJHGHBSZ_DM",hidden:!mxcxFlag,width: 140, align:"center",sortable: false },
				{ name: "CKSL", label: "出口数量", index: "CKSL",hidden:!mxcxFlag,width: 70, align:"right",sortable: false },
				{ name: "CJZJ", label: "成交总价", index: "CJZJ",hidden:!mxcxFlag,width: 100, align:"right",sortable: false,formatter:function(cellvalue, options, rowObject){
          return avalon.filters.number(cellvalue,2);
      } },
        { name: "MYLAJ", label: "美元离岸价", index: "MYLAJ",hidden:!mxcxFlag,width: 100, align:"right",sortable: false,formatter:function(cellvalue, options, rowObject){
          return avalon.filters.number(cellvalue,2);
      } },
      { name: "ZMSJY_DM", label: "征免税建议代码", index: "ZMSJY_DM",hidden:!mxcxFlag,width: 100, align:"center",sortable: false },
      { name: "BSYCKTMSZCCDYY_DM", label: "不适用出口退（免）税政策传递原因代码", index: "BSYCKTMSZCCDYY_DM",hidden:!mxcxFlag,width: 240, align:"center",sortable: false },
      { name: "LRR_DM", label: "录入人代码", index: "LRR_DM",hidden:!mxcxFlag,width: 100, align:"center",sortable: false },
      { name: "LRRQQ", label: "录入日期", index: "LRRQQ",hidden:!mxcxFlag,width: 100, align:"center",sortable: false },
			];
			$('#'+id).jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
        // rownumWidth: 50,
				pager: '#'+id+'Pager',
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
					return $(".bsyckmts .form").height() -120;
				})(),
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
			});
		},
		search:function(pageNo,id){
			var self=this;
      var dataValid = [
        { start: "fqsjQ", end: "fqsjZ", msg: "录入日期" },
      ];
      for (var i = 0; i < dataValid.length; i++) {
        var item = dataValid[i];
        var validItem = tools.checkDate(
          this.searchData[item.start],
          this.searchData[item.end]
        );
        if (!validItem) {
          tools.info(item.msg + "截止时间必须大于起始时间");
          return false;
        }
      }
			this.searchData.pageSize = $(".ui-pg-selbox", $('.bsyckmts')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
      ajax("POST", "/cxfw/cqwsb/bsyck/tj/list", params).done(function(res){
        if(res.code=='0'){
          self.tableData = res.data.rows
          if(self.activeIndex=='0'){
            $('#bsyckmts-swjg-table')[0].addJSONData(res.data);
          }else if(self.activeIndex=='1'){
            $('#bsyckmts-qyfz-table')[0].addJSONData(res.data);
          }else{
            $('#bsyckmts-mxcx-table')[0].addJSONData(res.data);
          }
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
				$.fn.zTree.init($(".bsyckmts .bsyckmtsSwjgTree"), setting,data);
        var treeObj = $.fn.zTree.getZTreeObj('bsyckmtsSwjgTree');//ztree树的ID
        var node = treeObj.getNodeByParam("id", self.searchData.swjgdm);//根据ID找到该节点
        self.swjgmc = node.text
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.bsyckmts .select-sub').toggle();
			$('.bsyckmts .select-wrapper .icon').toggleClass("active");
			if ($('.bsyckmts .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.bsyckmts .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.bsyckmts .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.bsyckmts .select-sub').hide();
            $('.bsyckmts .select-wrapper .icon').removeClass('active');
            $('.bsyckmts .select-wrapper .icon').attr("title","展开查询条件");
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.bsyckmts').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.bsyckmts').off('click');
		},
		reset: function() {
			this.searchData = {
        swjgdm:avalonRoot.user.swjgDm,
        nsrsbh:'',
        nsrmc:'',
        qyhgdm:'',
        ckpzhm:'',
        fqsjQ:'',
        fqsjZ:'',
        type:Number(this.activeIndex)+1,
        sjly:'2',
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
    changeTab: function (num) {
      this.activeIndex = num;
      this.searchData.type = Number(num)+1
      if(num=='0'){
        this.createTableSwjg()
      }else if(num == '1'){
        this.createTableQyfz()
      }else{
        this.createTableMxcx()
      }
    },
    exform: function(){
      var self = this;
      // 校验录入日期范围是否小于等于一个月
      var startDate = this.searchData.fqsjQ;
      var endDate = this.searchData.fqsjZ;
      if(!startDate || !endDate){
        tools.info("请先设置录入日期范围");
        return;
      }
      var start = new Date(startDate);
      var end = new Date(endDate);
      var diffDays = (end - start) / (1000 * 60 * 60 * 24);
      if(diffDays > 31){
        tools.info("导出的录入日期范围不能超过一个月，请重新设置查询条件");
        return;
      }
      var params = tools.clone(self.searchData);
      delete params.type;
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/cqwsb/bsyck/tj/list/export");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    createTableSwjg: function(){
      this.createTable( 'bsyckmts-swjg-table');
    },
    createTableQyfz: function(){
      this.createTable( 'bsyckmts-qyfz-table');
    },
    createTableMxcx: function(){
      this.createTable( 'bsyckmts-mxcx-table');
    },
	}
});