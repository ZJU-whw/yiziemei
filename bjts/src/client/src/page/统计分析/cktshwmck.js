var cktshwmck=require("./cktshwmck.html");
var chart;
avalon.component('cktshwmck', {
    template:cktshwmck,
    defaults: {
        TZswitch:"",
        act:1,
        tcode:"E01001",
        bbid:"",
        editType: "1",
        yearArr:(function(){var year=new Date().getFullYear();return [year-4,year-3,year-2,year-1,year]})(),
        searchData:{
            ssny:"",
            swjgdm:"",
            swjgmc:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        IEFlag:false,
        scFlag:false,
        clock:0,
        currentPage:1,
        form:{
            bbdm:"",
            bbmc:"",
            bbjc:"",
            sppy:"",
            czpy:"",
            sfbl:"",
            showorder:"",
            bbtype:"",
            note:"",
        },
        modalData:{
            ssny:"",
        },
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{
            count:0,
            records:0,
            rows:[],
            total:0
        },
        setData:{
            zczt:"",
            ktpt:""
        },
        chartOption: {
            title : [{
                text: '出口退税和外贸出口情况',
                subtext: '出口额单位：美元，退税额单位：元',
                textStyle:{
                    fontSize:18
                },
                left:'middle',
                top:'top',
                textAlign:"center"
            }],
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'cross',
                    crossStyle: {
                        color: '#999'
                    }
                },
	            formatter: function (params) {
		            let html=params[0].name+"<br>";
		            for(let i=0;i<params.length;i++){
			            html+='<span style="display:inline-block;margin-right:5px;border-radius:10px;width:10px;height:10px;background-color:'+params[i].color+';"></span>'
			            if(params[i].seriesName=="外贸出口额增长率" ||params[i].seriesName=="出口退税额增长率" ||params[i].seriesName=="报关单出口额增长率"){
				            html+=params[i].seriesName+":"+avalon.filters.number(params[i].value*100,2)+"%<br>";
			            }else{
				            html+=params[i].seriesName+":"+params[i].value+"<br>";
			            }
		            }
		            return html;
	            }
            },
            legend: {
                data: ['外贸出口额','报关单出口额','出口退税额','外贸出口额增长率', '出口退税额增长率', '报关单出口额增长率'],
                x:"center",
                y: "bottom"
            },
            xAxis: [
                {
                    type: 'category',
                    data: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
                    axisPointer: {
                        type: 'shadow'
                    },
                    gridIndex: 0
                },
                {
                    type: 'category',
                    data: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
                    axisPointer: {
                        type: 'shadow'
                    },
                    gridIndex: 1
                }
            ],
            yAxis: [
                {
                    name: '金额',
                    max: function(value) {
                        return value.max;
                    },
                    min: 0,
                    axisLabel: {
                        formatter: '{value}'
                    },
                    gridIndex: 0
                },
                {
                    name: '同比增长率',
                    splitNumber: 4,
                    axisLabel: {
                        formatter: function(value){
                            return value+"%"
                        }
                    },
                    gridIndex: 0
                },
                 {
                    name: '金额',
                    max: function(value) {
                        return value.max;
                    },
                    min: 0,
                    axisLabel: {
                        formatter: '{value}'
                    },
                    gridIndex: 1
                },
                {
                    name: '同比增长率',
                    splitNumber: 4,
                    axisLabel: {
                        formatter: function(value){
                            return value+"%"
                        }
                    },
                    gridIndex: 1
                }
            ],
            grid: [
                {bottom: '55%'},
                {top: '55%'}
            ],
            series: [
                {
                    name: '外贸出口额',
                    type: 'bar',
                    data: [2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3],
                    xAxisIndex: 0, yAxisIndex:0
                },
                {
                    name: '出口退税额',
                    type: 'bar',
                    data: [2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3],
                    xAxisIndex: 1, yAxisIndex: 2
                },
                {
                    name: '报关单出口额',
                    type: 'bar',
                    xAxisIndex: 0, yAxisIndex:0,
                    data: [2.0, 2.2, 3.3, 4.5, 6.3, 10.2, 20.3, 23.4, 23.0, 16.5, 12.0, 6.2]
                },
                {
                    name: '外贸出口额增长率',
                    type: 'line',
                    xAxisIndex: 0, yAxisIndex:1,
                    data: [2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3]
                },
                {
                    name: '出口退税额增长率',
                    type: 'line',
                    xAxisIndex: 1, yAxisIndex:3,
                    data: [2.6, 5.9, 9.0, 26.4, 28.7, 70.7, 175.6, 182.2, 48.7, 18.8, 6.0, 2.3],
                },
                {
                    name: '报关单出口额增长率',
                    type: 'line',
                    xAxisIndex: 0, yAxisIndex:1,
                    data: [2.0, 2.2, 3.3, 4.5, 6.3, 10.2, 20.3, 23.4, 23.0, 16.5, 12.0, 6.2]
                }
            ]
        },
	    handleChange: function(e) {
        	var ssny = e.target.value;
        	this.searchData.ssny = ssny;
        	this.search(1);
	    },
        onReady:function(){
            var self = this;
            this.initForm();
            // self.initTree();
            self.isIE();
            self.findYearArr();
            $('.cktshwmck .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.cktshwmck .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });
            //统计表初始化
            $('#cktshwmck-chart').width($('.cktshwmck').width()).height($('.cktshwmck .page').height()-40);
            chart = echarts.init(document.getElementById('cktshwmck-chart'));
            chart.setOption(tools.clone(self.chartOption));
        },

        changeTab:function(num){
            this.act=num;
        },
        findYearArr: function (isDefault) {
            var self = this;
            ajax("POST","/bjtssw/tjfx/year",{}).done(function(res){
                if(res.code=="0"){
                    self.yearArr = res.data.rows;
                    var flag = false;//数组是否存在今年年份
                    if (!isDefault && self.yearArr && self.yearArr.length > 0) {
                        self.searchData.ssny = self.yearArr[0];
                    }
                    var currentYear = new Date().getFullYear();
                    $.each(self.yearArr,function (index,item) {
                        if (item == currentYear) {
                            flag = true;
                        }
                    });
                    if (isDefault) {
                    	self.search(1);
                    } else {
	                    if (flag && self.yearArr && self.yearArr.length > 0) {
		                    self.searchData.ssny = self.yearArr[0];
		                    self.search(1);
	                    }
	                    if (!flag) {
	                    	tools.confirm("当年【"+currentYear+"】期别数据尚未初始化，是否执行初始化？？","确定",function () {
			                    ajax("POST","/bjtssw/tjfx/initE01001",{ssny: currentYear}).done(function(res){
				                    if(res.code=='0'){
					                    self.hideModel();
					                    self.findYearArr();
					                    self.searchData.ssny = currentYear;
					                    self.search(1);
				                    }else{
					                    tools.info(res.msg);
				                    }
			                    }).fail(function(err){
				                    tools.info(err);
			                    })
		                    },function() {
			                    if (self.yearArr && self.yearArr.length > 0) {
				                    self.searchData.ssny = self.yearArr[0];
				                    self.search(1);
			                    }
		                    });
	                    }
                    }
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        //copy
        initForm:function(){
            var self=this;
            ajax("POST","/bjtssw/tjbb/profile",{bbdm:self.tcode}).done(function(res){
                if(res.code=="0"){
                    self.form=res.data;
                    self.initTable();
                }else{
                    tools.info(res.msg)
                }

            }).fail(function(err){
                tools.info(err);
            })
        },
        scrollTHead:function(e){
            var target=e.target;
            $(target).prev().scrollLeft($(target).scrollLeft())
        },
        initTable:function(){
            var self=this;
            ajax("POST","/bjtssw/tjbb/profile/header",{bbdm:self.tcode}).done(function(res){
                if(res.code=="0"){
                    self.tableOption=res.data;
                    $('.page.active .table-head-wrapper').height($('.page.active .table-head-wrapper .table thead').height()+'px');
                }else{
                    tools.info(res.msg)
                }

            }).fail(function(err){
                tools.info(err);
            })
        },
        search:function(page){
            var self=this;
            if(self.form.bbtype==3){
                var pagesize=20
            }else{
                pagesize=1000
            }
            var params={
                pageSize:pagesize,
                pageNo:page,
                ssny:this.searchData.ssny,
                bbdm:self.tcode
            };
            ajax("POST","/bjtssw/tjbb/loaddata",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    self.closeHyper();
                    self.fleshChart(res.data);
                    self.currentPage=page;
                    if(!self.scFlag){
                        $(".cktshwmck .table-body-wrapper").scroll(function () {
                            $(".cktshwmck .table-head-wrapper").scrollLeft($(".table-body-wrapper").scrollLeft())
                        });
                        self.scFlag=true;
                    }
                    // self.calTable();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        flesh:function(page){
            var self=this;
            if(self.form.bbtype==3){
                var pagesize=20
            }else{
                pagesize=1000
            }
            var params={
                pageSize:pagesize,
                pageNo:page,
                ssny:this.searchData.ssny,
                bbdm:self.tcode
            };
            ajax("POST","/bjtssw/tjfx/flushE01001",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    self.fleshChart(res.data);
                    self.currentPage=page;
                    if(!self.scFlag){
                        $(".cktshwmck .table-body-wrapper").scroll(function () {
                            $(".cktshwmck .table-head-wrapper").scrollLeft($(".table-body-wrapper").scrollLeft())
                        });
                        self.scFlag=true;
                    }
                    // self.calTable();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        fleshChart:function(data){
            var self=this;
            var barData=[data.rows[0],data.rows[3],data.rows[6]];
            var lineData=[data.rows[2],data.rows[5],data.rows[8]];
            var barSer=[[],[],[]],lineSer=[[],[],[]];
            for(var i=0;i<barData.length;i++){
                barSer[i].push(barData[i].JAN);
                barSer[i].push(barData[i].FEB);
                barSer[i].push(barData[i].MAR);
                barSer[i].push(barData[i].APR);
                barSer[i].push(barData[i].MAY);
                barSer[i].push(barData[i].JUN);
                barSer[i].push(barData[i].JUL);
                barSer[i].push(barData[i].AUG);
                barSer[i].push(barData[i].SEP);
                barSer[i].push(barData[i].OCT);
                barSer[i].push(barData[i].NOV);
                barSer[i].push(barData[i].DEC);
            }
            for(var i=0;i<lineData.length;i++){
                lineSer[i].push(lineData[i].JAN);
                lineSer[i].push(lineData[i].FEB);
                lineSer[i].push(lineData[i].MAR);
                lineSer[i].push(lineData[i].APR);
                lineSer[i].push(lineData[i].MAY);
                lineSer[i].push(lineData[i].JUN);
                lineSer[i].push(lineData[i].JUL);
                lineSer[i].push(lineData[i].AUG);
                lineSer[i].push(lineData[i].SEP);
                lineSer[i].push(lineData[i].OCT);
                lineSer[i].push(lineData[i].NOV);
                lineSer[i].push(lineData[i].DEC);
            }
            self.chartOption.series[0].data=tools.clone(barSer[0]);
            self.chartOption.series[1].data=tools.clone(barSer[1]);
            self.chartOption.series[2].data=tools.clone(barSer[2]);
            self.chartOption.series[3].data=tools.clone(lineSer[0]);
            self.chartOption.series[4].data=tools.clone(lineSer[1]);
            self.chartOption.series[5].data=tools.clone(lineSer[2]);
            var maxValue = Math.max.apply(null,barSer[0].concat(barSer[1]).concat(barSer[2]));
            self.chartOption.yAxis[0].max = maxValue;
            chart.setOption(tools.clone(self.chartOption));
        },
        saveBB:function(){
            var self=this;
            var params={
                bbdm:self.tcode,
                bbid:self.bbid,
                data:tools.clone(self.tableData.rows)
            };
            ajax("POST","/bjtssw/tjbb/savedata",params).done(function(res){
                if(res.code=='0'){
                    tools.info("保存成功");
	                self.editType = "1";
	                self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        cleanTable:function(){
            var self=this;
            for(var i=0;i<self.tableData.rows.length;i++){
                for(var j=0;j<self.tableOption.column.length;j++){
                    if(self.tableOption.column[j].allowformula&&self.tableOption.column[j].allowformula=='N'){
                        continue;
                    }
                    var key=self.tableOption.column[j].fname;
                    if(self.tableData.rows[i][key]&&isNaN(self.tableData.rows[i][key])&&self.tableData.rows[i][key].indexOf(',')>=0){
                        self.tableData.rows[i][key]=self.tableData.rows[i][key].replace(/,/g,'')-0
                    }else if(self.tableData.rows[i][key]&&!isNaN(self.tableData.rows[i][key])){
                        self.tableData.rows[i][key]=self.tableData.rows[i][key]-0
                    }
                }
            }
        },
        calTable:function(){
            var self=this;
            if(self.tableOption.linerFormula.length==0&&self.tableOption.headerFormula.length==0){
                for(var k=0;k<self.tableOption.column.length;k++){
                    var col=self.tableOption.column[k]
                    if(!col.degree||isNaN(col.degree)){
                        continue;
                    }else{
                        for(var l=0;l<self.tableData.rows.length;l++){
                            var row=self.tableData.rows[l]

                            row[col.fname]=avalon.filters.number(row[col.fname],col.degree)
                        }
                    }
                }
                this.saveBB();
                return ;
            }
            this.cleanTable();
            for(var i=0;i<self.tableOption.linerFormula.length;i++){
                var str=self.tableOption.linerFormula[i]
                str=str.replace(/\([0-9]+\)/g,function(a,b){
                    var num=a.match(/[0-9]+/)[0]-1;
                    if(b==0){
                        return "self.tableData.rows["+num+"][key]"
                    }else{
                        return "(self.tableData.rows["+num+"][key]-0)"
                    }

                })
                for(var j=0;j<self.tableOption.column.length;j++){
                    if(self.tableOption.column[j].allowformula&&self.tableOption.column[j].allowformula=='N'){
                        continue;
                    }
                    var key=self.tableOption.column[j].fname;
                    try{
                        eval(str);
                    }catch(e){
                        tools.info(e)
                    }

                }
            }
            for(var i=0;i<self.tableOption.headerFormula.length;i++){
                var str=self.tableOption.headerFormula[i].trim();
                str=str.replace(/\([0-9A-Za-z\_]+\)/g,function(a,b){
                    var num=a.match(/[0-9A-Za-z\_]+/)[0];
                    if(b==0){
                        return "(self.tableData.rows[j]['"+num+"'])"
                    }else{
                        return "(self.tableData.rows[j]['"+num+"']-0)"
                    }

                })
                for(var j=0;j<self.tableData.rows.length;j++){
                    if(self.tableData.rows[j].ALLOWFORMULA&&self.tableData.rows[j].ALLOWFORMULA=='N'){
                        continue;
                    }
                    try{
                        eval(str);
                    }catch(e){
                        tools.info(e)
                    }
                }
            }
            //exCal
            for(var i=0;i<self.tableOption.bzFormula.length;i++){
                var str=self.tableOption.bzFormula[i].trim();
                str=str.replace(/\([0-9A-Za-z\_]+\)/g,function(a,b){
                    var num=a.match(/[0-9A-Za-z\_]+/)[0];
                    if(b==0){
                        return "(self.tableData.rows[j]['"+num+"'])"
                    }else{
                        return "(self.tableData.rows[j]['"+num+"']/self.tableData.rows[0]['"+num+"'])"
                    }

                })
                for(var j=0;j<self.tableData.rows.length;j++){
                    if(self.tableData.rows[j].ALLOWFORMULA&&self.tableData.rows[j].ALLOWFORMULA=='N'){
                        continue;
                    }
                    try{
                        eval(str);
                    }catch(e){
                        tools.info(e)
                    }
                }
            }
            self.tableData.rows=tools.clone(self.tableData.rows)
            for(var k=0;k<self.tableOption.column.length;k++){
                var col=self.tableOption.column[k]
                if(!col.degree||isNaN(col.degree)){
                    continue;
                }else{
                    for(var l=0;l<self.tableData.rows.length;l++){
                        var row=self.tableData.rows[l]
                        row[col.fname]=avalon.filters.number(row[col.fname],col.degree)
                    }
                }
            }
            this.saveBB();
        },

        showHyper:function(){
            $('.bbbbmxb03102 .hyper').toggle();
            $('.bbbbmxb03102 .hyperBtn').toggleClass('active');
        },
        closeHyper:function(){
            $('.bbbbmxb03102 .hyper').hide();
            $('.bbbbmxb03102 .hyperBtn').removeClass('active');
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
        degree:function(x,y,degree){
            var self=this;
            if(x==undefined||y==undefined){
                throw "there is no such [x][y]@degree"
                return ;
            }
            if(degree==undefined||degree==""||isNaN(degree)){
                return ;
            }else{
                self.tableData.rows[x][y]=avalon.filters.number(self.tableData.rows[x][y],degree);
            }
        },
        filMon:function(e){
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
            $('.cktshwmck').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.cktshwmck').off('click');
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

            ajax("POST","/cxfw/export/readtree", {nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($(".bbbbmxb03102 .treeDiv"), setting, res.data);
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
            $('.bbbbmxb03102').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.bbbbmxb03102').off('click');
        },
        checkRed:function(index,col){
            var self=this;
            if(self.tableData.rows[index][col+'_HZ']==undefined){
                return false;
            }
            var degree;
            for(var i=0;i<self.tableOption.column.length;i++){
                if(self.tableOption.column[i].fname==col){
                    degree=self.tableOption.column[i].degree;
                }
            }
            if(degree!=""&&!isNaN(degree)){
                var nowVal=avalon.filters.number(self.tableData.rows[index][col],degree);
                var oldVal=avalon.filters.number(self.tableData.rows[index][col+'_HZ'],degree);
            }else{
                nowVal=self.tableData.rows[index][col]+"";
                oldVal=self.tableData.rows[index][col+'_HZ']+"";
            }

            if(oldVal==nowVal){
                return false;
            }else{
                return true;
            }
        },
        checkHz:function(index,col){
            var self=this;
            if(self.tableData.rows[index][col+'_HZ']==undefined){
                var nowVal=self.tableData.rows[index][col]+"";
                return "当前值："+nowVal;
            }
            var degree;
            for(var i=0;i<self.tableOption.column.length;i++){
                if(self.tableOption.column[i].fname==col){
                    degree=self.tableOption.column[i].degree;
                }
            }
            if(degree!=""&&!isNaN(degree)){
                var nowVal=avalon.filters.number(self.tableData.rows[index][col],degree);
                var oldVal=avalon.filters.number(self.tableData.rows[index][col+'_HZ'],degree);
            }else{
                nowVal=self.tableData.rows[index][col]+"";
                oldVal=self.tableData.rows[index][col+'_HZ']+"";
            }
            return "原始值：("+oldVal+"),当前值：("+nowVal+")";

        },
        addRow:function(){
            var self=this;
            var row=new Object();
            for(var i=0;i<self.tableOption.column.length;i++){
                if(self.tableOption.column[i]&&self.tableOption.column[i].fname){
                    row[self.tableOption.column[i].fname]="";
                }
            }
            row.SSNY=self.searchData.ssny;
            row.ALLOWUPDATE="Y";
            row.SWJGDM=avalonRoot.user.swjgDm;
            row.BBLC=self.tableData.rows.length+1;
            if(row.BBLC<=9){
                row.BBLC="0"+row.BBLC
            }
            row.isAdd="1";
            self.tableData.rows.push(row)
        },
        isIE: function () {
            var DEFAULT_VERSION = 8.0;
            var ua = navigator.userAgent.toLowerCase();
            var isIE = ua.indexOf("msie")>-1;
            var safariVersion;
            if(isIE){
                safariVersion =  ua.match(/msie ([\d.]+)/)[1];
            }
            if(safariVersion <= DEFAULT_VERSION ){
                return true
            } else {
                return false
            }
        },
        zbxxFlag:function(){
            var self=this;
            if(self.searchData.swjgdm==avalonRoot.user.swjgDm){
                return true;
            }else{
                return false;
            }
        },
        checkDisabled:function(col,index){
            var self=this;
            return (col.allowupdate=='N'||self.tableData.rows[index].ALLOWUPDATE=='N')?true:false
        },
        saveModel:function(){
            var self=this;
            if (!/^\d{4}$/.test(this.modalData.ssny)) {
                tools.info("请输入正确的年份，格式为yyyy");
                return;
            }
            var params = {ssny: this.modalData.ssny};
            ajax("POST","/bjtssw/tjfx/initE01001",params).done(function(res){
                if(res.code=='0'){
                    self.hideModel();
	                self.searchData.ssny = params.ssny;
	                self.findYearArr(true);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        showModel:function(){
            this.modalData.ssny = "";
            $('.model').show();
            $('.cktshwmck .zbxxModel').show();
        },
        hideModel:function(){
            $('.model').hide();
            $('.cktshwmck .zbxxModel').hide();
        },
        exform:function(){
            var self=this;
	        var params = {
		        bbdm:self.tcode,
		        ssny: self.searchData.ssny,
		        pageSize:"20",
		        pageNo:1
	        };
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/bjtssw/tjbb/saveExcel");
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