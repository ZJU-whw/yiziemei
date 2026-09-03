var rwlb=require("./rwlb.html");
avalon.component('rwlb', {
    template:rwlb,
    defaults: {
        params:{},
        act:1,
        timer:null,
        tcode:"qyxx",
        pageTitle:["报表生成"],
        searchData:{
            ssny:"",
            orderSql:"sbtime desc",
            pageSize:config.pageSize,
        },
        swjgmc:"",
        tableArr:[],
        tableOption:[],
        tableData:{},
        onReady:function(){
            var self = this;
            self.searchData.ssny=tools.getPrevMonth();
            self.swjgmc=avalonRoot.user.swjgMc;
            this.getTableRow();
            // self.initTree();
            $('.rwlb .control .date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.rwlb .date-month').datepicker({
                dateFormat: 'yymm',
                changeMonth: true,
                changeYear: true
            });
        },
        onInit:function(e){
            rwlb = e.vmodel;
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
                { name: "zbtime", label: "制表时间", index: "zbtime", sortable: true,align:"center", width: 100 ,},
                { name: "sbtime", label: "上报时间", index: "sbtime",  sortable: true,align:"center", width: 100 ,},
                { name: "sjswjg", label: "上级机关", index: "sjswjg", sortable: true,align:"center", width: 80 ,},
                { name: "op", label:"操作", width:150, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(cellvalue, options, rowObject){
                    if(rowObject.statusDm=="00"){
                        var str="<div class='btn zb' style='float: none;display: inline-block;' title='制表'>制表</div>"
                    }else if(rowObject.statusDm=="10"){
                        str="<div class='btn sb' style='float: none;display: inline-block;' title='上报'>上报</div>"
                    }else if(rowObject.statusDm=="20"){
                        str="<div class='btn disabled' style='float: none;display: inline-block;' title='已上报'>上报</div>"
                    }else{
                        str=""
                    }
                    if(tools.getPreSwjgdm(rowObject.swjgdm).length<=5){
                        str+="<div class='btn xj' style='float: none;display: inline-block;' title='查看下级'>查看下级</div>"
                    }
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
            $("#rwlb-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#rwlb-tablePager',
                shrinkToFit: true,
                width:"100%",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".rwlb .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var swjgdm=getCellData("rwlb-table", rowid, 'swjgdm');
                        var params ={
                            bbdldm:getCellData("rwlb-table", rowid, 'bbdldm'),
                            bbdlmc:getCellData("rwlb-table", rowid, 'bbdlmc'),
                            ny:getCellData("rwlb-table", rowid, 'ny'),
                            swjgdm:swjgdm,
                            swjgmc:getCellData("rwlb-table", rowid, 'swjgmc'),
                            TZswitch:self.checkTZ(getCellData("rwlb-table", rowid, 'statusDm'),tools.getPreSwjgdm(swjgdm)),
                        }
                        params.pageTitle=tools.clone(self.pageTitle);
                        params.pageTitle.push(params.bbdlmc)
                        avalonRoot.addTab({title:params.bbdlmc,tip:params.bbdlmc+'-'+params.swjgmc,component:"rwlbMx",sameCheck:true,params:params});
                        return false;
                    }else if($(e.target).hasClass('xj')){

                        var swjgdm=tools.getPreSwjgdm(getCellData("rwlb-table", rowid, 'swjgdm'))
                        var swjgmc=getCellData("rwlb-table", rowid, 'swjgmc')
                        var bbdlmc=getCellData("rwlb-table", rowid, 'bbdlmc')
                        var params ={
                            bbdldm:getCellData("rwlb-table", rowid, 'bbdldm'),
                            bbdlmc:bbdlmc,
                            ny:getCellData("rwlb-table", rowid, 'ny'),
                            TZswitch:self.checkTZ(getCellData("rwlb-table", rowid, 'statusDm'),swjgdm),
                            pageTitle:[]
                        }

                        // alert(JSON.stringify(self.pageTitle));
                        params.pageTitle=tools.clone(self.pageTitle);
                        params.pageTitle.push("下级上报情况")
                        // alert('step3')
                        avalonRoot.addTab({title:"下级上报情况",tip:"下级上报情况-"+bbdlmc+'-'+swjgmc,component:"rwlbXj",sameCheck:true,params:params});
                        // alert('step4')
                        return false;
                    }else if($(e.target).hasClass('zb')){
                        var swjgdm = getCellData("rwlb-table", rowid, 'swjgdm')
                        var b = getCellData("rwlb-table", rowid, 'bbdldm')

                        var params ={
                            bbdldm:getCellData("rwlb-table", rowid, 'bbdldm'),
                            bbdlmc:getCellData("rwlb-table", rowid, 'bbdlmc'),
                            swjgdm:swjgdm,
                            swjgmc:getCellData("rwlb-table", rowid, 'swjgmc'),
                            TZswitch:self.checkTZ(getCellData("rwlb-table", rowid, 'statusDm'),tools.getPreSwjgdm(swjgdm)),
                            ny:getCellData("rwlb-table", rowid, 'ny')
                        }

                        params.pageTitle=tools.clone(self.pageTitle);

                        params.pageTitle.push(params.bbdlmc)

                        self.dzzb(b,params);

                        return false;
                    }else if($(e.target).hasClass('sb')){
                        var b = getCellData("rwlb-table", rowid, 'bbdldm');
                        var ssny = getCellData("rwlb-table", rowid, 'ny');
                        self.dzsb(b,ssny);
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
                    var pageNo=tools.getPageNo(pgButton,"rwlb-table");
                    self.search(pageNo);
                }

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.rwlb')).val();
            self.search(1)
        },
        resetTable:function() {
            var self = this;
            for (var i = 0; i < self.tableOption.length; i++) {
                if (self.tableOption[i].show == true) {
                    $("#rwlb-table").showCol(self.tableOption[i].name)
                } else {
                    $("#rwlb-table").hideCol(self.tableOption[i].name)
                }
            }
            $("#rwlb-table").setGridWidth($('.rwlb').width())
        },

        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.rwlb')).val();
            if(!this.searchData.pageSize){return ;}
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#rwlb-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/tjbb/task",params).done(function(res){
                if(res.code=='0'){
                    $("#rwlb-table").resetSelection();
                    $("#rwlb-table")[0].addJSONData(res.data);
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
            ajax("POST","/bjtssw/tjbb/task/make",{bbdldm:b,ssny:params.ny}).done(function(res){
                w.close();
                if(res.code=='0'){
                    tools.info('制表成功')
                    self.search(1)
                    avalonRoot.addTab({title:"报表统计-"+params.bbdlmc+"-"+params.swjgmc,component:"rwlbMx",sameCheck:true,params:params});
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                w.close();
                tools.info(err);

            })
        },
        dzsb:function(b,ssny){
            var self=this;
            ajax("POST","/bjtssw/tjbb/task/sb",{bbdldm:b,ssny:ssny}).done(function(res){
                if(res.code=='0'){
                    self.afterSb(b,ssny)
                }else if(res.code=='7001'){
                    tools.infoList(res.data,"继续上报",function(){
                        self.afterSb(b,ssny)
                    });
                }else if(res.code=='7002'){
                    tools.infoList(res.data);
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);

            })
        },
        afterSb:function(b,ssny){
            var self=this;
            var params={
                bbdldm:b,
                qrflag:1,
                ssny:ssny
            }
            ajax("POST","/bjtssw/tjbb/task/sb",params).done(function(res){
                if(res.code=='0'){
                    tools.info('操作成功!')
                    self.search(1)
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);

            })
        },
        showHyper:function(){
            $('.rwlb .hyper').toggle();
            $('.rwlb .hyperBtn').toggleClass('active');
        },
        closeHyper:function(){
            $('.rwlb .hyper').hide();
            $('.rwlb .hyperBtn').removeClass('active');
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
            $('.rwlb').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.rwlb').off('click');
        },

        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.swcode = node.id;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.swcode = node.id;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            var setting2 = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.zgswskfj_dm = node.id;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.zgswskfj_dm = node.id;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };

            ajax("POST","/cxfw/export/readtree", {nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($(".rwlb #qyjcssTsjg"), setting, res.data);
                    $.fn.zTree.init($(".rwlb #rwlbZgsws"), setting2, res.data);
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.rwlb').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.rwlb').off('click');
        },
        saveModel:function(){
            var self=this;
            var ssny=$('#rwlbModelIpt').val();
            if(ssny===""){
                tools.info("请输入所属年月！")
                return ;
            }
            var params = {ssny: ssny};
            ajax("POST","/bjtssw/tjfx/initE01001",params).done(function(res){
                if(res.code=='0'){
                    self.hideModel();
                    self.searchData.ssny = params.ssny;
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        showModel:function(){
            $('#rwlbModelIpt').val("")
            $('.model').show();
            $('.rwlbModel').show();
        },
        hideModel:function(){
            $('.model').hide();
            $('.rwlbModel').hide();
        },
        exform:function(){
            var self=this;
            if($('#rwlb-table').jqGrid('getRowData').length<=0){
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
        }
    }
});