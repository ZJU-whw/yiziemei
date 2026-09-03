var dcbcx=require("./dcbcx.html");
avalon.component('dcbcx', {
    template:dcbcx,
    defaults: {
        params:{},
        act:1,
        swjgmc:"",
        tcode:"dcbcx",
        searchData:{
            swjgdm:"",
            tjnd:"",
            tjyf:"",
            qybs:"",
            zdbz:"",
            tsjsfs_dm:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        tjndList:[],
        tableArr:[],
        tableOption:[],
        tableData:{
            sumData:{}
        },
        onReady:function(){
            var self = this;
            this.searchData.swjgdm=avalonRoot.user.swjgDm;
            this.swjgmc=avalonRoot.user.swjgMc;
            this.searchData.tjnd=new Date().getFullYear();
            this.searchData.tjyf=new Date().getMonth()+1;
            if(this.searchData.tjyf<10){
                this.searchData.tjyf="0"+this.searchData.tjyf
            }
            this.tjndList=[];
            for(var i=0 ;i<5;i++){
                this.tjndList.push((this.searchData.tjnd + 1)-i)
            }
            this.initTree();
            this.getTableRow();
        },

        changeTab:function(num){
            this.act=num;
        },
        reset: function() {
            var self=this;
            self.searchData={
                spdm:"",
                spmc:"",
                jkDate:"",
                orderSql:"",
                pageSize:config.pageSize,
            };
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "tjyf", label: "月份", index: "tjyf", sortable: true,align:"center", width: 60 },
                { name: "shxydm", label: "社会信用代码", index: "shxydm", width: 150, align:"center",sortable: true },
                { name: "nsrmc", label: "企业名称", index: "nsrmc", width: 150, align:"left",sortable: true },
                { name: "zdbz", label: "企业重点标志", index: "zdbz", width: 90, align:"center",sortable: true },
                { name: "tsjsfs_dm", label: "退税计算方式", index: "tsjsfs_dm", sortable: true,align:"center", width: 100 },
                { name: "jjlx", label: "经济类型", index: "jjlx", width: 110, align:"center",sortable: true },
                { name: "sndckgm", label: "去年出口规模", index: "sndckgm", sortable: true,align:"right", width: 90 },
                { name: "sndsbcke", label: "去年申报出口额", index: "sndsbcke", sortable: true,align:"right", width: 90 },
                { name: "zymyg", label: "主要出口国别", index: "zymyg", sortable: true,align:"left", width: 150 },
                { name: "zyspmc", label: "主要商品代码", index: "zyspmc", sortable: true,align:"left", width: 150 },
                { name: "ckxse", label: "出口额", index: "ckxse", sortable: true,align:"right",width: 90 },
                { name: "mde", label: "免抵额", index: "mde", sortable: true,align:"right",width: 90 },
                { name: "tse", label: "退税额", index: "tse", sortable: true,align:"right",width: 90 },
                { name: "ckhblv", label: "出口额环比(%)", index: "ckhblv", sortable: true,align:"center",width: 90 },
                { name: "tshblv", label: "退税额环比(%)", index: "tshblv", sortable: true,align:"center",width: 90 },
                { name: "jdtj_ksbcke", label: "可申报出口额", index: "jdtj_ksbcke", sortable: true,align:"right",width: 90 },
                { name: "jdtj_sbcke", label: "申报出口额", index: "jdtj_sbcke", sortable: true,align:"right",width: 90 },
                { name: "jdtj_mde", label: "申报免抵额", index: "jdtj_mde", sortable: true,align:"right",width: 90 },
                { name: "jdtj_tse", label: "申报退税额", index: "jdtj_tse", sortable: true,align:"right",width: 90 },
                { name: "wsb_jxfpse", label: "近六个月未申报进项发票税额", index: "wsb_jxfpse", sortable: true,align:"right",width: 160 },
                { name: "sykp_xxse", label: "上月销项税额", index: "sykp_xxse", sortable: true,align:"right",width: 90},
                { name: "sykp_jxse", label: "上月进项税额", index: "sykp_jxse", sortable: true,align:"right",width: 90 },
                { name: "sqldse", label: "上期留抵税额", index: "sqldse", sortable: true,align:"right",width: 90 },
                { name: "mdtytse", label: "免抵退应退税额", index: "mdtytse", sortable: true,align:"right",width: 90 },
                { name: "qmldse", label: "期末留底(测算)", index: "qmldse", sortable: true,align:"right",width: 90 },
                { name: "hbycyy", label: "退税额环比波动20%及其以上原因", index: "hbycyy", sortable: true,align:"center",width: 185,formatter:function(cellvalue){
                    return "<div style='white-space: nowrap'>"+cellvalue+"</div>"
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
            $("#dcbcx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#dcbcx-tablePager',
                shrinkToFit: false,
                width:"100%",
                autowidth:true,
                altRows: true,
                multiselect: false,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                footerrow:true,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".dcbcx .form").height() -60-60;
                })(),
                onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                gridComplete: function(){
                    var sumData=self.tableData.sumData;
                    sumData['shxydm']="合计";
                    $("#dcbcx-table").footerData('set', sumData);
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"dcbcx-table");
                    self.search(pageNo);
                },
            })
            $("#dcbcx-table").jqGrid('setGroupHeaders', {
                useColSpanStyle: true,
                groupHeaders:[
                    {startColumnName:'shxydm', numberOfColumns:8, titleText: '基础信息'},
                    {startColumnName:'ckxse', numberOfColumns:5, titleText: '退税需求情况-企业填报数据'},
                    {startColumnName:'jdtj_ksbcke', numberOfColumns:4, titleText: '退税需求情况-局端统计数据'},
                    {startColumnName:'wsb_jxfpse', numberOfColumns:1, titleText: '外贸企业-统计数据'},
                    {startColumnName:'sykp_xxse', numberOfColumns:5, titleText: '生产企业-统计数据'}
                ]
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.dcbcx')).val();
            // self.search(1)
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
            $("#dcbcx-table").setGridWidth($('.dcbcx').width())
        },normalSearch(){
            this.searchData.orderSql="";
            $('.s-ico').hide();
            this.search(1)
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.dcbcx')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#dcbcx-table").jqGrid('clearGridData')
            ajax("POST","/glfw/extra/tszbcs/cx/list",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    $("#dcbcx-table").resetSelection();
                    $("#dcbcx-table")[0].addJSONData(res.data);

                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        newData:function(){
            var self=this;
            self.modelData ={
                id:"",
                spdm:"",
                spmc:"",
                qsrq:"",
                jzrq:"",
                yyms:"",
                yxbz:"",
            }
            $('.dcbcx .model-title').html("新增");
            self.showModel();
        },
        delData:function(){
            var self=this;
            var incode=[]
            var rowids=$("#dcbcx-table").jqGrid("getGridParam", "selarrrow");
            for (var i = 0; i < rowids.length; i++) {
                var b = getCellData("dcbcx-table", rowids[i], 'id');
                incode.push(b);
            }
            if(incode.length<=0){
                tools.info("请至少选择一条记录！");
                return false;
            }
            tools.confirm("确定删除选中数据？",'确定',function(){
                ajax("POST","/bjtssw/yj/mgsp/del",{ids:incode}).done(function(res){
                    if(res.code=='0'){
                        tools.info("操作成功")
                        self.search(1);
                    }else{
                        tools.info(res.msg);
                    }
                }).fail(function(err){
                    tools.info(err);
                })
            })

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

            ajax("POST","/cxfw/export/readtree",{nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($(".dcbcx .treeDiv"), setting, res.data);
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
            $('.dcbcx').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },

        hideTree:function(){
            $(".treeDiv").hide();
            $('.dcbcx').off('click');
        },

        showModel:function(){
            $('.model').show();
            $('.dcbcx .page-model').show();
        },
        hideModel:function(){
            $('.model').hide();
            $('.dcbcx .page-model').hide();
            this.modelData={
                yjObject:"",
                yjObjname:""
            }
        },
        saveModel:function(){
            var self=this;
            var params=tools.clone(self.modelData)
            if(!/^[0-9]*$/g.test(params.spdm)){
                tools.info("请输入正确的商品代码")
                return;
            }
            params.bmdid=self.searchData.id;
            ajax("POST","/bjtssw/yj/mgsp/update",params).done(function(res){
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
            if($('#dcbcx-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var self=this;
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/glfw/export/tszbcs/cx/list/");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
    }
});