var flgljcxx = require("./flgljcxx.html");
avalon.component("flgljcxx",{
    template:flgljcxx,
    defaults: {
        act:1,
        swjgmc:"",
        swjgData:"",
        searchData:{
            swjg_dm:"",
            ssny:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        onReady:function(){
            try {
                this.searchData.swjg_dm=avalonRoot.user.swjgDm;
                this.swjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

            }
            this.initTree();
            this.createTable();
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
        createTable:function(){
            var self=this;
            var columns = [
                { name: "id", label: "主键id", index: "id", align:"center",hidden:true,sortable: true },
                { name: "qyhgdm", label: "海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
                { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
                { name: "nsrmc", label: "企业名称", index: "nsrmc",width: 140, align:"left",sortable: true },
                { name: "swjgmc", label: "税务机关", index: "swjgmc",width: 100, align:"center",sortable: true },
                { name: "ssny", label: "分类管理评定年月", index: "ssny",width: 80, align:"center",sortable: true },
                { name: "qylx", label: "企业类型", index: "qylx",width: 100, align:"left",sortable: true },
                { name: "shxtbazt", label: "审核系统备案状态", index: "shxtbazt",width: 80, align:"center",sortable: true },
                { name: "jsxtqyzt", label: "金三系统企业状态", index: "jsxtqyzt",width: 80, align:"center",sortable: true },
                { name: "flglcd", label: "评定前分类管理类别", index: "flglcd",width: 80, align:"center",sortable: true },
                { name: "snd_qmjzc", label: "上一年度期末净资产", index: "snd_qmjzc",width: 80, align:"right",sortable: true },
                { name: "snd_cktse", label: "上一年度已办理出口退税额", index: "snd_cktse",width: 80, align:"right",sortable: true },
                { name: "nsxydj", label: "纳税信用等级", index: "nsxydj",width: 80, align:"center",sortable: true },
                { name: "flgl_hg", label: "海关企业信用管理类别", index: "flgl_hg",width: 80, align:"center",sortable: true },
                { name: "flgl_wg", label: "外汇管理的分类管理等级", index: "flgl_wg",width: 80, align:"center",sortable: true },
                { name: "scsbzjljys", label: "自首笔申报出口退（免）税之日起至评定时未满12个月", index: "scsbzjljys",width: 80, align:"center",sortable: true },
                { name: "snd_ljlgywsb", label: "上一年度累计六个月未申报", index: "snd_ljlgywsb",width: 80, align:"center",sortable: true },
                { name: "swdjrq", label: "税务登记日期", index: "swdjrq",width: 80, align:"center",sortable: true },
                { name: "jcaj_wh", label: "近三年稽查案件情况", index: "jcaj_wh",width: 80, align:"center",sortable: true },
                { name: "lhcjsxqy", label: "被列为国家联合惩戒对象的失信企业", index: "lhcjsxqy",width: 80, align:"center",sortable: true},
                { name: "slqyfr_new", label: "四类出口企业法定代表人新成立的出口企业", index: "slqyfr_new",width: 80, align:"center",sortable: true },
            ];
            $("#flgljcxx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#flgljcxx-tablePager',
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
                    return $(".flgljcxx .form").height() -200;
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
                    var pageNo=tools.getPageNo(pgButton,"flgljcxx-table");
                    self.search(pageNo);
                }
            });
            $("#flgljcxx-table").jqGrid('setGroupHeaders', {
                useColSpanStyle: true,
                groupHeaders:[
                    {startColumnName:'qyhgdm', numberOfColumns:19, titleText: '出口企业分类管理评定指标统计清册'}
                ]
            })
            $(".flgljcxx th.ui-th-column div").css({"white-space":"normal","height":"auto",})
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.flgljcxx')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#flgljcxx-table").jqGrid('clearGridData')
            ajax("POST","/glfw/flglpdzb/jcxxtj/select",params).done(function(res){
                if(res.code=='0'){
                    $("#flgljcxx-table")[0].addJSONData(res.data);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.swjg_dm = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.swjg_dm = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".flgljcxx .treeDiv"), setting,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.flgljcxx').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.flgljcxx').off('click');
        },
        exform:function(){
            var self=this;
            if($('#flgljcxx-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/glfw/export/flglpdzb/jcxxtj");
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