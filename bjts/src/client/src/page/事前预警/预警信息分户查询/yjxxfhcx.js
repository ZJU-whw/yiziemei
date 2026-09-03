var yjxxfhcx=require("./yjxxfhcx.html");
avalon.component('yjxxfhcx', {
    template:yjxxfhcx,
    defaults: {
        params:{
            nsrsbh:"",
            pgFlag:"",
        },
        exClass:"",
        act:1,
        yjList:[],
        zbList:[],
        tcode:"pfxx",
        searchData:{
            nsrsbh:"",
            yjcode:"",
            zbcode:"",
            clFlag:"",
            yjObject:"",
            yjAmtStart:"",
            yjAmtEnd:"",
            bz:"",
            orderSql:"cl_date desc",
            pageSize:config.pageSize,
        },
        formData:{
            scoreTotal:"",
            qyhgdm:"",
            nsrmc:"",
            nsrsbh:"",
            swjgDm:"",
            tsjsfsDm:"",
            tsjsfsZh:"",
            flgldj:"",
            bsyMc:"",
            bsyDh:"",
            fddbrmc:"",
            frdhhm:"",
        },
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{},
        swjgDm:"",
        swjgMc:"",
        pgFlag:false,
        onReady:function(){
            this.searchData.nsrsbh=this.params.nsrsbh;
            this.exClass="yjxxfhcx"+this.params.nsrsbh;
            this.pgFlag=this.params.pgFlag||false;
            if(this.pgFlag==true){
                this.searchData.clFlag="0"
            }
            var self = this;
            this.getTableRow();
            this.initPfxx();
            // self.initTree();
            $('.'+self.exClass+' .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.'+self.exClass+' .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });

            self.initYjList();

        },

        changeTab:function(num){
            this.act=num;
        },
        initPfxx:function(){
            var self=this;
            ajax("POST","/bjtssw/yj/pfxx/view",{nsrsbh:self.params.nsrsbh}).done(function(res){
                if(res.code=='0'){
                    self.formData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        initYjList:function(){
            var self=this;
            ajax("POST","/bjtssw/yj/yjzb",{}).done(function(res){
                if(res.code=="0"){
                    self.yjList=res.data;
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        setZbList:function(e){
            var target=e.target;
            var yjcode=$(target)[0].value;
            var self=this;
            self.searchData.zbcode="";
            if(yjcode==""){
                self.zbList=[];
                return ;
            }

            for(var i=0;i<self.yjList.length;i++){
                if(yjcode==self.yjList[i].yjcode){
                    self.zbList=self.yjList[i].yjzb||[];
                    return ;
                }
            }
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            ajax("POST","/bjtssw/basis/columprofile",{tcode:self.tcode}).done(function(res){
                if(res.code=="0"){
                    var arr=res.data.profiles;
                    var tableArr=[];
                    var tableOption=[];
                    for(var i=0;i<arr.length;i++){
                        var obj={
                            name: arr[i].t_c_code,
                            label: arr[i].t_c_name,
                            index: arr[i].t_c_code,
                            sortable: arr[i].is_order==0?false:true,
                            hidden:false,
                            width: arr[i].c_std_size ,
                            align:arr[i].align==0?"left":arr[i].align==1?"center":"right",
                        }
                        if(obj.name=='yjAmt'||obj.name=='yjTax'){
                            obj.formatter=function(cellvalue, options, rowObject){
                                return avalon.filters.number(cellvalue,2);
                            }
                        }
                        if(arr[i].degree){
                            var degree=arr[i].degree
                            obj.formatter=function(cellvalue, options, rowObject){
                                return avalon.filters.number(cellvalue,degree);
                            }
                        }
                        tableArr.push(obj)
                        if(arr[i].is_fixed=='0'){
                            tableOption.push({
                                name: arr[i].t_c_code,
                                label: arr[i].t_c_name,
                                show:false
                            })
                        }
                    }
                    self.tableArr=tableArr;
                    self.tableOption=tableOption;
                    if(tableArr.length>0){
                        self.createTable(tableArr)
                    };
                    var selected=res.data.select.split(",")
                    for(var j=0;j<selected.length;j++){
                        var name=selected[j]
                        for(var k=0;k<self.tableOption.length;k++){
                            if(name==self.tableOption[k].name){
                                self.tableOption[k].show=true;
                            }
                        }
                    }
                    self.resetTable();
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        reset: function() {
            var self=this;
            self.searchData={
                nsrsbh:self.params.nsrsbh,
                yjcode:"",
                zbcode:"",
                clFlag:"",
                yjObject:"",
                yjAmtStart:"",
                yjAmtEnd:"",
                bz:"",
                orderSql:"cl_date desc",
                pageSize:config.pageSize,
            }
            if(this.pgFlag==true){
                this.searchData.clFlag="0"
            }
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#yjxxfhcx-table"+self.exClass).jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#yjxxfhcx-tablePager'+self.exClass,
                shrinkToFit: false,
                width:"100%",
                // multiselect: true,
                // multiselectWidth:"30",
                autowidth:false,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $('.'+self.exClass+' .form').height() -210;
                })(),
                beforeSelectRow:function(rowid,e){
                   if(e.target.nodeName=="TD"){
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
                    var pageNo=tools.getPageNo2(pgButton,"yjxxfhcx-tablePager"+self.exClass);
                    self.search(pageNo);
                },
                // footerrow:true,
                // gridComplete: function(){
                //     var data = self.data.rows;
                //     var len = data.length;
                //     var sum_tseSb = 0;
                //     var sum_tseSh = 0;
                //     var sum_tseSp = 0;
                //     var sum_tseTk = 0;
                //     var sum_tseBy = 0;
                //     var sum_tseZh = 0;
                //     var sum_qycnt=0;
                //     $("#wdzxx-table").getCol('qycnt',false).map(function(a){ sum_qycnt+=(a.replace(',','')-0)});
                //     $("#wdzxx-table").footerData('set', { "ny": '合计',qycnt: sum_qycnt,tseSb: sum_tseSb,tseSh: sum_tseSh,tseSp: sum_tseSp,tseTk: sum_tseTk,tseBy: sum_tseBy,tseZh: sum_tseZh,"cz":"" });
                // },

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.'+self.exClass+'')).val();
            self.search(1)
        },
        setTableOption:function(){
            var self=this;
            setTimeout(function(){
                self.resetTable();
            },200);
            if(self.timer==null){
                self.timer=setTimeout(function(){
                    self.updataOption();
                    clearTimeout(self.timer);
                    self.timer=null;
                },2000)
            }else{
                clearTimeout(self.timer);
                self.timer=setTimeout(function(){
                    self.updataOption();
                    clearTimeout(self.timer);
                    self.timer=null;
                },2000)
            }
        },
        updataOption:function(){
            var self=this;
            var cs=[];
            for(var i=0;i<self.tableOption.length;i++){
                if(self.tableOption[i].show==true){
                    cs.push(self.tableOption[i].name)
                }
            }
            var params={
                tcode:this.tcode,
                cs:cs.join(',')
            }
            ajax("POST","/bjtssw/basis/columprofile/update",params).done(function(res){
                if(res.code!='0'){
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        resetTable:function() {
            var self = this;
            for (var i = 0; i < self.tableOption.length; i++) {
                if (self.tableOption[i].show == true) {
                    $("#yjxxfhcx-table"+self.exClass).showCol(self.tableOption[i].name)
                } else {
                    $("#yjxxfhcx-table"+self.exClass).hideCol(self.tableOption[i].name)
                }
            }
            $("#yjxxfhcx-table"+self.exClass).setGridWidth($('.'+self.exClass+'').width())
        },
        search:function(pageNo){
            var self=this;
            var params=tools.clone(self.searchData);
            params.pageSize = $(".ui-pg-selbox", $('.'+self.exClass+'')).val();
            params.pageNo=pageNo
            $("#yjxxfhcx-table"+self.exClass).jqGrid('clearGridData')
            ajax("POST","/bjtssw/yj/pfxx/list",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    $("#yjxxfhcx-table"+self.exClass)[0].addJSONData(res.data);
                    self.closeHyper();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
            this.initPfxx();
        },
        yjClear:function(){
            var self=this;
            var params={nsrsbh:self.searchData.nsrsbh}
            ajax("POST","/bjtssw/yj/pfxx/reset",params).done(function(res){
                if(res.code=='0'){
                    tools.info("操作成功！")
                    self.search(1)
                    self.initPfxx()
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        showHyper:function(){
            var self=this;
            $('.'+self.exClass+' .select-sub').toggle();
            $('.'+self.exClass+' .select-wrapper .icon').toggleClass("active");
            if ($('.'+self.exClass+' .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.'+self.exClass+' .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.'+self.exClass+' .select-wrapper .icon').attr("title","展开查询条件")
            }
        },
        closeHyper:function(){
            var self=this;
            $('.'+self.exClass+' .select-sub').hide();
            $('.'+self.exClass+' .select-wrapper .icon').removeClass('active');
            $('.'+self.exClass+' .select-wrapper .icon').attr("title","展开查询条件");
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
        filNum2:function(e){
            var date=e.target.value;
            e.target.value=date?avalon.filters.number(date,2):"";
            return false;
        },
        showMenu:function(e){
            var self=this;
            $(".dropdown-menu",e.target).show();
            $('.'+self.exClass+'').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.'+self.exClass+'').off('click');
        },

        //copy
        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.tsjg = node.id;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.tsjg = node.id;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            var setting2 = {
                callback:{
                    onClick:function(e,id,node){
                        self.swjgDm = node.id;
                        self.swjgMc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.swjgDm = node.id;
                        self.swjgMc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };

            ajax("POST","/cxfw/export/readtree", {nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($(".yjxxfhcx .treeDiv"), setting, res.data);
                    $.fn.zTree.init($(".yjxxfhcx .treeDiv2"), setting2, res.data);
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.'+self.exClass+'').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        showSwjg:function(e){
            var self=this;
            $(".treeDiv2",$(e.target)).show();
            $('body').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv2').find($(e.target)).length<=0){
                    self.hideSwjg();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.'+self.exClass+'').off('click');
        },
        hideSwjg:function(){
            $(".treeDiv2").hide();
            $('.body').off('click');
        },
        exform:function(){
            var self=this;
            if($("#yjxxfhcx-table"+self.exClass).jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            // form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/bjtssw/yj/pfxx/export");
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