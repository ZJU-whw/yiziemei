var wktDzbaQycx = require("./wktDzbaQycx.html");
avalon.component('wktDzbaQycx', {
  template: wktDzbaQycx,
  defaults: {
    params: {},
    act: 1,
    tcode: "wktDzbaQycx",
    swjgmc: "",
    searchData: {
      swjgdm: "",
      qybs: "",
      group: "",
      gllb: [],
      tsjsfs: [],
      orderSql: "",
      pageSize: config.pageSize,
    },
    tsjsfsName: '',
    gllbName: '',
    applyResult: [
      { value: '1', name: '登记中' },
      { value: '2', name: '已登记' },
      { value: '3', name: '未登记' },
    ],
    gllbList: [
      { value: 'A', name: 'A' },
      { value: 'B', name: 'B' },
      { value: 'C', name: 'C' },
      { value: 'D', name: 'D' },
    ],
    groupList: [
      // { groupCode: 'fyp', groupName: '傅燕萍' },
    ],
    tsjsfsList: [
      { value: '1', name: '免抵退'},
      { value: '2', name: '免退税'},
      { value: '3', name: '免税'},
      { value: '9', name: '其他'},
    ],
    timer: null,
    tableArr: [],
    tableOption: [],
    tableData: {},
    setData: {
      zczt: "",
      ktpt: ""
    },
    onReady: function () {
      this.initSwjgdm();
      this.createTable();
      this.initTree();
      this.initHeight();
    },

    initSwjgdm: function(){
      var self = this;
      api.getPrelogin().done(function(res){
        self.searchData.swjgdm = res.swjgDm;
        self.swjgmc = res.swjgMc;
        self.getGroup();
      })
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".wktDzbaQycx .form").height();
        if (h > 100) {
          $("#wktDzbaQycx-table").jqGrid('setGridHeight', h - 70);
        }
      })
    },

    getGroup: function () {
      var self = this;
      if(avalonRoot.user && /^13302/.test(avalonRoot.user.swjgDm)) return;
      var params = {
        swjgdm: this.searchData.swjgdm
      }
      ajax("POST", "/cxfw/swjgjd/group", params).done(function (res) {
        if (res.code == '0') {
          self.groupList = res.data
        }
      })
    },

    createTable: function () {
      var self = this;
      var columns = [
        { name: "id", label: "id", index: "id", hidden: true, width: 100, align: "left", sortable: true },
        { name: "swjgmc", label: "税务机关", index: "swjgmc", width: 200, align: "left", sortable: true },
        { name: "nsrsbh", label: "社会信用码", index: "nsrsbh", width: 150, align: "left", sortable: true },
        { name: "nsrmc", label: "企业名称", index: "nsrmc", width: 200, align: "left", sortable: true },
        { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm", width: 100, align: "left", sortable: true },
        { name: "tsjsfs", label: "退税计算方式", index: "tsjsfs", width: 80, align: "center", sortable: true },
        { name: "gllb", label: "管理类别", index: "gllb", width: 70, align: "center", sortable: true },
        { name: "groupName", label: "接单分组", index: "groupName", width: 200, align: "left", sortable: true },

      ];
      $("#wktDzbaQycx-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#wktDzbaQycx-tablePager',
        shrinkToFit: false,
        width: "100%",
        // multiselect: true,
        // multiselectWidth:"30",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        rownumWidth: 40,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".wktDzbaQycx .form").height() - 70;
        })(),
        onSortCol: function (index, iCol, sortorder) {
          self.searchData.orderSql = index + ' ' + sortorder;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "wktDzbaQycx-table");
          self.search(pageNo);
        }

      })
      $("#wktDzbaQycx-table").jqGrid('setFrozenColumns');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.wktDzbaQycx')).val();
      // self.search(1)
    },
    search: function (pageNo) {
      var self = this;
      var fields = [
        { name: "qyhgdm", rules: 'max_length[10]', message: "海关代码最大长度为10" },
        { name: "nsrmc", rules: 'max_length[30]', message: "纳税人名称最大长度为30" },
      ];
      var isValid = tools.validate("wktDzbaQycx-form", fields);
      if (isValid) {
        this.searchData.pageSize = $(".ui-pg-selbox", $('.wktDzbaQycx')).val() || 20;
        var params = tools.clone(self.searchData);
        params.pageNo = pageNo
        $("#wktDzbaQycx-table").jqGrid('clearGridData')
        api.dzbaApplyNotList(params).done(function (res) {
          if (res.code == '0') {
            $("#wktDzbaQycx-table").resetSelection();
            $("#wktDzbaQycx-table")[0].addJSONData(res.data);
            self.tableData = res.data;
          }
        })
      }
    },
    reset: function () {
      this.searchData = {
        swjgdm: avalonRoot.user.swjgDm,
        qybs: "",
        group: "",
        gllb: "",
        tsjsfs: "",
        orderSql: "",
        pageSize: config.pageSize,
      };
      this.swjgmc = avalonRoot.user.swjgMc;
    },
    exform: function () {
      tools.exform(this.searchData, '/dzba/export/apply/not');
    },
    initTree: function () {
      var self = this;
      var setting = {
        callback: {
          onClick: function (e, id, node) {
            self.searchData.swjgdm = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            self.getGroup();
            return;
          },
          onDblClick: function (e, id, node) {
            self.searchData.swjgdm = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            self.getGroup();
            return;
          }
        },
        data: { key: { children: "item", name: "text" } }
      };

      ajax("POST", "/cxfw/export/readtree", { nodeType: "3" }).done(function (res) {
        if (res.code == '0') {
          $.fn.zTree.init($(".wktDzbaQycx .treeDiv"), setting, res.data);
        } else {
          tools.info(res.msg)
        }
      }).fail(function (err) {
        tools.info(err)
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.wktDzbaQycx').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }

      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.wktDzbaQycx').off('click');
    },
    filDate: function (e) {
      var date = e.target.value;
      var res = tools.DateCheup(date);
      if (res === false) {
        tools.info("日期输入错误");
        res = ""
      }
      e.target.value = res;
      return;
    },
    showSelectTsjsfs: function (e) {
        $(".select-container", $(e.target).parent()).show();
        $('.wktDzbaQycx .page').on('click', function (e) {
            var e = e || window.event;
            if ($('.select-container').find($(e.target)).length <= 0) {
                $(".select-container").hide();
                $('.wktDzbaQycx .page').off('click');
            }
        })
    },
    selectChangeTsjsfs: function(){
      var curTsjsfsName = [];
      for(var i=0; i<this.tsjsfsList.length; i++){
        if(this.searchData.tsjsfs.indexOf(this.tsjsfsList[i].value)>-1){
          curTsjsfsName.push(this.tsjsfsList[i].name);
        }
      }
      this.tsjsfsName = curTsjsfsName.join(',');
    },
    selectChangeGllb: function(){
      var curGllbName = [];
      for(var i=0; i<this.gllbList.length; i++){
        if(this.searchData.gllb.indexOf(this.gllbList[i].value)>-1){
          curGllbName.push(this.gllbList[i].name);
        }
      }
      this.gllbName = curGllbName.join(',');
    },
  }
});