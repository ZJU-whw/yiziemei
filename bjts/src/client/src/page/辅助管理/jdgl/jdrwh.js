var temp = require("./jdrwh.html");
var treeObj
// function getPageDataFromJson(res){
//     var data = res.data;   //数据
//     var total=1; 		//数据总数
//     var offset=1;  		//偏移量
//     var size=80;  		//页面大小
//     var cellData; 		//申报业务数组
//     var pageData = new Object();
//     for(var key in data){
//         if(key=="total"){
//             total = data[key];
//         }else if(key=="offset"){
//             offset = data[key]-0;
//         }else if(key=="size"){
//             size = data[key]-0;
//         }else{
//             if((typeof data[key]) === "object"){
//                 cellData = data[key];
//             }
//         }
//     }
//
//     var totalPage = parseInt((total+size-1)/size); //总页数
//     var currentPage = parseInt((offset+size-1)/size); //当前页数
//
//     pageData["records"] = total+""
//     pageData["page"] = currentPage;
//     pageData["total"] = totalPage;
//     pageData["rows"] = cellData;
//     return pageData;
//
// }
avalon.component("jdrwh",{
	template:temp,
	defaults: {
		params:{},
		searchData:{
		    czryDm:"",
            orderSql:"",
            pageSize:9999
		},
        zsjgList:[],
        formData:{
            id:"",
            czryDm:"",
            czryMc:"",
            qybz:"",
            jsMode:[],
            flgl:[],
            zsjgDm:[],
            swjgDm:[],
            limitSc:"",
            limitWm:"",
            limitQt:"",
            jdfs:"0"
		},
		act:1,
		onReady: function() {
			// fpxxwh.init();
			this.getTableRow();
			this.initTree();
			this.getZsjg();
		},
        //copy bg
        getZsjg:function(){
		    var self=this;
		    var params={
                swjgBz: "2"
            }
            ajax("POST","/glfw/sys/swjg/view",params).done(function(res){
                if(res.code=='0'){
                    self.zsjgList=res.data.swjgs;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "id", label: "ID", key: true, hidden: true, index: "id", sortable: true },
                { name: "czryDm", label: "操作人员代码", align: "left", index: "czryDm", width: 80, sortable: true },
                { name: "czryMc", label: "操作人员名称", align: "left", index: "czryMc", width: 80, sortable: true },
                { name: "fpbzMc", label: "标志", align: "center", index: "fpbzMc", width: 45, sortable: true },
                { name: "fpbz", label: "标志", align: "center", index: "fpbz", width: 45, sortable: true, hidden: true },
                { name: "qybzMc", label: "启用标志", align: "center", index: "qybzMc", width: 55, sortable: true, },
            ]
            self.createTable(tableArr)

        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#jdrwh-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                shrinkToFit: true,
                width:"100%",
                autowidth:true,
                altRows: true,
                multiselect: false,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: -1,
                pgbuttons: false,
                pginput:false,
                height:(function(){
                    return $(".jdrwh").height() -120;
                })(),
                beforeSelectRow:function(rowid,e){
                    var czryDm = getCellData("jdrwh-table", rowid, 'czryDm')
                    self.searchForm(czryDm);
                    return false;
                },onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.jdrwh')).val();
            self.search(1)
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = 9999;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#jdrwh-table").jqGrid('clearGridData')
            ajax("POST","/glfw/user/view",params).done(function(res){
                if(res.code=='0'){
                    $("#jdrwh-table").resetSelection();
                    $("#jdrwh-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },

        searchForm:function(czryDm){
            var self=this;
            var params={
                czryDm:czryDm
            }
            ajax("POST","/glfw/fpgl/view",params).done(function(res){
                if(res.code=='0'){
                    //这里返回结构有点复杂，和接单人查询共用一个接口，修改时需要注意
                    self.formData.id=res.data.fpgls[0].id||"";
                    self.formData.czryDm=res.data.fpgls[0].czryDm||"";
                    self.formData.czryMc=res.data.fpgls[0].czryMc||"";
                    self.formData.qybz=res.data.fpgls[0].qybz||"N";
                    self.formData.jsMode=res.data.fpgls[0].jsMode.split('.')||[];
                    self.formData.flgl=res.data.fpgls[0].flgl.split('.')||[];
                    self.formData.zsjgDm=res.data.fpgls[0].zsjgDm.split('.')||[];
                    self.formData.swjgDm=res.data.fpgls[0].swjgDm.split('.')||[];
                    self.formData.limitSc=res.data.fpgls[0].limitSc||"";
                    self.formData.limitWm=res.data.fpgls[0].limitWm||"";
                    self.formData.limitQt=res.data.fpgls[0].limitQt||"";
                    self.formData.jdfs=res.data.jdfs||'0';
                    self.checkTree();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        checkTree(arr){
            var treeObj=$.fn.zTree.getZTreeObj("jdrwhTree");
            treeObj.checkAllNodes(false);
            for(var i=0;i<this.formData.swjgDm.length;i++){
                var swjgdm=this.formData.swjgDm[i];
                treeObj.checkNode(treeObj.getNodeByParam('id',swjgdm),true);
            }
        },
        getCheckNode(){
            var treeObj=$.fn.zTree.getZTreeObj("jdrwhTree");
            var nodes = treeObj.getCheckedNodes(true);
            this.formData.swjgDm=[];
            for(var i=0;i<nodes.length;i++){
                this.formData.swjgDm.push(nodes[i].id);
            }
        },
        initTree: function() {
            var self = this;
            var setting = {
                check: {
                    enable: true,
                    chkboxType: {"Y":"s","N":"ps"},
                    chkStyle: "checkbox"
                },
                view: {
                    showIcon: false,
                    selectedMulti: false,
                },
                data:{key:{children:"item",name:"text"}},
                callback: {
                    onCheck:function () {
                        self.getCheckNode();
                    }
                }
            };
            ajax("POST","/cxfw/export/readtree",{nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($("#jdrwhTree"), setting, res.data);
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
        },
        setQybz:function(val){
            this.formData.qybz=val;
            this.saveForm();
        },
        saveForm:function(){
            var self=this;
            if(!this.formData.id){
                return ;
            }
            var params={
                id:self.formData.id,
                czryDms:self.formData.czryDm,//这里应该是接口拼写错误
                flgl:self.formData.flgl.join('.'),
                jsMode:self.formData.jsMode.join('.'),
                qybz:self.formData.qybz,
                limitSc:self.formData.limitSc,
                limitWm:self.formData.limitWm,
                limitQt:self.formData.limitQt,
                zsjgDm:self.formData.zsjgDm.join('.'),
                swjgDm:self.formData.swjgDm.join('.'),
            }
            ajax("POST","/glfw/fpgl/update",params).done(function(res){
                if (res.code == "0") {
                    tools.info("操作成功！");
                    self.searchForm(self.formData.czryDm);
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
	}
})