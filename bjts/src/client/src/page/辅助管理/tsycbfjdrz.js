var tsycbfjdrz = require("./tsycbfjdrz.html");
avalon.component("tsycbfjdrz", {
  template: tsycbfjdrz,
  defaults: {
    params: {},
    act: 1,
    swjgmc: "",
    searchData: {
      nsrbs: "",
      swjgDm: "",
      cldz: "",
      tjnd: "",
      tjyf: "",
      tsjsfs: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    tjndList: [],
    tableData: {
      sumData: {},
    },
    onReady: function () {
      var self = this;
      try {
        this.searchData.swjgDm = avalonRoot.user.swjgDm;
        this.swjgmc = avalonRoot.user.swjgMc;
        this.searchData.tjnd = new Date().getFullYear();
        this.searchData.tjyf = new Date().getMonth() + 1;
        if (this.searchData.tjyf < 10) {
          this.searchData.tjyf = "0" + this.searchData.tjyf;
        }
        this.tjndList = [];
        for (var i = 0; i < 5; i++) {
          this.tjndList.push(this.searchData.tjnd + 1 - i);
        }
      } catch (e) {}
      //   this.initDate();
      this.initTree();
      this.createTable();
    },
    changeTab: function (num) {
      this.act = num;
    },
    initDate: function () {
      var options = {
        language: "zh-CN",
        format: "yyyy-mm-dd",
        autoclose: true,
        clearBtn: true,
        startView: 2,
        minView: 2,
      };
      $(".tsycbfjdrz .datepicker.date-day").datetimepicker(options);
    },
    //copy bg
    createTable: function () {
      var self = this;
      var columns = [
        // {
        //   name: "id",
        //   label: "主键id",
        //   index: "主键id",
        //   hidden: true,
        //   align: "left",
        //   sortable: true,
        // },
        // {
        //   name: "swjgDm",
        //   label: "税务机关代码",
        //   index: "swjgDm",
        //   width: 150,
        //   align: "center",
        //   sortable: true,
        // },
        {
          name: "swjgMc",
          label: "税务机关名称",
          index: "swjgMc",
          width: 180,
          align: "left",
          sortable: true,
        },
        {
          name: "nsrsbh",
          label: "纳税人识别号",
          index: "nsrsbh",
          width: 150,
          align: "center",
          sortable: true,
        },
        {
          name: "nsrmc",
          label: "纳税人名称",
          index: "nsrmc",
          width: 200,
          align: "center",
          sortable: true,
        },
        {
          name: "tsjsfs",
          label: "退税计算方式",
          index: "tsjsfs",
          width: 100,
          align: "center",
          sortable: true,
        },
        {
          name: "yctse",
          label: "预测退税额",
          index: "yctse",
          width: 100,
          align: "right",
          sortable: true,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "tjny",
          label: "统计年月",
          index: "tjny",
          width: 100,
          align: "center",
          sortable: true,
        },
        {
          name: "sbnypc",
          label: "申报所属期批次",
          index: "sbnypc",
          width: 100,
          align: "center",
          sortable: true,
        },
        {
          name: "sbtse",
          label: "申报退税额",
          index: "sbtse",
          width: 100,
          align: "right",
          sortable: true,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "cldz",
          label: "处理动作",
          index: "cldz",
          width: 100,
          align: "center",
          sortable: true,
        },
        {
          name: "yysm",
          label: "原因说明",
          index: "yysm",
          width: 100,
          align: "center",
          sortable: true,
        },
        {
          name: "crtime",
          label: "创建时间",
          index: "crtime",
          width: 200,
          align: "center",
          sortable: true,
        },
      ];
      $("#tsycbfjdrz-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: "#tsycbfjdrz-tablePager",
        shrinkToFit: false,
        autowidth: true,
        altRows: true,
        // multiselect: true,
        // multiselectWidth:"30",
        // footerrow: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        width: "100%",
        height: (function () {
          return $(".tsycbfjdrz .form").height() - 60 - 30;
        })(),
        beforeSelectRow: function (rowid, e) {
          if ($(e.target).hasClass("edit")) {
            $.dialog({
              title: "录入处理",
              content:
                '<div style="margin-bottom: 20px;">处理标志：<select type="text" id="deal-sign" style="    width: 155px;">' +
                '<option value="" selected></option>' +
                '<option value="1">以征管为准</option>' +
                '<option value="2">以出口为准</option>' +
                '<option value="3">无效</option>' +
                "</select></div>" +
                '<div><span style="position: relative; top: -90px; left: 0;">处理意见：</span><textarea id="deal-suggest" style="height: 100px;"></textarea></div>',
              lock: true,
              button: [
                {
                  value: "确认",
                  callback: function () {
                    var dealSign = $("#deal-sign").val();
                    var dealSuggest = $("#deal-suggest").val();
                    if (!dealSign) {
                      tools.info("处理标志不能为空，请选择处理标志。");
                      return;
                    }
                    var params = {
                      id: rowid,
                      clbz: dealSign,
                    };
                    !!dealSuggest ? (params["clyj"] = dealSuggest) : null;
                    ajax("POST", "/glfw/cktsfndz/clbz", params)
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
                  },
                },
                {
                  value: "取消",
                },
              ],
            });
          }
          if (e.target.nodeName == "TD") {
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
        // gridComplete: function () {
        //   var sumData = self.tableData.sumData;
        //   console.log(self.tableData);
        //   sumData["nsrsbh"] = "合计";
        //   $("#tsycbfjdrz-table").footerData("set", sumData);
        // },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "tsycbfjdrz-table");
          self.search(pageNo);
        },
      });
      // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
      // self.search(1);
    },
    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize =
        $(".ui-pg-selbox", $(".tsycbfjdrz")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      params.tjny = this.searchData.tjnd.toString() + this.searchData.tjyf;
      $("#tsycbfjdrz-table").jqGrid("clearGridData");
      api
        .getTseycQuery(params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data.rows;
            $("#tsycbfjdrz-table").resetSelection();
            $("#tsycbfjdrz-table")[0].addJSONData(res.data);
            self.closeHyper();
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    initTree: function () {
      var self = this;
      var setting1 = {
        callback: {
          onClick: function (e, id, node) {
            self.searchData.swjgDm = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            return;
          },
          onDblClick: function (e, id, node) {
            self.searchData.swjgDm = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            return;
          },
        },
        data: { key: { children: "item", name: "text" } },
      };
      tools
        .getCachedSwjg(avalonRoot, ajax)
        .done(function (data) {
          $.fn.zTree.init($(".tsycbfjdrz .treeDiv"), setting1, data);
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showHyper: function () {
      $(".tsycbfjdrz .select-sub").toggle();
      $(".tsycbfjdrz .select-wrapper .icon").toggleClass("active");
      if (
        $(".tsycbfjdrz .select-wrapper .icon").attr("title").slice(0, 2) ===
        "展开"
      ) {
        $(".tsycbfjdrz .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".tsycbfjdrz .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".tsycbfjdrz .select-sub").hide();
      $(".tsycbfjdrz .select-wrapper .icon").removeClass("active");
      $(".tsycbfjdrz .select-wrapper .icon").attr("title", "展开查询条件");
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".tsycbfjdrz").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".tsycbfjdrz").off("click");
    },
    check: function () {
      ajax("POST", "/glfw/cktsfndz/dz", {})
        .done(function (res) {
          if (res.code == "0") {
            tools.info("对账成功");
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    exform: function () {
      var self = this;
      if ($("#tsycbfjdrz-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData);
      params.pageNo = 1;
      params.tjny = this.searchData.tjnd.toString() + this.searchData.tjyf;
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/glfw/export/tseyc/log");
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
        swjgDm: avalonRoot.user.swjgDm,
        nsrbs: "",
        cldz: "",
        tjnd: "",
        tjyf: "",
        tsjsfs: "",
        orderSql: "",
        pageSize: config.pageSize,
      };
      this.swjgmc = avalonRoot.user.swjgMc;
    },
  },
});
