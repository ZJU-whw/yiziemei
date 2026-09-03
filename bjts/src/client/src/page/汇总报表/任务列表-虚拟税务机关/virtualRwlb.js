var virtualRwlb=require("./virtualRwlb.html");
avalon.component('virtualRwlb', {
    template:virtualRwlb,
    defaults: {
        params:{},
        act:1,
        timer:null,
        tcode:"qyxx",
        pageTitle:["自定义合并（地区）报表"],
        searchData:{
            swjgdm:"",
            swjgMc:"",
            ssny:"",
            orderSql:"sbtime desc",
            pageSize:config.pageSize,
        },
        virtualList:[],
        swjgmc:"",
        tableArr:[],
        tableOption:[],
        tableData:{},
        onReady:function(){
            var self = this;
            self.searchData.ssny=tools.getPrevMonth();
            self.swjgmc=avalonRoot.user.swjgMc;
            this.getTableRow();
            $('.virtualRwlb .control .date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.virtualRwlb .date-month').datepicker({
                dateFormat: 'yymm',
                changeMonth: true,
                changeYear: true
            });
        },
        onInit:function(e){
            virtualRwlb = e.vmodel;
        },
        changeTab:function(num){
            this.act=num;
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "bbdldm", label: "报表项目", index: "bbdldm", width: 50, align:"center",sortable: false },
                { name: "bbdlmc", label: "报表名称", index: "bbdlmc", sortable: true,align:"left", width: 150 ,formatter:function(cellvalue, options, rowObject){
                    return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>"
                 }},
                { name: "ny", label: "报表年月", index: "ny", sortable: true,align:"center", width: 70 ,},
                { name: "swjgdm", label: "税务机关代码", index: "swjgdm", hidden:true,sortable: true,align:"center"},
                { name: "swjgmc", label: "税务机关", index: "swjgmc", hidden:true,sortable: true,align:"center"},
                { name: "status", label: "状态", index: "status", sortable: true,align:"center", width: 50 ,},
                { name: "statusDm", label: "状态", index: "statusDm", hidden: true,},
                { name: "cjtime", label: "创建时间", index: "cjtime", sortable: true,align:"center", width: 100 ,},
                // { name: "zbtime", label: "制表时间", index: "zbtime", sortable: true,align:"center", width: 100 ,},
                // { name: "sbtime", label: "上报时间", index: "sbtime",  sortable: true,align:"center", width: 100 ,},
                // { name: "sjswjg", label: "上级机关", index: "sjswjg", sortable: true,align:"center", width: 80 ,},
                { name: "op", label:"操作", width:150, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(cellvalue, options, rowObject){
                    var str="<div class='btn zb' style='float: none;display: inline-block;' title='制表'>制表</div>"
                    str+="<div class='btn xj' style='float: none;display: inline-block;' title='查看下级'>查看下级</div>"
                    return str;
                }},
            ]
            self.createTable(tableArr)
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#virtualRwlb-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#virtualRwlb-tablePager',
                shrinkToFit: true,
                width:"100%",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".virtualRwlb .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var swjgdm=getCellData("virtualRwlb-table", rowid, 'swjgdm');
                        var params ={
                            bbdldm:getCellData("virtualRwlb-table", rowid, 'bbdldm'),
                            bbdlmc:getCellData("virtualRwlb-table", rowid, 'bbdlmc'),
                            ny:getCellData("virtualRwlb-table", rowid, 'ny'),
                            swjgdm:swjgdm,
                            swjgmc:getCellData("virtualRwlb-table", rowid, 'swjgmc'),
                            TZswitch:self.checkTZ(getCellData("virtualRwlb-table", rowid, 'statusDm'),tools.getPreSwjgdm(swjgdm)),
                        }
                        params.pageTitle=tools.clone(self.pageTitle);
                        params.pageTitle.push(params.bbdlmc)
                        avalonRoot.addTab({title:params.bbdlmc,tip:params.bbdlmc+'-'+params.swjgmc,component:"virtualRwlbMx",sameCheck:true,params:params});
                        return false;
                    }else if($(e.target).hasClass('xj')){

                        var swjgdm=getCellData("virtualRwlb-table", rowid, 'swjgdm')
                        var swjgmc=getCellData("virtualRwlb-table", rowid, 'swjgmc')
                        var bbdlmc=getCellData("virtualRwlb-table", rowid, 'bbdlmc')
                        var params ={
                            swjgdm:swjgdm,
                            swjgmc:swjgmc,
                            bbdldm:getCellData("virtualRwlb-table", rowid, 'bbdldm'),
                            bbdlmc:bbdlmc,
                            ny:getCellData("virtualRwlb-table", rowid, 'ny'),
                            TZswitch:self.checkTZ(getCellData("virtualRwlb-table", rowid, 'statusDm'),swjgdm),
                            pageTitle:[]
                        }


                        params.pageTitle=tools.clone(self.pageTitle);
                        params.pageTitle.push("下级上报情况")

                        avalonRoot.addTab({title:"下级上报情况",tip:"下级上报情况-"+bbdlmc+'-'+swjgmc,component:"virtualRwlbXj",sameCheck:true,params:params});

                        return false;

                    }else if($(e.target).hasClass('zb')){
                        var swjgdm = getCellData("virtualRwlb-table", rowid, 'swjgdm')
                        var b = getCellData("virtualRwlb-table", rowid, 'bbdldm')

                        var params ={
                            bbdldm:getCellData("virtualRwlb-table", rowid, 'bbdldm'),
                            bbdlmc:getCellData("virtualRwlb-table", rowid, 'bbdlmc'),
                            swjgdm:swjgdm,
                            swjgmc:getCellData("virtualRwlb-table", rowid, 'swjgmc'),
                            TZswitch:self.checkTZ(getCellData("virtualRwlb-table", rowid, 'statusDm'),tools.getPreSwjgdm(swjgdm)),
                            ny:getCellData("virtualRwlb-table", rowid, 'ny')
                        }

                        params.pageTitle=tools.clone(self.pageTitle);

                        params.pageTitle.push(params.bbdlmc)

                        self.dzzb(b,params);

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
                    var pageNo=tools.getPageNo(pgButton,"virtualRwlb-table");
                    self.search(pageNo);
                }

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.virtualRwlb')).val();
            self.getList();
        },
        getList:function(){
            var self=this;
            ajax("POST","/bjtssw/tjbb/mgt/virswjg/list",{}).done(function(res){
                if(res.code=='0'){
                    self.virtualList=res.data;
                    if(res.data.length>0){
                        self.searchData.swjgdm=self.virtualList[0].virSwjgdm;
                        self.search(1);
                    }
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        resetTable:function() {
            var self = this;
            for (var i = 0; i < self.tableOption.length; i++) {
                if (self.tableOption[i].show == true) {
                    $("#virtualRwlb-table").showCol(self.tableOption[i].name)
                } else {
                    $("#virtualRwlb-table").hideCol(self.tableOption[i].name)
                }
            }
            $("#virtualRwlb-table").setGridWidth($('.virtualRwlb').width())
        },

        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.virtualRwlb')).val();
            if(!this.searchData.pageSize){return ;}
            var params=tools.clone(self.searchData);
            if(!params.swjgdm){
                tools.info("请先选择虚拟单位")
                return ;
            }
            params.pageNo=pageNo;
            params.virName=self.getSwjgMc
            $("#virtualRwlb-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/tjbb/task",params).done(function(res){
                if(res.code=='0'){
                    $("#virtualRwlb-table").resetSelection();
                    $("#virtualRwlb-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },

        checkTZ:function(statusDm,swjgdm){
            if(statusDm=='20'||swjgdm.length<=5){
                return "0"
            }else{
                return "1"
            }
        },
        dzzb:function(b,params){
            var w=artDialog({
                id: 'Tips',
                title: false,
                cancel: false,
                fixed: true,
                lock: true,
                content:"制表中，请稍后..."
            })
            var self=this;
            ajax("POST","/bjtssw/tjbb/task/make",{bbdldm:b,ssny:params.ny,swjgdm:self.searchData.swjgdm,isVir:1}).done(function(res){
                w.close();
                if(res.code=='0'){
                    tools.info('制表成功')
                    self.search(1)
                    avalonRoot.addTab({title:"报表统计-"+params.bbdlmc+"-"+params.swjgmc,component:"virtualRwlbMx",sameCheck:true,params:params});
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                w.close();
                tools.info(err);

            })
        },
        showHyper:function(){
            $('.virtualRwlb .hyper').toggle();
            $('.virtualRwlb .hyperBtn').toggleClass('active');
        },
        closeHyper:function(){
            $('.virtualRwlb .hyper').hide();
            $('.virtualRwlb .hyperBtn').removeClass('active');
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
        filMonth:function(e){
            var date=e.target.value;
            var res=tools.MonCheup(date);
            if(res===false){
                tools.info("所属期输入错误");
                res=""
            }
            e.target.value=res;
            return ;
        },
        showMenu:function(e){
            var self=this;
            $(".dropdown-menu",e.target).show();
            $('.virtualRwlb').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.virtualRwlb').off('click');
        },


        createQb:function(){
            var self=this;
            var ssny=self.searchData.ssny
            if(ssny===""){
                tools.info("请输入所属年月！")
                return ;
            }
            if(!this.searchData.swjgdm){
                tools.info("请先选择虚拟单位")
                return ;
            }
            var params = {
                ssny: ssny,
                virSwjgdm:self.searchData.swjgdm,
                virName:self.getSwjgMc,
            };
            tools.confirm("是否创建【"+params.virName+"】【"+params.ssny+"】月报表","创建",function(){
                ajax("POST","/bjtssw/tjbb/vir/cr",params).done(function(res){
                    if(res.code=='0'){
                        self.searchData.ssny = params.ssny;
                        self.search(1);
                    }else{
                        tools.info(res.msg);
                    }
                }).fail(function(err){
                    tools.info(err);
                })
            })

        },
        exform:function(){
            var self=this;
            if($('#virtualRwlb-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            // form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/bjtssw/export/qyxx");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
        $computed:{
            getSwjgMc:function(){
                for(var i=0;i<this.virtualList.length;i++){
                    if(this.virtualList[i].virSwjgdm==this.searchData.swjgdm){
                        return this.virtualList[i].virName
                    }
                }
                return ""
            },
        }
    }
});