var xttblog = require("./xttblog.html");
avalon.component("xttblog",{
    template:xttblog,
    defaults: {
        act:1,
        searchData:{
            loglevel:"",
            logtimeq:"",
            logtimez:"",
            sync_type:"",
            sync_obj:"",
            loguser:"",
            lognr:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        onReady:function(){
            var self = this;
            this.createTable();
            $('.xttblog .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
        },
        createTable:function(){
            var self=this;
            var columns = [
                { name: "id", label: "主键id", index: "id", align:"center",hidden:true,sortable: true },
                { name: "logtime", label: "日志时间", index: "logtime",width: 120, align:"center",sortable: true },
                { name: "loguser", label: "操作人员", index: "loguser",width: 80, align:"left",sortable: true },
                { name: "lognr", label: "日志描述", index: "lognr",width: 180, align:"left",sortable: true },
                { name: "loglevel", label: "日志级别", index: "loglevel",width: 80, align:"center",sortable: true },
                { name: "sync_type", label: "同步类型", index: "sync_type",width: 140, align:"left",sortable: true },
                { name: "sync_obj", label: "同步对象", index: "sync_obj",width: 120, align:"left",sortable: true },
            ];
            $("#xttblog-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#xttblog-tablePager',
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
                    return $(".xttblog .form").height() -60;
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
                    var pageNo=tools.getPageNo(pgButton,"xttblog-table");
                    self.search(pageNo);
                }
            });
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.xttblog')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#xttblog-table").jqGrid('clearGridData')
            ajax("POST","/glfw/xttbrz/select",params).done(function(res){
                if(res.code=='0'){
                    $("#xttblog-table").resetSelection();
                    $("#xttblog-table")[0].addJSONData(res.data);
                    self.closeHyper();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        showHyper:function(){
            $('.xttblog .select-sub').toggle();
            $('.xttblog .select-wrapper .icon').toggleClass("active");
            if ($('.xttblog .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.xttblog .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.xttblog .select-wrapper .icon').attr("title","展开查询条件");
            }
        },
        closeHyper:function(){
            $('.xttblog .select-sub').hide();
            $('.xttblog .select-wrapper .icon').removeClass('active');
            $('.xttblog .select-wrapper .icon').attr("title","展开查询条件");
        },
        exform:function(){
            var self=this;
            if($('#xttblog-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/glfw/export/xttbrz");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
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
    }
})