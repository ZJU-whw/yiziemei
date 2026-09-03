var tsjhxdwh = require("./tsjhxdwh.html");
avalon.component('tsjhxdwh', {
	template: tsjhxdwh,
	defaults: {
		params: {},
		act: 1,
		tcode: "srthscx",
		swjgmc: "",
		searchData: {
			swjgdm: '',
			jhny: '',
			pc: '',
			pageNo: 1,
			pageSize: 300,
		},
		companyList: [],
		jhnyList: [], // 计划年月列表
		pcList: [], // 批次列表
		timer: null,
		userSwjgDm: '',
		dataList: [],
		byjhye: 0, // 可分配指标余额
		showYe: false, // 是否显示可分配指标余额
		onReady: function () {
			var self = this;
			try {
				this.swjgmc = avalonRoot.user.swjgMc;
				this.userSwjgDm = avalonRoot.user.swjgDm
			} catch (e) {

			}
			$('.tsjhxdwh .datepicker.date-day').datepicker({
				dateFormat: 'yy-mm-dd'
			});
			$('.tsjhxdwh .datepicker.date-month').datepicker({
				dateFormat: 'yymm'
			});
			$('#tsjhxdwh-fileupload').fileupload({
				dataType: 'json',
				done: function (e, data) {
					if (data.result.code == "0") {
						tools.info("导入成功!");
						self.search(1,'btn')
					} else {
						tools.info(data.result.msg);
					}
				}
			});
			this.getCompanyList()
		},
		createBatchBtn () {
			let self = this
			ajax("POST", "/glfw/zbplan/edit/cj/check").done(function (res) {
				if (res.code == '0') {
					console.log(res)
					let str = res.data.jhny + '-' + res.data.pc
					self.createBatch(str)
				} else {
					tools.info(res.msg);
				}
			}).fail(function (err) {
				tools.info(err);
			})
		},
		getCompanyList () {
			let self = this
			ajax("POST", "/glfw/zbplan/ffjgSelect").done(function (res) {
				if (res.code == '0') {
					self.companyList = res.data
					console.log(res.data)
					self.searchData.swjgdm = self.companyList[0].code
					self.getJhny()
				} else {
					tools.info(res.msg);
				}
			}).fail(function (err) {
				tools.info(err);
			})
		},
		// 创建批次
		createBatch(str) {
			let self = this
			tools.confirm(`是否创建新的批次: ${str}？`, '确定',
				function () {
					let params = {
						pageNo: 1,
						pageSize: 300
					}
					ajax("POST", "/glfw/zbplan/edit/cj", params).done(function (res) {
						if (res.code == '0') {
							tools.info("操作成功")
							// self.search(1);
							self.dataList = res.data.rows;
							// self.searchData.swjgdm = ''
							self.getPcList().done(function(){
								self.searchData.jhny = res.data.jhny;
								self.searchData.pc = res.data.pc;
                                self.search(1);
							})
						} else {
							tools.info(res.msg);
						}
					}).fail(function (err) {
						tools.info(err);
					})
				}
			)
		},
		// 下达生效
		operateEffect() {
			if (this.dataList.length <= 0) {
				tools.info('列表为空，请先进行查询！')
				return false
			}
			const { jhny, pc } = this.searchData
			var params = {
				jhny,
				pc
			}
			let self = this
			tools.confirm("将当前批次全部指标计划一起生效？", '确定',
				function () {
					ajax("POST", "/glfw/zbplan/edit/xd", params).done(function (res) {
						if (res.code == '0') {
							tools.info("操作成功")
							self.search(1, 'btn');
						} else {
							tools.info(res.msg);
						}
					}).fail(function (err) {
						tools.info(err);
					})
				}
			)
		},
		// 下载模板
		download() {
			var self = this;
			var params = {
			}
			var form = $("<form>"); //定义一个form表单
			form.attr("style", "display:none");
			// form.attr("target", "hiddenframe");
			// form.attr("target", "_blank")
			form.attr("method", "post");
			form.attr("action", "/glfw/zbplan/exportTmpt");
			var input1 = $("<input>");
			input1.attr("type", "hidden");
			input1.attr("name", "data");
			input1.attr("value", JSON.stringify(params));
			$("body").append(form); //将表单放置在web中
			form.append(input1);
			form.submit();
			form.remove();
		},
		// 保存
		save() {
			let params = {
				saveList: this.dataList
			}
			let self = this
			ajax("POST", "/glfw/zbplan/edit/update", params).done(function (res) {
				if (res.code == '0') {
					tools.info("操作成功")
					self.search(self.page);
				} else {
					tools.info(res.msg);
				}
			}).fail(function (err) {
				tools.info(err);
			})
		},
		//copy bg
		search: function () {
			const { swjgdm, jhny, pc } = this.searchData
			if (jhny === '' || pc === '') {
				return tools.info('查询条件均不能为空!');
			}
			var self = this;
			var params = tools.clone(self.searchData);
			ajax("POST", "/glfw/zbplan/edit/cx", params).done(function (res) {
				if (res.code == '0') {
					self.dataList = []
					self.dataList = res.data.rows || [];
					self.showYe = res.data.showYe === 'Y' ? true : false
					self.byjhye = res.data.byjhye
				} else {
					tools.info(res.msg);
				}
			}).fail(function (err) {
				tools.info(err);
			})
		},
		filDate: function (e) {
			var date = e.target.value;
			var res = tools.MonCheup(date);
			if (res === false) {
				tools.info("日期输入错误");
				res = ""
			}
			e.target.value = res;

			return;
		},
		// 获取计划年月列表
		getJhny () {
			let self = this
			ajax("POST", "/glfw/zbplan/edit/cx/init/jhny",{swjgdm: this.searchData.swjgdm}).done(function (res) {
				if (res.code == '0') {
					self.jhnyList = res.data
					self.searchData.jhny = self.jhnyList[0]
					self.getPcList()
				} else {
					tools.info(res.msg);
				}
			}).fail(function (err) {
				tools.info(err);
			})
		},
		// 获取批次列表
		getPcList () {
			let params = {
				jhny: this.searchData.jhny,
				swjgdm: this.searchData.swjgdm
			}
			let self = this
			var deferred = $.Deferred();
			ajax("POST", "/glfw/zbplan/edit/cx/init/pc", params).done(function (res) {
				if (res.code == '0') {
					self.pcList = res.data
					self.searchData.pc = self.pcList[0]
					deferred.resolve();
				} else {
					tools.info(res.msg);
				}
			}).fail(function (err) {
				tools.info(err);
			})
			return deferred.promise();
		},
		jhnyChange () {
			this.getPcList()
		},
		swjgdmChange () {
			this.getJhny()
		}
	}
});