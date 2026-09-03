var jjyqtsshtxsz = require("./jjyqtsshtxsz.html");
avalon.component("jjyqtsshtxsz", {
  template: jjyqtsshtxsz,
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
      swjgdm: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    czrymc:'',
    modelData: {
      tsswjgDm1: "",
      tsswjgMc: "",
      jjyqA: "",
      jjyqB: "",
      jjyqC: "",
      jjyqD: "",
      whry: "",
      whsj: "",
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
    onReady: function () {
      var self = this;
      try {
        this.hasHsPermission =
          this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
        this.searchData.swjgdm = avalonRoot.user.swjgDm;
        this.tsjgmc = avalonRoot.user.swjgMc;
        this.czrymc = avalonRoot.user.czrymc;
      } catch (e) {}
      this.createTable();
      self.initTree();
      self.normalSearch()
      $(".jjyqtsshtxsz .datepicker.date-day").datepicker({
        dateFormat: "yy-mm-dd",
      });
      $(".jjyqtsshtxsz .datepicker.date-month").datepicker({
        dateFormat: "yymm",
      });
    },
    changeTab: function (num) {
      this.act = num;
    },
    //copy bg
    getTableRow: function () {
      var self = this;
      ajax("POST", "/cxfw/basis/columprofile", { tcode: self.tcode })
        .done(function (res) {
          if (res.code == "0") {
            var arr = res.data.profiles;
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
        var btnName = this.hasHsPermission ? "编辑" : "查看";
      var self = this;
      var wwcColumns = [
        { name: "tsswjgDm1", label: "税务机关代码", index: "tsswjgDm1" },
        { name: "tsswjgMc", label: "税务机关名称", index: "tsswjgMc" },
        { name: "jjyqA", label: "一类企业流程提醒设置", index: "jjyqA" },
        { name: "jjyqB", label: "二类企业流程提醒设置", index: "jjyqB" },
        { name: "jjyqC", label: "三类企业流程提醒设置", index: "jjyqC" },
        { name: "jjyqD", label: "四类企业流程提醒设置", index: "jjyqD" },
        { name: "whry", label: "维护人员", index: "whry" },
        { name: "whsj", label: "维护时间", index: "whsj" },
        {
          name: "op",
          label: "操作",
          index: "op",
          width: 116,
          formatter: function (cellvalue, options, rowObject) {
            return (
              "<div class='btn edit' style='float: none;display: inline-block;' title='" +
              btnName +
              "'>" +
              btnName
            );
          },
        },
      ];
      $("#jjyqtsshtxsz-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: wwcColumns,
        viewrecords: true,
        rownumbers: true,
        pager: "#jjyqtsshtxsz-tablePager",
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
          return $(".jjyqtsshtxsz .form").height() - 118;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#jjyqtsshtxsz-table").jqGrid("getRowData", rowid);
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
            self.showModel(btnName);
            return false;
          } 
          else if (e.target.nodeName == "TD") {
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
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "jjyqtsshtxsz-table");
          self.search(pageNo);
        },
      });
      this.searchData.pageSize = $(".ui-pg-selbox", $(".jjyqtsshtxsz")).val();
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
          $("#jjyqtsshtxsz-table").showCol(self.tableOption[i].name);
        } else {
          $("#jjyqtsshtxsz-table").hideCol(self.tableOption[i].name);
        }
      }
      $("#jjyqtsshtxsz-table").setGridWidth($(".jjyqtsshtxsz").width());
    },
    normalSearch() {
      this.searchData.orderSql = "";
      $(".s-ico").hide();
      this.search(1);
    },
    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize =
        $(".ui-pg-selbox", $(".jjyqtsshtxsz")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      $("#jjyqtsshtxsz-table").jqGrid("clearGridData");
      ajax("POST", "/cxfw/fxgl/jjyq/list", params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data;
            $("#jjyqtsshtxsz-table").resetSelection();
            $("#jjyqtsshtxsz-table")[0].addJSONData(res.data);
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
      $(".jjyqtsshtxsz .select-sub").toggle();
      $(".jjyqtsshtxsz .select-wrapper .icon").toggleClass("active");
      if (
        $(".jjyqtsshtxsz .select-wrapper .icon").attr("title").slice(0, 2) ===
        "展开"
      ) {
        $(".jjyqtsshtxsz .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".jjyqtsshtxsz .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".jjyqtsshtxsz .select-sub").hide();
      $(".jjyqtsshtxsz .select-wrapper .icon").removeClass("active");
      $(".jjyqtsshtxsz .select-wrapper .icon").attr("title", "展开查询条件");
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
      $(".jjyqtsshtxsz").on("click", function (e) {
        var e = e || window.event;
        if ($(".dropdown-menu").find($(e.target)).length <= 0) {
          self.hideMenu();
        }
      });
    },
    hideMenu: function () {
      $(".dropdown-menu").hide();
      $(".jjyqtsshtxsz").off("click");
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
          $.fn.zTree.init($(".jjyqtsshtxsz .treeDiv"), setting, data);
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".jjyqtsshtxsz").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".jjyqtsshtxsz").off("click");
    },
    exform: function () {
      var self = this;
      if ($("#jjyqtsshtxsz-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData);
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/cxfw/fxgl/jjyq/list/export");
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
        swjgdm: avalonRoot.user.swjgDm,
        orderSql: "",
        pageSize: config.pageSize,
      };
      this.tsjgmc = avalonRoot.user.swjgMc;
    },
    showModel: function (title) {
      this.addTitle = title;
      if (title == "新增") {
        this.modelData = {
            tsswjgDm1: "",
            tsswjgMc: "",
            jjyqA: "",
            jjyqB: "",
            jjyqC: "",
            jjyqD: "",
            whry: this.czrymc,
            whsj: "",
          };
      }else if(title == "编辑"){
        this.modelData.whry = this.czrymc
      }
      $(".model").show();
      $(".jjyqtsshtxsz .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".jjyqtsshtxsz .add-page-model").hide();
    },
    saveModel: function () {
      var self = this;
      var valid = this.checkValid(this.modelData);
      if (!valid) return;
      let params = tools.clone(this.modelData)
      params.whsj = ''
      api.updateJjyqtssh(params).done(function (res) {
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
        { name: "jjyqA", message: "A类企业流程提醒设置不能为空！" },
        { name: "jjyqB", message: "B类企业流程提醒设置不能为空！" },
        { name: "jjyqC", message: "C类企业流程提醒设置不能为空！" },
        { name: "jjyqD", message: "D类企业流程提醒设置不能为空！" },
        { name: "whsj", message: "维护时间不能为空！" },

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
