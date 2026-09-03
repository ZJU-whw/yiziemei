var wsbgdMx=require("./wsbgdMx.html");
avalon.component('wsbgdMx', {
    template:wsbgdMx,
    defaults: {
        params:{
            bgd_no: "",
        },
        form:{},
        onReady:function(){
            var self = this;
            this.init();
        },
        init:function(){
            var self=this;
            var params={
                lcslid:self.params.lcslid,
                bgd_no: self.params.bgd_no
            }
            ajax("POST","/cxfw/wsbbgdcx/second",params).done(function(res){
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
            $('.wsbgdMx').print();
        },
        count:function(name){
            var sum=0;
            for(var i=0;i<this.form.rows.length;i++){
                if(!isNaN(this.form.rows[i][name])) {
                    sum += this.form.rows[i][name] - 0;
                }
            }
            return sum;
        },
    }
});