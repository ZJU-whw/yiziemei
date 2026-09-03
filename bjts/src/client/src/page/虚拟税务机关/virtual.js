var temp = require("./virtual.html");
avalon.component("virtual",{
    template:temp,
    defaults: {
        params:{},
        searchData:{

        },
        zsjgList:[],
        formData:{
            yxbz:"",
            virSwjgdm:"",
            virName:"",
            sublist:[],

        },
        showFlag:false,
        tableData:[],
        act:1,
        actIndex:"",
        onReady: function() {
            this.initTree();
            this.search(1);
        },
        //copy bg

        search:function(pageNo){
            var self=this;
            ajax("POST","/bjtssw/tjbb/mgt/virswjg/list",{}).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    self.actIndex="";
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },

        checkTree(arr){
            var treeObj=$.fn.zTree.getZTreeObj("virtualTree");
            treeObj.checkAllNodes(false);
            for(var i=0;i<arr.length;i++){
                var swjgdm=arr[i].swjgdm;
                treeObj.checkNode(treeObj.getNodeByParam('id',swjgdm),true);
            }
        },
        getCheckNode(){
            var treeObj=$.fn.zTree.getZTreeObj("virtualTree");
            var nodes = treeObj.getCheckedNodes(true);
            this.formData.sublist=[];
            for(var i=0;i<nodes.length;i++){
                this.formData.sublist.push({swjgdm:nodes[i].id,swjgmc:nodes[i].text});
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
            ajax("POST","/bjtssw/basis/readtree",{}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($("#virtualTree"), setting, res.data);
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
        },
        setQybz:function(val){
            var self=this;
            self.formData.yxbz=val;
            var params={
                virSwjgdm:self.formData.virSwjgdm,
                yxbz:self.formData.yxbz
            }
            ajax("POST","/bjtssw/tjbb/mgt/virswjg/qybz",params).done(function(res){
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
        setForm:function(index){
            var self=this;
            self.actIndex=index;
            self.formData={
                yxbz:self.tableData[index].yxbz,
                virSwjgdm:self.tableData[index].virSwjgdm,
                virName:self.tableData[index].virName,
                sublist:self.tableData[index].sublist,
            }
            self.checkTree(self.formData.sublist)
            self.showFlag=true;
        },
        delForm:function(){
            var self=this;
            if(self.actIndex===""){
                tools.info("请先选择一条记录");
                return ;
            }
            var params={
                virSwjgdm:encodeAesString(self.tableData[self.actIndex].virSwjgdm)
            }
            ajax("POST","/bjtssw/tjbb/mgt/virswjg/del",params).done(function(res){
                if (res.code == "0") {
                    tools.info("操作成功！");
                    self.search();
                    self.showFlag=false;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        initForm:function(){
            var self=this;
            self.actIndex="";
            self.formData={
                yxbz:"Y",
                virSwjgdm:"",
                virName:"",
                sublist:[],
            }
            self.checkTree(self.formData.sublist)
            self.showFlag=true;
        },
        saveForm:function(){
            var self=this;
            var params=tools.clone(self.formData)
            if(params.sublist.length<2){
                tools.info("必须选择2个（含）以上下辖税务机关")
                return ;
            }
            if(self.formData.virSwjgdm==""){
                var url="/bjtssw/tjbb/mgt/virswjg/save"
            }else{
                url="/bjtssw/tjbb/mgt/virswjg/update"
            }
            ajax("POST",url,params).done(function(res){
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

    }
})