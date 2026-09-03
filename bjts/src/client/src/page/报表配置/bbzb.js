var bbzb=require("./bbzb.html");
avalon.component('bbzb', {
    template:bbzb,
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

        addRow:function(){
            var self=this;
            this.tableData.push({
                bbdm:self.params.bbdm,
                bblc:"",
                lcmc:"",
                showorder:"",
                hztype:"",
                hzobj:"",
                xlsrow:"",
                allowupdate:"Y",
                qybj:"",
            })
        },
        search:function(pageNo){
            var self=this;
            var params=tools.clone(self.searchData);
            ajax("POST","/bjtssw/tjbb/mgt/item",params).done(function(res){
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
            ajax("POST","/bjtssw/tjbb/mgt/item/update",params).done(function(res){
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
    }
});