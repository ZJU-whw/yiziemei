var zxjdzbcsszMx = require("./zxjdzbcsszMx.html");
avalon.component("zxjdzbcsszMx", {
  template: zxjdzbcsszMx,
  defaults: {
    params: {
      zbId: "",
      zbCname: "",
      datatype: "",
      ywms: "",
      zbFomula: "",
    },
    act: 1,
    tcode: "zxjdzbcsszMx",
    searchYcffData: {
      zbId: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    searchCsData: {
      zbId: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    searchSxData: {
      zbid: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    modelYcffData: {
      xh: "",
      customScore: "",
      yxbz: "Y",
      operation: "2",
    },
    modelCsData: {
      csbm: "",
      customValDef: "",
      datatype: "",
      yxbz: "Y",
      operation: "2",
    },
    dapplyQyMap: { 0: "通用", 1: "生产", 2: "外贸" },
    onReady: function () {
      this.searchYcffData.zbId = this.params.zbId;
      this.searchCsData.zbId = this.params.zbId;
      this.searchSxData.zbid = this.params.zbId;
      // this.createTableYcff();
      this.createTableCs();
      this.createTableSx();
      var el1 = $(".zxjdzbcsszMx .more1")[0];
      var el2 = $(".zxjdzbcsszMx .more2")[0];
      // this.setEllipsis(el1);
      // this.setEllipsis(el2);
    },
    //copy bg
    createTableYcff: function () {
      var self = this;
      var columns = [
        { name: "zbId", label: "指标标识", index: "zbId", hidden: true },
        { name: "xh", label: "序号", index: "xh", hidden: true },
        {
          name: "ycpdtj",
          label: "异常判定条件",
          index: "ycpdtj",
          width: 270,
          align: "left",
          sortable: true,
        },
        {
          name: "lwgz",
          label: "例外规则",
          index: "lwgz",
          width: 80,
          align: "left",
          sortable: true,
        },
        {
          name: "badpoint",
          label: "坏点标志",
          index: "badpoint",
          hidden: true,
        },
        {
          name: "badpointName",
          label: "坏点标志",
          index: "badpointName",
          width: 60,
          align: "center",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.badpoint] || "";
          },
        },
        {
          name: "score",
          label: "上级赋分",
          index: "score",
          width: 80,
          align: "right",
          sortable: true,
        },
        {
          name: "customScore",
          label: "自定义赋分",
          index: "customScore",
          width: 80,
          align: "right",
          sortable: true,
        },
        {
          name: "note",
          label: "异常描述",
          index: "note",
          width: 270,
          align: "left",
          sortable: true,
        },
        { name: "yxbz", label: "有效标志", index: "yxbz", hidden: true },
        {
          name: "yxbzName",
          label: "有效标志",
          index: "yxbzName",
          width: 60,
          align: "center",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            var yxbzMap = { Y: "有效", N: "无效" };
            return yxbzMap[rowObject.yxbz] || "";
          },
        },
        {
          name: "op",
          label: "操作",
          index: "op",
          width: 60,
          formatter: function (cellvalue, options, rowObject) {
            var op =
              "<div style='text-align:center;'><div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div>";
            op += "</div>";
            return op;
          },
        },
      ];
      $("#zxjdzbcsszMx-ycff-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: "#zxjdzbcsszMx-ycff-tablePager",
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
          return (
            ($(".zxjdzbcsszMx .form").height() -
              $(".zxjdzbcsszMx .msg").height() -
              189) /
            2
          );
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#zxjdzbcsszMx-ycff-table").jqGrid("getRowData", rowid);
          if ($(e.target).hasClass("edit")) {
            for (var key in self.modelYcffData) {
              self.modelYcffData[key] = row[key];
            }
            self.showModelYcff("2");
            return false;
          } else if ($(e.target).hasClass("del")) {
            tools.confirm("是否确定删除该条数据？", "确定", function () {
              var params = {
                zbId: row.zbId,
                xh: row.xh,
              };
              ajax("POST", "/sszj/zxjg/zbgl/zb/ycff/del", params)
                .done(function (res) {
                  if (res.code == "0") {
                    self.searchYcff(1);
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
          self.searchYcffData.orderSql = index + " " + sortorder;
          self.searchYcff(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "zxjdzbcsszMx-ycff-table");
          self.searchYcff(pageNo);
        },
      });
      this.searchYcffData.pageSize = $(
        ".ui-pg-selbox",
        $(".zxjdzbcsszMx")
      ).val();
      self.searchYcff(1);
    },
    createTableCs: function () {
      var self = this;
      var columns = [
        { name: "zbId", label: "指标标识", index: "zbId", hidden: true },
        {
          name: "csbm",
          label: "参数编码",
          index: "csbm",
          width: 230,
          align: "left",
          sortable: true,
        },
        {
          name: "csmc",
          label: "参数名称",
          index: "csmc",
          width: 200,
          align: "left",
          sortable: true,
        },
        {
          name: "datatype",
          label: "数据类型",
          index: "datatype",
          hidden: true,
        },
        // { name: "datatypeName", label: "数据类型", index: "datatypeName",width: 60, align:"center",sortable: false, formatter: function(cellvalue, options, rowObject){
        // 	var map = {'1': '字符型', '2': '数值型', '3': '日期型', '4': '逻辑性'};
        // 	return map[rowObject.datatype] || '';
        // } },
        {
          name: "cstype",
          label: "参数类型",
          index: "cstype",
          width: 80,
          align: "center",
          sortable: true,
        },
        {
          name: "valDef",
          label: "默认值",
          index: "valDef",
          width: 80,
          align: "center",
          sortable: true,
        },
        {
          name: "customValDef",
          label: "税务机关自定义值",
          index: "customValDef",
          width: 120,
          align: "center",
          sortable: true,
        },
        {
          name: "note",
          label: "说明",
          index: "note",
          width: 350,
          align: "left",
          sortable: true,
        },
        { name: "yxbz", label: "有效标志", index: "yxbz", hidden: true },
        {
          name: "yxbzName",
          label: "有效标志",
          index: "yxbzName",
          width: 60,
          align: "center",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            var yxbzMap = { Y: "有效", N: "无效" };
            return yxbzMap[rowObject.yxbz] || "";
          },
        },
        {
          name: "op",
          label: "操作",
          index: "op",
          width: 60,
          formatter: function (cellvalue, options, rowObject) {
            var op =
              "<div style='text-align:center;'><div class='btn edit' style='float: none;display: inline-block;' title='编辑'>编辑</div>";
            op += "</div>";
            return op;
          },
        },
      ];
      $("#zxjdzbcsszMx-cs-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: "#zxjdzbcsszMx-cs-tablePager",
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
          return (
            $(".zxjdzbcsszMx .form").height() -
            $(".zxjdzbcsszMx .msg").height() -
            111
          );
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#zxjdzbcsszMx-cs-table").jqGrid("getRowData", rowid);
          if ($(e.target).hasClass("edit")) {
            for (var key in self.modelCsData) {
              self.modelCsData[key] = row[key];
            }
            self.showModelCs("2");
            return false;
          } else if ($(e.target).hasClass("del")) {
            tools.confirm("是否确定删除该条数据？", "确定", function () {
              var params = {
                zbId: row.zbId,
                csbm: row.csbm,
              };
              ajax("POST", "/sszj/zxjg/zbgl/zb/cs/del", params)
                .done(function (res) {
                  if (res.code == "0") {
                    self.searchCs(1);
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
          var orderSql = index + " " + sortorder;
          if (index == "valDef") {
            self.searchCsData.orderSql = "a." + orderSql;
          } else {
            self.searchCsData.orderSql = orderSql;
          }
          self.searchCs(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "zxjdzbcsszMx-cs-table");
          self.searchCs(pageNo);
        },
      });
      this.searchCsData.pageSize = $(".ui-pg-selbox", $(".zxjdzbcsszMx")).val();
      self.searchCs(1);
    },
    showModelYcff: function (operation) {
      this.modelYcffData.operation = operation;
      $(".model").show();
      $(".zxjdzbcsszMx .ycff-page-model").show();
    },
    hideModelYcff: function () {
      $(".model").hide();
      $(".zxjdzbcsszMx .ycff-page-model").hide();
      this.modelYcffData = {
        xh: "",
        customScore: "",
        yxbz: "Y",
        operation: "2",
      };
    },
    showModelCs: function (operation) {
      this.modelCsData.operation = operation;
      $(".model").show();
      $(".zxjdzbcsszMx .cs-page-model").show();
    },
    hideModelCs: function () {
      $(".model").hide();
      $(".zxjdzbcsszMx .cs-page-model").hide();
      this.modelCsData = {
        csbm: "",
        customValDef: "",
        datatype: "",
        yxbz: "Y",
        operation: "2",
      };
    },
    searchYcff: function (pageNo) {
      var self = this;
      this.searchYcffData.pageSize =
        $(".ui-pg-selbox", $(".zxjdzbcsszMx .ycff")).val() || 20;
      var params = tools.clone(self.searchYcffData);
      params.pageNo = pageNo;
      $("#zxjdzbcsszMx-ycff-table").jqGrid("clearGridData");
      ajax("POST", "/sszj/zxjg/zbgl/zb/ycff/swjg/list", params)
        .done(function (res) {
          if (res.code == "0") {
            $("#zxjdzbcsszMx-ycff-table").resetSelection();
            $("#zxjdzbcsszMx-ycff-table")[0].addJSONData(res.data);
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    searchCs: function (pageNo) {
      var self = this;
      this.searchCsData.pageSize =
        $(".ui-pg-selbox", $(".zxjdzbcsszMx .cs")).val() || 20;
      var params = tools.clone(self.searchCsData);
      params.pageNo = pageNo;
      $("#zxjdzbcsszMx-cs-table").jqGrid("clearGridData");
      ajax("POST", "/sszj/zxjg/zbgl/zb/cs/swjg/list", params)
        .done(function (res) {
          if (res.code == "0") {
            $("#zxjdzbcsszMx-cs-table").resetSelection();
            $("#zxjdzbcsszMx-cs-table")[0].addJSONData(res.data);
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    saveModelYcff: function () {
      var self = this;
      var rules = [
        { name: "customScore", message: "自定义赋分不能为空！" },
        { name: "yxbz", message: "有效标志不能为空！" },
      ];
      var url = "/sszj/zxjg/zbgl/zb/ycff/swjg/update";
      for (var i = 0; i < rules.length; i++) {
        if (this.modelYcffData[rules[i].name] == "") {
          tools.info(rules[i].message);
          return;
        }
      }
      this.modelYcffData.zbId = this.params.zbId;
      var params = {
        xh: this.modelYcffData.xh,
        score: this.modelYcffData.customScore,
        yxbz: this.modelYcffData.yxbz,
        operation: this.modelYcffData.operation,
        zbId: this.modelYcffData.zbId,
      };
      ajax("POST", url, params)
        .done(function (res) {
          if (res.code == "0") {
            tools.info("保存成功！");
            self.hideModelYcff();
            self.searchYcff(1);
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    saveModelCs: function () {
      var self = this;
      var url = "/sszj/zxjg/zbgl/zb/cs/swjg/update";
      var rules = [
        { name: "csbm", message: "参数编码不能为空！" },
        { name: "valDef", message: "参数值不能为空！" },
        { name: "yxbz", message: "有效标志不能为空！" },
      ];
      for (var i = 0; i < rules.length; i++) {
        if (this.modelCsData[rules[i].name] == "") {
          tools.info(rules[i].message);
          return;
        }
      }
      var params = {
        csbm: this.modelCsData.csbm,
        zbId: this.params.zbId,
        valDef: this.modelCsData.customValDef,
        yxbz: this.modelCsData.yxbz,
        operation: this.modelYcffData.operation,
      };
      ajax("POST", url, params)
        .done(function (res) {
          if (res.code == "0") {
            tools.info("保存成功！");
            self.hideModelCs();
            self.searchCs(1);
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    numberLimit: function () {
      this.modelYcffData.customScore = this.modelYcffData.customScore.replace(
        /\D/g,
        ""
      );
    },
    setEllipsis: function (el) {
      var offsetHeight = el.offsetHeight;
      var innerHTML = el.innerHTML;
      for (var i = 0; i < innerHTML.length; i++) {
        el.innerHTML = innerHTML.substr(0, i);
        if (offsetHeight < el.scrollHeight) {
          el.style.overflow = "hidden";
          el.innerHTML = innerHTML.substr(0, i - 3) + "...";
          break;
        }
      }
    },
    customValDefChange: function () {
      if (this.modelCsData.datatype == "2") {
        this.modelCsData.customValDef = this.modelCsData.customValDef.replace(
          /\D/g,
          ""
        );
      }
    },
    updateRes: function(){
      ajax("POST", "/sszj/zxjg/submit/task", {zbid:this.params.zbId})
                .done(function (res) {
                  if (res.code == "0") {
                    tools.info('刷新成功');
                  } else {
                    tools.info(res.msg);
                  }
                })
                .fail(function (err) {
                  tools.info(err);
                });
    },
    showModelSx: function (operation) {
      this.modelYcffData.operation = operation;
      this.searchSx(1);
      $(".model").show();
      $(".zxjdzbcsszMx .sx-page-model").show();
    },
    hideModelSx: function () {
      $(".model").hide();
      $(".zxjdzbcsszMx .sx-page-model").hide();
    },
    createTableSx: function () {
      var self = this;
      var columns = [
        { name: "zbId", label: "指标标识", index: "zbId", hidden: true },
        {
          name: "swjgDm",
          label: "税务机关代码",
          index: "swjgDm",
          align: "left",
          sortable: true,
        },
        {
          name: "sqrXm",
          label: "操作人",
          index: "sqrXm",
          align: "left",
          sortable: true,
        },
        {
          name: "sqsj",
          label: "刷新时间",
          index: "sqsj",
          align: "left",
          width:170,
          sortable: true,
        },
        {
          name: "clkssj",
          label: "处理开始时间",
          index: "clkssj",
          align: "left",
          width:170,
          sortable: true,
        },
        {
          name: "ztbz",
          label: "状态",
          index: "ztbz",
          width:80,
          align: "center",
          sortable: true,
          hidden:true
        },
        {
          name: "ztbzZn",
          label: "状态",
          index: "ztbzZn",
          width:80,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var Map = { '0': "已提交", '1': "出理中",'2':'处理完成','9':'处理失败' };
            return Map[rowObject.ztbz];
          },
        },
      ];
      $("#zxjdzbcsszMx-sx-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: "#zxjdzbcsszMx-sx-tablePager",
        shrinkToFit: true,
        autowidth: true,
        altRows: true,
        // multiselect: true,
        // multiselectWidth:"30",
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        width: 750,
        height:340,
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "zxjdzbcsszMx-sx-table");
          self.searchSx(pageNo);
        },
      });
      this.searchSxData.pageSize = $(".ui-pg-selbox", $(".zxjdzbcsszMx")).val();
      self.searchSx(1);
    },
    searchSx: function (pageNo) {
      var self = this;
      this.searchSxData.pageSize =
        $(".ui-pg-selbox", $(".zxjdzbcsszMx .sx")).val() || 20;
      var params = tools.clone(self.searchSxData);
      params.pageNo = pageNo;
      $("#zxjdzbcsszMx-sx-table").jqGrid("clearGridData");
      ajax("POST", "/sszj/zxjg/query/task", params)
        .done(function (res) {
          if (res.code == "0") {
            $("#zxjdzbcsszMx-sx-table").resetSelection();
            $("#zxjdzbcsszMx-sx-table")[0].addJSONData(res.data);
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
  },
});
