var jljg=require("./jljg.html");
avalon.component('jljg', {
    template:jljg,
    defaults: {
        params:{},
        act:1,
        tcode:"jljgcx",
	    swjgmc:"",
        searchData:{
            swjgdm:"",
            hgdm:"",
            shxydm:"",
            nsrmc:"",
            qylx:"",
            sbrqq:"",
            sbrqz:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{
            sumData:{}
        },
        setData:{
            zczt:"",
            ktpt:""
        },
        onReady:function(){
            try {
                this.searchData.swjgdm=avalonRoot.user.swjgDm;
                this.swjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

            }
            var self = this;
            this.getTableRow();
            self.initTree();
            $('.jljg .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });

        },
        changeTab:function(num){
            this.act=num;
        },
        creatChart:function(){
            echarts.init($('.jljg .chartDiv')[0]).setOption({
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
            ajax("POST","/cxfw/basis/columprofile",{tcode:self.tcode}).done(function(res){
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
            $("#jljg-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#jljg-tablePager',
                shrinkToFit: false,
                width:"100%",
                // multiselect: true,
                // multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                footerrow:true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".jljg .form").height() -100;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var b = getCellData("jljg-table", rowid, 'taxpayerCode')
                        avalonRoot.addTab({title:"进料加工手册核销明细",component:"jljgMx",sameCheck:false,params:{lcslid:self.tableData.rows[rowid-1].lcslid}});
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
                gridComplete: function(){
                    var sumData=self.tableData.sumData;
                    sumData[self.tableArr[0].name]="合计";
                    $("#jljg-table").footerData('set', sumData);
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"jljg-table");
                    self.search(pageNo);
                }
            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.jljg')).val();
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
            ajax("POST","/cxfw/basis/columprofile/update",params).done(function(res){
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
                    $("#jljg-table").showCol(self.tableOption[i].name)
                } else {
                    $("#jljg-table").hideCol(self.tableOption[i].name)
                }
            }
            $("#jljg-table").setGridWidth($('.jljg').width())
        },
        search:function(pageNo){
            var self=this;
	        var fields = [
		        {name:"hgdm",rules:'max_length[10]',message:"海关代码最大长度为10"},
		        {name:"shxydm",rules:'max_length[21]',message:"社会信用代码最大长度为10"},
		        {name:"nsrmc",rules:'max_length[30]',message:"纳税人名称最大长度为30"},
	        ];
	        var isValid = tools.validate("jljg-form",fields);
	        if (isValid) {
		        this.searchData.pageSize = $(".ui-pg-selbox", $('.jljg')).val() || 20;
		        var params=tools.clone(self.searchData);
		        params.pageNo=pageNo
                $("#jljg-table").jqGrid('clearGridData');
		        ajax("POST","/cxfw/jljgcx",params).done(function(res){
			        if(res.code=='0'){
                        self.tableData=res.data;
				        $("#jljg-table").resetSelection();
				        $("#jljg-table")[0].addJSONData(res.data);
				        self.closeHyper();
			        }else{
				        tools.info(res.msg);
			        }
		        }).fail(function(err){
			        tools.info(err);
		        })
	        }
        },

        showHyper:function(){
            $('.jljg .select-sub').toggle();
            $('.jljg .select-wrapper .icon').toggleClass("active");
            if ($('.jljg .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.jljg .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.jljg .select-wrapper .icon').attr("title","展开查询条件")
            }
        },
        closeHyper:function(){
            $('.jljg .select-sub').hide();
            $('.jljg .select-wrapper .icon').removeClass('active');
            $('.jljg .select-wrapper .icon').attr("title","展开查询条件")
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
                tools.info("申报年月输入错误");
                res=""
            }
            e.target.value=res;
            return ;
        },
        showMenu:function(e){
            var self=this;
            $(".dropdown-menu",e.target).show();
            $('.jljg').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }
            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.jljg').off('click');
        },

        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.swjgdm = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.swjgdm = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".jljg .treeDiv"), setting,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.jljg').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.jljg').off('click');
        },
        exform:function(){
            if($('#jljg-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var self=this;
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/cxfw/export/jljgcx");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
	    reset: function() {
		    this.searchData = {
                swjgdm:avalonRoot.user.swjgDm,
                hgdm:"",
                shxydm:"",
                nsrmc:"",
                qylx:"",
                sbrqq:"",
                sbrqz:"",
                orderSql:"",
                pageSize:config.pageSize,
            };
		    this.swjgmc = avalonRoot.user.swjgMc;
	    }
    }
});