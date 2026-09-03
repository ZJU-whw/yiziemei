var tsgzsz = require("./tsgzsz.html");
avalon.component("tsgzsz",{
	template: tsgzsz,
	defaults: {
		opts1:[],
		opts2:[],
		opts3:[],
		opts4:[],
		formData: {
			swjgmc:"",//税务机关名称

            defaultSet:{
                bktgydMc:"",
                ktgydMc:"",
                wydMc:"",
                lsbMc:"",
			},
            customSet:{
                bktgyd:"", //不可挑过疑点(岗位代码)
                bktgydMc:"",//不可挑过疑点(岗位名称)
                ktgyd:"",//可挑过疑点(岗位代码)
                ktgydMc:"",//可挑过疑点(岗位名称)
                wyd:"",//无疑点(岗位代码)
                wydMc:"",//无疑点(岗位名称)
                lsb:"",//零申报(岗位代码)
                lsbMc:""//零申报(岗位名称)
			}

		},
		onReady: function() {
			var self=this;
			this.initOpts();
			ajax("POST","/glfw/ydfltssz/select",{}).done(function(res){
				if(res.code=="0"){
					self.formData=res.data;
				}else{
					tools.info(res.msg)
				}

			}).fail(function(err){
				tools.info(err);
			})
		},
        initOpts:function(){
			this.initOpt(1);
			this.initOpt(2);
			this.initOpt(3);
			this.initOpt(4);
		},
        initOpt:function(num){
			var self=this;
            ajax("POST","/glfw/ydfltssz/getCustom",{ydjb:num}).done(function(res){
                if(res.code=="0"){
                    switch (num){
						case 1:
							self.opts1=res.data;
							break;
						case 2:
                            self.opts2=res.data;
                            break;
						case 3:
                            self.opts3=res.data;
                            break;
						case 4:
                            self.opts4=res.data;
                            break;
					}
                }else{
                    tools.info(res.msg)
                }

            }).fail(function(err){
                tools.info(err);
            })
		},
		/**
		 * @Description: ydjb疑点类型，gwdm岗位代码
		 * @author LongSX
		 * @date 2020/3/11
		*/
		handleChange: function(ydjb,e) {
			var gwdm = e.target.value;
			if(gwdm==""){
				return ;
			}
			ajax("POST","/glfw/ydfltssz/save",{ydjb:ydjb,gwdm:gwdm}).done(function(res){
				if(res.code=="0"){
					tools.info("设置成功");
				}else{
					tools.info(res.msg)
				}
			}).fail(function(err){
				tools.info(err);
			})
		}
	}
})