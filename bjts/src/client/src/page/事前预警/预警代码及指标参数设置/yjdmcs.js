var yjdmcs=require("./yjdmcs.html");
avalon.component('yjdmcs', {
    template:yjdmcs,
    defaults: {
        params:{},
        act:1,
        tcode:"yjdmcs",
        searchData:{
            orderSql:"cl_date desc",
            pageSize:config.pageSize,
        },
        editRow:"",
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{
        },
        modelData:{

        },
        swjgDm:"",
        swjgMc:"",
        ptop:"0px",
        userLevel:"",  // 用户级别：province(省局)/city(市局)/county(区县局)
        swjgTreeData:[],  // 税务机关树形数据
        onReady:function(){
            var self=this;
            // 加载税务机关数据并判断用户级别
            self.loadSwjgData();
            this.getTableRow();
        },
        
        // 加载税务机关数据
        loadSwjgData:function(){
            var self = this;
            ajax("GET", "static/swjg.json", {}).done(function(res){
                if(res.code == '0'){
                    self.swjgTreeData = res.data;
                    // 判断用户级别
                    self.userLevel = self.getUserLevel();
                    console.log('用户级别:', self.userLevel, 'swjgDm:', avalonRoot.user.swjgDm);
                }
            }).fail(function(err){
                console.error('加载税务机关数据失败:', err);
            });
        },
        
        // 判断用户级别：province(省局)/city(市局)/county(区县局)
        getUserLevel:function(){
            var currentSwjgDm = avalonRoot.user.swjgDm;
            if(!currentSwjgDm || !this.swjgTreeData.length){
                return "unknown";
            }
            
            // 遍历树形结构，查找当前税务机关所在的层级
            var treeData = this.swjgTreeData;
            
            // 第一层：省局
            for(var i=0; i<treeData.length; i++){
                if(treeData[i].id === currentSwjgDm){
                    return "province";  // 省局
                }
                
                // 第二层：市局
                var cityNodes = treeData[i].item || [];
                for(var j=0; j<cityNodes.length; j++){
                    if(cityNodes[j].id === currentSwjgDm){
                        return "city";  // 市局
                    }
                    
                    // 第三层：区县局
                    var countyNodes = cityNodes[j].item || [];
                    for(var k=0; k<countyNodes.length; k++){
                        if(countyNodes[k].id === currentSwjgDm){
                            return "county";  // 区县局
                        }
                    }
                }
            }
            
            return "unknown";
        },

        changeTab:function(num){
            this.act=num;
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "yjcode", label: "预警代码", index: "yjcode", width: 60, align:"center",sortable: true },
                { name: "yjname", label: "预警名称", index: "yjname", sortable: true,align:"left", width: 150 ,formatter:function(cellvalue, options, rowObject){
                    if(rowObject.yxbz=="1"){
                        return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>"
                    }else{
                        return cellvalue;
                    }

                }},
                { name: "yjinfo", label: "描述", index: "yjinfo", sortable: true,align:"left", width: 400 ,},
                { name: "zxflag", label: "是否可选",hidden:true, index: "zxflag", sortable: true,align:"center", width: 80 ,},

                { name: "yjobject", label: "预警主对象", index: "yjobject", sortable: true,align:"center", width: 150 ,},
                { name: "yjlx", label: "预警计算类型",hidden:true, index: "yjlx", sortable: true,align:"center", width: 150 ,},
                { name: "yjlxZh", label: "预警计算类型", index: "yjlxZh", sortable: true,align:"center", width: 100 ,},
                { name: "tsywlx", label: "业务类型",hidden:true, index: "tsywlx", sortable: true,align:"center", width: 80 ,},
                { name: "tsywlxZh", label: "业务类型", index: "tsywlxZh", sortable: true,align:"center", width: 80 ,},
                { name: "swjgFw", label: "适用范围", index: "swjgFw", sortable: true,align:"center", width: 100 },
                { name: "syqy", label: "用于企业",hidden:true, index: "syqy", sortable: true,align:"center", width: 80 ,},
                { name: "syqyZh", label: "<span title='该预警信息是否展示给企业'>用于企业</span>", index: "syqyZh", sortable: true,align:"center", width: 80 ,hidden:true},
                { name: "yxbz", label: "启用标志", index: "yxbz",hidden:true, sortable: true,align:"center", width: 80 ,},
                { name: "zxflagZh", label: "<span title='该预警是否允许地市税务机关自行选择是否启用'>是否可选</span>", index: "zxflagZh", sortable: true,align:"center", width: 80 ,formatter: function(cellvalue, options, rowObject){
                        if(rowObject.yxbz=='1'){
                            return cellvalue
                        }else{
                            return "<span class='bg-gray'>"+cellvalue+"</span>"
                        }
                    }},
                { name: "op", label:"启用标志", index:"op", width:80, align:"center", resizable: false, search: false, sortable: true,editable :false,formatter: function(cellvalue, options, rowObject){
                    var userLevel = self.userLevel;
                    var swjgFw = rowObject.swjgFw || "";
                    var swjgFwLength = swjgFw.length;  // 3/5/7
                    var zxflag = rowObject.zxflag;
                    var yxbz = rowObject.yxbz;
                    
                    // 省局：全部显示文字
                    if(userLevel === "province"){
                        return rowObject.yxbzZh;
                    }
                    
                    // 市局：省级指标(3位) + zxflag='1' → 显示可切换开关
                    if(userLevel === "city"){
                        if(swjgFwLength === 3 && zxflag === '1'){
                            // yxbz='1' 显示开启(switch1)，yxbz='0' 显示关闭(switch0)
                            if(yxbz == '1' || yxbz == 1){
                                return "<div class='yjdmcs-switch1' style='float: none;display: inline-block;'></div>"
                            }else{
                                return "<div class='yjdmcs-switch0' style='float: none;display: inline-block;'></div>"
                            }
                        }
                        // 其他情况显示文字
                        return rowObject.yxbzZh;
                    }
                    
                    // 区县局：全部显示文字（不可切换）
                    if(userLevel === "county"){
                        return rowObject.yxbzZh;
                    }
                    
                    // 其他情况：显示文字
                    return rowObject.yxbzZh;
                }}
            ]
            self.createTable(tableArr)
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#yjdmcs-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#yjdmcs-tablePager',
                shrinkToFit: true,
                width:"100%",
                autowidth:true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".yjdmcs .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var b = getCellData("yjdmcs-table", rowid, 'yjcode')
                        var n = getCellData("yjdmcs-table", rowid, 'yjname')
                        var swjgFw = getCellData("yjdmcs-table", rowid, 'swjgFw')
                        // 传递swjgFw和userLevel到yjzbcs页面
                        avalonRoot.addTab({title:"指标参数设置",tip:"指标参数设置-"+n,component:"yjzbcs",sameCheck:true,params:{yjcode:b,tsjg:self.searchData.tsjg,swjgFw:swjgFw,userLevel:self.userLevel}});
                        return false;
                    }else if($(e.target).hasClass('yjdmcs-switch1') || $(e.target).hasClass('yjdmcs-switch0')){
                        // 可切换开关（市局省级指标）
                        var yxbz = getCellData("yjdmcs-table", rowid, 'yxbz');
                        var yjcode = getCellData("yjdmcs-table", rowid, 'yjcode');
                        console.log('开关点击 - yjcode:', yjcode, 'yxbz:', yxbz, '类型:', typeof yxbz);
                        
                        // 切换逻辑：1→0, 0→1
                        var newYxbz = (yxbz == '1' || yxbz == 1) ? 0 : 1;
                        console.log('切换后的值:', newYxbz);
                        
                        self.setYxbz(yjcode, newYxbz);
                        return false;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }

                },

                onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"yjdmcs-table");
                    self.search(pageNo);
                },
            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.yjdmcs')).val();
            self.search(1)

        },
        setGray:function(){
            $('#yjdmcs-table>tbody>tr').has('.bg-gray').css('background','#efefef')
        },
        setYxbz:function(code,bz){
            var self=this;
            if(code==undefined||bz==undefined){
                tools.info("yjcode或yxbz为空。")
                return ;
            }
            console.log('setYxbz 调用 - yjcode:', code, 'yxbz:', bz);
            var params={
                yjcode:code,
                yxbz:bz
            }
            ajax("POST","/bjtssw/yj/profile/qybz",params).done(function(res){
                console.log('setYxbz 响应:', res);
                if(res.code=='0'){
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                console.error('setYxbz 失败:', err);
                tools.info(err);
            })
        },
        resetTable:function() {
            $("#yjdmcs-table").setGridWidth($('.yjdmcs').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.yjdmcs')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#yjdmcs-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/yj/profile",params).done(function(res){
                if(res.code=='0'){
                    $("#yjdmcs-table").resetSelection();
                    $("#yjdmcs-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                    self.setGray();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        delRow:function(){
            var self=this;
            var incode=[]
            var rowids=$("#yjdmcs-table").jqGrid("getGridParam", "selarrrow");
            for (var i = 0; i < rowids.length; i++) {
                var b = getCellData("yjdmcs-table", rowids[i], 'incode');
                incode.push(b);
            }
            if(incode.length<=0){
                tools.info("请至少选择一条记录！");
                return false;
            }
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

        showModel:function(){
          $('.model').show();
          $('.yjdmcs .page-model').show();
        },
        hideModel:function(){
            $('.model').hide();
            $('.yjdmcs .page-model').hide();
            this.modelData={

            }
        },
        saveModel:function(){
            var self=this;
            var params=tools.clone(self.modelData)
            ajax("POST","",params).done(function(res){
                if(res.code=='0'){
                    self.hideModel();
                    self.search(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        exform:function(){
            var self=this;
            if($("#yjdmcs-table").jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("method", "post");
            form.attr("action", "/bjtssw/export/profile");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        }
    }
});