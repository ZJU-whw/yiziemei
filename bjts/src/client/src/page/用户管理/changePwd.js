var changePwd = require("./changePwd.html");

avalon.component("changePwd",{
    template: changePwd,
    defaults: {
        currentPwd: "",
        firstPwd: "",
        secondPwd: "",
        submit: function () {
            var self = this;
            if (!this.currentPwd) {
                tools.info("请输入原密码");
                return;
            } else if (!this.firstPwd) {
                tools.info("请输入新密码");
                return;
            } else if (!this.secondPwd) {
                tools.info("请再次输入新密码");
                return;
            } else if (this.firstPwd != this.secondPwd) {
                tools.info("新密码两次输入不一致，请重新输入");
                return;
            }
            var params = {
                currentPwd: this.currentPwd,
                firstPwd: this.firstPwd,
                secondPwd: this.secondPwd,
            };
            ajax("POST","/auth/user/changePwd",params).done(function(res){
                if(res.code=='0'){
                    $(".pwd-warn").text("");
                    $(".pwd-warn").parent().hide();
                    tools.info("密码修改成功");
                }else{
                    $(".pwd-warn").text(res.msg);
                    $(".pwd-warn").parent().show();
                }
            }).fail(function(err){
                tools.info(err);
            })
        }
    }
})