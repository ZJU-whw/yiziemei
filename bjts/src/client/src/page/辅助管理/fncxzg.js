var fncxzg=require("./fncxzg.html");
avalon.component('fncxzg', {
	template:fncxzg,
	defaults: {
		params:{},
		act:1,
		swjgmc: "",
		searchData:{
			nsrsbh:"",
			swjg_dm:"",
            rkrqq:"",
			rkrqz:"",
			sjjeq:"",
            sjjez:"",
			dzjg:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		tableData:{
            sumData:{}
		},
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjg_dm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
			this.initTree();
			this.createTable();
            $('.fncxzg .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.fncxzg .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });
			$('.fncxzg .input-number').keyup(function(){
				var c=$(this);
				if(/[^\d]/.test(c.val())){//替换非数字字符
					var temp=c.val().replace(/[^\d]/g,'');
					$(this).val(temp);
				}
			})
		},
		changeTab:function(num){
			this.act=num;
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
        checkIsNum: function(e) {
            var data=e.target.value;
            var res = data;
            if(!/^[\.0-9]*$/.test(data)){
                tools.info("实缴金额输入错误");
                res="";
            }
            e.target.value=res;
            return ;
        },
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
                { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 80, align:"center",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
				{ name: "nsrmc", label: "纳税人名称", index: "nsrmc",width: 180, align:"left",sortable: true },
                { name: "dzsphm", label: "电子税票号码", index: "dzsphm",width: 140, align:"left",sortable: true },
                { name: "dzspmxxh", label: "序号", index: "dzspmxxh",width: 50, align:"left",sortable: true },
                { name: "zsxm_dm", label: "征收项目代码", index: "zsxm_dm",width: 80, align:"center",sortable: true },
                { name: "sksx_dm", label: "税款属性代码", index: "sksx_dm",width: 80, align:"left",sortable: true },
                { name: "yskm_dm", label: "预算科目代码", index: "yskm_dm",width: 80, align:"left",sortable: true },
                { name: "skssqq", label: "税款所属期起", index: "skssqq",width: 80, align:"left",sortable: true },
                { name: "skssqz", label: "税款所属期止", index: "skssqz",width: 80, align:"left",sortable: true },
				{ name: "kjrq", label: "开具日期", index: "kjrq",width: 80, align:"center",sortable: true },
				{ name: "jsyj", label: "计算依据", index: "jsyj",width: 85, align:"right",sortable: true },
				{ name: "jkqx", label: "缴款期限", index: "jkqx",width: 80, align:"center",sortable: true },
				{ name: "rkrq", label: "入库日期", index: "rkrq",width: 80, align:"center",sortable: true },
				{ name: "sjje", label: "实缴金额", index: "sjje",width: 100, align:"right",sortable: true },
				{ name: "yzpzxh_ckts", label: "凭证序号", index: "yzpzxh_ckts",width: 120, align:"left",sortable: true },
                { name: "dzjg", label: "对账结果", index: "dzjg",width: 80, align:"left",sortable: true },
				{ name: "swjgmc", label: "税务机关", index: "swjgmc",width: 180, align:"center",sortable: true },
                { name: "sjtb_date", label: "数据同步时间", index: "sjtb_date",width: 80, align:"center",sortable: true }
			];
			$("#fncxzg-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#fncxzg-tablePager',
                shrinkToFit: false,
                autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				footerrow:true,
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
                width:"100%",
				height:(function(){
					return $(".fncxzg .form").height() -60-30;
				})(),
				beforeSelectRow:function(rowid,e){
					 if(e.target.nodeName=="TD"){
						$(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
						return false;
					}else{
						return true;
					}

				},onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },gridComplete: function(){
                    var sumData=self.tableData.sumData;
                    sumData["nsrsbh"]="合计";
                    $("#fncxzg-table").footerData('set', sumData);
                },
				onPaging:function(pgButton){
					var pageNo=tools.getPageNo(pgButton,"fncxzg-table");
					self.search(pageNo);
				}
			});
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.fncxzg')).val() || 20;
			var params=tools.clone(self.searchData);
            //对账结果为正确是空格，所以特殊处理
            if (params.dzjg == "10") {
                params.dzjg = " ";
            }
			params.pageNo=pageNo;
            $("#fncxzg-table").jqGrid('clearGridData')
			ajax("POST","/glfw/fnxxcx4zg/select",params).done(function(res){
				if(res.code=='0'){
					self.tableData=res.data
					$("#fncxzg-table")[0].addJSONData(res.data);
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
			var setting1 = {
				callback:{
					onClick:function(e,id,node){
						self.searchData.swjg_dm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					},
					onDblClick:function(e,id,node){
						self.searchData.swjg_dm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			};
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				$.fn.zTree.init($(".fncxzg .treeDiv"), setting1,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showHyper:function(){
			$('.fncxzg .select-sub').toggle();
			$('.fncxzg .select-wrapper .icon').toggleClass("active");
			if ($('.fncxzg .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.fncxzg .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.fncxzg .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.fncxzg .select-sub').hide();
            $('.fncxzg .select-wrapper .icon').removeClass('active');
            $('.fncxzg .select-wrapper .icon').attr("title","展开查询条件");
        },
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.fncxzg').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}

			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.fncxzg').off('click');
		},
		exform:function(){
			var self=this;
            if($('#fncxzg-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/glfw/export/fnxxcx4zg");
			var input1 = $("<input>");
			input1.attr("type", "hidden");
			input1.attr("name", "data");
			input1.attr("value", JSON.stringify(params));
			$("body").append(form); //将表单放置在web中
			form.append(input1);
			form.submit();
			form.remove();
		},
		reset: function() {
			this.searchData = {
				nsrsbh:"",
				swjg_dm:avalonRoot.user.swjgDm,
				rkrqq:"",
                rkrqz:"",
				sjjeq:"",
				sjjez:"",
				dzjg:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc = avalonRoot.user.swjgMc;
		},
		sychonize: function() {
			ajax("POST","/glfw/fnxxcx4zg/sync",{}).done(function(res){
				if(res.code=='0'){
					tools.info("同步成功")
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		}
	}
});