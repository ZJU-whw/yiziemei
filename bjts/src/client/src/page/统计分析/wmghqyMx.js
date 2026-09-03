var wmghqyMx=require("./wmghqyMx.html");
var chart;
var data1=[],data2=[];
avalon.component('wmghqyMx', {
    template:wmghqyMx,
    defaults: {
        params:{
            dqmc:"",
            xzqh:"",
            xdtjMc:"",
            searchData:{
                swjgDm:"",
                swjgMc:"",
                tjlx:"",
                pmlx:"",
                cksjStart:"",
                cksjEnd:"",
                gbcode:[],
                dqcode:[],
                tslcode:[],
                spmlcode:[],
            }
        },
        act:1,
        spdl:[],
        slArray:["16","15","13","10","9","6","5","0"],
        xdtjMc: "",
        searchData:{
            swjgDm:"",
            swjgMc:"",
            tjlx:"1",
            pmlx:"1",
            cksjStart:"",
            cksjEnd:"",
            gbcode:[],
            dqcode:[],
            tslcode:[],
            spmlcode:[],
            xzqh:""
        },
        dqmc:"",
        tableCol:[],
        tableArr:[
            { name: "ghfns_no", label: "供货企业税号", index: "ghfns_no",hidden:false, sortable: false,align:"center", width: 150},
            { name: "nsrmc", label: "纳税人名称", index: "nsrmc",hidden:false, sortable: false,align:"center", width: 150},
            { name: "jhamt", label: "累计进货金额(元)", index: "jhamt",hidden:false, sortable: false,align:"center", width: 150,formatter:function(cellvalue, options, rowObject){
                    return avalon.filters.number(cellvalue,2);
                }},
            { name: "jhamt_sq", label: "上年同期(元)", index: "jhamt_sq",hidden:false, sortable: false,align:"center", width: 150,formatter:function(cellvalue, options, rowObject){
                    return avalon.filters.number(cellvalue,2);
                }},
            { name: "tse", label: "累计退税额(元)", index: "tse",hidden:false, sortable: false,align:"center", width: 150,formatter:function(cellvalue, options, rowObject){
                    return avalon.filters.number(cellvalue,2);
                }},
            { name: "tse_sq", label: "上年同期(元)", index: "tse_sq",hidden:false, sortable: false,align:"center", width: 150,formatter:function(cellvalue, options, rowObject){
                    return avalon.filters.number(cellvalue,2);
                }},
        ],
        onReady:function(){
            var self = this;
            self.searchData={
                swjgDm:self.params.searchData.swjgDm,
                swjgMc:self.params.searchData.swjgMc,
                tjlx:self.params.searchData.tjlx,
                pmlx:self.params.searchData.pmlx,
                cksjStart:self.params.searchData.cksjStart,
                cksjEnd:self.params.searchData.cksjEnd,
                gbcode:self.params.searchData.gbcode,
                dqcode:self.params.searchData.dqcode,
                tslcode:self.params.searchData.tslcode,
                spmlcode:self.params.searchData.spmlcode,
                xzqh:self.params.xzqh,
            }
            self.xdtjMc=self.params.xdtjMc;
            self.dqmc=self.params.dqmc;
            $('.wmghqyMx .select-sub').show();
            self.createTable( self.tableArr);
            this.getSpdl();
            this.initTree();
            this.initTree2();
            $('.wmghqyMx .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
        },

        changeTab:function(num){
            this.act=num;
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#wmghqyMx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#wmghqyMx-tablePager',
                shrinkToFit: true,
                width:"100%",
                multiselect: false,
                multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                footerrow:true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: 50,
                rowList: [20,50,100,500],
                height:(function(){ return $(".wmghqyMx .form").height() -90;})(),
                beforeSelectRow:function(rowid,e){
                    if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }
                },
                gridComplete: function(){
                    // var data = self.data.rows;
                    // var len = data.length;
                    var sumData={}
                    for(var i=0;i<self.tableArr.length;i++){
                        if(i==2 || i== 3|| i== 4|| i== 5 ){
                            var sum=0;
                            $("#wmghqyMx-table").getCol(self.tableArr[i].name,false).map(function(a){ sum+=(a.replace(/\,/g,'')-0)});
                            sumData[self.tableArr[i].name]=avalon.filters.number(sum,2);
                        }else{
                            sumData[self.tableArr[i].name]=""
                        }
                    }
                    sumData[self.tableArr[0].name] = "当前页合计";
                    $("#wmghqyMx-table").footerData('set', sumData);
                },
                onSortCol: function (index, iCol, sortorder) {
                    // self.searchData.orderSql = index + ' ' + sortorder;
                    // self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"wmghqyMx-table");
                    self.search(pageNo);
                }

            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.wmghqyMx')).val();
            $("#wmghqyMx-table").setGridWidth($('.wmghqyMx').width())
            self.search(1);
        },
        //获取商品大类
        getSpdl: function () {
            var self = this;
            ajax("POST","/bjtssw/tjfx/spml",{}).done(function(res){
                if(res.code=='0'){
                    self.spdl = res.data.spdl;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        getCheckedChildNodes: function(type) {
            var res = {gbcode:[],dqcode:[]};
            var xdtjMc = "";
            var nodes = $.fn.zTree.getZTreeObj("wmghqyMxTree2").getCheckedNodes(true);
            //按照国家 所有的统计方式gbcode都传国家代码进去
            if (type == "gbcode") {
                var arr = [];
                for (var i = 0; i < nodes.length; i++) {
                    if (nodes[i].isParent) {
                        continue;
                    }
                    arr.push(nodes[i].id);
                    xdtjMc += "," + nodes[i].name;
                }
                if (xdtjMc && xdtjMc.length > 20) {
                    this.xdtjMc = xdtjMc.slice(1,20)+"...";
                } else {
                    this.xdtjMc = xdtjMc ? xdtjMc.slice(1) : "";
                }
                res.gbcode = arr;
            }
            //其他按大洲按经济体
            else {
                var arr1 = [],arr2=[];
                var children;
                for (var i = 0; i < nodes.length; i++) {
                    arr1.push(nodes[i].id);
                    xdtjMc += "," + nodes[i].name;
                    children = nodes[i].states;
                    for (var j = 0; j < children.length; j++) {
                        arr2.push(children[j].id);
                    }
                }
                if (xdtjMc && xdtjMc.length > 20) {
                    this.xdtjMc = xdtjMc.slice(1,20)+"...";
                } else {
                    this.xdtjMc = xdtjMc ? xdtjMc.slice(1) : "";
                }
                res.gbcode = arr2;
                res.dqcode = arr1;
            }
            return res;
        },
        //构建国家树
        initTree2: function() {
            var self = this;
            this.hideTree();
            var treeObj = $.fn.zTree.getZTreeObj("wmghqyMxTree2");
            if (treeObj) {
                treeObj.destroy();
            }
            var setting = {
                check: {
                    enable: true,
                    chkboxType: {"Y":"ps","N":"ps"},
                    chkStyle: "checkbox"
                },
                view: {
                    showIcon: false,
                    selectedMulti: false,
                },
                data: {
                    key: {
                        children: "states"
                    }
                },
                callback: {
                    onCheck:function () {
                        var resObj = self.getCheckedChildNodes("gbcode");
                        self.searchData.gbcode = resObj.gbcode;
                        self.searchData.dqcode = resObj.dqcode;
                    }
                }
            };
            var data = tools.clone(avalonRoot.ztreeNodes.gjdata);
            $.fn.zTree.init($("#wmghqyMxTree2"), setting,data);
        },
        search:function(page){
            var self=this;
            var cksjStart = this.searchData.cksjStart;
            var cksjEnd = this.searchData.cksjEnd;
            if (!cksjStart) {
                tools.info("出口时间起不能为空");
                return
            }
            if (!cksjEnd){
                tools.info("出口时间止不能为空");
                return
            }
            if ((new Date(cksjStart).getTime() - new Date(cksjEnd).getTime()) > 0) {
                tools.info("出口时间止不能小于出口时间起");
                return
            }
            var tjlx = self.searchData.tjlx;
            // if (tjlx == "1" && this.searchData.gbcode.length == 0) {
            //     tools.info("出口贸易国不能为空");
            //     return;
            // }
            // if (tjlx == "2" && this.searchData.spmlcode.length == 0) {
            //     tools.info("出口商品大类不能为空");
            //     return;
            // }
            // if (tjlx == "3" && this.searchData.tslcode.length == 0) {
            //     tools.info("退税率不能为空");
            //     return;
            // }
            // if (this.searchData.gbcode.length == 0 && this.searchData.dqcode.length == 0) {
            //     tools.info("出口贸易国不能为空");
            //     return
            // }
            var params={
                bbdm:"D01010",
                cxtjDTO:tools.clone(self.searchData),
                pageSize:$(".ui-pg-selbox", $('.wmghqyMx')).val(),
                pageNo:page
            };
            $("#wmghqyMx-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/tjfx/wmghqymx",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    $("#wmghqyMx-table").resetSelection();
                    $("#wmghqyMx-table")[0].addJSONData(res.data);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        reset: function() {
            var self=this;
            self.searchData={
                tsjg:"",
                qylx:"",
                cksjStart:"",
                cksjEnd:"",
                gbcode:[]
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
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.swjgDm = node.id;
                        self.searchData.swjgMc = node.text;
                        // console.log(tree.getCheckedNodes(true));
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.swjgDm = node.id;
                        self.searchData.swjgMc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{
                    key:{
                        children:"item",
                        name:"text"
                    }
                }
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($("#wmghqyMxTree"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            })
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.wmghqyMx').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.wmghqyMx').off('click');
        },
        //点击企业类型输入框时触发
        showSelect: function (e) {
            var self=this;
            $(".select-container",$(e.target).parent()).show();
            $('.wmghqyMx .page').on('click',function(e){
                var e=e||window.event;
                if($('.select-container').find($(e.target)).length<=0){
                    $(".select-container").hide();
                    $('.wmghqyMx .page').off('click');
                }
            })
        },
        //点击限定条件对应值这个输入框时触发，根据不同的限定条件弹出不同的选择框
        showSelect2: function (e) {
            var self=this;
            //限定条件类型
            var tjlx = self.searchData.tjlx;
            if(!tjlx) return;
            if (tjlx == "1") {
                $(".select1",$(e.target).parent()).show();
                $('.wmghqyMx .page').on('click',function(e){
                    var e=e||window.event;
                    if($('.select1').find($(e.target)).length<=0){
                        $(".select1").hide();
                        $('.wmghqyMx .page').off('click');
                    }
                })
            } else if (tjlx == "2") {
                $(".select2",$(e.target).parent()).show();
                $('.wmghqyMx .page').on('click',function(e){
                    var e=e||window.event;
                    if($('.select2').find($(e.target)).length<=0){
                        $(".select2").hide();
                        $('.wmghqyMx .page').off('click');
                    }
                })
            } else {
                $(".select3",$(e.target).parent()).show();
                $('.wmghqyMx .page').on('click',function(e){
                    var e=e||window.event;
                    if($('.select3').find($(e.target)).length<=0){
                        $(".select3").hide();
                        $('.wmghqyMx .page').off('click');
                    }
                })
            }

        },
        //限定条件类型改变
        handleChange: function (e) {
            var target=e.target;
            var xdlx = $(target).val();
            this.xdtjMc = "";
            this.searchData.gbcode = [];
            this.searchData.tslcode = [];
            this.searchData.spmlcode = [];
            if (xdlx == "1") {
                this.initTree2();
            }
        },
        selectChange: function(e) {
            var map = {"1": "生产企业","2":"外贸企业","3":"外综服"};
            if (this.searchData.qylx && this.searchData.qylx.length == 0) {
                this.searchData.qylxMc = "";
            } else {
                var str = "";
                for (var i = 0; i < this.searchData.qylx.length; i++) {
                    str += ","+map[this.searchData.qylx[i]];
                }
                this.searchData.qylxMc = str.slice(1);
            }
        },
        selectChange2: function(type) {
            var xdtjMc = "";
            var self = this;
            if (type == "2") {
                $.each(this.spdl,function (index,item) {
                    if (self.searchData.spmlcode.indexOf(item.spml) > -1) {
                        xdtjMc += "," + item.mldm;
                    }
                })
                if (xdtjMc.length > 20) {
                    xdtjMc = xdtjMc.slice(1,20)
                } else {
                    xdtjMc = xdtjMc ? xdtjMc.slice(1) : "";
                }
            } else {
                $.each(this.searchData.tslcode,function (index,item) {
                    xdtjMc += "," + item + "%";
                });
                xdtjMc = xdtjMc ? xdtjMc.slice(1) : "";
            }
            this.xdtjMc = xdtjMc;
        },
        exform:function(){
            var self=this;
            if($("#wmghqyMx-table").jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var cksjStart = this.searchData.cksjStart;
            var cksjEnd = this.searchData.cksjEnd;
            if (!cksjStart) {
                tools.info("出口时间起不能为空");
                return
            }
            if (!cksjEnd){
                tools.info("出口时间止不能为空");
                return
            }
            if ((new Date(cksjStart).getTime() - new Date(cksjEnd).getTime()) > 0) {
                tools.info("出口时间止不能小于出口时间起");
                return
            }
            var tjlx = self.searchData.tjlx;
            // if (tjlx == "1" && this.searchData.gbcode.length == 0) {
            //     tools.info("出口贸易国不能为空");
            //     return;
            // }
            // if (tjlx == "2" && this.searchData.spmlcode.length == 0) {
            //     tools.info("出口商品大类不能为空");
            //     return;
            // }
            // if (tjlx == "3" && this.searchData.tslcode.length == 0) {
            //     tools.info("退税率不能为空");
            //     return;
            // }
            // if (this.searchData.gbcode.length == 0 && this.searchData.dqcode.length == 0) {
            //     tools.info("出口贸易国不能为空");
            //     return
            // }
            var params={
                bbdm:"D01010",
                cxtjDTO:tools.clone(self.searchData),
                pageSize:"20",
                pageNo:1
            };
            params.cxtjDTO.gjmc=self.xdtjMc;
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("method", "post");
            form.attr("action", "/bjtssw/export/tjfx/wmghqymx");
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