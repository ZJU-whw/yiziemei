var bbgs=require("./bbgs.html");
avalon.component('bbgs', {
    template:bbgs,
    defaults: {
        params:{
            bbdm:""
        },
        searchData:{
            bbdm:""
        },
        tableData:[],

        onReady:function(){
            var self = this;
            self.searchData.bbdm=self.params.bbdm
            self.search(1)
        },

        search:function(pageNo){
            var self=this;
            var params=tools.clone(self.searchData);
            ajax("POST","/bjtssw/tjbb/mgt/formula",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        saveTable:function(){
            var self=this;
            var params={
                data:tools.clone(self.tableData)
            }
            ajax("POST","/bjtssw/tjbb/mgt/formula/update",params).done(function(res){
                if(res.code=='0'){
                    tools.info('保存成功')
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        openEdit:function(){
            var self=this;
            avalonRoot.addTab({title:"报表公式编辑",component:"gsbj",sameCheck:true,params:{bbdm:self.searchData.bbdm}});
        },
        delGs:function(id){
            var self=this;
            var params={
                id:id,
            }
            ajax("POST","/bjtssw/tjbb/mgt/formula/del",params).done(function(res){
                if(res.code=='0'){
                    tools.info('操作成功')
                    self.search(1);
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