var jdrcx=require("./jdrcx.html");
function getPageDataFromJson(res){
    var data = res.data;   //数据
    var total=1; 		//数据总数
    var offset=1;  		//偏移量
    var size=20;  		//页面大小
    var cellData; 		//申报业务数组
    var pageData = new Object();
    for(var key in data){
        if(key=="total"){
            total = data[key];
        }else if(key=="offset"){
            offset = data[key]-0;
        }else if(key=="size"){
            size = data[key]-0;
        }else{
            if((typeof data[key]) === "object"){
                cellData = data[key];
            }
        }
    }

    var totalPage = parseInt((total+size-1)/size); //总页数
    var currentPage = parseInt((offset+size-1)/size); //当前页数

    pageData["records"] = total+""
    pageData["page"] = currentPage;
    pageData["total"] = totalPage;
    pageData["rows"] = cellData;
    return pageData;

}
avalon.component('jdrcx', {
	template:jdrcx,
	defaults: {
		params:{},
		act:1,
		searchData:{
			czryDm:"",
			zsjgDm:"",
			flgl:[],
			flglMc:"",
			jsMode:[],
			jsModeMc:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
		onReady:function(){
			var self = this;
			this.createTable();
		},
		changeTab:function(num){
			this.act=num;
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "ID", key: true, hidden: true, index: "id" },
				{ name: "czryDm", index: "czryDm", label: "操作人员代码", align: "left", width: 105, sortable: true },
				{ name: "czryMc", index: "czryMc", label: "操作人员名称", align: "left", width: 105, sortable: true },
				{ name: "qybz", index: "qybz", label: "启用标志", align: "center", width: 200, hidden: true, sortable: true },
				{ name: "qybzMc", index: "qybzMc", label: "启用标志", align: "center", width: 70, sortable: true },
				{ name: "zsjgDm", index: "zsjgDm", label: "征收机关代码", hidden: true, align: "center", width: 135, sortable: true },
				{ name: "swjgDm", index: "swjgDm", label: "退税机关范围", align: "left", width: 200, sortable: true },
				{ name: "zsjgMc", index: "zsjgMc", label: "征收机关分组", align: "left", width: 275, sortable: true },
				{ name: "flgl", index: "flgl", label: "分类管理等级", align: "left", width: 105, hidden: true, sortable: true },
				{ name: "flglMc", index: "flglMc", label: "分类管理等级", align: "left", width: 160, sortable: true },
				{ name: "jsMode", index: "jsMode", label: "退税计算方式", align: "left", width: 160, hidden: true, sortable: true },
				{ name: "jsModeMc", index: "jsModeMc", label: "退税计算方式", align: "left", width: 160, sortable: true },
				{ name: "limitSc", index: "limitSc", label: "生产接单上限", align: "left", width: 90, sortable: true },
				{ name: "limitWm", index: "limitWm", label: "外贸接单上限", align: "left", width: 90, sortable: true },
				{ name: "limitQt", index: "limitQt", label: "其他接单上限", align: "left", width: 90, sortable: true },
				{ name: "cntSc", index: "cntSc", label: "生产接单数", align: "left", width: 80, sortable: true },
				{ name: "cntWm", index: "cntWm", label: "外贸接单数", align: "left", width: 80, sortable: true },
				{ name: "cntQt", index: "cntQt", label: "其他接单数", align: "left", width: 80, sortable: true }
			];
			$("#jdrcx-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#jdrcx-tablePager',
				shrinkToFit: false,
				autowidth:true,
				altRows: true,
				// multiselect: true,
				// multiselectWidth:"30",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
				width:"100%",
				height:(function(){
					return $(".jdrcx .form").height() -60;
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
					var pageNo=tools.getPageNo(pgButton,"jdrcx-table");
					self.search(pageNo);
				}
			});
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = 20;
			var params=tools.clone(self.searchData);
			params.flgl=params.flgl.join('.')+"."
			params.jsMode=params.jsMode.join('.')+"."
			params.pageNo=pageNo;
            $("#jdrcx-table").jqGrid('clearGridData')
			ajax("POST","/glfw/fpgl/view",params).done(function(res){
				if(res.code=='0'){
					$("#jdrcx-table").resetSelection();
                    var data=getPageDataFromJson(res)
					$("#jdrcx-table")[0].addJSONData(data);
					self.form=res.data;
					self.closeHyper();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		showHyper:function(){
			$('.jdrcx .select-sub').toggle();
			$('.jdrcx .select-wrapper .icon').toggleClass("active");
			if ($('.jdrcx .select-wrapper .icon').attr("title").slice(0,2) === "展开") {
				$('.jdrcx .select-wrapper .icon').attr("title","收起查询条件");
			} else {
				$('.jdrcx .select-wrapper .icon').attr("title","展开查询条件")
			}
		},closeHyper:function(){
            $('.jdrcx .select-sub').hide();
            $('.jdrcx .select-wrapper .icon').removeClass('active');
            $('.jdrcx .select-wrapper .icon').attr("title","展开查询条件")
        },
		exform:function(){
			var self=this;
            if($('#jdrcx-table').jqGrid('getRowData').length<=0){
                tools.info("请先查询列表");
                return ;
            }
			var params = tools.clone(self.searchData)
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			form.attr("target", "hiddenframe");
			form.attr("method", "post");
			form.attr("action", "/glfw/export/jdrcxqd");
			var input1 = $("<input>");
			input1.attr("type", "hidden");
			input1.attr("name", "data");
			input1.attr("value", JSON.stringify(params));
			$("body").append(form); //将表单放置在web中
			form.append(input1);
			form.submit();
			form.remove();
		},
		showSelect: function (e) {
			var self=this;
			$(".select-container",$(e.target).parent()).show();
			$('.jdrcx .page').on('click',function(e){
				var e=e||window.event;
				if($('.select-container').find($(e.target)).length<=0){
					$(".select-container").hide();
					$('.jdrcx .page').off('click');
				}
			})
		},
		selectChange: function(type) {
			var map = {"A": "一类","B":"二类","C":"三类","D":"四类"};
			var map2 = {"1":"生产","2":"外贸"};
			//分类管理
			if (type == 1) {
				if (this.searchData.flgl && this.searchData.flgl.length == 0) {
					this.searchData.flglMc = "";
				} else {
					var str = "";
					for (var i = 0; i < this.searchData.flgl.length; i++) {
						str += ","+map[this.searchData.flgl[i]];
					}
					this.searchData.flglMc = str.slice(1);
				}
				console.log(this.searchData)
			}
			//退税计算方式
			else {
				if (this.searchData.jsMode && this.searchData.jsMode.length == 0) {
					this.searchData.jsModeMc = "";
				} else {
					var str = "";
					for (var i = 0; i < this.searchData.jsMode.length; i++) {
						str += ","+map2[this.searchData.jsMode[i]];
					}
					this.searchData.jsModeMc = str.slice(1);
				}
			}
		},
	}
});