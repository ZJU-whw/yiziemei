var tztx = require("./tztx.html");
avalon.component("tztx",{
    template: tztx,
    defaults: {
        activeIndex: "0",
        tabs: ["通知列表（未读）","通知列表（已读）"],
        searchData:{
            title:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        onReady: function () {
            this.setUnderline(0);
            this.createTable1();
            this.createTable2();
        },
        handleClick: function (index) {
            this.activeIndex = index;
            this.setUnderline(index)
        },
        //设置激活的tab底部横条的位置和宽度
        setUnderline: function(index) {
            var width = $(".tztx .tabs-item:eq("+index+")").outerWidth();
            var offsetX = this.calcOffset(index);
            $(".tztx .tabs-underline").width(width);
            $(".tztx .tabs-underline").css("left",offsetX+"px");
        },
        //计算第n个tab项的相对于父元素的横向偏移量
        calcOffset: function (index) {
            var parentOffset = $(".tztx .tabs-list").offset();
            var childOffset = $(".tztx .tabs-item:eq("+index+")").offset();
            return childOffset.left - parentOffset.left;
        },
        createTable1:function(){
            var self=this;
            var columns = [
                { name: "id", label: "主键", index: "id", hidden:true, align:"left",sortable: true },
                { name: "title", label: "标题", index: "title",width: 200, align:"left",sortable: true,formatter:function (cellvalue) {
                        return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>";
                    } },
                { name: "release_time", label: "发布日期", index: "release_time",width: 100, align:"center",sortable: true },
                { name: "release_user", label: "发布人", index: "release_user",width: 100, align:"center",sortable: true },
                { name: "release_swjgmc", label: "发布机关", index: "release_swjgmc",width: 100, align:"center",sortable: true },
                { name: "exist_upfile", label: "附件", index: "exist_upfile",width: 100, align:"center",sortable: true },
                { name: "bz", label: "备注", index: "bz",width: 100, align:"center",sortable: true },
            ];
            $("#tztxwd-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#tztxwd-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".tztx .page").height() -100;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var rowObj = $("#tztxwd-table").jqGrid("getRowData", rowid);
                        avalonRoot.addTab({title:"通知内容",component:"tznr",params: {noticeid: rowObj.id}});
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
                    var pageNo=tools.getPageNo(pgButton,"tztxwd-pager");
                    self.search(pageNo);
                }
            });
        },
        createTable2:function(){
            var self=this;
            var columns = [
                { name: "id", label: "主键", index: "id", hidden:true, align:"left",sortable: true },
                { name: "title", label: "标题", index: "title",width: 200, align:"left",sortable: true,formatter:function (cellvalue) {
                        return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>";
                    } },
                { name: "release_time", label: "发布日期", index: "release_time",width: 100, align:"center",sortable: true },
                { name: "release_user", label: "发布人", index: "release_user",width: 100, align:"center",sortable: true },
                { name: "release_swjgmc", label: "发布机关", index: "release_swjgmc",width: 100, align:"center",sortable: true },
                { name: "exist_upfile", label: "附件", index: "exist_upfile",width: 100, align:"center",sortable: true },
                { name: "bz", label: "备注", index: "bz",width: 100, align:"center",sortable: true },
            ];
            $("#tztxyd-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#tztxyd-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".tztx .page").height() -100;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var rowObj = $("#tztxyd-table").jqGrid("getRowData", rowid);
                        avalonRoot.addTab({title:"通知内容",component:"tznr",params: {noticeid: rowObj.id}});
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
                    var pageNo=tools.getPageNo(pgButton,"tztxyd-pager");
                    self.search(pageNo);
                }
            });
        },
        search: function (pageNo) {
            var self = this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.tztx')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo;
            if (this.activeIndex == "0") {
                params.read = "N";
            } else {
                params.read = "Y";
            }
            ajax("POST","/glfw/tztx/select/first",params).done(function(res){
                if(res.code=='0'){
                    if (self.activeIndex == "0") {
                        $("#tztxwd-table")[0].addJSONData(res.data);
                    } else {
                        $("#tztxyd-table")[0].addJSONData(res.data);
                    }
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
    }
})