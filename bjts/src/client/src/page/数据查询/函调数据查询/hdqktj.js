var hdqktj=require("./hdqktj.html");
avalon.component('hdqktj', {
    template:hdqktj,
    defaults: {
        params:{},
        act:1,
	    tcode: "hdqkcx",
	    swjgmc: "",
        searchData:{
	        swjgdm:"",
	        cxrqq:"",
	        cxrqz:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        form:{

        },
	    timer:null,
	    tableArr:[],
	    tableOption:[],
	    tableData:{},
        onReady:function(){
            var self = this;
			try {
				this.searchData.swjgdm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
            self.initTree();
	        $('.hdqktj .datepicker.date-day').datepicker({
		        dateFormat: 'yy-mm-dd'
	        });
	        $('.hdqktj .datepicker.date-month').datepicker({
		        dateFormat: 'yymm'
	        });
        },
        changeTab:function(num){
            this.act=num;
        },
	    search:function(pageNo){
		    var self=this;
		    this.searchData.pageSize = $(".ui-pg-selbox", $('.hdqktj')).val() || 20;
		    var params=tools.clone(self.searchData);
		    params.pageNo=pageNo
            $("#hdqktj-table").jqGrid('clearGridData')
		    ajax("POST","/cxfw/hdqktjfx",params).done(function(res){
			    if(res.code=='0'){
				    self.form=res.data;
			    }else{
				    tools.info(res.msg);
			    }
		    }).fail(function(err){
			    tools.info(err);
		    })
	    },

	    showHyper:function(){
		    $('.hdqktj .select-sub').toggle();
		    $('.hdqktj .select-wrapper .icon').toggleClass("active");
		    if ($('.hdqktj .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
			    $('.hdqktj .select-wrapper .icon').attr("title","收起查询条件");
		    } else {
			    $('.hdqktj .select-wrapper .icon').attr("title","展开查询条件")
		    }
	    },
	    closeHyper:function(){
            $('.hdqktj .select-sub').hide();
            $('.hdqktj .select-wrapper .icon').removeClass('active');
            $('.hdqktj .select-wrapper .icon').attr("title","展开查询条件")
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

        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.swjgdm = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
	                    self.searchData.swjgdm = node.id;
	                    self.swjgmc = node.text;
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
                $.fn.zTree.init($(".hdqktj .treeDiv"), setting, data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
	        $(".treeDiv",$(e.target).parent()).show();
            $('.hdqktj').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.hdqktj').off('click');
        },
        exform:function(){
	        var self=this;
            if($('#hdqktj-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
	        var params = tools.clone(self.searchData)
	        var form = $("<form>"); //定义一个form表单
	        form.attr("style", "display:none");
	        form.attr("target", "hiddenframe");
	        form.attr("method", "post");
	        form.attr("action", "/cxfw/export/hdqktjfx");
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