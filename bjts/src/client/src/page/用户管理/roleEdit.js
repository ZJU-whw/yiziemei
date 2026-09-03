var roleEdit = require("./roleEdit.html");
avalon.component("roleEdit",{
    template: roleEdit,
    defaults: {
        //已拥有角色表格数据
        tableData1: {},
        //角色列表数据
        tableData2: {},
        params: {code: ""},
        formData: {
            rolecode: "",
            rolename: "",
            remark: "",
            isvalid: false
        },
	    menuData: [],
        activeIndex: "0",
        tabs: ["角色信息","配置角色"],

        onReady: function () {
        	var self = this;
            this.setUnderline(0);
            this.findRoleView();
	        var setting = {
		        check: {
			        enable: true,
			        chkboxType: {"Y":"","N":""},
			        chkStyle: "checkbox"
		        },
		        view: {
		        	showIcon: false,
			        selectedMulti: false,
		        },
		        data: {
		        	key: {
		        		checked: "sfyy",
				        isParent: "childflag",
				        name: "pername",
			        }
		        },
		        callback: {
		        	beforeExpand: function(id,node) {
		        		if (node.children) return true;
		        		if (node.childflag == "1") {
					        var params = {
						        rolecode: self.params.code,
						        ppercode: node.id,
						        pertype:"M"
					        }
					        ajax("POST","/auth/rolePerm/tree",params).done(function(res){
						        if(res.code=='0'){
							        var data = res.data;
							        for (var i = 0;i<data.length;i++) {
								        data[i].id = data[i].percode;
								        data[i].sfyy= data[i].sfyy == "1" ? true : false;
								        data[i].childflag= data[i].childflag == "1" ? true : false;
								        data[i].nocheck = data[i].childflag == "1" ? true: false;
							        }
							        $.fn.zTree.getZTreeObj("funcTree").addNodes(node,data);
						        }else{
							        tools.info(res.msg);
						        }
					        }).fail(function(err){
						        tools.info(err);
					        })
				        }
						return true
			        },
		        	onClick: function(a,b,node) {
		        		if (node.childflag == "1" && node.children) return;
				        var params = {
					        rolecode: self.params.code,
					        ppercode: node.id,
					        pertype:node.childflag ? "M" : "F"
				        }
		        		if (node.childflag == "1") {
					        ajax("POST","/auth/rolePerm/tree",params).done(function(res){
						        if(res.code=='0'){
							        var data = res.data;
							        for (var i = 0;i<data.length;i++) {
								        data[i].id = data[i].percode;
								        data[i].sfyy= data[i].sfyy == "1" ? true : false;
								        data[i].childflag= data[i].childflag == "1" ? true : false;
								        data[i].nocheck = data[i].childflag == "1" ? true: false;
							        }
							        $.fn.zTree.getZTreeObj("funcTree").addNodes(node,data);
						        }else{
							        tools.info(res.msg);
						        }
					        }).fail(function(err){
						        tools.info(err);
					        })
				        } else {
					        ajax("POST","/auth/rolePerm/tree",params).done(function(res){
						        if(res.code=='0'){
							        var data = res.data;
							        for (var i = 0;i<data.length;i++) {
								        data[i].parent = node;
								        data[i].sfyy= data[i].sfyy == "1" ? true : false;
							        }
							        self.menuData = data;
						        }else{
							        tools.info(res.msg);
						        }
					        }).fail(function(err){
						        tools.info(err);
					        })
				        }
			        },
					onCheck: function(e,id,node) {
		        		var hasChild = self.menuData && self.menuData.length > 0;
						var matches = hasChild && self.menuData[0].percode.match(/_(.*):/);
						var checked = node.sfyy;
						if (matches && node.percode.indexOf(matches[1])> -1) {
							var len = self.menuData.length;
							self.check(node,true);
							if (checked) {
								for (var i = 0;i <len;i++ ) {
									self.menuData[i].sfyy = true;
								}
							} else {
								for (var i = 0;i <len;i++ ) {
									self.menuData[i].sfyy = false;
								}
							}
						}
						else {
							var params = {
								rolecode: self.params.code,
								ppercode: node.id,
								pertype:node.childflag ? "M" : "F"
							}
							self.check(node,true);
							ajax("POST","/auth/rolePerm/tree",params).done(function(res){
								if(res.code=='0'){
									var data = res.data;
									for (var i = 0;i<data.length;i++) {
										data[i].parent = node;
										data[i].sfyy= data[i].sfyy == "1" ? true : false;
									}
									self.menuData = data;
									var len = self.menuData.length;
									if (checked) {
										for (var i = 0;i <len;i++ ) {
											self.menuData[i].sfyy = true;
										}
									} else {
										for (var i = 0;i <len;i++ ) {
											self.menuData[i].sfyy = false;
										}
									}
								}else{
									tools.info(res.msg);
								}
							}).fail(function(err){
								tools.info(err);
							})
						}

					}
		        }
	        };
	        var params = {
	        	rolecode: this.params.code,
		        ppercode: "M_ROOT",
		        pertype:"M"
	        }
	        var self = this;
	        ajax("POST","/auth/rolePerm/tree",params).done(function(res){
		        if(res.code=='0'){
			        var data = res.data;
			        for (var i = 0;i<data.length;i++) {
			        	data[i].id = data[i].percode;
			        	data[i].sfyy= data[i].sfyy == "1" ? true : false;
			        	data[i].childflag= data[i].childflag == "1" ? true : false;
			        	data[i].nocheck = data[i].childflag == "1" ? true : false;
			        }
			        $.fn.zTree.init($("#funcTree"), setting, data);
		        }else{
			        tools.info(res.msg);
		        }
	        }).fail(function(err){
		        tools.info(err);
	        })

        },
        handleClick: function (index) {
            this.activeIndex = index;
            this.setUnderline(index)
        },
        //设置激活的tab底部横条的位置和宽度
        setUnderline: function(index) {
            var width = $(".roleEdit .tabs-item:eq("+index+")").outerWidth();
            var offsetX = this.calcOffset(index);
            $(".roleEdit .tabs-underline").width(width);
            $(".roleEdit .tabs-underline").css("left",offsetX+"px");
        },
        //计算第n个tab项的相对于父元素的横向偏移量
        calcOffset: function (index) {
            var parentOffset = $(".roleEdit .tabs-list").offset();
            var childOffset = $(".roleEdit .tabs-item:eq("+index+")").offset();
            return childOffset.left - parentOffset.left;
        },
        findRoleView: function() {
            var self = this;
            ajax("POST","/auth/role/view",this.params).done(function(res){
                if(res.code=='0'){
                    self.formData = res.data;
                    self.formData.isvalid = res.data.isvalid == "1" ? true : false;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
	    check: function (node,checkAll) {
        	var self = this;
        	var params = {
        		rolecode: self.params.code,
		        percode: node.percode,
		        pertype: checkAll ? "M" : "F"
	        };
	        var url = node.sfyy ? "/auth/rolePerm/add" : "/auth/rolePerm/del";
		    ajax("POST",url,params).done(function(res){
			    if(res.code=='0'){

			    }else{
				    tools.info(res.msg);
			    }
		    }).fail(function(err){
			    tools.info(err);
		    })
	    },
	    onChange: function(item) {
        	var self = this;
        	var noChecked = self.menuData.every(function(el) {
        		return !el.sfyy;
	        })
		    var allChecked = self.menuData.every(function(el) {
			    return el.sfyy;
		    })
		    var parentNode = item.parent;
		    if (noChecked) {
		        parentNode.sfyy = false
			    	// $.fn.zTree.getZTreeObj("funcTree").updateNode(parentNode,false);
		        // self.check(parentNode,true)
		        self.check(item,true)
		    } else {
		    	parentNode.sfyy = true;
			    $.fn.zTree.getZTreeObj("funcTree").updateNode(parentNode,false);
			    if (allChecked) {
				    self.check(parentNode,true)
			    } else {
			    	self.check(item,false);
			    }
		    }
	    },
	    getTreeNode: function() {
		    var self = this;
		    ajax("POST","/auth/role/view",this.params).done(function(res){
			    if(res.code=='0'){
				    self.formData = res.data;
				    self.formData.isvalid = res.data.isvalid == "1" ? true : false;
			    }else{
				    tools.info(res.msg);
			    }
		    }).fail(function(err){
			    tools.info(err);
		    })
	    },
	    saveInfo: function() {
		    var self = this;
		    if (!this.formData.rolename) {
			    tools.info("角色名称不能为空");
			    return
		    }
		    var params = {};
		    params.rolecode = this.formData.rolecode;
		    params.rolename= this.formData.rolename;
		    params.remark = this.formData.remark;
		    params.isvalid = this.formData.isvalid ? "1" : "0";
		    ajax("POST","/auth/role/update",params).done(function(res){
			    if(res.code=='0'){
				    tools.info("更新成功")
			    }else{
				    tools.info(res.msg);
			    }
		    }).fail(function(err){
			    tools.info(err);
		    })
	    }
    }
})