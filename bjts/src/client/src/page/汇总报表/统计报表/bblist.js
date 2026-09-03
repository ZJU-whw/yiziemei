var bblist=require("./bblist.html");
avalon.component('bblist', {
    template:bblist,
    defaults: {
        params:{
            bbdm:"",
            bbmc:"",
            sublist:[]
        },
        pageTitle:["报表查询"],
        act:1,
        exClass:"",
        bbdm:"",
        actIndex:0,
        bbmc:"",
        sublist:[],
        timer:null,
        tzSwitch:false,
        searchData:{
            ssny:"",
            bbdm:"",
            bbmc:"",
            pageSize:config.pageSize,
        },
        tableArr:[],
        tableOption:[],
        tableData:{},
        onReady:function(){
            var self = this;
            this.exClass="bblist"+this.params.bbdm;
            self.pageTitle.push(self.params.bbmc);
            self.sublist=tools.clone(self.params.sublist);
            self.searchData.bbdm=self.params.sublist[0].bbdm;
            self.searchData.bbmc=self.params.sublist[0].bbmc;
            this.getTableRow();
            if(tools.getPreSwjgdm(avalonRoot.user.swjgDm).length<=5){
                self.tzSwitch=true;
            }
            $('.bblist .date-month').datepicker({
                dateFormat: 'yymm',
                changeMonth: true,
                changeYear: true
            }).on('change',self.filMon)
        },

        changeTab:function(num){
            this.act=num;
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "bbdm", label: "报表代码", index: "bbdm", width: 100, align:"center",sortable: false },
                { name: "bbmc", label: "报表名称", hidden:true,index: "bbmc", width: 180, align:"center",sortable: false },
                { name: "swjgdm", label: "税务机关代码", index: "swjgdm", sortable: true,align:"center", width: 100 ,},
                { name: "swjgmc", label: "税务机关名称", index: "swjgmc", sortable: true,align:"left", width: 200 ,},
                { name: "sbtime", label: "上报时间", index: "sbtime", sortable: true,align:"center", width: 100 ,},
                { name: "sbr", label: "上报人", index: "sbr", sortable: true,align:"center", width: 100 ,},
                { name: "", label:"操作", width:80, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(cellvalue, options, rowObject){
                    var str="<div class='btn openMx' style='float: none;display: inline-block;' title='查看'>查看</div>"
                    return str;
                }},
            ];
            self.createTable(tableArr);
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#bblist-table"+self.exClass).jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#bblist-tablePager'+self.exClass,
                shrinkToFit: true,
                width:"100%",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $("."+self.exClass+" .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var params ={
                            bbdm:getCellData("bblist-table"+self.exClass, rowid, 'bbdm'),
                            bbmc:self.searchData.bbmc,
                            bbid:"",
                            TZswitch:"0",
                            swjgdm:getCellData("bblist-table"+self.exClass, rowid, 'swjgdm'),
                            swjgmc:getCellData("bblist-table"+self.exClass, rowid, 'swjgmc'),
                            ssny:self.searchData.ssny,
                            clock:1
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
                    var pageNo=tools.getPageNo2(pgButton,"bblist-tablePager"+self.exClass);
                    self.search(pageNo);
                }

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.bblist.'+self.exClass)).val();
            self.search(1)
        },
        resetTable:function() {
            var self = this;
            for (var i = 0; i < self.tableOption.length; i++) {
                if (self.tableOption[i].show == true) {
                    $("#bblist-table"+self.exClass).showCol(self.tableOption[i].name)
                } else {
                    $("#bblist-table"+self.exClass).hideCol(self.tableOption[i].name)
                }
            }
            $("#bblist-table"+self.exClass).setGridWidth($('.bblist.'+self.exClass).width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.bblist.'+self.exClass)).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#bblist-table"+self.exClass).jqGrid('clearGridData')
            ajax("POST","/bjtssw/tjbb/recevMain",params).done(function(res){
                if(res.code=='0'){
                    $("#bblist-table"+self.exClass).resetSelection();
                    $("#bblist-table"+self.exClass)[0].addJSONData(res.data);
                    self.tableData=res.data;
                    if(res.data.rows.length>0){
                        self.searchData.ssny=res.data.rows[0].ssny;
                        $('#datepicker'+self.exClass).val(res.data.rows[0].ssny);
                    }
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        setbbdm:function(tcode,index,bbmc){
            this.searchData.bbdm=tcode;
            this.searchData.bbmc=bbmc||"";
            this.actIndex=index;
            this.search(1);
        },
        openMx:function(){
            var self=this;
            var rowid=$("#bblist-table").jqGrid("getGridParam","selrow");
            if(!self.searchData.ssny){
                tools.info("请输入报表年月!")
                return ;
            }
            var params={
                bbdm:self.searchData.bbdm,
                bbid:"",
                ssny:self.searchData.ssny,
                TZswitch:self.TZswitch,
                bbmc:self.searchData.bbmc,
                swjgdm:avalonRoot.user.swjgDm,
                swjgmc:avalonRoot.user.swjgMc,
            }
            params.pageTitle=tools.clone(self.pageTitle);
            params.pageTitle.push(params.bbmc);
            var bbcom=avalonRoot.getCom(params.bbdm);
            avalonRoot.addTab({title:"报表明细",tip:"报表明细-"+params.bbmc+"-"+params.swjgmc+"-"+params.ssny,component:bbcom,sameCheck:true,params:params});
        },
        filMon:function(e){
            var date=e.target.value;
            var res=tools.MonCheup(date);
            if(res===false){
                tools.info("申报年月输入错误");
                res="";
            }
            e.target.value=res;
            this.searchData.ssny=res;
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
            if($("#bblist-table"+self.exClass).jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            if(!self.searchData.ssny){
                tools.info("请输入报表年月!")
                return ;
            }
            var params = {
                bbdldm:self.searchData.bbdm.slice(0,3),
                ssny:self.searchData.ssny,
                swjgdm:avalonRoot.user.swjgDm,
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