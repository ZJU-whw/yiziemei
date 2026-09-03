var htmlTemplate=require("./jdfswh.html");

avalon.component('jdfswh', {
	template:htmlTemplate,
	defaults: {
		params:{},
		formData:{
            id:"",
            swjgDm:"",
            flgl:[],
            jsMode:[],
            sbywbDm:[],
            qybz:"N",
            jdMode:"",
            yjClose:""
		},
        swjgMc:"",
        sbyws:[],
		act:1,
		zsswjg:[],
		onReady:function(){
			this.initTree();
			this.initSbyws();
		},
        setQybz:function(val){
			this.formData.qybz=val;
			this.saveForm();
		},
		search:function(swjgDm){
			if(!swjgDm){
				return ;
			}
			var params={
				swjgDm:swjgDm
			}
			var self=this;
            ajax("POST","/glfw/fpgl/mode/view",params).done(function(res){
                if (res.code == 0) {
                    self.formData ={
                        id:res.data.id||"",
                        swjgDm:res.data.swjgDm||"",
                        flgl:res.data.flgl.split('.')||[],
                        jsMode:res.data.jsMode.split('.')||[],
                        sbywbDm:res.data.sbywbDm.split('.')||[],
                        qybz:res.data.qybz||"",
                        jdMode:res.data.jdMode||"",
                        yjClose:res.data.yjClose||"",
					}
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
		},
        initTree:function(){
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.search(node.id)
                        self.swjgMc=node.text
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.search(node.id)
                        self.swjgMc=node.text
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            ajax("POST","/cxfw/export/readtree",{nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($("#jdfswh-custreeDiv"), setting, res.data);
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
		},
        initSbyws:function(){
		    var self=this;
            ajax("POST","/glfw/sys/getDictInfo",{dtype:"ywlx_dm"}).done(function(res){
                if(res.code=='0'){
                    self.sbyws=res.data;
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
        },
        saveForm:function(){
		    var self=this;
			if(!this.formData.id){
				return ;
			}
			var params=tools.clone(this.formData);
			params.flgl=params.flgl.join('.');
			params.jsMode=params.jsMode.join('.');
			params.sbywbDm=params.sbywbDm.join('.');
            ajax("POST","/glfw/fpgl/mode/update",params).done(function(res){
                if (res.code == "0") {
                    tools.info("操作成功！");
                    self.search();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })

		},
		checkFlgl:function(num){
			var index=this.formData.flgl.indexOf(num);
			if(index>=0){
				this.formData.flgl.splice(0,1);
			}else{
                this.formData.flgl.push(num);
			}
		},
        checkJsMode:function(num){
            var index=this.formData.jsMode.indexOf(num);
            if(index>=0){
                this.formData.jsMode.splice(0,1);
            }else{
                this.formData.jsMode.push(num);
            }
        },
        isCheckedFlgl:function(num){
            if(this.formData.flgl.indexOf(num)>=0){
                return true;
            }else{
                return false
            }
        },
        isCheckedJsMode:function(num){
            if(this.formData.jsMode.indexOf(num)>=0){
                return true;
            }else{
                return false
            }
        },
		$computed:{

		}

	}
});