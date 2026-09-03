var shspb=require("./shspb.html");
avalon.component('shspb', {
    template:shspb,
    defaults: {
        params:{},
        act:1,
	    swjgmc: "",
        searchData:{
            orderSql: "",
            bbdm: 'CX10001',
            cxtjDTO: {
                swjgDm: "",
                ny: "",
                cksjStart: "2020-11-11",
                cksjEnd: "2020-11-15",
            },
            pageSize:config.pageSize,
        },
        tableData:{},
        colModel: [
            {name:'swjgmc', label:'税务机关', align:'center', editable:true, width:150},
            {name:'bqtse_fh', label:'本月', align:'center', editable:true, width:150},
            {name:'ljtse_fh', label:'累计', align:'center', editable:true, width:150},
            {name:'bqtse_hz', label:'本月', align:'center', editable:true, width:150},
            {name:'ljtse_hz', label:'累计', align:'center', editable:true, width:150},
            {name:'bqtse_sp', label:'本月', align:'center', editable:true, width:150},
            {name:'ljtse_sp', label:'累计', align:'center', editable:true, width:150},
            {name:'bqtse_kp', label:'本月', align:'center', editable:true, width:150},
            {name:'ljtse_kp', label:'累计', align:'center', editable:true, width:150},
            {name:'dqdhztse', label:'当前待核准退税额', align:'center', editable:true, width:150},
            {name:'dqdsptse', label:'当前待审批退税额', align:'center', editable:true, width:150},
            {name:'dqdkptse', label:'当前已审批未退税', align:'center', editable:true, width:150},
        ],
        onReady:function(){
            try {
                this.searchData.cxtjDTO.swjgDm=avalonRoot.user.swjgDm;
                this.swjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

            }
            var self = this;
            self.initNy();
            self.initTree();
            // 创建表格
            this.createTable();
            $('.shspb .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.shspb .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });

        },
        initNy: function(){
            var self = this;
            var now = new Date();
            var year = now.getFullYear();
            var month = now.getMonth()+1;
            month<10? month='0'+month: null;
            self.searchData.cxtjDTO.ny = '' + year + month;
        },
        createTable:function(){
            var self=this;
            $("#shspb-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: self.colModel,
                viewrecords: true,
                rownumbers:true,
                pager: '#shspb-tablePager',
                shrinkToFit: false,
                width:"100%",
                // multiselect: true,
                // multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                cellEdit: true,
                cellsubmit: 'clientArray',
                height:(function(){
                    return $(".shspb .form").height() -100;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var b = getCellData("shspb-table", rowid, 'taxpayerCode')
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
                    var pageNo=tools.getPageNo(pgButton,"shspb-table");
                    self.search(pageNo);
                },
            })
            $("#shspb-table").jqGrid('setGroupHeaders', {
                useColSpanStyle: true,
                groupHeaders: [
                    { startColumnName: 'bqtse_fh', numberOfColumns: 2, titleText: '已复审退税额' },
                    { startColumnName: 'bqtse_hz', numberOfColumns: 2, titleText: '已核准退税额' },
                    { startColumnName: 'bqtse_sp', numberOfColumns: 2, titleText: '已审批退税额' },
                    { startColumnName: 'bqtse_kp', numberOfColumns: 2, titleText: '已退税税额' },
                ]
            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.shspb')).val();
            // self.search(1)
        },
        search:function(pageNo){
            var self=this;
            if(!self.searchData.cxtjDTO.ny){
                tools.info('查询条件“退税申报年月”不可为空。');
                return
            }
            this.searchData.pageSize = $(".ui-pg-selbox", $('.shspb')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#shspb-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/tjfx/loaddata",params).done(function(res){
                if(res.code=='0'){
                    $("#shspb-table").resetSelection();
                    $("#shspb-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
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
        filMonth:function(e){
            var date=e.target.value;
            var res=tools.MonCheup(date);
            if(res===false){
                tools.info("所属期输入错误");
                res=""
            }
            e.target.value=res;
            return ;
        },
	    reset: function() {
            this.searchData = {
                bbdm: 'CX10001',
                cxtjDTO: {
                    swjgDm: "",
                    ny: "",
                    cksjStart: "2020-11-11",
                    cksjEnd: "2020-11-15",
                },
                pageSize:config.pageSize,
            };
            this.swjgmc = avalonRoot.user.swjgMc;
        },
        
        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.cxtjDTO.swjgDm = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
	                    self.searchData.cxtjDTO.swjgDm = node.id;
	                    self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".shspb .treeDiv"), setting,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.shspb').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.shspb').off('click');
        },
    }
});