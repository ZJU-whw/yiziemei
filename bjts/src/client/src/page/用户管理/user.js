var user = require("./user.html");

avalon.component("user",{
    template: user,
    defaults: {
        searchData: {
            name: "",
            swjgDm: "",
            pageSize: config.pageSize,
            orderSql:"",
            pageNo: 1
        },
        tableData: {},
        modalData1: {
            czryDm: "",
            czryMc: "",
            password: "",
            swjgDm: ""
        },
        modalData2: {
            firstPwd: "",
            secondPwd: ""
        },
        isEnter: false,
        swjgmc: '',
        onReady: function() {
            this.createTable();
            this.initUser();
            this.initTree();
        },

        // 初始化用户数据
        initUser: function () {
          var self = this;
          if (avalonRoot.user) {
            this.searchData.swjgDm = avalonRoot.user.swjgDm;
            this.swjgmc = avalonRoot.user.swjgMc;
          } else {
            api.preLogin().done(function (res) {
              if (res.code == '0') {
                avalonRoot.user = res.data;
                self.searchData.swjgDm = avalonRoot.user.swjgDm;
                self.swjgmc = avalonRoot.user.swjgMc;
              }
            })
          }
        },
        initTree: function () {
          var self = this;
          var setting = {
            callback: {
              onClick: function (e, id, node) {
                self.searchData.swjgDm = node.id;
                self.swjgmc = node.text;
                self.hideTree();
                return;
              },
              onDblClick: function (e, id, node) {
                self.searchData.swjgDm = node.id;
                self.swjgmc = node.text;
                self.hideTree();
                return;
              }
            },
            data: { key: { children: "item", name: "text" } }
          };
    
          api.dzbaExportReadtree({ nodeType: "3" }).done(function (res) {
            if (res.code == '0') {
              $.fn.zTree.init($(".user .treeDiv"), setting, res.data);
            }
          })
        },
        createTable:function(){
            var self=this;
            var columns = [
                { name: "id", label: "操作员id", index: "id",hidden:true, width: 100, align:"left",sortable: false },
                { name: "czryDm", label: "用户代码", index: "czryDm",width: 100, align:"left",sortable: true },
                { name: "czryMc", label: "用户名称", index: "czryMc",width: 80, align:"left",sortable: true },
                { name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 200, align:"center",sortable: true },
                { name: "swjgDm", label: "税务机关代码", index: "swjgDm",width: 200, align:"center",sortable: true },
                { name: "yhly", label: "用户来源", index: "yhly",width: 100, align:"center",sortable: true },
                { name: "qybz", label: "启用标志", index: "qybz",width: 100, align:"center",sortable: true,formatter:function (cellvalue) {
                return cellvalue == "1" ? "已启用" : "未启用"
                }},
                { name: "", label:"操作", width:200, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(){
                        return "<div class='btn edit' style='float: none;display: inline-block;'>编辑</div><div class='btn setPwd' style='float: none;display: inline-block;'>重置密码</div>"
                    }},
            ];
            $("#user-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#user-table-pager',
                shrinkToFit: true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".user .form").height() -100;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('edit')){
                        var id = $("#user-table").jqGrid('getRowData',rowid).id;
                        avalonRoot.addTab({title:"用户编辑",component:"userEdit",sameCheck:true,params:{id}});
                        return false;
                    }else if($(e.target).hasClass('setPwd')){
                        var userId = $("#user-table").jqGrid('getRowData',rowid).id;
                        self.modalData2.id = userId;
                        self.showModal("2");
                        return false;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }
                },onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo2(pgButton,"user-table-pager");
                    self.search(pageNo);
                },
            })
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            self.search(1)
        },
        //提交弹框的表单内容，新增用户
        submit: function() {
            var self = this;
            if (!this.modalData1.czryDm) {
                tools.info("用户代码不能为空");
                return;
            }
	        if (!(/^[0-9a-zA-Z]+$/.test(this.modalData1.czryDm))) {
		        tools.info("用户代码只能为数字与字母组合");
		        return
	        }
            if (!this.modalData1.czryMc) {
                tools.info("用户名称不能为空");
                return
            }
            if (!this.modalData1.password) {
                tools.info("用户密码不能为空");
                return
            }
            if (!this.modalData1.swjgDm) {
                tools.info("税务机关代码不能为空");
                return
            }
            var params = tools.clone(this.modalData1);
            ajax("POST","/auth/user/add",params).done(function(res){
                if(res.code=='0'){
                    tools.info("添加成功");
                    self.search(1);
                    self.closeModal("1");
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
            this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            this.searchData.name = this.searchData.name.trim();
            var params = tools.clone(this.searchData)
            params.pageNo = pageNo
            // var params =  {
            //     pageSize: this.searchData.pageSize,
            //     orderSql:this.searchData.orderSql,
            //     pageNo
            // };
            // if(findByName) {
		    //     params.name = this.searchData.name
	        // }
            $("#user-table").jqGrid('clearGridData')
            ajax("POST","/auth/user/list",params).done(function(res){
                if(res.code=='0'){
                    $("#user-table").resetSelection();
                    $("#user-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        //根据用户id删除用户
        delUser: function(id) {
            var self = this;
            ajax("POST","/auth/user/del",{id}).done(function(res){
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
        setPwd: function() {
            var self = this;
            if (!this.modalData2.firstPwd) {
                tools.info("请输入新密码");
                return
            } else if (!this.modalData2.secondPwd) {
                tools.info("请再次输入新密码");
                return
            } else if (this.modalData2.firstPwd != this.modalData2.secondPwd) {
                tools.info("两次输入的密码不一致，请重新输入");
                return;
            }
            ajax("POST","/auth/user/setPwd",this.modalData2).done(function(res){
                if(res.code=='0'){
                    $(".pwd-warn").text("");
                    $(".pwd-warn").parent().hide();
                    tools.info("密码重置成功!");
                    self.search(1);
                }else{
                    $(".pwd-warn").text(res.msg);
                    $(".pwd-warn").parent().show();
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        showModal: function(type) {
            if (type == "1") {
                $(".model").show();
                $(".user .modal1").show();
            } else {
                $(".model").show();
                $(".user .modal2").show();
            }
        },
        closeModal: function (type) {
            if (type == "1") {
                $(".model").hide();
                $(".user .modal1").hide();
                for (var prop in this.modalData1) {
                    if (this.modalData1.hasOwnProperty(prop)) {
                        this.modalData1[prop] = "";
                    }
                }
            } else  {
                $(".model").hide();
                $(".user .modal2").hide();
                for (var prop in this.modalData2) {
                    if (this.modalData2.hasOwnProperty(prop)) {
                        this.modalData2[prop] = "";
                    }
                }
            }
        },
        syncUserInfo: function(){
            var self = this;
            if (this.modalData1.czryDm == '') {
                return false;
            }
            ajax("POST","/auth/user/add/sync",{czryDm: this.modalData1.czryDm}).done(function(res){
                if(res.code=='0'){
                    var data = res.data
                    self.modalData1.czryMc = data.czryMc
                    self.modalData1.swjgDm = data.swjgDm
                    if (self.isEnter) {
                        $('.user .addPwd')[0].focus()
                        self.isEnter = false
                    }
                }else{
                    self.modalData1.czryMc = ''
                    self.modalData1.swjgDm = ''
                    tools.info(res.msg);
                }
            }).fail(function(err){
                self.modalData1.czryMc = ''
                self.modalData1.swjgDm = ''
                tools.info(err);
            })
        },
        enterHandle: function(e){
            if (this.modalData1.czryDm == '') {
                return false;
            }
            e.target.blur()
            this.isEnter = true
        },
        
      showTree:function(e){
        var self=this;
        $(".treeDiv",$(e.target).parent()).show();
        $('.user').on('click',function(e){
            var e=e||window.event;
            if($('.treeDiv').find($(e.target)).length<=0){
                self.hideTree();
            }
        })
      },
      hideTree:function(){
        $(".treeDiv").hide();
        $('.user').off('click');
      },
    }
})