var qylstz = require("./qylstz.html");
avalon.component("qylstz",{
    template: qylstz,
    defaults: {
        act:"1",
        objvalMc:"",
        swjgmc:"",
        searchData: {
            notitype:"",
            title:"",
            objval:"",
            sfdq:"",
            exist_upfile:"",
            release_user:"",
            release_swjgdm:"",
            release_timeq:"",
            release_timez:"",
            bz:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        onReady:function(){
            var self = this;
            try {
                this.searchData.release_swjgdm=avalonRoot.user.swjgDm;
                this.swjgmc=avalonRoot.user.swjgMc.slice(6);
            } catch (e) {

            }
	        $(".qylstz .datepicker.date-day").datepicker({
		        dateFormat:"yy-mm-dd"
	        });
            this.initTree();
            this.createTable();
        },
        changeTab:function(num){
            this.act=num;
        },
        //copy bg
        createTable:function(){
            var self=this;
            var columns = [
                { name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
                { name: "title", label: "标题", index: "title",width: 120, align:"left",sortable: true,
                    formatter:function(cellvalue, options, rowObject){
                        return "<span  style='color: #0000FF;text-decoration: underline;cursor: pointer' class='operation'>"+cellvalue+"</span>";
                    }
                },
                { name: "notitype", label: "类型", index: "notitype",width: 80, align:"center",sortable: true },
                { name: "objval", label: "通知对象", index: "objval",width: 200, align:"left",sortable: true },
                { name: "release_swjgmc", label: "发布机关", index: "release_swjgmc",width: 100, align:"left",sortable: true },
                { name: "release_time", label: "发布日期", index: "release_time",width: 100, align:"center",sortable: true },
                { name: "valid_time", label: "截至日期", index: "valid_time",width: 100, align:"center",sortable: true },
                { name: "exist_upfile", label: "附件", index: "exist_upfile",width: 60, align:"center",sortable: true },
                { name: "cs_flag", label: "抄送", index: "cs_flag",width: 120, align:"left",sortable: true },
                { name: "release_user", label: "发布人", index: "release_user",width: 80, align:"left",sortable: true },
                { name: "bz", label: "备注", index: "bz",width: 120, align:"left",sortable: true },
            ];
            $("#qylstz-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#qylstz-tablePager',
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
                    return $(".qylstz .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    var rowObject = $("#qylstz-table").jqGrid("getRowData",rowid);
                    if ($(e.target).hasClass("operation")) {
                        avalonRoot.addTab({title:"企业通知内容查看",component:"qytzbj",params:{type:"check",noticeid:rowObject.id}});
                    } else if(e.target.nodeName=="TD"){
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
                    var pageNo=tools.getPageNo(pgButton,"qylstz-table");
                    self.search(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            // self.search(1);
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.qylstz')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo;
            $("#qylstz-table").jqGrid('clearGridData')
            ajax("POST","/glfw/qylstzcx/select/first",params).done(function(res){
                if(res.code=='0'){
                    $("#qylstz-table")[0].addJSONData(res.data);
                    self.closeHyper()
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            });
        },
        initTree:function() {
            var self = this;
            var setting1 = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.objval = node.id;
                        self.objvalMc = node.id +" " +node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.objval = node.id;
                        self.objvalMc = node.id +" " +node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            var setting2 = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.release_swjgdm = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.release_swjgdm = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($("#qylstzZtree1"), setting1,data);
                $.fn.zTree.init($("#qylstzZtree2"), setting2,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showHyper:function(){
            $('.qylstz .select-sub').toggle();
            $('.qylstz .select-wrapper .icon').toggleClass("active");
            if ($('.qylstz .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.qylstz .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.qylstz .select-wrapper .icon').attr("title","展开查询条件")
            }
        },closeHyper:function(){
            $('.qylstz .select-sub').hide();
            $('.qylstz .select-wrapper .icon').removeClass('active');
            $('.qylstz .select-wrapper .icon').attr("title","展开查询条件")
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.qylstz').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }
            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.qylstz').off('click');
        },
        exform:function(){
            var self=this;
            if($('#qylstz-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/glfw/export/tzgl/qylstzcx");
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
        handleChange: function () {
            this.objvalMc = "";
            this.searchData.objval = "";
        },
        reset: function() {
            this.searchData = {
                notitype:"",
                title:"",
                objval:"",
                sfdq:"",
                exist_upfile:"",
                release_user:"",
                release_swjgdm:avalonRoot.user.swjgDm,
                release_timeq:"",
                release_timez:"",
                bz:"",
                orderSql:"",
                pageSize:config.pageSize,
            };
            this.swjgmc = avalonRoot.user.swjgMc;
        },
        $computed:{
            getPH:function(){
                if(this.searchData.notitype=="1"){
                    return "请选择群发税务机关"
                }else if(this.searchData.notitype=="2"){
                    return "请输入企业税号"
                }else{
                    return ""
                }
            },
        }
    }
})