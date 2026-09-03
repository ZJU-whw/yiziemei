var spfxckwh = require("./spfxckwh.html");
avalon.component("spfxckwh", {
  template: spfxckwh,
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
      // swjgdm: "",
      fxly: "",
      gzmc: "",
      spdm: "",
      spmc: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    modelData: {
      id: "",
      gzFwData: "",
      gzMc: "",
      gzFxms: "",
      gzSpdm: "",
      gzSpmc: "",
      gzGgxh: "",
      gzCkka: "",
      gzCkgb: "",
      gzHyd: "",
      gzDjq: "",
      gzDjz: "",
      gzYxqz: "",
      gzDxtxbz: "",
      qybj: "",
      gzZjq: "",
      gzZjz: "",
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
    onReady: function () {
      var self = this;
      try {
        this.hasHsPermission =
          this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
        this.tsjgmc = avalonRoot.user.swjgMc;
        this.syjgfw = avalonRoot.user.swjgMc;
      } catch (e) {}
      this.getTableRow();
      $(".spfxckwh .datepicker.date-day").datepicker({
        dateFormat: "yy-mm-dd",
      });
      $(".spfxckwh .datepicker.date-month").datepicker({
        dateFormat: "yymm",
      });
    },
    changeTab: function (num) {
      this.activeIndex = num;
      this.normalSearch();
    },
    //copy bg
    getTableRow: function () {
      var self = this;
      ajax("POST", "/cxfw/basis/columprofile", { tcode: self.tcode })
        .done(function (res) {
          if (res.code == "0") {
            var arr = res.data.profiles;
            self.tableRowList = arr;
            var tableArr = [];
            var tableOption = [];
            for (var i = 0; i < arr.length; i++) {
              var obj = {
                name: arr[i].t_c_code,
                label: arr[i].t_c_name,
                index: arr[i].t_c_code,
                sortable: arr[i].is_order == 0 ? false : true,
                hidden: false,
                width: arr[i].c_std_size,
                align:
                  arr[i].align == 0
                    ? "left"
                    : arr[i].align == 1
                    ? "center"
                    : "right",
              };
              if (arr[i].degree) {
                var degree = arr[i].degree;
                obj.formatter = function (cellvalue, options, rowObject) {
                  return avalon.filters.number(cellvalue, degree);
                };
              }
              tableArr.push(obj);
              if (arr[i].is_fixed == "0") {
                tableOption.push({
                  name: arr[i].t_c_code,
                  label: arr[i].t_c_name,
                  show: false,
                });
              }
            }
            self.tableArr = tableArr;
            self.tableOption = tableOption;
            if (tableArr.length > 0) {
              self.createTable(tableArr);
            }
            var selected = res.data.select.split(",");
            for (var j = 0; j < selected.length; j++) {
              var name = selected[j];
              for (var k = 0; k < self.tableOption.length; k++) {
                if (name == self.tableOption[k].name) {
                  self.tableOption[k].show = true;
                }
              }
            }
            self.resetTable();
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    createTable: function (arr) {
      var btnName = this.activeIndex == "0" ? "编辑" : "查看";
      var self = this;
      var cm = [];
      for (var i = 0; i < arr.length; i++) {
        cm[i] = tools.clone(arr[i]);
      }
      let op = {
        name: "op",
        label: "操作",
        index: "op",
        width: 116,
        formatter: function (cellvalue, options, rowObject) {
          let returnBtn = "";
          if (self.activeIndex == "0") {
            returnBtn =
              "<div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn del' style='float: none;display: inline-block;' title='删除'>删除</div>";
          } else {
            returnBtn =
              "<div class='btn edit' style='float: none;display: inline-block;' title='查看'>查看</div>";
          }
          return returnBtn;
        },
      };
      cm.push(op);
      $("#spfxckwh-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: cm,
        viewrecords: true,
        rownumbers: true,
        pager: "#spfxckwh-tablePager",
        shrinkToFit: false,
        width: "100%",
        // multiselect: true,
        // multiselectWidth:"30",
        autowidth: true,
        altRows: true,
        // footerrow:true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".spfxckwh .form").height() - 120;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#spfxckwh-table").jqGrid("getRowData", rowid);
          if ($(e.target).hasClass("openMx")) {
            var obj = self.tableData.rows[rowid - 1];
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
          } else if ($(e.target).hasClass("edit")) {
            for (var key in self.modelData) {
              self.modelData[key] = row[key];
            }
            self.modelData.id = rowid;
            let gzFwDataList = [
              { value: "1", label: "出口电子信息" },
              { value: "2", label: "申报出口明细" },
              { value: "3", label: "同时适用" },
            ];
            gzFwDataList.forEach((item) => {
              if (item.label == self.modelData.gzFwData) {
                self.modelData.gzFwData = item.value;
              }
            });
            var btnName = self.activeIndex == "0" ? "编辑" : "查看";
            self.showModel(btnName);
            return false;
          } else if ($(e.target).hasClass("del")) {
            tools.confirm("是否确定删除该条数据？", "确定", function () {
              var params = {
                id: rowid,
              };
              ajax("POST", "/cxfw/fxgl/fxsp/del", params)
                .done(function (res) {
                  if (res.code == "0") {
                    self.search(1);
                  } else {
                    tools.info(res.msg);
                  }
                })
                .fail(function (err) {
                  tools.info(err);
                });
            });
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
          let name = "";
          if (self.tableRowList[iCol - 1].f1) {
            name = self.tableRowList[iCol - 1].f1;
          } else {
            name = index;
          }
          self.searchData.orderSql = name + " " + sortorder;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "spfxckwh-table");
          self.search(pageNo);
        },
      });
      this.searchData.pageSize = $(".ui-pg-selbox", $(".spfxckwh")).val();
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
          $("#spfxckwh-table").showCol(self.tableOption[i].name);
        } else {
          $("#spfxckwh-table").hideCol(self.tableOption[i].name);
        }
      }
      $("#spfxckwh-table").setGridWidth($(".spfxckwh").width());
    },
    normalSearch() {
      this.searchData.orderSql = "";
      $(".s-ico").hide();
      this.search(1);
    },
    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize = $(".ui-pg-selbox", $(".spfxckwh")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      params.fwlx = self.searchData.fwlx;
      let url;
      if (self.activeIndex == "0") {
        url = "/cxfw/fxgl/fxsplist";
      } else if (self.activeIndex == "1") {
        url = "/cxfw/fxgl/fxsplist4Other";
      }
      self.url = url;
      $("#spfxckwh-table").jqGrid("clearGridData");
      ajax("POST", url, params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data;
            $("#spfxckwh-table").resetSelection();
            $("#spfxckwh-table")[0].addJSONData(res.data);
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
      $(".spfxckwh .select-sub").toggle();
      $(".spfxckwh .select-wrapper .icon").toggleClass("active");
      if (
        $(".spfxckwh .select-wrapper .icon").attr("title").slice(0, 2) ===
        "展开"
      ) {
        $(".spfxckwh .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".spfxckwh .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".spfxckwh .select-sub").hide();
      $(".spfxckwh .select-wrapper .icon").removeClass("active");
      $(".spfxckwh .select-wrapper .icon").attr("title", "展开查询条件");
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
      $(".spfxckwh").on("click", function (e) {
        var e = e || window.event;
        if ($(".dropdown-menu").find($(e.target)).length <= 0) {
          self.hideMenu();
        }
      });
    },
    hideMenu: function () {
      $(".dropdown-menu").hide();
      $(".spfxckwh").off("click");
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
          $.fn.zTree.init($(".spfxckwh .treeDiv"), setting, data);
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".spfxckwh").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".spfxckwh").off("click");
    },
    exform: function () {
      var self = this;
      if ($("#spfxckwh-table").jqGrid("getRowData").length <= 0) {
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
      form.attr("action", "/cxfw/fxgl/fxsplist/export");
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
        // swjgdm: avalonRoot.user.swjgDm,
        fxly: "",
        gzmc: "",
        spdm: "",
        spmc: "",
        orderSql: "",
        pageSize: config.pageSize,
      };
      this.tsjgmc = avalonRoot.user.swjgMc;
    },
    showModel: function (title) {
      this.addTitle = title;
      if (title == "新增") {
        this.modelData = {
          id: "",
          gzFwData: "",
          gzMc: "",
          gzFxms: "",
          gzSpdm: "",
          gzSpmc: "",
          gzGgxh: "",
          gzCkka: "",
          gzCkgb: "",
          gzHyd: "",
          gzDjq: "",
          gzDjz: "",
          gzYxqz: "",
          gzDxtxbz: "N",
          qybj: "Y",
          gzZjq: "",
          gzZjz: "",
        };
      }
      $(".model").show();
      $(".spfxckwh .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".spfxckwh .add-page-model").hide();
    },
    saveModel: function () {
      var self = this;
      if (
        !/^\d+(\.\d{1,2})?$/.test(this.modelData.gzDjq) &&
        this.modelData.gzDjq
      ) {
        tools.info("请输入正确的单价范围起");
        return;
      }
      if (
        !/^\d+(\.\d{1,2})?$/.test(this.modelData.gzDjz) &&
        this.modelData.gzDjz
      ) {
        tools.info("请输入正确的单价范围止");
        return;
      }
      if (
        !/^\d+(\.\d{1,2})?$/.test(this.modelData.gzZjq) &&
        this.modelData.gzZjq
      ) {
        tools.info("请输入正确的总价范围起");
        return;
      }
      if (
        !/^\d+(\.\d{1,2})?$/.test(this.modelData.gzZjz) &&
        this.modelData.gzZjz
      ) {
        tools.info("请输入正确的总价范围止");
        return;
      }
      var valid = this.checkValid(this.modelData);
      if (!valid) return;
      api.updateFxsp(this.modelData).done(function (res) {
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
        { name: "gzFwData", message: "请选择适用业务范围！" },
        { name: "gzMc", message: "规则名称不能为空！" },
        { name: "gzSpdm", message: "商品代码不能为空！" },
        { name: "qybj", message: "请选择启用标记！" },
      ];
      for (var i = 0; i < rules.length; i++) {
        if (modelData[rules[i].name] == "") {
          tools.info(rules[i].message);
          return false;
        }
      }
      return true;
    },
  },
});
