var tsyczdqymc = require("./tsyczdqymc.html");
avalon.component("tsyczdqymc", {
  template: tsyczdqymc,
  defaults: {
    params: {},
    act: 1,
    swjgmc: "",
    nsrmc: "",
    searchData: {
      nsrbs: "",
      swjgDm: "",
      tsjsfs: "",
      qybz: "",
      zdbz: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    editData: {
      nsrmc: "",
      nsrsbh: "",
    },
    modelTag:'0',
    isEdit: false,
    addTitle: "",
    tableData: {
      sumData: {},
    },
    hasHsPermission:false,
    nsrdzdahList: [],
    nsrdzdahListTemp: [],
    listCount: 20,
    tempSearch: "",
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
    onReady: function () {
      var self = this;
      try {
        this.hasHsPermission =
          this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
          console.log(this.hasHsPermission);
        this.searchData.swjgDm = avalonRoot.user.swjgDm;
        this.swjgmc = avalonRoot.user.swjgMc;
      } catch (e) {}
      this.initDate();
      this.initTree();
      this.createTable();
      this.importCallBack('tsyczdqymcFileupload');
      this.importCallBack('tsyczdqymcFileupload1');
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
      $(".tsyczdqymc .datepicker.date-day").datetimepicker(options);
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
        //   name: "nsrdzdah",
        //   label: "纳税人电子档案号",
        //   index: "nsrdzdah",
        //   width: 150,
        //   align: "center",
        //   sortable: true,
        // },
        // {
        //   name: "swjgDm",
        //   label: "税务机关代码",
        //   index: "swjgDm",
        //   width: 120,
        //   align: "center",
        //   sortable: true,
        // },
        {
          name: "swjgJc",
          label: "税务机关名称",
          index: "swjgJc",
          width: 130,
          align: "center",
          sortable: true,
        },
        {
          name: "nsrsbh",
          label: "纳税人识别号",
          index: "nsrsbh",
          width: 180,
          align: "center",
          sortable: true,
        },
        {
          name: "nsrmc",
          label: "纳税人名称",
          index: "nsrmc",
          width: 180,
          align: "center",
          sortable: true,
        },
        {
          name: "tsjsfsDm",
          label: "退税计算方式代码",
          index: "tsjsfsDm",
          width: 120,
          align: "center",
          hidden:true,
          sortable: true,
        },
        {
          name: "tsjsfs",
          label: "退税计算方式",
          index: "tsjsfs",
          width: 120,
          align: "center",
          sortable: false,
        },
        // {
        //   name: "zdhbz",
        //   label: "重点户标志",
        //   index: "zdhbz",
        //   width: 100,
        //   align: "right",
        //   sortable: true,
        // },
        {
          name: "zdhbz",
          label: "重点户标志",
          index: "zdhbz",
          width: 100,
          align: "center",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[cellvalue];
          },
        },
        // {
        //   name: "qybj",
        //   label: "启用标记",
        //   index: "qybj",
        //   width: 100,
        //   align: "right",
        //   sortable: true,
        // },
        {
          name: "qybj",
          label: "启用标记",
          index: "qybj",
          width: 100,
          align: "center",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "启用", N: "不启用" };
            return map[cellvalue];
          },
        },
        {
          name: "op",
          label: "操作",
          index: "op",
          width: 116,
          hidden: !self.hasHsPermission,
          formatter: function (cellvalue, options, rowObject) {
            return "<div class='btn op-edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn op-del' style='float: none;display: inline-block;' title='删除'>删除</div>";
          },
        },
      ];
      $("#tsyczdqymc-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: "#tsyczdqymc-tablePager",
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
          return $(".tsyczdqymc .form").height() - 60 - 10;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#tsyczdqymc-table").jqGrid("getRowData", rowid);
          if ($(e.target).hasClass("op-edit")) {
            self.editData = {
              nsrmc: row.nsrmc,
              nsrsbh: row.nsrsbh,
              qybj: row.qybj == "启用" ? "Y" : "N",
              zdhbz: row.zdhbz == "是" ? "Y" : "N",
            };
            self.showModel("编辑");
            return false;
          } else if ($(e.target).hasClass("op-del")) {
            tools.confirm("是否确定删除该条数据？", "确定", function () {
              api.getZdqyDelete({ nsrsbh: row.nsrsbh }).done(function (res) {
                if (res.code == "0") {
                  tools.info("删除成功！");
                  self.search(1);
                }
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
        // gridComplete: function () {
        //   var sumData = self.tableData.sumData;
        //   sumData["nsrsbh"] = "合计";
        //   $("#tsyczdqymc-table").footerData("set", sumData);
        // },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "tsyczdqymc-table");
          self.search(pageNo);
        },
      });
    },
    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize =
        $(".ui-pg-selbox", $(".tsyczdqymc")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      $("#tsyczdqymc-table").jqGrid("clearGridData");
      api
        .getZdqyQuery(params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data.rows;
            $("#tsyczdqymc-table").resetSelection();
            $("#tsyczdqymc-table")[0].addJSONData(res.data);
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
          $.fn.zTree.init($(".tsyczdqymc .treeDiv"), setting1, data);
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showHyper: function () {
      $(".tsyczdqymc .select-sub").toggle();
      $(".tsyczdqymc .select-wrapper .icon").toggleClass("active");
      if (
        $(".tsyczdqymc .select-wrapper .icon").attr("title").slice(0, 2) ===
        "展开"
      ) {
        $(".tsyczdqymc .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".tsyczdqymc .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".tsyczdqymc .select-sub").hide();
      $(".tsyczdqymc .select-wrapper .icon").removeClass("active");
      $(".tsyczdqymc .select-wrapper .icon").attr("title", "展开查询条件");
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".tsyczdqymc").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".tsyczdqymc").off("click");
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
      if ($("#tsyczdqymc-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData);
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/glfw/export/tseyc/zdqy");
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
        tsjsfs: "",
        qybz: "",
        zdbz: "",
        orderSql: "",
        pageSize: config.pageSize,
      };
      this.swjgmc = avalonRoot.user.swjgMc;
    },
    showModel: function (title) {
      this.addTitle = title;
      if (title == "新增") {
        this.isEdit = false;
        this.editData = {
          nsrmc: "",
          nsrsbh: "",
          nsrbs: "",
        };
      } else if (title == "编辑") {
        this.isEdit = true;
      }
      $(".model").show();
      $(".tsyczdqymc .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".tsyczdqymc .add-page-model").hide();
      this.editData = {};
      this.nsrmc = "";
      this.nsrdzdahList = [];
    },
    searchQy() {
      let self = this;
      let data = {
        nsrbs: this.editData.nsrbs,
        rowNum: 200,
      };
      setTimeout(function () {
        if (self.editData.nsrbs != self.tempSearch && self.editData.nsrbs) {
          api.getZdqymhQuery(data).done((res) => {
            if (res.code == "0") {
              self.nsrdzdahListTemp = [];
              self.nsrdzdahListTemp = res.data;
              self.nsrdzdahList = [...self.nsrdzdahListTemp];
              self.tempSearch = self.editData.nsrbs;
            }
          });
        }
      }, 0);
    },
    onchange(e) {
      setTimeout(() => {
        this.nsrdzdahList.forEach((item) => {
          if (item.nsrmc == this.nsrmc) {
            this.editData.nsrmc = item.nsrmc;
            this.editData.nsrsbh = item.nsrsbh;
          }
        });
      }, 0);
    },
    showImportModel: function (val) {
      this.modelTag = val
      $(".model").show();
      $(".tsyczdqymc .import-page-model").show();
    },
    hideImportModel: function () {
      this.nsrdzdahList = [];
      $(".model").hide();
      $(".tsyczdqymc .import-page-model").hide();
    },
    importCallBack: function (id) {
      var self = this;
      var idStr = '#'+id
      $(idStr)
        .fileupload({
          dataType: "json",
          acceptFileTypes: /(xls|xlsx)$/i,
          maxFileSize: 4000000, // 限制大小4M
          done: function (e, data) {
            if (data.result.code == "0") {
              let str =
                "导入总数量：" +
                data.result.data.totalNum +
                ",成功数量：" +
                data.result.data.successNum +
                ",失败数量：" +
                data.result.data.errorNum;
              if (data.result.data.errorDetails.length) {
                data.result.data.errorDetails.forEach((item, index) => {
                  if (index < 5) {
                    let temp =
                      "\n纳税人名称：" +
                      item.nsrmc +
                      "&nbsp&nbsp&nbsp错误信息：" +
                      item.msg;
                    str = str + temp;
                  } else if (index == 5) {
                    str = str + "\n......";
                  }
                });
              }
              tools.info(str);
              // tools.info("导入成功!");
              self.search(1);
            } else {
              tools.info(data.result.msg);
            }
          },
        })
        .on("fileuploadadd", function (e, data) {
          $(".app-loading").show();
        })
        .on("fileuploadalways", function (e, data) {
          $(".app-loading").hide();
        });
    },
    exformModel() {
      // tools.exform({}, "/glfw/tseyc/zdqy/import/template");
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/glfw/tseyc/zdqy/import/template");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify({}));
      $("body").append(form); //将表单放置在web中
      form.append(input1);
      form.submit();
      form.remove();
    },
    saveModel() {
      let self = this;
      if (!this.isEdit) {
        let params = {
          nsrmc: this.editData.nsrmc,
          nsrsbh: this.editData.nsrsbh,
        };
        api.getZdqyAdd(params).done(function (res) {
          if (res.code == "0") {
            tools.info("新增成功！");
            self.search(1);
            self.hideModel();
          }
        });
      } else {
        let params = {
          nsrsbh: this.editData.nsrsbh,
          qybj: this.editData.qybj,
          zdhbz: this.editData.zdhbz,
        };
        api.getZdqyUpdate(params).done(function (res) {
          if (res.code == "0") {
            tools.info("编辑成功！");
            self.search(1);
            self.hideModel();
          }
        });
      }
    },
    showMenu:function(e){
			var self=this;
			$(".dropdown-menu",e.target).show();
			$('.tsyczdqymc').on('click',function(e){
				var e=e||window.event;
				if($('.dropdown-menu').find($(e.target)).length<=0){
					self.hideMenu();
				}
			})
		},
    hideMenu:function(){
			$(".dropdown-menu").hide();
			$('.tsyczdqymc').off('click');
		},
  },
});
