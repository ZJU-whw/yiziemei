var virtualRwlbMx=require("./virtualRwlbMx.html");
avalon.component('virtualRwlbMx', {
    template:virtualRwlbMx,
    defaults: {
        params:{
            bbdldm:"",
            bbdlmc:"",
            ny:"",
            TZswitch:"",
            swjgmc:"",
            swjgdm:""
        },
        pageTitle:[],
        bbdlmc:"",
        exClass:"",
        TZswitch:"",
        swjgmc:"",
        swjgdm:"",
        act:1,
        tbFlag:false,
        tcode:"pfxx",
        searchData:{
            bbdldm:"",
            ssny:"",
            orderSql:"hztime desc",
            pageSize:config.pageSize,
        },
        timer:null,
        tableData:{},

        onReady:function(){
            this.searchData.bbdldm=this.params.bbdldm;
            this.searchData.ssny=this.params.ny;
            this.exClass="virtualRwlbMx"+this.params.bbdldm+this.params.ny+this.params.swjgdm;
            this.bbdlmc=this.params.bbdlmc;
            this.TZswitch=this.params.TZswitch;
            this.swjgmc=this.params.swjgmc;
            this.swjgdm=this.params.swjgdm;
            this.pageTitle=tools.clone(this.params.pageTitle);
            this.getTableRow();
            this.checkTbFlag();
        },
        onInit:function(e){
            virtualRwlbMx = e.vmodel;
        },
        changeTab:function(num){
            this.act=num;
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "bbdm", label: "报表代码", index: "bbdm", width: 100, align:"center",sortable: false },
                { name: "bbmc", label: "报表名称", index: "bbmc", sortable: true,align:"left", width: 200 },
                { name: "hztime", label: "汇总时间", index: "hztime", sortable: true,align:"center", width: 150 ,},
                { name: "xgtime", label: "调整时间", index: "xgtime", sortable: true,align:"center", width: 150 ,},
                { name: "bbid", label: "调整时间", index: "bbid", hidden: true,align:"center", width: 150 ,},
                { name: "ishz", label: "汇总状态", index: "ishz", sortable: true,align:"center", width: 150 ,formatter:function(cellvalue, options, rowObject){
                    if(cellvalue=='1'){
                        return "√"
                    }else{
                        return ""
                    }
                }},
                { name: "isxg", label: "调整状态", index: "isxg", sortable: true,align:"center", width: 150 ,formatter:function(cellvalue, options, rowObject){
                        if(cellvalue=='1'){
                            return "√"
                        }else{
                            return ""
                        }
                    }},
                { name: "", label:"操作", width:90, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(cellvalue, options, rowObject){
                    if(self.TZswitch=='1'){
                        var str= "<div class='btn tz' style='float: none;display: inline-block;' title='编辑'>编辑</div>"
                    }else{
                        var str= "<div class='btn tz' style='float: none;display: inline-block;' title='查看'>查看</div>"
                    }

                    return str;
                }},
            ]
            self.createTable(tableArr)
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#virtualRwlbMx-table"+self.exClass).jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#virtualRwlbMx-tablePager'+self.exClass,
                shrinkToFit: true,
                width:"100%",
                multiselect: false,
                // multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $('.'+self.exClass+' .form').height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('tz')){
                        var params={
                            bbdm:getCellData("virtualRwlbMx-table"+self.exClass, rowid, 'bbdm'),
                            bbid:getCellData("virtualRwlbMx-table"+self.exClass, rowid, 'bbid'),
                            ssny:self.searchData.ssny,
                            TZswitch:self.TZswitch,
                            bbmc:getCellData("virtualRwlbMx-table"+self.exClass, rowid, 'bbmc'),
                            swjgdm:self.swjgdm,
                            swjgmc:self.swjgmc,
                        }
                        params.pageTitle=tools.clone(self.pageTitle);
                        params.pageTitle.push(params.bbmc);
                        var bbcom=avalonRoot.getCom(params.bbdm);
                        avalonRoot.addTab({title:"报表明细",tip:"报表明细-"+params.bbmc+"-"+params.swjgmc+"-"+params.ssny,component:bbcom,sameCheck:true,params:params});
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
                    var pageNo=tools.getPageNo2(pgButton,"virtualRwlbMx-tablePager"+self.exClass);
                    self.search(pageNo);
                },
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.'+self.exClass+'')).val();
            self.search(1)
        },
        resetTable:function() {
            var self = this;
            $("#virtualRwlbMx-table"+self.exClass).setGridWidth($('.'+self.exClass+'').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.'+self.exClass+'')).val();
            if(!this.searchData.pageSize){return ;}
            var params=tools.clone(self.searchData);
            params.swjgDm=self.swjgdm;
            params.pageNo=pageNo
            $("#virtualRwlbMx-table"+self.exClass).jqGrid('clearGridData')
            ajax("POST","/bjtssw/tjbb/task/sublist",params).done(function(res){
                if(res.code=='0'){
                    $("#virtualRwlbMx-table"+self.exClass)[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        checkTbFlag:function(){
            var self=this;
            if(self.swjgdm==avalonRoot.user.swjgDm){
                self.tbFlag=true;
            }else{
                self.tbFlag=false;
            }
        },
        bbtj:function(){
            var self=this;
            var incode=[]
            var rowids=$("#virtualRwlbMx-table"+self.exClass).jqGrid("getGridParam", "selarrrow");
            for (var i = 0; i < rowids.length; i++) {
                var b = getCellData("virtualRwlbMx-table"+self.exClass, rowids[i], 'bbdm');
                incode.push(b);
            }
            if(incode.length<=0){
                tools.info("请至少选择一条记录！");
                return false;
            }
            var params={
                bbdldm:self.params.bbdldm,
                bbdm:incode.join(','),
                ssny:self.searchData.ssny
            }
            ajax("POST","/bjtssw/tjbb/task/cxmake",params).done(function(res){
                if(res.code=='0'){
                    tools.info("操作成功");
                    self.search(1)
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        bbcj:function(){
            var self=this;
            var params={
                bbdldm:self.params.bbdldm
            }
            ajax("POST","/bjtssw/tjbb/task/cxmake/hz",params).done(function(res){
                if(res.code=='0'){
                    tools.info("操作成功");
                    self.search(1)
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
        showMenu:function(e){
            var self=this;
            $(".dropdown-menu",e.target).show();
            $('.'+self.exClass).on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }
            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.'+self.exClass).off('click');
        },
        exTable:function(type){
            var self=this;
            if($("#virtualRwlbMx-table"+self.exClass).jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = {
                bbdldm:self.searchData.bbdldm,
                ssny:self.searchData.ssny,
                swjgdm:self.swjgdm,
                type:type
            }
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/bjtssw/tjbb/saveSuitExcel");
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
});