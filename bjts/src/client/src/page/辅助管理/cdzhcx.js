var cdzhcx=require("./cdzhcx.html");
avalon.component('cdzhcx', {
    template:cdzhcx,
    defaults: {
        params:{},
        act:1,
        swjgmc1: "",
        selRows: [],
        searchData:{
            qyhgdm:"",
            nsrsbh:"",
            swjg_dm:"",
            qylx:"",
            gllb:"",
            lc_id:"",
            sbrqq:"",
            sbrqz:"",
            cdrqq:"",
            cdrqz:"",
            sc_user:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        onReady:function(){
            var self = this;
            try {
                this.searchData.swjg_dm=avalonRoot.user.swjgDm;
                this.swjgmc1=avalonRoot.user.swjgMc;
            } catch (e) {

            }
            this.initTree();
            this.createTable();
            $('.cdzhcx .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.cdzhcx .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });
        },
        changeTab:function(num){
            this.act=num;
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
        //copy bg
        createTable:function(){
            var self=this;
            var columns = [
                { name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
                { name: "qyhgdm", label: "海关代码", index: "qyhgdm",width:90, align:"center",sortable: true },
                { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true,formatter:function(cellvalue){
                        return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>";
                    }},
                { name: "nsrmc", label: "企业名称", index: "nsrmc",width: 200, align:"left",sortable: true },
                { name: "lc_id", label: "业务类型", index: "lc_id",width: 90, align:"left",sortable: true },
                { name: "sbym", label: "申报年月", index: "sbym",width: 80, align:"center",sortable: true },
                { name: "sbpc", label: "申报批次", index: "sbpc",width: 90, align:"center",sortable: true },
                { name: "ckamt_usd", label: "申报出口额(美元)", index: "ckamt_usd",width: 100, align:"right",sortable: true },
                { name: "sl_date", label: "申报时间", index: "sl_date",width: 120, align:"center",sortable: true },
                { name: "sh_user", label: "审核人员", index: "sh_user",width: 80, align:"left",sortable: true },
                { name: "yjbz", label: "预警标志", index: "yjbz",width: 80, align:"left",sortable: true },
                { name: "sq_date", label: "申请时间", index: "sq_date",width:120, align:"left",sortable: true },
                { name: "sq_reason", label: "申请原因", index: "sq_reason",width: 180, align:"left",sortable: true },
                { name: "cdbz", label: "撤单标志", index: "cdbz",width: 80, align:"left",sortable: true },
                { name: "sc_user", label: "撤单人", index: "sc_user",width: 80, align:"left",sortable: true },
                { name: "sc_date", label: "撤单时间", index: "sc_date",width: 120, align:"left",sortable: true },
                { name: "sc_reason", label: "撤单原因", index: "sc_reason",width: 180, align:"left",sortable: true },
                { name: "tse_zh", label: "暂缓退税金额", index: "tse_zh",width: 100, align:"right",sortable: true },
                { name: "tse_by", label: "不予退税金额", index: "tse_by",width: 100, align:"right",sortable: true },
                { name: "qylx", label: "企业类型", index: "qylx",width: 80, align:"left",sortable: true },
                { name: "gllb", label: "管理类别", index: "gllb",width: 80, align:"left",sortable: true },
                { name: "swjgmc", label: "税务机关", index: "swjgmc",width: 120, align:"left",sortable: true },
            ];
            $("#cdzhcx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#cdzhcx-tablePager',
                shrinkToFit: false,
                autowidth:true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                width:"100%",
                height:(function(){
                    return $(".cdzhcx .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var lcslid = $("#cdzhcx-table").jqGrid("getRowData",rowid).lcslid;
                        avalonRoot.addTab({title:"撤单明细",component:"cdMx",params:{lcslid:lcslid}});
                        return false;
                    }else if(e.target.nodeName=="TD"){
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
                    var pageNo=tools.getPageNo(pgButton,"cdzhcx-table");
                    self.search(pageNo);
                }
            });
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.cdzhcx')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo;
            $("#cdzhcx-table").jqGrid('clearGridData')
            ajax("POST","/glfw/cdsqzhcx/select/first",params).done(function(res){
                if(res.code=='0'){
                    $("#cdzhcx-table")[0].addJSONData(res.data);
                    self.form=res.data;
                    self.closeHyper();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        initTree:function() {
            var self = this;
            var setting1 = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.swjg_dm = node.id;
                        self.swjgmc1 = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.swjg_dm = node.id;
                        self.swjgmc1 = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".cdzhcx .swjg1"), setting1,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showHyper:function(){
            $('.cdzhcx .select-sub').toggle();
            $('.cdzhcx .select-wrapper .icon').toggleClass("active");
            if ($('.cdzhcx .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.cdzhcx .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.cdzhcx .select-wrapper .icon').attr("title","展开查询条件")
            }
        },closeHyper:function(){
            $('.cdzhcx .select-sub').hide();
            $('.cdzhcx .select-wrapper .icon').removeClass('active');
            $('.cdzhcx .select-wrapper .icon').attr("title","展开查询条件");
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.cdzhcx').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.cdzhcx').off('click');
        },
        exform:function(){
            var self=this;
            if($('#cdzhcx-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/glfw/export/cdzhcxqd");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
        reset: function() {
           this.searchData = {
               qyhgdm:"",
               nsrsbh:"",
               swjg_dm:avalonRoot.user.swjgDm,
               qylx:"",
               gllb:"",
               lc_id:"",
               sbrqq:"",
               sbrqz:"",
               cdrqq:"",
               cdrqz:"",
               sc_user:"",
               orderSql:"",
               pageSize:config.pageSize,
           };
           this.swjgmc1 = avalonRoot.user.swjgMc;
        }
    }
});