var flgldttx = require("./flgldttx.html");
avalon.component("flgldttx",{
    template:flgldttx,
    defaults: {
        act:1,
        swjgmc:"",
        swjgData:"",
        searchData:{
            swjg_dm:"",
            ssny:"",
            orderSql:"",
            pageSize:config.pageSize,
        },
        onReady:function(){
            var self = this;
            try {
                this.searchData.swjg_dm=avalonRoot.user.swjgDm;
                this.swjgmc=avalonRoot.user.swjgMc;
            } catch (e) {

            }
            this.initTree();
            this.createTable();
            this.searchData.ssny = this.getCurrentMonth();
            $('.flgldttx .datepicker.date-month').datepicker({
                dateFormat: 'yymm'
            });
        },
        getCurrentMonth: function () {
            var date = new Date();
            var year = date.getFullYear();
            var month = date.getMonth() + 1;
            if ((month+"").length === 1) {
                month = "0" + month;
            }
            return year + "" + month;
        },
        filDate:function(e){
            var date=e.target.value;
            var res = date;
	        if (!/^\d{6}$/.test(date)) {
		        tools.info("所属年月输入错误");
		        res = "";
	        }
            e.target.value=res;
            return ;
        },
        createTable:function(){
            var self=this;
            var columns = [
                { name: "id", label: "主键id", index: "id", align:"center",hidden:true,sortable: true },
                { name: "qyhgdm", label: "海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
                { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"center",sortable: true },
                { name: "nsrmc", label: "企业名称", index: "nsrmc",width: 140, align:"left",sortable: true },
                { name: "swjgmc", label: "税务机关", index: "swjgmc",width: 100, align:"left",sortable: true },
                { name: "ssny", label: "所属年月", index: "ssny",width: 80, align:"center",sortable: true },
                { name: "nsxydj_sy", label: "上月", index: "nsxydj_sy",width: 80, align:"center",sortable: true },
                { name: "nsxydj_by", label: "本月", index: "nsxydj_by",width: 80, align:"center",sortable: true },
                { name: "hgflgl_sy", label: "上月", index: "hgflgl_sy",width: 80, align:"center",sortable: true },
                { name: "hgflgl_by", label: "本月", index: "hgflgl_by",width: 80, align:"center",sortable: true },
                { name: "wgflgl_sy", label: "上月", index: "wgflgl_sy",width: 80, align:"center",sortable: true },
                { name: "wgflgl_by", label: "本月", index: "wgflgl_by",width: 80, align:"center",sortable: true },
                { name: "sxqy_sy", label: "上月", index: "sxqy_sy",width: 80, align:"center",sortable: true,formatter: function(val) {
		                if (val == "0") {
		                	return "否"
		                } else {
		                	return "是"
		                }
	                }},
                { name: "sxqy_by", label: "本月", index: "sxqy_by",width: 80, align:"center",sortable: true,formatter: function(val) {
		                if (val == "0") {
			                return "否"
		                } else {
			                return "是"
		                }
	                } },
                { name: "jcaj_wh", label: "稽查案件", index: "jcaj_wh",width: 80, align:"center",sortable: true },
                { name: "slqyfr_new", label: "四类出口企业法定代表人新成立的出口企业", index: "slqyfr_new",width: 140, align:"left",sortable: true },
                { name: "flglcd", label: "分类管理类别", index: "flglcd",width: 80, align:"center",sortable: true },
            ];
            $("#flgldttx-table").jqGrid({
                datatype: "local",
                gridview: true,
                colModel: columns,
                viewrecords: true,
                rownumbers:true,
                pager: '#flgldttx-tablePager',
                shrinkToFit: false,
                autowidth:true,
                altRows: true,
                width:"100%",
                // multiselect: true,
                // multiselectWidth:"30",
                altclass: "altclasscss",
                lastsort: 1,
                rowNum: config.pageSize,
                height:(function(){
                    return $(".flgldttx .form").height() -160;
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
                    var pageNo=tools.getPageNo(pgButton,"flgldttx-table");
                    self.search(pageNo);
                }
            });
            $("#flgldttx-table").jqGrid('setGroupHeaders', {
                useColSpanStyle: true,
                groupHeaders:[
                    {startColumnName:'nsxydj_sy', numberOfColumns:2, titleText: '纳税信用级别'},
                    {startColumnName:'hgflgl_sy', numberOfColumns:2, titleText: '海关企业信用管理类别'},
                    {startColumnName:'wgflgl_sy', numberOfColumns:2, titleText: '外汇管理的分类管理等级'},
                    {startColumnName:'sxqy_sy', numberOfColumns:2, titleText: '被列为国家联合惩戒对象的失信企业'},
                ]
            })
            $(".flgldttx th.ui-th-column div").css({"white-space":"normal","height":"auto",})
        },
        search:function(pageNo){
            var self=this;
            this.searchData.pageSize = $(".ui-pg-selbox", $('.flgldttx')).val() || 20;
            var params=tools.clone(self.searchData);
            params.pageNo=pageNo
            $("#flgldttx-table").jqGrid('clearGridData')
            ajax("POST","/glfw/flglpdzb/dttxcx/select",params).done(function(res){
                if(res.code=='0'){
                    $("#flgldttx-table")[0].addJSONData(res.data);
                }else{
                    tools.info(res.msg);
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        initTree:function() {
            var self = this;
            var setting = {
                callback:{
                    onClick:function(e,id,node){
                        self.searchData.swjg_dm = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    },
                    onDblClick:function(e,id,node){
                        self.searchData.swjg_dm = node.id;
                        self.swjgmc = node.text;
                        self.hideTree();
                        return;
                    }
                },
                data:{key:{children:"item",name:"text"}}
            };
            tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
                $.fn.zTree.init($(".flgldttx .treeDiv"), setting,data);
            }).fail(function (err) {
                tools.info(err);
            });
        },
        showTree:function(e){
            var self=this;
            $(".treeDiv",$(e.target).parent()).show();
            $('.flgldttx').on('click',function(e){
                var e=e||window.event;
                if($('.treeDiv').find($(e.target)).length<=0){
                    self.hideTree();
                }

            })
        },
        hideTree:function(){
            $(".treeDiv").hide();
            $('.flgldttx').off('click');
        },
        exform:function(){
            var self=this;
            if($('#flgldttx-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
            var params = tools.clone(self.searchData)
            var form = $("<form>"); //定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "hiddenframe");
            form.attr("method", "post");
            form.attr("action", "/glfw/export/flglpdzb/dttxcx");
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "data");
            input1.attr("value", JSON.stringify(params));
            $("body").append(form); //将表单放置在web中
            form.append(input1);
            form.submit();
            form.remove();
        },
    }
})