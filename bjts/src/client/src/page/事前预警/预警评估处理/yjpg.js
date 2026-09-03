var yjpg=require("./yjpg.html");
avalon.component('yjpg', {
    template:yjpg,
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
            clFlag:"0",
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
        tableData:{},
        setData:{
            zczt:"",
            ktpt:""
        },
        onReady:function(){
            try{
                this.searchData.swjgDm=avalonRoot.user.swjgDm;
                this.searchData.swjgMc=avalonRoot.user.swjgMc;
            }catch(e){
                // console.log(e);
            }
         
            var self = this;
            this.getTableRow();
            self.initTree();
            $('.yjpg .datepicker.date-day').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            $('.yjpg .datepicker.date-month').datepicker({
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
            ajax("POST","/bjtssw/basis/columprofile",{tcode:self.tcode}).done(function(res){
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
            $("#yjpg-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#yjpg-tablePager',
                shrinkToFit: false,
                width:"100%",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".yjpg .form").height() -60;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        avalonRoot.addTab({title:"预警信息分户查询",tip:"预警信息分户查询-"+self.tableData.rows[rowid-1].nsrsbh,component:"yjxxfhcx",sameCheck:true,params:{nsrsbh:self.tableData.rows[rowid-1].nsrsbh,pgFlag:true}});
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
                    var pageNo=tools.getPageNo(pgButton,"yjpg-table");
                    self.search(pageNo);
                },

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.yjpg')).val();
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
                    $("#yjpg-table").showCol(self.tableOption[i].name)
                } else {
                    $("#yjpg-table").hideCol(self.tableOption[i].name)
                }
            }
            $("#yjpg-table").setGridWidth($('.yjpg').width())
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.yjpg')).val();
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#yjpg-table").jqGrid('clearGridData');
            ajax("POST","/bjtssw/yj/zhcx/list",params).done(function(res){
                if(res.code=='0'){
                    $("#yjpg-table").resetSelection();
                    $("#yjpg-table")[0].addJSONData(res.data);
                    self.tableData=res.data;
                    self.closeHyper();
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },

        showHyper:function(){
            $('.yjpg .select-sub').toggle();
            $('.yjpg .select-wrapper .icon').toggleClass("active");
            if ($('.yjpg .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.yjpg .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.yjpg .select-wrapper .icon').attr("title","展开查询条件")
            }
        },
        closeHyper:function(){
            $('.yjpg .select-sub').hide();
            $('.yjpg .select-wrapper .icon').removeClass('active');
            $('.yjpg .select-wrapper .icon').attr("title","展开查询条件")
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
            $('.yjpg').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.yjpg').off('click');
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
                $.fn.zTree.init($(".yjpg .treeDiv"), setting, data);

            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.yjpg').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.yjpg').off('click');
        },
        reset: function() {
            var self=this;
            self.searchData={
                qybs:"",
                qymc:"",
                yjcode:"",
                zbcode:"",
                bmdflag:"",
                clFlag:"0",
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
            if($('#yjpg-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var self=this;
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