var nkgltj = require("./nkgltj.html");
var fxjsCommonFun = require("../../config/fxjsCommonFun.js");
avalon.component("nkgltj", {
  template: nkgltj,
  defaults: {
    searchData: {
      swjgDm: "",
      swjgmc: "",
      startDate: "",
      endDate: "",
      zbbh: "",
      zbmc: "",
    },
    showSwjg: "",
    showZbfw: "",
    zbfwType: 0,
    chartIndex: 1,
    option: {
      title: {
        text: "时间趋势柱状图",
        textStyle: {
          fontSize: 13,
        },
        left: 20,
      },
      color: ["#5470c6", "#91cc75", "#fac858"],
      legend: {},
      tooltip: {},
      xAxis: {
        type: "category",
        axisTick: { show: false },
        data: [],
      },
      yAxis: {},
      series: [
        {
          name: "事前",
          type: "bar",
          barGap: 0,
          emphasis: {
            focus: "series",
          },
          data: [],
        },
        {
          name: "事中",
          type: "bar",
          emphasis: {
            focus: "series",
          },
          data: [],
        },
        {
          name: "事后",
          type: "bar",
          emphasis: {
            focus: "series",
          },
          data: [],
        },
      ],
    },
    option1: {
      title: {
        text: "出口企业健康码户数占比",
      },
      tooltip: {},
      legend: {
        top: 20,
      },
      color: [
        "#e54d42",
        "#f37b1d",
        "#fbbd08",
        "#8dc63f",
        "#39b54a",
        "#1cbbb4",
        "#0081ff",
        "#6739b6",
        "#9c26b0",
        "#e03997",
        "#a5673f",
        "#8799a3",
        "#aaaaaa",
        "#333333",
        "#5470c6",
      ],
      series: [
        {
          type: "pie",
          radius: ["30%", "60%"],
          center: ["40%", "55%"],
          startAngle: 70,
          label: {
            normal: {
              position: "inner",
              show: false,
            },
          },
          labelLine: {
            show: true,
          },
          label: {
            //echarts饼图内部显示百分比设置
            show: true,
            position: "outside", //outside 外部显示  inside 内部显示
            formatter: `{d}%({c}件)`,
            // color: "#ffffff", //颜色
            fontSize: 12, //字体大小
          },
          data: [],
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: "rgba(0, 0, 0, 0.5)",
            },
          },
        },
      ],
    },
    activeIndex: "0",
    barYearOption: {},
    barQuarterOption: {},
    barMounthOption: {},
    barYearTable: [],
    barQuarterTable: [],
    barMounthTable: [],
    barShowTable: [],
    swjgShowTable: [],
    hjShowTable: [],
    zbShowTable: [],
    zbShowTableLeft: [],
    zbShowTableRight: [],
    pieHjOption: {},
    pieSwjgOption: {},
    pieZbOption: {},
    onInit: function (e) {
      avalonRoot.nkgltj = e.vmodel;
    },
    onReady: function () {
      this.initDate();
      this.initTree();
      this.initZBTree();
      this.hideTable();
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
      $(".nkgltj .datepicker.date-day").datetimepicker(options);
    },
    initTree: function () {
      var self = this;
      var setting = {
        callback: {
          onCheck: function (e, id, node) {
            var treeObj = $.fn.zTree.getZTreeObj("nkgltjSearchSwjg");
            var userNodes = treeObj.getCheckedNodes(true);
            let arr = [];
            let showArr = [];
            let count = 0;
            userNodes.forEach((item) => {
              if (item.level > count) {
                count = item.level;
              }
            });
            userNodes.forEach((item) => {
              if (item.level == count) {
                arr.push(item.id);
                showArr.push(item.text);
              }
            });
            self.searchData.swjgDm = arr;
            if (showArr.length == 0) {
              self.showSwjg = "";
            } else if (showArr.length <= 2) {
              self.showSwjg = showArr.join(",");
            } else if (showArr.length > 2) {
              self.showSwjg = "(" + showArr.length + ")项已选择";
            }
            return;
          },
        },
        data: { key: { children: "item", name: "text" } },
        view: {
          selectedMulti: true,
        },
        check: {
          enable: true,
        },
      };
      tools
        .getCachedSwjg(avalonRoot, ajax)
        .done(function (data) {
          let arr = [];
          arr = self.handleListLevel(data, 2, "id", "text", "item", self);
          $.fn.zTree.init($(".nkgltj .treeDiv"), setting, arr);
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".nkgltj").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".nkgltj").off("click");
    },
    showTable() {
      $(".table").show();
    },
    hideTable() {
      $(".table").hide();
    },
    initZBTree: function () {
      var self = this;
      var setting = {
        callback: {
          onCheck: function (e, id, node) {
            var treeObj = $.fn.zTree.getZTreeObj("nkgltjSearchZB");
            var userNodes = treeObj.getCheckedNodes(true);
            let arr = [];
            let showArr = [];
            let count = 0;
            userNodes.forEach((item) => {
              if (item.level > count) {
                count = item.level;
              }
            });
            userNodes.forEach((item) => {
              if (item.level == count) {
                arr.push(item.zbbh);
                showArr.push(item.zbmc);
              }
            });
            self.searchData.zbbh = arr;
            if (showArr.length == 0) {
              self.showZbfw = "";
            } else if (showArr.length <= 1) {
              self.showZbfw = showArr.join(",");
            } else if (showArr.length > 1) {
              self.showZbfw = "(" + showArr.length + ")项已选择";
            }
            return;
          },
        },
        data: { key: { children: "items", name: "zbmc" } },
        view: {
          selectedMulti: true,
        },
        check: {
          enable: true,
        },
      };
      api
        .getNkfxTree()
        .done(function (data) {
          let arr = [];
          if (self.zbfwType == 0) {
            arr = self.handleListLevel(
              [data.data],
              2,
              "zbbh",
              "zbmc",
              "items",
              self
            );
          } else {
            arr = self.handleListLevel(
              [data.data],
              3,
              "zbbh",
              "zbmc",
              "items",
              self
            );
          }
          $.fn.zTree.init($(".nkgltj .treeDiv1"), setting, arr);
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showZBTree: function (e) {
      var self = this;
      $(".treeDiv1", $(e.target).parent()).show();
      $(".nkgltj").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv1").find($(e.target)).length <= 0) {
          self.hideZBTree();
        }
      });
    },
    hideZBTree: function () {
      $(".treeDiv1").hide();
      $(".nkgltj").off("click");
    },
    search: function (pageNo) {
      var self = this;
      var valid = tools.checkDate(
        this.searchData.startDate,
        this.searchData.endDate
      );
      if (!valid) {
        tools.info("发生时间止不能小于发生时间起！");
        return;
      }
      if (!this.searchData.swjgDm || this.searchData.swjgDm.length == 0) {
        tools.info("请选择税务机关！");
        return;
      }
      if (!this.searchData.zbbh || this.searchData.zbbh.length == 0) {
        tools.info("请选择指标！");
        return;
      }
      let param = {};
      param.swjgDm = this.searchData.swjgDm;
      param.startDate = this.searchData.startDate;
      param.endDate = this.searchData.endDate;
      param.zbbh = this.searchData.zbbh;
      api.getNkfxStatistic(param).done((res) => {
        if (res.code == "0") {
          let data = res.data;
          self.setBarOption(data.sqList, data.szList, data.shList);
          self.handleBarTable(data.sqList, data.szList, data.shList);
          self.setPieOption(data.hjMap, data.swjgMap, data.zbList);
          self.handlePieTable(data.hjMap, data.swjgMap, data.zbList);
          if (this.chartIndex == 1) {
            if (self.activeIndex == "0") {
              $("#table").width((self.barMounthTable.length + 1) * 150);
              self.barShowTable = self.barMounthTable;
              self.initChartsData($("#nkgltj-chart1")[0], self.barMounthOption);
            } else if (self.activeIndex == "1") {
              $("#table").width((self.barQuarterTable.length + 1) * 150);
              self.barShowTable = self.barQuarterTable;
              self.initChartsData(
                $("#nkgltj-chart1")[0],
                self.barQuarterOption
              );
            } else {
              $("#table").width((self.barYearTable.length + 1) * 150);
              self.barShowTable = self.barYearTable;
              self.initChartsData($("#nkgltj-chart1")[0], self.barYearOption);
            }
          } else if (self.chartIndex == 2) {
            $("#swjgtable").width((self.swjgShowTable.length + 1) * 150);
            self.initChartsData($("#nkgltj-chart3")[0], self.pieSwjgOption);
          } else if (self.chartIndex == 3) {
            $("#hjtable").width((self.hjShowTable.length + 1) * 150);
            self.initChartsData($("#nkgltj-chart2")[0], self.pieHjOption);
          } else {
            self.initChartsData($("#nkgltj-chart4")[0], self.pieZbOption);
          }
        }
      });
      this.closeHyper();
      this.showTable();
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
    initChartsData: function (chart, options) {
      if (!chart) return;
      chart = echarts.init(chart);
      chart.setOption(options);
      window.addEventListener("resize", () => {
        chart.resize();
      });
    },
    setBarOption(sqList, szList, shList) {
      //按照月展示
      this.barMounthOption = tools.clone(this.option);
      for (let i = 0; i < sqList[2].length; i++) {
        this.barMounthOption.xAxis.data.push(sqList[2][i].rangeName);
        this.barMounthOption.series[0].data.push(sqList[2][i].number);
      }
      for (let i = 0; i < szList[2].length; i++) {
        this.barMounthOption.series[1].data.push(szList[2][i].number);
      }
      for (let i = 0; i < shList[2].length; i++) {
        this.barMounthOption.series[2].data.push(shList[2][i].number);
      }
      // this.initChartsData($("#nkgltj-chart1")[0], this.barMounthOption);
      //按照季度展示
      this.barQuarterOption = tools.clone(this.option);
      for (let i = 0; i < sqList[1].length; i++) {
        this.barQuarterOption.xAxis.data.push(sqList[1][i].rangeName);
        this.barQuarterOption.series[0].data.push(sqList[1][i].number);
      }
      for (let i = 0; i < szList[1].length; i++) {
        this.barQuarterOption.series[1].data.push(szList[1][i].number);
      }
      for (let i = 0; i < shList[1].length; i++) {
        this.barQuarterOption.series[2].data.push(shList[1][i].number);
      }
      // this.initChartsData($("#nkgltj-chart1")[0], this.barQuarterOption);
      //按照年展示
      this.barYearOption = tools.clone(this.option);
      for (let i = 0; i < sqList[0].length; i++) {
        this.barYearOption.xAxis.data.push(sqList[0][i].rangeName);
        this.barYearOption.series[0].data.push(sqList[0][i].number);
      }
      for (let i = 0; i < szList[0].length; i++) {
        this.barYearOption.series[1].data.push(szList[0][i].number);
      }
      for (let i = 0; i < shList[0].length; i++) {
        this.barYearOption.series[2].data.push(shList[0][i].number);
      }
      // this.initChartsData($("#nkgltj-chart1")[0], this.barYearOption);
    },
    handleBarTable(sqList, szList, shList) {
      //按照月展示表格
      this.barMounthTable = [];
      for (let i = 0; i < sqList[2].length; i++) {
        let obj = {};
        obj.name = sqList[2][i].rangeName;
        obj.sqNumber = sqList[2][i].number;
        obj.szNumber = szList[2][i].number;
        obj.shNumber = shList[2][i].number;
        this.barMounthTable.push(obj);
      }
      //按照季展示表格
      this.barQuarterTable = [];
      for (let i = 0; i < sqList[1].length; i++) {
        let obj = {};
        obj.name = sqList[1][i].rangeName;
        obj.sqNumber = sqList[1][i].number;
        obj.szNumber = szList[1][i].number;
        obj.shNumber = shList[1][i].number;
        this.barQuarterTable.push(obj);
      }
      //按照年展示表格
      this.barYearTable = [];
      for (let i = 0; i < sqList[0].length; i++) {
        let obj = {};
        obj.name = sqList[0][i].rangeName;
        obj.sqNumber = sqList[0][i].number;
        obj.szNumber = szList[0][i].number;
        obj.shNumber = shList[0][i].number;
        this.barYearTable.push(obj);
      }
    },
    setPieOption(hjMap, swjgMap, zbList) {
      //按环节饼状图
      this.pieHjOption = tools.clone(this.option1);
      this.pieHjOption.title.text = "按环节占比";
      for (let key in hjMap) {
        this.pieHjOption.series[0].data.push({
          value: hjMap[key],
          name: key,
        });
      }
      this.initChartsData($("#nkgltj-chart2")[0], this.pieHjOption);
      //按机关饼状图
      this.pieSwjgOption = tools.clone(this.option1);
      this.pieSwjgOption.title.text = "按税务机关占比";
      for (let key in swjgMap) {
        this.pieSwjgOption.series[0].data.push({
          value: swjgMap[key],
          name: key,
        });
      }
      this.initChartsData($("#nkgltj-chart3")[0], this.pieSwjgOption);
      //按指标类型饼状图
      this.pieZbOption = tools.clone(this.option1);
      this.pieZbOption.title.text = "按指标类型占比";
      let arr = [];
      for (let i = 0; i < zbList.length; i++) {
        let obj = {};
        obj.name = zbList[i].zbbh;
        obj.value = zbList[i].number;
        arr.push(obj);
      }
      arr.sort(function (a, b) {
        return b.value - a.value;
      });
      if (arr.length <= 10) {
        this.pieZbOption.series[0].data = arr;
      } else {
        for (let i = 0; i < 10; i++) {
          this.pieZbOption.series[0].data.push(arr[i]);
        }
        let countNumber = 0;
        for (let i = 10; i < arr.length; i++) {
          countNumber += arr[i].value;
        }
        this.pieZbOption.series[0].data.push({
          name: "其他",
          value: countNumber,
        });
      }
      this.initChartsData($("#nkgltj-chart4")[0], this.pieZbOption);
    },
    handlePieTable(hjMap, swjgMap, zbList) {
      this.hjShowTable = [];
      let hjCount = 0;
      for (let key in hjMap) {
        let obj = {};
        obj.name = key;
        obj.number = hjMap[key];
        hjCount += obj.number;
        this.hjShowTable.push(obj);
      }
      this.hjShowTable.forEach((item) => {
        item.percent = (100 * (item.number / hjCount)).toFixed(2);
      });
      this.swjgShowTable = [];
      let swjgCount = 0;
      for (let key in swjgMap) {
        let obj = {};
        obj.name = key;
        obj.number = swjgMap[key];
        swjgCount += obj.number;
        this.swjgShowTable.push(obj);
      }
      this.swjgShowTable.forEach((item) => {
        item.percent = (100 * (item.number / swjgCount)).toFixed(2);
      });
      this.zbShowTable = [];
      let arr = [];
      let zbCount = 0;
      for (let i = 0; i < zbList.length; i++) {
        let obj = {};
        obj.name = zbList[i].zbmc;
        obj.number = zbList[i].number;
        obj.zbbh = zbList[i].zbbh;
        zbCount += obj.number;
        arr.push(obj);
      }
      arr.forEach((item) => {
        item.percent = (100 * (item.number / zbCount)).toFixed(2);
      });
      arr.sort(function (a, b) {
        return b.number - a.number;
      });
      this.zbShowTable = arr;
      for (let i = 0; i < this.zbShowTable.length; i++){
        if(i % 2 !== 0){
          this.zbShowTableLeft.push(this.zbShowTable[i])
        }else{
          this.zbShowTableRight.push(this.zbShowTable[i])
        }
      }
    },
    changeTab: function (index) {
      this.activeIndex = index;
      if (this.chartIndex == 1) {
        if (this.activeIndex == "0") {
          $("#table").width((this.barMounthTable.length + 1) * 150);
          this.barShowTable = this.barMounthTable;
          this.initChartsData($("#nkgltj-chart1")[0], this.barMounthOption);
        } else if (this.activeIndex == "1") {
          $("#table").width((this.barQuarterTable.length + 1) * 150);
          this.barShowTable = this.barQuarterTable;
          this.initChartsData($("#nkgltj-chart1")[0], this.barQuarterOption);
        } else {
          $("#table").width((this.barYearTable.length + 1) * 150);
          this.barShowTable = this.barYearTable;
          this.initChartsData($("#nkgltj-chart1")[0], this.barYearOption);
        }
      }
    },
    reset: function () {
      this.searchData = {
        swjgDm: "",
        swjgmc: "",
        startDate: "",
        endDate: "",
        zbbh: "",
        zbmc: "",
      };
      this.showSwjg = "";
      this.showZbfw = "";
    },
    handleListLevel(data, level, id, name, children, self, currentLevel = 0) {
      if (currentLevel >= level) {
        return "";
      }
      return data.map((item) => {
        const newItem = {};
        newItem[id] = item[id];
        newItem[name] = item[name];
        if (item[children]) {
          newItem[children] = self.handleListLevel(
            item[children],
            level,
            id,
            name,
            children,
            self,
            currentLevel + 1
          );
        }
        return newItem;
      });
    },
    showHyper: function () {
      $(".nkgltj .select-sub").toggle();
      $(".nkgltj .select-wrapper .icon").toggleClass("active");
      if (
        $(".nkgltj .select-wrapper .icon").attr("title").slice(0, 2) === "展开"
      ) {
        $(".nkgltj .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".nkgltj .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".nkgltj .select-sub").hide();
      $(".nkgltj .select-wrapper .icon").removeClass("active");
      $(".nkgltj .select-wrapper .icon").attr("title", "展开查询条件");
    },
    onchange(e) {
      this.initZBTree();
      this.showZbfw = "";
      this.searchData.zbbh = [];
    },
    showMenu: function (e) {
      var self = this;
      $(".dropdown-menu", e.target).show();
      $(".nkgltj").on("click", function (e) {
        var e = e || window.event;
        if ($(".dropdown-menu").find($(e.target)).length <= 0) {
          self.hideMenu();
        }
      });
    },
    hideMenu: function () {
      $(".dropdown-menu").hide();
      $(".nkgltj").off("click");
    },
    setTableOption(val, e) {
      this.chartIndex = $("input[name='dropdown']:checked").val();
      if (this.chartIndex == 1) {
        if (this.activeIndex == "0") {
          $("#table").width((this.barMounthTable.length + 1) * 150);
          this.barShowTable = this.barMounthTable;
          this.initChartsData($("#nkgltj-chart1")[0], this.barMounthOption);
        } else if (this.activeIndex == "1") {
          $("#table").width((this.barQuarterTable.length + 1) * 150);
          this.barShowTable = this.barQuarterTable;
          this.initChartsData($("#nkgltj-chart1")[0], this.barQuarterOption);
        } else {
          $("#table").width((this.barYearTable.length + 1) * 150);
          this.barShowTable = this.barYearTable;
          this.initChartsData($("#nkgltj-chart1")[0], this.barYearOption);
        }
      } else if (this.chartIndex == 2) {
        $("#swjgtable").width((this.swjgShowTable.length + 1) * 150);
        this.initChartsData($("#nkgltj-chart3")[0], this.pieSwjgOption);
      } else if (this.chartIndex == 3) {
        $("#hjtable").width((this.hjShowTable.length + 1) * 150);
        this.initChartsData($("#nkgltj-chart2")[0], this.pieHjOption);
      } else {
        this.initChartsData($("#nkgltj-chart4")[0], this.pieZbOption);
      }
    },
  },
});
