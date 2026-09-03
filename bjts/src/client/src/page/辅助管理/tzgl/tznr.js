var tznr = require("./tznr.html");
avalon.component("tznr",{
    template: tznr,
    defaults:{
        params: {noticeid: ""},
        formData: {
            main:{
                title:"",
                release_time:"",
                release_user:"",
                release_swjgmc:"",
                content:"",
            },
            attach:[]
        },
        onReady: function () {
            this.search();
        },
        search: function () {
            var self = this;
            var params = {noticeid: this.params.noticeid}
            ajax("POST","/glfw/tztx/select/second",params).done(function(res){
                if(res.code=='0'){
                    self.formData = res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        loadFile: function (id) {
            var self = this;
            ajax("POST","/glfw/qytz/downloadDoc",{fileid:id}).done(function(res){
                if(res.code=='0'){
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            });
        }
    }
});