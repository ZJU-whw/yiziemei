var bbmxb03106=require("./bbmxb03106.html");
var chart;
avalon.component('bbmxb03106', {
    template:bbmxb03106,
    defaults: {
        params:{
            bbdm:"",
            bbid:"",
            bbmc:"",
            ssny:"",
            swjgdm:"",
            swjgmc:"",
            pageTitle:[]
        },
        location: [],
        pageTitle:[],
        TZswitch:"",
        act:1,
        tcode:"B03201",
        bbid:"",
        searchData:{
            ssny:"2019",
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
        modelData:{
            swjgmc:"",
            ssny:"",
            unit:"",
            zbr:"",
            zbdate:"",
            id:"",
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
        defaultData: [],
        setData:{
            zczt:"",
            ktpt:""
        },
        chartOption:{
            title : [{
                text: '浙江省出口商品主要贸易方式分布情况统计表',
                textStyle:{
                    fontSize:18
                },
                left:'middle',
                top:'top',
                textAlign:"center"
            },{
                text: '出口额本年累计比重',
                textStyle:{
                    fontSize:15
                },
                left:'25%',
                top:'15%',
                textAlign:"center"
            },{
                text: '退税额本年累计比重',
                textStyle:{
                    fontSize:15
                },
                left:'75%',
                top:'15%',
                textAlign:"center"
            },
            ],
            tooltip : {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                type:'scroll',
                pageButtonPosition:"start",
                x : 'center',
                y : 'bottom',
                data:['一般贸易','进料对口','市场采购','跨境电商','跨境电商B2B直接出口','跨境电商出口海外仓','其他']
            },
            calculable : true,
            series : [
                {
                    name:'出口额比重',
                    type:'pie',
                    radius : [0, 110],
                    center : ['25%', '50%'],
                    label: {

                        formatter: '{d}%'
                    },

                    data:[

                    ]
                },
                {
                    name:'退税额比重',
                    type:'pie',
                    radius : [0, 110],
                    center : ['75%', '50%'],
                    label: {

                        formatter: '{d}%'
                    },

                    data:[

                    ]
                }
            ]
        },

        onReady:function(){
            this.tcode=this.params.bbdm;
            this.bbid=this.params.bbid;
            this.searchData.ssny=this.params.ssny;
            this.TZswitch=this.params.TZswitch;
            this.searchData.swjgdm=this.params.swjgdm;
            this.searchData.swjgmc=this.params.swjgmc;
            this.pageTitle=tools.clone(this.params.pageTitle);
            var self = this;
            this.initForm();
            // self.initTree();
            self.isIE();
            //统计表初始化
            $('#bbmxb03106-chart').width($('.bbmxb03106').width());
            self.chartOption.title.subtext="申报年月:"+self.searchData.ssny;
            chart = echarts.init(document.getElementById('bbmxb03106-chart'));
            chart.setOption(tools.clone(self.chartOption));
        },
        changeTab:function(num){
            this.act=num;
        },
        //copy bg
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
                    self.getLocation();
                    self.search(1);
                }else{
                    tools.info(res.msg)
                }
                    
            }).fail(function(err){
                tools.info(err);
            })
        },
        goPrevPage: function() {
            var self = this;
            if (this.currentPage == "1") return
            this.currentPage = parseInt(this.currentPage) -1;
            this.search(self.currentPage)
        },
        changePage:function(event){
            var target=event.target;
            if(!isNaN(target.value)){
                if(target.value<=0||target.value>this.tableData.total){
                    this.search(1);
                    return
                }
                this.search(target.value)
            }
        },
        goNextPage: function() {
            var self = this;
            if (this.currentPage >= this.tableData.total) return
            this.currentPage = parseInt(this.currentPage) +  1;
            this.search(self.currentPage)
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
                ssny:self.searchData.ssny,
                swjgdm:self.searchData.swjgdm,
                bbdm:self.tcode
            }
            ajax("POST","/bjtssw/tjbb/loaddata",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    self.defaultData = tools.clone(res.data.rows)
                    self.fleshChart(res.data)
                    self.currentPage=page;
                    if(!self.scFlag){
                        $(".bbmxb03106 .table-body-wrapper").scroll(function () {
                            $(".bbmxb03106 .table-head-wrapper").scrollLeft($(".table-body-wrapper").scrollLeft())
                        })
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
            var ckbzData=[],tsbzData=[];
            var nameIndex=[
                "合计",
                '一般贸易',
                '进料对口',
                '市场采购',
                '跨境电商',
                '跨境电商B2B直接出口',
                '跨境电商出口海外仓',
                '其他'
            ]
            for(var rowNum=1;rowNum<data.rows.length;rowNum++){
                var row=data.rows[rowNum];
                ckbzData.push({value:row['CKE_YEAR'],name:nameIndex[rowNum]})
                tsbzData.push({value:row['TSE_YEAR'],name:nameIndex[rowNum]})
            }
            ckbzData=tools.pieSelect(ckbzData,10);
            tsbzData=tools.pieSelect(tsbzData,10);
            self.chartOption.series[0].data=tools.clone(ckbzData);
            self.chartOption.series[1].data=tools.clone(tsbzData);
            chart.setOption(tools.clone(self.chartOption));
        },
        saveBB:function(){
            var self=this;
            var params={
                bbdm:self.tcode,
                bbid:self.bbid,
                data:tools.clone(self.tableData.rows)
            }
            ajax("POST","/bjtssw/tjbb/savedata",params).done(function(res){
                if(res.code=='0'){
                    tools.info("保存成功");
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
        degreeTable:function(){
            var self=this;
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
        },
        calTable:function(){
            var self=this;
            if(self.tableOption.linerFormula.length==0&&self.tableOption.headerFormula.length==0){
                self.degreeTable();
                return ;
            }
            this.cleanTable();
            var exliner=[],exheader=[];
            //处理
            for(var i=0;i<self.tableOption.linerFormula.length;i++){
                var str=self.tableOption.linerFormula[i].trim();
                if(str.indexOf('/')>0){
                    exliner.push(str);
                    continue;
                }
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
                        tools.info("计算错误，详细信息："+str)
                    }

                }
            }
            for(var i=0;i<self.tableOption.headerFormula.length;i++){
                var str=self.tableOption.headerFormula[i].trim();
                if(str.indexOf('/')>0){
                    exheader.push(str);
                    continue;
                }
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
                        tools.info("计算错误，详细信息："+str)
                    }
                }
            }
            //处理除法
            for(var i=0;i<exliner.length;i++){
                var str=exliner[i].trim();
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
                        tools.info("计算错误，详细信息："+str)
                    }

                }
            }
            for(var i=0;i<exheader.length;i++){
                var str=exheader[i].trim();
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
                        tools.info("计算错误，详细信息："+str)
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
                        tools.info("计算错误，详细信息："+str)
                    }
                }
            }
            // self.tableData.rows=tools.clone(self.tableData.rows)
            self.degreeTable();
        },

        showHyper:function(){
            $('.bbbbmxb03106 .hyper').toggle();
            $('.bbbbmxb03106 .hyperBtn').toggleClass('active');
        },
        closeHyper:function(){
            $('.bbbbmxb03106 .hyper').hide();
            $('.bbbbmxb03106 .hyperBtn').removeClass('active');
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
            $('.bbmxb03106').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.bbmxb03106').off('click');
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
                    $.fn.zTree.init($(".bbbbmxb03106 .treeDiv"), setting, res.data);
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
            $('.bbbbmxb03106').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.bbbbmxb03106').off('click');
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
            var params=tools.clone(self.modelData);
            params.bbdm=self.tcode;
            ajax("POST","/bjtssw/tjbb/zbxx/save",params).done(function(res){
                if(res.code=='0'){
                    self.hideModel();
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        showModel:function(){
            var self=this;
            var params={
                bbdm:self.tcode
            }
            ajax("POST","/bjtssw/tjbb/zbxx/init",params).done(function(res){
                if(res.code=='0'){
                    self.modelData=res.data;
                    $('.model').show();
                    $('.bbmxb03106 .zbxxModel').show();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })

        },
        hideModel:function(){
            $('.model').hide();
            $('.bbmxb03106 .zbxxModel').hide();
        },

        exform:function(type){
            var self=this;
            var params = {
                bbdm:self.tcode,
                ssny:self.searchData.ssny,
                swjgdm:self.searchData.swjgdm,
                type:type
            }
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
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
        },
        toCellMx: function(data){
            var params = {
                bbdm: this.tcode,
                ssny: this.searchData.ssny,
                location: data.location,
                bblc: data.bblc,
                bbxx: tools.clone(data),
                pageTitle: tools.clone(this.pageTitle),
                type: '1'
            }
            params.pageTitle.push(this.tcode);
            avalonRoot.addTab({title:'报表单元格明细钻取',component:"bbmxzq",params:params});
        },
        getProfile: function(fname,index,x,y,bblc, type){
            var temp = this.defaultData[index][fname]
            if (this.location.indexOf(x+'-'+y)<=-1 || temp==='') {
                return false;
            }
            var self = this
            var params = {
                bbdm: this.tcode,
                x: x,
                y: y
            }
            ajax("POST","/bjtssw/tjbb/mgt/dynamic/profile",params).done(function(res){
                if(res.code=='0'){
                    var mx = res.data
                    mx.bblc = bblc
                    if (type=='1') {
                        var obj = self.tableOption.column[0]
                        var key = obj[Object.keys(obj)[0]]
                        for (var i=0;i<self.defaultData.length;i++) {
                            var item = self.defaultData[i]
                            if (item.BBLC == bblc) {
                                mx.bblcName = item[key]
                            }
                        }
                    }
                    self.toCellMx(mx)
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
        },
        getLocation: function(){
            var self = this
            ajax("POST","/bjtssw/tjbb/dynamic/location",{bbdm: this.tcode, type: '1'}).done(function(res){
                if(res.code=='0'){
                    var lot = res.data.map(item=>item.location)
                    self.location = lot
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
        },
    }
});