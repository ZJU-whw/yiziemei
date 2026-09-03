var ddbd=require("./ddbd.html");
var chart;
avalon.component('ddbd', {
    template:ddbd,
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
                text: '订单变动情况统计',
                subtext: '单位：万美元',
                textStyle:{
                    fontSize:18
                },
                left:'middle',
                top:10,
                textAlign:"center"
            },],
            legend: {
                data: ['本年度订单总额', '上年同期订单总额'],
                type:'scroll',
                pageButtonPosition:"start",
                x : 'center',
                y : 'bottom',
            },
            tooltip: {
                trigger: 'axis'
            },
            color:["#3177FD","#F9D25D","#5BC97A","#4ECBC9","#E7A57C","#897FD0","#F5A623","#ec6d71","#89C3EB","#949495","#b88884","#93ca76","#cc7eb1"],
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
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
                    name:'本年度订单总额',
                    type:'line',
                    data:[

                    ]
                },
                {
                    name:'上年同期订单总额',
                    type:'line',
                    data:[

                    ]
                }
            ],
        },
        tableCol:[],
        tableArr:[
            { name: "tjyf", label: "月份", index: "tjyf",width: 50, align:"center",sortable: true },
            { name: "lsdd", label: "流失订单", index: "lsdd",width: 90, align:"right",sortable: true },
            { name: "xjdd", label: "新接订单", index: "xjdd",width: 90, align:"right",sortable: true},
            { name: "zhfhdd", label: "暂缓发货订单", index: "zhfhdd",width: 90, align:"right",sortable: true },
            { name: "hhfhdd", label: "恢复发货订单", index: "hhfhdd",width: 90, align:"right",sortable: true },
            { name: "ddze", label: "订单总额", index: "ddze",width: 90, align:"right",sortable: true },
            { name: "sndtqdd", label: "订单总额(上年同期)", index: "sndtqdd",width: 130, align:"right",sortable: true},
            { name: "yckdd", label: "已出口订单", index: "yckdd",width: 90, align:"right",sortable: true },
            { name: "sjzhfhdd", label: "实际暂缓发货订单", index: "sjzhfhdd",width: 90, align:"right",sortable: true},
            { name: "yjqnzjf", label: "预计全年增/降幅(%)", index: "yjqnzjf",width: 110, align:"center",sortable: true },
            // { name: "", label: "企业困难与建议", index: "",width: 80, align:"left",sortable: true },
        ],
        onReady:function(){
            var self = this;

            this.initTree();
            this.searchData.swjgdm=avalonRoot.user.swjgDm;
            this.searchData.swjgMc=avalonRoot.user.swjgMc;
            this.searchData.tjnd=new Date().getFullYear();
            this.createTable(this.tableArr);
            this.tjndList=[];
            for(var i=0 ;i<5;i++){
                this.tjndList.push((this.searchData.tjnd + 1)-i)
            }
            //统计表初始化
            $('#ddbd-chart').width($('.ddbd').width()).height($('.ddbd .form').height());
            // self.chartOption.title.subtext="申报年月:"+self.searchData.ssny;
            chart = echarts.init(document.getElementById('ddbd-chart'));
            chart.setOption(tools.clone(self.chartOption));
        },
        changeTab:function(num){
            this.act=num;
        },
        fleshChart:function(data){
            var self=this;
            var ckbzData=[],tsbzData=[];
            for(var rowNum=0;rowNum<data.rows.length;rowNum++){
                var row=data.rows[rowNum];
                //此处0,2,5指对应的col的name
                ckbzData.push({value:row[self.tableArr[5].name],name:row[self.tableArr[0].name]})
                tsbzData.push({value:row[self.tableArr[6].name],name:row[self.tableArr[0].name]})
            }
            // ckbzData=tools.pieSelect(ckbzData,11);
            // tsbzData=tools.pieSelect(tsbzData,11);
            self.chartOption.series[0].data=tools.clone(ckbzData);
            self.chartOption.series[1].data=tools.clone(tsbzData);
            chart.setOption(tools.clone(self.chartOption));
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#ddbd-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#ddbd-tablePager',
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
                height:(function(){ return $(".ddbd .form").height() -60-30;})(),
                gridComplete: function(){
                    // var data = self.data.rows;
                    // var len = data.length;
                    var sumData={}
                    for(var i=0;i<self.tableArr.length;i++){
                        if(i==2||i==5){
                            var sum=0;
                            $("#ddbd-table").getCol(self.tableArr[i].name,false).map(function(a){ sum+=(a.replace(/\,/g,'')-0)});
                            sumData[self.tableArr[i].name]=avalon.filters.number(sum,2);
                        }else{
                            sumData[self.tableArr[i].name]=""
                        }
                    }
                    sumData[self.tableArr[0].name]="当前页合计";
                    $("#ddbd-table").footerData('set', sumData);
                },
                onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"ddbd-table");
                    self.search(pageNo);
                }

            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.ddbd')).val();
            $("#ddbd-table").setGridWidth($('.ddbd').width())
            // this.search(1);
        },normalSearch(){
            this.searchData.orderSql="";
            $('.s-ico').hide();
            this.search(1)
        },
        search:function(page){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.ddbd')).val() || 20;
            var params=tools.clone(this.searchData);
            params.pageNo=page
            $("#ddbd-table").jqGrid('clearGridData')
            ajax("POST","/glfw/extra/tszbcs/tj/ddbdqk",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    $("#ddbd-table").resetSelection();
                    $("#ddbd-table")[0].addJSONData(res.data);
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
                        self.searchData.swjgdm = node.id;
                        self.searchData.swjgMc = node.text;
                        // console.log(tree.getCheckedNodes(true));
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.swjgdm = node.id;
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
                $.fn.zTree.init($("#ddbdTree"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.ddbd').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.ddbd').off('click');
        },
        exform:function(){
            if($('#ddbd-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var self=this;
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("method", "post");
            form.attr("action", "/glfw/export/tszbcs/tj/ddbdqk");
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