var bbmx=require("./bbmx.html");
avalon.component('bbmx', {
    template:bbmx,
    defaults: {
        params:{
            bbdm:"",
            bbid:"",
            bbmc:"",
            ssny:"",
            swjgdm:"",
            swjgmc:"",
            pageTitle:[],
        },
        pageTitle:[],
        TZswitch:"",
        act:1,
        readyFlag:false,
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
            qt:"",
        },
        timer:null,
        tableArr:[],
        tableOption:{
            column:[],
            header:[],
            headerFormula:[],
            liner:[],
            linerFormula:[]
        },
        tableData:{
            count:0,
            records:0,
            rows:[],
            total:0
        },
        defaultData: [],
        cleanTableData:[],
        delBblcs:[],
        setData:{
            zczt:"",
            ktpt:""
        },
        activeRow:"",
        activeCol:"",
        location: [],
        onReady:function(){
            this.tcode=this.params.bbdm;
            this.bbid=this.params.bbid;
            this.searchData.ssny=this.params.ssny;
            this.TZswitch=this.params.TZswitch;
            this.searchData.swjgdm=this.params.swjgdm;
            this.searchData.swjgmc=this.params.swjgmc;
            this.pageTitle=tools.clone(this.params.pageTitle);
            var self = this;

            if(self.isIE()){
                self.IEFlag=true;
            }else{
                self.IEFlag=false;
            }
            this.initForm();
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
                    // self.printTableHead(res.data);
                    self.tableOption=res.data;
                    if(self.form.bbtype!='1'){
                        setTimeout(function(){
                            $('.page.active .table-head-wrapper').height($('.page.active .table-head-wrapper .table thead').height()+'px');
                        },0)
                    }
                    self.getLocation()
                    self.search(1)
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
                    self.tableData=tools.clone(res.data);
                    self.defaultData = tools.clone(res.data.rows)
                    self.currentPage=page;
                    $(".bbmx .table-body-wrapper").scroll(function () {
                        $(".bbmx .table-head-wrapper").scrollLeft($(".table-body-wrapper").scrollLeft())
                    })
                    self.scFlag=true;
                    if(!self.readyFlag){
                        self.readyFlag=true;
                    }
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        initCleanTableData:function(){
            var self=this;
            self.cleanTableData=[];
            for(var i=0;i<self.tableData.rows.length;i++){
                var row=[];
                for(var j=0;j<self.tableOption.column.length;j++){
                    var colName=self.tableOption.column[j].fname;
                    row.push(self.tableData.rows[i][colName])
                }
                self.cleanTableData.push(row);
            }
        },
        getCleanTableData:function(){
            var self=this;
            for(var i=0;i<self.tableData.rows.length;i++){
                for(var j=0;j<self.tableOption.column.length;j++){
                    var colName=self.tableOption.column[j].fname;
                    self.cleanTableData[i][j]=self.tableData.rows[i][colName];
                }
            }
        },
        setCleanTableData:function(){
            var self=this;
            for(var i=0;i<self.tableData.rows.length;i++){
                for(var j=0;j<self.tableOption.column.length;j++){
                    var colName=self.tableOption.column[j].fname;
                    self.tableData.rows[i][colName]=self.cleanTableData[i][j];
                }
            }
        },
        saveBB:function(){
            var self=this;
            // if(self.IEFlag){
            //     self.setCleanTableData();
            // }
            var params={
                bbdm:self.tcode,
                bbid:self.bbid,
                data:tools.clone(self.tableData.rows),
                ssny:self.searchData.ssny,
                delBblcs:self.delBblcs
            }

            ajax("POST","/bjtssw/tjbb/savedata",params).done(function(res){
                if(res.code=='0'){
                    tools.info("保存成功");
                    self.delBblcs=[];
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        delRow:function() {
            var self=this;
            var rows=$('.bbmx .table-body-wrapper tbody tr')
            var index=null;
            for(var i=0;i<rows.length;i++){
                if($(rows[i]).hasClass('active')){
                    index=i;
                }
            }
            if(index===null){
                tools.info("请先选择一行！");
                return ;
            }
            var tableD=tools.clone(self.tableData);
            var delR=tableD.rows.splice(index,1)[0];
            self.tableData=tableD;
            if(!delR.isAdd){
                self.delBblcs.push(delR.BBLC);
            }
        },
        myActiveCell:function(index,col){
            this.activeRow=index;
            this.activeCol=col.fname;
        },
        myActiveRow:function(e){
            var target=e.target;
            $(".bbmx .table .active").removeClass('active');
            if(target.nodeName=='INPUT'){
                $(target).parent().parent().parent().addClass('active');
            }else if(target.nodeName=='DIV'){
                $(target).parent().parent().addClass('active');
            }else if(target.nodeName=='TD'){
                $(target).parent().addClass('active');
            }else if(target.nodeName=='TR'){
                $(target).addClass('active');
            }
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
        showMenu:function(e){
            var self=this;
            $(".dropdown-menu",e.target).show();
            $('.bbmx').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.bbmx').off('click');
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
                    $('.bbmx .zbxxModel').show();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })

        },
        hideModel:function(){
            $('.model').hide();
            $('.bbmx .zbxxModel').hide();
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
        $computed:{
            rowCheck:function(){
                // console.log(this.tcode)
                var self=this;
                var f1;
                var arr=["B02101", "B03107", "B03103", "B03110","B03114"];
                if(arr.indexOf(self.tcode)>=0){
                    f1=false;
                }else {
                    f1=true;
                }
                // console.log(self.TZswitch=='1'&&self.form.bbtype!='1'&&f1)
                if(self.TZswitch=='1'&&self.form.bbtype!='1'&&f1){
                    return true
                }else{
                    return false
                }
            }
        }
    }
});