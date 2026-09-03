var blqk=require("./blqk.html");
avalon.component('blqk', {
    template:blqk,
    defaults: {
        params:{},
        act:1,
        swjgmc: "",
        page: 1,
        searchData:{
            swjgdm: "",
            ny: "",
            pageNo: 1,
            pageSize:config.pageSize,
        },
        blqkList: [],
        onReady:function(){
            var self = this;
            try {
                this.searchData.swjgdm = avalonRoot.user.swjgDm;
                this.swjgmc = avalonRoot.user.swjgMc;
            } catch (e) {

            }
            self.initNy();
            self.initTree();
            $('.blqk .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.blqk .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });
        },
        initNy: function(){
            var self = this;
            var now = new Date();
            var year = now.getFullYear();
            var month = now.getMonth()+1;
            month<10? month='0'+month: null;
            self.searchData.ny = '' + year + month;
        },
        search:function(){
            var self=this;
            if(!self.searchData.ny){
                tools.info('查询条件“退税申报年月”不可为空。');
                return
            }
            this.searchData.pageSize = $(".ui-pg-selbox", $('.blqk')).val() || 20;
            var params=tools.clone(self.searchData);
            ajax("POST","/cxfw/blqkcx/list",params).done(function(res){
                if(res.code=='0'){
                    self.blqkList = res.data;
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
        exform:function(){
            var self=this;
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/cxfw/export/blqkcx");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
        blqkSave: function(){
            var self = this;
            ajax("POST","cxfw/blqkcx/save", {list: self.blqkList}).done(function(res){
                tools.info(res.msg);
            }).fail(function(err){
                tools.info(err);
            })
        },
	    reset: function() {
            this.searchData = {
                swjgdm: "",
                ny: "",
                pageNo: 1,
                pageSize:config.pageSize,
            };
            this.initNy();
            this.searchData.swjgdm = avalonRoot.user.swjgDm;
            this.swjgmc = avalonRoot.user.swjgMc;
        },
        byxdjheChanged: function(e, index){
            var self = this;
            self.calByjhzeVal(index);
            self.calByjhyeVal(index);
            self.calByjhwclVal(index);
        },
        syjzjheChanged: function(e, index){
            var self = this;
            self.calByjhzeVal(index);
            self.calByjhyeVal(index);
            self.calByjhwclVal(index);
        },
        byzhcktseChanged: function(e, index){
            var self = this;
            self.calByjhzeVal(index);
            self.calByjhyeVal(index);
            self.calByjhwclVal(index);
        },
        byjhzeChanged: function(e, index){
            var self = this;
            self.calByjhyeVal(index);
            self.calByjhwclVal(index);
        },
        calByjhzeVal: function(index){
            var self = this;
            self.blqkList[index]['byjhze'] = self.formatNumber(self.blqkList[index]['byxdjhe']) + self.formatNumber(self.blqkList[index]['syjzjhe']) + self.formatNumber(self.blqkList[index]['byzhcktse']);
        },
        calByjhyeVal: function(index){
            var self = this;
            self.blqkList[index]['byjhye'] = self.formatNumber(self.blqkList[index]['byjhze']) - self.formatNumber(self.blqkList[index]['byybltse']);
        },
        calByjhwclVal: function(index){
            var self = this;
            if(self.blqkList[index]['byjhze']==0){
                self.blqkList[index]['byjhwcl'] = '0';
                return
            }
            var byjhwcl = Math.round(10000.0 * self.formatNumber(self.blqkList[index]['byybltse']) / self.formatNumber(self.blqkList[index]['byjhze']))/100;
            self.blqkList[index]['byjhwcl'] = byjhwcl;
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
                $.fn.zTree.init($(".blqk .treeDiv"), setting,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.blqk').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.blqk').off('click');
        },
        formatNumber: function(num){
            return isNaN(Number(num))? 0: Number(num);
        }
    }
});