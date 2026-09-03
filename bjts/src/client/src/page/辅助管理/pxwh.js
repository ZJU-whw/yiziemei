var pxwh = require("./pxwh.html");
avalon.component("pxwh",{
    template: pxwh,
    defaults:{
        act:"1",
        params:{},
        addOrEdit:"1",//"1"为新增,"2" 为编辑
        showQdCode: false,
        showBmCode: false,
        searchData:{
            topic:"",
            start:"",
            end:"",
            orderSql:"",
        },
        modalData:{
            id:"",
            originator: "",
            topic: "",
            synopsis: "",
            personLimit:"",
            validDateStart: "",
            validDateEnd:"",
            tssjq:"",
            tssjz :"",
            address:"",
            contact:"",
            contactTel:"",
        },
        emptyErrMap: {
            originator: "发布人不能为空",
            topic: "标题不能为空",
            synopsis: "简介不能为空",
            validDateStart: "培训开始时间不能为空",
            validDateEnd:"培训结束时间不能为空",
            tssjq:"推送起始时间不能为空",
            tssjz :"推送截止时间不能为空",
            personLimit:"报名人数上限不能为空",
            address:"培训地址不能为空",
            contact:"联系人不能为空",
            contactTel:"联系人电话不能为空",
        },
        bmImg: '',
        qdImg: '',
        onReady:function(){
            this.createTable();
            $(".pxwh .datepicker.date-day").datepicker({dateFormat: "yy-mm-dd"});
            $(".pxwh .datepicker.date-time").datetimepicker({
                timeFormat: "HH:mm:ss",
                dateFormat: "yy-mm-dd",
                changeMonth: true,
                changeYear: true
            })
        },
        changeTab:function(num){
            this.act=num;
        },
        //copy bg
        createTable:function(){
            var self=this;
            var columns = [
                { name: "id", label: "主键", index: "id", width: 80, sortable: true ,align:"center",hidden:true},
                { name: "originator", label: "发起人", align:"center", index: "originator",  width: 100,sortable: true},
                { name: "topic", label: "标题",  index: "topic",width: 120, sortable: true },
                { name: "synopsis", label: "内容简介", index: "synopsis", width: 120 ,sortable: true},
                { name:"validDateStart", label:"培训开始时间", index:"validDateStart", width:130, sortable: true,},
                { name:"validDateEnd", label:"培训结束时间", index:"validDateEnd", width:130, sortable: true,},
                { name:"tssjq", label:"推送时间起", index:"tssjq", width:100, sortable: true,},
                { name:"tssjz", label:"推送时间止", index:"tssjz", width:100, sortable: true,},
                { name: "address", label: "培训地址",  index: "address", width: 160, sortable: true, },
                { name: "xq", label: "报名信息", index: "xq", width: 80, sortable: true ,align:"center",
                    formatter:function(cellvalue, options, rowObject){
                        return "<span style='color: #ff0000;text-decoration: underline;cursor: pointer' class='bmxxcx'>查看</span>";
                    }
                },
                { name: "bj", label: "操作", index: "bj", width: 80, sortable: true ,align:"center",
                    formatter:function(cellvalue, options, rowObject){
                        return "<span  style='color: #ff0000;text-decoration: underline;cursor: pointer' class='operation'>编辑</span> <span  style='color: #ff0000;text-decoration: underline;cursor: pointer' class='delete'>删除</span>";
                    }
                }
            ];
            $("#pxwh-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#pxwh-tablePager',
                shrinkToFit: false,
                autowidth:true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                width:"100%",
                height:(function(){
                    return $(".pxwh .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    var rowObject = $("#pxwh-table").jqGrid("getRowData",rowid);
                    if ($(e.target).hasClass("bmxxcx")) {
                        avalonRoot.addTab({title:"培训报名信息",component:"pxbmxx",params:{id: rowObject.id}});
                    }
                    else if ($(e.target).hasClass("operation")) {
                        self.update(rowObject.id);
                    }
                    else if ($(e.target).hasClass("delete")) {
                        self.myDelete(rowObject.id);
                    }
                    if(e.target.nodeName=="TD"){
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
                    var pageNo=tools.getPageNo(pgButton,"pxwh-table");
                    self.search(pageNo);
                }
            });
        },
        search:function(pageNo){
            var size = $(".ui-pg-selbox", $('.pxwh')).val() || 20;
            var params={};
            params.start = this.searchData.start;
            params.end = this.searchData.end;
            params.topic = this.searchData.topic;
            params.pageSize = size;
            params.orderSql = "";
            params.pageNo = pageNo;
            $("#pxwh-table").jqGrid('clearGridData')
            // var data = {count:1,page:1,records:1,rows: [{address: "西湖区", contact: "lsx", contactTel: "13221088392",
            // id: 1000166, isvalid: "", operator: "超级管理员", originator: "lsx", personLimit: 10, remain: 10,synopsis: "123",
            // ticket: "",topic: "test",tssjq:"2020-02-01",tssjz: "2020-02-05", validDateEnd: "2020-02-22 00:00:00",
            // validDateStart: "2020-02-13 00:00:00"}]};
            // $("#pxwh-table")[0].addJSONData(data);
            ajax("POST","/glfw/train/list",params).done(function(res){
                if(res.code=='0'){
                    $("#pxwh-table")[0].addJSONData(res.data);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        saveInfo: function(){
            var self = this;
            var isValid = this.checkEmpty();
            if (!isValid) {return;}
            if(!/^\d+$/.test(this.modalData.personLimit)) {
                tools.info("培训人数上限需输入数值类型");
                return;
            }
            if (!this.checkDate()) {
                return;
            }
            if (!this.checkTel(this.modalData.contactTel)){
                return;
            }
            var params = {};
            for (var prop in this.modalData) {
                if (this.modalData.hasOwnProperty(prop)) {
                    if (prop == "tssjq") {
                        params[prop] = this.modalData[prop] +" 00:00:00";
                    } else if(prop == "tssjz") {
                        params[prop] = this.modalData[prop] +" 23:59:59";
                    } else {
                        params[prop] = this.modalData[prop];
                    }
                }
            }
            ajax("POST","/glfw/train/add",params).done(function(res){
                if(res.code=='0'){
                    tools.info("保存成功");
                    self.closeModal();
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        add:function () {
            this.addOrEdit = "1";
            for(var prop in this.modalData) {
                if (this.modalData.hasOwnProperty(prop)) {
                    this.modalData[prop] = "";
                }
            }
            $(".model").show();
            $(".pxwh .modal").show();
        },
        update:function (id) {
            if (!id) return;
            this.addOrEdit = "2";
            var self = this;
            ajax("POST","/glfw/train/mx",{id: id}).done(function(res){
                if(res.code=='0'){
                    var data = res.data;
                    self.modalData.id = id;
                    for(var prop in self.modalData) {
                        if (self.modalData.hasOwnProperty(prop)) {
                            if (prop == "id") continue
                            if (prop == "tssjq" || prop == "tssjz") {
                                self.modalData[prop] = data[prop] ? data[prop].substring(0,10) : "";
                            } else {
                                self.modalData[prop] = data[prop];
                            }
                        }
                    }
                    self.bmImg = "data:image/png;base64,"+data.signQrCode
                    self.qdImg = "data:image/png;base64,"+data.ticket
                    // $(".pxwh .qrcode-wrapper .signQrCode").attr("src","data:image/png;base64,"+data.signQrCode);
                    // $(".pxwh .qrcode-wrapper .ticket").attr("src","data:image/png;base64,"+data.ticket);
                    $(".model").show();
                    $(".pxwh .modal").show();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        myDelete:function(id){
            var self=this;
            ajax("POST","/glfw/train/del",{id: id}).done(function(res){
                if(res.code=='0'){
                    tools.info("删除成功");
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        checkEmpty:function() {
            var valid = true;
            for (var prop in this.modalData) {
                if (this.modalData.hasOwnProperty(prop)) {
                    if (prop  == "id") continue;
                    if (prop == "personLimit" && this.modalData[prop] == "") {
                        tools.info(this.emptyErrMap[prop]);
                        valid = false;
                        return valid;
                    }
                    else if (!this.modalData[prop]) {
                        tools.info(this.emptyErrMap[prop]);
                        valid = false;
                        return valid;
                    }
                }
            }
            return valid;
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
        closeModal: function () {
            $(".model").hide();
            $(".pxwh .modal").hide();
        },
        showSignCode: function() {
            this.showBmCode = true;
            this.showQdCode = false;
            $(".pxwh .qrcode-wrapper").show();
        },
        showTicket: function() {
            this.showBmCode = false;
            this.showQdCode = true;
            $(".pxwh .qrcode-wrapper").show();
        },
        closeQrcode: function() {
            $(".pxwh .qrcode-wrapper").hide();
            this.showBmCode = false;
            this.showQdCode = false;
        },
        checkDate: function () {
            var valid = true;
            var validDateStart = this.modalData.validDateStart;
            var validDateEnd = this.modalData.validDateEnd;
            if (validDateStart.length > 0 && validDateEnd.length > 0) {
                var startDateTemp = validDateStart.substring(0,10);
                var endDateTemp = validDateEnd.substring(0,10);
                var time1 = new Date(startDateTemp.replace(/\-/g, "\/"));
                var time2 = new Date(endDateTemp.replace(/\-/g, "\/"));
                if (time1 > time2) {
                    tools.info("培训结束时间必须大于培训开始时间");
                    valid = false;
                    return valid;
                }
            }
            var tssjq = this.modalData.tssjq;
            var tssjz = this.modalData.tssjz;
            if (tssjq.length > 0 && tssjz.length > 0) {
                    var startDateTemp =tssjq;
                    var endDateTemp = tssjz;
                    var time1 = new Date(startDateTemp.replace(/\-/g, "\/"));
                    var time2 = new Date(endDateTemp.replace(/\-/g, "\/"));
                    if (time1 > time2) {
                        tools.info("推送截止时间必须大于推送起始时间");
                        valid = false;
                        return  valid;
                    }
                    else {
                        var diff = time2.getTime() - time1.getTime();//时间差的毫秒数
                        var dayDiff = Math.floor(diff / (24 * 3600 * 1000));//计算出相差天数
                        var year = time1.getFullYear();
                        var startMonth = time1.getMonth() + 1;
                        var bigMonth = [1,3,5,7,8,10,12];
                        if (startMonth == 2) {
                            if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
                                if (dayDiff > 28) {
                                   tools.info("推送时间区间必须小于一个月");
                                   valid = false;
                                   return valid;
                                }
                            } else {
                                if (dayDiff > 27) {
                                    tools.info("推送时间区间必须小于一个月");
                                    valid = false;
                                    return valid;
                                }
                            }
                        }
                        else if(bigMonth.indexOf(startMonth) > -1) {
                            if (dayDiff > 30) {
                                tools.info("推送时间区间必须小于一个月");
                                valid = false;
                                return valid;
                            }
                        }
                        else {
                            if (dayDiff > 29) {
                                tools.info("推送时间区间必须小于一个月");
                                valid = false;
                                return valid;
                            }
                        }
                        if (tssjz.length > 0 && validDateStart.length > 0) {
                            var DateTemp = validDateStart.substring(0,10);
                            var time = new Date(DateTemp.replace(/\-/g, "\/"));
                            if (time2 > time) {
                                tools.info("推送截止时间必须小于培训开始时间");
                                valid = false;
                                return valid;
                            }
                        }
                    }
                }
            return valid;
        },
        checkTel: function(str){
            var isPhone = /^0\d{2,3}-?\d{7,8}$/;
            var isMob=/^1[0-9]{10}$/;
            if (str.charAt(0) == "1") {
                if (isMob.test(str))  {
                    return true
                }
                tools.info("请输入正确格式的联系人电话");
                return false
            } else {
                if (isPhone.test(str))  {
                    return true
                }
                tools.info("请输入正确格式的联系人电话");
                return false
            }
        }
    }
})