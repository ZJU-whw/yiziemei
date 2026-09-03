var bbzdedit=require("./bbzdedit.html");
avalon.component('bbzdedit', {
    template:bbzdedit,
    defaults: {
        params:{
            bbdm:""
        },
        searchData:{
            bbdm:""
        },
        tableData:[],
        options:[],
        onReady:function(){
            var self = this;
            self.searchData.bbdm=self.params.bbdm
            self.search(1)
            self.getOptions();
        },

        chgOption:function(e,index){
            var self=this;
            var target=e.target;
            var optionIndex=$(target).val();
            if(optionIndex==""){
                self.tableData[index].fname="";
                self.tableData[index].ftype="";
                self.tableData[index].maxlen="";
                self.tableData[index].degree="";
                return ;
            }
            for(var i=0;i<self.options.length;i++){
                if(self.options[i].fname==optionIndex){
                    break;
                }
            }
            var option=self.options[i]
            self.tableData[index].fname=option.fname;
            self.tableData[index].ftype=option.ftype;
            self.tableData[index].maxlen=option.maxlen;
            self.tableData[index].degree=option.degree;
            if(self.tableData[index].ftype=='NUMBER'){
                self.tableData[index].allowformula="Y"
                self.tableData[index].allowsum="Y"

            }else{
                self.tableData[index].allowformula="N"
                self.tableData[index].allowsum="N"
                self.tableData[index].hztype=""
                self.tableData[index].hzobj=""
            }
        },
        addRow:function(){
            var self=this;
            this.tableData.push({
                bbdm:self.params.bbdm,
                fname:"",
                cname:"",
                ftype:"NUMBER",
                maxlen:"",
                degree:"",
                showorder:"",
                xlscol:"",
                allowupdate:"Y",
                allowformula:"Y",
                allowsum:"Y",
                hztype:"",
                hzobj:"",
                note:"",
                align:"2",
                isAdd:"1"
            })
        },
        search:function(pageNo){
            var self=this;
            var params=tools.clone(self.searchData);
            ajax("POST","/bjtssw/tjbb/mgt/column",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        getOptions:function(){
            var self=this;
            var params=tools.clone(self.searchData);
            ajax("POST","/bjtssw/tjbb/mgt/columntype/list",params).done(function(res){
                if(res.code=='0'){
                    self.options=res.data;
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
            ajax("POST","/bjtssw/tjbb/mgt/column/update",params).done(function(res){
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
        delZd:function(id){
            var self=this;
            var params={
                bbdm:self.params.bbdm,
                id:id
            }
            ajax("POST","/bjtssw/tjbb/mgt/column/del",params).done(function(res){
                if(res.code=='0'){
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