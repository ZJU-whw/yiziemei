var dzhcZbrw = require("./dzhcZbrw.html");

avalon.component('dzhcZbrw', {
  template: dzhcZbrw,
  defaults: {
    searchData: {
      swjgdm: "",
      nsrsbh: "",
      nsrmc: "",
      qyhgdm: "",
      sfyq: "",
      releaseStart: "", // 受理下达日期起
      releaseEnd: "", // 受理下达日期止
      releaser: "",//下达人
      sbnypc: "",
      sssq: "",
      sbpc: "",
      orderSql: "",
      pageNo: 1,
      pageSize: 20,
    },
    swjgmc: '',
    qySearchType: 'nsrsbh', // nsrsbh-纳税人识别号，qymc-企业名称，hgdm-海关代码
    qySearchVal: '',
    searchAddCkywData: {
      nsrsbh: '',
      sbnypc: '',
      entryId: '',
      sbxh: '',
      glh: '',
      spdm: '',
      ghfnsrsbh: '',
      ckrqq: '',
      ckrqz: '',
      pageSize: 20,
    },
    nsrxx: {
      nsrsbh: '',
      nsrmc: '',
      qyhgdm: '',
      tsjsfs: '',
      gllb: '',
      tsjsfsName: '',
      jydz: '',
      lxr: '',
      lxrDh: '',
      lxrDhCzr: '',
    },
    sbnypcList: [],
    selRowsCkyw: [],
    ckywChooseList: [],
    rangeList: [],
    addIndex: 0,
    modelAddStyle: {
      0: {
        width: '960px',
        marginLeft: '-480px',
        height: '540px',
        marginTop: '-270px',
        contentHeight: '460px'
      },
      1: {
        width: '600px',
        marginLeft: '-300px',
        height: '300px',
        marginTop: '-150px',
        contentHeight: '200px'
      }
    },
    showNsrsbhList: false,
    nsrsbhList: [],
    showNsrsbhCkywList: false,
    nsrsbhCkywList: [],
    typeTreeData: [], // 核查单证类型
    activeBgCkywIndex: -1,
    activeBgIndex: -1,
    ckywTotal: 0,
    nsrxxQybz: '',
    tsjsfsChecked: false,  // 是否勾选 退税计算方式 false-未勾选，true-已勾选
    resetSearchData: function () {
      this.searchData = {
        swjgdm: this.searchData.swjgdm,
        nsrsbh: "",
        nsrmc: "",
        qyhgdm: "",
        sfyq: "",
        releaseStart: "", // 受理下达日期起
        releaseEnd: "", // 受理下达日期止
        releaser: this.searchData.releaser,
        sbnypc: "",
        sssq: "",
        sbpc: "",
        orderSql: "",
        pageNo: 1,
        pageSize: 20,
      };
      this.qySearchVal = '';
    },
    onInit: function (e) {
      avalonRoot.dzhcZbrw = e.vmodel;
    },

    onReady: function () {
      this.initUser();
      this.initDate();
      this.initTree();
      this.initHeight();
      this.createTable();
      this.createTableAddCkyw();
    },

    // 初始化用户数据
    initUser: function () {
      var self = this;
      if (avalonRoot.user && avalonRoot.user.swjgDm) {
        this.searchData.swjgdm = avalonRoot.user.swjgDm;
        this.swjgmc = avalonRoot.user.swjgMc;
        this.searchData.releaser = avalonRoot.user.czrymc;
      } else {
        api.preLogin().done(function (res) {
          if (res.code == '0') {
            avalonRoot.user = res.data;
            self.searchData.swjgdm = avalonRoot.user.swjgDm;
            self.swjgmc = avalonRoot.user.swjgMc;
            self.searchData.releaser = avalonRoot.user.czrymc;
          }
        })
      }
    },

    // 初始化日期输入框
    initDate: function () {
      var self = this;
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2, endDate: new Date(), };
      $('.dzhc-zbrw .datepicker.date-day').datetimepicker(options);
      $('.dzhc-zbrw .datepicker.date-month').datetimepicker({
        language: 'zh-CN',
        format: 'yyyymm',
        weekStart: 1,
        // todayBtn: true,
        clearBtn: true,
        autoclose: 1,
        todayHighlight: 1,
        startView: 3, // 这里就设置了默认视图为年视图
        minView: 3, // 设置最小视图为年视图
        endDate: new Date(),
        forceParse: 0,
      }).on('hide', function (e) {
        if (!e.target.value) self.searchData.sbpc = '';
      })
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".dzhc-zbrw .form").height();
        if (h > 100) {
          $("#dzhc-zbrw-table").jqGrid('setGridHeight', h - 70);
        }
      })
    },

    // 查询条件 纳税人识别号/企业名称/海关代码 变更事件
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
    initTree: function () {
      var self = this;
      var setting = {
        callback: {
          onClick: function (e, id, node) {
            self.searchData.swjgdm = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            return;
          },
          onDblClick: function (e, id, node) {
            self.searchData.swjgdm = node.id;
            self.swjgmc = node.text;
            self.hideTree();
            return;
          }
        },
        data: { key: { children: "item", name: "text" } }
      };

      api.dzbaExportReadtree({ nodeType: "3" }).done(function (res) {
        if (res.code == '0') {
          $.fn.zTree.init($(".dzhc-zbrw .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.dzhc-zbrw').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }
      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.dzhc-zbrw').off('click');
    },
    // 根据申报年月过滤申报批次
    getSbpcs: function (isCheckChg) {
      if (!this.nsrxx.nsrsbh) {
        if(!isCheckChg) tools.info('请先输入社会信用码')
        return false
      }
      var params = {
        qybs: this.nsrxx.nsrsbh,
        sbnd: '',
        tsjsfsChg: this.tsjsfsChecked? (this.nsrxx.tsjsfs=='2'? '1': '2'): '',
      }
      var self = this;
      self.sbnypcList = []
      self.resetSearchAddCkyw();
      api.dzbaDailySbnypcList(params).done(function (res) {
        if (res.code == '0') {
          self.sbnypcList = res.data || [];
          if(self.sbnypcList.length>0) self.searchAddCkywData.sbnypc = self.sbnypcList[0].sbnypc;
          $("#dzhc-zbrw-ckyw-table").jqGrid('clearGridData');
        }
      })
    },
    sbpcChange: function () {
      var sbpc = this.searchData.sbpc.replace(/[^0-9]/g, '')
      this.searchData.sbpc = sbpc
    },
    // 格式化申报批次 - '001'
    formatInt: function (number) {
      var mask = "";
      var returnVal = "";
      for (var i = 0; i < 3; i++) mask += "0";
      returnVal = mask + number;
      returnVal = returnVal.substr(returnVal.length - 3, 3);
      return returnVal;
    },
    sbpcFormat: function (key) {
      if (this[key].sbpc != '') {
        this[key].sbpc = this.formatInt(this[key].sbpc)
      }
    },

    nsrsbhEnterSearch: function (e) {
      e.target.blur()
      this.showNsrsbhList = false
      this.search(1)
    },

    getNsrxx: function () {
      var self = this
      this.nsrxx.nsrsbh = this.nsrxx.nsrsbh.trim()
      if (this.nsrxx.nsrsbh == '' || this.nsrxx.nsrsbh.length < 4) {
        this.resetNsrxx()
        return;
      }
      this.showNsrsbhCkywList = false
      var params = {
        qybs: this.nsrxx.nsrsbh
      }
      // 新增在办任务时，先校验是否开通单证备案
      api.dzbaNsrxxWhether(params).done(function(res){
        if(res.code==0){
          if(res.data=='Y'){
            self.zbrwSetNsrxx(params);
          } else{
            $.dialog({
              title: '提示',
              content: '您选择的【'+self.nsrxx.nsrmc+'】企业尚未开通数字化单证备案，是否继续？',
              lock: true,
              okValue: '确定',
              ok: function(){
                self.zbrwSetNsrxx(params);
              },
              cancelValue: '取消',
              cancel: function(){
                self.resetNsrxx();
              },
            })
          }
        }
      })
    },

    zbrwSetNsrxx: function(params){
      var self = this;
      api.dzbaNsrxxGet(params).done(function (res) {
        if (res.code == '0') {
          self.nsrxx = res.data
          self.searchAddCkywData.nsrsbh = res.data.nsrsbh;
          self.getSbpcs();
        } else {
          var nsrsbh = self.nsrxx.nsrsbh;
          self.resetNsrxx();
          self.nsrxx.nsrsbh = nsrsbh;
          self.sbnypcList = [];
        }
      })
    },

    search: function (pageNo) {
      var self = this;
      var dateValid1 = tools.checkDate(this.searchData.releaseStart, this.searchData.releaseEnd)
      if (!dateValid1) {
        tools.info('下达日期截止日期必须大于起始日期')
        return false
      }
      if (!this.searchData.sssq && !this.searchData.sbpc) {
        this.searchData.sbnypc = ''
      }
      if (!this.searchData.sssq && this.searchData.sbpc) {
        tools.info('申报批次不为空时，申报年月也不能为空')
        return;
      }
      if (this.searchData.sssq) {
        if (!this.searchData.sbpc) {
          tools.info('申报年月不为空时，申报批次也不能为空')
          return;
        } else {
          this.searchData.sbnypc = this.searchData.sssq + '-' + this.searchData.sbpc
        }
      }
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-zbrw')).val() || 20;
      self.searchData.pageNo = pageNo;
      // 处理外层查询条件切换时的问题
      this.qySearchValChg();
      var params = tools.clone(self.searchData);
      $("#dzhc-zbrw-table").jqGrid('clearGridData')
      api.dzbaInspectDailyProcessList(params).done(function (res) {
        if (res.code == '0') {
          $("#dzhc-zbrw-table")[0].addJSONData(res.data);
          self.tableData = res.data;
          tools.HeiKjNoSel('dzhc-zbrw', 'dzhc-zbrw-table')
          $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },

    showHyper: function () {
      $('.dzhc-zbrw .page .select-sub').toggle();
      $('.dzhc-zbrw .page .select-wrapper .icon').toggleClass("active");
      if ($('.dzhc-zbrw .page .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
        $('.dzhc-zbrw .page .select-wrapper .icon').attr("title", "收起查询条件");
      } else {
        $('.dzhc-zbrw .page .select-wrapper .icon').attr("title", "展开查询条件")
      }
    },
    closeHyper: function () {
      $('.dzhc-zbrw .select-sub').hide();
      $('.dzhc-zbrw .select-wrapper .icon').removeClass('active');
      $('.dzhc-zbrw .select-wrapper .icon').attr("title", "展开查询条件")
    },

    createTable: function () {
      var self = this;
      var columns = [
        {
          name: "op2", label: "操作", width: 0, frozen: true, align: "center", resizable: false, sortable: false, formatter: function () {
            return "<div class='btn op-btn op-edit' title='查看'>查看</div>" // 查看
          }
        },
        { name: "swjgdm", label: "税务机关代码", index: "swjgdm", hidden: true },
        { name: "swjgmc", label: "税务机关", index: "swjgmc", width: 80, align: "left", sortable: false },
        { name: "nsrsbh", label: "纳税人税号", index: "nsrsbh", width: 125, align: "left" },
        { name: "nsrmc", label: "企业名称", index: "nsrmc", width: 120, align: "left", sortable: false },
        { name: "balx", label: "备案类型", index: "balx", hidden: true },
        { name: "balxName", label: "备案类型", index: "balxName", width: 70, align: "center", sortable: false },
        { name: "sbywzl", label: "申报业务种类", index: "sbywzl", hidden: true },
        { name: "sbywzlName", label: "申报业务种类", index: "sbywzlName", width: 110, align: "center", sortable: false },
        { name: "sbnypc", label: "申报年月批次", index: "sbnypc", width: 80, align: "center", sortable: true, formatter: function(cellVal, op, row){
          var res = '';
          if(row.sbrqBeforeApply=='Y'){
            res = '<span style="color: #e67e22;" title="该批次下的报关单为企业开通数字化单证备案前申报">'+cellVal+'</span>'
          } else{
            res = '<span>'+cellVal+'</span>';
          }
          return res
        } },
        { name: "overdule", label: "逾期日期", index: "overdule", width: 65, align: "center", sortable: false },
        {
          name: "ywsTotal", label: "核查业务数<i class='icon-question-th' title='该退税申报批次已创建的审单核查业务数量'>?</i>", index: "ywsTotal", width: 75, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ywsWork", label: "在办业务数<i class='icon-question-th' title='该退税申报批次下尚未审核办结的审单核查业务数量'>?</i>", index: "ywsWork", width: 75, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "yjTotal", label: "预警业务数<i class='icon-question-th' title='该退税申报批次下发生过三新预警的审单核查业务数量'>?</i>", index: "yjTotal", width: 75, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "ywsReport", label: "已上报业务数<i class='icon-question-th' title='企业已上报单证可进行审核的审单核查业务数'>?</i>", index: "ywsReport", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        {
          name: "je", label: "出口销售金额(美元)", index: "je", width: 120, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "se", label: "退免税额", index: "se", width: 80, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        { name: "flglcd", label: "分类管理", index: "flglcd", width: 55, align: "center", sortable: false },
        { name: "qyhgdm", label: "海关代码", index: "qyhgdm", width: 70, align: "left", sortable: false },
        { name: "tsjsfsChg", label: "退税计算方式", index: "tsjsfsChg", hidden: true },
        { name: "op", label: "操作", width: 100, align: "center", resizable: false, search: false, sortable: false }
      ];
      $("#dzhc-zbrw-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#dzhc-zbrw-tablePager',
        shrinkToFit: false,
        width: "100%",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        rowNum: 20,
        rownumWidth: 40,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".dzhc-zbrw .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $('#dzhc-zbrw-table').jqGrid('getRowData', rowid);
          row.sbnypc = $(row.sbnypc).html();
          if ($(e.target).hasClass('op-edit')) { // 查看
            // 打开日常审单页面
            row.swjgmc = self.swjgmc;
            avalonRoot.addTab({
              title: '审单核查',
              component: 'dzhcRcsd',
              params: row,
            })
            return false
          } else {
            return true;
          }
        },
        onSortCol: function (index, iCol, sortorder) {
          self.searchData.orderSql = index + ' ' + sortorder;
          self.search(1);
          return;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "dzhc-zbrw-table");
          self.search(pageNo);
        },
      })
      $("#dzhc-zbrw-table").jqGrid('setFrozenColumns');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-zbrw')).val();
      this.search(1)
    },

    createTask: function () {
      $('.model').show();
      $('.dzhc-zbrw .page-model-add').show();
      this.addIndex = 0;
      this.tsjsfsChecked = false;
    },

    // 查询出口业务列表
    searchCkyw: function (pageNo) {
      var self = this;
      this.searchAddCkywData.nsrsbh = this.nsrxx.nsrsbh
      if (!this.searchAddCkywData.nsrsbh) {
        tools.info('请先输入社会信用码、海关代码或企业名称选择准备核查的企业');
        return false;
      }
      var dateValid = tools.checkDate(this.searchAddCkywData.ckrqq, this.searchAddCkywData.ckrqz)
      if (!dateValid) {
        tools.info('出口日期截止日期必须大于起始日期');
        return false;
      }
      if(!(self.searchAddCkywData.sbnypc || self.searchAddCkywData.entryId)){
        tools.info('申报年月批次和报关单号不能同时为空');
        return
      }
      this.searchAddCkywData.pageSize = $(".ui-pg-selbox", $('.dzhc-zbrw .page-model-add')).val() || 20;
      var params = tools.clone(self.searchAddCkywData);
      // 处理退税计算方式
      params.tsjsfsChg = this.tsjsfsChecked? (this.nsrxx.tsjsfs=='2'? '1': '2'): '',
      params.pageNo = pageNo
      $("#dzhc-zbrw-ckyw-table").jqGrid('clearGridData')
      $('.loading').show()
      api.dzbaAvaliableList(params).done(function (res) {
        if (res.code == '0') {
          $("#dzhc-zbrw-ckyw-table")[0].addJSONData(res.data);
          self.ckywTotal = res.data? res.data.length: 0;
          self.ckywChooseList = []
          self.selRowsCkyw = []
        }
        $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
      })
    },

    // 新增任务-出口业务表格
    createTableAddCkyw: function () {
      var self = this;
      var columns = [
        { name: "sbywzl", label: "申报业务种类", index: "sbywzl", hidden: true },
        { name: "sbywzlName", label: "申报业务种类", index: "sbywzlName", width: 90, align: "center", sortable: false },
        { name: "sbnypc", label: "退税申报批次", index: "sbnypc", width: 100, align: "center", sortable: false },
        { name: "entryId", label: "报关单号", index: "entryId", width: 180, align: "center", sortable: false },
        { name: "ckrq", label: "出口日期", index: "ckrq", width: 100, align: "center", sortable: false },
        { name: "sbrq", label: "申报日期", index: "sbrq", width: 100, align: "center", sortable: false },
        { name: "ckfpNo", label: "出口发票", index: "ckfpNo", hidden: true },
        { name: "jhfpNo", label: "进项发票", index: "jhfpNo", hidden: true },
        {
          name: "je", label: "出口销售金额(美元)", index: "je", width: 150, align: "right", sortable: false, formatter: function (cellVal, options, rowObject) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "se", label: "退免税额", index: "se", width: 100, align: "right", sortable: false, formatter: function (cellVal, options, rowObject) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        { name: "ywlxCode", label: "业务类型代码", index: "ywlxCode", hidden: true },
      ]
      $("#dzhc-zbrw-ckyw-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        rownumbers: true,
        shrinkToFit: false,
        autoScroll: true,
        multiselect: true,
        viewrecords: true,
        // pager: '#dzhc-zbrw-ckyw-tablePager',
        // rowList: [20, 50, 100, 500],
        rowNum: 100000,
        rownumWidth: 40,
        multiselectWidth: "30",
        altRows: true,
        altclass: "altclasscss",
        width: 960,
        height: 232,
        onSelectRow: function (rowid, status) {
          var rowObj = $('#dzhc-zbrw-ckyw-table').getRowData(rowid)
          var index = self.selRowsCkyw.indexOf(rowid);
          if (status) {
            self.ckywChooseList.push(rowObj);
            self.selRowsCkyw.push(rowid);
          } else {
            self.ckywChooseList.splice(index, 1);
            self.selRowsCkyw.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          var idArr = rowids.map(function (item) {
            return $('#dzhc-zbrw-ckyw-table').getRowData(item)
          })
          if (status) {
            self.ckywChooseList = idArr;
            self.selRowsCkyw = JSON.parse(JSON.stringify(rowids));
          } else {
            self.ckywChooseList = [];
            self.selRowsCkyw = []
          }
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "dzhc-zbrw-ckyw-table");
          self.searchCkyw(pageNo);
        }
      })
      this.searchAddCkywData.pageSize = $(".ui-pg-selbox", $('.dzhc-zbrw .page-model-add .dzhc-zbrw-ckyw-table')).val();
    },

    // 显示纳税人识别号弹框-选择出口业务
    showNsrsbhCkyw: function () {
      var list = this.nsrsbhCkywList
      this.showNsrsbhCkywList = list && list.length > 0
    },

    hideModelTask: function () {
      $('.model').hide();
      $('.dzhc-zbrw .page-model-add').hide();
      this.resetCkywTable()
      this.activeBgCkywIndex = -1
    },

    resetCkywTable: function () {
      this.resetNsrxx()
      this.nsrsbhCkywList = []
      this.ckywChooseList = []
      this.selRowsCkyw = []
      $("#dzhc-zbrw-ckyw-table").jqGrid('clearGridData');
      this.ckywTotal = 0;
      this.nsrxxQybz = '';
    },

    // 模糊查询税号，获取税号列表
    inpChangeNsrsbh: function (key) {
      if (key == 'searchData') {
        this.searchData.nsrmc = '';
        if (this.qySearchType != 'nsrsbh') return
        // 处理外层查询条件切换时的问题
        this.qySearchValChg();
      }
      this[key].nsrsbh = this[key].nsrsbh.trim()
      var nsrsbh;
      if(key=='nsrxx'){ // 根据企业标志查询，如果使用税号和海关代码查询，至少需要4位，如果使用企业名称，则至少需要2位
        nsrsbh = this.nsrxxQybz;
        if(/[\u4e00-\u9fa5]/.test(nsrsbh)){
          if(nsrsbh.length<2) return
        } else if (nsrsbh.length < 4) {
          return;
        }
      } else{
        nsrsbh = this[key].nsrsbh
        if (nsrsbh.length < 4) {
          return;
        }
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
          } else {
            self.nsrsbhCkywList = res.data || [];
            self.activeBgCkywIndex = self.nsrsbhCkywList.length>0? 0: -1
            self.showNsrsbhCkyw();

          }
        }
      })
    },
    setNsrsbh: function (item, key) {
      this[key].nsrsbh = item.nsrsbh
      this.showNsrsbhList = false
      if (key == 'nsrxx') {
        if(this[key].nsrmc!=item.nsrmc){
          this.getNsrxx();
        }
        this[key].nsrmc = item.nsrmc
        $('#zbrwNrsbhCkywInp').blur();
      } else {
        this.qySearchVal = item.nsrsbh;
        this.search(1)
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
      this.showNsrsbhCkywList = false
    },

    resetNsrxx: function () {
      this.nsrxx = {
        nsrsbh: '',
        nsrmc: '',
        qyhgdm: '',
        tsjsfs: '',
        gllb: '',
        tsjsfsName: '',
        jydz: '',
        lxr: '',
        lxrDh: '',
        lxrDhCzr: '',
      }
      this.sbnypcList = [];
      this.resetSearchAddCkyw();
    },
    resetSearchAddCkyw: function(){
      this.searchAddCkywData = {
        nsrsbh: '',
        sbnypc: '',
        entryId: '',
        sbxh: '',
        glh: '',
        spdm: '',
        ghfnsrsbh: '',
        ckrqq: '',
        ckrqz: '',
        orderSql: "",
        pageSize: 20,
      }
    },

    keydown: function (e, id) {
      if (id == 'zbrwNrsbhList') {
        var index = this.activeBgIndex
        var len = this.nsrsbhList.length
      } else {
        var index = this.activeBgCkywIndex
        var len = this.nsrsbhCkywList.length
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
      if (id == 'zbrwNrsbhList') {
        this.activeBgIndex = index
      } else {
        this.activeBgCkywIndex = index
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
        if (id == 'zbrwNrsbhList') {
          item = this.nsrsbhList[index],
            key = 'searchData'
        } else {
          item = this.nsrsbhCkywList[index],
            key = 'nsrxx'
        }
        if (item) {
          this[key].nsrsbh = item.nsrsbh
          if (id == 'zbrwNrsbhList') {
            this.qySearchVal = item.nsrsbh;
          } else {
            this[key].nsrmc = item.nsrmc;
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
    // 新增
    createTaskConfirm: function () {
      var self = this
      var inspectDatas = [];
      for(var i=0; i<this.ckywChooseList.length; i++){
        var ckywChooseListItem = this.ckywChooseList[i];
        var je = ckywChooseListItem.je.replace(/,/g, '');
        je = parseFloat(je);
        je = isNaN(je)? '': je;
        var se = ckywChooseListItem.se.replace(/,/g, '');
        se = parseFloat(se);
        se = isNaN(se)? '': se;
        var item = {
          sbywzl: ckywChooseListItem.sbywzl,
          sbnypc: ckywChooseListItem.sbnypc,
          sbrq: ckywChooseListItem.sbrq,
          entryId: ckywChooseListItem.entryId,
          ckfpNo: ckywChooseListItem.ckfpNo,
          jhfpNo: ckywChooseListItem.jhfpNo,
          je: je,
          se: se,
          ywlxCode: ckywChooseListItem.ywlxCode,
        }
        inspectDatas.push(item);
      }
      var params = {
        nsrsbh: this.searchAddCkywData.nsrsbh,
        range: this.rangeList.join(','),
        inspectDatas: inspectDatas,
        tsjsfsChg: this.tsjsfsChecked? (this.nsrxx.tsjsfs=='2'? '1': '2'): '',
      }
      if(!params.range){
        tools.info('请至少选择一种核查单证类型');
        return
      }
      api.dzbaDailyBusinessAdd(params).done(function (res) {
        if (res.code == '0') {
          var lxrDhCzr = self.nsrxx.lxrDhCzr || '';
          self.hideModelTask();
          var result = res.data;
          if (!result || result.length == 0) return
          var ids = [];
          for (var i = 0; i < result.length; i++) {
            ids.push(result[i].id)
          }
          var paramsBatch = {
            ids: ids.join(','),
          }
          tools.confirm('任务新增成功，是否立即执行下达？', '下达', function () {
            self.rwxdDialog(api.dzbaDailyReleaseBatch, paramsBatch, lxrDhCzr);
          }, function () {
            self.search(1);
          }, '取消')
        }
      })
    },

    // 下达任务选择期限弹框
    rwxdDialog: function (f, params, lxrDhCzr) {
      var self = this;
      var content = "<div style='padding: 10px 60px 20px 20px'><div style='padding-bottom: 10px;'><label style='display:inline-block;min-width:84px;text-align:right;'>资料报送期限：</label><input id='zbrw-deadline' type='text' data-date-start-date='1d' data-date-end-date='30d' readonly /></div><div style='padding-bottom: 10px;'><label style='display:inline-block;min-width:84px;text-align:right;'>联系电话：</label><input id='zbrw-phone' type='text' /></div></div>"
      $.dialog({
        title: "核查任务下达",
        padding: 0,
        content: content,
        okValue: '确定',
        lock: true,
        ok: function () {
          var phone = $('#zbrw-phone').val().trim();
          params.overdule = $('#zbrw-deadline').val();
          params.lxdh = phone;
          f(params).done(function (res) {
            if (res.code == '0') {
              tools.info("任务下达成功");
              self.search(1);;
            }
          })
        },
        cancelValue: '取消',
        cancel: function () {
          self.search(1);
        }
      })
      var startDate = tools.getNextDay(1);
      var endDate = tools.getNextDay(30);
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, startView: 2, minView: 2, startDate: startDate, endDate: endDate };
      $('#zbrw-deadline').datetimepicker(options);
      $('#zbrw-deadline').val(tools.getNextDay(15));
      if(lxrDhCzr) $('#zbrw-phone').val(lxrDhCzr);
    },

    nextStep: function () {
      var self = this;
      if (this.ckywChooseList.length <= 0) {
        tools.info('请先查询并选择出口业务数据！')
        return false;
      }
      var entryIds = [];
      var params = {
        nsrsbh: this.nsrxx.nsrsbh,
        sbrq: '',
      }
      var sbnypc = '';
      for (var i = 0; i < this.ckywChooseList.length; i++) {
        var ywlxCode = this.ckywChooseList[i].ywlxCode ? this.ckywChooseList[i].ywlxCode : ''
        var entryId = this.ckywChooseList[i].entryId;
        var sbrq = this.ckywChooseList[i].sbrq;
        if(sbrq) params.sbrq = sbrq;
        var sbywzl = this.ckywChooseList[i].sbywzl;
        sbnypc = this.ckywChooseList[i].sbnypc;
        entryIds.push({ 
          ywlxCode: ywlxCode, 
          entryId: entryId, 
          sbrq: sbrq,
          sbywzl: sbywzl,
          sbnypc: sbnypc,
        })
      }
      // 先判断申报日期是否在开通数字化单证备案之前
      api.dzbaDailyJudge(params).done(function(res){
        if(res.code==0){
          if(res.data=='Y'){
            $.dialog({
              title: '提示',
              content: '您选择的申报批次【'+sbnypc+'】，为企业开通数字化单证备案前的申报批次，是否继续？',
              okValue: '确定',
              lock: true,
              ok: function(){
                self.addIndex = 1;
                self.getTypeTreeData({ nsrsbh: self.nsrxx.nsrsbh, entryIds: entryIds, type: 'daily' })
              },
              cancelValue: '取消',
              cancel: function(){},
            })
          } else{
            self.addIndex = 1;
            self.getTypeTreeData({ nsrsbh: self.nsrxx.nsrsbh, entryIds: entryIds, type: 'daily' })
          }
        }
      })
    },
    // 获取核查单证类型
    getTypeTreeData: function (params) {
      var self = this;
      self.typeTreeData = [];
      params.tsjsfsChg = this.tsjsfsChecked? (this.nsrxx.tsjsfs=='2'? '1': '2'): '',
      api.dzbaInspectTree(params).done(function (res) {
        if (res.code == '0') {
          self.typeTreeData = res.data
          self.rangeList = []
          for (var i = 0; i < self.typeTreeData.length; i++) {
            var item = self.typeTreeData[i].item
            for (var j = 0; j < item.length; j++) {
              if (item[j].checked) {
                self.rangeList.push(item[j].value)
              }
            }
          }
        }
      })
    },
    // 输入框变更事件
    inpChg: function (type) {
      this.searchAddCkywData[type] = this.searchAddCkywData[type].trim();
    },
  }
})