var ckqyjclasjtjMx = require("./ckqyjclasjtjMx.html");
avalon.component("ckqyjclasjtjMx", {
  template: ckqyjclasjtjMx,
  defaults: {
    params: {},
    act: 1,
    // tcode: "scqysbxxcx",
    tcode: "jclatjMx",
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
      startDate: "",
      endDate: "",
      orderSql: "",
      selectType: "0",
      nsrmc:'',
      nsrsbh:'',
      sswflx:'',
      pageSize: config.pageSize,
    },
    modelData: {
      id: "",
      ssny: "",
      shxyno: "",
      nsrmc: "",
      fxrwlyDm: "",
      rwfxqjMycke: "",
      rwfxqjSbmycke: "",
      rwfxqjBltse: "",
      fxydcsJh: "",
      byts: "",
      yzhts: "",
      stnxzs: "",
      zhts: "",
      jxsezc: "",
      ybjzzs: "",
      ybjsds: "",
      ybjqtsz: "",
      bz: "",
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
    tableRowList:[],
    onReady: function () {
      var self = this;
        var promise = this.getTableRow();
      if (self.params.swjgDm) {
        self.searchData.swjgdm = self.params.swjgDm
        self.searchData.startDate = self.params.startDate
        self.searchData.endDate = self.params.endDate
        self.searchData.selectType = self.params.selectType
      }else{
        self.tsjgmc = avalonRoot.user.swjgMc;
        self.searchData.swjgdm = avalonRoot.user.swjgDm;
        self.searchData.startDate = tools.getFirstMounth()
        self.searchData.endDate = tools.getTodayYM()
      }
      self.initTree();
      promise.then(()=>{
        self.normalSearch();
      })
      $(".ckqyjclasjtjMx .datepicker.date-day").datepicker({
        dateFormat: "yy-mm-dd",
      });
      $(".ckqyjclasjtjMx .datepicker.date-month").datepicker({
        dateFormat: "yymm",
      });
    },
    changeTab: function (num) {
      this.act = num;
    },
    //copy bg
    getTableRow: function () {
      return new Promise(resolve=>{
        var self = this;
        ajax("POST", "/cxfw/basis/columprofile", { tcode: self.tcode })
          .done(function (res) {
            if (res.code == "0") {
              var arr = res.data.profiles;
              self.tableRowList = arr
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
              resolve()
            } else {
              tools.info(res.msg);
            }
          })
          .fail(function (err) {
            tools.info(err);
          });
      })
    },
    createTable: function (arr) {
      var btnName = this.hasHsPermission ? "编辑" : "查看";
      var self = this;
      var cm = [];
      for (var i = 0; i < arr.length; i++) {
        cm[i] = tools.clone(arr[i]);
      }
      $("#ckqyjclasjtjMx-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: cm,
        viewrecords: true,
        rownumbers: true,
        pager: "#ckqyjclasjtjMx-tablePager",
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
          return $(".ckqyjclasjtjMx .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#ckqyjclasjtjMx-table").jqGrid("getRowData", rowid);
          var obj = self.tableData.rows[rowid - 1];
          if ($(e.target).hasClass("edit")) {
            for (var key in self.modelData) {
              self.modelData[key] = row[key];
            }
            self.modelData.id = rowid;
            self.showModel(btnName);
            return false;
          } else if ($(e.target).hasClass("del")) {
            tools.confirm("是否确定删除该条数据？", "确定", function () {
              var params = {
                id: rowid,
              };
              ajax("POST", "/cxfw/fxgl/fxyd/del", params)
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
          let name = ''
          if(self.tableRowList[iCol-1].f1){
            name = self.tableRowList[iCol-1].f1
          }else{
            name = index
          }
          self.searchData.orderSql = name + " " + sortorder;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "ckqyjclasjtjMx-table");
          self.search(pageNo);
        },
        gridComplete: function () {
          try {
            setTimeout(() => {
              var sumData = self.tableData.sumData?self.tableData.sumData:{}
              sumData["tsswjgdm"] = "合计";
              $("#ckqyjclasjtjMx-table").footerData("set", sumData);
            }, 200);
          } catch (error) {
            console.log(error);
          }
        },
      });
      this.searchData.pageSize = $(".ui-pg-selbox", $(".ckqyjclasjtjMx")).val();
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
          $("#ckqyjclasjtjMx-table").showCol(self.tableOption[i].name);
        } else {
          $("#ckqyjclasjtjMx-table").hideCol(self.tableOption[i].name);
        }
      }
      $("#ckqyjclasjtjMx-table").setGridWidth($(".ckqyjclasjtjMx").width());
    },
    normalSearch() {
      this.searchData.orderSql = "";
      $(".s-ico").hide();
      this.search(1);
    },
    search: function (pageNo) {
      var self = this;
      var dataValid = [{ start: "startDate", end: "endDate", msg: "查询时间" }];
      for (var i = 0; i < dataValid.length; i++) {
        var item = dataValid[i];
        var validItem = tools.checkDate(
          this.searchData[item.start],
          this.searchData[item.end]
        );
        if (!validItem) {
          tools.info(item.msg + "截止时间必须大于起始时间");
          return false;
        }
      }
      this.searchData.pageSize =
        $(".ui-pg-selbox", $(".ckqyjclasjtjMx")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      $("#ckqyjclasjtjMx-table").jqGrid("clearGridData");
      ajax("POST", "/cxfw/fxgl/jclatj/mx", params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data;
            $("#ckqyjclasjtjMx-table").resetSelection();
            $("#ckqyjclasjtjMx-table")[0].addJSONData(res.data);
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
      $(".ckqyjclasjtjMx .select-sub").toggle();
      $(".ckqyjclasjtjMx .select-wrapper .icon").toggleClass("active");
      if (
        $(".ckqyjclasjtjMx .select-wrapper .icon").attr("title").slice(0, 2) ===
        "展开"
      ) {
        $(".ckqyjclasjtjMx .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".ckqyjclasjtjMx .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".ckqyjclasjtjMx .select-sub").hide();
      $(".ckqyjclasjtjMx .select-wrapper .icon").removeClass("active");
      $(".ckqyjclasjtjMx .select-wrapper .icon").attr("title", "展开查询条件");
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
      $(".ckqyjclasjtjMx").on("click", function (e) {
        var e = e || window.event;
        if ($(".dropdown-menu").find($(e.target)).length <= 0) {
          self.hideMenu();
        }
      });
    },
    hideMenu: function () {
      $(".dropdown-menu").hide();
      $(".ckqyjclasjtjMx").off("click");
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
          $.fn.zTree.init($(".ckqyjclasjtjMx .treeDiv"), setting, data);
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".ckqyjclasjtjMx").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".ckqyjclasjtjMx").off("click");
    },
    exform: function () {
      var self = this;
      if ($("#ckqyjclasjtjMx-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData);
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/cxfw/fxgl/jclatj/mx/export");
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
        startDate: "",
        endDate: "",
        selectType: "",
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
          ssny: "",
          shxyno: "",
          nsrmc: "",
          fxrwlyDm: "",
          rwfxqjMycke: "",
          rwfxqjSbmycke: "",
          rwfxqjBltse: "",
          fxydcsJh: "",
          byts: "",
          yzhts: "",
          stnxzs: "",
          zhts: "",
          jxsezc: "",
          ybjzzs: "",
          ybjsds: "",
          ybjqtsz: "",
          bz: "",
        };
      }
      $(".model").show();
      $(".ckqyjclasjtjMx .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".ckqyjclasjtjMx .add-page-model").hide();
    },
    saveModel: function () {
      var self = this;
      var valid = this.checkValid(this.modelData);
      if (!valid) return;
      api.updateFxyd(this.modelData).done(function (res) {
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
        { name: "ssny", message: "所属年月不能为空！" },
        { name: "fxrwlyDm", message: "请选择风险来源！" },
        { name: "shxyno", message: "统一社会信用代码不能为空！" },
        { name: "nsrmc", message: "企业名称不能为空！" },
        {
          name: "rwfxqjMycke",
          message: "下发任务分析期间涉及出口额（万美元）不能为空！",
        },
        {
          name: "rwfxqjSbmycke",
          message: "下发任务分析期间涉及申报退税出口额（万美元）不能为空！",
        },
        {
          name: "rwfxqjBltse",
          message: "任务分析期间内办理退税额（万元）不能为空！",
        },
        { name: "fxydcsJh", message: "请选择风险应对措施！" },
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
