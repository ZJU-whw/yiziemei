var zxrcjdydtj = require("./zxrcjdydtj.html");
avalon.component("zxrcjdydtj", {
  template: zxrcjdydtj,
  defaults: {
    params: {},
    act: 1,
    tcode: "zxrcjdydtj",
    searchData: {
      swjgdm: "",
      smrqQ: "",
      smrqZ: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    tsjgmc:'',
    modelData: {
      // nkzbbh: "",
      nkzblb: "",
      nkzbmc: "",
      nkfxdj: "",
      // nkywly: "",
      nkywms: "",
      nksjly: "",
      nkkjms: "",
      sqtxlx: "",
      szyjlx: "",
      shjdlx: "",
      kstxgzr: "",
      ksjdgzr: "",
    },
    addTitle: "查看",
    hyList: [],
    pageNumber:1,
    isAdmin: false,
    onReady: function () {
      var self = this
      try {
        // this.hasHsPermission =
        //   this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
        this.searchData.swjgdm = avalonRoot.user.swjgDm;
        this.tsjgmc = avalonRoot.user.swjgMc;
        // self.searchData.startDate = tools.getFirstMounth()
        // self.searchData.endDate = tools.getTodayYM()
      } catch (e) {}
      if(self.params.swjgdm){
        self.searchData.smrqQ = self.params.startDate
        self.searchData.smrqZ = self.params.endDate
        self.searchData.swjgdm = self.params.swjgdm
        self.tsjgmc = self.params.swjgMc
      }
      this.isAdmin = ["super", "admin"].indexOf(avalonRoot.user.roleDm) > -1;
      this.createTable();
      self.initTree();
      self.search(1);
      $(".zxrcjdydtj .datepicker.date-day").datepicker({
        dateFormat: "yy-mm-dd",
      });
      $(".zxrcjdydtj .datepicker.date-month").datepicker({
        dateFormat: "yymm",
      });
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
    //copy bg
    createTable: function () {
      var self = this;
      var columns = [
        // {
        //   name: "op2",
        //   label: "操作",
        //   width: 0,
        //   frozen: true,
        //   align: "center",
        //   resizable: false,
        //   sortable: false,
        //   formatter: function (cellvalue, options, rowObject) {
        //     return "<div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn del' style='float: none;display: inline-block;' title='删除'>删除</div>";
        //   },
        // },
        {
          name: "swjgdm",
          label: "税务机关代码",
          index: "swjgdm",
          align: "left",
          sortable: false,
          hidden:true
        },
        {
          name: "unit",
          label: "单位名称",
          index: "unit",
          align: "left",
          sortable: false,
          hidden:false,
          width:250,
        },
        { name: "zb1", label: "新办类出口企业异常增长", index: "zb1", hidden: false,
          formatter: function (cellvalue, options, rowObject) {
            return (
              "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='zb1'>" +
              cellvalue +
              "</span>"
            );
          },
         },
        // { name: "zb2", label: "供货企业异常", index: "zb2", hidden: false,
        //   formatter: function (cellvalue, options, rowObject) {
        //     return (
        //       "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='zb2'>" +
        //       cellvalue +
        //       "</span>"
        //     );
        //   },
        //  },
         { name: "zb21", label: "货物出口日期早于供货企业成立日期", index: "zb21", hidden: false,
          formatter: function (cellvalue, options, rowObject) {
            return (
              "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='zb21'>" +
              cellvalue +
              "</span>"
            );
          },
         },
         { name: "zb22", label: "已申报退税但发票状态非正常", index: "zb22", hidden: false,
          formatter: function (cellvalue, options, rowObject) {
            return (
              "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='zb22'>" +
              cellvalue +
              "</span>"
            );
          },
         },
         { name: "zb23", label: "供货企业存在复函异常情形", index: "zb23", hidden: false,
          formatter: function (cellvalue, options, rowObject) {
            return (
              "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='zb23'>" +
              cellvalue +
              "</span>"
            );
          },
         },
         { name: "zb24", label: "连续3个月内供货企业数量变动异常", index: "zb24", hidden: false,
          formatter: function (cellvalue, options, rowObject) {
            return (
              "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='zb24'>" +
              cellvalue +
              "</span>"
            );
          },
         },
        { name: "zb3", label: "农产品等出口异常增长", index: "zb3", hidden: false,
          formatter: function (cellvalue, options, rowObject) {
            return (
              "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='zb3'>" +
              cellvalue +
              "</span>"
            );
          },
         },
        { name: "zb4", label: "电子类产品出口异常增长", index: "zb4", hidden: false,
          formatter: function (cellvalue, options, rowObject) {
            return (
              "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='zb4'>" +
              cellvalue +
              "</span>"
            );
          },
         },
        { name: "zb5", label: "外贸企业出口增长异常", index: "zb5", hidden: false,
          formatter: function (cellvalue, options, rowObject) {
            return (
              "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='zb5'>" +
              cellvalue +
              "</span>"
            );
          },
         },
        { name: "zb6", label: "生产企业生产能力异常", index: "zb6", hidden: false,
          formatter: function (cellvalue, options, rowObject) {
            return (
              "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='zb6'>" +
              cellvalue +
              "</span>"
            );
          },
         },
        // {
        //   name: "op",
        //   label: "操作",
        //   width: 160,
        //   align: "center",
        //   resizable: false,
        //   search: false,
        //   sortable: false,
        //   formatter: function (cellvalue, options, rowObject) {
        //     return "<div class='btn edit' style='float: none;display: inline-block;' title='查看'>查看</div>";
        //   },
        // },
      ];
      $("#zxrcjdydtj-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: "#zxrcjdydtj-tablePager",
        shrinkToFit: false,
        autowidth: true,
        altRows: true,
        // multiselect: true,
        // multiselectWidth:"30",
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        width: "100%",
        height: (function () {
          return $(".zxrcjdydtj .form").height() - 60;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#zxrcjdydtj-table").jqGrid("getRowData", rowid);
          if ($(e.target).hasClass("edit")) {
            for (var key in self.modelData) {
              self.modelData[key] = row[key];
            }
            self.showModel("2");
            return false;
          }else if ($(e.target).hasClass("zb1")) {
            avalonRoot.addTab({
              title: "专项日常监管疑点核实",
              component: "zxrcjdydhs",
              sameCheck: true,
              params: {
                swjgDm: row.swjgdm,
                swjgMc: row.unit,
                startDate:self.searchData.smrqQ,
                endDate:self.searchData.smrqZ,
                zbid:'C01001'
              },
            });
            return false;
          }else if ($(e.target).hasClass("zb21")) {
            avalonRoot.addTab({
              title: "专项日常监管疑点核实",
              component: "zxrcjdydhs",
              sameCheck: true,
              params: {
                swjgDm: row.swjgdm,
                swjgMc: row.unit,
                startDate:self.searchData.smrqQ,
                endDate:self.searchData.smrqZ,
                zbid:'C02001'
              },
            });
            return false;
          }else if ($(e.target).hasClass("zb22")) {
            avalonRoot.addTab({
              title: "专项日常监管疑点核实",
              component: "zxrcjdydhs",
              sameCheck: true,
              params: {
                swjgDm: row.swjgdm,
                swjgMc: row.unit,
                startDate:self.searchData.smrqQ,
                endDate:self.searchData.smrqZ,
                zbid:'C02002'
              },
            });
            return false;
          }else if ($(e.target).hasClass("zb23")) {
            avalonRoot.addTab({
              title: "专项日常监管疑点核实",
              component: "zxrcjdydhs",
              sameCheck: true,
              params: {
                swjgDm: row.swjgdm,
                swjgMc: row.unit,
                startDate:self.searchData.smrqQ,
                endDate:self.searchData.smrqZ,
                zbid:'C02003'
              },
            });
            return false;
          }else if ($(e.target).hasClass("zb24")) {
            avalonRoot.addTab({
              title: "专项日常监管疑点核实",
              component: "zxrcjdydhs",
              sameCheck: true,
              params: {
                swjgDm: row.swjgdm,
                swjgMc: row.unit,
                startDate:self.searchData.smrqQ,
                endDate:self.searchData.smrqZ,
                zbid:'C02004'
              },
            });
            return false;
          }else if ($(e.target).hasClass("zb3")) {
            avalonRoot.addTab({
              title: "专项日常监管疑点核实",
              component: "zxrcjdydhs",
              sameCheck: true,
              params: {
                swjgDm: row.swjgdm,
                swjgMc: row.unit,
                startDate:self.searchData.smrqQ,
                endDate:self.searchData.smrqZ,
                zbid:'C03001'
              },
            });
            return false;
          }else if ($(e.target).hasClass("zb4")) {
            avalonRoot.addTab({
              title: "专项日常监管疑点核实",
              component: "zxrcjdydhs",
              sameCheck: true,
              params: {
                swjgDm: row.swjgdm,
                swjgMc: row.unit,
                startDate:self.searchData.smrqQ,
                endDate:self.searchData.smrqZ,
                zbid:'C04001'
              },
            });
            return false;
          }else if ($(e.target).hasClass("zb5")) {
            avalonRoot.addTab({
              title: "专项日常监管疑点核实",
              component: "zxrcjdydhs",
              sameCheck: true,
              params: {
                swjgDm: row.swjgdm,
                swjgMc: row.unit,
                startDate:self.searchData.smrqQ,
                endDate:self.searchData.smrqZ,
                zbid:'C05001'
              },
            });
            return false;
          }else if ($(e.target).hasClass("zb6")) {
            avalonRoot.addTab({
              title: "专项日常监管疑点核实",
              component: "zxrcjdydhs",
              sameCheck: true,
              params: {
                swjgDm: row.swjgdm,
                swjgMc: row.unit,
                startDate:self.searchData.smrqQ,
                endDate:self.searchData.smrqZ,
                zbid:'C06001'
              },
            });
            return false;
          } else if ($(e.target).hasClass("del")) {
            tools.confirm("是否确定删除该条数据？", "确定", function () {
              var params = {
                zbId: row.zbId,
              };
              ajax("POST", "/sszj/zbgl/zb/del", params)
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
          self.searchData.orderSql = index + " " + sortorder;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "zxrcjdydtj-table");
          this.pageNumber = pageNo
          self.search(pageNo);
        },
      });

      $("#zxrcjdydtj-table").jqGrid("setFrozenColumns");
      if (this.isAdmin) {
        tools.HeiKjNoSel("zxrcjdydtj", "zxrcjdydtj-table");
      }
      // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
      // self.search(1);
    },
    showModel: function (operation) {
      $(".model").show();
      $(".zxrcjdydtj .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".zxrcjdydtj .add-page-model").hide();
      this.modelData = {
        // nkzbbh: "",
        nkzblb: "",
        nkzbmc: "",
        nkfxdj: "",
        // nkywly: "",
        nkywms: "",
        nksjly: "",
        nkkjms: "",
        sqtxlx: "",
        szyjlx: "",
        shjdlx: "",
        kstxgzr: "",
        ksjdgzr: "",
      };
    },
    showHyper: function () {
      $(".zxrcjdydtj .select-sub").toggle();
      $(".zxrcjdydtj .select-wrapper .icon").toggleClass("active");
      if (
        $(".zxrcjdydtj .select-wrapper .icon").attr("title").slice(0, 2) === "展开"
      ) {
        $(".zxrcjdydtj .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".zxrcjdydtj .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".zxrcjdydtj .select-sub").hide();
      $(".zxrcjdydtj .select-wrapper .icon").removeClass("active");
      $(".zxrcjdydtj .select-wrapper .icon").attr("title", "展开查询条件");
    },
    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize = $(".ui-pg-selbox", $(".zxrcjdydtj")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      $("#zxrcjdydtj-table").jqGrid("clearGridData");
      api
        .getTjcxConfig(params)
        .done(function (res) {
          if (res.code == "0") {
            $("#zxrcjdydtj-table").resetSelection();
            $("#zxrcjdydtj-table")[0].addJSONData(res.data);
            if (self.isAdmin) {
              tools.HeiKjNoSel("zxrcjdydtj", "zxrcjdydtj-table");
            }
            self.closeHyper();
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
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
          $.fn.zTree.init($(".zxrcjdydtj .treeDiv"), setting, data);
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".zxrcjdydtj").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".zxrcjdydtj").off("click");
    },
    exform: function () {
      var self = this;
      if ($("#zxrcjdydtj-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData);
      params.pageNo = this.pageNumber
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/nkgl/zb/config/export");
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
        smrqQ: "",
        smrqZ: "",
        orderSql: "",
        pageSize: config.pageSize,
      };
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".zxrcjdydtj").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".zxrcjdydtj").off("click");
    },
    numberLimit: function () {
      this.modelData.jsYxj = this.modelData.jsYxj.replace(/\D/g, "");
    },
  },
});
