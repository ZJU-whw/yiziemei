var yjbmdwh=require("./yjbmdwh.html");
avalon.component('yjbmdwh', {
    template:yjbmdwh,
    defaults: {
        params:{},
        act:1,
        tcode:"yjbmdwh",
        searchData:{
            qybs:"",
            qymc:"",
            yjcode:"",
            objflag:"",
            tsjg:"",
            swjgMc:"",
            orderSql:"cl_date desc",
            pageSize:config.pageSize,
        },
        editRow:"",
        timer:null,
        tableArr:[],
        tableOption:[],
        yjList:[],
        tableData:{
        },
        modelData:{
            qybs:"",
            yjcode:"",
            yyms:"",
            objflag:""
        },
        swjgDm:"",
        swjgMc:"",
        tips:"",
        showFlag:false,
        onReady:function(){
            var self = this;
            try{
                this.searchData.tsjg=avalonRoot.user.swjgDm;
                this.searchData.swjgMc=avalonRoot.user.swjgMc;
            }catch(e){
                // console.log(e);
            }
            if(tools.isXianju(avalonRoot.user.swjgDm)){
                self.showFlag=true;
            }
            this.getTableRow();
            this.initTree();
            this.initYjList();


        },

        changeTab:function(num){
            this.act=num;
        },
        reset: function() {
            var self=this;
            self.searchData={
                qybs:"",
                qymc:"",
                yjcode:"",
                objflag:"",
                tsjg:avalonRoot.user.swjgDm,
                swjgMc:avalonRoot.user.swjgMc,
                orderSql:"cl_date desc",
                pageSize:config.pageSize,
            }
        },
        showHyper:function(){
            $('.yjbmdwh .select-sub').toggle();
            $('.yjbmdwh .select-wrapper .icon').toggleClass("active");
            if ($('.yjbmdwh .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.yjbmdwh .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.yjbmdwh .select-wrapper .icon').attr("title","展开查询条件")
            }
        },closeHyper:function(){
            $('.yjbmdwh .select-sub').hide();
            $('.yjbmdwh .select-wrapper .icon').removeClass('active');
            $('.yjbmdwh .select-wrapper .icon').attr("title","展开查询条件")
        },
        initYjList:function(){
            var self=this;
            ajax("POST","/bjtssw/yj/yjzb",{}).done(function(res){
                if(res.code=="0"){
                    self.yjList=res.data;
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        checkObjFlag:function(){
            var index=$('#yjbmdwhSel option:checked').attr('data-op');
            var item=this.yjList[index];
            if(item.yjobject&&item.yjlx==3){
                $('#yjbmdwhOpt').show();
                this.modelData.objflag=0;
            }else{
                $('#yjbmdwhOpt').hide();
                this.modelData.objflag=0;
            }
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "bmdid", label: "id", index: "bmdid",hidden:true, width: 100, align:"left",sortable: true },
                { name: "qyhgdm", label: "海关代码", index: "qyhgdm", width: 100, align:"left",sortable: true },
                { name: "shxyno", label: "社会信用代码", index: "shxyno", sortable: true,align:"left", width: 150 ,},
                { name: "nsrmc", label: "纳税人名称", index: "nsrmc", sortable: true,align:"left", width: 200 ,formatter:function(cellvalue, options, rowObject){
                    if(rowObject.objflagBz=='0'){
                        return cellvalue;
                    }
                    return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>"
                }},
                { name: "yjcode", label: "预警代码", index: "yjcode", sortable: true,align:"center", width: 80 ,},
                { name: "yjname", label: "预警名称", index: "yjname", sortable: true,align:"center", width: 150 ,},
                { name: "objflag", label: "白名单类型", index: "objflag", sortable: true,align:"center", width: 150 ,},
                { name: "objflagBz", label: "白名单类型", index: "objflagBz",  hidden:true,sortable: true,align:"center", width: 150 ,},
                { name: "swjgmc", label: "退税机关名称", index: "swjgmc", sortable: true,align:"center", width: 150 ,},
                { name: "yyms", label: "原因描述", index: "yyms", sortable: true,align:"left", width: 180 ,},
                { name: "yxbz", label: "启用标志", index: "yxbz", hidden:true,sortable: true,align:"center", width: 80 ,},
                { name: "", label:"操作", width:180, align:"center", hidden:!self.showFlag, resizable: false, search: false, sortable: true,editable :false,formatter: function(cellvalue, options, rowObject){
                    if(self.showFlag){
                        return "<div class='btn danger del' style='float: none;display: inline-block;' title='删除'>删除</div>"
                    }else{
                        return ""
                    }

                }},
                // { name: "", label:"操作", width:180, align:"center", resizable: false, search: false, sortable: true,editable :false,formatter: function(cellvalue, options, rowObject){
                //     if(rowObject.kpbz==""||!rowObject.kpbz){
                //         return "<div class='btn dzzd' style='float: none;display: inline-block;' title='编辑'>编辑</div>"+"<div class='btn dzzd' style='float: none;display: inline-block;' title='启用'>启用</div>"+"<div class='btn dzzd' style='float: none;display: inline-block;' title='禁用'>禁用</div>"
                //     }else{
                //         return "<div class='btn dzzd' style='float: none;display: inline-block;' title='编辑'>编辑</div>"+"<div class='btn dzzd' style='float: none;display: inline-block;' title='启用'>启用</div>"+"<div class='btn dzzd' style='float: none;display: inline-block;' title='禁用'>禁用</div>"
                //     }
                // }}
            ]
            self.createTable(tableArr)
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#yjbmdwh-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#yjbmdwh-tablePager',
                shrinkToFit: true,
                width:"100%",
                autowidth:true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".yjbmdwh .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var params={
                            id:self.tableData.rows[rowid-1].bmdid,
                            shxyno:self.tableData.rows[rowid-1].shxyno,
                            nsrmc:self.tableData.rows[rowid-1].nsrmc,
                            yjcode:self.tableData.rows[rowid-1].yjcode,
                            yjname:self.tableData.rows[rowid-1].yjname,
                        }
                        avalonRoot.addTab({title:"白名单放行对象",component:"yjbmdqy",sameCheck:true,params:params});
                        return false;
                    }else if($(e.target).hasClass('del')){
                        var b = self.tableData.rows[rowid-1].bmdid;
                        tools.confirm("是否删除该预警白名单？如有明细将一并删除。","确定",function(){
                            self.delYj(b);
                        })
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
                    var pageNo=tools.getPageNo(pgButton,"yjbmdwh-table");
                    self.search(pageNo);
                },
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.yjbmdwh')).val();
            self.search(1)
            // $("#yjbmdwh-table")[0].addJSONData(self.tableData);
        },
        delYj:function(id){
            var self=this;
            ajax("POST","/bjtssw/yj/bmd/del",{id:id}).done(function(res){
                if(res.code=='0'){
                    tools.info("操作成功!");
                    self.search(1);
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        getQyxx:function(e){
            var self=this;
            var params={
                qybs:e.target.value
            }
            ajax("POST","/bjtssw/yj/bmd/add/check",params).done(function(res){
                if(res.code=='0'){
                    self.tips=res.data;
                    $('#yjbmdAddTips').removeClass('text-red').addClass('text-blue')
                }else{
                    self.tips=res.msg;
                    $('#yjbmdAddTips').removeClass('text-blue').addClass('text-red')
                }
            }).fail(function(err){
                self.tips=err;
            })
        },
        setTableOption:function(){
            var self=this;
            setTimeout(function(){
                self.resetTable();
            },200);
            if(self.timer==null){
                self.timer=setTimeout(function(){
                    self.updataOption();
                    clearTimeout(self.timer);
                    self.timer=null;
                },2000)
            }else{
                clearTimeout(self.timer);
                self.timer=setTimeout(function(){
                    self.updataOption();
                    clearTimeout(self.timer);
                    self.timer=null;
                },2000)
            }
        },
        updataOption:function(){
            var self=this;
            var cs=[];
            for(var i=0;i<self.tableOption.length;i++){
                if(self.tableOption[i].show==true){
                    cs.push(self.tableOption[i].name)
                }
            }
            var params={
                tcode:this.tcode,
                cs:cs.join(',')
            }
            ajax("POST","/bjtssw/basis/columprofile/update",params).done(function(res){
                if(res.code!='0'){
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        resetTable:function() {
            $("#yjbmdwh-table").setGridWidth($('.yjbmdwh').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.yjbmdwh')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#yjbmdwh-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/yj/bmd",params).done(function(res){
                if(res.code=='0'){
                    $("#yjbmdwh-table").resetSelection();
                    $("#yjbmdwh-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        delRow:function(){
            var self=this;
            var incode=[]
            var rowids=$("#yjbmdwh-table").jqGrid("getGridParam", "selarrrow");
            for (var i = 0; i < rowids.length; i++) {
                var b = getCellData("yjbmdwh-table", rowids[i], 'incode');
                incode.push(b);
            }
            if(incode.length<=0){
                tools.info("请至少选择一条记录！");
                return false;
            }
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
        //copy
        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.tsjg = node.id;
                        self.searchData.swjgMc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.tsjg = node.id;
                        self.searchData.swjgMc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".yjbmdwh .treeDiv"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.yjbmdwh').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        showSwjg:function(e){
            var self=this;
            $(".treeDiv2",$(e.target)).show();
            $('body').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv2').find($(e.target)).length<=0){
                    self.hideSwjg();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.yjbmdwh').off('click');
        },
        hideSwjg:function(){
            $(".treeDiv2").hide();
            $('.body').off('click');
        },
        showModel:function(){
          $('.model').show();
          $('.yjbmdwh .page-model').show();
        },
        hideModel:function(){
            $('.model').hide();
            $('.yjbmdwh .page-model').hide();
            this.modelData={
                qybs:"",
                yjcode:"",
                yyms:"",
                objflag:""
            }
            this.tips="";
        },
        saveModel:function(){
            var self=this;
            var params=tools.clone(self.modelData);
            if(!/[0-9a-zA-Z]+/.test(params.qybs)){
                tools.info("请输入正确的企业海关代码或社会信用代码！")
                return ;
            }
            ajax("POST","/bjtssw/yj/bmd/add",params).done(function(res){
                if(res.code=='0'){
                    self.hideModel();
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        exform:function(){
            if($('#yjbmdwh-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var self=this;
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            // form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/bjtssw/yj/bmd/excel");
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