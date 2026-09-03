var fjlb = require("./fjlb.html");
avalon.component("fjlb", {
  template: fjlb,
  defaults: {
    params: {},
    act: 1,
    // tcode: "scqysbxxcx",
    tcode: "fxglFxyd",
    tsjgmc: "",
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
      qybs: "",
      czflag: "",
      fjlx: "",
      note: "",
      title: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    modelData: {
      id: "",
      nsrsbh: "",
      isRead: "",
      lockFlag: "",
      note2: "",
    },
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
    multiselectList: [],
    qymcList: [],
    activeOption: 0,
    isFocus: false,
    timer1: null,
    imgSrc:'',
    onReady: function () {
      var self = this;
      try {
        this.hasHsPermission =
          this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
        this.searchData.swjgdm = avalonRoot.user.swjgDm;
        this.tsjgmc = avalonRoot.user.swjgMc;
      } catch (e) {}
      this.createTable();
      this.initMultiselect();
      //   self.initTree();
      // self.normalSearch();
      $(".fjlb .datepicker.date-day").datepicker({
        dateFormat: "yy-mm-dd",
      });
      $(".fjlb .datepicker.date-month").datepicker({
        dateFormat: "yymm",
      });
    },
    changeTab: function (num) {
      this.act = num;
    },
    createTable: function (arr) {
      var btnName = "处理更新";
      var self = this;
      var wwcColumns = [
        { name: "id", label: "主键", index: "id", hidden: true,sortable: false },
        { name: "title", label: "标题", index: "title", align: "left",sortable: false,width: 400,formatter: function (cellvalue, options, rowObject) {
          return (
            "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='fj'>" +
            cellvalue +
            "</span>"
          );
        } },
        // { name: "filename", label: "文件名", index: "filename", align: "left",width: 400 },
        // { name: "fmcode", label: "文件类型", index: "fmcode", align: "left" },
        {
          name: "zmbh",
          label: "报关单/代理证明",
          index: "zmbh",
          sortable: false,
          align: "left",
          width: 170
        },
        {
          name: "fjlx",
          label: "单证类型",
          index: "fjlx",
          sortable: false,
          align: "left",
          width: 100
        },
        {
          name: "nsrsbh",
          label: "企业税号",
          index: "nsrsbh",
          align: "left",
          sortable: false,
          width: 170,
        },
        {
          name: "nsrmc",
          label: "企业名称",
          index: "nsrmc",
          align: "left",
          sortable: false,
          width: 170,
        },
        { name: "dycs", label: "阅读状态",sortable: false, index: "dycs", align: "center",width: 80,formatter: function(cellvalue, options, rowObject){
          var str = ''
          if(cellvalue>0){
            str = '已阅读'
          }else{
            str = '未阅读'
          }
          return str;
        } },
        { name: "dycs", label: "阅读次数", index: "dycs",sortable: false, align: "left",width: 80 },
        { name: "islock", label: "锁定状态", index: "islock",sortable: false, align: "center",width: 80,formatter: function(cellvalue, options, rowObject){
					var map = { 'Y': '已锁定', 'N': '未锁定'};
					return map[cellvalue]?map[cellvalue]:'未锁定';
				} },
        { name: "note", label: "备注", index: "note",sortable: false, align: "left",width: 80 },
        // { name: "note2", label: "备注（税务）", index: "note2", align: "left",width: 80 },
        // { name: "jgfsDm", label: "监管方式", index: "jgfsDm", align: "left",width: 80 },
        { name: "crtime", label: "上传时间", index: "crtime",sortable: false, align: "center",width: 150 },
        { name: "filesize", label: "文件大小", index: "filesize",sortable: false, align: "center",width: 70 },
        {
          name: "op",
          label: "操作",
          index: "op",
          sortable: false,
          width: 160,
          formatter: function (cellvalue, options, rowObject) {
            var lockStr = "";
            if (rowObject.islock&&rowObject.islock=='Y') {
              lockStr =
                "<div class='btn js' style='float: none;display: inline-block;' title=''>解锁</div>";
            } else {
              lockStr =
                "<div class='btn sd' style='float: none;display: inline-block;' title=''>锁定</div>";
            }
             lockStr = self.hasHsPermission
              ? lockStr
              : "";
              var btnStr = "<div class='btn fj' style='float: none;display: inline-block;' title='查看附件'>查看附件</div>"
              
            return btnStr + lockStr;
          },
        },
      ];
      $("#fjlb-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: wwcColumns,
        viewrecords: true,
        rownumbers: true,
        pager: "#fjlb-tablePager",
        shrinkToFit: false,
        width: "100%",
        // multiselect: this.hasHsPermission,
        // multiselectWidth: "40",
        autowidth: true,
        altRows: true,
        // footerrow:true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".fjlb .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#fjlb-table").jqGrid("getRowData", rowid);
          var obj = self.tableData.rows[rowid - 1];
          if ($(e.target).hasClass("openMx")) {
            var tableNum = Number(sessionStorage.getItem("tableNum"));
            sessionStorage.setItem("tableNum", tableNum + 1);
            avalonRoot.addTab({
              title: "生产企业申报明细",
              component: "scqysbMx",
              sameCheck: true,
              params: {
                lcslid: obj.lcslid,
                shxyno: obj.shxyno,
                sssq: obj.sb_ym,
              },
            });
            return false;
          } else if ($(e.target).hasClass("js")) {
            self.modelData.id = row.id;
            self.modelData.nsrsbh = row.nsrsbh;
            self.modelData.lockFlag = "N";
            self.modelData.note2 = row.note2 ? row.note2 : "";
            self.showModel("解锁");
          } else if ($(e.target).hasClass("sd")) {
            self.modelData.id = row.id;
            self.modelData.nsrsbh = row.nsrsbh;
            self.modelData.lockFlag = "Y";
            self.modelData.note2 = row.note2 ? row.note2 : "";
            self.showModel("锁定");
          } else if ($(e.target).hasClass("edit")) {
            self.multiselectList = [rowid];
            self.showModel(btnName);
            return false;
          } else if ($(e.target).hasClass("fj")) {
            self.showModelPdf(row);
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
          self.searchData.orderSql = index + " " + sortorder;
          self.search(1);
          return;
        },
        onSelectRow: function (rowid, status) {
          var row = $("#fjlb-table").jqGrid("getRowData", rowid);
          var index = self.multiselectList.indexOf(rowid);
          if (status) {
            self.multiselectList.push(rowid);
          } else {
            self.multiselectList.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          if (status) {
            self.multiselectList = JSON.parse(JSON.stringify(rowids));
          } else {
            self.multiselectList = [];
          }
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "fjlb-table");
          self.search(pageNo);
        },
        gridComplete: function () {
          var ids = $("#fjlb-table").getDataIDs();
          for (var i = 0; i < ids.length; i++) {
            var rowData = $("#fjlb-table").getRowData(ids[i]);
            if (!rowData.dycs) {
              // 有效标志=N的指标记录用浅灰背景色
              // $('#' + ids[i]).find("td").css("background", '#eee');
              $('#fjlb-table '+"#" + ids[i])
                .find("td")
                .css("background", "#d9ecff");
            } else if (rowData.swjgdm != avalonRoot.user.swjgDm) {
              // $('#' + ids[i]).find("td").css("background", '#d9ecff');
            }
          }
        },
      });
      this.searchData.pageSize = $(".ui-pg-selbox", $(".fjlb")).val();
    },
    setTableOption: function () {
      var self = this;
      setTimeout(function () {
        self.resetTable();
      }, 200);
      if (self.timer == null) {
        self.timer = setTimeout(function () {
          self.updataOption();
          clearTimeout(self.timer);
          self.timer = null;
        }, 2000);
      } else {
        clearTimeout(self.timer);
        self.timer = setTimeout(function () {
          self.updataOption();
          clearTimeout(self.timer);
          self.timer = null;
        }, 2000);
      }
    },
    updataOption: function () {
      var self = this;
      var cs = [];
      for (var i = 0; i < self.tableOption.length; i++) {
        if (self.tableOption[i].show == true) {
          cs.push(self.tableOption[i].name);
        }
      }
      var params = {
        tcode: this.tcode,
        cs: cs.join(","),
      };
      ajax("POST", "/cxfw/basis/columprofile/update", params)
        .done(function (res) {
          if (res.code != "0") {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    resetTable: function () {
      var self = this;
      for (var i = 0; i < self.tableOption.length; i++) {
        if (self.tableOption[i].show == true) {
          $("#fjlb-table").showCol(self.tableOption[i].name);
        } else {
          $("#fjlb-table").hideCol(self.tableOption[i].name);
        }
      }
      $("#fjlb-table").setGridWidth($(".fjlb").width());
    },
    normalSearch() {
      this.searchData.orderSql = "";
      $(".s-ico").hide();
      this.search(1);
    },
    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize = $(".ui-pg-selbox", $(".fjlb")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      if(!params.qybs){
        tools.info('企业标识不能为空')
        return
      }
      $("#fjlb-table").jqGrid("clearGridData");
      ajax("POST", "/cxfw/cqwsb/doc/list", params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data;
            $("#fjlb-table").resetSelection();
            $("#fjlb-table")[0].addJSONData(res.data);
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
      $(".fjlb .select-sub").toggle();
      $(".fjlb .select-wrapper .icon").toggleClass("active");
      if (
        $(".fjlb .select-wrapper .icon").attr("title").slice(0, 2) === "展开"
      ) {
        $(".fjlb .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".fjlb .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".fjlb .select-sub").hide();
      $(".fjlb .select-wrapper .icon").removeClass("active");
      $(".fjlb .select-wrapper .icon").attr("title", "展开查询条件");
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
      $(".fjlb").on("click", function (e) {
        var e = e || window.event;
        if ($(".dropdown-menu").find($(e.target)).length <= 0) {
          self.hideMenu();
        }
      });
    },
    hideMenu: function () {
      $(".dropdown-menu").hide();
      $(".fjlb").off("click");
    },
    //copy
    initTree: function () {
      var self = this;
      var setting = {
        callback: {
          onClick: function (e, id, node) {
            self.searchData.swjgdm = node.id;
            self.tsjgmc = node.text;
            self.hideTree();
            return;
          },
          onDblClick: function (e, id, node) {
            self.searchData.swjgdm = node.id;
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
          $.fn.zTree.init($(".fjlb .treeDiv"), setting, data);
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".fjlb").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".fjlb").off("click");
    },
    exform: function () {
      var self = this;
      if ($("#fjlb-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData);
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/cxfw/fxgl/ckyzshw/list/export");
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
        qybs: "",
        czflag: "",
        fjlx: "",
        note: "",
        title: "",
        orderSql: "",
        pageSize: config.pageSize,
      };
      this.tsjgmc = avalonRoot.user.swjgMc;
    },
    showModel: function (title) {
      this.addTitle = title;
      $(".model").show();
      $(".fjlb .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".fjlb .add-page-model").hide();
      this.modelData = {
        id: "",
        nsrsbh: "",
        isRead: "",
        lockFlag: "",
        note2: "",
      };
    },
    isRead(params) {
      var self = this;
      ajax("POST", "/cxfw/cqwsb/doc/status/update", params).done(function (
        res
      ) {
        if (res.code == "0") {
          self.search(1);
        }
      });
    },
    saveModel: function () {
      var self = this;
      // var valid = this.checkValid(this.modelData);
      // if (!valid) return;
      let params = tools.clone(this.modelData);
      ajax("POST", "/cxfw/cqwsb/doc/status/update", params)
        .done(function (res) {
          if (res.code == "0") {
            tools.info("操作成功");
            self.hideModel();
            self.search(1);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
      // let saveList = [];
      // if (self.multiselectList.length) {
      //   self.multiselectList.forEach((item) => {
      //     var row = $("#fjlb-table").jqGrid("getRowData", item);
      //     var obj = {
      //       djxh: row.djxh,
      //       ckbgdh: row.ckbgdh,
      //     };
      //     saveList.push(obj);
      //   });
      // }
      // params.saveList = saveList;
    },
    // 校验必填项
    checkValid: function (modelData) {
      var rules = [{ name: "remark", message: "标注信息不能为空！" }];
      for (var i = 0; i < rules.length; i++) {
        if (modelData[rules[i].name] == "") {
          tools.info(rules[i].message);
          return false;
        }
      }
      return true;
    },
    multiHandle() {
      this.showModel("批量处理");
    },
    changeOption(event) {
      if (event.key === "ArrowDown") {
        event.preventDefault();
        if (this.activeOption < this.qymcList.length - 1) {
          this.activeOption += 1;
        }
      }
      if (event.key === "ArrowUp") {
        event.preventDefault();
        if (this.activeOption > 0) {
          this.activeOption -= 1;
        }
      }
      if (event.key === "ArrowDown" || event.key === "ArrowUp") {
        let sHeight = $(".g-autoselect").scrollTop();
        let tHeight = 28 * this.activeOption - sHeight;
        if (tHeight >= 168) {
          $(".g-autoselect").scrollTop(28 * this.activeOption - 168);
        }
        if (tHeight <= 0) {
          $(".g-autoselect").scrollTop(28 * this.activeOption);
        }
      }
      if (event.key === "Enter") {
        this.searchData.qybs = this.qymcList[this.activeOption].shxyno;
        // this.formData.shxyno = this.qymcList[this.activeOption].shxyno;
        // this.formData.nsrmc = this.qymcList[this.activeOption].nsrmc;
        // this.formData.qylx = this.qymcList[this.activeOption].qylx;
        this.isFocus = false;
        this.qymcList = [];
      }
    },
    chooseOption(k) {
      this.searchData.qybs = this.qymcList[k].shxyno;
      // this.formData.shxyno = this.qymcList[k].shxyno;
      // this.formData.nsrmc = this.qymcList[k].nsrmc;
      // this.formData.qylx = this.qymcList[this.activeOption].qylx;
      this.isFocus = false;
      this.qymcList = [];
    },
    getQymc(event) {
      if (
        event.key === "ArrowDown" ||
        event.key === "ArrowUp" ||
        event.key === "Enter"
      ) {
        return;
      }
      this.isFocus = true;
      var shxyno = event.target.value;
      var self = this;
      var hasZh = /[\u4e00-\u9fff]+/.test(shxyno)
      if (shxyno.length >= 4&&!hasZh) {
        clearTimeout(self.timer1);
        self.timer1 = setTimeout(function () {
          ajax("POST", "/cxfw/fxgl/fxyd/nsr/list", { shxyno: shxyno })
            .done(function (res) {
              if (res.code == "0") {
                self.qymcList = res.data;
              } else {
                tools.info(res.msg);
              }
            })
            .fail(function (err) {
              tools.info(err);
            });
        }, 500);
      }
    },
    selectFocus() {
      this.isFocus = true;
      this.handleAutoselect();
    },
    selectBlur() {
      setTimeout(() => {
        this.isFocus = false;
      }, 200);
    },
    setActiveOption(k) {
      this.activeOption = k;
    },
    //查看pdf
    showModelPdf: function (row) {
      var self = this;
      var params = {
        nsrsbh: row.nsrsbh,
        fileId: row.id,
      };
      ajax("POST", "/bjtssw/sbxx/doc/view", params)
        .done(function (res) {
          if (res.code == "0"&& res.data) {
            $(".model").show();
            $(".fjlb .page-model-pdf").show();
            var pdfSrc = res.data;
            var pdfBlob = tools.dataURLtoBlob(
              "data:application/pdf;base64," + pdfSrc
            );
            var pdfUrl = URL.createObjectURL(pdfBlob);
            self.createPdf(pdfUrl);
            if(self.hasHsPermission){
              var params = {
                nsrsbh: row.nsrsbh,
                id: row.id,
                isRead: "1",
              };
              self.isRead(params);
            }
          }else{
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    createPdf: function(url) {
      var options = {
        pdfOpenParams: {
          navpanes: 0,
          toolbar: 0,
          statusbar: 0,
          view: "FitV",
          pagemode: "thumbs",
          page: 1
        },
        forcePDFJS: true,
        PDFJS_URL: "../../jdgl/static/pdfjs/web/viewer.html"
      };

      var myPDF = PDFObject.embed(url, "#sb-fjlb-pdf", options);

      var el = document.querySelector("#sb-fjlb-results");
      el.setAttribute("class", (myPDF) ? "success" : "fail");
      el.innerHTML = (myPDF) ? "" : "Uh-oh, the embed didn't work.";
    },
    hideModelPdf:function(){
      $(".model").hide();
      $('.fjlb .page-model-pdf').hide();
    },
    // 多选下拉框
		initMultiselect: function(){
			var self = this
			let id = '#cqwsb_select_dzlx'
			let options = []
      let values = []
      options = [
        {
          label: "报关单",
          title: "报关单",
          value: "报关单",
          selected: false,
        },
        {
          label: "出口发票",
          title: "出口发票",
          value: "出口发票",
          selected: false,
        },
        {
          label: "进货凭证",
          title: "进货凭证",
          value: "进货凭证",
          selected: false,
        },
        {
          label: "申报资料",
          title: "申报资料",
          value: "申报资料",
          selected: false,
        },
        {
          label: "财务凭证",
          title: "财务凭证",
          value: "财务凭证",
          selected: false,
        },
        {
          label: "其他资料",
          title: "其他资料",
          value: "其他资料",
          selected: false,
        },
      ];
			$(id).multiselect({
				nonSelectedText: '',
				nSelectedText: '项已选择',
				allSelectedText: '全部选中',
				onChange: function(option, checked, select) {
					let val = $(option).val()
					if (checked) {
						values.push(val)
					} else {
						let i = values.indexOf(val)
						values.splice(i,1)
					}
					self.searchData.fjlx = values.join(",");
				}
			});
			$(id).multiselect('dataprovider', options);
		},
  },
});
