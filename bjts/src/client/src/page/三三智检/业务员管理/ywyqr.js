var ywyqr=require("./ywyqr.html");
avalon.component('ywyqr', {
	template:ywyqr,
	defaults: {
		params:{},
		act:1,
		tcode: "ywyqrcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			qyhgdm:"",
			nsrsbh:"",
			nsrmc:"",
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
      flag: '1',
			thyy: ''
    },
		isShowErrorMsg: false,
		qyhgs: [],
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjg_dm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
			this.createTable();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",hidden: true},
				{ name: "nsrsbhLink", label: "纳税人识别号", index: "nsrsbhLink",width: 150, align:"center",sortable: false,formatter: function(cellvalue, options, rowObject){
					return "<span class='link toYwyqrdh'>"+rowObject.nsrsbh+"</span>";
				}},
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 160, align:"left",sortable: true },
				{ name: "ywysl", label: "业务员数量", index: "ywysl",width: 70, align:"right",sortable: true },
				{ name: "tjsj", label: "提交时间", index: "tjsj",width: 140, align:"left",sortable: true },
				{ name: "op", label: "操作", index: "op",width: 60, formatter: function(cellvalue, options, rowObject){
					return "<div class='btn confirm' style='float: none;display: inline-block;' title='确认'>确认</div>";
				} },
			];
			$("#ywyqr-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#ywyqr-tablePager',
        shrinkToFit: false,
        autowidth:true,
				altRows: true,
				multiselect: true,
				multiselectWidth:"40",
				altclass: "altclasscss",
				lastsort: 1,
				rowNum: config.pageSize,
        width:"100%",
				height:(function(){
					return $(".ywyqr .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if($(e.target).hasClass('toYwyqrdh')){
            var nsrsbh = getCellData("ywyqr-table", rowid, 'nsrsbh')
						avalonRoot.addTab({title:"业务员单户确认",component:"ywyqrdh",params:{nsrsbh:nsrsbh}});
						return false;
					}else if($(e.target).hasClass('confirm')){
            var qyhgdm = getCellData("ywyqr-table", rowid, 'qyhgdm')
						self.qyhgs = [qyhgdm]
						self.showModel();
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
					var pageNo=tools.getPageNo(pgButton,"ywyqr-table");
					self.search(pageNo);
				},
        onSelectRow: function (rowid, status) {
          var index = self.selRows.indexOf(rowid);
          if (status) {
            self.selRows.push(rowid)
          } else {
            self.selRows.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          if (status) {
            self.selRows = JSON.parse(JSON.stringify(rowids));
          } else {
            self.selRows = [];
          }
        }
			});
			// this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
			// self.search(1);
		},
		showModel: function(){
			$('.model').show();
			$('.ywyqr .page-model').show();
			this.modelData = {
				flag: '1',
				thyy: ''
			}
		},
		hideModel: function(){
			$('.model').hide();
			$('.ywyqr .page-model').hide();
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.ywyqr')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
      $("#ywyqr-table").jqGrid('clearGridData')
			ajax("POST","/sszj/ywyba/qrlist",params).done(function(res){
				if(res.code=='0'){
					$("#ywyqr-table").resetSelection();
					$("#ywyqr-table")[0].addJSONData(res.data);
          self.selRows = []
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
		reset: function() {
			this.searchData = {
				qyhgdm:"",
				nsrsbh:"",
				nsrmc:"",
				orderSql:"",
				pageSize:config.pageSize,
			};
			this.swjgmc= avalonRoot.user.swjgMc;
		},
    plqr: function(){
      if (this.selRows.length <=0) {
        tools.info('请先选择要确认的项！');
        return;
      }
      this.qyhgs = []
      for (var i = 0; i < this.selRows.length;i++ ){
        let qyhgdm = getCellData("ywyqr-table", this.selRows[i], 'qyhgdm')
        this.qyhgs.push(qyhgdm);
      }
      this.showModel();
    },
    confirmModel: function(){
			var self = this
			if (this.modelData.flag == '0' && this.modelData.thyy == '') {
				this.isShowErrorMsg = true
				return;
			} else {
				this.isShowErrorMsg = false
			}
			var params = {
				flag: this.modelData.flag,
				qyhgs: this.qyhgs,
				thyy: this.modelData.thyy
			}
			ajax("POST","/sszj/ywyba/shqr",params).done(function(res){
				if(res.code=='0'){
					tools.info('确认成功！');
					self.search(1)
					self.hideModel()
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    }
	}
});