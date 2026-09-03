var yjzbcs=require("./yjzbcs.html");
avalon.component('yjzbcs', {
    template:yjzbcs,
    defaults: {
        params:{
            yjcode:"",
            swjgFw:"",  // 接收指标适用范围
            userLevel:"",  // 接收用户级别 province/city/county
        },
        exClass:"",
        act:1,
        tcode:"yjzbcs",
        canEdit:false,  // 是否可编辑参数
        swjgTreeData:[],  // 税务机关树形数据
        searchData:{
            yjcode:"",
            zbcode:"",
            orderSql:"cl_date desc",
            pageSize:config.pageSize,
        },
        tsjg:"",
        editRow:"",
        timer:null,
        tableArr:[],
        tableOption:[],
        tableData:{
        },
        tableData4Qsmr:{
        },
        zbSelect:[],
        modelData:{
            zbcode:"",
            zbname:"",
            p1name:"",
            p2name:"",
            p3name:"",
            p4name:"",
            p1val:"",
            p2val:"",
            p3val:"",
            p4val:"",
            score:"",
            yxbz:"",
            swjgdm:"",
            swjgmc:"",
        },
        swjgDm:"",
        swjgMc:"",
        showFlag:true,
        showCustomFlag:true,  // 是否显示自定义预警参数指标维护
        onReady:function(){
            var self=this;
            // 使用从yjdmcs传递过来的userLevel
            self.userLevel = self.params.userLevel;
            console.log('yjzbcs - 接收的userLevel:', self.userLevel);
            
            // 加载税务机关树形数据（用于行级权限判断）
            self.loadSwjgTreeData();
            
            // 初始化
            self.canEdit = self.checkCanEdit();
            self.showCustomFlag = self.checkShowCustomFlag();
            
            try {
                this.modelData.swjgdm=avalonRoot.user.swjgDm;
                this.modelData.swjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

            }
            
            self.searchData.yjcode=self.params.yjcode;
            self.exClass="yjzbcs"+self.params.yjcode;
            self.tsjg=self.params.tsjg;
            if(tools.isXianju(avalonRoot.user.swjgDm)&&avalonRoot.user.swjgDm!="13300910000"){
                self.showFlag=false;
            }
            self.initTree();
            self.getTableRow();
            self.getTableRow4Qsmr();
            self.initZbSelect();//初始化指标类型下拉框
        },

        // 判断是否可编辑参数
        checkCanEdit:function(){
            var userLevel = this.params.userLevel;  // 直接使用传递的userLevel
            var swjgFw = this.params.swjgFw || "";
            var swjgFwLength = swjgFw.length;  // 3/5/7
            
            // 省局：全部不可编辑
            if(userLevel === "province"){
                return false;
            }
            
            // 市局：3位和5位可编辑，7位不可编辑
            if(userLevel === "city"){
                return swjgFwLength !== 7;
            }
            
            // 区县局：全部可编辑
            if(userLevel === "county"){
                return true;
            }
            
            return false;
        },
        
        // 判断是否显示自定义预警参数指标维护
        checkShowCustomFlag:function(){
            var userLevel = this.params.userLevel;  // 直接使用传递的userLevel
            
            // 省局：不显示
            if(userLevel === "province"){
                return false;
            }
            
            // 市局和区县局：显示
            return true;
        },
        
        // 加载税务机关树形数据
        loadSwjgTreeData:function(){
            var self = this;
            ajax("GET", "static/swjg.json", {}).done(function(res){
                if(res.code == '0'){
                    self.swjgTreeData = res.data;
                }
            }).fail(function(err){
                console.error('加载税务机关数据失败:', err);
            });
        },
        
        // 根据swjgdm长度判断数据所属层级：province(省局)/city(市局)/county(区县局)
        // getDataLevel:function(swjgdm){
        //     if(!swjgdm){
        //         return "unknown";
        //     }
            
        //     var length = swjgdm.length;
            
        //     // 3位：省局
        //     if(length === 3){
        //         return "province";
        //     }
            
        //     // 5位：市局
        //     if(length === 5){
        //         return "city";
        //     }
            
        //     // 7位：区县局
        //     if(length === 7){
        //         return "county";
        //     }
            
        //     return "unknown";
        // },
        
        // 判断行级权限：数据行是否可编辑（用于第二个表格）
        canEditRow:function(swjgdm){
            var currentUserSwjgDm = avalonRoot.user.swjgDm;
            
            console.log('canEditRow - 数据swjgdm:', swjgdm, '当前用户swjgDm:', currentUserSwjgDm, '可编辑:', swjgdm === currentUserSwjgDm);
            
            // 列表返回的swjgdm与当前登录用户的swjgDm相等则有编辑权限
            return swjgdm === currentUserSwjgDm;
        },
        
        changeTab:function(num){
            this.act=num;
        },



        getTableRow4Qsmr:function(){
            var self=this;
            var tableArr=[
                // { name: "swjgmc", label: "税务机关", index: "swjgmc", width: 85, align:"center",sortable: false },
                { name: "zbcode", label: "指标代码", index: "zbcode", width: 60, align:"left",sortable: false },
                { name: "zbname", label: "指标名称", index: "zbname", sortable: false,align:"center", width: 120 ,},
                { name: "jslx", label: "计算类型", index: "jslx", sortable: false,align:"center", width: 80 ,},
                { name: "p1name", label: "参数1", index: "p1name", sortable: false,align:"center", width: 90 ,},
                { name: "p1val", label: "数值1", index: "p1val", hidden:true,sortable: false,align:"center", width: 90 ,},
                { name: "p1valchange", label: "数值1", index: "p1valchange", sortable: false,align:"center", width: 90 ,},
                { name: "p2name", label: "参数2", index: "p2name", sortable: false,align:"center", width: 90 ,},
                { name: "p2val", label: "数值2", index: "p2val", hidden:true,sortable: true,align:"center", width: 110 ,},
                { name: "p2valchange", label: "数值2", index: "p2valchange", sortable: false,align:"center", width: 100 ,},
                { name: "p3name", label: "参数3", index: "p3name", sortable: false,align:"center", width: 90 ,},
                { name: "p3val", label: "数值3", index: "p3val", hidden:true,sortable: false,align:"center", width: 90 ,},
                { name: "p3valchange", label: "数值3", index: "p3valchange", sortable: false,align:"center", width: 100 ,},
                { name: "p4name", label: "参数4", index: "p4name", sortable: false,align:"center", width: 90 ,},
                { name: "p4val", label: "数值4", index: "p4val", hidden:true,sortable: false,align:"center", width: 110 ,},
                { name: "p4valchange", label: "数值4", index: "p4valchange", sortable: false,align:"center", width: 100 ,},
                { name: "score", label: "分值", index: "score", sortable: false,align:"center", width: 80 ,},
                // { name: "syqy", label: "<span title='该预警信息是否展示给企业'>用于企业</span>", index: "syqy", sortable: true,align:"center", width: 50 ,formatter: function(cellvalue, options, rowObject){
                //     if(cellvalue=='1'){
                //         return "是"
                //     }else{
                //         return "否"
                //     }
                // }},
                { name: "yxbz", label: "启用标志", index: "yxbz", sortable: false,align:"center", width: 50 ,},
                { name: "op", label:"操作", width:100, hidden:!self.canEdit, align:"center", resizable: false, search: false, sortable: false,editable :false,formatter: function(cellvalue, options, rowObject){
                    return "<div class='btn add' style='float: none;display: inline-block;' title='自定义添加'>自定义添加</div>"
                }}
            ]
            self.createTable4Qsmr(tableArr)
        },
        createTable4Qsmr:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#yjzbcs-table-qsmr"+self.exClass).jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#yjzbcs-tablePager-qsmr'+self.exClass,
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
                    return $("."+self.exClass+" .form").height() -60+34;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('add')){
                        self.modelData={
                            zbcode:self.tableData4Qsmr.rows[rowid-1].zbcode||'',
                            zbname:self.tableData4Qsmr.rows[rowid-1].zbname||'',
                            p1name:self.tableData4Qsmr.rows[rowid-1].p1name||'',
                            p2name:self.tableData4Qsmr.rows[rowid-1].p2name||'',
                            p3name:self.tableData4Qsmr.rows[rowid-1].p3name||'',
                            p4name:self.tableData4Qsmr.rows[rowid-1].p4name||'',
                            p1val:self.tableData4Qsmr.rows[rowid-1].p1valchange||'',
                            p2val:self.tableData4Qsmr.rows[rowid-1].p2valchange||'',
                            p3val:self.tableData4Qsmr.rows[rowid-1].p3valchange||'',
                            p4val:self.tableData4Qsmr.rows[rowid-1].p4valchange||'',
                            score:self.tableData4Qsmr.rows[rowid-1].score,
                            yxbz:self.tableData4Qsmr.rows[rowid-1].yxbz=="启用"?'Y':'N',
                            swjgdm:avalonRoot.user.swjgDm,
                            swjgmc:avalonRoot.user.swjgMc,
                        };
                        self.showModel("add");
                        return false;
                    }else if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }

                }
            })

            // self.search(1)
        },


        //copy bg
        getTableRow:function(){
            var self=this;
            var tableArr=[
                { name: "swjgdm", label: "税务机关代码", index: "swjgdm", hidden:true },
                { name: "swjgmc", label: "税务机关", index: "swjgmc", width: 85, align:"center",sortable: true },
                { name: "zbcode", label: "指标代码", index: "zbcode", width: 60, align:"left",sortable: true },
                { name: "zbname", label: "指标名称", index: "zbname", sortable: true,align:"center", width: 120 ,},
                { name: "jslx", label: "计算类型", index: "jslx", sortable: true,align:"center", width: 80 ,},
                { name: "p1name", label: "参数1", index: "p1name", sortable: true,align:"center", width: 70 ,},
                { name: "p1val", label: "数值1", index: "p1val", hidden:true,sortable: true,align:"center", width: 70 ,},
                { name: "p1valchange", label: "数值1", index: "p1valchange", sortable: true,align:"center", width: 70 ,},
                { name: "p2name", label: "参数2", index: "p2name", sortable: true,align:"center", width: 70 ,},
                { name: "p2val", label: "数值2", index: "p2val", hidden:true,sortable: true,align:"center", width: 70 ,},
                { name: "p2valchange", label: "数值2", index: "p2valchange", sortable: true,align:"center", width: 70 ,},
                { name: "p3name", label: "参数3", index: "p3name", sortable: true,align:"center", width: 70 ,},
                { name: "p3val", label: "数值3", index: "p3val", hidden:true,sortable: true,align:"center", width: 70 ,},
                { name: "p3valchange", label: "数值3", index: "p3valchange", sortable: true,align:"center", width: 70 ,},
                { name: "p4name", label: "参数4", index: "p4name", sortable: true,align:"center", width: 70 ,},
                { name: "p4val", label: "数值4", index: "p4val", hidden:true,sortable: true,align:"center", width: 70 ,},
                { name: "p4valchange", label: "数值4", index: "p4valchange", sortable: true,align:"center", width: 70 ,},
                { name: "score", label: "分值", index: "score", sortable: true,align:"center", width: 70 ,},
                // { name: "syqy", label: "<span title='该预警信息是否展示给企业'>用于企业</span>", index: "syqy", sortable: true,align:"center", width: 50 ,formatter: function(cellvalue, options, rowObject){
                //     if(cellvalue=='1'){
                //         return "是"
                //     }else{
                //         return "否"
                //     }
                // }},
                { name: "yxbz", label: "启用标志", index: "yxbz", sortable: true,align:"center", width: 50 ,},
                { name: "op", label:"操作", width:120, hidden:!self.canEdit, align:"center", resizable: false, search: false, sortable: true,editable :false,formatter: function(cellvalue, options, rowObject){
                    // 行级权限控制：如果数据属于上级，则禁用操作按钮
                    var canEditRow = self.canEditRow(rowObject.swjgdm);
                    if(!canEditRow){
                        // 显示禁用的按钮
                        return "<div class='btn edit disabled' style='float: none;display: inline-block;' title='编辑'>编辑</div> <div class='btn del disabled' style='float: none;display: inline-block;' title='删除'>删除</div>"
                    }
                    return "<div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div> <div class='btn del' style='float: none;display: inline-block;' title='删除'>删除</div>"
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
            $("#yjzbcs-table"+self.exClass).jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#yjzbcs-tablePager'+self.exClass,
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
                    // console.log($("."+self.exClass+" .form").height() -60+34+310)
                    return window.innerHeight-$("."+self.exClass+" .form").height() -255;
                })(),
                // height: "calc(100% - 470px)",
                beforeSelectRow:function(rowid,e){
                    // 判断是否为禁用按钮
                    if($(e.target).hasClass('disabled')){
                        return false;  // 禁用按钮，直接返回
                    }
                    
                    if($(e.target).hasClass('edit')){
                        self.modelData={
                            zbcode:self.tableData.rows[rowid-1].zbcode||'',
                            zbname:self.tableData.rows[rowid-1].zbname||'',
                            p1name:self.tableData.rows[rowid-1].p1name||'',
                            p2name:self.tableData.rows[rowid-1].p2name||'',
                            p3name:self.tableData.rows[rowid-1].p3name||'',
                            p4name:self.tableData.rows[rowid-1].p4name||'',
                            p1val:self.tableData.rows[rowid-1].p1valchange||'',
                            p2val:self.tableData.rows[rowid-1].p2valchange||'',
                            p3val:self.tableData.rows[rowid-1].p3valchange||'',
                            p4val:self.tableData.rows[rowid-1].p4valchange||'',
                            score:self.tableData.rows[rowid-1].score,
                            yxbz:self.tableData.rows[rowid-1].yxbz=="启用"?'Y':'N',
                            swjgdm:self.tableData.rows[rowid-1].swjgdm ||'',
                            swjgmc:self.tableData.rows[rowid-1].swjgmc ||'',
                        };
                        self.showModel("edit");
                        return false;
                    }else if($(e.target).hasClass('del')){
                        var rowData = $("#yjzbcs-table"+self.exClass).jqGrid("getRowData",rowid);
                        var swjgdm = rowData.swjgdm;
                        var zbcode = rowData.zbcode;
                        var swjgmc = rowData.swjgmc;
                        var zbname = rowData.zbname;
                        tools.confirm("是否删除" + swjgmc + "自定义预警参数指标【" + zbname + "】","确定",function(){
                            self.delYjzbSwjg(swjgdm,zbcode);
                        });
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
                    self.searchPositive(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo2(pgButton,"yjzbcs-tablePager"+self.exClass);
                    self.searchPositive(pageNo);
                },
            })

            self.search(1)

        },
        setGray:function(){
            $("#yjzbcs-table"+self.exClass+">tbody>tr").has('.bg-gray').css('background','#efefef')
        },
        setTableOption:function(){
            var self=this;
            setTimeout(function(){
                self.resetTable();
            },200);
            if(self.timer==null){
                self.timer=setTimeout(function(){
                    self.updataOption();
                    clearTimeout(self.timer);
                    self.timer=null;
                },2000)
            }else{
                clearTimeout(self.timer);
                self.timer=setTimeout(function(){
                    self.updataOption();
                    clearTimeout(self.timer);
                    self.timer=null;
                },2000)
            }
        },
        updataOption:function(){
            var self=this;
            var cs=[];
            for(var i=0;i<self.tableOption.length;i++){
                if(self.tableOption[i].show==true){
                    cs.push(self.tableOption[i].name)
                }
            }
            var params={
                tcode:this.tcode,
                cs:cs.join(',')
            }
            ajax("POST","/bjtssw/basis/columprofile/update",params).done(function(res){
                if(res.code!='0'){
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        resetTable:function() {
            $("#yjzbcs-table"+self.exClass).setGridWidth($('.'+self.exClass).width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $('.'+self.exClass+" .ui-pg-selbox").val();
            var params=tools.clone(self.searchData);
            params.tsjg=self.tsjg;
            params.pageNo=pageNo
            $("#yjzbcs-table"+self.exClass).jqGrid('clearGridData');
            $("#yjzbcs-table-qsmr"+self.exClass).jqGrid('clearGridData');
            ajax("POST","/bjtssw/yj/profile/mx",params).done(function(res){
                if(res.code=='0'){
                    // $('.'+self.exClass+" #yjzbcs-table"+self.exClass+self.exClass).resetSelection();
                     $("#yjzbcs-table"+self.exClass)[0].addJSONData(res.data.yhsz);
                    $("#yjzbcs-table-qsmr"+self.exClass)[0].addJSONData(res.data.qsmr);
                    self.tableData=res.data.yhsz;
                    self.tableData4Qsmr=res.data.qsmr;
                    self.setGray();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },

        searchPositive:function(pageNo){
            var self=this;
            this.searchData.pageSize = $('.'+self.exClass+" .ui-pg-selbox").val();
            var params=tools.clone(self.searchData);
            params.tsjg=self.tsjg;
            params.pageNo=pageNo
            $("#yjzbcs-table"+self.exClass).jqGrid('clearGridData');
            ajax("POST","/bjtssw/yj/profile/mx/ds",params).done(function(res){
                if(res.code=='0'){
                    // $('.'+self.exClass+" #yjzbcs-table"+self.exClass+self.exClass).resetSelection();
                    $("#yjzbcs-table"+self.exClass)[0].addJSONData(res.data);
                    self.tableData=res.data;
                    self.setGray();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        initZbSelect:function(){
            var self=this;
            var params=tools.clone(self.searchData);
            ajax("POST","/bjtssw/yj/profile/mx/getZbSelect",params).done(function(res){
                if(res.code=='0'){
                    self.zbSelect=res.data;
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        //税务机关代码和指标代码删除数据
        delYjzbSwjg: function(swjgdm,zbcode) {
            var self = this;
            var params = {};
            params.swjgdm=swjgdm;
            params.zbcode=zbcode
            ajax("POST","/bjtssw/yj/profile/mx/delete",params).done(function(res){
                if(res.code=='0'){
                    tools.info("删除成功!");
                    self.searchPositive(1);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
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
        //copy
        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.modelData.swjgdm = node.id;
                        self.modelData.swjgmc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.modelData.swjgdm = node.id;
                        self.modelData.swjgmc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };

            ajax("POST","/cxfw/export/readtree",{nodeType:"3"}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($(".page-model #yjzbcs",$('.'+self.exClass)), setting, res.data);
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err)
            })
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.page-model').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.page-model',$('.'+self.exClass)).off('click');
        },
        showModel:function(type){
            var self=this;
          $('.model').show();
          $('.page-model',$('.'+self.exClass)).show();
            if(type == "add"){
                $('#swjgTree').attr("disabled",false);
            }else{
                $('#swjgTree').attr("disabled",true);
            }
        },
        hideModel:function(){
            var self=this;
            $('.model').hide();
            $('.page-model',$('.'+self.exClass)).hide();
            this.modelData= {
                zbcode:"",
                zbname:"",
                p1name:"",
                p2name:"",
                p3name:"",
                p4name:"",
                p1val:"",
                p2val:"",
                p3val:"",
                p4val:"",
                score:"",
                yxbz:"",
                swjgdm:"",
                swjgmc:"",
            }
        },
        saveModel:function(){
            var self=this;
            var params=tools.clone(self.modelData)
            if(!/^(\-|\+)?\d*(\.\d+)?$/.test(params.p1val)||!/^(\-|\+)?\d*(\.\d+)?$/.test(params.p2val)||!/^(\-|\+)?\d*(\.\d+)?$/.test(params.p3val)||!/^(\-|\+)?\d*(\.\d+)?$/.test(params.p4val)){
                tools.info("请输入正确的数值！");
                return ;
            }
            if(!/^-?[0-9]*$/.test(params.score)){
                tools.info("请输入正确的分值！");
                return ;
            }
            params.tsjg=self.tsjg;
            ajax("POST","/bjtssw/yj/profile/mx/qybz",params).done(function(res){
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
            if($("#yjzbcs-table"+self.exClass).jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData);
            params.tsjg=self.tsjg;
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            // form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/bjtssw/export/profile/mx");
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