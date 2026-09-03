var group = require("./group.html");

avalon.component("group",{
    template: group,
    defaults: {
        searchData: {
            name: "",
            pageSize: config.pageSize,
            pageNo: 1
        },
        tableData: {},
        modalData: {
            code:"",
            name:"",
            remark:""
        },
        onReady: function() {
            this.createTable();
        },
        createTable:function(){
            var self=this;
            var columns = [
                { name: "code", label: "用户组代码", index: "code", width: 100, align:"left",sortable: false },
                { name: "name", label: "用户组名称", index: "name",width: 200, align:"left",sortable: false },
                { name: "isvalid", label: "是否启用", index: "isvalid",width: 100, align:"center",sortable: false ,formatter:function (cellvalue) {
                        return cellvalue == "1" ? "已启用" : "未启用"
                    }},
                { name: "", label:"操作", width:200, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(){
                        return "<div class='btn edit' style='float: none;display: inline-block;'>编辑</div><div class='btn danger delete' style='float: none;display: inline-block;'>删除</div>"
                    }},
            ];
            $("#group-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#group-pager',
                shrinkToFit: true,
                // width:"100%",
                // autowidth:true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".group .form").height() -100;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('edit')){
                        var code = self.tableData.rows[rowid-1].code;
                        avalonRoot.addTab({title:"用户组编辑",component:"groupEdit",sameCheck:true,params:{code}});
                        return false;
                    }else if($(e.target).hasClass('delete')){
                        var code = self.tableData.rows[rowid-1].code;
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
                    var pageNo=tools.getPageNo2(pgButton,"group-pager");
                    self.search(pageNo);
                },
            })
            self.search(1)
        },
        //提交弹框的表单内容，新增用户组
        submit: function() {
            var self = this;
            if (!this.modalData.code) {
                tools.info("用户组代码不能为空");
                return;
            }
            if (!(/^[0-9a-zA-Z]+$/.test(this.modalData.code))) {
                tools.info("用户组代码只能为数字与字母组合");
                return
            }
            if (!this.modalData.name) {
                tools.info("用户组名称不能为空");
                return
            }
            var params = tools.clone(this.modalData);
            ajax("POST","/auth/group/add",params).done(function(res){
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
        //查询用户列表
        search: function(pageNo,findByName) {
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.group')).val();
            var params =  {
                pageSize: this.searchData.pageSize,
                pageNo
            };
            if(findByName) {
                params.name = this.searchData.name
            }
            $("#group-table").jqGrid('clearGridData')
            ajax("POST","/auth/group/list",params).done(function(res){
                if(res.code=='0'){
                    $("#group-table").resetSelection();
                    $("#group-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        //根据用户id删除用户
        delGroup: function(code) {
            var self = this;
            ajax("POST","/auth/group/del",{code}).done(function(res){
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
            $(".group .page-model").show();
        },
        closeModal: function () {
            $(".model").hide();
            $(".group .page-model").hide();
            for (var prop in this.modalData) {
                if (this.modalData.hasOwnProperty(prop)) {
                    this.modalData[prop] = "";
                }
            }
        }
    }
})