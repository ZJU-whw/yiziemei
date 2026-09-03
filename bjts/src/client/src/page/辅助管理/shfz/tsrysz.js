var tsrysz = require("./tsrysz.html");
avalon.component("tsrysz",{
	template: tsrysz,
	defaults: {
		gwdm: "SH01",
		activeIndex: 0,
		leftArr: [],
		rightArr: [],
		formData: {
			swjgmc: "",//税务机关名称
			optional: [{ user_id: "", czry_mc: "" }],//某岗位全部人员列表
			choose: [{ user_id: "", czry_mc: "" }],//	可随机推送人员
			all: [{ shgwmc: "", user_id: "", czry_mc: "" }]//所有岗位和人员一览表
		},
		onReady: function() {
			this.gwdm = "SH01";
			this.setUnderline(0);
			this.search();
		},
		search: function() {
			var self = this;
			var params = { shgwdm: this.gwdm };
			ajax("POST", "/glfw/sjtsgwry/select", params).done(function(res) {
				if (res.code == "0") {
					self.formData = res.data;
				} else {
					tools.info(res.msg)
				}

			}).fail(function(err) {
				tools.info(err);
			})
		},
		addItem: function() {
			var self = this;
			if (this.leftArr.length == 0) {
				tools.info("请先选择需要操作的人员");
				return
			}
			var params = { user_ids: this.leftArr, shgwdm: this.gwdm };
			ajax("POST", "/glfw/sjtsgwry/add", params).done(function(res) {
				if (res.code == "0") {
					self.search();
					self.leftArr = [];
					self.rightArr = [];
				} else {
					tools.info(res.msg)
				}
			}).fail(function(err) {
				tools.info(err);
			})
		},
		delItem: function() {
			var self = this;
			if (this.rightArr.length == 0) {
				tools.info("请先选择需要操作的人员");
				return
			}
			var params = { user_ids: this.rightArr, shgwdm: this.gwdm };
			ajax("POST", "/glfw/sjtsgwry/delete", params).done(function(res) {
				if (res.code == "0") {
					self.search();
					self.leftArr = [];
					self.rightArr = [];
				} else {
					tools.info(res.msg)
				}
			}).fail(function(err) {
				tools.info(err);
			})
		},
		handleChange: function(e) {
			this.gwdm = e.target.value;
			this.search();
		},
		handleClick: function(index) {
			this.activeIndex = index;
			this.setUnderline(index)
		},
		//设置激活的tab底部横条的位置和宽度
		setUnderline: function(index) {
			var width = $(".tsrysz .tabs-item:eq(" + index + ")").outerWidth();
			var offsetX = this.calcOffset(index);
			$(".tsrysz .tabs-underline").width(width);
			$(".tsrysz .tabs-underline").css("left", offsetX + "px");
		},
		//计算第n个tab项的相对于父元素的横向偏移量
		calcOffset: function(index) {
			var parentOffset = $(".tsrysz .tabs-list").offset();
			var childOffset = $(".tsrysz .tabs-item:eq(" + index + ")").offset();
			return childOffset.left - parentOffset.left;
		},
	}
})