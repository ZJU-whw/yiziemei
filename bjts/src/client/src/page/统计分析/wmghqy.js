var wmghqy=require("./wmghqy.html");
var chart;
var data1=[],data2=[];
avalon.component('wmghqy', {
    template:wmghqy,
    defaults: {
        params:{},
        act:1,
        spdl:[],
        slArray:["16","15","13","10","9","6","5","0"],
        mapIdx:{
            "china":"china",
            "安徽":"01",
            "澳门":"02",
            "北京":"03",
            "福建":"04",
            "甘肃":"05",
            "广东":"06",
            "广西":"07",
            "贵州":"08",
            "海南":"09",
            "河北":"10",
            "河南":"11",
            "黑龙江":"12",
            "湖北":"13",
            "湖南":"14",
            "吉林":"15",
            "江苏":"16",
            "江西":"17",
            "辽宁":"18",
            "内蒙古":"19",
            "宁夏":"20",
            "青海":"21",
            "山东":"22",
            "山西":"23",
            "陕西":"24",
            "上海":"25",
            "四川":"26",
            "天津":"27",
            "西藏":"28",
            "香港":"29",
            "新疆":"30",
            "云南":"31",
            "浙江":"32",
            "重庆":"33"
        },
        mapType:"china",
        xdtjMc: "",
        searchData:{
            refresh:'N',
            swjgDm:"",
            swjgMc:"",
            tjlx:"1",
            pmlx:"1",
            qylx:["2"],
            qyhgdm:"",
            cksjStart:"",
            cksjEnd:"",
            gbcode:[],
            dqcode:[],
            tslcode:[],
            spmlcode:[],
            pageSize:'1000'
        },
        chartOption:{
            tooltip:{
                trigger: 'item',
                formatter: function(params){
                    if(params.dataIndex<0){return ;}
                    var str="";
                    str+=params.name;
                    str+="<br>"
                    str+="累计进货额：";
                    str+=data1[params.dataIndex].value?data1[params.dataIndex].value:0;
                    str+="<br>";
                    str+="累计退税额：";
                    str+=data2[params.dataIndex].value?data2[params.dataIndex].value:0;
                    return str
                }
            },
            visualMap: {
                min: 0,
                max: 0,
                show:true,
                left: '10%',
                top: 'bottom',
                text:['高','低'],           // 文本，默认为数值文本
                inRange: {
                    color: ['#e0ffff', '#006edd']
                },
                calculable : true
            },
            title : [{
                text: '外贸供货企业分析',
                subtext: '进货额单位：元，退税额单位：元',
                textStyle:{
                    fontSize:18
                },
                left:'middle',
                top:'top',
                textAlign:"center"
            }
            ],
            series : [
                {
                    name: '累计进货额',
                    type: 'map',
                    mapType: 'china',
                    roam: false,
                    label:{
                        normal:{
                            show:true,

                        }
                    },
                    data:[]
                },
                {
                    name: '累计退税额',
                    type: 'map',
                    mapType: 'china',
                    roam: false,
                    label:{
                        normal:{
                            show:true,

                        }
                    },
                    data:[]
                },
            ]
        },
        tableCol:[],
        tableArr:[
            { name: "", label: "供货企业区域", index: "",hidden:false, sortable: false,align:"center", width: 150,formatter:function(cellvalue, options, rowObject){
                if(rowObject.JHAMT_ZB){
                    if(rowObject.XZQH.length==2){
                        return "<span style='color:#0000ff;float:left;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>";
                    }else{
                        return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>";
                    }
                }else{
                    if(rowObject.XZQH.length==2){
                        return "<span style='float: left'>"+cellvalue+"</span>"
                    }else{
                        return "<span>"+cellvalue+"</span>"
                    }
                }
                }},
            { name: "", label: "累计进货额(元)", index: "",hidden:false, sortable: false,align:"center", width: 150,formatter:function(cellvalue, options, rowObject){
                    return avalon.filters.number(cellvalue,2);
                }},
            { name: "", label: "占比", index: "",hidden:false, sortable: false,align:"center", width: 150,},
            { name: "", label: "同比", index: "",hidden:false, sortable: false,align:"center", width: 150,},
            { name: "", label: "累计退税额(元)", index: "",hidden:false, sortable: false,align:"center", width: 150,formatter:function(cellvalue, options, rowObject){
                    return avalon.filters.number(cellvalue,2);
                }},
            { name: "", label: "占比", index: "",hidden:false, sortable: false,align:"center", width: 150,},
            { name: "", label: "同比", index: "",hidden:false, sortable: false,align:"center", width: 150,},
            { name: "XZQH", label: "行政区划", index: "XZQH",hidden:true,},
        ],
        onReady:function(){
            var self = this;
            $('.wmghqy .select-sub').show();
            this.getTableCol();
            this.getSpdl();
            this.initTree();
            this.initTree2();
            try {
                this.searchData.swjgDm=avalonRoot.user.swjgDm;
                this.searchData.swjgMc=avalonRoot.user.swjgMc;
                this.searchData.qylxMc = "生产企业,外贸企业,外综服企业";
                this.searchData.cksjStart = tools.getToday();
                this.searchData.cksjEnd = tools.getToday();
            } catch (e) {
            }
            $('.wmghqy .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('#wmghqy-chart').width($('.wmghqy').width()).height($('.wmghqy .form').height());
            chart = echarts.init(document.getElementById('wmghqy-chart'));
            ajax('GET','static/map/'+self.mapIdx[self.mapType]+'.json').done(function (res) {
                echarts.registerMap(self.mapType, res);
                chart.setOption(tools.clone(self.chartOption));
            }).fail(function(err){
                tools.info(err);
            })
            //统计表初始化
            // $('#wmghqy-chart').width($('.wmghqy').width()).height($('.wmghqy .form').height());
            // self.chartOption.title.subtext="申报年月:"+self.searchData.ssny;
            // chart = echarts.init(document.getElementById('wmghqy-chart'));
            // chart.setOption(tools.clone(self.chartOption));
            this.searchData.qylxMc = ""
            // 如果有初始值 赋值并进行查询
            if (this.params.tjtj && this.params.tjtj.parseData === '1') {
                console.log(this.params.tjtj)
                if (this.params.tjtj.cxtjDTO.swjgDm) self.searchData.swjgDm = this.params.tjtj.cxtjDTO.swjgDm
                if (this.params.tjtj.cxtjDTO.swjgMc) self.searchData.swjgMc = this.params.tjtj.cxtjDTO.swjgMc
                if (this.params.tjtj.cxtjDTO.qylx) self.searchData.qylx = this.params.tjtj.cxtjDTO.qylx
                if (this.params.tjtj.cxtjDTO.qylxMc) self.searchData.qylxMc = this.params.tjtj.cxtjDTO.qylxMc
                if (this.params.tjtj.cxtjDTO.qyhgdm) self.searchData.qyhgdm = this.params.tjtj.cxtjDTO.qyhgdm
                if (this.params.tjtj.cxtjDTO.cksjEnd) self.searchData.cksjEnd = this.params.tjtj.cxtjDTO.cksjEnd
                if (this.params.tjtj.cxtjDTO.cksjStart) self.searchData.cksjStart = this.params.tjtj.cxtjDTO.cksjStart
                if (this.params.tjtj.cxtjDTO.dqcode) self.searchData.dqcode = this.params.tjtj.cxtjDTO.dqcode
                if (this.params.tjtj.cxtjDTO.gbcode) self.searchData.gbcode = this.params.tjtj.cxtjDTO.gbcode
                if (this.params.tjtj.cxtjDTO.tjkj) self.searchData.tjkj = this.params.tjtj.cxtjDTO.tjkj
                if (this.params.tjtj.cxtjDTO.tjlx) self.searchData.tjlx = this.params.tjtj.cxtjDTO.tjlx
                if (this.params.tjtj.cxtjDTO.tslcode) self.searchData.tslcode = this.params.tjtj.cxtjDTO.tslcode
                if (this.params.tjtj.cxtjDTO.spmlcode) self.searchData.spmlcode = this.params.tjtj.cxtjDTO.spmlcode
                if (this.params.tjtj.cxtjDTO.pmlx) self.searchData.pmlx = this.params.tjtj.cxtjDTO.pmlx
                var zTree = $.fn.zTree.getZTreeObj("wmghqyTree2")
                var text = ''
                for (var key of this.params.tjtj.cxtjDTO.gbcode) {
                    zTree.getNodeByParam("id", key).checked = true
                    zTree.getNodeByParam("id", key).getParentNode().checked = true
                    zTree.updateNode(zTree.getNodeByParam("id", key).getParentNode());
                    text += zTree.getNodeByParam("id", key).name + ','
                }
                text=text.slice(0,-1)
                self.ckmygMc = text
                self.search(1)
            }
        },

        changeTab:function(num){
            this.act=num;
        },
        fleshChart:function(data){
            var self=this;
            data1=[];data2=[];
            for(var rowNum=0;rowNum<data.rows.length;rowNum++){
                var row=data.rows[rowNum];
                //此处0,1,4指对应的col的name
                data1.push({value:row[self.tableArr[1].name],name:row[self.tableArr[0].name]});
                data2.push({value:row[self.tableArr[4].name],name:row[self.tableArr[0].name]});
            }
            self.chartOption.visualMap.min=tools.getVis(data1)[0];
            self.chartOption.visualMap.max=tools.getVis(data1)[1];
            self.chartOption.series[0].data=tools.clone(data1);
            // self.chartOption.series[1].data=tools.clone(tsbzData);
            chart.setOption(tools.clone(self.chartOption));
        },
        getTableCol:function(){
            var self=this;
            ajax("POST","/bjtssw/tjbb/profile/header",{bbdm:"D01010"}).done(function(res){
                if(res.code=="0"){
                    if(res.data.column.length>0){
                        for(var i=0;i<res.data.column.length;i++){
                            self.tableArr[i].name=res.data.column[i].fname;
                            self.tableArr[i].index=res.data.column[i].fname;
                        }
                    }

                    self.createTable( self.tableArr);
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
            $("#wmghqy-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#wmghqy-tablePager',
                shrinkToFit: true,
                width:"100%",
                multiselect: false,
                multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                footerrow:true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: 50,
                rowList: [20,50,100,500],
                height:(function(){ return $(".wmghqy .form").height() -90;})(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var b = getCellData("wmghqy-table", rowid, 'XZQH');
                        var mc = getCellData("wmghqy-table", rowid, 'MC');
                        avalonRoot.addTab({title:"外贸供货企业明细",tip:"外贸供货企业明细-"+mc,component:"wmghqyMx",sameCheck:true,params:{dqmc:mc,xzqh:b,xdtjMc:self.xdtjMc,searchData:tools.clone(self.searchData)}});
                        return false;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }
                },
                gridComplete: function(){
                    // var data = self.data.rows;
                    // var len = data.length;
                    var sumData={}
                    for(var i=0;i<self.tableArr.length;i++){
                        if(i==1 || i== 4 ){
                            var sum=0;
                            $("#wmghqy-table").getCol(self.tableArr[i].name,false).map(function(a,key){
                                if(self.tableData.rows[key].XZQH.length==2){

                                }else{
                                    sum+=(a.replace(/\,/g,'')-0)
                                }
                            });
                            sumData[self.tableArr[i].name]=avalon.filters.number(sum,2);
                        }else{
                            sumData[self.tableArr[i].name]=""
                        }
                    }
                    sumData[self.tableArr[0].name] = "当前页合计";
                    $("#wmghqy-table").footerData('set', sumData);
                },
                onSortCol: function (index, iCol, sortorder) {
                    // self.searchData.orderSql = index + ' ' + sortorder;
                    // self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"wmghqy-table");
                    self.search(pageNo);
                }

            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.wmghqy')).val();
            $("#wmghqy-table").setGridWidth($('.wmghqy').width())
        },
        //获取商品大类
        getSpdl: function () {
            var self = this;
            ajax("POST","/bjtssw/tjfx/spml",{}).done(function(res){
                if(res.code=='0'){
                    self.spdl = res.data.spdl;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        getCheckedChildNodes: function(type) {
            var res = {gbcode:[],dqcode:[]};
            var xdtjMc = "";
            var nodes = $.fn.zTree.getZTreeObj("wmghqyTree2").getCheckedNodes(true);
            //按照国家 所有的统计方式gbcode都传国家代码进去
            if (type == "gbcode") {
                var arr = [];
                for (var i = 0; i < nodes.length; i++) {
                    if (nodes[i].isParent) {
                        continue;
                    }
                    arr.push(nodes[i].id);
                    xdtjMc += ","+nodes[i].name;
                }
                res.gbcode = arr;
                if (xdtjMc && xdtjMc.length > 20) {
                    this.xdtjMc = xdtjMc.slice(1,20)+"...";
                } else {
                    this.xdtjMc = xdtjMc ? xdtjMc.slice(1) : "";
                }
            }
            //其他按大洲按经济体
            else {
                var arr1 = [],arr2=[];
                var children;
                for (var i = 0; i < nodes.length; i++) {
                    arr1.push(nodes[i].id);
                    xdtjMc += ","+nodes[i].name;
                    children = nodes[i].states;
                    for (var j = 0; j < children.length; j++) {
                        arr2.push(children[j].id);
                    }
                }
                if (xdtjMc && xdtjMc.length > 20) {
                    this.xdtjMc = xdtjMc.slice(1,20)+"...";
                } else {
                    this.xdtjMc = xdtjMc ? xdtjMc.slice(1) : "";
                }
                res.gbcode = arr2;
                res.dqcode = arr1;
            }
            return res;
        },
        //构建国家树
        initTree2: function() {
            var self = this;
            this.hideTree();
            var treeObj = $.fn.zTree.getZTreeObj("wmghqyTree2");
            if (treeObj) {
                treeObj.destroy();
            }
            var setting = {
                check: {
                    enable: true,
                    chkboxType: {"Y":"ps","N":"ps"},
                    chkStyle: "checkbox"
                },
                view: {
                    showIcon: false,
                    selectedMulti: false,
                },
                data: {
                    key: {
                        children: "states"
                    }
                },
                callback: {
                    onCheck:function () {
                        var resObj = self.getCheckedChildNodes("gbcode");
                        self.searchData.gbcode = resObj.gbcode;
                        self.searchData.dqcode = resObj.dqcode;
                    }
                }
            };
            var data = tools.clone(avalonRoot.ztreeNodes.gjdata);
            $.fn.zTree.init($("#wmghqyTree2"), setting,data);
        },
        search:function(page){
            var self=this;
            var cksjStart = this.searchData.cksjStart;
            var cksjEnd = this.searchData.cksjEnd;
            if (!cksjStart) {
                tools.info("出口时间起不能为空");
                return
            }
            if (!cksjEnd){
                tools.info("出口时间止不能为空");
                return
            }
            if(!tools.betweenYear(cksjStart,cksjEnd)){
                tools.info('出口日期起和止的跨度不能超过1个自然年度');
                return ;
            }
            if ((new Date(cksjStart).getTime() - new Date(cksjEnd).getTime()) > 0) {
                tools.info("出口时间止不能小于出口时间起");
                return
            }
            var tjlx = this.searchData.tjlx;
            // if (tjlx == "1" && this.searchData.gbcode.length == 0) {
            //     tools.info("出口贸易国不能为空");
            //     return;
            // }
            // if (tjlx == "2" && this.searchData.spmlcode.length == 0) {
            //     tools.info("出口商品大类不能为空");
            //     return;
            // }
            // if (tjlx == "3" && this.searchData.tslcode.length == 0) {
            //     tools.info("退税率不能为空");
            //     return;
            // }
            // if (this.searchData.gbcode.length == 0 && this.searchData.dqcode.length == 0) {
            //     tools.info("出口贸易国不能为空");
            //     return
            // }
            var params={
                bbdm:"D01010",
                cxtjDTO:tools.clone(self.searchData),
                pageSize:$(".ui-pg-selbox", $('.wmghqy')).val(),
                pageNo:page,
                pageSize:self.searchData.pageSize
            };
            $("#wmghqy-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/tjfx/loaddata",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    $("#wmghqy-table").resetSelection();
                    $("#wmghqy-table")[0].addJSONData(res.data);
                    self.fleshChart(res.data)
                }else if (res.code == '100') {
                    $.dialog({
                        title: "提示",
                        content: res.msg,
                        lock: true,
                        button: [
                            {
                                value: '查看结果',
                                callback: function () {
                                    self.tableData=res.data;
                                    $("#wmghqy-table").resetSelection();
                                    $("#wmghqy-table")[0].addJSONData(res.data);
                                    self.fleshChart(res.data)

                                }
                            },
                            {
                                value: '重新统计',
                                callback: function () {
                                    self.searchData.refresh =  "Y"
                                    self.search(1)
                                }
                            },
                            {
                                value: '取消'
                            }
                        ]
                    })
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        reset: function() {
            var self=this;
            self.searchData={
                tsjg:"",
                qylx:"",
                cksjStart:"",
                cksjEnd:"",
                gbcode:[]
            }
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
                data:{
                    key:{
                        children:"item",
                        name:"text"
                    }
                }
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($("#wmghqyTree"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            })
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.wmghqy').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.wmghqy').off('click');
        },
        //点击企业类型输入框时触发
        showSelect: function (e) {
            var self=this;
            $(".select-container",$(e.target).parent()).show();
            $('.wmghqy .page').on('click',function(e){
                var e=e||window.event;
                if($('.select-container').find($(e.target)).length<=0){
                    $(".select-container").hide();
                    $('.wmghqy .page').off('click');
                }
            })
        },
        //点击限定条件对应值这个输入框时触发，根据不同的限定条件弹出不同的选择框
        showSelect2: function (e) {
            var self=this;
            //限定条件类型
            var tjlx = self.searchData.tjlx;
            if(!tjlx) return;
            if (tjlx == "1") {
                $(".select1",$(e.target).parent()).show();
                $('.wmghqy .page').on('click',function(e){
                    var e=e||window.event;
                    if($('.select1').find($(e.target)).length<=0){
                        $(".select1").hide();
                        $('.wmghqy .page').off('click');
                    }
                })
            } else if (tjlx == "2") {
                $(".select2",$(e.target).parent()).show();
                $('.wmghqy .page').on('click',function(e){
                    var e=e||window.event;
                    if($('.select2').find($(e.target)).length<=0){
                        $(".select2").hide();
                        $('.wmghqy .page').off('click');
                    }
                })
            } else {
                $(".select3",$(e.target).parent()).show();
                $('.wmghqy .page').on('click',function(e){
                    var e=e||window.event;
                    if($('.select3').find($(e.target)).length<=0){
                        $(".select3").hide();
                        $('.wmghqy .page').off('click');
                    }
                })
            }

        },
        //限定条件类型改变
        handleChange: function (e) {
            var target=e.target;
            var xdlx = $(target).val();
            this.xdtjMc = "";
            this.searchData.gbcode = [];
            this.searchData.tslcode = [];
            this.searchData.spmlcode = [];
            if (xdlx == "1") {
                this.initTree2();
            }
        },
        selectChange: function(e) {
            var map = {"1": "生产企业","2":"外贸企业","3":"外综服"};
            if (this.searchData.qylx && this.searchData.qylx.length == 0) {
                this.searchData.qylxMc = "";
            } else {
                var str = "";
                for (var i = 0; i < this.searchData.qylx.length; i++) {
                    str += ","+map[this.searchData.qylx[i]];
                }
                this.searchData.qylxMc = str.slice(1);
            }
        },
        selectChange2: function(type) {
            var xdtjMc = "";
            var self = this;
            if (type == "2") {
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
            } else {
                $.each(this.searchData.tslcode,function (index,item) {
                    xdtjMc += "," + item + "%";
                });
                xdtjMc = xdtjMc ? xdtjMc.slice(1) : "";
            }
            this.xdtjMc = xdtjMc;
        },
        exform:function(){
            var self=this;
            if($('#wmghqy-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var cksjStart = this.searchData.cksjStart;
            var cksjEnd = this.searchData.cksjEnd;
            if (!cksjStart) {
                tools.info("出口时间起不能为空");
                return
            }
            if (!cksjEnd){
                tools.info("出口时间止不能为空");
                return
            }
            if ((new Date(cksjStart).getTime() - new Date(cksjEnd).getTime()) > 0) {
                tools.info("出口时间止不能小于出口时间起");
                return
            }
            var tjlx = this.searchData.tjlx;
            // if (tjlx == "1" && this.searchData.gbcode.length == 0) {
            //     tools.info("出口贸易国不能为空");
            //     return;
            // }
            // if (tjlx == "2" && this.searchData.spmlcode.length == 0) {
            //     tools.info("出口商品大类不能为空");
            //     return;
            // }
            // if (tjlx == "3" && this.searchData.tslcode.length == 0) {
            //     tools.info("退税率不能为空");
            //     return;
            // }
            // if (this.searchData.gbcode.length == 0 && this.searchData.dqcode.length == 0) {
            //     tools.info("出口贸易国不能为空");
            //     return
            // }
            var params={
                bbdm:"D01010",
                cxtjDTO:tools.clone(self.searchData),
                pageSize:$(".ui-pg-selbox", $('.wmghqy')).val(),
                pageNo:1
            };
            params.cxtjDTO.gjmc=self.xdtjMc;
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("method", "post");
            form.attr("action", "/bjtssw/tjfx/loaddata/export");
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