var pxry = require("./pxry.html");
avalon.component("pxbmxx",{
    template:pxry,
    defaults: {
        act:1,
        params:{
            id:""
        },
        searchData:{
            id: "",
            signFlag:"",
            orderSql:"",
            size:config.pageSize,
        },
        onReady:function(){
            this.searchData.id = this.params.id;
            this.createTable();
        },
        createTable:function(){
            var self=this;
            var columns = [
                { name: "id", label: "主键", index: "id", width: 80, sortable: true ,align:"center",hidden:true},
                { name: "trainid", label: "trainid", index: "trainid", width: 80, sortable: true ,align:"center",hidden:true},
                { name: "companyName", label: "公司名称", align:"center", index: "companyName", sortable: true, width: 100},
                { name: "shxydm", label: "社会信用代码",  index: "shxydm", sortable: true },
                { name:"qylxCN", label:"企业类型", index:"qylxCN", width:95, sortable: true,},
                { name:"participant", label:"报名人", index:"participant", width:95, sortable: true,},
                { name:"participantTel", label:"报名人电话", index:"participantTel", width:95, sortable: true,},
                { name:"joinper", label:"参加人", index:"joinper", width:95, sortable: true,},
                { name:"joinperTel", label:"参加人电话", index:"joinperTel", width:95, sortable: true,},
                { name:"signFlag", label:"签到标志", index:"signFlag", width:95, sortable: true,hidden:true},
                { name: "signFlagCN", label: "是否签到",  index: "signFlagCN", width: 200, sortable: true, align:"center",}
            ];
            $("#pxry-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#pxry-tablePager',
                shrinkToFit: false,
                autowidth:true,
                altRows: true,
                width:"100%",
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                height:(function(){
                    return $(".pxry .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }
                },onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"pxry-table");
                    self.search(pageNo);
                }
            });
        },
        search:function(pageNo){
            var self=this;
            var size = $(".ui-pg-selbox", $('.pxry')).val() || 20;
            var params = {};
            params.id = this.searchData.id;
            params.signFlag = this.searchData.signFlag;
            params.pageSize = size;
            params.orderSql = "";
            params.pageNo = pageNo;
            $("#pxry-table").jqGrid('clearGridData')
            ajax("POST","/glfw/train/joinpeople",params).done(function(res){
                if(res.code=='0'){
                    $("#pxry-table")[0].addJSONData(res.data);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        exform:function(){
            var self=this;
            if($('#pxry-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/glfw/train/joinpeople/excel");
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
})