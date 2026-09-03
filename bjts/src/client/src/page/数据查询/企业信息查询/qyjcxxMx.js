var qyjcxxMx=require("./qyjcxxMx.html");
avalon.component('qyjcxxMx', {
    template:qyjcxxMx,
    defaults: {
        params:{
            nsrdj_no:""
        },
        form:{

        },
        onReady:function(){
            var self = this;
            this.init();

        },
        init:function(){
            var self=this;
            var params={
                nsrdj_no:self.params.nsrdj_no,
                pageSize:20,
                pageNo:1
            }
            ajax("POST","/cxfw/qyxxcx/second",params).done(function(res){
                if(res.code=='0'){
                    self.form=res.data;
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },

        printForm:function(e){
            $('.qyjcxxMx').print();
        }
    }
});