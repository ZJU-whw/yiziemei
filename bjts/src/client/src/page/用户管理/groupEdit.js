var groupEdit = require("./groupEdit.html");

avalon.component("groupEdit",{
    template: groupEdit,
    defaults: {
        tableData1: {},
        tableData2: {},
        tableData3: {},
        tableData4: {},
        params: {code: ""},
        formData: {
            code: "",
            name: "",
            remark: "",
            isvalid:false
        },
	    name:"",
        activeIndex: "0",
        tabs: ["基本信息","用户管理","角色管理"],

        onReady: function () {
            this.setUnderline(0);
            //    设置table-wrapper的高度
            var h = $(".groupEdit .page").height() -60;
            $(".groupEdit .table-wrapper").css("height",h/2+"px");
            this.findGroupView();
            this.createTable1();
            this.createTable2();
            this.createTable3();
            this.createTable4();
        },
        handleClick: function (index) {
            this.activeIndex = index;
            this.setUnderline(index)
        },
        //设置激活的tab底部横条的位置和宽度
        setUnderline: function(index) {
            var width = $(".groupEdit .tabs-item:eq("+index+")").outerWidth();
            var offsetX = this.calcOffset(index);
            $(".groupEdit .tabs-underline").width(width);
            $(".groupEdit .tabs-underline").css("left",offsetX+"px");
        },
        //计算第n个tab项的相对于父元素的横向偏移量
        calcOffset: function (index) {
            var parentOffset = $(".groupEdit .tabs-list").offset();
            var childOffset = $(".groupEdit .tabs-item:eq("+index+")").offset();
            return childOffset.left - parentOffset.left;
        },
        //根据groupcode查询该用户组基本信息
        findGroupView: function() {
            var self = this;
            ajax("POST","/auth/group/view",this.params).done(function(res){
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
        //保存基本信息
        saveInfo: function() {
            if (!this.formData.name) {
                tools.info("用户组名称不能为空");
                return
            }
            var params = {};
            params.isvalid = this.formData.isvalid ? "1" : "0";
            params.code = this.formData.code;
            params.name = this.formData.name;
            params.remark = this.formData.remark;
            ajax("POST","/auth/group/update",params).done(function(res){
                if(res.code=='0'){
                    tools.info("更新成功")
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        //创建现有用户表格
        createTable1:function(){
            var self=this;
            var columns = [
                { name: "id", label: "id", index: "id",hidden:true, width: 100, align:"left",sortable: false },
                { name: "czryDm", label: "用户代码", index: "czryDm",width: 100, align:"left",sortable: false },
                { name: "czryMc", label: "用户名称", index: "czryMc",width: 200, align:"left",sortable: false },
                { name: "swjgDm", label: "税务机关代码", index: "swjgDm",width: 200, align:"center",sortable: false },
                { name: "isvalid", label: "是否启用", index: "isvalid",width: 100, align:"center",sortable: false, formatter:function (cellvalue) {
                        return cellvalue == "1" ? "已启用" : "未启用"
                    }},
                { name: "", label:"操作", width:100, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(){
                        return "<div class='btn danger delete' style='float: none;display: inline-block;'>删除</div>"
                    }},
            ];
            $("#current-group-user").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#current-group-user-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
	            rowList: [20,50,100,500],
                height:(function(){
                    return $(".groupEdit .table-wrapper").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('delete')){
                        var userId = $("#current-group-user").jqGrid('getRowData',rowid).id;
                        tools.confirm("是否删除该用户","确定",function(){
                            self.delUser(userId);
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
                    var pageNo=tools.getPageNo2(pgButton,"current-group-user-pager");
                    self.searchCurrentUser(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            self.searchCurrentUser(1);
        },
        //根据用户组id删除用户组
        delUser: function(czyid) {
            var self = this;
            ajax("POST","/auth/groupUser/del",{czyid,groupcode:this.params.code}).done(function(res){
                if(res.code=='0'){
                    self.searchCurrentUser(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        searchCurrentUser: function(pageNo) {
            var self=this;
            var params =  {
                pageSize: $(".ui-pg-selbox", $("#current-group-user-pager")).val(),
                pageNo,
                code: this.params.code
            };
            $("#current-group-user").jqGrid('clearGridData')
            ajax("POST","/auth/groupUser/list",params).done(function(res){
                if(res.code=='0'){
                    $("#current-group-user").resetSelection();
                    $("#current-group-user")[0].addJSONData(res.data);
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
                { name: "id", label: "id", index: "id",hidden:true, width: 100, align:"left",sortable: false },
                { name: "czryDm", label: "用户代码", index: "czryDm",width: 100, align:"left",sortable: false },
                { name: "czryMc", label: "用户名称", index: "czryMc",width: 200, align:"left",sortable: false },
                { name: "swjgDm", label: "税务机关代码", index: "swjgDm",width: 200, align:"center",sortable: false },
                { name: "isvalid", label: "是否启用", index: "isvalid",width: 100, align:"center",sortable: false, formatter:function (cellvalue) {
                        return cellvalue == "1" ? "已启用" : "未启用"
                    }},
                { name: "", label:"操作", width:100, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(){
                        return "<div class='btn add' style='float: none;display: inline-block;'>添加</div>"
                    }},
            ];
            $("#group-user").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#group-user-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
	            rowList: [20,50,100,500],
                height:(function(){
                    return $(".groupEdit .table-wrapper").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('add')){
                        var userId = $("#group-user").jqGrid('getRowData',rowid).id;
                        self.addUser(userId);
                        return false;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }

                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo2(pgButton,"group-user-pager");
                    self.searchUserList(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            self.searchUserList(1);
        },
        addUser: function (czyid) {
            var self = this;
            ajax("POST","/auth/groupUser/add",{czyid,groupcode:this.params.code}).done(function(res){
                if(res.code=='0'){
                    self.searchCurrentUser(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        searchUserList: function(pageNo,findByName) {
            var self=this;
            var params =  {
                pageSize: $(".ui-pg-selbox", $("#group-user-pager")).val(),
                pageNo
            };
	        if(findByName) {
		        params.name = this.name
	        }
            $("#group-user").jqGrid('clearGridData')
            ajax("POST","/auth/user/list",params).done(function(res){
                if(res.code=='0'){
                    $("#group-user").resetSelection();
                    $("#group-user")[0].addJSONData(res.data);
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
                { name: "", label:"操作", width:100, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(){
                        return "<div class='btn danger delete' style='float: none;display: inline-block;'>删除</div>"
                    }},
            ];
            $("#current-group-role").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#current-group-role-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
	            rowList: [20,50,100,500],
                height:(function(){
                    return $(".groupEdit .table-wrapper").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('delete')){
                        var rolecode = self.tableData3.rows[rowid-1].rolecode;
                        tools.confirm("是否删除该角色","确定",function(){
                            self.delRole(rolecode);
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
                    var pageNo=tools.getPageNo2(pgButton,"current-group-role-pager");
                    self.searchCurrentRole(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.group')).val();
            self.searchCurrentRole(1);
        },
        delRole: function(rolecode) {
            var self = this;
            var params = {rolecode,groupcode: this.params.code};
            ajax("POST","/auth/groupRole/del",params).done(function(res){
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
                pageSize: $(".ui-pg-selbox", $("#current-group-role-pager")).val(),
                pageNo,
                code: this.params.code
            };
            $("#current-group-role").jqGrid('clearGridData')
            ajax("POST","/auth/groupRole/list",params).done(function(res){
                if(res.code=='0'){
                    $("#current-group-role").resetSelection();
                    $("#current-group-role")[0].addJSONData(res.data);
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
                { name: "", label:"操作", width:100, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(){
                        return "<div class='btn add' style='float: none;display: inline-block;'>添加</div>"
                    }},
            ];
            $("#group-role").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#group-role-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
	            rowList: [20,50,100,500],
                height:(function(){
                    return $(".groupEdit .table-wrapper").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('add')){
                        var rolecode = self.tableData4.rows[rowid-1].rolecode;
                        self.addRole(rolecode);
                        return false;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo2(pgButton,"group-role-pager");
                    self.searchRoleList(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.group')).val();
            self.searchRoleList(1);
        },
        addRole: function (rolecode) {
            var self = this;
            var groupcode = this.params.code;
            ajax("POST","/auth/groupRole/add",{rolecode,groupcode}).done(function(res){
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
                pageSize: $(".ui-pg-selbox", $("#group-role-pager")).val(),
                pageNo
            };
            $("#group-role").jqGrid('clearGridData')
            ajax("POST","/auth/role/list",params).done(function(res){
                if(res.code=='0'){
                    $("#group-role").resetSelection();
                    $("#group-role")[0].addJSONData(res.data);
                    self.tableData4=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        }
    }
})