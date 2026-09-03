var zbpz = require("./sdhcqkcx.html");
avalon.component("sdhcqkcx", {
  template: zbpz,
  defaults: {
    params: {},
    act: 1,
    tcode: "zbpz",
    tsjgmc:'',
    isDZBAGL: true, // 是否为单证备案管理岗
    releaserList: [],
    nsrsbhList: [],
    // SearchType: 'nsrsbh', // nsrsbh-纳税人识别号，qymc-企业名称，hgdm-海关代码
    qySearchType: 'nsrsbh',
    showNsrsbhList: false,
    qySearchVal: '',
    activeBgReleaserIndex: -1,
    activeBgIndex: -1,
    searchData: {
      swjgdm:'',
      hcrqQ:'',
      hcrqZ:'',
      releaseStart:'',
      releaseEnd:'',
      hczt:'',
      jcjg:'',
      xdr:'',
      sbnypc:'',
      qyhgdm:'',
      nsrsbh:'',
      nsrmc:'',
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
    showReleaserList: false,
    addTitle: "查看",
    hyList: [],
    pageNumber:1,
    isAdmin: false,
    onReady: function () {
      var self = this
      this.isAdmin = ["super", "admin"].indexOf(avalonRoot.user.roleDm) > -1;
      if (self.params.swjgdm) {
        console.log(self.params);
        self.searchData.swjgdm = self.params.swjgdm
        self.searchData.hcrqQ = self.params.startDate
        self.searchData.hcrqZ = self.params.endDate
        self.searchData.hczt = self.params.hczt
        self.searchData.jcjg = self.params.jcjg
        self.tsjgmc = self.params.swjgMc
      }else{
        self.tsjgmc = avalonRoot.user.swjgMc;
        self.searchData.swjgdm = avalonRoot.user.swjgDm;
      }
      this.initDate()
      // this.getRole();
      this.initTree();
      this.createTable();
      this.search(1)
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
          name: "key",
          label: "key",
          index: "key",
          width:0,
          align: "left",
          sortable: false,
          hidden:true
        },
        {
          name: "swjgdm",
          label: "税务机关",
          index: "swjgdm",
          width:100,
          align: "left",
          sortable: false,
        },
        {
          name: "nsrsbh",
          label: "税号",
          index: "nsrsbh",
          width:150,
          align: "left",
          sortable: false,
        },
        {
          name: "nsrmc",
          label: "企业名称",
          index: "nsrmc",
          width:200,
          align: "left",
          sortable: false,
        },
        {
          name: "qyhgdm",
          label: "企业海关代码",
          index: "qyhgdm",
          width:100,
          align: "left",
          sortable: false,
        },
        {
          name: "sbywzl",
          label: "业务类型",
          index: "sbywzl",
          width:120,
          align: "left",
          sortable: false,
        },
        {
          name: "sbnypc",
          label: "申报年月批次",
          index: "sbnypc",
          width:90,
          align: "left",
          sortable: false,
        },
        {
          name: "flglcd",
          label: "分类管理等级",
          index: "flglcd",
          width:80,
          align: "center",
          sortable: false,
        },
        {
          name: "entryId",
          label: "报关单号",
          index: "entryId",
          width:135,
          align: "left",
          sortable: false,
        },
        {
          name: "je",
          label: "金额",
          index: "je",
          width:90,
          align: "right",
          sortable: false,
        },
        {
          name: "se",
          label: "税额",
          index: "se",
          width:90,
          align: "right",
          sortable: false,
        },
        {
          name: "balx",
          label: "备案类型",
          index: "balx",
          width:100,
          align: "left",
          sortable: false,
        },
        {
          name: "status",
          label: "核查状态",
          index: "status",
          width:80,
          align: "center",
          sortable: false,
        },
        {
          name: "releaser",
          label: "下达人",
          width:80,
          index: "releaser",
          align: "left",
          sortable: false,
        },
        {
          name: "releaseTime",
          label: "下达日期",
          width:90,
          index: "releaseTime",
          align: "left",
          sortable: false,
        },
        {
          name: "reportTime",
          label: "上报日期",
          width:90,
          index: "reportTime",
          align: "left",
          sortable: false,
        },
        {
          name: "overdule",
          label: "逾期日期",
          width:90,
          index: "overdule",
          align: "left",
          sortable: false,
        },
        {
          name: "examiner",
          label: "核查人",
          width:80,
          index: "examiner",
          align: "left",
          sortable: false,
        },
        {
          name: "examineTime",
          label: "核查日期",
          width:90,
          index: "examineTime",
          align: "left",
          sortable: false,
        },
        {
          name: "examineResult",
          label: "核查结论",
          width:100,
          index: "examineResult",
          align: "left",
          sortable: false,
        },
        {
          name: "examineNote",
          label: "核查意见",
          index: "examineNote",
          width:80,
          align: "left",
          sortable: false,
        },
        {
          name: "range",
          label: "核查范围",
          index: "range",
          align: "left",
          sortable: false,
        },
        {
          name: "voidFlag",
          label: "是否作废",
          index: "voidFlag",
          width:90,
          align: "left",
          sortable: false,
        },
        {
          name: "voider",
          label: "作废人",
          index: "voider",
          align: "left",
          sortable: false,
        },
        {
          name: "note",
          label: "备注",
          index: "note",
          align: "left",
          sortable: false,
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
      $("#sdhcqkcx-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: "#sdhcqkcx-tablePager",
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
          return $(".sdhcqkcx .form").height() - 60;
        })(),
        // beforeSelectRow: function (rowid, e) {
        //   var row = $("#sdhcqkcx-table").jqGrid("getRowData", rowid);
        //   if ($(e.target).hasClass("link")) {
        //     var params = {
        //       zbId: row.zbId,
        //       zbCname: row.zbCname,
        //       datatype: row.datatype,
        //       ywms: row.ywms,
        //       zbFomula: row.zbFomula,
        //     };
        //     avalonRoot.addTab({
        //       title: "指标配置详情",
        //       component: "zbpzmx",
        //       params: params,
        //     });
        //     return false;
        //   } else if ($(e.target).hasClass("edit")) {
        //     for (var key in self.modelData) {
        //       self.modelData[key] = row[key];
        //     }
        //     self.showModel("2");
        //     return false;
        //   } else if ($(e.target).hasClass("del")) {
        //     tools.confirm("是否确定删除该条数据？", "确定", function () {
        //       var params = {
        //         zbId: row.zbId,
        //       };
        //       ajax("POST", "/sszj/zbgl/zb/del", params)
        //         .done(function (res) {
        //           if (res.code == "0") {
        //             self.search(1);
        //           } else {
        //             tools.info(res.msg);
        //           }
        //         })
        //         .fail(function (err) {
        //           tools.info(err);
        //         });
        //     });
        //     return false;
        //   } else if (e.target.nodeName == "TD") {
        //     $(e.target)
        //       .parent()
        //       .addClass("ui-state-highlight")
        //       .siblings()
        //       .removeClass("ui-state-highlight");
        //     return false;
        //   } else {
        //     return true;
        //   }
        // },
        onSortCol: function (index, iCol, sortorder) {
          self.searchData.orderSql = index + " " + sortorder;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "sdhcqkcx-table");
          this.pageNumber = pageNo
          self.search(pageNo);
        },
      });

      $("#sdhcqkcx-table").jqGrid("setFrozenColumns");
      if (this.isAdmin) {
        tools.HeiKjNoSel("sdhcqkcx", "sdhcqkcx-table");
      }
      // this.searchData.pageSize = $(".ui-pg-selbox", $('.user')).val();
      // self.search(1);
    },
    showModel: function (operation) {
      $(".model").show();
      $(".sdhcqkcx .add-page-model").show();
    },
    hideModel: function () {
      $(".model").hide();
      $(".sdhcqkcx .add-page-model").hide();
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
      $(".sdhcqkcx .select-sub").toggle();
      $(".sdhcqkcx .select-wrapper .icon").toggleClass("active");
      if (
        $(".sdhcqkcx .select-wrapper .icon").attr("title").slice(0, 2) === "展开"
      ) {
        $(".sdhcqkcx .select-wrapper .icon").attr("title", "收起查询条件");
      } else {
        $(".sdhcqkcx .select-wrapper .icon").attr("title", "展开查询条件");
      }
    },
    closeHyper: function () {
      $(".sdhcqkcx .select-sub").hide();
      $(".sdhcqkcx .select-wrapper .icon").removeClass("active");
      $(".sdhcqkcx .select-wrapper .icon").attr("title", "展开查询条件");
    },
    search: function (pageNo) {
      var self = this;
      this.qySearchValChg();
      this.searchData.pageSize = $(".ui-pg-selbox", $(".sdhcqkcx")).val() || 20;
      var params = tools.clone(self.searchData);
      params.pageNo = pageNo;
      $("#sdhcqkcx-table").jqGrid("clearGridData");
      api
        .getSdhcqk(params)
        .done(function (res) {
          if (res.code == "0") {
            $("#sdhcqkcx-table").resetSelection();
            $("#sdhcqkcx-table")[0].addJSONData(res.data);
            if (self.isAdmin) {
              tools.HeiKjNoSel("sdhcqkcx", "sdhcqkcx-table");
            }
            self.closeHyper();
            // $("#sdhcqkcx-table").trigger("reloadGrid");
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
      if ($("#sdhcqkcx-table").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      var params = tools.clone(self.searchData);
      params.pageNo = this.pageNumber
      var form = $("<form>"); //定义一个form表单
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/dzba/export/sdhc");
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
      // this.searchData = {
      //   // nkzbbh: "",
      //   nkzblb: "",
      //   nkzbmc: "",
      //   nkfxdj: "",
      //   // nkywly: "",
      //   sqtxlx: "",
      //   szyjlx: "",
      //   shjdlx: "",
      //   releaseStart:'',
      //   releaseEnd:'',
      //   hcrqQ:'',
      //   hcrqZ:'',
      //   xdr:'',
      //   sbnypc:'',
      //   nsrsbh:'',
      //   nsrmc:'',
      //   hczt:'',
      //   jcjg:'',
      //   pageSize: config.pageSize,
      // };
      // this.searchData.nkzblb = ""
      this.searchData.nkzbmc = ""
      this.searchData.nkfxdj = ""
      this.searchData.sqtxlx = ""
      this.searchData.szyjlx = ""
      this.searchData.shjdlx = ""
      this.searchData.releaseStart = ""
      this.searchData.releaseEnd = ""
      this.searchData.hcrqQ = ""
      this.searchData.hcrqZ = ""
      this.searchData.xdr = ""
      this.searchData.sbnypc = ""
      this.searchData.nsrsbh = ""
      this.searchData.nsrmc = ""
      this.searchData.hczt = ""
      this.searchData.jcjg = ""
      this.searchData.pageSize =  config.pageSize
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
          $.fn.zTree.init($(".sdhcqkcx .treeDiv"), setting, data);
        })
        .fail(function (err) {
          tools.info(err);
        });
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $(".sdhcqkcx").on("click", function (e) {
        var e = e || window.event;
        if ($(".treeDiv").find($(e.target)).length <= 0) {
          self.hideTree();
        }
      });
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $(".sdhcqkcx").off("click");
    },
    numberLimit: function () {
      this.modelData.jsYxj = this.modelData.jsYxj.replace(/\D/g, "");
    },
    getRole: function(){
      var self = this
      api.releaserCheckRole({}).done(function (res) {
        if (res.code == '0') {
          self.isDZBAGL = res.data.isDZBAGL == '1'
          // self.isDZBAGL = true
          // self.createTable();
        }
      })
    },
    // 模糊查询下达人，获取下达人列表
    inpChangeReleaser: function () {
      this.searchData.xdr = this.searchData.xdr.trim()
      var params = {
        releaser: this.searchData.xdr
      }
      var self = this
      ajax("POST", "/auth/user/releaser/list", params, false, false, true).done(function (res) {
        if (res.code == '0') {
          self.releaserList = res.data || [];
          self.activeBgReleaserIndex = self.releaserList.length>0? 0: -1
          self.showReleaser()
        }
      })
    },
    setReleaser: function (item) {
      this.searchData.xdr = item.czryMc
      this.showReleaserList = false
    },
    // 显示下达人弹框
    showReleaser: function () {
      var list = this.releaserList
      this.showReleaserList = list && list.length > 0;
    },
    // 隐藏纳税人识别号弹框
    hideNsrsbh: function (e) {
      if ($(e.target).parent().hasClass('releaser-group')) return
      this.showReleaserList = false
    },
    releaserEnterSearch: function (e) {
      e.target.blur()
      this.showReleaserList = false
      this.search(1)
    },
    // 模糊查询税号，获取税号列表
    inpChangeNsrsbh: function (key) {
      if (key == 'searchData') {
        this.searchData.nsrmc = '';
        // 处理外层查询条件切换时的问题
        this.qySearchValChg();
        if (this.qySearchType != 'nsrsbh') return
      }
      this[key].nsrsbh = this[key].nsrsbh.trim()
      var nsrsbh = this[key].nsrsbh
      if (nsrsbh.length < 4) {
        return;
      }
      var params = {
        qybs: nsrsbh
      }
      var self = this
      ajax("POST", "/dzba/inspect/nsrxx/list", params, false, false, true).done(function (res) {
        if (res.code == '0') {
          if (key == 'searchData') {
            self.nsrsbhList = res.data || [];
            self.activeBgIndex = self.nsrsbhList.length>0? 0: -1
            self.showNsrsbh()
          }
        }
      })
    },
    setNsrsbh: function (item, key) {
      this[key].nsrsbh = item.nsrsbh
      this.showNsrsbhList = false
      if (key == 'nsrxx') {
      } else {
        this.qySearchVal = item.nsrsbh;
        this.search(1);
      }
    },
    // 显示纳税人识别号弹框
    showNsrsbh: function () {
      var list = this.nsrsbhList
      this.showNsrsbhList = list && list.length > 0;
    },
    // 隐藏纳税人识别号弹框
    hideNsrsbh: function (e) {
      if ($(e.target).parent().hasClass('nsrsbh-group')) return
      this.showNsrsbhList = false
    },
    keydown: function (e, id) {
      if (id == 'rwcxNrsbhList') {
        var index = this.activeBgIndex
        var len = this.nsrsbhList.length
      } else if (id == 'rwcxReleaserList') {
        var index = this.activeBgReleaserIndex
        var len = this.releaserList.length
      }
      //38:上  40:下
      if (e.keyCode == 38) {
        if (index > -1) {
          index--
        } else {
          index = len - 1
        }
        this.stopDefault(e)
      } else if (e.keyCode == 40) {
        if (index < len) {
          index++
        } else {
          index = 0
        }
        this.stopDefault(e)
      }
      if (index >= len) {
        index = len - 1;
      }
      if (index < 0) {
        index = 0;
      }
      if (id == 'rwcxNrsbhList') {
        this.activeBgIndex = index
      } else if (id == 'rwcxReleaserList') {
        this.activeBgReleaserIndex = index
      }
      var pHeight = $('#' + id + ' p:first').height() // p元素高度
      if (index > 2) {
        $("#" + id).scrollTop(pHeight * (index - 3) + 9)
      } else {
        $("#" + id).scrollTop(0)
      }
      if (e.keyCode == 13) {  // enter
        var item = {}
        var key = ''
        if (id == 'rwcxNrsbhList') {
          item = this.nsrsbhList[index],
          key = 'searchData'
        } else if (id == 'rwcxReleaserList') {
          this.searchData.xdr = this.releaserList[index].czryMc
          return;
        }
        if (item) {
          this[key].nsrsbh = item.nsrsbh
          if (id == 'rwcxNrsbhList') {
            this.qySearchVal = item.nsrsbh;
          }
        }
      }
    },
    //阻止事件执行
    stopDefault: function (event) {
      //阻止默认浏览器动作(W3C)   
      if (event && event.preventDefault) {
        //火狐的 事件是传进来的e  
        event.preventDefault();
      }
      //IE中阻止函数器默认动作的方式   
      else {
        //ie 用的是默认的event  
        event.returnValue = false;
      }
    },
    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },
    initDate: function(){
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
      $('.sdhcqkcx .datepicker.date-day').datetimepicker(options);
      $('.sdhcqkcx .datepicker.date-day-release').datetimepicker(options);
    },
    nsrsbhEnterSearch: function (e) {
      e.target.blur()
      this.showNsrsbhList = false
      this.search(1)
    },
    qySearchTypeChg: function () {
      this.qySearchVal = '';
      this.searchData.nsrsbh = '';
      this.searchData.nsrmc = '';
      this.searchData.qyhgdm = '';
    },
    // 查询条件 纳税人识别号/企业名称/海关代码输入框 变更事件
    qySearchValChg: function () {
      this.qySearchVal = this.qySearchVal.trim();
      if (this.qySearchType == 'nsrsbh') {
        this.searchData.nsrsbh = this.qySearchVal;
      } else if (this.qySearchType == 'qymc') {
        this.searchData.nsrmc = this.qySearchVal;
      } else if (this.qySearchType == 'hgdm') {
        this.searchData.qyhgdm = this.qySearchVal;
      }
    },
  },
});
