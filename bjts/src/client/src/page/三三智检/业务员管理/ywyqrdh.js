var ywyqrdh=require("./ywyqrdh.html");
avalon.component('ywyqrdh', {
	template:ywyqrdh,
	defaults: {
		params:{
			nsrsbh: ''
		},
		act:1,
		tcode: "ywyqrdhcx",
		swjgmc: "",
		selRows: [],
		searchData:{
			nsrsbh: '',
			bazt: '1',
			orderSql:"",
			pageSize:config.pageSize,
		},
    modelData: {
      flag: '1',
			thyy: ''
    },
		isShowErrorMsg: false,
		ids: [],
		imgSrc: '',
		onReady:function(){
			var self = this;
			try {
				this.searchData.swjg_dm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {
			}
			this.searchData.nsrsbh = this.params.nsrsbh
			this.createTable();
		},
		//copy bg
		createTable:function(){
			var self=this;
			var columns = [
				{ name: "op2", label:"操作", width: 0, frozen: true, align:"center", resizable: false, sortable: false,formatter: function(cellvalue, options, rowObject){
					var h = '<div style="display: flex; justify-content: center;">';
					h+= '<span class="btn confirm" title="确认">确认</span>'
					h += '</div>';
					return h
				}},
				{ name: "id", label: "主键id", index: "主键id",hidden:true, align:"left",sortable: true },
				{ name: "qyhgdm", label: "企业海关代码", index: "qyhgdm",width: 90, align:"center",sortable: true },
				{ name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width: 140, align:"left",sortable: true },
				{ name: "nsrmc", label: "企业名称", index: "nsrmc",width: 140, align:"left",sortable: true },
				{ name: "swjgMc", label: "税务机关名称", index: "swjgMc",width: 120, align:"left",sortable: true },
				{ name: "xm", label: "业务员姓名", index: "xm",width: 70, align:"left",sortable: true },
				{ name: "sex", label: "性别", index: "sex",width: 40, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '1': '男', '2': '女'};
					return map[cellvalue];
				} },
				{ name: "zjhm", label: "证件号码", index: "zjhm",width: 140, align:"left",sortable: true },
				{ name: "zjlx", label: "证件类型", index: "zjlx",width: 70, align:"center",sortable: false },
				{ name: "phone", label: "手机号码", index: "phone",width: 90, align:"left",sortable: true },
				{ name: "status", label: "业务员状态", index: "status",width: 70, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '1': '在职', '0': '离职'};
					return map[cellvalue];
				} },
				{ name: "gzrqQ", label: "工作日期起", index: "gzrqQ",width: 120, align:"center",sortable: true },
				{ name: "gzrqZ", label: "工作日期止", index: "gzrqZ",width: 120, align:"center",sortable: true },
				{ name: "ckcpfw", label: "出口产品范围", index: "ckcpfw",width: 80, align:"center",sortable: true },
				{ name: "sfqdldht", label: "是否签订劳动合同", index: "sfqdldht",width: 100, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				} },
				{ name: "sfdjsb", label: "是否代缴社保", index: "sfdjsb",width: 80, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				}},
				{ name: "ywyly", label: "业务员来源", index: "ywyly",width: 90, align:"left",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '1': '他人介绍', '2': '招聘', '3': '企业法人/投资方/实际管理人', '4': '其他'};
					return map[cellvalue] || '';
				}  },
				{ name: "sjqyhs", label: "涉及企业户数", index: "sjqyhs",width: 80, align:"right",sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<span class='link toSjqy'>"+(cellvalue || '')+"</span>";
				} },
				{ name: "sffxywy", label: "是否风险业务员", index: "sffxywy",width: 90, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				} },
				{ name: "zfbz", label: "作废标志", index: "zfbz",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '是', 'N': '否'};
					return map[cellvalue] || '';
				} },
				{ name: "bazt", label: "备案状态", index: "bazt",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					var map = { '0': '未备案', '1': '备案中', '2': '已备案', '3': '备案退回'};
					return map[cellvalue] || '';
				} },
				{ name: "zfsj", label: "作废时间", index: "zfsj",width: 120, align:"center",sortable: true },
				{ name: "tjsj", label: "提交时间", index: "tjsj",width: 120, align:"center",sortable: true },
				{ name: "zp", label: "证件照片", index: "zp",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
					return "<span class='link fj' title='查看'>查看</span>";
				} },
				{ name: "sfzjnr64", label: "base64图片内容", index: "sfzjnr64", hidden: true, formatter: function(cellvalue, options, rowObject){
					return cellvalue ? cellvalue : '';
				}},
				{ name: "op", label: "操作", width: 110, align: "center", resizable: false, search: false, sortable: false }
			];
			$("#ywyqrdh-table").jqGrid({
				datatype: "local",
				gridview: true,
				colModel: columns,
				viewrecords: true,
				rownumbers:true,
				pager: '#ywyqrdh-tablePager',
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
					return $(".ywyqrdh .form").height() -60;
				})(),
				beforeSelectRow:function(rowid,e){
					if($(e.target).hasClass('toSjqy')){
						var zjhm = getCellData("ywyba-table", rowid, 'zjhm')
						avalonRoot.addTab({title:"业务员涉及企业",component:"ywysjqy",params:{zjhm:zjhm}});
						return false;
					}else if($(e.target).hasClass('fj')){
						var id = getCellData("ywyqrdh-table", rowid, 'id')
						ajax("POST","/sszj/ywyba/getSfzj",{ywyId: id}).done(function(res){
							if(res.code=='0'){
								var imgSrc = res.data.sfzjnr64
								if (imgSrc) {
									self.imgSrc = 'data:image/png;base64,'+ imgSrc
								} else {
									self.imgSrc = ''
								}
								self.showModelImg();
							}else{
								tools.info(res.msg);
							}
						}).fail(function(err){
							tools.info(err);
						})
						return false;
					}else if($(e.target).hasClass('confirm')){
            var id = getCellData("ywyqrdh-table", rowid, 'id')
						self.ids = [id]
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
					var pageNo=tools.getPageNo(pgButton,"ywyqrdh-table");
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
			$("#ywyqrdh-table").jqGrid('setFrozenColumns');
			this.searchData.pageSize = $(".ui-pg-selbox", $('.ywyqrdh')).val();
			self.search(1);
		},
		showModel: function(){
			$('.model').show();
			$('.ywyqrdh .qr-page-model').show();
			this.modelData = {
				flag: '1',
				thyy: ''
			}
		},
		hideModel: function(){
			$('.model').hide();
			$('.ywyqrdh .qr-page-model').hide();
		},
		showModelImg: function(){
			$('.model').show();
			$('.ywyqrdh .img-page-model').show();
		},
		hideModelImg: function(){
			$('.model').hide();
			$('.ywyqrdh .img-page-model').hide();
		},
		search:function(pageNo){
			var self=this;
			this.searchData.pageSize = $(".ui-pg-selbox", $('.ywyqrdh')).val() || 20;
			var params=tools.clone(self.searchData);
			params.pageNo=pageNo;
      $("#ywyqrdh-table").jqGrid('clearGridData')
			ajax("POST","/sszj/ywyba/dhqrlist",params).done(function(res){
				if(res.code=='0'){
					$("#ywyqrdh-table").resetSelection();
					$("#ywyqrdh-table")[0].addJSONData(res.data);
          self.selRows = [];
					tools.HeiKj('ywyqrdh', 'ywyqrdh-table')
					$('.frozen-div #ywyqrdh-table_cb').css('width', '0');
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
    plqr: function(){
      if (this.selRows.length <=0) {
        tools.info('请先选择要确认的项！');
        return;
      }
      this.ids = []
      for (var i = 0; i < this.selRows.length;i++ ){
        let id = getCellData("ywyqrdh-table", this.selRows[i], 'id')
        this.ids.push(id);
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
				ywyids: this.ids,
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