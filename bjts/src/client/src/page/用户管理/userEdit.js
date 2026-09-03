var userEdit = require("./userEdit.html");

avalon.component("userEdit",{
    template: userEdit,
    defaults: {
        tableData1: {},
        tableData2: {},
        tableData3: {},
        tableData4: {},
        params: {id: ""},
        formData: {
            id:"",
            czryMc: "",
            czryDm:"",
            password:"",
            swjgDm: "",
            lxrdh: "",
            qybz: false,
            isSuper: ''
        },
        currentRolecode: '',
        currentRolename: '',
        activeIndex: "0",
        tabs: [
            {index: 0, name: '基本信息'},
            {index: 2, name: '配置角色'}
        ],
        tabs2: [
            {index: 0, name: '基本信息'},
            {index: 1, name: '配置用户组'},
            {index: 2, name: '配置角色'}
        ],
        onReady: function () {
            this.setUnderline(0);
        //    设置table-wrapper的高度
            var h = $(".userEdit .page").height() -60;
            $(".userEdit .table-wrapper").css("height",h/2+"px");
            this.findUserView();
            this.createTable3();
            this.createTable4();
        },
        handleClick: function (index, underlineIndex) {
            this.activeIndex = index;
            this.setUnderline(underlineIndex)
        },
        //设置激活的tab底部横条的位置和宽度
        setUnderline: function(index) {
            var width = $(".userEdit .tabs-item:eq("+index+")").outerWidth();
            var offsetX = this.calcOffset(index);
            $(".userEdit .tabs-underline").width(width);
            $(".userEdit .tabs-underline").css("left",offsetX+"px");
        },
        //计算第n个tab项的相对于父元素的横向偏移量
        calcOffset: function (index) {
            var parentOffset = $(".userEdit .tabs-list").offset();
            var childOffset = $(".userEdit .tabs-item:eq("+index+")").offset();
            return childOffset.left - parentOffset.left;
        },
        findUserView: function() {
            var self = this;
            ajax("POST","/auth/user/view",this.params).done(function(res){
                if(res.code=='0'){
                    res.data.lxrdh = res.data.lxrdh || '';
                    self.formData = res.data;
                    self.formData.qybz = res.data.qybz == "1" ? true : false;
                    if (self.formData.isSuper == 'Y') {
                        self.tabs = self.tabs2
                        self.createTable1();
                        self.createTable2();
                    }
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        //保存基本信息
        saveInfo: function() {
            if (!this.formData.czryDm) {
                tools.info("用户代码不能为空");
                return;
            }
            if (!(/^[0-9a-zA-Z]+$/.test(this.formData.czryDm))) {
                tools.info("用户代码只能为数字与字母组合");
                return
            }
            if (!this.formData.czryMc) {
                tools.info("用户名称不能为空");
                return
            }
            // if (!this.formData.password) {
            //     tools.info("用户密码不能为空");
            //     return
            // }
            if (!(/^\d{11}$/.test(this.formData.swjgDm))) {
                tools.info("税务机关只能为11位数字");
                return
            }
            this.formData.lxrdh = this.formData.lxrdh.trim();
            if(this.formData.lxrdh){
                var checkMsg = tools.checkPhone(this.formData.lxrdh);
                if(checkMsg) {
                    tools.info(checkMsg);
                    return
                };
            }
            var params = {};
            params.qybz = this.formData.qybz ? "1" : "0";
            params.id = this.formData.id;
            params.czryMc = this.formData.czryMc;
            params.czryDm = this.formData.czryDm;
            // params.password = this.formData.password;
            params.swjgDm = this.formData.swjgDm;
            params.lxrdh = this.formData.lxrdh;
            ajax("POST","/auth/user/update",params).done(function(res){
                if(res.code=='0'){
                    tools.info("更新成功")
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        //创建现有用户组表格
        createTable1:function(){
            var self=this;
            var columns = [
                { name: "code", label: "用户组代码", index: "code", width: 100, align:"left",sortable: false },
                { name: "name", label: "用户组名称", index: "name",width: 200, align:"left",sortable: false },
                { name: "isvalid", label: "是否启用", index: "isvalid",width: 100, align:"center",sortable: false ,formatter:function (cellvalue) {
                        return cellvalue == "1" ? "已启用" : "未启用"
                    }},
                { name: "", label:"操作", width:100, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(){
                        return "<div class='btn danger delete' style='float: none;display: inline-block;'>删除</div>"
                    }},
            ];
            $("#current-user-group").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#current-user-group-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
	            rowList: [20,50,100,500],
                height:(function(){
                    return $(".userEdit .table-wrapper").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('delete')){
                        var code = self.tableData1.rows[rowid-1].code;
                        tools.confirm("是否删除该用户组","确定",function(){
                            self.delGroup(code);
                        });
                        return false;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }

                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo2(pgButton,"current-user-group-pager");
                    self.searchCurrentGroup(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            self.searchCurrentGroup(1);
        },
        //根据用户组id删除用户组
        delGroup: function(groupcode) {
            var self = this;
            var params = {czyid: this.params.id,groupcode};
            ajax("POST","/auth/userGroup/del",params).done(function(res){
                if(res.code=='0'){
                    self.searchCurrentGroup(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        searchCurrentGroup: function(pageNo) {
            var self=this;
            var params =  {
                pageSize: $(".ui-pg-selbox", $("#current-user-group-pager")).val(),
                pageNo,
                id: this.params.id
            };
            $("#current-user-group").jqGrid('clearGridData')
            ajax("POST","/auth/userGroup/list",params).done(function(res){
                if(res.code=='0'){
                    $("#current-user-group").resetSelection();
                    $("#current-user-group")[0].addJSONData(res.data);
                    self.tableData1=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
    //    创建用户组列表表格
        createTable2: function () {
            var self=this;
            var columns = [
                { name: "code", label: "用户组代码", index: "code",width: 100, align:"left",sortable: false },
                { name: "name", label: "用户组名称", index: "name",width: 200, align:"left",sortable: false },
                { name: "isvalid", label: "是否启用", index: "isvalid",width: 100, align:"center",sortable: false ,formatter:function (cellvalue) {
                        return cellvalue == "1" ? "已启用" : "未启用"
                    }},
                { name: "", label:"操作", width:100, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(){
                        return "<div class='btn add' style='float: none;display: inline-block;'>添加</div>"
                    }},
            ];
            $("#user-group").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#user-group-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".userEdit .table-wrapper").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('add')){
                        var code = self.tableData2.rows[rowid-1].code;
                        self.addGroup(code);
                        return false;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }

                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo2(pgButton,"user-group-pager");
                    self.searchGroupList(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            self.searchGroupList(1);
        },
        //根据用户组id添加用户组
        addGroup: function (groupcode) {
            var self = this;
            ajax("POST","/auth/groupUser/add",{czyid:this.params.id,groupcode}).done(function(res){
                if(res.code=='0'){
                    self.searchCurrentGroup(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        searchGroupList: function(pageNo) {
            var self=this;
            var params =  {
                pageSize: $(".ui-pg-selbox", $("#user-group-pager")).val(),
                pageNo
            };
            $("#user-group").jqGrid('clearGridData')
            ajax("POST","/auth/group/list",params).done(function(res){
                if(res.code=='0'){
                    $("#user-group").resetSelection();
                    $("#user-group")[0].addJSONData(res.data);
                    self.tableData2=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        //已拥有角色表
        createTable3: function() {
            var self=this;
            var columns = [
                { name: "rolecode", label: "角色代码", index: "rolecode", width: 100, align:"left",sortable: false },
                { name: "rolename", label: "角色名称", index: "rolename",width: 200, align:"left",sortable: false },
                { name: "isvalid", label: "是否启用", index: "isvalid",width: 100, align:"center",sortable: false ,formatter:function (cellvalue) {
                        return cellvalue == "1" ? "已启用" : "未启用"
                    }},
                { name: "", label:"操作", width:120, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(){
                        return "<div class='btn danger delete' style='float: none;display: inline-block;'>删除</div>" + "<div class='btn saw' style='float: none;display: inline-block;'>查看</div>"
                    }},
            ];
            $("#current-user-role").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#current-user-role-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".userEdit .table-wrapper").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    var rolecode = self.tableData3.rows[rowid-1].rolecode;
                    if($(e.target).hasClass('delete')){
                        tools.confirm("是否删除该角色","确定",function(){
                            self.delRole(rolecode);
                        });
                        return false;
                    }else if($(e.target).hasClass('saw')){
                        var rolename = self.tableData3.rows[rowid-1].rolename;
                        self.currentRolecode = rolecode
                        self.currentRolename = rolename
                        self.initTree()
                        return false;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }

                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo2(pgButton,"current-user-role-pager");
                    self.searchCurrentRole(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            self.searchCurrentRole(1);
        },
        delRole: function(rolecode) {
            var self = this;
            var params = {rolecode,czyid: this.params.id};
            ajax("POST","/auth/userRole/del",params).done(function(res){
                if(res.code=='0'){
                    self.searchCurrentRole(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        searchCurrentRole: function(pageNo) {
            var self=this;
            var params =  {
                pageSize: $(".ui-pg-selbox", $("#current-user-role-pager")).val(),
                pageNo,
                id: this.params.id
            };
            $("#current-user-role").jqGrid('clearGridData')
            ajax("POST","/auth/userRole/list",params).done(function(res){
                if(res.code=='0'){
                    $("#current-user-role").resetSelection();
                    $("#current-user-role")[0].addJSONData(res.data);
                    self.tableData3=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        createTable4: function() {
            var self=this;
            var columns = [
                { name: "rolecode", label: "角色代码", index: "rolecode", width: 100, align:"left",sortable: false },
                { name: "rolename", label: "角色名称", index: "rolename",width: 200, align:"left",sortable: false },
                { name: "isvalid", label: "是否启用", index: "isvalid",width: 100, align:"center",sortable: false ,formatter:function (cellvalue) {
                        return cellvalue == "1" ? "已启用" : "未启用"
                    }},
                { name: "", label:"操作", width:120, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(){
                        return "<div class='btn add' style='float: none;display: inline-block;'>添加</div>" + "<div class='btn saw' style='float: none;display: inline-block;'>查看</div>"
                    }},
            ];
            $("#user-role").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#user-role-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".userEdit .table-wrapper").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    var rolecode = self.tableData4.rows[rowid-1].rolecode;
                    if($(e.target).hasClass('add')){
                        self.addRole(rolecode);
                        return false;
                    }else if($(e.target).hasClass('saw')){
                        var rolename = self.tableData4.rows[rowid-1].rolename;
                        self.currentRolecode = rolecode
                        self.currentRolename = rolename
                        self.initTree()
                        return false;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }

                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo2(pgButton,"user-role-pager");
                    self.searchRoleList(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            self.searchRoleList(1);
        },
        addRole: function (rolecode) {
            var self = this;
            ajax("POST","/auth/userRole/add",{rolecode,czyid: this.params.id}).done(function(res){
                if(res.code=='0'){
                    self.searchCurrentRole(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        searchRoleList: function (pageNo) {
            var self=this;
            var params =  {
                pageSize: $(".ui-pg-selbox", $("#user-role-pager")).val(),
                pageNo
            };
            $("#user-role").jqGrid('clearGridData')
            ajax("POST","/auth/role/list",params).done(function(res){
                if(res.code=='0'){
                    $("#user-role").resetSelection();
                    $("#user-role")[0].addJSONData(res.data);
                    self.tableData4=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        initTree:function() {
            $('#userEditTree').css('height', $(".userEdit .table-wrapper").height() * 2 - 16)
            var self = this;
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
						        rolecode: self.currentRolecode,
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
                                        data[i].chkDisabled = true
							        }
							        $.fn.zTree.getZTreeObj("userEditTree").addNodes(node,data);
						        }else{
							        tools.info(res.msg);
						        }
					        }).fail(function(err){
						        tools.info(err);
					        })
				        }
						return true
			        },
		        }
	        };
	        var params = {
	        	rolecode: this.currentRolecode,
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
			        $.fn.zTree.init($("#userEditTree"), setting, data);
		        }else{
			        tools.info(res.msg);
		        }
	        }).fail(function(err){
		        tools.info(err);
	        })
        },
    }
})