var ychdxxkcx=require("./ychdxxkcx.html");
avalon.component('ychdxxkcx', {
    template:ychdxxkcx,
    defaults: {
        params:{},
        act:1,
        tcode:"ychdxxkcx",
        searchData:{
            nsrsbh:"",
            nsrmc:"",
            fhrqq:"",
            fhrqz:"",
            orderSql:"cl_date desc",
            pageSize:config.pageSize,
        },
        modelData:{
            nsrsbh:"",
            nsrmc:"",
            fhbh:"",
            zgswjgmc:"",
            fhrq:"",
            fhnr:"",
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
            $('.ychdxxkcx .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
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
                fhrqq:"",
                fhrqz:"",
                orderSql:"cl_date desc",
                pageSize:config.pageSize,
            };
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "nsrsbh", label: "供货企业税号", index: "nsrsbh", width: 150, align:"center",sortable: true },
                { name: "nsrmc", label: "供货企业名称", index: "nsrmc", sortable: true,align:"left", width: 200 },
                { name: "fhbh", label: "复函编号", index: "fhbh", sortable: true,align:"center", width: 150 },
                { name: "fhrq", label: "复函日期", index: "fhrq", sortable: true,align:"center", width: 80 },
                { name: "fhnr", label: "复函内容", index: "fhnr", sortable: true,align:"left", width: 200 },
                { name: "tbsj", label: "同步时间", index: "tbsj", sortable: true,align:"center", width: 80 },
                { name: "zgswjgmc", label: "主管税务机关", index: "zgswjgmc", sortable: true,align:"left", width: 150 },
                { name: "yxbz", label: "有效标志", index: "yxbz", sortable: true,align:"center", width: 80 },
                // { name: "op", label:"有效标志", width:120, align:"center", resizable: false, search: false, sortable: true,formatter: function(cellvalue, options, rowObject){
                //     if(rowObject.yxbz=="Y"){
                //         return "<div class='btn disabled' style='float: none;display: inline-block;' title='有效'>有效</div>"+"<div class='btn yxbz' style='float: none;display: inline-block;' title='无效'>无效</div>"
                //     }else{
                //         return "<div class='btn yxbz' style='float: none;display: inline-block;' title='有效'>有效</div>"+"<div class='btn disabled' style='float: none;display: inline-block;' title='无效'>无效</div>"
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
            $("#ychdxxkcx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#ychdxxkcx-tablePager',
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
                    return $(".ychdxxkcx .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var b = getCellData("ychdxxkcx-table", rowid, 'taxpayerCode')
                        avalonRoot.addTab({title:"不予退税明细",component:"ychdxxkcxMx",sameCheck:false,params:{lcslid:self.tableData.rows[rowid-1].lcslid}});
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
                    var pageNo=tools.getPageNo(pgButton,"ychdxxkcx-table");
                    self.search(pageNo);
                },
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.ychdxxkcx')).val();
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
            $("#ychdxxkcx-table").setGridWidth($('.ychdxxkcx').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.ychdxxkcx')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#ychdxxkcx-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/yj/ychd",params).done(function(res){
                if(res.code=='0'){
                    $("#ychdxxkcx-table").resetSelection();
                    $("#ychdxxkcx-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.modelData.zgswjgmc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.modelData.zgswjgmc = node.text;
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
                    $.fn.zTree.init($(".ychdxxkcx .treeDiv"), setting, res.data);
                    $.fn.zTree.init($(".ychdxxkcx .treeDiv2"), setting2, res.data);
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
            $('.ychdxxkcx').on('click',function(e){
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
            $('.ychdxxkcx').off('click');
        },
        hideSwjg:function(){
            $(".treeDiv2").hide();
            $('.body').off('click');
        },
        newData:function(){
            var self=this;
            self.modelData ={
                nsrsbh:"",
                nsrmc:"",
                fhbh:"",
                zgswjgmc:"",
                fhrq:"",
                fhnr:"",
                yxbz:"",
            }
            $('.ychdxxkcx .model-title').html("新增");
            self.showModel();
        },
        delData:function(){
            var self=this;
            var incode=[]
            var rowids=$("#ychdxxkcx-table").jqGrid("getGridParam", "selarrrow");
            for (var i = 0; i < rowids.length; i++) {
                var b = getCellData("ychdxxkcx-table", rowids[i], 'id');
                incode.push(b);
            }
            if(incode.length<=0){
                tools.info("请至少选择一条记录！");
                return false;
            }
            ajax("POST","/bjtssw/yj/ychd/del",{ids:incode}).done(function(res){
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
        showModel:function(){
            $('.model').show();
            $('.ychdxxkcx .page-model').show();
        },
        hideModel:function(){
            $('.model').hide();
            $('.ychdxxkcx .page-model').hide();
            this.modelData={
                yjObject:"",
                yjObjname:""
            }
        },
        saveModel:function(){
            var self=this;
            var params=tools.clone(self.modelData)
            params.bmdid=self.searchData.id;
            ajax("POST","/bjtssw/yj/ychd/update",params).done(function(res){
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
            if($('#ychdxxkcx-table').jqGrid('getRowData').length<=0){
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
            form.attr("action", "/bjtssw/export/ychd");
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