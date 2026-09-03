var ycghqywh=require("./ycghqywh.html");
avalon.component('ycghqywh', {
    template:ycghqywh,
    defaults: {
        params:{},
        act:1,
        tcode:"ycghqywh",
        searchData:{
            nsrsbh:"",
            nsrmc:"",
            jkDate:"",
            orderSql:"cl_date desc",
            pageSize:config.pageSize,
        },
        modelData:{
            id:"",
            nsrsbh:"",
            nsrmc:"",
            zgswjg:"",
            zgswjgmc:"",
            qsrq:"",
            jzrq:"",
            yyms:"",
            yxbz:"",
        },
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{},
        swjgDm:"",
        swjgMc:"",
        onReady:function(){
            var self = this;
            this.getTableRow();
            this.initTree();
            $('.ycghqywh .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('#ycgh-fileupload').fileupload({
                dataType: 'json',
                done: function (e, data) {
                    if(data.result.code == "0"){
                        tools.info("导入成功!");
                        self.search(1);
                    }else{
                        tools.info(data.result.msg);
                    }
                }
            });
        },

        changeTab:function(num){
            this.act=num;
        },
        reset: function() {
            var self=this;
            self.searchData={
                nsrsbh:"",
                nsrmc:"",
                jkDate:"",
                orderSql:"cl_date desc",
                pageSize:config.pageSize,
            };
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "id", label: "id", index: "id", hidden:true,width: 100, align:"left",sortable: true },
                { name: "nsrsbh", label: "企业税号", index: "nsrsbh", width: 160, align:"center",sortable: true },
                { name: "nsrmc", label: "企业名称", index: "nsrmc", sortable: true,align:"left", width: 160 },
                { name: "zgswjgmc", label: "主管税务机关", index: "zgswjgmc", sortable: true,align:"left", width: 130 },
                { name: "qsrq", label: "起始日期", index: "qsrq", width: 80, align:"center",sortable: true },
                { name: "jzrq", label: "截止日期", index: "jzrq", sortable: true,align:"center", width: 80 },
                { name: "yyms", label: "监控原因", index: "yyms", sortable: true,align:"left", width: 150 },
                { name: "lrr", label: "录入人", index: "lrr", sortable: true,align:"center", width: 60 },
                { name: "lrrq", label: "录入日期", index: "lrrq", sortable: true,align:"center", width: 80 },
                { name: "lrswjgdm", label: "录入税务机关", index: "lrswjgdm", sortable: true,align:"center", width: 110 },
                { name: "yxbz", label: "有效标志", index: "yxbz",sortable: true,align:"center", width: 60 },
                { name: "op", label:"操作", width:80, align:"center", resizable: false, search: false, sortable: true,formatter: function(cellvalue, options, rowObject){
                        return "<div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div>";
                    }}
            ]
            self.createTable(tableArr)

        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#ycghqywh-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#ycghqywh-tablePager',
                shrinkToFit: true,
                width:"100%",
                autowidth:true,
                altRows: true,
                multiselect: true,
                multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".ycghqywh .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('edit')){
                        self.modelData ={
                            id:getCellData("ycghqywh-table", rowid, 'id'),
                            nsrsbh:getCellData("ycghqywh-table", rowid, 'nsrsbh').trim(),
                            nsrmc:getCellData("ycghqywh-table", rowid, 'nsrmc').trim(),
                            zgswjg:"",
                            zgswjgmc:getCellData("ycghqywh-table", rowid, 'zgswjgmc').trim(),
                            qsrq:getCellData("ycghqywh-table", rowid, 'qsrq').trim(),
                            jzrq:getCellData("ycghqywh-table", rowid, 'jzrq').trim(),
                            yyms:getCellData("ycghqywh-table", rowid, 'yyms').trim(),
                            yxbz:getCellData("ycghqywh-table", rowid, 'yxbz').trim(),
                        }
                        $('.ycghqywh .model-title').html("编辑");
                        self.showModel();
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
                    var pageNo=tools.getPageNo(pgButton,"ycghqywh-table");
                    self.search(pageNo);
                },
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.ycghqywh')).val();
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
            $("#ycghqywh-table").setGridWidth($('.ycghqywh').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.ycghqywh')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#ycghqywh-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/yj/ycghqy",params).done(function(res){
                if(res.code=='0'){
                    $("#ycghqywh-table").resetSelection();
                    $("#ycghqywh-table")[0].addJSONData(res.data);
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
                id:"",
                nsrsbh:"",
                nsrmc:"",
                zgswjg:"",
                zgswjgmc:"",
                qsrq:"",
                jzrq:"",
                yyms:"",
                yxbz:"",
            }
            $('.ycghqywh .model-title').html("新增");
            self.showModel();
        },
        delData:function(){
            var self=this;
            var incode=[]
            var rowids=$("#ycghqywh-table").jqGrid("getGridParam", "selarrrow");
            for (var i = 0; i < rowids.length; i++) {
                var b = getCellData("ycghqywh-table", rowids[i], 'id');
                incode.push(b);
            }
            if(incode.length<=0){
                tools.info("请至少选择一条记录！");
                return ;
            }
            tools.confirm("确定删除选中数据？",'确定',function(){
                ajax("POST","/bjtssw/yj/ycghqy/del",{ids:incode}).done(function(res){
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
                        self.modelData.zgswjg= node.id;
                        self.modelData.zgswjgmc= node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.modelData.zgswjg = node.id;
                        self.modelData.zgswjgmc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };

            ajax("POST","/cxfw/export/readtree", {nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($(".ycghqywh .treeDiv"), setting, res.data);
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
            $('.ycghqywh').on('click',function(e){
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
            $('.ycghqywh').off('click');
        },
        hideSwjg:function(){
            $(".treeDiv2").hide();
            $('.body').off('click');
        },
        showModel:function(){
            $('.model').show();
            $('.ycghqywh .page-model').show();
        },
        hideModel:function(){
            $('.model').hide();
            $('.ycghqywh .page-model').hide();
            this.modelData={
                yjObject:"",
                yjObjname:""
            }
        },
        saveModel:function(){
            var self=this;
            var params=tools.clone(self.modelData)
            if(params.yxbz===""){
                tools.info("请选择有效标志!")
                return ;
            }
            if(!/[0-9a-zA-Z]+/.test(params.nsrsbh)){
                tools.info("请输入正确的企业税号!")
                return ;
            }
            params.bmdid=self.searchData.id;
            ajax("POST","/bjtssw/yj/ycghqy/update",params).done(function(res){
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
            if($('#ycghqywh-table').jqGrid('getRowData').length<=0){
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
            form.attr("action", "/bjtssw/export/ycghqy");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
        downMB:function(){
            var self=this;
            var params = {
            }
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            // form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/bjtssw/export/ycghqy/mb");
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