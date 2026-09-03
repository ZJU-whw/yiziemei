var tsxq=require("./tsxq.html");
var chart;
avalon.component('tsxq', {
    template:tsxq,
    defaults: {
        params:{},
        act:1,
        bbdm:"D01003",
        ckmygMc:"",
        searchData:{
            swjgdm:"",
            swjgMc:"",
            tjnd:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        tjndList:[],
        chartOption:{
            title : [{
                text: '退税需求情况统计',
                subtext: '单位：万美元',
                textStyle:{
                    fontSize:18
                },
                left:'middle',
                top:10,
                textAlign:"center"
            },],
            legend: {
                data: ['出口额-企业填报', '出口额-实际申报','免抵额-企业填报', '免抵额-实际申报','退税额-企业填报', '退税额-实际申报'],
                type:'scroll',
                pageButtonPosition:"start",
                x : 'center',
                y : 'bottom',
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
            tooltip: {
                trigger: 'axis'
            },
            color:["#3177FD","#F9D25D","#5BC97A","#4ECBC9","#E7A57C","#897FD0","#F5A623","#ec6d71","#89C3EB","#949495","#b88884","#93ca76","#cc7eb1"],
            xAxis: [
                {
                    type: 'category',
                    data: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
                    axisPointer: {
                        type: 'shadow'
                    }
                }
            ],
            yAxis: [
                {
                    type: 'value',
                },
            ],
            series : [
                {
                    name:'出口额-企业填报',
                    type:'line',
                    data:[

                    ]
                },
                {
                    name:'出口额-实际申报',
                    type:'line',
                    data:[

                    ]
                },{
                    name:'免抵额-企业填报',
                    type:'line',
                    data:[

                    ]
                },
                {
                    name:'免抵额-实际申报',
                    type:'line',
                    data:[

                    ]
                },{
                    name:'退税额-企业填报',
                    type:'line',
                    data:[

                    ]
                },
                {
                    name:'退税额-实际申报',
                    type:'line',
                    data:[

                    ]
                },
            ],
        },
        tableCol:[],
        tableArr:[
            { name: "tjyf", label: "月份", index: "tjyf",width: 50, align:"center",sortable: true },
            { name: "ckxse", label: "出口额", index: "ckxse",width: 90, align:"right",sortable: true },
            { name: "mde", label: "免抵额", index: "mde",width: 90, align:"right",sortable: true },
            { name: "tse", label: "退税额", index: "tse",width: 90, align:"right",sortable: true},
            { name: "ckhblv", label: "出口额环比(%)", index: "ckhblv",width: 90, align:"right",sortable: true },
            { name: "tshblv", label: "退税额环比(%)", index: "tshblv",width: 90, align:"right",sortable: true },
            { name: "jdtj_ksbcke", label: "可申报出口额", index: "jdtj_ksbcke",width: 90, align:"right",sortable: true },
            { name: "jdtj_sbcke", label: "申报出口额", index: "jdtj_sbcke",width: 90, align:"right",sortable: true},
            { name: "jdtj_mde", label: "申报免抵额", index: "jdtj_mde",width: 90, align:"right",sortable: true },
            { name: "jdtj_tse", label: "申报退税额", index: "jdtj_tse",width: 90, align:"right",sortable: true},
        ],
        onReady:function(){
            var self = this;

            this.searchData.tjnd=new Date().getFullYear();
            this.searchData.swjgdm=avalonRoot.user.swjgDm;
            this.searchData.swjgMc=avalonRoot.user.swjgMc;
            this.createTable(this.tableArr);
            this.initTree();
            this.tjndList=[];
            for(var i=0 ;i<5;i++){
                this.tjndList.push((this.searchData.tjnd + 1)-i)
            }
            //统计表初始化
            $('#tsxq-chart').width($('.tsxq').width()).height($('.tsxq .form').height());
            // self.chartOption.title.subtext="申报年月:"+self.searchData.ssny;
            chart = echarts.init(document.getElementById('tsxq-chart'));
            chart.setOption(tools.clone(self.chartOption));
        },
        changeTab:function(num){
            this.act=num;
        },
        fleshChart:function(data){
            var self=this;
            var ckbzData=[],tsbzData=[];
            var ckbzData2=[],tsbzData2=[];
            var ckbzData3=[],tsbzData3=[];
            for(var rowNum=0;rowNum<data.rows.length;rowNum++){
                var row=data.rows[rowNum];
                //此处0,2,5指对应的col的name
                ckbzData.push({value:row[self.tableArr[1].name],name:row[self.tableArr[0].name]})
                ckbzData2.push({value:row[self.tableArr[2].name],name:row[self.tableArr[0].name]})
                ckbzData3.push({value:row[self.tableArr[3].name],name:row[self.tableArr[0].name]})
                tsbzData.push({value:row[self.tableArr[7].name],name:row[self.tableArr[0].name]})
                tsbzData2.push({value:row[self.tableArr[8].name],name:row[self.tableArr[0].name]})
                tsbzData3.push({value:row[self.tableArr[9].name],name:row[self.tableArr[0].name]})
            }
            // ckbzData=tools.pieSelect(ckbzData,11);
            // tsbzData=tools.pieSelect(tsbzData,11);
            self.chartOption.series[0].data=tools.clone(ckbzData);
            self.chartOption.series[1].data=tools.clone(tsbzData);
            self.chartOption.series[2].data=tools.clone(ckbzData2);
            self.chartOption.series[3].data=tools.clone(tsbzData2);
            self.chartOption.series[4].data=tools.clone(ckbzData3);
            self.chartOption.series[5].data=tools.clone(tsbzData3);
            chart.setOption(tools.clone(self.chartOption));
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#tsxq-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#tsxq-tablePager',
                shrinkToFit: true,
                width:"100%",
                multiselect: false,
                // multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                footerrow:true,
                altclass: "altclasscss",
                lastsort: 1,
                // rowNum: -1,
                // pgbuttons: false,
                // pginput:false,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){ return $(".tsxq .form").height() -60-60;})(),
                gridComplete: function(){
                    // var data = self.data.rows;
                    // var len = data.length;
                    var sumData={}
                    for(var i=0;i<self.tableArr.length;i++){
                        if(i==2||i==5){
                            var sum=0;
                            $("#tsxq-table").getCol(self.tableArr[i].name,false).map(function(a){ sum+=(a.replace(/\,/g,'')-0)});
                            sumData[self.tableArr[i].name]=avalon.filters.number(sum,2);
                        }else{
                            sumData[self.tableArr[i].name]=""
                        }
                    }
                    sumData[self.tableArr[0].name]="当前页合计";
                    $("#tsxq-table").footerData('set', sumData);
                },
                onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"tsxq-table");
                    self.search(pageNo);
                }

            });
            $("#tsxq-table").jqGrid('setGroupHeaders', {
                useColSpanStyle: true,
                groupHeaders:[
                    {startColumnName:'ckxse', numberOfColumns:5, titleText: '企业填报数据'},
                    {startColumnName:'jdtj_ksbcke', numberOfColumns:4, titleText: '局端统计数据'},
                ]
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.tsxq')).val();
            $("#tsxq-table").setGridWidth($('.tsxq').width())
            // this.search(1);
        },normalSearch(){
            this.searchData.orderSql="";
            $('.s-ico').hide();
            this.search(1)
        },
        search:function(page){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.tsxq')).val() || 20;
            var params=tools.clone(this.searchData);
            params.pageNo=page;
            $("#tsxq-table").jqGrid('clearGridData');
            ajax("POST","/glfw/extra/tszbcs/tj/tsxqqk",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    $("#tsxq-table").resetSelection();
                    $("#tsxq-table")[0].addJSONData(res.data);
                    self.fleshChart(res.data)
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
        initTree:function() {
            var tree;
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.swjgDm = node.id;
                        self.searchData.swjgMc = node.text;
                        // console.log(tree.getCheckedNodes(true));
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.swjgDm = node.id;
                        self.searchData.swjgMc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                // check:{
                //     autoCheckTrigger: true,
                //     enable: true,
                //     chkStyle: "checkbox",
                //     nocheckInherit: false,
                //     chkDisabledInherit: false,
                //
                //     chkboxType: { "Y": "ps", "N": "ps" }
                // },
                data:{
                    key:{
                        children:"item",
                        name:"text"
                    }
                }
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($("#tsxqTree"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.tsxq').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }
            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.tsxq').off('click');
        },
        exform:function(){
            if($('#tsxq-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var self=this;
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/glfw/export/tszbcs/tj/tsxqqk");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
        $computed:{
            qylxMc:function(){
                var map = {
                    "1":"生产企业",
                    "2":"外贸企业",
                    "3":"外综服企业",
                }
                var arr = this.searchData.qylx.map(function(a){
                    return map[a];
                })
                var str = arr.join(',')
                this.searchData.qylxMc=str;
                return str;
            },
            spdlMc:function(){
                var xdtjMc = "";
                var self = this;
                $.each(this.spdl,function (index,item) {
                    if (self.searchData.spmlcode.indexOf(item.spml) > -1) {
                        xdtjMc += "," + item.mldm;
                    }
                })
                if (xdtjMc.length > 20) {
                    xdtjMc = xdtjMc.slice(1,20)
                } else {
                    xdtjMc = xdtjMc ? xdtjMc.slice(1) : "";
                }
                this.xdtjMc = xdtjMc;
                return xdtjMc
            },
            tslMc:function(){
                var xdtjMc = "";
                var self = this;
                $.each(this.searchData.tslcode,function (index,item) {
                    xdtjMc += "," + item + "%";
                });
                xdtjMc = xdtjMc ? xdtjMc.slice(1) : "";
                this.xdtjMc = xdtjMc;
                return xdtjMc
            }
        }
    }
});