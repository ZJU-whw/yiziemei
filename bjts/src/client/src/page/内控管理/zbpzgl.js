var zbpz = require("./zbpzgl.html");
avalon.component("zbpzgl", {
  template: zbpz,
  defaults: {
    params: {},
    act: 1,
    tcode: "zbpz",
    searchData: {
      // nkzbbh: "",
      nkzblb: "",
      nkzbmc: "",
      nkfxdj: "",
      // nkywly: "",
      sqtxlx: "",
      szyjlx: "",
      shjdlx: "",
      pageSize: config.pageSize,
    },
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
      this.isAdmin = ["super", "admin"].indexOf(avalonRoot.user.roleDm) > -1;
      this.createTable();
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
          name: "nkzbbh",
          label: "内控指标编号",
          index: "nkzbbh",
          width: 80,
          align: "left",
          sortable: false,
          hidden:true
        },
        { name: "nkzblb", label: "内控指标类别", index: "nkzblb", hidden: true },
        {
          name: "nkzblb",
          label: "内控指标类别",
          index: "nkzblb",
          width: 80,
          align: "center",
          sortable: false,
        },
        {
          name: "nkzbmc",
          label: "内控指标名称",
          index: "nkzbmc",
          width: 180,
          align: "left",
          sortable: false,
        },
        {
          name: "nkfxdj",
          label: "内控风险等级",
          index: "nkfxdj",
          align: "center",
          // hidden: true,
        },
        // {
        //   name: "nkywly",
        //   label: "内控业务领域",
        //   index: "nkywly",
        //   width: 180,
        //   align: "center",
        //   sortable: false,
        // },
        {
          name: "nkywms",
          label: "内控业务描述",
          index: "nkywms",
          width: 250,
          align: "left",
          sortable: false,
        },
        {
          name: "nksjly",
          label: "内控数据来源",
          index: "nksjly",
          width: 200,
          align: "left",
          sortable: false,
        },
        {
          name: "nkkjms",
          label: "内控口径描述",
          index: "nkkjms",
          width: 200,
          align: "left",
          sortable: false,
        },
        {
          name: "sqtxlx",
          label: "事前提醒类型",
          index: "sqtxlx",
          width: 100,
          align: "center",
          sortable: false,
        },
        {
          name: "szyjlx",
          label: "事中预警类型",
          index: "szyjlx",
          width: 100,
          align: "center",
          sortable: false,
        },
        {
          name: "shjdlx",
          label: "事后监督类型",
          index: "shjdlx",
          width: 100,
          align: "center",
          sortable: false,
        },
        {
          name: "kstxgzr",
          label: "开始提醒工作日",
          index: "kstxgzr",
          width: 100,
          align: "right",
          sortable: false,
        },
        {
          name: "ksjdgzr",
          label: "开始监督工作日",
          index: "ksjdgzr",
          width: 100,
          align: "right",
          sortable: false,
        },
        {
          name: "op",
          label: "操作",
          width: 160,
          align: "center",
          resizable: false,
          search: false,
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            return "<div class='btn edit' style='float: none;display: inline-block;' title='查看'>查看</div>";
          },
        },
      ];
      $("#zbpz-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: "#zbpz-tablePager",
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
          return $(".zbpzgl .form").height() - 60;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#zbpz-table").jqGrid("getRowData", rowid);
          if ($(e.target).hasClass("link")) {
            var params = {
              zbId: row.zbId,
              zbCname: row.zbCname,
              datatype: row.datatype,
              ywms: row.ywms,
              zbFomula: row.zbFomula,
            };
            avalonRoot.addTab({
              title: "指标配置详情",
              component: "zbpzmx",
              params: params,
            });
            return false;
          } else if ($(e.target).hasClass("edit")) {
            for (var key in self.modelData) {
              self.modelData[key] = row[key];
            }
            self.showModel("2");
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
          var pageNo = tools.getPageNo(pgButton, "zbpz-table");
          this.pageNumber = pageNo
          self.search(pageNo);
        },
      });

      $("#zbpz-table").jqGrid("setFrozenColumns");
      if (this.isAdmin) {
        tools.HeiKjNoSel("zbpzgl", "zbpz-table");
      }
      // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
      // self.search(1);
    },
    showModel: function (operation) {
      $(".model").show();
      $(".zbpzgl .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".zbpzgl .add-page-model").hide();
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
      $(".zbpzgl .select-sub").toggle();
      $(".zbpzgl .select-wrapper .icon").toggleClass("active");
      if (
        $(".zbpzgl .select-wrapper .icon").attr("title").slice(0, 2) === "展开"
      ) {
        $(".zbpzgl .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".zbpzgl .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".zbpzgl .select-sub").hide();
      $(".zbpzgl .select-wrapper .icon").removeClass("active");
      $(".zbpzgl .select-wrapper .icon").attr("title", "展开查询条件");
    },
    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize = $(".ui-pg-selbox", $(".zbpzgl")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      $("#zbpz-table").jqGrid("clearGridData");
      api
        .getNkfxConfig(params)
        .done(function (res) {
          if (res.code == "0") {
            $("#zbpz-table").resetSelection();
            $("#zbpz-table")[0].addJSONData(res.data);
            if (self.isAdmin) {
              tools.HeiKjNoSel("zbpzgl", "zbpz-table");
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
    exform: function () {
      var self = this;
      if ($("#zbpz-table").jqGrid("getRowData").length <= 0) {
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
        // nkzbbh: "",
        nkzblb: "",
        nkzbmc: "",
        nkfxdj: "",
        // nkywly: "",
        sqtxlx: "",
        szyjlx: "",
        shjdlx: "",
        pageSize: config.pageSize,
      };
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".zbpzgl").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".zbpzgl").off("click");
    },
    numberLimit: function () {
      this.modelData.jsYxj = this.modelData.jsYxj.replace(/\D/g, "");
    },
  },
});
