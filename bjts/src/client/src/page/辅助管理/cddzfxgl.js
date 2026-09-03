var cddzfxgl=require("./cddzfxgl.html");
avalon.component('cddzfxgl', {
    template:cddzfxgl,
    defaults: {
        params:{},
        act:1,
        selRows: [],
        bz: "",
        fx_flag: "1",
        pzhm:"",
        searchData:{
            qyhgdm:"",
            pzlx:"",
            pzhm:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        modalData1: {
            cpcode:"",
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
        },
        modalData2:{},
        formData: {},
        onReady:function(){
            var self = this;
            this.createTable();
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
                { name: "qyhgdm", label: "海关代码", index: "qyhgdm",width:90, align:"left",sortable: true },
                { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
                { name: "nsrmc", label: "企业名称", index: "nsrmc",width: 180, align:"left",sortable: true },
                { name: "cpcode", label: "产品代码", index: "cpcode",width: 140, hidden:true,align:"center",sortable: true },
                { name: "pzlxMc", label: "凭证类型", index: "pzlxMc",width: 80, align:"center",sortable: true},
                { name: "pzlx", label: "凭证类型", index: "pzlx",width: 80,hidden:true, align:"center",sortable: true},
                { name: "pzhm", label: "凭证号码", index: "pzhm",width: 80, align:"center",sortable: true,formatter:function(cellvalue){
                    self.pzhm = cellvalue;
                    return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>";
                } },
                { name: "pzhm", label: "凭证号码", index: "pzhm",width: 80, align:"center",sortable: true,hidden:true },
                { name: "fx_flag", label: "放行标志", index: "fx_flag",width: 80, align:"center",sortable: true },
                { name: "op_user", label: "设置人", index: "op_user",width: 70, align:"left",sortable: true },
                { name: "op_date", label: "设置时间", index: "op_date",width: 120, align:"center",sortable: true },
                { name: "bz", label: "注释说明", index: "bz",width: 120, align:"left",sortable: true },
            ];
            $("#cddzfxgl-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#cddzfxgl-tablePager',
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
                    return $(".cddzfxgl .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var rowData = $("#cddzfxgl-table").jqGrid("getRowData",rowid);
                        var params = {
                            cpcode: rowData.cpcode,
                            pzlx: rowData.pzlx,
                            pzhm: rowData.pzhm
                        };
                        self.findMx(params);
                        return false;
                    }else if(e.target.nodeName=="TD"){
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
                    var pageNo=tools.getPageNo(pgButton,"cddzfxgl-table");
                    self.search(pageNo);
                }
            });
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.cddzfxgl')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo;
            $("#cddzfxgl-table").jqGrid('clearGridData')
            ajax("POST","/glfw/cddzfxgl/select/first",params).done(function(res){
                if(res.code=='0'){
                    $("#cddzfxgl-table").resetSelection();
                    $("#cddzfxgl-table")[0].addJSONData(res.data);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        findMx: function(params) {
            var self = this;
            ajax("POST","/glfw/cddzfxgl/select/second",params).done(function(res){
                if(res.code=='0'){
                    self.modalData1=res.data;
                    self.showModal("1");
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
                rowData = $("#cddzfxgl-table").jqGrid("getRowData",this.selRows[i]);
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
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        exform:function(){
            var self=this;
            if($('#cddzfxgl-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/glfw/export/cddzfxglqd");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
        showModal: function(type) {
            if (type == "1") {
                $(".model").show();
                $(".cddzfxgl .modal1").show();
            } else {
                if (this.selRows.length == 0) {
                    tools.info("请先选择需要设置放行的数据");
                    return;
                }
                this.fx_flag = "0";
                this.bz = "";
                $(".model").show();
                $(".cddzfxgl .modal2").show();
            }
        },
        closeModal: function (type) {
            if (type == "1") {
                $(".model").hide();
                $(".cddzfxgl .modal1").hide();
                for (var prop in this.modalData1) {
                    if (this.modalData1.hasOwnProperty(prop)) {
                        this.modalData1[prop] = "";
                    }
                }
            } else  {
                $(".model").hide();
                $(".cddzfxgl .modal2").hide();
                for (var prop in this.modalData2) {
                    if (this.modalData2.hasOwnProperty(prop)) {
                        this.modalData2[prop] = "";
                    }
                }
            }
        },
    }
});