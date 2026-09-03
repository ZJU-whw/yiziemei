var bbwh=require("./bbwh.html");
avalon.component('bbwh', {
    template:bbwh,
    defaults: {
        params:{},
        searchData:{
            pageSize:config.pageSize,
        },
        tableData:{},
        asyncData:{},
        modelData:{
            isAdd:1,
            bbdldm:"",
            bbdm:"",
            bbmc:"",
            bbjc:"",
            proc:"",
            showorder:"",
            bbtype:"",
            hztype:"",
            excelcol:"",
            excelrow:"",
        },
        modelData2:{
            type:"1",
            headCol:"",
            headLine:"",
            dataCol:"",
            dataLine:"",
            endLine:"",
            isUpdateItem:"",
            isUpdateFormula:"",
            note:""
        },
        bbdlList: [], // 报表大类列表
        onReady:function(){
            var self = this;
            var w;
            this.getTableRow();
            $('#bbwh-fileupload').fileupload({
                dataType: 'json',
                autoUpload:false,
                add:function(e,data){
                    $('#fileAdd').text(data.files[0].name);
                    self.asyncData=data;
                },
                done: function (e, data) {
                    if(data.result.code == "0"){
                        self.hideMB();
                        self.openEx();
                    }else{
                        tools.info(data.result.msg);
                    }
                }
            });

            $('#bbwh-fileupload2').fileupload({
                dataType: 'json',
                add:function(e,data){
                    var rowid=$("#bbwh-table").jqGrid("getGridParam","selrow");
                    if(!rowid){
                        tools.info('请先选择一行数据！');
                        return ;
                    }
                    var bbdm=getCellData("bbwh-table",rowid,'bbdm');
                    data.formData={
                        bbdm:bbdm,
                        type:self.modelData2.type,
                        headCol:self.modelData2.headCol||"",
                        headLine:self.modelData2.headLine||"",
                        dataCol:self.modelData2.dataCol||"",
                        dataLine:self.modelData2.dataLine||"",
                        endLine:self.modelData2.endLine||"",
                        isUpdateItem:self.modelData2.isUpdateItem||false,
                        isUpdateFormula:self.modelData2.isUpdateFormula||false,
                    }
                    if(data.formData.headCol==''||data.formData.headLine==''||data.formData.dataCol==''||data.formData.dataLine==''||data.formData.endLine==''){
                        tools.info("请输入必填项！");
                        return;
                    }
                    data.submit();
                    w=artDialog({
                        id: 'Tips',
                        title: false,
                        cancel: false,
                        fixed: true,
                        lock: true,
                        content:"模板上传中..."
                    })
                },
                done: function (e, data) {
                    w.close();
                    if(data.result.code == "0"){
                        self.openEx();
                        self.hideMB();
                        self.search(1)
                    }else{
                        tools.info(data.result.msg);
                    }
                },
                error:function(){
                    w.close();
                }
            });
            this.getBbdlList()
        },
        // 获取报表大类列表
        getBbdlList () {
            let self = this
            ajax("POST","/bjtssw/tjbb/mgt/bbdl").done(function(res){
                if(res.code=='0'){
                    self.bbdlList = res.data
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "bbdldm", label: "报表大类代码", index: "bbdldm", width: 80, align:"center",sortable: false },
                { name: "bbdm", label: "报表代码", index: "bbdm", sortable: true,align:"left", width: 150,formatter: function(cellvalue, options, rowObject){
                    return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>"
                }},
                { name: "bbmc", label: "报表中文名称", index: "bbmc", sortable: true,align:"left", width: 200 },
                { name: "bbjc", label: "报表简称", index: "bbjc", sortable: true,align:"left", width: 200 },
                { name: "showorder", label: "显示顺序", index: "showorder", sortable: true,align:"center", width: 80 ,},
                { name: "bbtype", label: "报表类型", index: "bbtype", sortable: true,align:"center", width: 100 ,},
                { name: "hztype", label: "汇总类型", index: "hztype", sortable: true,align:"center", width: 100 ,},
                { name: "proc", label: "初始过程", index: "proc", sortable: true,align:"left", width: 200 },
                { name: "prochz", label: "汇总过程", index: "prochz", sortable: true,align:"left", width: 200 },
                { name: "excelrow", label: "起始行", index: "excelrow",  sortable: true,align:"center", width: 100 ,},
                { name: "excelcol", label: "起始列", index: "excelcol", sortable: true,align:"center", width: 100 ,},
                { name: "endrow", label: "结束行", index: "endrow",  sortable: true,align:"center", width: 100 ,},
                { name: "note", label: "note", index: "note",  hidden: true},
                { name: "headcol", label: "headcol", index: "headcol",  hidden:true},
                { name: "headrow", label: "headrow", index: "headrow",  hidden:true},
                // { name: "", label:"操作", width:80, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(cellvalue, options, rowObject){
                //     var str="";
                //     str+="<div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div>"
                //     return str;
                // }},
            ]
            self.createTable(tableArr)
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#bbwh-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#bbwh-tablePager',
                shrinkToFit: true,
                width:"100%",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".bbwh .form").height() -100;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var bbdm=getCellData("bbwh-table",rowid,'bbdm');
                        avalonRoot.addTab({title:"报表预览",component:"test",sameCheck:true,params:{bbdm:bbdm}});
                        return true;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return true;
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
                    var pageNo=tools.getPageNo(pgButton,"bbwh-table");
                    self.search(pageNo);
                }

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.bbwh')).val();
            self.search(1)
        },
        editModel:function(){
            var rowid=$("#bbwh-table").jqGrid("getGridParam","selrow");
            if(!rowid){
                tools.info('请先选择一行数据！');
                return ;
            }
            var self=this;
            self.modelData ={
                bbdldm:getCellData("bbwh-table",rowid,'bbdldm').trim(),
                bbdm:getCellData("bbwh-table",rowid,'bbdm').trim(),
                bbmc:getCellData("bbwh-table",rowid,'bbmc').trim(),
                bbjc:getCellData("bbwh-table",rowid,'bbjc').trim(),
                proc:getCellData("bbwh-table",rowid,'proc').trim(),
                prochz:getCellData("bbwh-table",rowid,'prochz').trim(),
                showorder:getCellData("bbwh-table",rowid,'showorder').trim(),
                bbtype:getCellData("bbwh-table",rowid,'bbtype').trim(),
                hztype:getCellData("bbwh-table",rowid,'hztype').trim(),
                excelcol:getCellData("bbwh-table",rowid,'excelcol').trim(),
                excelrow:getCellData("bbwh-table",rowid,'excelrow').trim(),
            };
            self.showModel(0);
        },
        resetTable:function() {
            var self = this;
            for (var i = 0; i < self.tableOption.length; i++) {
                if (self.tableOption[i].show == true) {
                    $("#bbwh-table").showCol(self.tableOption[i].name)
                } else {
                    $("#bbwh-table").hideCol(self.tableOption[i].name)
                }
            }
            $("#bbwh-table").setGridWidth($('.bbwh').width())
        },

        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.bbwh')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#bbwh-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/tjbb/mgt/list",params).done(function(res){
                if(res.code=='0'){
                    $("#bbwh-table").resetSelection();
                    $("#bbwh-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                    $("#bbwh-table").jqGrid('setSelection',1);
                    self.closeHyper();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        addRow:function(){
            this.modelData={
                isAdd:1,
                bbdldm:"B01",
                bbdm:"",
                bbmc:"",
                bbjc:"",
                proc:"",
                prochz:"",
                showorder:"",
                bbtype:"1",
                hztype:"1",
                excelcol:"",
                excelrow:"",
            },
            this.showModel(1)
        },
        showHyper:function(){
            $('.bbwh .hyper').toggle();
            $('.bbwh .hyperBtn').toggleClass('active');
        },
        closeHyper:function(){
            $('.bbwh .hyper').hide();
            $('.bbwh .hyperBtn').removeClass('active');
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
        filMon:function(e){
            var date=e.target.value;
            var res=tools.MonCheup(date);
            if(res===false){
                tools.info("申报年月输入错误");
                res=""
            }
            e.target.value=res;
            return ;
        },

        showModel:function(num){
            this.modelData.isAdd=num;
            $('.model').show();
            $('.bbwh #editModel').show();
        },
        hideModel:function(){
            $('.model').hide();
            $('.bbwh #editModel').hide();
            this.modelData={
                isAdd:1,
                bbdldm:"",
                bbdm:"",
                bbmc:"",
                bbjc:"",
                proc:"",
                showorder:"",
                bbtype:"",
                hztype:"",
                excelcol:"",
                excelrow:"",
            }
        },
        showMB:function(){
            var rowid=$("#bbwh-table").jqGrid("getGridParam","selrow");
            if(!rowid){
                tools.info('请先选择一行数据！');
                return ;
            }
            var self=this;
            self.modelData2 ={
                headLine:getCellData("bbwh-table",rowid,'headrow').trim(),
                headCol:getCellData("bbwh-table",rowid,'headcol').trim(),
                dataLine:getCellData("bbwh-table",rowid,'excelrow').trim(),
                dataCol:getCellData("bbwh-table",rowid,'excelcol').trim(),
                endLine:getCellData("bbwh-table",rowid,'endrow').trim(),
                type:"1",
                isUpdateItem:"",
                isUpdateFormula:"",
                note:""
            }
            $('.model').show();
            $('.bbwh #MBupload').show();
        },
        hideMB:function(){
            $('.model').hide();
            $('.bbwh #MBupload').hide();
            this.modelData2={
                type:"1",
                headCol:"",
                headLine:"",
                dataCol:"",
                dataLine:"",
                endLine:"",
                isUpdateItem:"",
                isUpdateFormula:"",
                note:""
            }
        },
        sendData:function(){
            var self=this;
            var data=this.asyncData;
            var rowid=$("#bbwh-table").jqGrid("getGridParam","selrow");
            if(!rowid){
                tools.info('请先选择一行数据！');
                return ;
            }
            var bbdm=getCellData("bbwh-table",rowid,'bbdm');
            data.formData={
                bbdm:bbdm,
                type:self.modelData2.type,
                headCol:self.modelData2.headCol||"",
                headLine:self.modelData2.headLine||"",
                dataCol:self.modelData2.dataCol||"",
                dataLine:self.modelData2.dataLine||"",
                endLine:self.modelData2.endLine||"",
                isUpdateItem:self.modelData2.isUpdateItem||false,
                isUpdateFormula:self.modelData2.isUpdateFormula||false,
            }
            if(data.formData.headCol==''||data.formData.headLine==''||data.formData.dataCol==''||data.formData.dataLine==''||data.formData.endLine==''){
                tools.info("请输入必填项！");
                return;
            }
            $('#bbwh-fileupload').fileupload('send', data);
        },
        saveModel:function(){
            var self=this;
            var params=tools.clone(self.modelData)
            ajax("POST","/bjtssw/tjbb/mgt/update",params).done(function(res){
                if(res.code=='0'){
                    self.hideModel();
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        editZD:function(){
            var rowid=$("#bbwh-table").jqGrid("getGridParam","selrow");
            if(!rowid){
                tools.info('请先选择一行数据！');
                return ;
            }
            var bbdm=getCellData("bbwh-table",rowid,'bbdm');
            var note=getCellData("bbwh-table",rowid,'note');
            if(note=='OWN'){
                avalonRoot.addTab({title:"报表字段维护",component:"bbzdedit",sameCheck:true,params:{bbdm:bbdm}});
            }else{
                avalonRoot.addTab({title:"报表字段维护",component:"bbzd",sameCheck:true,params:{bbdm:bbdm}});
            }

        },
        editZB:function(){
            var rowid=$("#bbwh-table").jqGrid("getGridParam","selrow");
            if(!rowid){
                tools.info('请先选择一行数据！');
                return ;
            }
            var bbdm=getCellData("bbwh-table",rowid,'bbdm');
            avalonRoot.addTab({title:"报表指标维护",component:"bbzb",sameCheck:true,params:{bbdm:bbdm}});
        },
        openEx:function(){
            var rowid=$("#bbwh-table").jqGrid("getGridParam","selrow");
            if(!rowid){
                tools.info('请先选择一行数据！');
                return ;
            }
            var bbdm=getCellData("bbwh-table",rowid,'bbdm');
            avalonRoot.addTab({title:"报表预览",component:"test",sameCheck:true,params:{bbdm:bbdm}});
        },
        editGs:function(){
            var rowid=$("#bbwh-table").jqGrid("getGridParam","selrow");
            if(!rowid){
                tools.info('请先选择一行数据！');
                return ;
            }
            var bbdm=getCellData("bbwh-table",rowid,'bbdm');
            avalonRoot.addTab({title:"报表公式维护",component:"bbgs",sameCheck:true,params:{bbdm:bbdm}});
        },
        exform:function(){
            var self=this;
            if($('#bbwh-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            // form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/bjtssw/export/qyxx");
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