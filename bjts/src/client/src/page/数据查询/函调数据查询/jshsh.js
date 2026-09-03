var jshsh=require("./jshsh.html");
avalon.component('jshsh', {
    template:jshsh,
    defaults: {
        params:{},
        act:1,
	    tcode: "jshshcx",
        searchData:{
	        shjg:"",
	        jchbh:"",
	        sfyfh:"",
			sfyq:"",
			xsyfh:"",
			gfmc:"",
			gfsh:"",
			xfmc:"",
			xfsh:"",
			hflx:"",
			shsjq:"",
			shsjz:"",
			fhsjq:"",
			fhsjz:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
	    timer:null,
	    tableArr:[],
	    tableOption:[],
	    tableData:{},
        onReady:function(){
            var self = this;
	        this.getTableRow();
	        // self.initTree();
	        $('.jshsh .datepicker.date-day').datepicker({
		        dateFormat: 'yy-mm-dd'
	        });
	        $('.jshsh .datepicker.date-month').datepicker({
		        dateFormat: 'yymm'
	        });
        },
        changeTab:function(num){
            this.act=num;
        },
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
		    $("#jshsh-table").jqGrid({
			    datatype: "local",
			    gridview: true,
			    colModel: cm,
			    viewrecords: true,
			    rownumbers:true,
			    pager: '#jshsh-tablePager',
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
				    return $(".jshsh .form").height() -100;
			    })(),
			    beforeSelectRow:function(rowid,e){
				    if($(e.target).hasClass('openMx')){
					    var b = getCellData("jshsh-table", rowid, 'taxpayerCode')
					    avalonRoot.addTab({title:"不予退税明细",component:"jshshMx",sameCheck:false,params:{lcslid:self.tableData.rows[rowid-1].lcslid}});
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
				    var pageNo=tools.getPageNo(pgButton,"jshsh-table");
				    self.search(pageNo);
			    }
		    })
		    this.searchData.pageSize = $(".ui-pg-selbox", $('.jshsh')).val();
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
				    $("#jshsh-table").showCol(self.tableOption[i].name)
			    } else {
				    $("#jshsh-table").hideCol(self.tableOption[i].name)
			    }
		    }
		    $("#jshsh-table").setGridWidth($('.jshsh').width())
	    },
	    search:function(pageNo){
		    var self=this;
		    this.searchData.pageSize = $(".ui-pg-selbox", $('.jshsh')).val() || 20;
		    var params=tools.clone(self.searchData);
		    params.pageNo=pageNo
            $("#jshsh-table").jqGrid('clearGridData')
		    ajax("POST","/cxfw/jshshcx",params).done(function(res){
			    if(res.code=='0'){
				    $("#jshsh-table").resetSelection();
				    $("#jshsh-table")[0].addJSONData(res.data);
				    self.tableData=res.data;
			    }else{
				    tools.info(res.msg);
			    }
		    }).fail(function(err){
			    tools.info(err);
		    })
	    },

	    showHyper:function(){
		    $('.jshsh .select-sub').toggle();
		    $('.jshsh .select-wrapper .icon').toggleClass("active");
		    if ($('.jshsh .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
			    $('.jshsh .select-wrapper .icon').attr("title","收起查询条件");
		    } else {
			    $('.jshsh .select-wrapper .icon').attr("title","展开查询条件")
		    }
	    },
	    closeHyper:function(){
            $('.jshsh .select-sub').hide();
            $('.jshsh .select-wrapper .icon').removeClass('active');
            $('.jshsh .select-wrapper .icon').attr("title","展开查询条件")
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
            $('.jshsh').on('click',function(e){
                var e=e||window.event;
                if($('.dropdown-menu').find($(e.target)).length<=0){
                    self.hideMenu();
                }

            })
        },
        hideMenu:function(){
            $(".dropdown-menu").hide();
            $('.jshsh').off('click');
        },
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.opDeptCode = node.id;
                        self.searchData.opDeptName = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.opDeptCode = node.id;
                        self.searchData.opDeptName = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{
                    key:{
                        children:"item",
                        name:"text"
                    }
                }
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".jshsh .treeDiv"), setting,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
	        $(".treeDiv",$(e.target).parent()).show();
            $('.jshsh').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.jshsh').off('click');
        },
        exform:function(){
	        var self=this;
            if($('#jshsh-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
	        var params = tools.clone(self.searchData)
	        var form = $("<form>"); //定义一个form表单
	        form.attr("style", "display:none");
	        form.attr("target", "hiddenframe");
	        form.attr("method", "post");
	        form.attr("action", "/cxfw/export/jshshcx");
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
				shjg:"",
				jchbh:"",
				sfyfh:"",
				sfyq:"",
				xsyfh:"",
				gfmc:"",
				gfsh:"",
				xfmc:"",
				xfsh:"",
				hflx:"",
				shsjq:"",
				shsjz:"",
				fhsjq:"",
				fhsjz:"",
				orderSql:"",
				pageSize:config.pageSize,
			}
	    }
    }
});