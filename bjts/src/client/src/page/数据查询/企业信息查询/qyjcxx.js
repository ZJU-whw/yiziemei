var qyjcxx=require("./qyjcxx.html");
avalon.component('qyjcxx', {
    template:qyjcxx,
    defaults: {
        params:{},
        act:1,
        timer:null,
        tcode:"qyxx",
	    swjgmc: "",
	    swjgData: [],
        searchData:{
            shxy_no:"",
            qydm:"",
            name:"",
	        qfbz:"",
            address:"",
            jy_address:"",
            zgswskfj_dm:"",
            zgswskfjmc:"",
            swcode:"",
            tsswname:"",
            qylx:"",
            nsrlb:"",
            nsrztcode:"",
            nsrzt:"",
            js_mode:"",
            ysjccode:"",
            tkjc:"",
            sq_dateq:"",
            sq_datez:"",
            ysfw:"",
            wzfqy:"",
            wzhqy:"",
            sdqqy:"",
            yfjg:"",
            qs_flag:"",
            jcpg_flag:"",
            xhhc_flag:"",
	        pgjc_flag:"",
	        tszh_sfyz:"",
	        bzch_sfyz:"",
	        glyz_flag:"",
            hd_flag:"",
            xydj:"",
            gllb:"",
            shgry: "",
            dcpggry:"",
            tszh:"",
            tszh_js:"",
            tszh_flag:"",
            bach:"",
            bach_js:"",
            bach_flag:"",
            gl_js:"",
            gl_flag:"",
            jdxz_dm:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        jdxz_mc:"",
        tableArr:[],
        tableOption:[],
        tableData:{},
        onReady:function(){
            var self = this;
            try {
                this.searchData.swcode=avalonRoot.user.swjgDm;
                this.swjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

            }
            this.getTableRow();
            self.initTree();
            self.initStreetTree();
            $('.qyjcxx .datepicker').datepicker({
                dateFormat: 'yy-mm-dd'
            });
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
                        if(obj.name=='shxy_no'){
                            obj.formatter=function(cellvalue, options, rowObject){
                                if(!cellvalue){
                                    return "";
                                }
                                return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='openMx'>"+cellvalue+"</span>";
                            }
                        }
                        if(obj.name=='name'){
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
            $("#qyjcxx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: cm,
                viewrecords: true,
                rownumbers:true,
                pager: '#qyjcxx-tablePager',
                shrinkToFit: false,
                width:"100%",
                // multiselect: true,
                // multiselectWidth:"30",
                autowidth:true,
                altRows: true,
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                rowList: [20,50,100,500],
                height:(function(){
                    return $(".qyjcxx .form").height() -100;
                })(),
                beforeSelectRow:function(rowid,e){
                    if($(e.target).hasClass('openMx')){
                        var b = getCellData("qyjcxx-table", rowid, 'taxpayerCode')
                        avalonRoot.addTab({title:"企业基础信息明细",component:"qyjcxxMx",sameCheck:false,params:{nsrdj_no:self.tableData.rows[rowid-1].nsrdj_no}});
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
                    var pageNo=tools.getPageNo(pgButton,"qyjcxx-table");
                    self.search(pageNo);
                }

            })
            this.searchData.pageSize = $(".ui-pg-selbox", $('.qyjcxx')).val();
            // self.search(1)
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
                    $("#qyjcxx-table").showCol(self.tableOption[i].name)
                } else {
                    $("#qyjcxx-table").hideCol(self.tableOption[i].name)
                }
            }
            $("#qyjcxx-table").setGridWidth($('.qyjcxx').width())
        },
        search:function(pageNo){
            var self=this;
	        var fields = [
	        	{name:"qydm",rules:'max_length[10]',message:"海关代码最大长度为10"},
	        	{name:"shxy_no",rules:'max_length[21]',message:"社会信用代码最大长度为21"},
	        	{name:"name",rules:'max_length[30]',message:"企业名称最大长度为30"},
	        	];
	        var isValid = tools.validate("qyjcxx-form",fields);
	        if (isValid) {
		        this.searchData.pageSize = $(".ui-pg-selbox", $('.qyjcxx')).val() || 20;
		        var params=tools.clone(self.searchData);
		        delete params.shgry;
		        delete params.dcpggry;
		        delete params.xydj;
		        delete params.qfbz;
		        delete params.xhhc_flag;
		        delete params.pgjc_flag;
		        delete params.tszh_sfyz;
		        delete params.bzch_sfyz;
		        delete params.glyz_flag;
		        params.pageNo=pageNo;
                $("#qyjcxx-table").jqGrid('clearGridData')
		        ajax("POST","/cxfw/qyxxcx/first",params).done(function(res){
			        if(res.code=='0'){
				        $("#qyjcxx-table").resetSelection();
				        $("#qyjcxx-table")[0].addJSONData(res.data);
				        self.tableData=res.data;
                        self.closeHyper();
			        }else{
				        tools.info(res.msg);
			        }
		        }).fail(function(err){
			        tools.info(err);
		        })
	        }
        },
        showHyper:function(){
            $('.qyjcxx .select-sub').toggle();
            $('.qyjcxx .select-wrapper .icon').toggleClass("active");
            if ($('.qyjcxx .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
                $('.qyjcxx .select-wrapper .icon').attr("title","收起查询条件");
            } else {
                $('.qyjcxx .select-wrapper .icon').attr("title","展开查询条件")
            }
        },
        closeHyper:function(){
            $('.qyjcxx .select-sub').hide();
            $('.qyjcxx .select-wrapper .icon').removeClass('active');
            $('.qyjcxx .select-wrapper .icon').attr("title","展开查询条件")
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
            $('.qyjcxx').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.qyjcxx').off('click');
        },

        //copy
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.swcode = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.swcode = node.id;
	                    self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".qyjcxx #qyjcssTsjg"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        initStreetTree:function(){
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.jdxz_dm = node.id;
                        self.jdxz_mc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.jdxz_dm = node.id;
                        self.jdxz_mc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            ajax("POST","/cxfw/common/streetTree",{}).done(function(res){
                if(res.code=='0'){
                    $.fn.zTree.init($(".qyjcxx #qyjcssJdxz"), setting, res.data);
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
            $('.qyjcxx').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.qyjcxx').off('click');
        },
        exform:function(){
            var self=this;
            if($('#qyjcxx-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/cxfw/export/qyxx");
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
                shxy_no:"",
                jdxz_dm:"",
                qydm:"",
                name:"",
                qfbz:"",
                address:"",
                jy_address:"",
                zgswskfj_dm:"",
                zgswskfjmc:"",
                swcode:avalonRoot.user.swjgDm,
                tsswname:"",
                qylx:"",
                nsrlb:"",
                nsrztcode:"",
                nsrzt:"",
                js_mode:"",
                ysjccode:"",
                tkjc:"",
                sq_dateq:"",
                sq_datez:"",
                ysfw:"",
                wzfqy:"",
                wzhqy:"",
                sdqqy:"",
                yfjg:"",
                qs_flag:"",
                jcpg_flag:"",
                xhhc_flag:"",
                pgjc_flag:"",
                tszh_sfyz:"",
                bzch_sfyz:"",
                glyz_flag:"",
                hd_flag:"",
                xydj:"",
                gllb:"",
                shgry: "",
                dcpggry:"",
                tszh:"",
                tszh_js:"",
                tszh_flag:"",
                bach:"",
                bach_js:"",
                bach_flag:"",
                gl_js:"",
                gl_flag:"",
                orderSql:"",
                pageSize:config.pageSize,
            }
            this.swjgmc = avalonRoot.user.swjgMc;
            this.jdxz_mc = "";
        }
    }
});