var qytzfb = require("./qytzfb.html");
avalon.component("qytzfb",{
    template: qytzfb,
    defaults: {
        act:"1",
        swjgmc:"",
        objvalMc:"",
        selRows:[],
        searchData: {
            notitype:"",
            title:"",
            objval:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        onReady:function(){
            var self = this;
            $(".qytzfb .fileupload").fileupload({
                dataType:"json",
                url:"/glfw/notice/qytz/import",
                add: function (e,data) {
                    data.submit();
                },
                done: function (e,data) {
                    if (data.result.code == "0") {
                        tools.info("导入成功");
                        self.search(1);
                    } else {
                        tools.info(data.result.msg);
                    }
                }
            });
            this.initTree();
            this.createTable();
        },
        changeTab:function(num){
            this.act=num;
        },
        toggle:function(){
            $(".tzgl .btn-container").toggleClass("active");
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
                { name: "release_user", label: "发布人", index: "release_user",width: 80, align:"left",sortable: true },
                { name: "release_swjgmc", label: "发布机关", index: "release_swjgmc",width: 140, align:"left",sortable: true },
                { name: "exist_upfile", label: "附件", index: "exist_upfile",width: 60, align:"center",sortable: true },
                { name: "valid_time", label: "通知截止日期", index: "valid_time",width: 100, align:"center",sortable: true },
            ];
            $("#qytzfb-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#qytzfb-tablePager',
                shrinkToFit: false,
                autowidth:true,
                altRows: true,
                multiselect: true,
                multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                width:"100%",
                height:(function(){
                    return $(".qytzfb .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    var rowObject = $("#qytzfb-table").jqGrid("getRowData",rowid);
                    if ($(e.target).hasClass("operation")) {
                        avalonRoot.addTab({title:"企业通知内容编辑",component:"qytzbj",params:{type:"update",noticeid:rowObject.id}});
                    } else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }
                },
                onSelectRow: function(rowid,status){
                    var index = self.selRows.indexOf(rowid);
                    if (status) {
                        self.selRows.push(rowid)
                    } else {
                        self.selRows.splice(index,1);
                    }
                },
                onSelectAll: function(rowids,status) {
                    if (status) {
                        self.selRows = rowids;
                    } else {
                        self.selRows = [];
                    }
                },onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"qytzfb-table");
                    self.search(pageNo);
                }
            });
        },
        add: function () {
            avalonRoot.addTab({title: "企业通知内容新增",component: "qytzbj",params:{type: "add"}});
        },
        myDelete: function () {
            if (this.selRows.length == 0) {
                tools.info("请先勾选需要删除的通知");
                return;
            }
            var self = this;
            tools.confirm("确定删除？","确定",function() {
	            ajax("POST","/glfw/qytzfbgl/delete",{ids: self.selRows.join(",")}).done(function(res){
		            if(res.code=='0'){
			            tools.info("删除成功");
			            self.selRows = [];
			            self.search(1);
		            }else{
			            tools.info(res.msg);
		            }
	            }).fail(function(err){
		            tools.info(err);
	            });
            });
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.qytzfb')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo;
            // if (params.notitype == "2" && params.objval && params.objval.length !== 18) {
            //     tools.info("请输入正确的通知对象");
            //     return
            // }
            $("#qytzfb-table").jqGrid('clearGridData')
            ajax("POST","/glfw/qytzfbgl/select/first",params).done(function(res){
                if(res.code=='0'){
                    $("#qytzfb-table")[0].addJSONData(res.data);
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
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".qytzfb .treeDiv"), setting,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.qytzfb').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }
            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.qytzfb').off('click');
        },
        publish:function(){
            var self=this;
            if (this.selRows.length == 0) {
                tools.info("请先勾选需要发布的通知");
                return;
            }
            var params = {ids:this.selRows.join(",")};
            ajax("POST","/glfw/qytzfbgl/publish",params).done(function(res){
                if(res.code=='0'){
                    tools.info("发布成功");
                    self.selRows = [];
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        handleChange: function () {
            this.objvalMc = "";
            this.searchData.objval = "";
        },
	    loadFile: function () {
		    // var a = document.createElement("a");
		    // a.href = "/glfw/static/企业定向通知批量导入模板.xls";
		    // a.click();
		    window.open("/glfw/static/qydxtz_template.xls");
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