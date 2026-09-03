var shmxcx = require("./shmxcx.html");
var fxjsCommonFun = require('../../config/fxjsCommonFun.js');
avalon.component("shmxcx", {
  template: shmxcx,
  defaults: {
    params: {},
    act: 1,
    // tcode: "scqysbxxcx",
    tcode: "cqwsbMxsh",
    tsjgmc: "",
    selRows: [],
    contents: [],
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
    jdxz_mc:'',
    selectMc:{
      name:'',
      value:'',
    },
    qytjSearchType:'nsrsbh',
    rqSearchType:'ckrq',
    ssqSearchType:'sbssq',
    qyqrxxSearchType:'ckfphm',
    hasHsPermission: false, // 是否有核实处理权限
    searchData: {
      zgswjgks: "",
      jdxzDm:'',
      tsjsfs:'',
      nsrsbh:'',
      qyhgdm:'',
      nsrmc:'',
      ckpzhm:'',
      ckrqQ:'',
      ckrqZ:'',
      cjrqQ:'',
      cjrqZ:'',
      qrrqQ:'',
      qrrqZ:'',
      jsrqQ:'',
      jsrqZ:'',
      jgfsdm:null,
      qyqrzt:'',
      ckfphm:'',
      jhpzhm:'',
      jszt:'',
      swshzt:'',
      shry:'',
      jsdm:"",
      sbssq:"",
      jxzcssq:"",
      orderSql: "",
      pageSize: config.pageSize,
      keyValue:'1',
      swjgDm:''
    },
    firstSwjgdm: "",
    firstSwjgMc: "",
    swjgMc:'',
    modelData: {
      uuid: "",
      djxh: "",
      nsrsbh: "",
      nsrmc: "",
      ckbgdh: "",
      ckrq1: "",
      ckspDm: "",
      gfhhgspmc: "",
      mylaj: "",
      rmblaj: "",
      dyjldwDm: "",
      cksl: "",
      qyqrZt: "",
      qyqrRq: "",
      zmsSbssq: "",
      zsYsxse: "",
      zsJtxxse: "",
      zmsCkfphm: "",
      msMsxse: "",
      msJhpzhbz: "",
      msJhpzh: "",
      msJxzcbz: "",
      msJxzcssq: "",
      msJxzcje: "",
      zmsFj: "",
      zmsBz: "",
      wsbYylx: "",
      wsbYysm: "",
      swshZt: "",
      swshHtyj: "",
      swshRq: "",
      sjly: "",
      zmtbz: "",
      tsjsffdm: "",
      jgfsDm: null,
      zsl: "",
      tsl: "",
      wsbsl: "",
      cjrq: "",
      zmtzt: "",
      swshRy: "",
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
    submitData: {
      djxh: "",
      ckbgdh: "",
      swshZt: "",
      swshHtyj: "",
    },
    htrzData: {
      djxh: "",
      ckpzhm: "",
      pageSize: config.pageSize,
    },
    jsList:[],
    groupList: [],
    tableRowList: [],
    modelAddStyle: {
      0: {
        width: "960px",
        marginLeft: "-480px",
        height: "540px",
        marginTop: "-270px",
        contentHeight: "460px",
      },
      1: {
        width: "600px",
        marginLeft: "-300px",
        height: "300px",
        marginTop: "-150px",
        contentHeight: "200px",
      },
    },
    showCm: [],
    addIndex: 0,
    onReady: function () {
      var self = this;
      var promise = this.getTableRow();
      self.tsjgmc = avalonRoot.user.swjgMc;
      self.searchData.zgswjgks = avalonRoot.user.swjgDm;
      this.hasHsPermission =
        this.swjgList.indexOf(avalonRoot.user.swjgDm) == -1;
        self.getQueryCriteria()
      let key = avalonRoot.user.czryDm + 'shmxcxZTS'
      const savedValue = localStorage.getItem(key);
      if (savedValue === "1" || savedValue === "2") {
          this.searchData.keyValue = savedValue;
      } else {
          this.searchData.keyValue = "1"; // 默认值
      }
      self.initTree();
      self.initTreeTuishui();
      self.initStreetTree();
      self.getJsyj();
      // this.createTableAddCkyw();
      $(".shmxcx .datepicker.date-day").datepicker({
        dateFormat: "yy-mm-dd",
      });
      $(".shmxcx .datepicker.date-month").datepicker({
        dateFormat: "yymm",
      });
      window.SHMXCX_SEARCH = this.normalSearch;
    },
    changeTab: function (num) {
      this.act = num;
    },
    //copy bg
    getTableRow: function () {
      return new Promise((resolve) => {
        var self = this;
        ajax("POST", "/cxfw/basis/columprofile", { tcode: self.tcode })
          .done(function (res) {
            if (res.code == "0") {
              var arr = res.data.profiles;
              self.tableRowList = arr;
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
                if (obj.name == "ckbgdh") {
                  obj.formatter = function (cellvalue, options, rowObject) {
                    return (
                      "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='ckbgdh'>" +
                      cellvalue +
                      "</span>"
                    );
                  };
                }
                if (obj.name == "swshZt") {
                  obj.formatter = function (cellvalue, options, rowObject) {
                    var colorMap = {
                      '未审核':'#000000',
                      '审核通过':'#5CBB7A',
                      '退回':'#F56C6C'
                    }
                    return (
                      "<span style='color:"+colorMap[cellvalue]+";'>" +
                      cellvalue +
                      "</span>"
                    );
                  };
                }
                if (obj.name == "jsZt") {
                  obj.formatter = function (cellvalue, options, rowObject) {
                    var colorMap = {
                      '未审核':'#000000',
                      '机审通过':'#5CBB7A',
                      '机审有意见':'#E6A23C'
                    }
                    return (
                      "<span style='color:"+colorMap[cellvalue]+";'>" +
                      cellvalue +
                      "</span>"
                    );
                  };
                }
                if (arr[i].degree) {
                  var degree = arr[i].degree;
                  obj.formatter = function (cellvalue, options, rowObject) {
                    return cellvalue || cellvalue === 0
                      ? avalon.filters.number(cellvalue, degree)
                      : "";
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
              resolve();
            } else {
              tools.info(res.msg);
            }
          })
          .fail(function (err) {
            tools.info(err);
          });
      });
    },
    createTable: function (arr) {
      var btnName = "查看";
      var hasHsPermission = this.hasHsPermission;
      var self = this;
      var cm = [];
      for (var i = 0; i < arr.length; i++) {
        cm[i] = tools.clone(arr[i]);
      }
      this.showCm = cm;
      let uuid = {
        name: "uuid",
        label: "uuid",
        index: "uuid",
        hidden: true,
        width: 140,
        align: "left",
        sortable: false,
      };
      let djxh = {
        name: "djxh",
        label: "登记序号",
        index: "djxh",
        hidden: true,
        width: 140,
        align: "left",
        sortable: false,
      };
      let zmsFj = {
        name: "zmsFj",
        label: "附件",
        index: "zmsFj",
        hidden: true,
        width: 140,
        align: "left",
        sortable: false,
      };
      cm.unshift(uuid);
      cm.push(djxh);
      cm.push(zmsFj);
      $("#shmxcx-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: cm,
        viewrecords: true,
        rownumbers: true,
        pager: "#shmxcx-tablePager",
        shrinkToFit: false,
        width: "100%",
        // multiselect: true,
        // multiselectWidth: "40",
        autowidth: true,
        altRows: true,
        // footerrow:true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".shmxcx .form").height() - 94;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#shmxcx-table").jqGrid("getRowData", rowid);
          var obj = self.tableData.rows[rowid - 1];
          if ($(e.target).hasClass("ckbgdh")) {
            var isSh =hasHsPermission &&(obj.qyqrZt=='适用征税'||obj.qyqrZt=='适用免税'||obj.qyqrZt=='已全部退税'||obj.qyqrZt=='非销售业务') && (obj.swshZt=='未审核'||obj.swshZt=='审核通过')&& (obj.sjly != "SYSTEM" || obj.zmtbz == '可退税') 
              if(!isSh){
                var params = {
                  row: obj,
                  title: "查看",
                };
                avalonRoot.addTab({
                  title: "审核明细查看",
                  component: "shmxcxEdit",
                  params: params,
                  repeatCheck: true,
                });
              }else{
                var params = {
                  row: obj,
                  title: "审核",
                };
                avalonRoot.addTab({
                  title: "审核",
                  component: "shmxcxEdit",
                  params: params,
                  repeatCheck: true,
                });
              }
            return false;
          }  else if (e.target.nodeName == "TD") {
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
          let name = "";
          if (self.tableRowList[iCol - 1].f1) {
            name = self.tableRowList[iCol - 1].f1;
          } else {
            name = index;
          }
          var sortName = ''
          if(name == 'nsrsbh'){
            sortName = 'a.nsrsbh'
          }else if(name == 'ckbgdh'){
            sortName = 'a.CKBGDH'
          }else if(name == 'ckrq1'){
            sortName = 'a.CKRQ_1'
          }else if(name == 'ckspDm'){
            sortName = 'a.CKSP_DM'
          }else if(name == 'qyqrZt'){
            sortName = 'a.QYQR_ZT'
          }else if(name == 'jsZt'){
            sortName = 'a.js_zt'
          }
          self.searchData.orderSql = sortName + " " + sortorder;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "shmxcx-table");
          self.search(pageNo);
        },
        onSelectRow: function (rowid, status) {
          var index = self.selRows.indexOf(rowid);
          if (status) {
            self.selRows.push(rowid);
          } else {
            self.selRows.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          if (status) {
            self.selRows = JSON.parse(JSON.stringify(rowids));
          } else {
            self.selRows = [];
          }
          // self.checkboxInit(self.tableData);
        },
        gridComplete: function () {
          var ids = $("#shmxcx-table").getDataIDs();
          for (var i = 0; i < ids.length; i++) {
            var rowData = $("#shmxcx-table").getRowData(ids[i]);
            var isSh = hasHsPermission &&(rowData.qyqrZt=='适用征税'||rowData.qyqrZt=='适用免税'||rowData.qyqrZt=='已全部退税'||rowData.qyqrZt=='非销售业务') && rowData.swshZt=='未审核'&&( rowData.sjly != "SYSTEM" || rowData.zmtbz == '可退税' )
            if (isSh) {
              $('#shmxcx-table '+"#" + ids[i])
                .find("td")
                .css("background", "#d9ecff");
            }
          }
        },
      });
      $("#shmxcx-table").jqGrid("setGroupHeaders", {
        useColSpanStyle: true,
        groupHeaders: [
          {
            startColumnName: "nsrsbh",
            numberOfColumns: 3,
            titleText: "企业基本信息",
          },
          {
            startColumnName: "ckbgdh",
            numberOfColumns: 2,
            titleText: "审核摘要",
          },
          {
            startColumnName: "jsZt",
            numberOfColumns: 3,
            titleText: "机审信息",
          },
          {
            startColumnName: "swshZt",
            numberOfColumns: 4,
            titleText: "人工审核信息",
          },
          {
            startColumnName: "ckrq1",
            numberOfColumns: 13,
            titleText: "报关单信息",
          },
          {
            startColumnName: "qyqrRq",
            numberOfColumns: 15,
            titleText: "企业确认信息",
          },
        ],
      });
      this.searchData.pageSize = $(".ui-pg-selbox", $(".shmxcx")).val();
      if(hasHsPermission){
        var promptTextSpan = document.createElement('span');
        // 设置 span 的内容和样式
        promptTextSpan.className = 'prompt-text'; // 可以通过CSS进一步控制样式
        promptTextSpan.style.marginLeft = '15px'; // 根据需要调整样式
        promptTextSpan.textContent = '注：表格中底色为蓝色的行表示待审核业务';
        // 获取目标 div
        var pagerLeftDiv = document.getElementById('shmxcx-tablePager_left');
        if (pagerLeftDiv) {
            // 直接在 #dshywcl-tablePager_left 内部添加新的 span
            pagerLeftDiv.appendChild(promptTextSpan);
        }
      }
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
    changeZTS(){
      let key = avalonRoot.user.czryDm + 'shmxcxZTS'
      localStorage.setItem(key, this.searchData.keyValue);
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
          $("#shmxcx-table").showCol(self.tableOption[i].name);
        } else {
          $("#shmxcx-table").hideCol(self.tableOption[i].name);
        }
      }
      $("#shmxcx-table").setGridWidth($(".shmxcx").width());
    },
    normalSearch() {
      this.searchData.orderSql = "";
      $(".s-ico").hide();
      this.search(1);
    },
    search: function (pageNo) {
      var self = this;
      var dataValid = [
        { start: "ckrqQ", end: "ckrqZ", msg: "出口日期" },
        { start: "qrrqQ", end: "qrrqZ", msg: "确认日期" },
        { start: "cjrqQ", end: "cjrqZ", msg: "新增日期" },
        { start: "jsrqQ", end: "jsrqZ", msg: "机审日期" },
      ];
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
      this.searchData.pageSize = $(".ui-pg-selbox", $(".shmxcx")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      if(params.keyValue == '1'){
        params.swjgDm = ""
      }else{
        params.zgswjgks = "";
        params.swjgdm = params.swjgDm
        delete params.swjgDm;
      }
      self.contents = [];
      $("#shmxcx-table").jqGrid("clearGridData");
      ajax("POST", "/cxfw/cqwsb/shmx/list", params)
        .done(function (res) {
          if (res.code == "0") {
            self.tableData = res.data;
            $("#shmxcx-table").resetSelection();
            $("#shmxcx-table")[0].addJSONData(res.data);
            self.contents = res.data.rows;
            self.selRows = [];
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
      $(".shmxcx .select-sub").toggle();
      $(".shmxcx .select-wrapper .icon").toggleClass("active");
      if (
        $(".shmxcx .select-wrapper .icon").attr("title").slice(0, 2) === "展开"
      ) {
        $(".shmxcx .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".shmxcx .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".shmxcx .select-sub").hide();
      $(".shmxcx .select-wrapper .icon").removeClass("active");
      $(".shmxcx .select-wrapper .icon").attr("title", "展开查询条件");
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
      $(".shmxcx").on("click", function (e) {
        var e = e || window.event;
        if ($(".dropdown-menu").find($(e.target)).length <= 0) {
          self.hideMenu();
        }
      });
    },
    hideMenu: function () {
      $(".dropdown-menu").hide();
      $(".shmxcx").off("click");
    },
    //copy
    initTree: function () {
      var self = this;
      var setting = {
        callback: {
          onClick: function (e, id, node) {
            self.searchData.zgswjgks = node.id;
            self.tsjgmc = node.text;
            self.hideTree();
            return;
          },
          onDblClick: function (e, id, node) {
            self.searchData.zgswjgks = node.id;
            self.tsjgmc = node.text;
            self.hideTree();
            return;
          },
        },
        data: { key: { children: "item", name: "text" } },
      };
      ajax("POST","/cxfw/export/readtree",{nodeType:"4"}).done(function(res){
        if(res.code=='0'){
            var data = self.replaceEmptyItemWithNull(res.data)
            $.fn.zTree.init($(".shmxcx #shmxcxtree"), setting, data);
        }else{
            tools.info(res.msg)
        }
    }).fail(function(err){
        tools.info(err)
    })
    },
     initTreeTuishui: function () {
      var self = this;
      var setting = {
        callback: {
          onClick: function (e, id, node) {
            self.searchData.swjgDm = node.id;
            self.swjgMc = node.text;
            self.hideTree();
            return;
          },
          onDblClick: function (e, id, node) {
            self.searchData.swjgDm = node.id;
            self.swjgMc = node.text;
            self.hideTree();
            return;
          },
        },
        data: { key: { children: "item", name: "text" } },
      };
      ajax("POST", "/cxfw/export/readtree", { nodeType: "3" })
        .done(function (res) {
          if (res.code == "0") {
            var data = self.replaceEmptyItemWithNull(res.data);
            $.fn.zTree.init($(".shmxcx #shmxcxtreeTs"), setting, data);
            if(data.length){
              self.swjgMc = data[0].text;
              self.firstSwjgMc = data[0].text;
              self.firstSwjgdm = data[0].id;
              self.searchData.swjgDm = data[0].id;
            }

          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    initStreetTree:function(){
      var self = this;
      var setting = {
          callback:{
              onClick:function(e,id,node){
                  self.searchData.jdxzDm = node.id;
                  self.jdxz_mc = node.text;
                  self.hideTree();
                  return;
              },
              onDblClick:function(e,id,node){
                  self.searchData.jdxzDm = node.id;
                  self.jdxz_mc = node.text;
                  self.hideTree();
                  return;
              }
          },
          data:{key:{children:"item",name:"text"}}
      };
      ajax("POST","/cxfw/common/streetTree",{}).done(function(res){
          if(res.code=='0'){
              $.fn.zTree.init($(".shmxcx #shmxcxJdxz"), setting, res.data);
          }else{
              tools.info(res.msg)
          }
      }).fail(function(err){
          tools.info(err)
      })
  },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".shmxcx").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".shmxcx").off("click");
    },
    exform: function () {
      var self = this;
      if ($("#shmxcx-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData);
      if(params.keyValue == '1'){
        params.swjgDm = ""
      }else{
        params.zgswjgks = "";
        params.swjgdm = params.swjgDm
        delete params.swjgDm;
      }
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      // form.attr("target", "_blank")
      form.attr("method", "post");
      form.attr("action", "/cxfw/cqwsb/shmx/list/export");
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
        zgswjgks: avalonRoot.user.swjgDm,
        jdxzDm:'',
        tsjsfs:'',
        nsrsbh:'',
        qyhgdm:'',
        nsrmc:'',
        ckpzhm:'',
        ckrqQ:'',
        ckrqZ:'',
        cjrqQ:'',
        cjrqZ:'',
        qrrqQ:'',
        qrrqZ:'',
        jsrqQ:'',
        jsrqZ:'',
        jgfsdm:null,
        qyqrzt:'',
        ckfphm:'',
        jhpzhm:'',
        jszt:'',
        swshzt:'',
        shry:'',
        jsdm:"",
        sbssq:"",
        jxzcssq:"",
        orderSql: "",
        pageSize: config.pageSize,
        keyValue:'1',
        swjgDm:this.firstSwjgdm
      };
      this.tsjgmc = avalonRoot.user.swjgMc;
      this.swjgMc = this.firstSwjgMc
      this.jdxz_mc = '';
      this.changeZTS()
    },
    showModel: function (title) {
      this.addTitle = title;
      if (title == "新增") {
        this.modelData = {
          uuid: "",
          djxh: "",
          nsrsbh: "",
          nsrmc: "",
          ckbgdh: "",
          ckrq1: "",
          ckspDm: "",
          gfhhgspmc: "",
          mylaj: "",
          rmblaj: "",
          dyjldwDm: "",
          cksl: "",
          qyqrZt: "",
          qyqrRq: "",
          zmsSbssq: "",
          zsYsxse: "",
          zsJtxxse: "",
          zmsCkfphm: "",
          msMsxse: "",
          msJhpzhbz: "",
          msJhpzh: "",
          msJxzcbz: "",
          msJxzcssq: "",
          msJxzcje: "",
          zmsFj: "",
          zmsBz: "",
          wsbYylx: "",
          wsbYysm: "",
          swshZt: "",
          swshHtyj: "",
          swshRq: "",
          sjly: "",
          zmtbz: "",
          tsjsffdm: "",
          jgfsDm: null,
          zsl: "",
          tsl: "",
          wsbsl: "",
          cjrq: "",
          zmtzt: "",
          swshRy: "",
        };
      }
      $(".model").show();
      $(".shmxcx .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".shmxcx .add-page-model").hide();
    },
    showHandleModel: function (title) {
      $(".model").show();
      $(".shmxcx .page-model-add").show();
      this.searchCkyw(1);
    },
    hideHandleModel: function () {
      $(".model").hide();
      $(".shmxcx .page-model-add").hide();
      this.submitData = {
        djxh: "",
        ckbgdh: "",
        swshZt: "",
        swshHtyj: "",
      };
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
    createTableAddCkyw: function () {
      var self = this;
      var columns = [
        {
          name: "ckbgdh",
          label: "报关单号/代理证明号",
          index: "ckbgdh",
          width: 180,
          align: "left",
          sortable: true,
        },
        {
          name: "qyqrRq",
          label: "企业确认时间",
          index: "qyqrRq",
          width: 100,
          align: "center",
          sortable: true,
        },
        {
          name: "qyqrZt",
          label: "企业确认状态",
          index: "qyqrZt",
          width: 90,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = {
              0: "未确认",
              1: "适用征税",
              2: "适用免税",
              3: "已全部退税",
              4: "待申报退税",
            };
            return map[cellvalue] ? map[cellvalue] : "";
          },
        },
        {
          name: "swshHtyj",
          label: "审核意见",
          index: "swshHtyj",
          width: 140,
          align: "left",
          sortable: true,
        },
        {
          name: "swshRq",
          label: "审核时间",
          index: "swshRq",
          width: 100,
          align: "center",
          sortable: true,
        },
        {
          name: "swshRy",
          label: "审核人员",
          index: "swshRy",
          width: 90,
          align: "center",
          sortable: true,
        },
        {
          name: "swshZt",
          label: "审核状态",
          index: "swshZt",
          width: 90,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { 1: "未审核", 2: "审核通过", 3: "退回" };
            return map[cellvalue] ? map[cellvalue] : "";
          },
        },
        {
          name: "zmsFj",
          label: "附件",
          index: "zmsFj",
          width: 50,
          align: "right",
          sortable: true,
        },
        {
          name: "zmsSbssq",
          label: "申报所属期",
          index: "zmsSbssq",
          width: 70,
          align: "center",
          sortable: true,
        },
        {
          name: "zmsCkfphm",
          label: "出口发票号码",
          index: "zmsCkfphm",
          width: 100,
          align: "left",
          sortable: true,
        },
        {
          name: "zsJtxxse",
          label: "计提销项税额",
          index: "zsJtxxse",
          width: 90,
          align: "right",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            return cellvalue || cellvalue === 0
              ? avalon.filters.number(cellvalue, 2)
              : "";
          },
        },
        {
          name: "zsYsxse",
          label: "应税销售额",
          index: "zsYsxse",
          width: 90,
          align: "right",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            return cellvalue || cellvalue === 0
              ? avalon.filters.number(cellvalue, 2)
              : "";
          },
        },
        {
          name: "msJhpzh",
          label: "进货凭证号",
          index: "msJhpzh",
          width: 100,
          align: "left",
          sortable: true,
        },
        {
          name: "msJhpzhbz",
          label: "进货凭证号标志",
          index: "msJhpzhbz",
          width: 100,
          align: "left",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { 0: "无", 1: "有" };
            return map[cellvalue] ? map[cellvalue] : "";
          },
        },
        {
          name: "msJxzcbz",
          label: "进项转出标志",
          index: "msJxzcbz",
          width: 100,
          align: "left",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { 0: "无", 1: "有" };
            return map[cellvalue] ? map[cellvalue] : "";
          },
        },
        {
          name: "msJxzcje",
          label: "进项转出金额",
          index: "msJxzcje",
          width: 100,
          align: "right",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            return cellvalue || cellvalue === 0
              ? avalon.filters.number(cellvalue, 2)
              : "";
          },
        },
        {
          name: "msJxzcssq",
          label: "进项转出所属期",
          index: "msJxzcssq",
          width: 100,
          align: "left",
          sortable: true,
        },
        {
          name: "msMsxse",
          label: "免税销售额",
          index: "msMsxse",
          width: 100,
          align: "right",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            return cellvalue || cellvalue === 0
              ? avalon.filters.number(cellvalue, 2)
              : "";
          },
        },
        {
          name: "wsbYylx",
          label: "未申报原因类型",
          index: "wsbYylx",
          width: 100,
          align: "left",
          sortable: true,
        },
        {
          name: "wsbYysm",
          label: "具体原因说明",
          index: "wsbYysm",
          width: 100,
          align: "left",
          sortable: true,
        },
        {
          name: "zmsBz",
          label: "备注",
          index: "zmsBz",
          width: 100,
          align: "left",
          sortable: true,
        },
      ];
      $("#shmxcx-ckyw-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        rownumbers: true,
        shrinkToFit: false,
        autoScroll: true,
        // multiselect: true,
        viewrecords: true,
        pager: "#shmxcx-ckyw-tablePager",
        // multiselectWidth:"30",
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        width: 960,
        height: 250,
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "shmxcx-ckyw-table");
          self.searchCkyw(pageNo);
        },
      });
      this.htrzData.pageSize = $(
        ".ui-pg-selbox",
        $(".shmxcx .page-model-add")
      ).val();
    },
    searchCkyw(pageNo) {
      var self = this;
      this.htrzData.pageSize = $(
        ".ui-pg-selbox",
        $(".shmxcx .page-model-add")
      ).val();

      var params = tools.clone(self.htrzData);
      params.pageNo = pageNo;
      $("#shmxcx-ckyw-table").jqGrid("clearGridData");
      ajax("POST", "/cxfw/cqwsb/shmx/htrz/list", params)
        .done(function (res) {
          if (res.code == "0") {
            // self.tableData = res.data;
            $("#shmxcx-ckyw-table").resetSelection();
            $("#shmxcx-ckyw-table")[0].addJSONData(res.data);
            // self.closeHyper();
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    shConfirm() {
      var self = this;
      var params = tools.clone(self.submitData);
      if (!this.submitData.swshZt) {
        tools.info("请选择税务审核状态");
        return;
      }
      if (this.submitData.swshZt == 2 && !this.submitData.swshHtyj) {
        tools.info("税务审核意见不能为空");
        return;
      }
      ajax("POST", "/cxfw/cqwsb/shmx/submit", params).done(function (res) {
        if (res.code == "0") {
          tools.info("审核提交成功");
          self.hideHandleModel();
          self.search(1);
        } else {
          tools.info(res.msg);
        }
      });
    },
    review() {
      if (this.selRows.length <= 0) {
        tools.info("请先选择要操作的项！");
        return;
      }
      if (this.selRows.length > 1) {
        tools.info("单次审核只支持选择一条数据！");
        return;
      }
      var rowData = $("#shmxcx-table").getRowData(this.selRows[0]);
      var isSh =
        (this.hasHsPermission &&
          rowData.swshZt == "未审核" &&
          (rowData.qyqrZt == "适用征税" || rowData.qyqrZt == "适用免税")) ||
        (rowData.zmtbz == "征税" && rowData.qyqrZt == "适用免税");
      if (isSh) {
        var htmlString = rowData.ckbgdh;
        const regex = /<span[^>]*>(.*?)<\/span>/;
        const match = htmlString.match(regex);
        var spanContent = "";
        if (match && match.length > 1) {
          spanContent = match[1];
        }
        rowData.ckbgdh = spanContent;
        var params = {
          row: rowData,
          title: "审核",
        };
        avalonRoot.addTab({
          title: "审核",
          component: "shmxcxEdit",
          params: params,
          repeatCheck: true,
        });
      } else {
        tools.info("选择的数据列没有审核权限！");
        return;
      }
    },
    qytjSearchTypeChg(){
      this.searchData.nsrsbh = ''
      this.searchData.qyhgdm = ''
      this.searchData.nsrmc = ''
    },
    rqSearchTypeChg(){
      this.searchData.ckrqQ = ''
      this.searchData.ckrqZ = ''
      this.searchData.cjrqQ = ''
      this.searchData.cjrqZ = ''
      this.searchData.qrrqQ = ''
      this.searchData.qrrqZ = ''
      this.searchData.jsrqQ = ''
      this.searchData.jsrqZ = ''
    },
    ssqSearchTypeChg(){
      this.searchData.sbssq = ''
      this.searchData.jxzcssq = ''
    },
    qyqrxxSearchTypeChg(){
      this.searchData.ckfphm = ''
      this.searchData.jhpzhm = ''
    },
    replaceEmptyItemWithNull(data) {
      // 遍历数组中的每个对象
      return data.map(item => {
          // 如果 item 存在且是空数组，则将其设置为 null
          if (Array.isArray(item.item) && item.item.length === 0) {
              item.item = null;
          }
          // 如果 item 中还有嵌套的 item，则递归处理
          if (Array.isArray(item.item)) {
              item.item = this.replaceEmptyItemWithNull(item.item);
          }
          return item;
      });
    },
    getQueryCriteria: function(){
      var self = this
      ajax("POST","/bjtssw/sjjc/dynamic/init").done(function(res){
        if(res.code=='0'){
          var data = res.data
          var selectData = data.fzItemsTs.filter(item => item.zbxmmc == '贸易方式');
          self.initSelectTree('shmxcxJgfs',selectData[0].values)
        }else{
          tools.info(res.msg);
        }
      }).fail(function(err){
        tools.info(err);
      })
    },
    // 下拉列表树
      initSelectTree:function(id, treelistOrParams) {
        var self = this;
        var domId = id
        var setting = {
          check:{
            enable: true
          },
          view: {
            selectedMulti: false
          },
          data:{
            simpleData:{
              enable: true,
              idKey: "code",
            },
            key:{children:"item",name:"name"}
          },
          callback:{
            onCheck:function(e,id,node){
              self.treeCheckHandler(domId)
              return;
            }
          }
        };
        $.fn.zTree.init($('#'+domId), setting, treelistOrParams);
      },
      // 选中后赋值
      treeCheckHandler: function(domId){
        var treeObj = $.fn.zTree.getZTreeObj(domId);
        var nodes = treeObj.getCheckedNodes(true); // 获取输入框被勾选的节点集合
        var res = fxjsCommonFun.getFootNode(nodes)
        this.selectMc.value = []
        var nameArr = []
        for (var i=0;i<res.length;i++) {
          this.selectMc.value.push(res[i].code)
          nameArr.push(res[i].name)
        }
        this.selectMc.name = nameArr.join(',')
        this.searchData.jgfsdm = this.selectMc.value
        if(Array.isArray(this.searchData.jgfsdm) && this.searchData.jgfsdm.length == 0){
          this.searchData.jgfsdm = null
        }
      },
      getJsyj(){
        var self = this
        ajax("POST", "/cxfw/cqwsb/yddm/list", {})
        .done(function (res) {
          if (res.code == "0") {
            self.jsList = res.data
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
      }
  },
});
