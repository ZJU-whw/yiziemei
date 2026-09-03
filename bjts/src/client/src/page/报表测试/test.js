var test=require("./test.html");
avalon.component('test', {
    template:test,
    defaults: {
        params:{
            bbdm:""
        },
        act:1,
        tcode:"B03201",
        searchData:{
            ssny:"2019",
            orderSql:"",
            pageSize:config.pageSize,
        },
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
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{
            rows:[]
        },
        editData: {
        
        },
        isShow: false,
        setData:{
            zczt:"",
            ktpt:""
        },
        location: [],
        isValid: [],
        onInit:function(e){
            avalonRoot.test = e.vmodel;
        },
        onReady:function(){
            this.searchData.tsjg=avalonRoot.user.swjgDm;
            var self = this;
            self.tcode=self.params.bbdm
            this.initForm();
            self.initTree();
            $('.bbtest .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.bbtest .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });
            $('#bbtest-fileupload').fileupload({
                dataType: 'json',
                done: function (e, data) {
                    if(data.result.code == "0"){
                        tools.info("导入成功!");
                    }else{
                        tools.info(data.result.msg);
                    }
                }
            });
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
        initTable:function(){
            var self=this;
            ajax("POST","/bjtssw/tjbb/profile/header",{bbdm:self.tcode}).done(function(res){
                if(res.code=="0"){
                    self.tableOption=res.data;
                    $('.table-head-wrapper').height($('.table-head-wrapper .table thead').height()+'px');
                    self.htmlPropertysetting()
                    self.getLocation()
                }else{
                    tools.info(res.msg)
                }
                    
            }).fail(function(err){
                tools.info(err);
            })
        },


        showHyper:function(){
            $('.bbtest .hyper').toggle();
            $('.bbtest .hyperBtn').toggleClass('active');
        },
        closeHyper:function(){
            $('.bbtest .hyper').hide();
            $('.bbtest .hyperBtn').removeClass('active');
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
            $('.bbtest').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.bbtest').off('click');
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
                    $.fn.zTree.init($(".bbtest .treeDiv"), setting, res.data);
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
            $('.bbtest').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.bbtest').off('click');
        },
        exform:function(){
            var self=this;
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            // form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/bjtssw/export/testcx");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
        setupInstruction: function(e){
            var params = JSON.parse(e.currentTarget.dataset.params)
            this.getProfile(params.bbdm, params.x, params.y)
        },
        getProfile: function(bbdm,x,y){
            var self = this
            var params = {
                bbdm: bbdm,
                x: x,
                y: y
            }
            ajax("POST","/bjtssw/tjbb/mgt/dynamic/profile",params).done(function(res){
                if(res.code=='0'){
                    self.showModel()
                    self.editData = res.data
                    self.editData.isValid = self.editData.isValid || '0'
                    self.editData.dbTarget = self.editData.dbTarget || '1'
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
        },
        showModel:function(){
            $('.model').show()
            $('.page-model-setzq').show()
            this.isShow = true
        },
        hideModel:function(){
            $('.model').hide()
            $('.page-model-setzq').hide()
            this.isShow = false
        },
        saveModel: function(isReview){
            var self = this
            if (this.editData.sqlScript == '') {
                tools.info('请输入SQL脚本！')
                return false;
            }
            ajax("POST","/bjtssw/tjbb/mgt/dynamic/save",this.editData).done(function(res){
                if(res.code=='0'){
                    if (!isReview) {
                        self.hideModel()
                    } else {
                        self.review()
                    }
                    self.getLocation()
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
        },
        getLocation: function(){
            var self = this
            ajax("POST","/bjtssw/tjbb/dynamic/location",{bbdm: this.tcode, type: '0'}).done(function(res){
                if(res.code=='0'){
                    var data = res.data
                    self.location = []
                    self.isValid = []
                    for(var k=0;k<data.length;k++) {
                        self.location.push(data[k].location)
                        self.isValid.push(data[k].isValid)
                    }
                    self.htmlPropertysetting()
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
        },
        htmlPropertysetting: function(){
            var rowTr = $('.bbtest .testTableRowtr')
            $('.bbtest td').remove('.tableDataCellTd')
            for(var i=0;i<this.tableOption.liner.length;i++) {
                var item = rowTr.eq(i)
                var appendHtml = ''
                for(var j=0;j<this.tableOption.column.length;j++) {
                    var x = i+1
                    var y = j+1
                    var params = JSON.stringify({
                        bbdm: this.tcode,
                        x: x,
                        y: y
                    })
                    var lotIndex = this.location.indexOf(x+'-'+y)
                    var tmpHtml = '<td class="tableDataCellTd text-center" data-params='+params+'>'
                    +( lotIndex > -1 ?'<span class="'+(this.isValid[lotIndex]=='1'?'text-blue':'text-red')+'">钻取配置</span>': '')
                    +'</td>'
                    appendHtml += tmpHtml
                }
                item.append(appendHtml)
                item.off('click').on('click','td', this.setupInstruction)
            }
        },
        review: function() {
            var params = {
                bbdm: this.tcode,
                ssny: '',
                location: this.editData.location,
                bbmc: this.form.bbmc,
                pageTitle: ['钻取预览', this.form.bbmc, this.tcode],
                bbxx: this.editData,
                type: 0 // 预览
            }
            $('.model').hide()
            avalonRoot.addTab({title:'钻取预览',component:"bbmxzq",params:params});
        }
    }
});