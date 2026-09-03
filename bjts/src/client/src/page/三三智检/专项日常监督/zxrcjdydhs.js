var zxrcjdydhs = require("./zxrcjdydhs.html");
avalon.component("zxrcjdydhs", {
  template: zxrcjdydhs,
  defaults: {
    params: {},
    act: 1,
    activeIndex: "0",
    // tcode: "scqysbxxcx",
    tcode: "fxglFxsp",
    tsjgmc: "",
    syjgfw: "",
    url: "",
    tableRowList: [],
    swjgList: [
      "13300000000",
      "13301000000",
      "13302000000",
      "13303000000",
      "13304000000",
      "13305000000",
      "13306000000",
      "13307000000",
      "13308000000",
      "13309000000",
      "13310000000",
      "13311000000",
    ], // 省市级税务机关代码列表
    hasHsPermission: false, // 是否有核实处理权限
    searchData: {
      swjgDm: "",
      nsrsbh: "",
      nsrmc: "",
      zbid: "",
      hsjglx: "0",
      smrqQ:'',
      smrqZ:'',
      smlx:'',
      orderSql: "",
      pageSize: config.pageSize,
    },
    modelData: {
      id: "",
      swjgDm: "",
      nsrsbh: "",
      nsrmc: "",
      smlx: "",
      smlxZn: "",
      smrq: "",
      zbid: "",
      zbidZn: "",
      zbcs: "",
      hsjglx: "",
      hsrq: "",
      hsry: "",
      hsclqk: "",
      smjg:'',
    },
    syjgfw: "",
    addTitle: "",
    timer: null,
    tableArr: [],
    tableOption: [],
    tableData: {
      sumData: {},
    },
    setData: {
      zczt: "",
      ktpt: "",
    },
    groupList: [],
    zbidList: [],
    onReady: function () {
      var self = this;
      try {
        this.hasHsPermission =
          this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
        this.tsjgmc = avalonRoot.user.swjgMc;
        this.searchData.swjgDm = avalonRoot.user.swjgDm;
        this.syjgfw = avalonRoot.user.swjgMc;
      } catch (e) {}
      // this.getTableRow();
      if(self.params.swjgDm){
        // var startDate = self.params.startDate
        // var endDate = self.params.endDate
        // self.searchData.smrqQ = startDate.slice(0, 4)+'-'+startDate.slice(-2)+'-01'
        // self.searchData.smrqZ = endDate.slice(0, 4)+'-'+endDate.slice(-2)+'-'+self.getLastDayOfMonth(endDate.slice(0, 4),endDate.slice(-2))
        self.searchData.smrqQ = self.params.startDate
        self.searchData.smrqZ = self.params.endDate
        self.searchData.zbid = self.params.zbid
        if(self.hasHsPermission){
          self.searchData.nsrsbh = self.params.swjgDm
          self.searchData.nsrmc = self.params.swjgMc
        }else{
          self.tsjgmc = self.params.swjgMc
          self.searchData.swjgDm = self.params.swjgDm
        }
      }
      self.initTree();
      self.initDate();
      self.createTableWhs();
      self.search(1);
      this.getZxzblist();
    },
     getLastDayOfMonth:function(year, month) {
      // 注意：JavaScript中的月份是从0开始的（0代表1月，11代表12月）
      // 因此，我们需要将传入的月份减1来匹配JavaScript的Date对象
      let date = new Date(year, month, 1); // 这里的1实际上是下一个月的第一天
      // 然后减去一天，得到上一个月的最后一天
      date.setDate(date.getDate() - 1);
   
      // 我们可以使用getDate()方法来获取这个日期的“日”部分，这就是最后一天
      let lastDay = date.getDate();
   
      return lastDay;
  },
    initDate: function(){
			var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
			$('.zxrcjdydhs .datepicker.date-day').datetimepicker(options);
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
    changeTab: function (index) {
      this.activeIndex = index;
      self.pageNo = 1;
      if (this.activeIndex == "1") {
        this.createTableYhs();
        this.searchData.hsjglx = "1";
      } else {
        this.searchData.hsjglx = "0";
      }
      this.search(1);
    },
    createTableWhs: function () {
      var self = this
      var btnName = this.hasHsPermission ? "核实" : "查看";
      var wwcColumns = [
        { name: "tsswjgDm", label: "所属税务机关", index: "tsswjgDm",width:105 },
        { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh",width:160 },
        { name: "nsrmc", label: "纳税人名称", index: "nsrmc",width:180 },
        { name: "smlx", label: "扫描类型", index: "smlx",hidden:true },
        { name: "smlxZn", label: "扫描类型",align: "center",width:80, index: "smlxZn",formatter: function (cellvalue, options, rowObject) {
          var yxbzMap = { '0': "自动扫描", '1': "手动扫描" };
          return yxbzMap[rowObject.smlx];
        }, },
        {
          name: "smrq",
          label: "扫描日期",
          index: "smrq",
          width: 100,
          align: "left",
        },
        {
          name: "zbid",
          label: "专项监管指标名称",
          index: "zbid",
          width: 250,
          // hidden:true,
          align: "left",
        },
        // {
        //   name: "zbidZn",
        //   label: "专项监管指标名称",
        //   index: "zbidZn",
        //   width: 250,
        //   align: "left",
        //   formatter: function (cellvalue, options, rowObject) {
        //     var Map = self.zbidList
        //     var item = Map.find(item => item.key == rowObject.zbid)
        //     return item.value;
        //   },
        // },
        {
          name: "zbcs",
          label: "指标参数集合",
          index: "zbcs",
          width: 500,
          align: "left",
          hidden:true,
        },
        {
          name: "smjg",
          label: "扫描结果",
          index: "smjg",
          align: "left",
          width:600
        },
        {
          name: "hsclqk",
          label: "核实处理情况",
          index: "hsclqk",
          width: 140,
          align: "left",
          hidden:true
        },
        {
          name: "hsrq",
          label: "核实日期",
          index: "hsrq",
          width: 140,
          align: "left",
          hidden:true,
        },
        {
          name: "hsry",
          label: "核实人员",
          index: "hsry",
          width: 140,
          align: "left",
          hidden:true,
        },
        {
          name: "op",
          label: "操作",
          index: "op",
          width: 100,
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            var op =
              "<div style='text-align:center;'><div style='text-align:center;'><div class='btn op-hscl' style='float: none;display: inline-block;' title='" +
              btnName +
              "'>" +
              btnName +
              "</div>";
            op += "</div>";
            return op;
          },
        },
      ];
      this.createTable(wwcColumns, "zxrcjdydhs-whs-table",btnName);
    },
    createTableYhs: function () {
      var self = this
      var btnName = "查看";
      var ywcColumns = [
        // {
        //   name: "op2",
        //   label: "操作",
        //   index: "op",
        //   width: 0,
        //   frozen: true,
        //   align: "center",
        //   sortable: false,
        //   formatter: function (cellvalue, options, rowObject) {
        //     var op =
        //       "<div style='text-align:center;'><div style='text-align:center;'><div class='btn op-hscl' style='float: none;display: inline-block;' title='" +
        //       btnName +
        //       "'>" +
        //       btnName +
        //       "</div>";
        //     op += "</div>";
        //     return op;
        //   },
        // },
        { name: "tsswjgDm", label: "所属税务机关", index: "tsswjgDm" },
        { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh" },
        { name: "nsrmc", label: "纳税人名称", index: "nsrmc" },
        { name: "smlx", label: "扫描类型", index: "smlx",hidden:true },
        { name: "smlxZn", label: "扫描类型",align: "center", index: "smlxZn",formatter: function (cellvalue, options, rowObject) {
          var yxbzMap = { '0': "自动扫描", '1': "手动扫描" };
          return yxbzMap[rowObject.smlx];
        }, },
        {
          name: "smrq",
          label: "扫描日期",
          index: "smrq",
          width: 140,
          align: "left",
        },
        {
          name: "zbid",
          label: "专项监管指标名称",
          index: "zbid",
          width: 250,
          // hidden:true,
          align: "left",
        },
        // {
        //   name: "zbidZn",
        //   label: "专项监管指标名称",
        //   index: "zbidZn",
        //   width: 250,
        //   align: "left",
        //   formatter: function (cellvalue, options, rowObject) {
        //     var Map = self.zbidList
        //     var item = Map.find(item => item.key == rowObject.zbid)
        //     return item.value;
        //   },
        // },
        {
          name: "zbcs",
          label: "指标参数集合",
          index: "zbcs",
          width: 140,
          align: "left",
          hidden:true,
        },
        {
          name: "smjg",
          label: "扫描结果",
          index: "smjg",
          width: 120,
          align: "left",
        },
        {
          name: "hsjglx",
          label: "核实结果类型",
          index: "hsjglx",
          width: 140,
          align: "left",
          hidden:true
        },
        {
          name: "hsjglxZn",
          label: "核实结果类型",
          index: "hsjglxZn",
          width: 140,
          align: "center",
          formatter: function (cellvalue, options, rowObject) {
            var yxbzMap = { '0': "未核实", '1': "已核实" };
            return yxbzMap[rowObject.hsjglx];
          },
        },
        {
          name: "hsrq",
          label: "核实日期",
          index: "hsrq",
          width: 140,
          align: "left",
        },
        {
          name: "hsry",
          label: "核实人员",
          index: "hsry",
          width: 140,
          align: "left",
        },
        {
          name: "hsclqk",
          label: "核实处理情况",
          index: "hsclqk",
          width: 140,
          align: "left",
        },
        {
          name: "op",
          label: "操作",
          index: "op",
          width: 100,
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            var op =
              "<div style='text-align:center;'><div style='text-align:center;'><div class='btn op-hscl' style='float: none;display: inline-block;' title='" +
              btnName +
              "'>" +
              btnName +
              "</div>";
            op += "</div>";
            return op;
          },
        },
      ];
      this.createTable(ywcColumns, "zxrcjdydhs-yhs-table",btnName);
      // $("#zxrcjdydhs-yhs-table").jqGrid("setFrozenColumns");
      // tools.HeiKjNoSel("zxrcjdydhs", "zxrcjdydhs-yhs-table");
    },
    createTable: function (columns, id,btnName) {
      var self = this;
      $("#" + id).jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: "#" + id + "Pager",
        shrinkToFit: false,
        autowidth: true,
        altRows: true,
        // shrinkToFit:false,
        // multiselect: true,
        // multiselectWidth:"30",
        altclass: "altclasscss",
        // lastsort: 1,
        rowNum: config.pageSize,
        width: "100%",
        height: (function () {
          return $(".zxrcjdydhs .form").height() - 125;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#"+id).jqGrid("getRowData", rowid);
          var uuid = getCellData(id, rowid, "uuid");
          var nkzbbh = getCellData(id, rowid, "nkzbbh");
          if ($(e.target).hasClass("disabled")) return false;
          if ($(e.target).hasClass("op-hscl")) {
            for (var key in self.modelData) {
              self.modelData[key] = row[key];
            }
            self.modelData.id = rowid;
            if(btnName == '核实'){
              self.modelData.hsry = avalonRoot.user.czrymc
              self.modelData.hsrq = tools.getToday()
            }
            self.modelData.swjgDm = avalonRoot.user.swjgDm
            self.showModel(btnName);
            return false;
          } else if (e.target.nodeName == "TD") {
            $(e.target)
              .parent()
              .addClass("ui-state-highlight")
              .siblings()
              .removeClass("ui-state-highlight");
            return false;
          } else {
            return true;
          }
        },
        onSortCol: function (index, iCol, sortorder) {
          var orderSql = index + " " + sortorder;
          self.searchData.orderSql = orderSql;
          self.search(1);
          self.pageNo = 1;
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, id);
          self.pageNo = pageNo;
          self.search(pageNo);
        },
      });
    },
    normalSearch() {
      this.searchData.orderSql = "";
      $(".s-ico").hide();
      this.search(1);
    },
    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize =
        $(".ui-pg-selbox", $(".zxrcjdydhs")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      params.fwlx = self.searchData.fwlx;
      
      let url;
      if (self.activeIndex == "0") {
        url = "/sszj/zxjg/zxjgClMx";
      } else if (self.activeIndex == "1") {
        url = "/sszj/zxjg/zxjgClMx";
      }
      self.url = url;
      var id =
        this.activeIndex == "0"
          ? "#zxrcjdydhs-whs-table"
          : "#zxrcjdydhs-yhs-table";
      $(id).jqGrid("clearGridData");
      ajax("POST", url, params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data;
            $(id).resetSelection();
            $(id)[0].addJSONData(res.data);
            self.closeHyper();
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showHyper: function () {
      $(".zxrcjdydhs .select-sub").toggle();
      $(".zxrcjdydhs .select-wrapper .icon").toggleClass("active");
      if (
        $(".zxrcjdydhs .select-wrapper .icon").attr("title").slice(0, 2) ===
        "展开"
      ) {
        $(".zxrcjdydhs .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".zxrcjdydhs .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".zxrcjdydhs .select-sub").hide();
      $(".zxrcjdydhs .select-wrapper .icon").removeClass("active");
      $(".zxrcjdydhs .select-wrapper .icon").attr("title", "展开查询条件");
    },
    filDate: function (e) {
      var date = e.target.value;
      var res = tools.DateCheup(date);
      if (res === false) {
        tools.info("日期输入错误");
        res = "";
      }
      e.target.value = res;
      return;
    },
    filMonth: function (e) {
      var date = e.target.value;
      var res = tools.MonCheup(date);
      if (res === false) {
        tools.info("所属期输入错误");
        res = "";
      }
      e.target.value = res;
      return;
    },
    showMenu: function (e) {
      var self = this;
      $(".dropdown-menu", e.target).show();
      $(".zxrcjdydhs").on("click", function (e) {
        var e = e || window.event;
        if ($(".dropdown-menu").find($(e.target)).length <= 0) {
          self.hideMenu();
        }
      });
    },
    hideMenu: function () {
      $(".dropdown-menu").hide();
      $(".zxrcjdydhs").off("click");
    },
    //copy
    initTree: function () {
      var self = this;
      var setting = {
        callback: {
          onClick: function (e, id, node) {
            self.searchData.swjgDm = node.id;
            self.tsjgmc = node.text;
            self.hideTree();
            return;
          },
          onDblClick: function (e, id, node) {
            self.searchData.swjgDm = node.id;
            self.tsjgmc = node.text;
            self.hideTree();
            return;
          },
        },
        data: { key: { children: "item", name: "text" } },
      };
      tools
        .getCachedSwjg(avalonRoot, ajax)
        .done(function (data) {
          $.fn.zTree.init($(".zxrcjdydhs .treeDiv"), setting, data);
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".zxrcjdydhs").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".zxrcjdydhs").off("click");
    },
    exform: function () {
      var self = this;
      if ($("#zxrcjdydhs-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData);
      var url = self.url + "/export";
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/sszj/export/zxjgClMx");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form); //将表单放置在web中
      form.append(input1);
      form.submit();
      form.remove();
    },
    reset: function () {
      this.searchData = {
        swjgDm: "",
        nsrsbh: "",
        nsrmc: "",
        zbid: "",
        hsjglx: "0",
        orderSql: "",
        pageSize: config.pageSize,
      };
      this.tsjgmc = avalonRoot.user.swjgMc;
      this.activeIndex = "0"
    },
    showModel: function (title) {
      this.addTitle = title;
      // if (title == "新增") {
      //   this.modelData = {
      //     id: "",
      //     tsswjg_dm: "",
      //     nsrsbh: "",
      //     nsrmc: "",
      //     smlx: "",
      //     smrq: "",
      //     zbid: "",
      //     zbcs: "",
      //     hsjglx: "",
      //     hsrq: tools.getToday(),
      //     hsry: avalonRoot.user.czrymc,
      //     hsclqk: "",
      //   };
      // }
      $(".model").show();
      $(".zxrcjdydhs .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".zxrcjdydhs .add-page-model").hide();
    },
    saveModel: function () {
      var self = this;
      var params = {
        id:this.modelData.id,
        hsjglx:this.modelData.hsjglx?this.modelData.hsjglx:'',
        hsrq:this.modelData.hsrq,
        hsry:this.modelData.hsry,
        hsclqk:this.modelData.hsclqk,
      }
      var valid = this.checkValid(params);
      if (!valid) return;
      api.updateZxjg(params).done(function (res) {
        if (res.code == "0") {
          tools.info("保存成功！");
          self.hideModel();
          self.search(1);
        }
      });
    },
    // 校验必填项
    checkValid: function (modelData) {
      var rules = [
        { name: "hsjglx", message: "请选择核实结果类型！" },
        { name: "hsry", message: "核实人员不能为空！" },
        { name: "hsrq", message: "核实日期不能为空！" },
      ];
      for (var i = 0; i < rules.length; i++) {
        if (modelData[rules[i].name] == "") {
          tools.info(rules[i].message);
          return false;
        }
      }
      return true;
    },
    getZxzblist(){
      api.getZxzblist().then( (res) => {
        if (res.code == "0") {
          this.zbidList = res.data
        }
      });
    }
  },
});
