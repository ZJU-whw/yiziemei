var yjbmdqy=require("./yjbmdqy.html");
avalon.component('yjbmdqy', {
    template:yjbmdqy,
    defaults: {
        params:{
            id:"",
            shxyno:"",
            nsrmc:"",
            yjcode:"",
            yjname:"",
        },
        act:1,
        tcode:"yjbmdqy",
        searchData:{
            id:"",
            orderSql:"cl_date desc",
            pageSize:config.pageSize,
        },
        formData:{
            id:"",
            shxyno:"",
            nsrmc:"",
            yjcode:"",
            yjname:"",
        },
        editRow:"",
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{
        },
        modelData:{
            yjObject:"",
            yjObjname:"",
        },
        swjgDm:"",
        swjgMc:"",
        showFlag:false,
        onReady:function(){

            this.searchData.id=this.params.id;
            this.formData.id=this.params.id;
            this.formData.shxyno=this.params.shxyno;
            this.formData.nsrmc=this.params.nsrmc;
            this.formData.yjcode=this.params.yjcode;
            this.formData.yjname=this.params.yjname;
            var self = this;

            this.initTree();
            if(tools.isXianju(avalonRoot.user.swjgDm)){
                self.showFlag=true;
            }
            this.getTableRow();
        },

        changeTab:function(num){
            this.act=num;
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "bsid", label: "id", index: "bsid",hidden:true, width: 100, align:"left",sortable: true },
                { name: "yjObject", label: "放行对象", index: "yjObject", width: 150, align:"left",sortable: true },
                { name: "yjObjname", label: "放行对象名称", index: "yjObjname", sortable: true,align:"center", width: 250},
                { name: "yxbz", label: "有效标志",hidden:true, index: "yxbz", sortable: true,align:"center", width: 80 ,},
                { name: "lrr", label: "录入人", index: "lrr", sortable: true,align:"center", width: 100 ,},
                { name: "lrrq", label: "录入日期", index: "lrrq", sortable: true,align:"center", width: 150 ,},
                { name: "", label:"操作", width:180, align:"center",hidden:!self.showFlag, resizable: false, search: false, sortable: true,editable :false,formatter: function(cellvalue, options, rowObject){
                        if(self.showFlag){
                            return "<div class='btn danger del' style='float: none;display: inline-block;' title='删除'>删除</div>"
                        }else{
                            return ""
                        }

                    }},
            ];
            self.createTable(tableArr)
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#yjbmdqy-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#yjbmdqy-tablePager',
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
                    return $(".yjbmdqy .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('del')){
                        var b = getCellData("yjbmdqy-table", rowid, 'bsid')
                        tools.confirm("确定删除该条记录？","确定",function(){
                            self.delRow(b)
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
                    var pageNo=tools.getPageNo(pgButton,"yjbmdqy-table");
                    self.search(pageNo);
                },
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.yjbmdqy')).val();
            self.search(1)
            // $("#yjbmdqy-table")[0].addJSONData(self.tableData);
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
            $("#yjbmdqy-table").setGridWidth($('.yjbmdqy').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.yjbmdqy')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#yjbmdqy-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/yj/bmdsub/view",params).done(function(res){
                if(res.code=='0'){
                    $("#yjbmdqy-table").resetSelection();
                    $("#yjbmdqy-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        delRow:function(incode){
            var self=this;
            var incode=incode;
            // var rowids=$("#yjbmdqy-table").jqGrid("getGridParam", "selarrrow");
            // for (var i = 0; i < rowids.length; i++) {
            //     var b = getCellData("yjbmdqy-table", rowids[i], 'bsid');
            //     incode.push(b);
            // }
            // if(incode.length<=0){
            //     tools.info("请至少选择一条记录！");
            //     return false;
            // }
            ajax("POST","/bjtssw/yj/bmdsub/del",{bsid:incode}).done(function(res){
                if(res.code=='0'){
                    tools.info("操作成功!");
                    self.search(1);
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
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
                    $.fn.zTree.init($(".yjbmdqy .treeDiv"), setting, res.data);
                    $.fn.zTree.init($(".yjbmdqy .treeDiv2"), setting2, res.data);
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
            $('.yjbmdqy').on('click',function(e){
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
            $('.yjbmdqy').off('click');
        },
        hideSwjg:function(){
            $(".treeDiv2").hide();
            $('.body').off('click');
        },
        showModel:function(){
          $('.model').show();
          $('.yjbmdqy .page-model').show();
        },
        hideModel:function(){
            $('.model').hide();
            $('.yjbmdqy .page-model').hide();
            this.modelData={
                yjObject:"",
                yjObjname:""
            }
        },
        saveModel:function(){
            var self=this;
            var params=tools.clone(self.modelData)
            params.bmdid=self.searchData.id;
            ajax("POST","/bjtssw/yj/bmdsub/add",params).done(function(res){
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
            if($('#yjbmdqy-table').jqGrid('getRowData').length<=0){
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
            form.attr("action", "/bjtssw/export/bmdsub/view");
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
            getYjobtName:function(){
                var self=this;
                if(self.formData.yjcode=="101"||self.formData.yjcode=="108"){return "商品代码，例如：64029929"}
                else if(self.formData.yjcode=="102"||self.formData.yjcode=="107"||self.formData.yjcode=="111"){return "供货方税号，例如：91320509323706366U"}
                else if(self.formData.yjcode=="109"||self.formData.yjcode=="110"){return "出口海关代码  例如：9421"}
                else{return ""}
            }
        }
    }
});