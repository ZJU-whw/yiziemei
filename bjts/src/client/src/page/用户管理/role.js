var role = require("./role.html");

avalon.component("role",{
    template: role,
    defaults: {
        searchData: {
            name: "",
            pageNo: 1,
            pageSize: config.pageSize
        },
        tableData: {},
        modalData: {
            rolecode: "",
            rolename: "",
            remark: ""
        },
        onReady: function() {
            this.createTable();
        },
        createTable:function(){
            var self=this;
            var columns = [
                { name: "rolecode", label: "代码", index: "rolecode", width: 100, align:"left",sortable: false },
                { name: "rolename", label: "角色名", index: "rolename",width: 200, align:"left",sortable: false },
                { name: "isvalid", label: "是否启用", index: "isvalid",width: 100, align:"center",sortable: false ,formatter:function (cellvalue) {
                        return cellvalue == "1" ? "已启用" : "未启用"
                    }},
                { name: "", label:"操作", width:200, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(cellvalue,options,rowObject){
                        return "<div class='btn edit' style='float: none;display: inline-block;'>编辑</div><div class='btn danger delete' style='float: none;display: inline-block;'>删除</div>"
                    }},
            ];
            $("#role-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#role-table-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".role .form").height() -100;
                })(),
                beforeSelectRow:function(rowid,e){
                	var rowData = $("#role-table").jqGrid("getRowData",rowid);
                    if($(e.target).hasClass('edit')){
                        var code = rowData.rolecode;
                        avalonRoot.addTab({title:"角色编辑",component:"roleEdit",sameCheck:true,params:{code}});
                        return false;
                    }else if($(e.target).hasClass('delete')){
                        var code = rowData.rolecode;
                        tools.confirm("是否删除该角色信息","确定",function(){
                            self.delRole(code);
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
                    var pageNo=tools.getPageNo2(pgButton,"role-table-pager");
                    self.search(pageNo);
                },
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            self.search(1);
        },
        submit: function() {
            var self = this;
            if (!this.modalData.rolecode) {
                tools.info("角色代码不能为空");
                return;
            }
            if (!(/^[0-9a-zA-Z]+$/.test(this.modalData.rolecode))) {
                tools.info("角色代码只能为数字与字母组合");
                return
            }
            if (!this.modalData.rolename) {
                tools.info("角色名称不能为空");
                return
            }
            var params = tools.clone(this.modalData);
            ajax("POST","/auth/role/add",params).done(function(res){
                if(res.code=='0'){
                    tools.info("添加成功");
                    self.search(1);
                    self.closeModal();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        search: function(pageNo,findByName) {
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.role')).val();
            var params =  {
                pageSize: this.searchData.pageSize,
                pageNo
            };
            if(findByName) {
                params.name = this.searchData.name
            }
            $("#role-table").jqGrid('clearGridData')
            ajax("POST","/auth/role/list",params).done(function(res){
                if(res.code=='0'){
                    $("#role-table").resetSelection();
                    $("#role-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        //根据用户id删除用户
        delRole: function(code) {
            var self = this;
            ajax("POST","/auth/role/del",{code}).done(function(res){
                if(res.code=='0'){
                    tools.info("删除成功!");
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        showModal: function() {
            $(".model").show();
            $(".role .page-model").show();
        },
        closeModal: function () {
            $(".model").hide();
            $(".role .page-model").hide();
            for (var prop in this.modalData) {
                if (this.modalData.hasOwnProperty(prop)) {
                    this.modalData[prop] = "";
                }
            }
        }
    }
})