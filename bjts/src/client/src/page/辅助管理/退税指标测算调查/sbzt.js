var sbzt = require("./sbzt.html");
avalon.component("sbzt", {
  template: sbzt,
  defaults: {
    params: {},
    act: 1,
    swjgmc: "",
    tcode: "sbzt",
    searchData: {
      bsly:"1",
      swjgDm: "",
      nsrbs: "",
      tjnd: "",
      tjyf: "",
      sbbz: "",
      zdbz: "Y",
      tsjsfs: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    tjndList: [],
    tableArr: [],
    tableOption: [],
    tableData: {
      sumData: {},
    },
    onReady: function () {
      var self = this;
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
      this.initTree();
      this.getTableRow();
    },

    changeTab: function (num) {
      this.act = num;
    },
    reset: function () {
      var self = this;
      self.searchData = {
        bsly:'1',
        spdm: "",
        spmc: "",
        jkDate: "",
        zdbz: "Y",
        orderSql: "",
        pageSize: config.pageSize,
      };
    },
    //copy bg
    getTableRow: function () {
      var self = this;
      var tableArr = [
        // {
        //   name: "swjgDm",
        //   label: "税务机关代码",
        //   index: "swjgDm",
        //   width: 120,
        //   align: "center",
        //   sortable: true,
        // },
        {
          name: "swjgMc",
          label: "税务机关名称",
          index: "swjgMc",
          width: 150,
          align: "center",
          sortable: true,
        },
        {
          name: "tjny",
          label: "统计年月",
          index: "tjny",
          width: 100,
          align: "left",
          sortable: true,
        },
        {
          name: "sbbz",
          label: "上报状态",
          index: "sbbz",
          width: 90,
          align: "center",
          sortable: true,
        },
        {
          name: "nsrsbh",
          label: "纳税人识别号",
          index: "nsrsbh",
          width: 180,
          align: "left",
          sortable: true,
        },
        {
          name: "nsrmc",
          label: "纳税人名称",
          index: "nsrmc",
          width: 200,
          align: "left",
          sortable: true,
        },
        {
          name: "tsjsfs",
          label: "退税计算方式",
          index: "tsjsfs",
          width: 90,
          align: "center",
          sortable: true,
        },
        {
          name: "zdbz",
          label: "重点企业（是/否）",
          index: "zdbz",
          width: 100,
          align: "center",
          sortable: true,
        },
        {
          name: "bsrMc",
          label: "办税人名称",
          index: "bsrMc",
          width: 90,
          align: "left",
          sortable: true,
        },
        {
          name: "bsrDh",
          label: "办税人电话",
          index: "bsrDh",
          width: 150,
          align: "left",
          sortable: true,
        },
        {
          name: "nsrdh",
          label: "企业联系电话",
          index: "nsrdh",
          width: 90,
          align: "left",
          sortable: true,
        },
      ];
      self.createTable(tableArr);
    },
    createTable: function (arr) {
      var self = this;
      var cm = [];
      for (var i = 0; i < arr.length; i++) {
        cm[i] = tools.clone(arr[i]);
      }
      $("#sbzt-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: cm,
        viewrecords: true,
        rownumbers: true,
        pager: "#sbzt-tablePager",
        shrinkToFit: false,
        width: "100%",
        autowidth: true,
        altRows: true,
        multiselect: false,
        // multiselectWidth:"30",
        altclass: "altclasscss",
        lastsort: 1,
        // footerrow:true,
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".sbzt .form").height() - 60;
        })(),
        onSortCol: function (index, iCol, sortorder) {
          self.searchData.orderSql = index + " " + sortorder;
          self.search(1);
          return;
        },
        // gridComplete: function(){
        //     var sumData=self.tableData.sumData;
        //     sumData['shxydm']="合计";
        //     $("#sbzt-table").footerData('set', sumData);
        // },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "sbzt-table");
          self.search(pageNo);
        },
      });
      this.searchData.pageSize = $(".ui-pg-selbox", $(".sbzt")).val();
      // self.search(1)
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
      ajax("POST", "/bjtssw/basis/columprofile/update", params)
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
      $("#sbzt-table").setGridWidth($(".sbzt").width());
    },
    normalSearch() {
      this.searchData.orderSql = "";
      $(".s-ico").hide();
      this.search(1);
    },
    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize = $(".ui-pg-selbox", $(".sbzt")).val();
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      params.tjny = this.searchData.tjnd.toString() + this.searchData.tjyf;
      $("#sbzt-table").jqGrid("clearGridData");
      api
        .getTsycqybszt(params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data;
            $("#sbzt-table").resetSelection();
            $("#sbzt-table")[0].addJSONData(res.data);
            self.closeHyper();
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    newData: function () {
      var self = this;
      self.modelData = {
        id: "",
        spdm: "",
        spmc: "",
        qsrq: "",
        jzrq: "",
        yyms: "",
        yxbz: "",
      };
      $(".sbzt .model-title").html("新增");
      self.showModel();
    },
    delData: function () {
      var self = this;
      var incode = [];
      var rowids = $("#sbzt-table").jqGrid("getGridParam", "selarrrow");
      for (var i = 0; i < rowids.length; i++) {
        var b = getCellData("sbzt-table", rowids[i], "id");
        incode.push(b);
      }
      if (incode.length <= 0) {
        tools.info("请至少选择一条记录！");
        return false;
      }
      tools.confirm("确定删除选中数据？", "确定", function () {
        ajax("POST", "/bjtssw/yj/mgsp/del", { ids: incode })
          .done(function (res) {
            if (res.code == "0") {
              tools.info("操作成功");
              self.search(1);
            } else {
              tools.info(res.msg);
            }
          })
          .fail(function (err) {
            tools.info(err);
          });
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

    //copy
    initTree: function () {
      var self = this;
      var setting = {
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

      ajax("POST", "/cxfw/export/readtree", { nodeType: "3" })
        .done(function (res) {
          if (res.code == "0") {
            $.fn.zTree.init($(".sbzt .treeDiv"), setting, res.data);
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".sbzt").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".sbzt").off("click");
    },
    showModel: function () {
      $(".model").show();
      $(".sbzt .page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".sbzt .page-model").hide();
      this.modelData = {
        yjObject: "",
        yjObjname: "",
      };
    },
    saveModel: function () {
      var self = this;
      var params = tools.clone(self.modelData);
      if (!/^[0-9]*$/g.test(params.spdm)) {
        tools.info("请输入正确的商品代码");
        return;
      }
      params.bmdid = self.searchData.id;
      ajax("POST", "/bjtssw/yj/mgsp/update", params)
        .done(function (res) {
          if (res.code == "0") {
            self.hideModel();
            self.search(1);
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    exform: function () {
      if ($("#sbzt-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      try {
        var self = this;
        var params = tools.clone(self.searchData);
        params.pageNo = 1;
        params.tjny = this.searchData.tjnd.toString() + this.searchData.tjyf;
        var form = $("<form>"); //定义一个form表单
        form.attr("style", "display:none");
        form.attr("target", "hiddenframe");
        // form.attr("target", "_blank")
        form.attr("method", "post");
        form.attr("action", "/glfw/export/tseyc/bszt");
        var input1 = $("<input>");
        input1.attr("type", "hidden");
        input1.attr("name", "data");
        input1.attr("value", JSON.stringify(params));
        $("body").append(form); //将表单放置在web中
        form.append(input1);
        form.submit();
        form.remove();
      } catch (error) {
        console.log(error);
      }
    },
    showHyper: function () {
      $(".sbzt .select-sub").toggle();
      $(".sbzt .select-wrapper .icon").toggleClass("active");
      if (
        $(".sbzt .select-wrapper .icon").attr("title").slice(0, 2) === "展开"
      ) {
        $(".sbzt .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".sbzt .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".sbzt .select-sub").hide();
      $(".sbzt .select-wrapper .icon").removeClass("active");
      $(".sbzt .select-wrapper .icon").attr("title", "展开查询条件");
    },
  },
});
