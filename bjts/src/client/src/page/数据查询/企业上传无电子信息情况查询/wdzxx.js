var wdzxx=require("./wdzxx.html");
avalon.component('wdzxx', {
    template:wdzxx,
    defaults: {
        params:{},
        act:1,
        tcode:"scwdzxx",
        searchData:{
            swjgdm:"",
            swjgmc:"",
            sbrqq:"",
            sbrqz:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{},
        setData:{
            zczt:"",
            ktpt:""
        },
        onReady:function(){
            try {
                this.searchData.swjgdm=avalonRoot.user.swjgDm;
                this.searchData.swjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

            }
            var self = this;
            this.getTableRow();
            self.initTree();
            $('.wdzxx .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.wdzxx .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });

        },
        changeTab:function(num){
            this.act=num;
        },
        creatChart:function(){
            echarts.init($('.wdzxx .chartDiv')[0]).setOption({
                title: {
                    text: '天气情况统计',
                    subtext: '虚构数据',
                    left: 'center'
                },
                tooltip : {
                    trigger: 'item',
                    formatter: "{a} <br/>{b} : {c} ({d}%)"
                },
                legend: {
                    // orient: 'vertical',
                    // top: 'middle',
                    bottom: 10,
                    left: 'center',
                    data: ['西凉', '益州','兖州','荆州','幽州']
                },
                series : [
                    {
                        type: 'pie',
                        radius : '65%',
                        center: ['50%', '50%'],
                        selectedMode: 'single',
                        data:[
                            {
                                value:1548,
                                name: '幽州',
                            },
                            {value:535, name: '荆州'},
                            {value:510, name: '兖州'},
                            {value:634, name: '益州'},
                            {value:735, name: '西凉'}
                        ],
                        itemStyle: {
                            emphasis: {
                                shadowBlur: 10,
                                shadowOffsetX: 0,
                                shadowColor: 'rgba(0, 0, 0, 0.5)'
                            }
                        }
                    }
                ]
            })
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
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#wdzxx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#wdzxx-tablePager',
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
                height:(function(){
                    return $(".wdzxx .form").height() -100;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var b = getCellData("wdzxx-table", rowid, 'taxpayerCode')
                        avalonRoot.addTab({title:"进料加工手册核销明细",component:"wdzxxMx",sameCheck:false,params:{lcslid:self.tableData.rows[rowid-1].lcslid}});
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
                    var pageNo=tools.getPageNo(pgButton,"wdzxx-table");
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
            this.searchData.pageSize = $(".ui-pg-selbox", $('.wdzxx')).val();
            // self.search(1)
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
                    $("#wdzxx-table").showCol(self.tableOption[i].name)
                } else {
                    $("#wdzxx-table").hideCol(self.tableOption[i].name)
                }
            }
            $("#wdzxx-table").setGridWidth($('.wdzxx').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.wdzxx')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#wdzxx-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/search/scwdzxx",params).done(function(res){
                if(res.code=='0'){
                    $("#wdzxx-table").resetSelection();
                    $("#wdzxx-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },

        showHyper:function(){
            $('.wdzxx .hyper').toggle();
            $('.wdzxx .hyperBtn').toggleClass('active');
        },
        closeHyper:function(){
            $('.wdzxx .hyper').hide();
            $('.wdzxx .hyperBtn').removeClass('active');
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
        showMenu:function(e){
            var self=this;
            $(".dropdown-menu",e.target).show();
            $('.wdzxx').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.wdzxx').off('click');
        },

        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.swjgdm = node.id;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.swjgdm = node.id;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".wdzxx .treeDiv"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.wdzxx').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.wdzxx').off('click');
        },
        exform:function(){
            var self=this;
            if($('#wdzxx-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/cxfw/export/scwdzxx");
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