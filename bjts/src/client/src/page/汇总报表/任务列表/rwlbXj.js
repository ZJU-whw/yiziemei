var rwlbXj=require("./rwlbXj.html");
avalon.component('rwlbXj', {
    template:rwlbXj,
    defaults: {
        params:{
            bbdldm:"",
            bbdlmc:"",
            ny:"",
            pageTitle:[]
        },
        pageTitle:[],
        swjgmc:"",
        TZswitch:"",
        bbdlmc:"",
        exClass:"",
        act:1,
        tcode:"pfxx",
        searchData:{
            bbdldm:"",
            ssny:"",
            orderSql:"zbtime desc",
            pageSize:config.pageSize,
        },
        timer:null,
        tableData:{},

        onReady:function(){
            var self = this;
            this.searchData.bbdldm=this.params.bbdldm;
            this.searchData.ssny=this.params.ny;
            this.exClass="rwlbXj"+this.params.bbdldm;
            this.bbdlmc=this.params.bbdlmc;
            this.TZswitch=this.params.TZswitch;
            this.pageTitle=tools.clone(this.params.pageTitle);
            this.swjgmc=avalonRoot.user.swjgMc;

            this.getTableRow();
        },

        changeTab:function(num){
            this.act=num;
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "swjgdm", label: "税务机关", index: "swjgdm", width: 100, align:"center",sortable: false },
                { name: "swjgmc", label: "税务机关简称", index: "swjgmc", width: 200, align:"left",sortable: false },
                { name: "status", label: "状态", index: "status",width: 100, align:"center",sortable: false },
                { name: "cjtime", label: "创建时间", index: "cjtime",width: 100, align:"center",sortable: false },
                { name: "zbtime", label: "制表时间", index: "zbtime", sortable: true,align:"center", width: 100 ,},
                { name: "sbtime", label: "上报时间", index: "sbtime", sortable: true,align:"center", width: 100 ,},
                { name: "", label:"操作", width:100, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(cellvalue, options, rowObject){
                    var str="";
                    if(rowObject.status=='上报'){
                        str+= "<div class='btn ch' style='float: none;display: inline-block;' title='撤回'>撤回</div>"
                        str+= "<div class='btn openMx' style='float: none;display: inline-block;' title='查看'>查看</div>"
                    }
                    else{
                        str+= "<div class='btn disabled' style='float: none;display: inline-block;' title='撤回'>撤回</div>"
                        str+= "<div class='btn disabled' style='float: none;display: inline-block;' title='查看'>查看</div>"
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
            $("#rwlbXj-table"+self.exClass).jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#rwlbXj-tablePager'+self.exClass,
                shrinkToFit: true,
                width:"100%",
                // multiselect: true,
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
                    if($(e.target).hasClass('openMx')){

                        var params ={
                            bbdldm:self.searchData.bbdldm,
                            bbdlmc:self.bbdlmc,
                            ny:self.searchData.ssny,
                            swjgdm:getCellData("rwlbXj-table"+self.exClass, rowid, 'swjgdm'),
                            swjgmc:getCellData("rwlbXj-table"+self.exClass, rowid, 'swjgmc'),
                            TZswitch:0,
                        }
                        params.pageTitle=tools.clone(self.pageTitle);
                        params.pageTitle.push(params.bbdlmc)
                        avalonRoot.addTab({title:params.bbdlmc,tip:params.bbdlmc+'-'+params.swjgmc,component:"rwlbMx",sameCheck:true,params:params});
                        return false;
                    }else if($(e.target).hasClass('ch')){
                        var b = getCellData("rwlbXj-table"+self.exClass, rowid, 'swjgdm')
                        self.dzch(b);
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
                    var pageNo=tools.getPageNo2(pgButton,"rwlbXj-tablePager"+self.exClass);
                    self.search(pageNo);
                },
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.'+self.exClass+'')).val();
            self.search(1)
        },
        resetTable:function() {
            var self = this;
            $("#rwlbXj-table"+self.exClass).setGridWidth($('.'+self.exClass+'').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.'+self.exClass+'')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#rwlbXj-table"+self.exClass).jqGrid('clearGridData')
            ajax("POST","/bjtssw/tjbb/task/recivelist",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    $("#rwlbXj-table"+self.exClass)[0].addJSONData(res.data);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        dzch:function(swjgdm){
            var self=this;
            var params={
                bbdldm:self.searchData.bbdldm,
                ssny:self.searchData.ssny,
                swjgdm:swjgdm
            }
            ajax("post","/bjtssw/tjbb/task/reciveback",params).done(function(res){
                if(res.code=='0'){
                    self.search(1)
                }else{
                    tools.info(res.msg)
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
    }
});