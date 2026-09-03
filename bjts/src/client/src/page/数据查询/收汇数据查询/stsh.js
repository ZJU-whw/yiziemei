var stsh=require("./stsh.html");
avalon.component('stsh', {
    template:stsh,
    defaults: {
        params:{},
        act:1,
        tcode: "stshcx",
	    swjgmc: "",
	    swjgData: [],
        searchData:{
            sbrqq:"",
            sbrqz:"",
            swjgdm:"",
            hgdm:"",
            shxydm:"",
            nsrmc:"",
            qylx:"",
            gllb:"",
            bgdno:"",
            fphm:"",
            yqyy:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
	    timer:null,
	    tableArr:[],
	    tableOption:[],
	    tableData:{},
        onReady:function(){
            try {
                this.searchData.swjgdm=avalonRoot.user.swjgDm;
                this.swjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

            }
            var self = this;
            this.getTableRow();
            this.creatChart();
            self.initTree();
            $('.stsh .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.stsh .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });
        },
        changeTab:function(num){
            this.act=num;
        },
        creatChart:function(){
            echarts.init($('.stsh .chartDiv')[0]).setOption({
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
            $("#stsh-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#stsh-tablePager',
                shrinkToFit: false,
                width:"100%",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".stsh .form").height() -100;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var b = getCellData("stsh-table", rowid, 'taxpayerCode')
                        avalonRoot.addTab({title:"视同明细",component:"stshMx",sameCheck:false,params:{lcslid:self.tableData.rows[rowid-1].lcslid}});
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
                    var pageNo=tools.getPageNo(pgButton,"stsh-table");
                    self.search(pageNo);
                }
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.stsh')).val();
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
                    $("#stsh-table").showCol(self.tableOption[i].name)
                } else {
                    $("#stsh-table").hideCol(self.tableOption[i].name)
                }
            }
            $("#stsh-table").setGridWidth($('.stsh').width())
        },
        search:function(pageNo){
            var self=this;
	        var fields = [
		        {name:"hgdm",rules:'max_length[10]',message:"海关代码最大长度为10"},
		        {name:"shxydm",rules:'max_length[21]',message:"社会信用代码最大长度为10"},
		        {name:"nsrmc",rules:'max_length[30]',message:"纳税人名称最大长度为30"},
	        ];
	        var isValid = tools.validate("stsh-form",fields);
	        if (isValid) {
		        this.searchData.pageSize = $(".ui-pg-selbox", $('.stsh')).val() || 20;
		        var params=tools.clone(self.searchData);
		        params.pageNo=pageNo
                $("#stsh-table").jqGrid('clearGridData')
		        ajax("POST","/cxfw/stshcx",params).done(function(res){
			        if(res.code=='0'){
				        $("#stsh-table").resetSelection();
				        $("#stsh-table")[0].addJSONData(res.data);
				        self.tableData=res.data;
			        }else{
				        tools.info(res.msg);
			        }
		        }).fail(function(err){
			        tools.info(err);
		        })
	        }
        },

        showHyper:function(){
            $('.stsh .select-sub').toggle();
            $('.stsh .select-wrapper .icon').toggleClass("active");
            if ($('.stsh .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.stsh .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.stsh .select-wrapper .icon').attr("title","展开查询条件")
            }
        },
        closeHyper:function(){
            $('.stsh .select-sub').hide();
            $('.stsh .select-wrapper .icon').removeClass('active');
            $('.stsh .select-wrapper .icon').attr("title","展开查询条件")
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
            $('.stsh').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.stsh').off('click');
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
                $.fn.zTree.init($(".stsh .treeDiv"), setting,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.stsh').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.stsh').off('click');
        },
        exform:function(){
            var self=this;
            if($('#stsh-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/cxfw/export/stshcx");
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
                sbrqq:"",
                sbrqz:"",
                swjgdm:avalonRoot.user.swjgDm,
                hgdm:"",
                shxydm:"",
                nsrmc:"",
                qylx:"",
                gllb:"",
                bgdno:"",
                fphm:"",
                yqyy:"",
                orderSql:"",
                pageSize:config.pageSize,
            };
		    this.swjgmc = avalonRoot.user.swjgMc;
	    }
    }
});