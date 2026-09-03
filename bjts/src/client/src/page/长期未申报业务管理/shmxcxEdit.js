var shmxcxEdit = require("./shmxcxEdit.html");
avalon.component("shmxcxEdit", {
  template: shmxcxEdit,
  defaults: {
    params: {
      lcslid: "",
      shxyno: "",
      sssq: "",
    },
    activeIndex: 0,
    totalCount: 0,
    fxlyList: [],
    form: {
      baseinfo: {
        flglcd: "",
        nsrmc: "",
        qyhgdm: "",
        qylx: "",
        sb_pc: "",
        sb_ym: "",
        shxy_no: "",
        swjgmc: "",
      },
      ywsxqk: {},
      shqk: {},
      hzqk: {},
      ttkqk: {},
      jxkh: {},
    },
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
    isCkfphmVisible: false,
    isJhpzhVisible: false,
    submitData: {
      djxh: "",
      ckbgdh: "",
      swshZt: "",
      swshHtyj: "",
    },
    htrzData: {
      djxh: "",
      ckpzhm: "",
      pageSize: config.pageSize,
    },
    formData: {},
    baseData: {
      tbdw: "",
      tbr: "",
      tbrq: "",
    },
    fxrwlyDm: "",
    sfysjc: "",
    sfhcywt: "",
    sfysga: "",
    values: [],
    isOpenTable: false,
    tableNum: 0,
    curFormHeight: 500,
    activeOption: 0, //记录下拉选的下标 所有下拉选通用 选中后需要重置为0
    qymcList: [],
    isFocus: false,
    timer: null,
    ckfphmText: "",
    jhpzhText: "",
    jeList: ["mylaj", "rmblaj", "zsJtxxse", "zsYsxse", "msMsxse", "msJxzcje"],
    jsFlag: false,
    selectShzt: false,
    isFjlbCollapsed: false, // 附件列表是否折叠
    searchData: {
      nsrsbh: "",
      czflag: "",
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
    orderSql: "",
    isFirst: true,
    wqrFlag: false,
    onReady: function () {
      $(".shmxcxEdit .datepicker.date-month").datepicker({
        dateFormat: "yymm",
      });
      $(".shmxcxEdit .datepicker.date-day").datepicker({
        dateFormat: "yy-mm-dd",
      });
      if (this.params.row) {
        this.formData = this.params.row;
        this.htrzData.djxh = this.params.row.djxh;
        this.htrzData.ckpzhm = this.params.row.ckbgdh;
        this.submitData.djxh = this.params.row.djxh;
        this.submitData.ckbgdh = this.params.row.ckbgdh;
        if (this.formData.zmsCkfphm) {
          this.ckfphmText = this.formData.zmsCkfphm.replace(/,/g, ",<br>");
        }
        if (this.formData.msJhpzh) {
          this.jhpzhText = this.formData.msJhpzh.replace(/,/g, ",<br>");
        }
        if (!this.formData.jsYd) {
          this.formData.jsYd = "";
        }
        if (this.formData.qyqrZt == "未确认") {
          this.wqrFlag = true;
        }
        this.hasHsPermission =
          this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
        if (
          this.formData.swshZt == "未审核" &&
          (this.hasHsPermission || avalonRoot.user.roleDm == "super")
        ) {
          this.jsFlag = true;
        }
        if (this.formData.swshZt == "审核通过") {
          this.selectShzt = true;
          this.submitData.swshZt = "2";
        } else {
          this.submitData.swshZt = "1";
        }
        for (const key in this.formData) {
          if (this.jeList.includes(key)) {
            this.formData[key] =
              this.formData[key] ||
              this.formData[key] === 0 ||
              this.formData[key] === "0"
                ? avalon.filters.number(this.formData[key], "2")
                : "";
          }
        }

        this.createTable();
        this.createTableAddCkyw();
        this.searchCkyw(1);
      }
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
    goBack() {
      var title = "";
      if (this.params.title == "查看") {
        title = "审核明细查看";
      } else {
        title = "审核";
      }
      avalonRoot.delDQTab({ title: title });
      window.SHMXCX_SEARCH && window.SHMXCX_SEARCH();
    },
    save() {
      var title = "";
      if (this.params.title == "查看") {
        title = "审核明细查看";
      } else {
        title = "审核";
      }
      var self = this;
      var params = tools.clone(self.submitData);
      if (!this.submitData.swshZt) {
        tools.info("请选择税务审核状态");
        return;
      }
      // if (this.submitData.swshZt == 2 && !this.submitData.swshHtyj) {
      //   tools.info("税务审核意见不能为空");
      //   return;
      // }
      ajax("POST", "/cxfw/cqwsb/shmx/submit", params).done(function (res) {
        if (res.code == "0") {
          tools.info("审核提交成功");
          this.selectShzt = true;
          avalonRoot.delDQTab({ title: title });
          window.SHMXCX_SEARCH && window.SHMXCX_SEARCH();
          // self.goBack();
        } else {
          tools.info(res.msg);
        }
      });
    },
    checkValid: function (formData) {
      var rules = [
        { name: "ssny", message: "所属年月批次不能为空！" },
        { name: "fxrwlyDm", message: "请选择风险企业来源！" },
        { name: "shxyno", message: "统一社会信用代码不能为空！" },
        { name: "nsrmc", message: "企业名称不能为空！" },
        { name: "fxydcsJh", message: "请选择风险应对措施！" },
        { name: "sfysjc", message: "请选择是否移送稽查！" },
        { name: "sfhcywt", message: "请选择是否存在问题！" },
        { name: "sfysga", message: "请选择是否移送公安！" },
      ];
      for (var i = 0; i < rules.length; i++) {
        if (formData[rules[i].name] == "") {
          tools.info(rules[i].message);
          return false;
        }
      }
      return true;
    },
    jsCheck() {
      var self = this;
      if (this.formData.jsZt == "未审核" || this.formData.jsZt == "") {
        var params = {};
        params.djxh = this.htrzData.djxh;
        params.ckbgdh = this.htrzData.ckpzhm;
        ajax("POST", "/cxfw/cqwsb/shmx/submit/js", params).done(function (res) {
          if (res.code == "0") {
            tools.info("此业务暂不满足机审条件");
          } else if (res.code == "701") {
            self.searchJsData();
            tools.info(res.msg);
          } else {
            tools.info(res.msg);
          }
        });
      } else {
        tools.confirm(
          "该数据已经完成机审，是否再次发起？",
          "确定",
          function () {
            var params = {};
            params.djxh = self.htrzData.djxh;
            params.ckbgdh = self.htrzData.ckpzhm;
            ajax("POST", "/cxfw/cqwsb/shmx/submit/js", params).done(function (
              res
            ) {
              if (res.code == "0") {
                tools.info("此业务暂不满足机审条件");
              } else if (res.code == "701") {
                self.searchJsData();
                tools.info(res.msg);
              } else {
                tools.info(res.msg);
              }
            });
          }
        );
      }
    },
    searchJsData() {
      var self = this;
      var params = {
        djxh: this.htrzData.djxh,
        ckpzhm: this.htrzData.ckpzhm,
        pageNo: 1,
        pageSize: "20",
      };
      ajax("POST", "/cxfw/cqwsb/shmx/list", params).done(function (res) {
        if (res.code == "0") {
          var data = res.data.rows[0];
          self.formData = data;
          // self.formData.jsZt = data.jsZt
          // self.formData.jsRq = data.jsRq
          // self.formData.jsYd = data.jsYd
        }
      });
    },
    createTableAddCkyw: function () {
      var self = this;
      var columns = [
        {
          name: "ckbgdh",
          label: "报关单号/代理证明号",
          index: "ckbgdh",
          width: 180,
          align: "left",
          sortable: false,
        },
        {
          name: "qyqrRq",
          label: "企业确认时间",
          index: "qyqrRq",
          width: 100,
          align: "center",
          sortable: false,
        },
        {
          name: "qyqrZt",
          label: "企业确认状态",
          index: "qyqrZt",
          width: 90,
          align: "center",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            var map = {
              0: "未确认",
              1: "适用征税",
              2: "适用免税",
              3: "已全部退税",
              4: "待申报退税",
              5: "非本企业业务",
            };
            return map[cellvalue] ? map[cellvalue] : "";
          },
        },
        {
          name: "swshHtyj",
          label: "审核意见",
          index: "swshHtyj",
          width: 140,
          align: "left",
          sortable: false,
        },
        {
          name: "swshRq",
          label: "审核时间",
          index: "swshRq",
          width: 100,
          align: "center",
          sortable: false,
        },
        {
          name: "swshRy",
          label: "审核人员",
          index: "swshRy",
          width: 90,
          align: "center",
          sortable: false,
        },
        {
          name: "swshZt",
          label: "审核状态",
          index: "swshZt",
          width: 90,
          align: "center",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            var map = { 0: "未审核", 1: "审核通过", 2: "退回" };
            return map[cellvalue] ? map[cellvalue] : "";
          },
        },
        {
          name: "zmsFj",
          label: "附件",
          index: "zmsFj",
          width: 50,
          align: "right",
          sortable: false,
        },
        {
          name: "zmsSbssq",
          label: "申报所属期",
          index: "zmsSbssq",
          width: 70,
          align: "center",
          sortable: false,
        },
        {
          name: "zmsCkfphm",
          label: "出口发票号码",
          index: "zmsCkfphm",
          width: 100,
          align: "left",
          sortable: false,
        },
        {
          name: "zsJtxxse",
          label: "计提销项税额",
          index: "zsJtxxse",
          width: 90,
          align: "right",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            return cellvalue || cellvalue === 0
              ? avalon.filters.number(cellvalue, 2)
              : "";
          },
        },
        {
          name: "zsYsxse",
          label: "应税销售额",
          index: "zsYsxse",
          width: 90,
          align: "right",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            return cellvalue || cellvalue === 0
              ? avalon.filters.number(cellvalue, 2)
              : "";
          },
        },
        {
          name: "msJhpzh",
          label: "进货凭证号",
          index: "msJhpzh",
          width: 100,
          align: "left",
          sortable: false,
        },
        {
          name: "msJhpzhbz",
          label: "进货凭证号标志",
          index: "msJhpzhbz",
          width: 100,
          align: "left",
          sortable: false,
        },
        {
          name: "msJxzcbz",
          label: "进项转出标志",
          index: "msJxzcbz",
          width: 100,
          align: "left",
          sortable: false,
        },
        {
          name: "msJxzcje",
          label: "进项转出金额",
          index: "msJxzcje",
          width: 100,
          align: "right",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            return cellvalue || cellvalue === 0
              ? avalon.filters.number(cellvalue, 2)
              : "";
          },
        },
        {
          name: "msJxzcssq",
          label: "进项转出所属期",
          index: "msJxzcssq",
          width: 100,
          align: "left",
          sortable: false,
        },
        {
          name: "msMsxse",
          label: "免税销售额",
          index: "msMsxse",
          width: 100,
          align: "right",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            return cellvalue || cellvalue === 0
              ? avalon.filters.number(cellvalue, 2)
              : "";
          },
        },
        {
          name: "wsbYylx",
          label: "未申报原因类型",
          index: "wsbYylx",
          width: 100,
          align: "left",
          sortable: false,
        },
        {
          name: "wsbYysm",
          label: "具体原因说明",
          index: "wsbYysm",
          width: 100,
          align: "left",
          sortable: false,
        },
        {
          name: "zmsBz",
          label: "备注",
          index: "zmsBz",
          width: 100,
          align: "left",
          sortable: false,
        },
      ];
      $("#shmxcxEdit-ckyw-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        rownumbers: true,
        shrinkToFit: false,
        autoScroll: true,
        // multiselect: true,
        viewrecords: true,
        pager: "#shmxcxEdit-ckyw-tablePager",
        // multiselectWidth:"30",
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        width: (function () {
          return $(".shmxcxEdit .table-content").width();
        })(),
        height: 300,
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "shmxcxEdit-ckyw-table");
          self.searchCkyw(pageNo);
        },
      });
      this.htrzData.pageSize = $(".ui-pg-selbox", $(".shmxcxEdit")).val();
    },
    createTable: function (arr) {
      var btnName = "处理更新";
      var self = this;
      var wwcColumns = [
        { name: "id", label: "主键", index: "id", hidden: true },
        {
          name: "fjlx",
          label: "附件类型",
          index: "fjlx",
          align: "center",
          width: 100,
          sortable: false,
          fixed: true,
        },
        {
          name: "title",
          label: "附件标题",
          index: "title",
          width: 400,
          sortable: false,
          align: "left",
          formatter: function (cellvalue, options, rowObject) {
            const icon =
              rowObject.islock === "Y"
                ? "static/image/icon_lock.png"
                : "static/image/icon_unlock.png";
            const sdzt = rowObject.islock === "Y" ? "js" : "sd";
            return `<span style='display: flex;align-items: center;white-space: nowrap;'>
    <span style='color:#0000ff; text-decoration: underline; vertical-align: middle;cursor:pointer;' class="fj">
      ${cellvalue}
    </span>
    <img src="${icon}" class="${sdzt}" style="vertical-align: middle; margin-left: 5px; width: 16px; height: 16px;cursor:pointer;">
  </span>`;
          },
        },
        {
          name: "crtime",
          label: "上传时间",
          index: "crtime",
          align: "center",
          width: 150,
          fixed: true,
          sortable: false,
        },
        {
          name: "dycs",
          label: "阅读次数",
          index: "dycs",
          align: "left",
          width: 80,
          hidden: true,
        },
        {
          name: "islock",
          label: "锁定状态",
          index: "islock",
          align: "center",
          sortable: false,
          width: 80,
          fixed: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "已锁定", N: "未锁定" };
            return map[cellvalue] ? map[cellvalue] : "未锁定";
          },
        },
        {
          name: "note",
          label: "备注",
          index: "note",
          align: "left",
          sortable: false,
          width: 200,
        },
        {
          name: "nsrsbh",
          label: "企业税号",
          index: "nsrsbh",
          align: "left",
          width: 170,
          hidden: true,
        },
      ];
      $("#shmxcxEdit-fjlb-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: wwcColumns,
        viewrecords: true,
        rownumbers: true,
        pager: "#shmxcxEdit-fjlb-tablePager",
        shrinkToFit: true,
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
        height: 300,
        beforeSelectRow: function (rowid, e) {
          var row = $("#shmxcxEdit-fjlb-table").jqGrid("getRowData", rowid);
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
            self.showFjModel("解锁");
          } else if ($(e.target).hasClass("sd")) {
            self.modelData.id = row.id;
            self.modelData.nsrsbh = row.nsrsbh;
            self.modelData.lockFlag = "Y";
            self.modelData.note2 = row.note2 ? row.note2 : "";
            self.showFjModel("锁定");
          } else if ($(e.target).hasClass("edit")) {
            self.multiselectList = [rowid];
            self.showFjModel(btnName);
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
        // onSortCol: function (index, iCol, sortorder) {
        //   self.orderSql = index + " " + sortorder;
        //   self.search(1);
        //   return;
        // },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "shmxcxEdit-fjlb-table");
          self.search(pageNo);
        },
        gridComplete: function () {
          var ids = $("#shmxcxEdit-fjlb-table").getDataIDs();
          for (var i = 0; i < ids.length; i++) {
            var rowData = $("#shmxcxEdit-fjlb-table").getRowData(ids[i]);
            if (!rowData.dycs) {
              // 有效标志=N的指标记录用浅灰背景色
              $("#shmxcxEdit-fjlb-table " + "#" + ids[i])
                .find("td")
                .css("background", "#d9ecff");
            } else if (rowData.swjgdm != avalonRoot.user.swjgDm) {
            }
          }
        },
      });
      this.search(1);
    },
    search: function (pageNo) {
      var self = this;
      var params = {
        qybs: this.formData.nsrsbh,
        czflag: "",
        fjlx: "",
        note: "",
        filename: "",
        orderSql: "",
        ckpzhm: this.formData.ckbgdh || "",
        pageSize: $(".ui-pg-selbox", $(".shmxcxEdit-fjlb-table")).val() || 20,
        pageNo: pageNo,
      };
      $("#shmxcxEdit-fjlb-table").jqGrid("clearGridData");
      ajax("POST", "/cxfw/cqwsb/doc/list", params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data;
            self.totalCount = res.data.records;
            if (self.isFirst && res.data.records > 0) {
              self.isFirst = false;
              self.toggleCollapse();
            }
            // $("#shmxcxEdit-fjlb-table").resetSelection();
            if ($("#shmxcxEdit-fjlb-table")[0]) {
              $("#shmxcxEdit-fjlb-table")[0].addJSONData(res.data);
            }
            // self.closeHyper();
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    //查看pdf
    showModelPdf: function (row) {
      console.log(1233);

      var self = this;
      var params = {
        nsrsbh: row.nsrsbh,
        fileId: row.id,
      };
      ajax("POST", "/bjtssw/sbxx/doc/view", params)
        .done(function (res) {
          if (res.code == "0" && res.data) {
            $(".model").show();
            $(".shmxcxEdit .page-model-pdf").show();
            var pdfSrc = res.data;
            var pdfBlob = tools.dataURLtoBlob(
              "data:application/pdf;base64," + pdfSrc
            );
            var pdfUrl = URL.createObjectURL(pdfBlob);
            self.createPdf(pdfUrl);
            if (self.hasHsPermission) {
              var params = {
                nsrsbh: row.nsrsbh,
                id: row.id,
                isRead: "1",
              };
              self.isRead(params);
            }
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    searchCkyw(pageNo) {
      try {
        var self = this;
        this.htrzData.pageSize = $(".ui-pg-selbox", $(".shmxcxEdit")).val();

        var params = tools.clone(self.htrzData);
        params.pageNo = pageNo;
        $("#shmxcxEdit-ckyw-table").jqGrid("clearGridData");
        ajax("POST", "/cxfw/cqwsb/shmx/htrz/list", params)
          .done(function (res) {
            if (res.code == "0") {
              $("#shmxcxEdit-ckyw-table").resetSelection();
              $("#shmxcxEdit-ckyw-table")[0].addJSONData(res.data);
            } else {
              tools.info(res.msg);
            }
          })
          .fail(function (err) {
            tools.info(err);
          });
      } catch (error) {
        console.log(error);
      }
    },
    fjView() {
      avalonRoot.addTab({
        title: "附件列表",
        component: "fjlb",
        params: { nsrsbh: this.formData.nsrsbh },
        sameCheck: true,
      });
    },
    showTooltip(val) {
      if (val == "ckfp" && this.formData.zmsCkfphm) {
        this.isCkfphmVisible = true;
      } else if (val == "jhpz" && this.formData.msJhpzh) {
        this.isJhpzhVisible = true;
      }
    },
    hideTooltip(val) {
      if (val == "ckfp") {
        this.isCkfphmVisible = false;
      } else if (val == "jhpz") {
        this.isJhpzhVisible = false;
      }
    },
    showModel: function () {
      $(".model").show();
      $(".shmxcxEdit .hscl-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".shmxcxEdit .hscl-page-model").hide();
    },
    toggleCollapse() {
      this.isFjlbCollapsed = !this.isFjlbCollapsed;
      const icon = document.querySelector(".table-header-toggle .toggle-icon");
      icon.classList.toggle("rotated");
      if (this.isFjlbCollapsed) {
        this.createTable();
      }
    },
    createPdf: function (url) {
      var options = {
        pdfOpenParams: {
          navpanes: 0,
          toolbar: 0,
          statusbar: 0,
          view: "FitV",
          pagemode: "thumbs",
          page: 1,
        },
        forcePDFJS: true,
        PDFJS_URL: "../../jdgl/static/pdfjs/web/viewer.html",
      };

      var myPDF = PDFObject.embed(url, "#sb-shmxcxEdit-pdf", options);

      var el = document.querySelector("#sb-shmxcxEdit-results");
      el.setAttribute("class", myPDF ? "success" : "fail");
      el.innerHTML = myPDF ? "" : "Uh-oh, the embed didn't work.";
    },
    hideModelPdf: function () {
      $(".model").hide();
      $(".shmxcxEdit .page-model-pdf").hide();
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
    showFjModel: function (title) {
      this.addTitle = title;
      $(".model").show();
      $(".shmxcxEdit .add-page-model").show();
    },
    hideFjModel: function () {
      $(".model").hide();
      $(".shmxcxEdit .add-page-model").hide();
      this.modelData = {
        id: "",
        nsrsbh: "",
        isRead: "",
        lockFlag: "",
        note2: "",
      };
    },
    saveModel: function () {
      var self = this;
      let params = tools.clone(this.modelData);
      ajax("POST", "/cxfw/cqwsb/doc/status/update", params)
        .done(function (res) {
          if (res.code == "0") {
            tools.info("操作成功");
            self.hideFjModel();
            self.search(1);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
  },
});
