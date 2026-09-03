var gjzyhwsb=require("./gjzyhwsb.html");
avalon.component('gjzyhwsb', {
    template:gjzyhwsb,
    defaults: {
        params:{},
        act:1,
        tcode:"qtywsbcx",
	    tsjgmc: "",
        searchData:{
            tsjg:"",
            qybs:"",
            qylx:"",
            gllb:"",
            lcjsFlag:"",
            lcfzcFlag:"",
            ssqq:"",
            ssqz:"",
            slrqq:"",
            slrqz:"",
            fhrqq:"",
            fhrqz:"",
	        ywhzrqq:"",
	        ywhzrqz:"",
            sehzrqq:"",
            sehzrqz:"",
            kprqq:"",
            kprqz:"",
            sbtsAmtq:"",
            sbtsAmtz:"",
            group:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        tableArr:[],
        tableOption:[],
        tableData:{
            sumData:{},
        },
        setData:{
            zczt:"",
            ktpt:""
        },
        groupList: [],
        onReady:function(){
            try {
                this.searchData.tsjg=avalonRoot.user.swjgDm;
                this.tsjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

            }
            var self = this;
            this.getTableRow();
            self.initTree();
            $('.gjzyhwsb .datepicker').datepicker({
                dateFormat: 'yy-mm-dd'
            });
            this.getGroup()
        },
        changeTab:function(num){
            this.act=num;
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
                        if(arr[i].degree){
                            var degree=arr[i].degree
                            obj.formatter=function(cellvalue, options, rowObject){
                                return avalon.filters.number(cellvalue,degree);
                            }
                        }
                        if(obj.name=='shxyno'){
                            obj.formatter=function(cellvalue, options, rowObject){
                                return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>";
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
            $("#gjzyhwsb-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#gjzyhwsb-tablePager',
                shrinkToFit: false,
                width:"100%",
                autowidth:true,
                altRows: true,
                footerrow:true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".gjzyhwsb .form").height() -120;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var obj = self.tableData.rows[rowid-1]
                        var tableNum = Number(sessionStorage.getItem('tableNum'))
                        sessionStorage.setItem('tableNum', tableNum+1)
                        avalonRoot.addTab({title:"其他业务申报明细",component:"gjzyhwsbMx",sameCheck:false,params:{lcslid:obj.lcslid,shxyno:obj.shxyno,sssq:obj.sb_ym}});
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
                gridComplete: function(){
                    var sumData=self.tableData.sumData;
                    sumData[self.tableArr[0].name]="合计";
                    $("#gjzyhwsb-table").footerData('set', sumData);
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"gjzyhwsb-table");
                    self.search(pageNo);
                }
            });
            $("#gjzyhwsb-table").jqGrid('setGroupHeaders', {
                useColSpanStyle: true,
                groupHeaders:[
                    {startColumnName:'swjgdm', numberOfColumns:3, titleText: '税务机关'},
                    {startColumnName:'nsrmc', numberOfColumns:5, titleText: '企业信息'},
                    {startColumnName:'sbywb_dm', numberOfColumns:13, titleText: '业务事项情况'},
                    {startColumnName:'bybl_amt', numberOfColumns:8, titleText: '审核情况'},
                    {startColumnName:'sehz_ts_amt', numberOfColumns:9, titleText: '核准情况'},
                    {startColumnName:'kp_ts_amt', numberOfColumns:5, titleText: '收核退调库情况'},
                    {startColumnName:'kp_ts_amt', numberOfColumns:4, titleText: '绩效情况'}
                ]
            });
            this.searchData.pageSize = $(".ui-pg-selbox", $('.gjzyhwsb')).val();
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
            ajax("POST","/cxfw/basis/columprofile/update",params).done(function(res){
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
                    $("#gjzyhwsb-table").showCol(self.tableOption[i].name)
                } else {
                    $("#gjzyhwsb-table").hideCol(self.tableOption[i].name)
                }
            }
            $("#gjzyhwsb-table").setGridWidth($('.gjzyhwsb').width())
        },normalSearch(){
            this.searchData.orderSql="";
            $('.s-ico').hide();
            this.search(1)
        },
        search:function(pageNo){
            var self=this;
	        var dataValid = [
                { start: 'slrqq', end: 'slrqz', msg: '受理日期'},
                { start: 'fhrqq', end: 'fhrqz', msg: '复审日期'},
                { start: 'ywhzrqq', end: 'ywhzrqz', msg: '业务核准日期'},
                { start: 'sehzrqq', end: 'sehzrqz', msg: '税额核准日期'},
                { start: 'kprqq', end: 'kprqz', msg: '开票日期'},
            ]
            for(var i=0; i<dataValid.length; i++) {
                var item = dataValid[i]
                var validItem = tools.checkDate(this.searchData[item.start], this.searchData[item.end])
                if (!validItem) {
                    tools.info(item.msg+'截止时间必须大于起始时间')
                    return false
                }
            }
            if (this.searchData.sbtsAmtq > this.searchData.sbtsAmtz) {
                tools.info('申报退税额止必须不小于申报退税额起')
                return false
            }
            this.searchData.pageSize = $(".ui-pg-selbox", $('.gjzyhwsb')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#gjzyhwsb-table").jqGrid('clearGridData')
            ajax("POST","/cxfw/qtywsbcx/first",params).done(function(res){
                if(res.code=='0'){self.tableData=res.data;
                    $("#gjzyhwsb-table").resetSelection();
                    $("#gjzyhwsb-table")[0].addJSONData(res.data);
                    self.closeHyper();

                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        showHyper:function(){
            $('.gjzyhwsb .select-sub').toggle();
            $('.gjzyhwsb .select-wrapper .icon').toggleClass("active");
            if ($('.gjzyhwsb .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.gjzyhwsb .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.gjzyhwsb .select-wrapper .icon').attr("title","展开查询条件")
            }
        },
        closeHyper:function(){
            $('.gjzyhwsb .select-sub').hide();
            $('.gjzyhwsb .select-wrapper .icon').removeClass('active');
            $('.gjzyhwsb .select-wrapper .icon').attr("title","展开查询条件")
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
        filMonth:function(e){
            var date=e.target.value;
            var res=tools.MonCheup(date);
            if(res===false){
                tools.info("所属期输入错误");
                res=""
            }
            e.target.value=res;
            return ;
        },
        showMenu:function(e){
            var self=this;
            $(".dropdown-menu",e.target).show();
            $('.gjzyhwsb').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }
            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.gjzyhwsb').off('click');
        },
        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.tsjg = node.id;
                        self.tsjgmc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
	                    self.searchData.tsjg = node.id;
	                    self.tsjgmc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".gjzyhwsb .treeDiv"), setting,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.gjzyhwsb').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.gjzyhwsb').off('click');
        },
        exform:function(){
            var self=this;
            if($('#gjzyhwsb-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            // form.attr("target", "_blank")
            form.attr("method", "post");
            form.attr("action", "/cxfw/export/gjzyhwcx");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
	    reset: function() {
		    this.searchData = {
                tsjg:avalonRoot.user.swjgDm,
                qybs:"",
                qylx:"",
                gllb:"",
                lcjsFlag:"",
                lcfzcFlag:"",
                ssqq:"",
                ssqz:"",
                slrqq:"",
                slrqz:"",
                fhrqq:"",
                fhrqz:"",
                ywhzrqq:"",
                ywhzrqz:"",
                sehzrqq:"",
                sehzrqz:"",
                kprqq:"",
                kprqz:"",
                sbtsAmtq:"",
                sbtsAmtz:"",
                group:"",
                orderSql:"",
                pageSize:config.pageSize,
            };
		    this.tsjgmc = avalonRoot.user.swjgMc;
	    },
        // 获取税务机关接单分组
        getGroup: function(){
            var self = this
            ajax("POST","/cxfw/swjgjd/group",{}).done(function(res){
                if(res.code=='0'){
                    self.groupList = res.data
                } else {
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        }
    }
});