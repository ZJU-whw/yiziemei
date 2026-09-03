var srths_sc=require("./srths_sc.html");
avalon.component('srths_sc', {
	template:srths_sc,
	defaults: {
		params:{},
		act:1,
		tcode: "srthscx",
		swjgmc: "",
		searchData:{
            thsrqq:"",
            thsrqz:"",
            yjflag:"0",
            qybs:"",
            swjg_dm:"",
            qylx_dm:"",
            flglcd:"",
            sbywbdm:"",
            qdbz:"",
            qd_date:"",
            qdno:"",
            no:"",
            spr:"",
            scr:"",
			queryType:"2", //查询类型为清单生成界面中的查询
			orderSql:"",
			pageSize:config.pageSize,
		},
        byjhyeDesc:"",//退税指标余额描述
		timer:null,
		tableData:{
            sumData:{}
		},
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjg_dm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
                this.searchData.thsrqq = tools.getToday();
                this.searchData.thsrqz = tools.getToday();
			} catch (e) {

			}
			this.createTable();
			self.initTree();
			$('.srths_sc .datepicker.date-day').datepicker({
				dateFormat: 'yy-mm-dd'
			});
			$('.srths_sc .datepicker.date-month').datepicker({
				dateFormat: 'yymm'
			});
		},
		changeTab:function(num){
			this.act=num;
		},
        createTable:function(){
            var self=this;
            var columns = [
                { name: "yjflagCN", label: "清单操作", index: "yjflag",width: 70, align:"center",sortable: true,
                    formatter: function(cellvalue, options, rowObject){
                        return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>"
                    }},
                { name: "yjflag", label: "清单操作",width: 20, align:"center",hidden:true },
                { name: "qyhgdm", label: "海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
                { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
                { name: "nsrmc", label: "企业名称", index: "nsrmc",width: 180, align:"left",sortable: true },
                { name: "no", label: "退还书号码", index: "no",width: 100, align:"center",sortable: true },
                { name: "op_date", label: "退还书日期", index: "op_date",width: 80, align:"center",sortable: true },
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
                { name: "spr", label: "审批人", index: "spr",width: 80, align:"left",sortable: true },
                { name: "yjmsg", label: "暂缓生成原因", index: "yjmsg",width: 150, align:"left",sortable: true }
            ];
            $("#srths_sc-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#srths_sc-tablePager',
                shrinkToFit: false,
                autowidth:true,
                altRows: true,
				width:"100%",
                // multiselect: true,
                // multiselectWidth:"30",
				footerrow:true,
                altclass: "altclasscss",
                lastsort: 1,
                rowList: [20,50,100,500],
                rowNum: config.pageSize,
                height:(function(){
                    return $(".srths_sc .form").height() -60-30;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                    	//获取清单操作类型（列表中的）
                        var yjflagOld = getCellData("srths_sc-table", rowid, 'yjflag');
                        var yjflagCNOld = getCellData("srths_sc-table", rowid, 'yjflagCN');
                        var no = getCellData("srths_sc-table", rowid, 'no');
                        var yjmsgOld = getCellData("srths_sc-table", rowid, 'yjmsg');
                        if(yjmsgOld){
                            yjmsgOld = yjmsgOld.trim();
                        }
                        $.dialog({
                            title: "设置清单操作",
                            content: '<div style="margin-bottom: 20px;">清单操作类型：<select type="text" id="yjflag" style=" width: 155px;">'+
                                '<option value="0">可生成</option>'+
                                '<option value="1">暂缓生成</option>'+
                                '</select></div>' +
                                '<div><span style="position: relative; top: -90px; left: 0;">暂缓原因：</span><textarea id="yjmsg" style="height: 100px;width: 180px;" placeholder="类型选择暂缓生成,可选填暂缓原因。"></textarea></div>',
                            lock: true,
                            button: [
                                {
                                    value: '确认',
                                    callback: function () {
                                        var yjflag = $('#yjflag').val();
                                        var yjmsg = $('#yjmsg').val();
                                        if(!yjflag){
                                            tools.info('清单操作类型不能为空，请选择。');
                                            return
                                        }
                                        if(yjflag == '0' && yjmsg){
                                            tools.info('清单操作为【' + yjflagCNOld + '】，不需要填写暂缓原因。');
                                            return
                                        }
                                        var params = {
                                            no: no,
                                            yjflag: yjflag,
                                            yjmsg:yjmsg
                                        }
                                        ajax("POST","/glfw/srthsqd/setYjflag",params).done(function(res){
                                            if(res.code=='0'){
                                                self.search(1);
                                            }else{
                                                tools.info(res.msg);
                                            }
                                        }).fail(function(err){
                                            tools.info(err);
                                        })
                                    }
                                },
                                {
                                    value: '取消'
                                }
                            ]
                        });
                        //设置父页面传递过来的清单操作类型和暂缓原因
                        $('#yjflag').val(yjflagOld);
                        $('#yjmsg').val(yjmsgOld);
                        return false;
                    }else{
                        return true;
                    }
                },onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                gridComplete: function(){
                    var sumData=self.tableData.sumData;
                    sumData["qyhgdm"]="合计";
                    $("#srths_sc-table").footerData('set', sumData);
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"srths_sc-table");
                    self.search(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            // self.search(1);
        },
		//copy bg
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.srths_sc')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
            $("#srths_sc-table").jqGrid('clearGridData')
			ajax("POST","/glfw/srthsqd/select",params).done(function(res){
				if(res.code=='0'){
					self.tableData=res.data;
					$("#srths_sc-table").resetSelection();
					$("#srths_sc-table")[0].addJSONData(res.data);
                    self.byjhyeDesc = res.data.byjhyeDesc
                    self.closeHyper();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},

        generate:function(){
            var self=this;
            if($('#srths_sc-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params=tools.clone(self.searchData);
            ajax("POST", "/glfw/srthsqd/generate4Check", params).done(function (res) {
                if (res.code == '0') {
                    tools.confirm('<p style="width:300px;word-break:normal; white-space:normal;font-family:微软雅黑;font-size:14px;">    待生成清单退还书' + res.data.tseCount +'笔</p>' +
                        '<p style="width:300px;word-break:normal; white-space:normal;font-family:微软雅黑;font-size:14px;">退税额合计：'+ res.data.tseSum + '元。</p>' +
                        '<p style="width:300px;word-break:normal; white-space:normal;font-family:微软雅黑;font-size:14px;">是否确认生成清单？</p>',
                        '确定',
                        function () {
                            ajax("POST", "/glfw/srthsqd/generate", params).done(function (res) {
                                if (res.code == '0') {
                                    tools.info("清单数据已生成，请前往菜单【收入退还书清单查询】中查看！");
                                    self.search(1);
                                } else {
                                    tools.info(res.msg);
                                }
                            }).fail(function (err) {
                                tools.info(err);
                            })
                        }
                    )
                } else {
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            })
        },

		showHyper:function(){
			$('.srths_sc .select-sub').toggle();
			$('.srths_sc .select-wrapper .icon').toggleClass("active");
			if ($('.srths_sc .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.srths_sc .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.srths_sc .select-wrapper .icon').attr("title","展开查询条件")
			}
		},
		closeHyper:function(){
            $('.srths_sc .select-sub').hide();
            $('.srths_sc .select-wrapper .icon').removeClass('active');
            $('.srths_sc .select-wrapper .icon').attr("title","展开查询条件")
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
			$('.srths_sc').on('click',function(e){
				var e=e||window.event;
				if($('.dropdown-menu').find($(e.target)).length<=0){
					self.hideMenu();
				}

			})
		},
		hideMenu:function(){
			$(".dropdown-menu").hide();
			$('.srths_sc').off('click');
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
				$.fn.zTree.init($(".srths_sc .treeDiv"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
		showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.srths_sc').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}

			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.srths_sc').off('click');
		},
		exform:function(){
			var self=this;
            if($('#srths_sc-table').jqGrid('getRowData').length<=0){
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
                qd_date:"",
                qdno:"",
                no:"",
                spr:"",
                scr:"",
                queryType:"2", //查询类型为清单生成界面中的查询
                orderSql:"",
                pageSize:config.pageSize,
			};
			this.swjgmc = avalonRoot.user.swjgMc;
		}
	}
});