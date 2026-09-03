var swtzbj = require("./swtzbj.html");
avalon.component("swtzbj",{
    template: swtzbj,
    defaults: {
        noticeid: "",
        act:"1",
        type:"",
        modalData: "",
        params:{
            type:"",
            noticeid: ""
        },
        formData: {
            main:{
                notitype:"1",
                valid_time:"",
                objval:"",
                objvalMc:"",
                title:"",
                content:"",
                bz:"",
            },
            csxx:[],
            attach: []
        },
        onReady: function () {
            var self = this;
            this.noticeid = this.params.noticeid;
            this.type = this.params.type;
            this.initTree();
            $(".swtzbj .datepicker.date-day").datepicker({
                dateFormat:"yy-mm-dd"
            });
            $(".swtzbj .fileupload").fileupload({
                dataType:"json",
                url:"/glfw/swtz/uploadDoc",
                add: function (e,data) {
                    if (!self.noticeid) {
                        tools.info("请先保存通知再上传附件");
                        return false;
                    }
                    var file = data.files[0];
                    if (file.size > (1024 * 2000)) {
                        tools.info("上传文件超过限制大小，请重新上传");
                        return false;
                    }
                    var url = "/glfw/swtz/uploadDoc?id=" + self.noticeid;
                    $(this).fileupload("option", "url", url);
                    data.submit();
                },
                done: function (e,data) {
                    if (data.result.code == "0") {
                        tools.info("上传成功");
                        self.search();
                    } else {
                        tools.info(data.result.msg);
                    }
                }
            });
            if (this.params.type == "update" || this.params.type == "check") {
                this.search();
            }
        },
        search:function(){
            var self=this;
            var params = {noticeid: this.noticeid};
            ajax("POST","/glfw/swtzfbgl/select/second",params).done(function(res){
                if(res.code=='0'){
                    var data = res.data;
                    if (data.attach && data.attach.length > 0) {
                        for (var j = 0; j < data.attach.length; j++) {
                            data.attach[j].filesize = (Math.floor((data.attach[j].filesize/1024)*100))/100 + "k";
                        }
                    }
                    if (data.main) {
                        self.formData.main  = data.main;
                        if (!self.formData.main.valid_time) {
                            self.formData.main.valid_time = "";
                        }
                    }
                    if (data.attach) {
                        self.formData.attach  = data.attach;
                    }
                    if (data.csxx) {
                        self.formData.csxx  = data.csxx;
                    }
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        showModal: function (type) {
            this.modalData = "";
            $("#swModalData").val("");
            if (type == "1") {
                $(".model").show();
                $(".swtzbj .modal1").show();
            } else {
                $(".model").show();
                $(".swtzbj .modal2").show();
            }
        },
        closeModal: function (type) {
            if (type == "1")  {
                $(".model").hide();
                $(".swtzbj .modal1").hide();
            } else {
                $(".model").hide();
                $(".swtzbj .modal2").hide();
            }
        },
        submit: function (type) {
            var self = this;
            if (type == "1") {
                if (!this.modalData) {
                    tools.info("税局操作员代码不能为空");
                    return;
                }
                ajax("POST","/glfw/tzfbgl/check",{type: "2",csdxs: this.modalData}).done(function(res){
                    if(res.code=='0'){
                        var data = res.data;
                        if (data && data.length > 0) {
                            self.formData.main.objval = data[0].objval;
                            self.formData.main.objvalMc = data[0].objvalMc;
                            self.closeModal("1");
                        }
                    }else{
                        tools.info(res.msg);
                    }
                }).fail(function(err){
                    tools.info(err);
                });
            } else {
                var csdxs;
                var data = $("#swModalData").val();
                if (data.length > 0) {
                    var arr = data.split(/\n/g);
                    $.each(arr, function (index, item) {
                        item = item.replace(/(^\s+)|(\s+$)/g,"");
                    });
                    csdxs = arr.join(",");
                } else {
                    csdxs = "";
                }
                if (!csdxs) {
                    tools.info("税局操作员代码不能为空");
                    return;
                }
                ajax("POST","/glfw/tzfbgl/check",{type: "2",csdxs: csdxs}).done(function(res){
                    if(res.code=='0'){
                        var data = res.data;
                        if (data && data.length > 0) {
                            self.formData.csxx = self.formData.csxx.concat(data);
                            self.closeModal("2");
                        }
                    }else{
                        tools.info(res.msg);
                    }
                }).fail(function(err){
                    tools.info(err);
                });
            }
        },
        saveInfo: function () {
            var self = this;
            if (this.formData.main.valid_time) {
                var time = new Date(this.formData.main.valid_time).getTime();
                if (time < new Date().getTime()) {
                    tools.info("截止日期不能小于当前日期");
                    return;
                }
            }
            if (!this.formData.main.objval) {
                tools.info("请填写通知对象");
                return;
            }
            if (!this.formData.main.title) {
                tools.info("请填写通知标题");
                return;
            }
            if (!this.formData.main.content) {
                tools.info("请填写通知内容");
                return;
            }
            var params = {
                id:"",
                notitype:"",
                valid_time:"",
                objval:"",
                title:"",
                content:"",
                bz:"",
                csdx:"",
            };
            params.id = this.noticeid ? this.noticeid : "";
            params.notitype = this.formData.main.notitype;
            params.valid_time = this.formData.main.valid_time;
            params.objval = this.formData.main.objval;
            params.title = this.formData.main.title;
            params.content = this.formData.main.content;
            params.bz = this.formData.main.bz;
            var csdx = "";
            if (this.formData.csxx && this.formData.csxx.length > 0) {
                for (var i = 0; i < this.formData.csxx.length; i++) {
                    csdx += (","+this.formData.csxx[i].objval);
                }
                csdx = csdx.slice(1);
            }
            params.csdx = csdx;
            ajax("POST","/glfw/swtzfbgl/update",params).done(function(res){
                if(res.code=='0'){
                    tools.info("保存成功");
                    self.noticeid = res.data.noticeid;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            });
        },
        initTree:function() {
            var self = this;
            var setting1 = {
                callback:{
                    onClick:function(e,id,node){
                        self.formData.main.objval = node.id;
                        self.formData.main.objvalMc = node.id +" " +node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.formData.main.objval = node.id;
                        self.formData.main.objvalMc = node.id +" " +node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            var setting2 = {
                callback:{
                    onClick:function(e,id,node){
                        var hasValue = self.isContain(self.formData.csxx,node.id);
                        if (hasValue) return;
                        var obj = {objval:"", objvalMc: ""};
                        obj.objval = node.id;
                        obj.objvalMc = node.id + " " + node.text;
                        self.formData.csxx.push(obj);
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        var hasValue = self.isContain(self.formData.csxx,node.id);
                        if (hasValue) return;
                        var obj = {objval:"", objvalMc: ""};
                        obj.objval = node.id;
                        obj.objvalMc = node.id + " " + node.text;
                        self.formData.csxx.push(obj);
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".swtzbj .tzdx"), setting1,data);
                $.fn.zTree.init($(".swtzbj .csdx"), setting2,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        loadFile: function (id) {
            var self = this;
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/glfw/swtz/downloadDoc?fileid=" + id);
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            var params = {};
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
        deleteFile: function (id) {
            var self = this;
            tools.confirm("确认删除此附件？","确定",function () {
                ajax("POST","/glfw/swtz/deleteDoc",{fileid:id}).done(function(res){
                    if(res.code=='0'){
                        self.search();
                    }else{
                        tools.info(res.msg);
                    }
                }).fail(function(err){
                    tools.info(err);
                });
            })
        },
        isContain: function (arr,target) {
            var has = false;
            for (var i = 0; i < arr.length; i++) {
                if (arr[i].objval == target) {
                    has = true;
                }
            }
            return has;
        },
        showTree:function(type){
            var self=this;
            if (type == "1") {
                $('#swtzZtree1').show();
            } else {
                $('#swtzZtree2').show();
            }
            $('.swtzbj').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }
            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.swtzbj').off('click');
        },
        handleChange: function () {
            this.formData.csxx = [];
            this.formData.main.objval = "";
            this.formData.main.objvalMc = "";
        },
        filDate:function(e){
            var date=e.target.value;
            var res=tools.DateCheup(date);
            if(res===false){
                tools.info("日期输入错误");
                res=""
            }
            e.target.value=res;
            return ;
        },
        deleteItem: function (index) {
            this.formData.csxx = this.formData.csxx.slice(0,index).concat(this.formData.csxx.slice(index + 1));
        },
    }
})