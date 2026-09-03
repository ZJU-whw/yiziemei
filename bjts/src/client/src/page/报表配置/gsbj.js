var gsbj=require("./gsbj.html");
avalon.component('gsbj', {
    template:gsbj,
    defaults: {
        params:{
            bbdm:""
        },
        searchData:{
            bbdm:""
        },
        tableData:{
            cols:[],
            rows:[]
        },
        form:{
            colContent:"",
            rowContent:""
        },
        onReady:function(){
            var self = this;
            self.searchData.bbdm=self.params.bbdm
            self.search(1)
        },

        search:function(pageNo){
            var self=this;
            var params=tools.clone(self.searchData);
            ajax("POST","/bjtssw/tjbb/mgt/formula/list",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        editRow:function(item){
            if(this.form.rowContent==''){
                this.form.rowContent+='('+item.bh+')';
                this.form.rowContent+='=';
            }else{
                this.form.rowContent+='('+item.bh+')';
            }
            $('#rowContent').focus()
        },
        resetRow:function(){
            this.form.rowContent='';
        },
        saveRow:function(){
            var self=this;
            if(self.form.rowContent==""){
                return ;
            }
            var params={
                bbdm:this.searchData.bbdm,
                type:2,
                formula:this.form.rowContent
            }
            ajax("POST","/bjtssw/tjbb/mgt/formula/save",params).done(function(res){
                if(res.code=='0'){
                    tools.info('保存成功');
                    self.form.rowContent='';
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        editCol:function(item){
            if(this.form.colContent==''){
                this.form.colContent+='('+item.fname+')'
                this.form.colContent+='='
            }else{
                this.form.colContent+='('+item.fname+')'
            }
            $('#colContent').focus()
        },
        resetCol:function(){
            this.form.colContent='';
        },
        saveCol:function(){
            var self=this;
            if(self.form.colContent==""){
                return ;
            }
            var params={
                bbdm:this.searchData.bbdm,
                type:1,
                formula:this.form.colContent
            }
            ajax("POST","/bjtssw/tjbb/mgt/formula/save",params).done(function(res){
                if(res.code=='0'){
                    tools.info('保存成功');
                    self.form.colContent='';
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        exform:function(){
            var self=this;
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            // form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/bjtssw/export/qyxx");
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