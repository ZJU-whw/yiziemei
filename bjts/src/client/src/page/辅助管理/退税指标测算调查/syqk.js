var syqk=require("./syqk.html");
avalon.component('syqk', {
    template:syqk,
    defaults: {
        params:{},
        act:1,
        swjgmc:"",
        tcode:"syqk",
        searchData:{
            swjgdm:"",
            tjnd:"",
            tjyf:"",
            orderSql:"",
            pageSize:200,
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
                pageSize:200,
            };
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "swjgdm", label: "退税机关代码", index: "swjgdm", width: 100, hidden:true},
                { name: "swjgmc", label: "退税机关", index: "swjgmc", width: 300, align:"center",sortable: false,formatter: function(cellvalue, options, rowObject){
                    //权限税务机关代码长度  3代表省局， 5代表市局
                    var len = tools.getPreSwjgdm(rowObject.swjgdm).length;
                    if(len == 3 || len == 5){
                        return "<span style='color:#090308;font-weight: bold;font-size:13px;' >"+cellvalue+"</span>";
                    }else{
                        return cellvalue;
                    }
                }},
                { name: "sbhs", label: "申报户数", index: "sbhs", width: 120, align:"right",sortable: false },
                { name: "syhs", label: "使用户数", index: "syhs", width: 120, align:"right",sortable: false },
                { name: "syhszb", label: "使用户数占比", index: "syhszb", width: 120, align:"right",sortable: false },
                { name: "tsehj", label: "企业填报退税额合计(万元)", index: "tsehj", width: 150, align:"right",sortable: false }
            ];
            self.createTable(tableArr)

        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#syqk-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#syqk-tablePager',
                shrinkToFit: false,
                width:"100%",
                autowidth:true,
                altRows: true,
                multiselect: false,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                // footerrow:true,
                rowNum: 200,
                rowList: [200],
                height:(function(){
                    return $(".syqk .form").height() -60;
                })(),
                onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"syqk-table");
                    self.search(pageNo);
                },
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.syqk')).val();
            // self.search(1)
        },
        resetTable:function() {
            $("#syqk-table").setGridWidth($('.syqk').width())
        },normalSearch(){
            this.searchData.orderSql="";
            $('.s-ico').hide();
            this.search(1)
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.syqk')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#syqk-table").jqGrid('clearGridData')
            ajax("POST","/glfw/extra/tszbcs/tj/syqk",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    $("#syqk-table").resetSelection();
                    $("#syqk-table")[0].addJSONData(res.data);

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
                    $.fn.zTree.init($(".syqk .treeDiv"), setting, res.data);
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
            $('.syqk').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.syqk').off('click');
        },
        exform:function(){
            if($('#syqk-table').jqGrid('getRowData').length<=0){
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
            form.attr("action", "/glfw/export/tszbcs/tj/syqk");
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