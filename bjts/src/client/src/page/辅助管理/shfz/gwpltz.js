var gwpltz = require("./gwpltz.html");
avalon.component("gwpltz",{
    template: gwpltz,
    defaults: {
        act:"1",
	    gwdm:"SH01",
	    user_before:"",
	    user_after:"",
        formData: {
	        swjgmc:"",
	        before:[{user_id:"",czry_mc:""}],
	        after:[{user_id:"",czry_mc:""}],
        },
        onReady: function() {
            var self=this;
	        this.gwdm = "SH01";
	        ajax("POST","/glfw/fztsgwpl/gettzry",{shgwdm:"SH01"}).done(function(res){
		        if(res.code=="0"){
			        self.formData = res.data;
		        }else{
			        tools.info(res.msg)
		        }
	        }).fail(function(err){
		        tools.info(err);
	        })
            this.createTable();
        },
        createTable:function(){
            var self=this;
            var columns = [
                { name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
                { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",align:"center",sortable: true },
                { name: "nsrmc", label: "企业名称", index: "nsrmc", align:"left",sortable: true },
            ];
            $("#gwpltz-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#gwpltz-tablePager',
                shrinkToFit: true,
                autowidth:true,
                altRows: true,
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                width:"100%",
                height:(function(){
                    return $(".gwpltz .form").height() -160;
                })(),
                beforeSelectRow:function(rowid,e){
                    if(e.target.nodeName=="TD"){
                        $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
                        return false;
                    }else{
                        return true;
                    }
                },onSortCol: function (index, iCol, sortorder) {
                    self.searchData.orderSql = index + ' ' + sortorder;
                    self.search(1);
                    return;
                },
                onPaging:function(pgButton){
                    var pageNo=tools.getPageNo(pgButton,"gwpltz-table");
                    self.search(pageNo);
                }
            });
            // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
            // self.search(1);
        },
	    /**
	     * @Description: 选择岗位人员去获取该人员分管企业
	     * @author LongSX
	     * @date 2020/3/12
	    */
	    handleSelect: function(e) {
	    	var shgwdm = this.gwdm;
		    var user_id = e.target.value;
		    if (!shgwdm || !user_id) return;
            $("#gwpltz-table").jqGrid('clearGridData')
		    ajax("POST","/glfw/fztsgwpl/getfgqy",{shgwdm:shgwdm,user_id: user_id}).done(function(res){
			    if(res.code=="0"){
				    $("#gwpltz-table").resetSelection();
				    $("#gwpltz-table")[0].addJSONData(res.data);
			    }else{
				    tools.info(res.msg)
			    }
		    }).fail(function(err){
			    tools.info(err);
		    })
	    },
        /**
         * @Description: 岗位代码变更
         * @author LongSX
         * @date 2020/3/11
         */
        handleChange: function(e) {
        	var gwdm = e.target.value;
        	if (!gwdm) return;
        	var self = this;
            ajax("POST","/glfw/fztsgwpl/gettzry",{shgwdm:gwdm}).done(function(res){
                if(res.code=="0"){
	                self.formData = res.data;
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
	    /**
	     * @Description: 批量调整人员的岗位
	     * @author LongSX
	     * @date 2020/3/12
	    */
	    adjust: function() {
		    var shgwdm = this.gwdm;
		    var user_before = this.user_before;
		    var user_after = this.user_after;
		    if (!shgwdm)  {
		    	tools.info("请先选择需要调整的岗位");
			    return;
		    }
		    if (!user_before)  {
		    	tools.info("请先选择调整前人员");
			    return;
		    }
		    if (!user_after)  {
		    	tools.info("请先选择调整后人员");
			    return;
		    }
		    ajax("POST","/glfw/fztsgwpl/pltz",{shgwdm,user_before,user_after}).done(function(res){
			    if(res.code=="0"){
				    tools.info("调整成功")
			    }else{
				    tools.info(res.msg)
			    }
		    }).fail(function(err){
			    tools.info(err);
		    })
	    }
    }
})