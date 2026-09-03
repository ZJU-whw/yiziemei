var dcbcx = require("./dcbcx.html");
avalon.component("dcbcx", {
  template: dcbcx,
  defaults: {
    params: {},
    swjgList: ["13300000000","13301000000","13302000000","13303000000","13304000000","13305000000","13306000000","13307000000","13308000000","13309000000","13310000000","13311000000"],
    act: 1,
    swjgmc: "",
    hasHsPermission:false,
    tcode: "dcbcx",
    searchData: {
      bsly:"1",
      swjgDm: "",
      nsrbs: "",
      tjnd: "",
      tjyf: "",
      zdbz: "Y",
      tsjsfs: "",
      orderSql: "",
      wceS: "",
      wceE: "",
      wclvS: "",
      wclvE: "",
      pageSize: config.pageSize,
    },
    tjndList: [],
    tableArr: [],
    tableOption: [],
    tableData: {
      sumData: {},
    },
    checkPermission:false,
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
      this.hasHsPermission = this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1
      if(this.hasHsPermission){
        this.checkBsjg()
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
        bsly:"1",
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
        {
          name: "tjny",
          label: "统计年月",
          index: "tjny",
          sortable: true,
          align: "center",
          width: 100,
        },
        // {
        //   name: "swjgDm",
        //   label: "税务机关代码",
        //   index: "swjgDm",
        //   sortable: true,
        //   align: "center",
        //   width: 100,
        // },
        {
          name: "swjgMc",
          label: "税务机关名称",
          index: "swjgMc",
          sortable: true,
          align: "center",
          width: 100,
        },
        {
          name: "nsrsbh",
          label: "纳税人识别号",
          index: "nsrsbh",
          sortable: true,
          align: "center",
          width: 150,
        },
        {
          name: "nsrmc",
          label: "纳税人名称",
          index: "nsrmc",
          sortable: true,
          align: "center",
          width: 180,
        },
        {
          name: "tsjsfs",
          label: "退税计算方式",
          index: "tsjsfs",
          sortable: true,
          align: "center",
          width: 100,
        },
        {
          name: "zdbz",
          label: "重点企业",
          index: "zdbz",
          sortable: true,
          align: "center",
          width: 100,
        },
        // {
        //   name: "ycCke",
        //   label: "预测出口额",
        //   index: "ycCke",
        //   sortable: true,
        //   align: "right",
        //   width: 100,
        //   formatter: function (cellVal, op, row) {
        //     cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
        //     if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
        //     return cellVal
        //   }
        // },
        {
          name: "ycTse",
          label: "预测退税额",
          index: "ycTse",
          sortable: true,
          align: "right",
          width: 100,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "sjTse",
          label: "实际退税额",
          index: "sjTse",
          sortable: true,
          align: "right",
          width: 100,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "tsWce",
          label: "退税误差额",
          index: "tsWce",
          sortable: true,
          align: "right",
          width: 100,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "tsWclv",
          label: "退税误差率",
          index: "tsWclv",
          sortable: true,
          align: "center",
          width: 100,
        },
        {
          name: "ycMde",
          label: "预测免抵额",
          index: "ycMde",
          sortable: true,
          align: "right",
          width: 100,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "sjMde",
          label: "实际免抵额",
          index: "sjMde",
          sortable: true,
          align: "right",
          width: 100,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "tjbz",
          label: "统计标志",
          index: "tjbz",
          sortable: true,
          align: "center",
          width: 100,
        },
        {
          name: "tjsj",
          label: "统计时间",
          index: "tjsj",
          sortable: true,
          align: "center",
          width: 150,
        },
        // {
        //   name: "hbycyy",
        //   label: "退税额环比波动20%及其以上原因",
        //   index: "hbycyy",
        //   sortable: true,
        //   align: "center",
        //   width: 185,
        //   formatter: function (cellvalue) {
        //     return "<div style='white-space: nowrap'>" + cellvalue + "</div>";
        //   },
        // },
      ];
      self.createTable(tableArr);
    },
    createTable: function (arr) {
      var self = this;
      var cm = [];
      for (var i = 0; i < arr.length; i++) {
        cm[i] = tools.clone(arr[i]);
      }
      $("#dcbcx-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: cm,
        viewrecords: true,
        rownumbers: true,
        pager: "#dcbcx-tablePager",
        shrinkToFit: false,
        width: "100%",
        autowidth: true,
        altRows: true,
        multiselect: false,
        // multiselectWidth:"30",
        altclass: "altclasscss",
        lastsort: 1,
        footerrow: true,
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".dcbcx .form").height() - 60 - 60;
        })(),
        onSortCol: function (index, iCol, sortorder) {
          self.searchData.orderSql = index + " " + sortorder;
          self.search(1);
          return;
        },
        gridComplete: function () {
          try {
            setTimeout(() => {
              var sumData = self.tableData.sumData?self.tableData.sumData:{
                sjMde:0,
                sjTse:0,
                tsWce:0,
                tsWclv:0,
                ycCke:0,
                ycMde:0,
                ycTse:0
              };
              sumData["tjny"] = "合计";
              $("#dcbcx-table").footerData("set", sumData);
            }, 200);
          } catch (error) {
            console.log(error);
          }
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "dcbcx-table");
          self.search(pageNo);
        },
      });
      // $("#dcbcx-table").jqGrid("setGroupHeaders", {
      //   useColSpanStyle: true,
      //   groupHeaders: [
      //     {
      //       startColumnName: " ycCke",
      //       numberOfColumns: 3,
      //       titleText: "预测数据",
      //     },
      //     {
      //       startColumnName: "sjTse",
      //       numberOfColumns: 2,
      //       titleText: "实际申报数据",
      //     },
      //   ],
      // });
      this.searchData.pageSize = $(".ui-pg-selbox", $(".dcbcx")).val();
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
      $("#dcbcx-table").setGridWidth($(".dcbcx").width());
    },
    normalSearch() {
      this.searchData.orderSql = "";
      $(".s-ico").hide();
      this.search(1, true);
    },
    search: function (pageNo, isSum) {
      var self = this;
      this.searchData.pageSize = $(".ui-pg-selbox", $(".dcbcx")).val();
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      params.tjny = this.searchData.tjnd.toString() + this.searchData.tjyf;
      $("#dcbcx-table").jqGrid("clearGridData");
      api
        .getTsycqybsjg(params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data.rows;
            self.tableData.sumData = {};
            if (isSum) {
              api.getTsycqybsjgstat(params).done((res) => {
                if (res.code == "0") {
                  self.tableData.sumData = res.data;
                } else {
                  tools.info(res.msg);
                }
              });
            }
            $("#dcbcx-table").resetSelection();
            $("#dcbcx-table")[0].addJSONData(res.data);
            self.closeHyper();
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
      // ajax("POST","/glfw/extra/tszbcs/cx/list",params).done(function(res){
      //     if(res.code=='0'){
      //         self.tableData=res.data;
      //         $("#dcbcx-table").resetSelection();
      //         $("#dcbcx-table")[0].addJSONData(res.data);

      //     }else{
      //         tools.info(res.msg);
      //     }
      // }).fail(function(err){
      //     tools.info(err);
      // })
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
      $(".dcbcx .model-title").html("新增");
      self.showModel();
    },
    delData: function () {
      var self = this;
      var incode = [];
      var rowids = $("#dcbcx-table").jqGrid("getGridParam", "selarrrow");
      for (var i = 0; i < rowids.length; i++) {
        var b = getCellData("dcbcx-table", rowids[i], "id");
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
            $.fn.zTree.init($(".dcbcx .treeDiv"), setting, res.data);
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
      $(".dcbcx").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },

    hideTree: function () {
      $(".treeDiv").hide();
      $(".dcbcx").off("click");
    },

    showModel: function () {
      $(".model").show();
      $(".dcbcx .page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".dcbcx .page-model").hide();
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
      if ($("#dcbcx-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var self = this;
      var params = tools.clone(self.searchData);
      params.pageNo = 1;
      params.tjny = this.searchData.tjnd.toString() + this.searchData.tjyf;
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/glfw/export/tseyc/bsjg");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form); //将表单放置在web中
      form.append(input1);
      form.submit();
      form.remove();
    },
    showHyper: function () {
      $(".dcbcx .select-sub").toggle();
      $(".dcbcx .select-wrapper .icon").toggleClass("active");
      if (
        $(".dcbcx .select-wrapper .icon").attr("title").slice(0, 2) === "展开"
      ) {
        $(".dcbcx .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".dcbcx .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".dcbcx .select-sub").hide();
      $(".dcbcx .select-wrapper .icon").removeClass("active");
      $(".dcbcx .select-wrapper .icon").attr("title", "展开查询条件");
    },
    statExecute(qrFlag) {
      let self = this
      let params = {
        tjny:this.searchData.tjnd.toString() + this.searchData.tjyf
      }
      if (qrFlag) {
        params.qrFlag = qrFlag
      }
      api
        .getTsycqybsjgexecute(params, false, true)
        .done(function (res) {
          if (res.code == "0") {
            self.closeHyper();
            self.normalSearch()
          } else if (res.code == "900") {
            tools.confirm(res.msg, "确定", function () {
              self.statExecute(1);
            });
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    checkBsjg(){
      ajax('post','/glfw/tseyc/qy/bsjg/stat/check',{}).done(res=>{
        if(res.code == '0'){
          this.checkPermission = true
        }
      }).fail(function(err){
				tools.info(err);
			})
    }
  },
});
