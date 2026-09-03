var srths=require("./srths.html");
avalon.component('srths', {
	template:srths,
	defaults: {
		params:{},
		act:1,
		tcode: "srthscx",
		swjgmc: "",
		searchData:{
            thsrqq:"",
            thsrqz:"",
            qybs:"",
            swjg_dm:"",
            qylx_dm:"",
            flglcd:"",
            sbywbdm:"",
            qdbz:"1",
            qd_dateq:"",
            qd_datez:"",
            qdno:"",
            no:"",
            spr:"",
            scr:"",
            queryType:"1", //查询类型为清单查询界面中的查询
			orderSql:"",
			pageSize:config.pageSize,
		},
		timer:null,
		tableData:{
            sumData:{}
		},
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjg_dm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
                this.searchData.qd_dateq = tools.getToday();
                this.searchData.qd_datez = tools.getToday();
			} catch (e) {

			}
			this.createTable();
			self.initTree();
			$('.srths .datepicker.date-day').datepicker({
				dateFormat: 'yy-mm-dd'
			});
			$('.srths .datepicker.date-month').datepicker({
				dateFormat: 'yymm'
			});
		},
		changeTab:function(num){
			this.act=num;
		},
        createTable:function(){
            var self=this;
            var columns = [
                { name: "qyhgdm", label: "海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
                { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
                { name: "nsrmc", label: "企业名称", index: "nsrmc",width: 180, align:"left",sortable: true },
                { name: "swjg_dm", label: "税务机关代码", index: "swjg_dm",width: 50, hidden:true},
                { name: "swjgmc", label: "税务机关", index: "swjgmc",width: 120, align:"left",sortable: true },
                { name: "no", label: "退还书号码", index: "no",width: 100, align:"center",sortable: true },
                { name: "op_date", label: "退还书日期", index: "op_date",width: 80, align:"center",sortable: true },
                { name: "qdno", label: "清单编号", index: "qdno",width: 145, align:"left",sortable: true },
                { name: "qdbz", label: "清单标志", index: "qdbz",width: 70, align:"center",sortable: true },
                { name: "qd_date", label: "清单生成日期", index: "qd_date",width: 80, align:"center",sortable: true },
                { name: "zzsamt", label: "增值税退税额", index: "zzsamt",width: 100, align:"right",sortable: true },
                { name: "xfsamt", label: "消费税退税额", index: "xfsamt",width: 100, align:"right",sortable: true },
                { name: "sbywbdm", label: "单证类型", index: "sbywbdm",width: 110, align:"center",sortable: true },
                { name: "sssq", label: "申报年月", index: "sssq",width: 80, align:"center",sortable: true },
                { name: "sbpc", label: "申报批次", index: "sbpc",width: 80, align:"center",sortable: true },
                { name: "qylx_dm", label: "企业类型", index: "qylx_dm",width: 100, align:"left",sortable: true },
                { name: "flglcd", label: "管理类别", index: "flglcd",width: 70, align:"center",sortable: true },
                { name: "tsjsfs_dm", label: "退税计算方法", index: "tsjsfs_dm",width: 80, align:"left",sortable: true },
                { name: "op_user", label: "生成人", index: "op_user",width: 80, align:"left",sortable: true },
                { name: "sh_time", label: "审批时间", index: "sh_time",width: 80, align:"center",sortable: true },
                { name: "spr", label: "审批人", index: "spr",width: 80, align:"left",sortable: true }
            ];
            $("#srths-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#srths-tablePager',
                shrinkToFit: false,
                autowidth:true,
                altRows: true,
				width:"100%",
                multiselect: true,
                multiselectWidth:"30",
				footerrow:true,
                altclass: "altclasscss",
                lastsort: 1,
                rowList: [20,50,100,500],
                rowNum: config.pageSize,
                height:(function(){
                    return $(".srths .form").height() -60-30;
                })(),
                beforeSelectRow:function(rowid,e){
                    if(e.target.nodeName=="TD"){
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
                gridComplete: function(){
                    var sumData=self.tableData.sumData;
                    sumData["qyhgdm"]="合计";
                    $("#srths-table").footerData('set', sumData);
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"srths-table");
                    self.search(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            // self.search(1);
        },
		//copy bg
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.srths')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
            $("#srths-table").jqGrid('clearGridData')
			ajax("POST","/glfw/srthsqd/select",params).done(function(res){
				if(res.code=='0'){
					self.tableData=res.data;
					$("#srths-table").resetSelection();
					$("#srths-table")[0].addJSONData(res.data);
                    self.closeHyper();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},

        withdraw:function(){
            var self = this;
            var ids = $("#srths-table").jqGrid('getGridParam', 'selarrrow');
            if (ids.length == 0) {
                tools.info("请先勾选需要清单撤回的数据");
                return;
            }
            //去重
            var uniqueIds = self.uniqueArray(ids.toString().split(","));
            //收入退还书号码
            var noArr=[];
            //清单编号
            var qdnoArr=[];

            for (var i = 0; i < uniqueIds.length; i++) {
                var no = getCellData("srths-table", uniqueIds[i], 'no');
                var swjgdm = getCellData("srths-table", uniqueIds[i], 'swjg_dm');
                //校验税务机关
                if(swjgdm != avalonRoot.user.swjgDm){
                    tools.info("只能撤回所属【"  + avalonRoot.user.swjgMc + "】下用户的退还书,请重新选择。");
                    return false;
                }
                //校验清单标志（未生成的不能撤回）
                var qdbz = getCellData("srths-table", uniqueIds[i], 'qdbz');
                if(qdbz != '已生成'){
                    tools.info("退还书号码【"  + no + "】的清单标志为未生成，不需要撤回，请重新选择。");
                    return false;
                }
                noArr.push(no);
                qdnoArr.push(getCellData("srths-table", uniqueIds[i], 'qdno'));
            }

            tools.confirm("是否执行（退还书号码" + noArr.join(',') +"）的清单撤回，相关的收入退还书状态变为[未生成]?","确定",function () {
                ajax("POST","/glfw/srthsqd/withdraw",{noArr: noArr,qdnoArr:qdnoArr}).done(function(res){
                    if(res.code=='0'){
                        tools.info("操作成功！");
                        self.search(1);
                    }else{
                        tools.info(res.msg);
                    }
                }).fail(function(err){
                    tools.info(err);
                })
            })
        },

		showHyper:function(){
			$('.srths .select-sub').toggle();
			$('.srths .select-wrapper .icon').toggleClass("active");
			if ($('.srths .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.srths .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.srths .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
		closeHyper:function(){
            $('.srths .select-sub').hide();
            $('.srths .select-wrapper .icon').removeClass('active');
            $('.srths .select-wrapper .icon').attr("title","展开查询条件")
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
		showMenu:function(e){
			var self=this;
			$(".dropdown-menu",e.target).show();
			$('.srths').on('click',function(e){
				var e=e||window.event;
				if($('.dropdown-menu').find($(e.target)).length<=0){
					self.hideMenu();
				}

			})
		},
		hideMenu:function(){
			$(".dropdown-menu").hide();
			$('.srths').off('click');
		},
		//copy
		initTree:function() {
			var self = this;
			var setting = {
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
				$.fn.zTree.init($(".srths .treeDiv"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.srths').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}

			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.srths').off('click');
		},
		exform:function(){
			var self=this;
            if($('#srths-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/glfw/export/srthsqd");
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
                thsrqq:"",
                thsrqz:"",
                qybs:"",
                swjg_dm:avalonRoot.user.swjgDm,
                qylx_dm:"",
                flglcd:"",
                sbywbdm:"",
                qdbz:"",
                qd_dateq:"",
                qd_datez:"",
                qdno:"",
                no:"",
                spr:"",
                scr:"",
                queryType:"1", //查询类型为清单查询界面中的查询
                orderSql:"",
                pageSize:config.pageSize,
			};
			this.swjgmc = avalonRoot.user.swjgMc;
		},
        qdbzChange () { //清单标志变更事件：选未生成，则清单日期起止都清空，选已生成或空，清单生成日期起和止默认设置为当天
            var qdbz = this.searchData.qdbz;
            if(qdbz == '1'){ //已生成
                this.searchData.qd_dateq = tools.getToday();
                this.searchData.qd_datez = tools.getToday();
			}else {//未生成
                this.searchData.qd_dateq = "";
                this.searchData.qd_datez = "";
			}
        },
        uniqueArray(arr){
            var newArr = [];
            for(var i = 0; i < arr.length; i++){
                for(var j = i+1; j < arr.length; j++){
                    if(arr[i] == arr[j]){
                        ++i;
                    }
                }
                newArr.push(arr[i]);
            }
            return newArr;
        }
	}
});