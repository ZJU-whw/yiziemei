var yjxxzhcx=require("./yjxxzhcx.html");
avalon.component('yjxxzhcx', {
    template:yjxxzhcx,
    defaults: {
        params:{},
        act:1,
        tcode:"zhcx",
        swjgDm:"",
        swjgMc:"",
        searchData:{
            qybs:"",
            qymc:"",
            yjcode:"",
            zbcode:"",
            bmdflag:"",
            clFlag:"",
            swjgDm:"",
            swjgMc:"",
            sbywbDm:"",
            sbym:"",
            clrqq:"",
            clrqz:"",
            yjObject:"",
            yjAmtStart:"",
            yjAmtEnd:"",
            orderSql:"cl_date desc",
            pageSize:config.pageSize,
        },
        timer:null,
        yjList:[],
        zbList:[],
        tableArr:[],
        tableOption:[],
        tableData:{
            sumData:{}
        },
        swjgList: [
            "13300000000",
            "13301000000",
            "13302000000",
            "13303000000",
            "13304000000",
            "13305000000",
            "13306000000",
            "13307000000",
            "13308000000",
            "13309000000",
            "13310000000",
            "13311000000",
          ], // 省市级税务机关代码列表
        setData:{
            zczt:"",
            ktpt:""
        },
        onReady:function(){
            try{
                this.hasHsPermission =this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
                this.searchData.swjgDm=avalonRoot.user.swjgDm;
                this.searchData.swjgMc=avalonRoot.user.swjgMc;
            }catch(e){
                // console.log(e);
            }
         
            var self = this;
            if(self.params){
                if(self.params.select){
                    self.searchData.yjcode = self.params.select
                }
                if(self.params.swjgDm&&self.params.swjgDm){
                    var startDate = self.params.startDate
                    var endDate = self.params.endDate
                    var clrqq = startDate.slice(0, 4)+'-'+startDate.slice(4)+'-01'
                    var clrqz = tools.getMonthLast(endDate.slice(0, 4)+'-'+endDate.slice(4)+'-01')
                    if(!self.hasHsPermission){
                        self.searchData.swjgDm=self.params.swjgDm;
                        self.searchData.swjgMc=self.params.swjgMc;
                    }else{
                        self.searchData.qybs = self.params.swjgDm
                    }
                    self.searchData.clrqq = clrqq
                    self.searchData.clrqz = clrqz
                }
            }
            this.getTableRow();
            self.initTree();
            $('.yjxxzhcx .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.yjxxzhcx .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });
            this.initYjList();
        },

        changeTab:function(num){
            this.act=num;
        },
        initYjList:function(){
            var self=this;
            ajax("POST","/bjtssw/yj/yjzb",{}).done(function(res){
                if(res.code=="0"){
                    self.yjList=res.data;
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        setZbList:function(e){
            var target=e.target;
            var yjcode=$(target)[0].value;
            var self=this;
            self.searchData.zbcode="";
            if(yjcode==""){
                self.zbList=[];
                return ;
            }
            for(var i=0;i<self.yjList.length;i++){
                if(yjcode==self.yjList[i].yjcode){
                    self.zbList=self.yjList[i].yjzb||[];
                    return ;
                }
            }
        },
        setZb:function(bzcode){
            this.searchData.zbcode=zbcode;
        },
        //copy bg
        getTableRow:function(){
            var self=this;
            ajax("POST","/cxfw/basis/columprofile",{tcode:self.tcode}).done(function(res){
                if(res.code=="0"){
                    var arr=res.data.profiles;
                    var tableArr=[];
                    var tableOption=[];
                    for(var i=0;i<arr.length;i++){
                        var obj={
                            name: arr[i].t_c_code,
                            label: arr[i].t_c_name,
                            index: arr[i].t_c_code,
                            sortable: arr[i].is_order==0?false:true,
                            hidden:false,
                            width: arr[i].c_std_size ,
                            align:arr[i].align==0?"left":arr[i].align==1?"center":"right",
                        }
                        if(obj.name=='nsrsbh'){
                            obj.formatter=function(cellvalue, options, rowObject){
                                return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>";
                            }
                        }
                        if(arr[i].degree){
                            var degree=arr[i].degree
                            obj.formatter=function(cellvalue, options, rowObject){
                                if(cellvalue===""||cellvalue===null||cellvalue===undefined){
                                    return "";
                                }
                                return avalon.filters.number(cellvalue,degree);
                            }
                        }
                        tableArr.push(obj)
                        if(arr[i].is_fixed=='0'){
                            tableOption.push({
                                name: arr[i].t_c_code,
                                label: arr[i].t_c_name,
                                show:false
                            })
                        }
                    }
                    self.tableArr=tableArr;
                    self.tableOption=tableOption;
                    if(tableArr.length>0){
                        self.createTable(tableArr)
                    };
                    var selected=res.data.select.split(",")
                    for(var j=0;j<selected.length;j++){
                        var name=selected[j]
                        for(var k=0;k<self.tableOption.length;k++){
                            if(name==self.tableOption[k].name){
                                self.tableOption[k].show=true;
                            }
                        }
                    }
                    self.resetTable();
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        createTable:function(arr){
            var self=this;
            var cm = [];
            for(var i=0;i<arr.length;i++) {
                cm[i] = tools.clone(arr[i]);
            }
            $("#yjxxzhcx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#yjxxzhcx-tablePager',
                shrinkToFit: false,
                width:"100%",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                footerrow:true,
                sortname: 'cl_date',
                sortorder: 'desc',
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".yjxxzhcx .form").height() -60-30;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        avalonRoot.addTab({title:"预警信息分户查询",tip:"预警信息分户查询-"+self.tableData.rows[rowid-1].nsrsbh,component:"yjxxfhcx",sameCheck:true,params:{nsrsbh:self.tableData.rows[rowid-1].nsrsbh}});
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
                },gridComplete: function(){
                    var sumData=self.tableData.sumData;
                    sumData[self.tableArr[0].name]="合计";
                    $("#yjxxzhcx-table").footerData('set', sumData);
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"yjxxzhcx-table");
                    self.search(pageNo);
                },

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.yjxxzhcx')).val();
            self.search(1)
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
            var self = this;
            for (var i = 0; i < self.tableOption.length; i++) {
                if (self.tableOption[i].show == true) {
                    $("#yjxxzhcx-table").showCol(self.tableOption[i].name)
                } else {
                    $("#yjxxzhcx-table").hideCol(self.tableOption[i].name)
                }
            }
            $("#yjxxzhcx-table").setGridWidth($('.yjxxzhcx').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.yjxxzhcx')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#yjxxzhcx-table").jqGrid('clearGridData')
            ajax("POST","/bjtssw/yj/zhcx/list",params).done(function(res){
                if(res.code=='0'){
                    self.tableData=res.data;
                    $("#yjxxzhcx-table").resetSelection();
                    $("#yjxxzhcx-table")[0].addJSONData(res.data);

                    self.closeHyper();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },

        showHyper:function(){
            $('.yjxxzhcx .select-sub').toggle();
            $('.yjxxzhcx .select-wrapper .icon').toggleClass("active");
            if ($('.yjxxzhcx .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.yjxxzhcx .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.yjxxzhcx .select-wrapper .icon').attr("title","展开查询条件")
            }
        },
        closeHyper:function(){
            $('.yjxxzhcx .select-sub').hide();
            $('.yjxxzhcx .select-wrapper .icon').removeClass('active');
            $('.yjxxzhcx .select-wrapper .icon').attr("title","展开查询条件")
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
        filMon:function(e){
            var date=e.target.value;
            var res=tools.MonCheup(date);
            if(res===false){
                tools.info("申报年月输入错误");
                res=""
            }
            e.target.value=res;
            return ;
        },
        filNum2:function(e){
            var date=e.target.value;
            e.target.value=date?avalon.filters.number(date,2):date;
            return false;
        },
        showMenu:function(e){
            var self=this;
            $(".dropdown-menu",e.target).show();
            $('.yjxxzhcx').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.yjxxzhcx').off('click');
        },

        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.swjgDm = node.id;
                        self.searchData.swjgMc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.swjgDm = node.id;
                        self.searchData.swjgMc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".yjxxzhcx .treeDiv"), setting, data);

            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.yjxxzhcx').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.yjxxzhcx').off('click');
        },
        reset: function() {
            var self=this;
            self.searchData={
                qybs:"",
                qymc:"",
                yjcode:"",
                zbcode:"",
                bmdflag:"",
                clFlag:"",
                swjgDm:avalonRoot.user.swjgDm,
                swjgMc:avalonRoot.user.swjgMc,
                sbywbDm:"",
                sbym:"",
                clrqq:"",
                clrqz:"",
                yjObject:"",
                yjAmtStart:"",
                yjAmtEnd:"",
                orderSql:"cl_date desc",
                pageSize:config.pageSize,
            }
        },
        exform:function(){
            var self=this;
            if($("#yjxxzhcx-table").jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            // form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/bjtssw/yj/zhcx/export");
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