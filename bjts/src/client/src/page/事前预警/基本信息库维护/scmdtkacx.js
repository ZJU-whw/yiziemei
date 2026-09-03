var scmdtkacx=require("./scmdtkacx.html");
avalon.component('scmdtkacx', {
    template:scmdtkacx,
    defaults: {
        params:{},
        act:1,
        tcode:"scmdtkacx",
        searchData:{
            kaCode:"",
            kaName:"",
            orderSql:"cl_date desc",
            pageSize:config.pageSize,
        },
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{},
        setData:{
            zczt:"",
            ktpt:""
        },
        modelData:{
            kacode:"",
            kaname:"",
            sheng:"",
            yxbz:"",
        },
        swjgDm:"",
        swjgMc:"",
        onReady:function(){

            var self = this;
            this.getTableRow();
            $('.scmdtkacx .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
        },

        changeTab:function(num){
            this.act=num;
        },
        reset: function() {
            var self=this;
            self.searchData={
                kaCode:"",
                kaName:"",
                orderSql:"cl_date desc",
                pageSize:config.pageSize,
            };
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "kacode", label: "口岸代码", index: "kacode", width: 100, align:"center",sortable: true },
                { name: "kaname", label: "口岸名称", index: "kaname", sortable: true,align:"left", width: 400 },
                { name: "sheng", label: "所在省份", index: "sheng", sortable: true,align:"center", width: 100 },
                { name: "yxbz", label: "有效标志", index: "yxbz", sortable: true,align:"center", width: 80 },

            ]
            self.createTable(tableArr)

        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#scmdtkacx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#scmdtkacx-tablePager',
                shrinkToFit: true,
                width:"100%",
                // multiselect: true,
                // multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".scmdtkacx .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var b = getCellData("scmdtkacx-table", rowid, 'taxpayerCode')
                        avalonRoot.addTab({title:"不予退税明细",component:"scmdtkacxMx",sameCheck:false,params:{lcslid:self.tableData.rows[rowid-1].lcslid}});
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
                    var pageNo=tools.getPageNo(pgButton,"scmdtkacx-table");
                    self.search(pageNo);
                },
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.scmdtkacx')).val();
            self.search(1)
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
            $("#scmdtkacx-table").setGridWidth($('.scmdtkacx').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.scmdtkacx')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#scmdtkacx-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/yj/scqycjka",params).done(function(res){
                if(res.code=='0'){
                    $("#scmdtkacx-table").resetSelection();
                    $("#scmdtkacx-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
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
                kacode:"",
                kaname:"",
                sheng:"",
                yxbz:"",

            }
            $('.scmdtkacx .model-title').html("新增");
            self.showModel();
        },
        delData:function(){
            var self=this;
            var incode=[]
            var rowids=$("#scmdtkacx-table").jqGrid("getGridParam", "selarrrow");
            for (var i = 0; i < rowids.length; i++) {
                var b = getCellData("scmdtkacx-table", rowids[i], 'id');
                incode.push(b);
            }
            if(incode.length<=0){
                tools.info("请至少选择一条记录！");
                return false;
            }
            ajax("POST","/bjtssw/yj/scqycjka/del",{ids:incode}).done(function(res){
                if(res.code=='0'){
                    tools.info("操作成功")
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
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
                        self.searchData.tsjg = node.id;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.tsjg = node.id;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            var setting2 = {
                callback:{
                    onClick:function(e,id,node){
                        self.swjgDm = node.id;
                        self.swjgMc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.swjgDm = node.id;
                        self.swjgMc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };

            ajax("POST","/cxfw/export/readtree", {nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($(".scmdtkacx .treeDiv"), setting, res.data);
                    $.fn.zTree.init($(".scmdtkacx .treeDiv2"), setting2, res.data);
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
            $('.scmdtkacx').on('click',function(e){
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
            $('.scmdtkacx').off('click');
        },
        hideSwjg:function(){
            $(".treeDiv2").hide();
            $('.body').off('click');
        },
        showModel:function(){
            $('.model').show();
            $('.scmdtkacx .page-model').show();
        },
        hideModel:function(){
            $('.model').hide();
            $('.scmdtkacx .page-model').hide();
            this.modelData={
                yjObject:"",
                yjObjname:""
            }
        },
        saveModel:function(){
            var self=this;
            var params=tools.clone(self.modelData)
            params.bmdid=self.searchData.id;
            ajax("POST","/bjtssw/yj/scqycjka/update",params).done(function(res){
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
            if($('#scmdtkacx-table').jqGrid('getRowData').length<=0){
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
            form.attr("action", "/bjtssw/export/scqycjka");
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