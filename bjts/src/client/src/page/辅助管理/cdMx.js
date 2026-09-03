var cdMx = require("./cdMx.html");
avalon.component("cdMx",{
    template: cdMx,
    defaults: {
        params: {lcslid: ""},
        formData: {
            sbxx:{},
            pzmx: []
        },
        fx_flag: "1",
        bz: "",
        modalData1: {
            cpcode:"",
            sbno:"",
            pzlx:"",
            pzhm:"",
            spdm:"",
            spmc:"",
            jldw:"",
            sl:"",
            zh_flag:"",
            by_flag:"",
            jsje:"",
            tse:"",
            fx_flag:"",
        },
        modalData2: {},
        selRows: [],
        activeIndex: "0",
        tabs: ["申报明细","凭证明细"],
        searchData: {
            lcslid:"",
            pzlx:"",
            pzhm:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        onReady: function () {
            var self = this;
            this.setUnderline(0);
            this.createTable();
            this.searchData.lcslid = this.params.lcslid;
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
        handleClick: function (index) {
            this.activeIndex = index;
            this.setUnderline(index)
        },
        //设置激活的tab底部横条的位置和宽度
        setUnderline: function(index) {
            var width = $(".cdMx .tabs-item:eq("+index+")").outerWidth();
            var offsetX = this.calcOffset(index);
            $(".cdMx .tabs-underline").width(width);
            $(".cdMx .tabs-underline").css("left",offsetX+"px");
        },
        //计算第n个tab项的相对于父元素的横向偏移量
        calcOffset: function (index) {
            var parentOffset = $(".cdMx .tabs-list").offset();
            var childOffset = $(".cdMx .tabs-item:eq("+index+")").offset();
            return childOffset.left - parentOffset.left;
        },
        createTable:function(){
            var self=this;
            var columns = [
                { name: "sbno", label: "申报序号", index: "sbno",width: 70, align:"center",sortable: true },
                { name: "cpcode", label: "产品代码", index: "cpcode",width:90,hidden:true, align:"left",sortable: true },
                { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width:140,hidden:true, align:"left",sortable: true },
                { name: "pzlx", label: "凭证类型", index: "pzlx",width: 80,hidden:true, align:"center",sortable: true },
                { name: "pzlxMc", label: "凭证类型", index: "pzlxMc",width: 80, align:"center",sortable: true },
                { name: "pzhm", label: "凭证号码", index: "pzhm",width: 120, align:"center",sortable: true,},
                { name: "spdm", label: "商品代码", index: "spdm",width: 80, align:"center",sortable: true },
                { name: "spmc", label: "商品名称", index: "spmc",width: 120, align:"left",sortable: true },
                { name: "jldw", label: "计量单位", index: "jldw",width: 80, align:"center",sortable: true },
                { name: "sl", label: "数量", index: "sl",width: 80, align:"left",sortable: true },
                { name: "zh_flag", label: "暂缓标志", index: "zh_flag",width: 80, align:"center",sortable: true },
                { name: "by_flag", label: "不予标志", index: "by_flag",width: 80, align:"center",sortable: true },
                { name: "jsje", label: "计税金额", index: "jsje",width: 100, align:"right",sortable: true ,formatter: function (val) {
                        return tools.toDecimal2(val);
                    }},
                { name: "nsrswjg", label: "纳税人税务机关", index: "nsrswjg",width: 120, align:"left",sortable: true },
                { name: "tse", label: "申报退税额", index: "tse",width: 100, align:"right",sortable: true },
                { name: "fx_flag", label: "放行标志", index: "fx_flag",width: 80, align:"center",sortable: true },
            ];
            $("#cdMx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#cdMx-tablePager',
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
                    return $(".cdMx .form").height() -120;
                })(),
                beforeSelectRow:function(rowid,e){
                     if(e.target.nodeName=="TD"){
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
                        self.selRows.splice(index);
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
                    var pageNo=tools.getPageNo(pgButton,"cdMx-table");
                    self.search(pageNo);
                }
            });
            var params = {
                orderSql:"",
                pageSize: 20,
                pageNo: 1,
                lcslid: this.params.lcslid
            }
            $("#cdMx-table").jqGrid('clearGridData')
            ajax("POST","/glfw/cdsqzhcx/select/second",params).done(function(res){
                if(res.code=='0'){
                    self.formData.sbxx = res.data.sbxx;
                    $("#cdMx-table")[0].addJSONData(res.data.pzmx);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        allowPass: function() {
            var self = this;
            if (this.selRows.length == 0) {
                tools.info("请先选择需要设置放行的数据");
                return;
            }
            var pzxx = [];
            var rowData;
            for (var i = 0; i < this.selRows.length;i++ ){
                rowData = $("#cdMx-table").jqGrid("getRowData",this.selRows[i]);
                pzxx.push({cpcode: rowData.cpcode,pzlx: rowData.pzlx,pzhm: rowData.pzhm});
            }
            var params = {
                pzxx: pzxx,
                fx_flag:this.fx_flag,
                bz: this.bz
            }
            ajax("POST","/glfw/cdsqzhcx/szfx",params).done(function(res){
                if(res.code=='0'){
                    tools.info("设置成功");
                    self.closeModal("2");
                    self.search(1)
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.cdMx')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo;
            $("#cdMx-table").jqGrid('clearGridData')
            ajax("POST","/glfw/cdsqzhcx/select/third",params).done(function(res){
                if(res.code=='0'){
                    $("#cdMx-table").resetSelection();
                    $("#cdMx-table")[0].addJSONData(res.data);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        showModal: function(type) {
            if (type == "1") {
                $(".model").show();
                $(".cdMx .modal1").show();
            } else {
                if (this.selRows.length == 0) {
                    tools.info("请先选择需要设置放行的数据");
                    return;
                }
                this.fx_flag = "0";
                this.bz = "";
                $(".model").show();
                $(".cdMx .modal2").show();
            }
        },
        closeModal: function (type) {
            if (type == "1") {
                $(".model").hide();
                $(".cdMx .modal1").hide();
                for (var prop in this.modalData1) {
                    if (this.modalData1.hasOwnProperty(prop)) {
                        this.modalData1[prop] = "";
                    }
                }
            } else  {
                $(".model").hide();
                $(".cdMx .modal2").hide();
                for (var prop in this.modalData2) {
                    if (this.modalData2.hasOwnProperty(prop)) {
                        this.modalData2[prop] = "";
                    }
                }
            }
        }
    }
})