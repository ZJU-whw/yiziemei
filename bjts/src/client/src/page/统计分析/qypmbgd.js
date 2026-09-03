var qypmbgd=require("./qypmbgd.html");
avalon.component('qypmbgd', {
    template:qypmbgd,
    defaults: {
        params:{},
        act:1,
        searchData:{
            zt:"",
            aqmzt:"",
            searchKey:"",
            searchValue:"",
            kpcsState:"",
            dateStart:"",
            dateEnd:"",
            ptktlx:"",
            diskType:"",
            source:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        tableArr:[
            { name: "id", label: "id", index: "id", sortable: true, hidden:true, width: 70 ,align:"center",},
            { name: "taxpayerName", label: "企业名称", index: "taxpayer_name",hidden:false, sortable: true,align:"center", width: 150},

            { name: "taxpayerCode", label: "企业税号", index: "taxpayer_code", width: 120, align:"center",sortable: true },
            { name: "contacter", label: "联系人", index: "contacter", width: 80, align:"left",sortable: true },
            { name: "contactMobile", label: "联系人手机号", index: "contact_mobile", sortable: true,align:"left", width: 60 },
            { name: "publishNo", label: "发行地区编号", index: "publish_no", sortable: true,align:"center", width: 60 },
            { name: "zt", label: "注册状态", index: "zt", sortable: false,align:"center", width: 60 },
            { name: "kpcsState", label: "参数状态", index: "kpcs_state", sortable: false,align:"center", width: 60 },
            { name: "aqmzt", label: "安全码状态", index: "aqmzt", sortable: false,align:"center", width: 60 },
            { name: "zcmzt", label: "注册文件", index: "zcmzt", sortable: false,align:"center", width: 60 },
            { name: "diskType", label: "税盘类型", index: "disk_type", sortable: true,align:"center", width: 60 },
            { name: "ptktlx", label: "平台类型", index: "ptktlx", sortable: true,align:"center", width: 60 },
            { name: "source", label: "信息来源", index: "source", sortable: true,align:"center", width: 60 },
            { name: "uptime", label: "修改日期", index: "uptime", sortable: true,align:"center", width: 60 },
            { name: "securityCodeUrl", label: "安全码", index: "securityCodeUrl",hidden:true, sortable: false,align:"center", width: 60 },
            { name: "zcmUrl", label: "注册码", index: "zcmUrl",hidden:true, sortable: false,align:"center", width: 60 },
        ],
        tableOption:[
            {name:"zt",label:"注册状态",show:true},
            {name:"kpcsState",label:"参数状态",show:true},
            {name:"aqmzt",label:"安全码状态",show:true},
            {name:"zcmzt",label:"注册文件",show:true},
            {name:"diskType",label:"税盘类型",show:true},
            {name:"ptktlx",label:"平台类型",show:true},
            {name:"source",label:"信息来源",show:true},
            {name:"uptime",label:"修改日期",show:true},
        ],
        onReady:function(){
            var self = this;
            this.createTable(this.tableArr);
            // this.creatChart();
            self.initTree();
            $('.qypmbgd .control .datepicker').datepicker({
                dateFormat: 'yy-mm-dd'
            });
        },
        changeTab:function(num){
            this.act=num;
        },
        creatChart:function(){

        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#qypmbgd-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#qypmbgd-tablePager',
                shrinkToFit: true,
                width:"100%",
                multiselect: true,
                multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){ return $(".qypmbgd .form").height() -90;})(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('dzzd')){
                        var b = getCellData("qypmbgd-table", rowid, 'taxpayerCode')
                        vm.addTab({title:"企业信息采集",component:"qyxxcj",params:{taxpayerCode:b}});
                        return false;
                    }else if($(e.target).hasClass('aqm')){
                        var url = getCellData("qypmbgd-table", rowid, 'securityCodeUrl')
                        if(!url){tools.info('链接不存在');return false;}
                        window.open(url)
                        return false;
                    }else if($(e.target).hasClass('zcwj')){
                        var url = getCellData("qypmbgd-table", rowid, 'zcmUrl')
                        if(!url){tools.info('链接不存在');return false;}
                        window.open(url)
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
                    var pageNo=tools.getPageNo(pgButton,"qypmbgd-table");
                    self.search(pageNo);
                }

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.qypmbgd')).val();
            self.search(1)
        },
        setTableOption:function(item,e){
            var self=this;
            setTimeout(function(){
                self.resetTable();
            },200)
        },
        resetTable:function() {
            var self = this;
            for (var i = 0; i < self.tableOption.length; i++) {
                if (self.tableOption[i].show == true) {
                    $("#qypmbgd-table").showCol(self.tableOption[i].name)
                } else {
                    $("#qypmbgd-table").hideCol(self.tableOption[i].name)
                }
            }
            $("#qypmbgd-table").setGridWidth($('.qypmbgd').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.qypmbgd')).val();
            var params={
                pageSize:this.searchData.pageSize,
                pageNo:pageNo,
                orderSql:this.searchData.orderSql,
                searchKey:this.searchData.searchKey,
                searchValue:this.searchData.searchValue,
                ptktlx:this.searchData.ptktlx,
                dateStart:this.searchData.dateStart,
                dateEnd:this.searchData.dateEnd,
                source:this.searchData.source,
                zt:this.searchData.zt,
                aqmzt:this.searchData.aqmzt,
                kpcsState:this.searchData.kpcsState,
                diskType:this.searchData.diskType
            }
            $("#qypmbgd-table").jqGrid('clearGridData')
            ajax("POST","/xxcj/company/list",params).done(function(res){
                if(res.code=='0'){
                    $("#qypmbgd-table").resetSelection();
                    $("#qypmbgd-table")[0].addJSONData(res.data);
                    self.closeHyper();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        showHyper:function(){
            $('.qypmbgd .hyper').toggle();
            $('.qypmbgd .hyperBtn').toggleClass('active');
        },
        closeHyper:function(){
            $('.qypmbgd .hyper').hide();
            $('.qypmbgd .hyperBtn').removeClass('active');
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
        showMenu:function(e){
            var self=this;
            $(".dropdown-menu",e.target).show();
            $('.qypmbgd').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.qypmbgd').off('click');
        },
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.opDeptCode = node.id;
                        self.searchData.opDeptName = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.opDeptCode = node.id;
                        self.searchData.opDeptName = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{
                    key:{
                        children:"item",
                        name:"text"
                    }
                }
            };
            ajax("POST","/cxfw/export/readtree", {nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($("qypmbgd .treeDiv"), setting, res.data);
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })


        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",e.target).show();
            $('.qypmbgd').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.qypmbgd').off('click');
        },
        exform:function(){
            var self=this;
            if($("#qypmbgd-table").jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params={
                searchKey:self.searchData.searchKey,
                searchValue:self.searchData.searchValue,
                ptktlx:self.searchData.ptktlx,
                dateStart:self.searchData.dateStart,
                dateEnd:self.searchData.dateEnd,
                source:self.searchData.source,
                zt:self.searchData.zt,
                aqmzt:self.searchData.aqmzt,
                kpcsState:self.searchData.kpcsState,
                diskType:self.searchData.diskType
            }
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("method", "post");
            form.attr("action", "/bjtssw/tjfx/loaddata/export");
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