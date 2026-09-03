var dxjsrpz = require("./dxjsrpz.html");
avalon.component("dxjsrpz", {
  template: dxjsrpz,
  defaults: {
    params: {},
    swjgmc: "",
    searchData: {
      swjgDm: "",
      orderSql: "",
      pageSize: config.pageSize,
    },
    editData: {
      id: "",
      username: "",
      jobType: "",
      phone: "",
      swjgDm: "",
      swjgMc: "",
      jjyqTssb: "",
      jjyqFuh: "",
      jjyqFuhcl: "",
      jjyqSdhc: "",
      fxck: "",
      fxcksb: "",
      fxgh: "",
      fxghsb: "",
      nksqtx: "",
      nkshjd: "",
      qybz: "",
      jjrtxbz:''
    },
    jobTypeList:[
      {value:1,label:'局长'},
      {value:2,label:'科股长'},
      {value:3,label:'市局干部'},
      {value:4,label:'省局干部'},
    ],
    swjgList: ["13301000000","13302000000","13303000000","13304000000","13305000000","13306000000","13307000000","13308000000","13309000000","13310000000","13311000000"], // 市级税务机关代码列表
    addTitle: "",
    onReady: function () {
      try {
        this.searchData.swjgDm = avalonRoot.user.swjgDm;
        this.swjgmc = avalonRoot.user.swjgMc;
      } catch (e) {}
      this.createTable();
      this.initTree();
    },
    createTable: function () {
      var self = this;
      var columns = [
        { name: "id", label: "主键", index: "id", hidden: true },
        {
          name: "username",
          label: "用户",
          index: "username",
          width: 90,
          align: "left",
          sortable: true,
        },
        { name: "jobType", label: "职位", index: "jobType", hidden: true },
        {
          name: "jobTypeName",
          label: "职位",
          index: "jobTypeName",
          width: 60,
          align: "left",
          sortable: false,
          formatter: function (cellvalue, options, rowObject) {
            var map = { 1: "局长", 2: "科股长", 3: "市局干部", 4: "省局干部"};
            return map[rowObject.jobType] || "";
          },
        },
        {
          name: "phone",
          label: "电话号码",
          index: "phone",
          width: 120,
          align: "center",
          sortable: true,
        },
        {
          name: "swjgDm",
          label: "税务机关代码",
          index: "swjgDm",
          width: 130,
          align: "center",
          sortable: true,
        },
        {
          name: "swjgMc",
          label: "税务机关名称",
          index: "swjgMc",
          width: 160,
          align: "left",
          sortable: true,
        },
        {
          name: "uptime",
          label: "更新时间",
          index: "uptime",
          width: 130,
          align: "center",
          sortable: true,
        },
        { name: "jjyqTssb", label: "即将逾期退税", index: "jjyqTssb", hidden: true },
        {
          name: "jjyqTssbName",
          label: "即将逾期退税",
          index: "jjyqTssbName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.jjyqTssb] || "";
          },
        },
        { name: "jjyqFuh", label: "即将逾期函调复函", index: "jjyqFuh", hidden: true },
        {
          name: "jjyqFuhName",
          label: "即将逾期函调复函",
          index: "jjyqFuhName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.jjyqFuh] || "";
          },
        },
        { name: "jjyqFuhcl", label: "即将逾期函调处理", index: "jjyqFuhcl", hidden: true },
        {
          name: "jjyqFuhclName",
          label: "即将逾期函调处理",
          index: "jjyqFuhclName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.jjyqFuhcl] || "";
          },
        },
        { name: "jjyqSdhc", label: "即将逾期实地核查", index: "jjyqSdhc", hidden: true },
        {
          name: "jjyqSdhcName",
          label: "即将逾期实地核查",
          index: "jjyqSdhcName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.jjyqSdhc] || "";
          },
        },
        { name: "fxck", label: "风险出口电子信息", index: "fxck", hidden: true },
        {
          name: "fxckName",
          label: "风险出口电子信息",
          index: "fxckName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.fxck] || "";
          },
        },
        { name: "fxcksb", label: "风险出口电子信息", index: "fxcksb", hidden: true },
        {
          name: "fxcksbName",
          label: "风险申报信息",
          index: "fxcksbName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.fxcksb] || "";
          },
        },
        { name: "fxgh", label: "风险供货电子信息", index: "fxgh", hidden: true },
        {
          name: "fxghName",
          label: "风险供货电子信息",
          index: "fxghName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.fxgh] || "";
          },
        },
        { name: "fxghsb", label: "风险供货申报信息", index: "fxghsb", hidden: true },
        {
          name: "fxghsbName",
          label: "风险供货申报信息",
          index: "fxghsbName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.fxghsb] || "";
          },
        },
        { name: "nksqtx", label: "内控事前提醒", index: "nksqtx", hidden: true },
        {
          name: "nksqtxName",
          label: "内控事前提醒",
          index: "nksqtxName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.nksqtx] || "";
          },
        },
        { name: "nkshjd", label: "内控事后监督", index: "nkshjd", hidden: true },
        {
          name: "nkshjdName",
          label: "内控事后监督",
          index: "nkshjdName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.nkshjd] || "";
          },
        },
        { name: "jjrtxbz", label: "节假日提醒标志", index: "jjrtxbz", hidden: true },
        {
          name: "jjrtxbzName",
          label: "节假日提醒标志",
          index: "jjrtxbzName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.jjrtxbz] || "";
          },
        },
        { name: "qybz", label: "启用标志", index: "qybz", hidden: true },
        {
          name: "qybzName",
          label: "启用标志",
          index: "qybzName",
          width: 130,
          align: "center",
          sortable: true,
          formatter: function (cellvalue, options, rowObject) {
            var map = { Y: "是", N: "否" };
            return map[rowObject.qybz] || "";
          },
        },
        {
          name: "op",
          label: "操作",
          index: "op",
          width: 116,
          formatter: function (cellvalue, options, rowObject) {
            return "<div class='btn op-edit' style='float: none;display: inline-block;' title='编辑'>编辑</div><div class='btn op-del' style='float: none;display: inline-block;' title='删除'>删除</div>";
          },
        },
      ];
      $("#dxjsrpz-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: "#dxjsrpz-tablePager",
        shrinkToFit: false,
        width: "100%",
        // multiselect: true,
        // multiselectWidth:"30",
        autowidth: true,
        altRows: true,
        // footerrow: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".dxjsrpz .form").height() - 90;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $("#dxjsrpz-table").jqGrid("getRowData", rowid);
          if ($(e.target).hasClass("op-edit")) {
            self.setJobTypeList(row.swjgDm)
            self.editData = {
              id: row.id,
              username: row.username,
              jobType: row.jobType,
              phone: row.phone,
              swjgDm: row.swjgDm,
              swjgMc: row.swjgMc,
              jjyqTssb: row.jjyqTssb,
              jjyqFuh: row.jjyqFuh,
              jjyqFuhcl: row.jjyqFuhcl,
              jjyqSdhc: row.jjyqSdhc,
              fxck: row.fxck,
              fxcksb: row.fxcksb,
              fxgh: row.fxgh,
              fxghsb: row.fxghsb,
              nksqtx: row.nksqtx,
              nkshjd: row.nkshjd,
              qybz: row.qybz,
              jjrtxbz: row.jjrtxbz,
            };
            self.showModel("编辑");
            return false;
          } else if ($(e.target).hasClass("op-del")) {
            tools.confirm("是否确定删除该条数据？", "确定", function () {
              api.msgplanUserDel({ id: row.id }).done(function (res) {
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
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "dxjsrpz-table");
          self.search(pageNo);
        },
      });
      $("#dxjsrpz-table").jqGrid("setGroupHeaders", {
        useColSpanStyle: true,
        groupHeaders: [
          {
            startColumnName: "jjyqTssb",
            numberOfColumns: 24,
            titleText: "接收短信类型",
          },
        ],
      });
      this.searchData.pageSize = $(".ui-pg-selbox", $(".dxjsrpz")).val();
      this.search(1);
    },
    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize = $(".ui-pg-selbox", $(".dxjsrpz")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      $("#dxjsrpz-table").jqGrid("clearGridData");
      ajax("POST", "/cxfw/zbrw/msgplan/userlist", params)
        .done(function (res) {
          if (res.code == "0") {
            $("#dxjsrpz-table").resetSelection();
            $("#dxjsrpz-table")[0].addJSONData(res.data);
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    reset: function () {
      this.searchData = {
        swjgDm: avalonRoot.user.swjgDm,
        qybs: "",
        biztype: "",
        orderSql: "",
        pageSize: config.pageSize,
      };
      this.swjgmc = avalonRoot.user.swjgMc;
    },
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
      var setting2 = {
        callback: {
          onClick: function (e, id, node) {
            self.editData.jobType = ''
            self.setJobTypeList(node.id)
            // var flag = self.swjgList.indexOf(node.id) == -1
            // if(node.id == "13300000000"){
            //     self.jobTypeList = [
            //     {value:4,label:'省局干部'},
            //   ]
            //   self.editData.jobType = 4
            // }else if(!flag){
            //   self.jobTypeList = [
            //     {value:3,label:'市局干部'},
            //   ]
            //   self.editData.jobType = 3
            // }else{
            //     self.jobTypeList = [
            //     {value:1,label:'局长'},
            //     {value:2,label:'科股长'},
            //   ]
            // }
            self.editData.swjgDm = node.id;
            self.editData.swjgMc = node.text;
            self.hideTree();
            return;
          },
          onDblClick: function (e, id, node) {
            self.editData.jobType = ''
            self.setJobTypeList(node.id)
            // var flag = self.swjgList.indexOf(node.id) == -1
            // if(node.id == "13300000000"){
            //     self.jobTypeList = [
            //     {value:4,label:'省局干部'},
            //   ]
            //   self.editData.jobType = 4
            // }else if(!flag){
            //   self.jobTypeList = [
            //     {value:3,label:'市局干部'},
            //   ]
            //   self.editData.jobType = 3
            // }else{
            //     self.jobTypeList = [
            //     {value:1,label:'局长'},
            //     {value:2,label:'科股长'},
            //   ]
            // }
            self.editData.swjgDm = node.id;
            self.editData.swjgMc = node.text;
            self.hideTree();
            return;
          },
        },
        data: { key: { children: "item", name: "text" } },
      };
      ajax("POST", "/cxfw/export/readtree", { nodeType: "3" })
        .done(function (res) {
          if (res.code == "0") {
            $.fn.zTree.init($("#dxjsrpzSearchSwjg"), setting, res.data);
            $.fn.zTree.init($(".dxjsrpz .editSwjg"), setting2, res.data);
          } else {
            tools.info(res.msg);
          }
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    setJobTypeList(id){
      var self = this
      var flag = self.swjgList.indexOf(id) == -1
      if(id == "13300000000"){
        self.jobTypeList = [
        {value:4,label:'省局干部'},
      ]
      self.editData.jobType = 4
    }else if(!flag){
      self.jobTypeList = [
        {value:3,label:'市局干部'},
      ]
      self.editData.jobType = 3
    }else{
        self.jobTypeList = [
        {value:1,label:'局长'},
        {value:2,label:'科股长'},
      ]
    }
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".dxjsrpz").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".dxjsrpz").off("click");
    },
    showModel: function (title) {
      this.addTitle = title;
      if(title == '新增'){
        this.editData = {
          id: "",
          username: "",
          jobType: "",
          phone: "",
          swjgDm: "",
          swjgMc: "",
          jjyqTssb: "Y",
          jjyqFuh: "Y",
          jjyqFuhcl: "Y",
          jjyqSdhc: "Y",
          fxck: "Y",
          fxcksb: "Y",
          fxgh: "Y",
          fxghsb: "Y",
          nksqtx: "Y",
          nkshjd: "Y",
          qybz: "Y",
          jjrtxbz:'Y'
        };
      }
      $(".model").show();
      $(".dxjsrpz .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".dxjsrpz .add-page-model").hide();
      this.editData = {
        id: "",
        username: "",
        jobType: "",
        phone: "",
        swjgDm: "",
        swjgMc: "",
        jjyqTssb: "",
        jjyqFuh: "",
        jjyqFuhcl: "",
        jjyqSdhc: "",
        fxck: "",
        fxcksb: "",
        fxgh: "",
        fxghsb: "",
        nksqtx: "",
        nkshjd: "",
        qybz: "",
        jjrtxbz:''
      };
    },
    saveModel: function () {
      var self = this;
      var valid = this.checkValid(this.editData);
      if (!valid) return;
      var reg = /^1[23456789]\d{9}$/;
      if (!reg.test(this.editData.phone)) {
        tools.info("手机号码格式不正确！");
        return;
      }
      api.msgplanUserUpdate(this.editData).done(function (res) {
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
        { name: "username", message: "用户不能为空！" },
        { name: "jobType", message: "请选择职位！" },
        { name: "phone", message: "电话号码不能为空！" },
        { name: "swjgDm", message: "税务机关不能为空！" },
        { name: "jjyqTssb", message: "（即将逾期）退税业务短信不能为空！" },
        { name: "jjyqFuh", message: "（即将逾期）函调复函短信不能为空！" },
        { name: "jjyqFuhcl", message: "（即将逾期）函调处理短信不能为空！" },
        { name: "jjyqSdhc", message: "（即将逾期）实地核查短信不能为空！" },
        { name: "fxck", message: "风险出口电子信息短信不能为空！" },
        { name: "fxcksb", message: "风险申报信息短信不能为空！" },
        { name: "fxgh", message: "风险供货电子信息短信不能为空！" },
        { name: "fxghsb", message: "风险供货申报信息短信不能为空！" },
        { name: "nksqtx", message: "内控事前提醒短信不能为空！" },
        { name: "nkshjd", message: "内控事后监督短信不能为空！" },
        { name: "qybz", message: "启用标志不能为空！" },
        { name: "jjrtxbz", message: "节假日提醒标志不能为空！" },
      ];
      for (var i = 0; i < rules.length; i++) {
        if (modelData[rules[i].name] == "") {
          tools.info(rules[i].message);
          return false;
        }
      }
      return true;
    },
    phoneChange: function () {
      this.editData.phone = this.editData.phone.replace(/[^0-9]/g, "");
    },
  },
});
