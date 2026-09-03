var jdglinfo = require('../../../config/jdglinfo.js');
var dzhcDzsh = require("./dzhcDzsh.html");

avalon.component('dzhcDzsh', {
  template: dzhcDzsh,
  defaults: {
    qySearchType: 'nsrsbh', // nsrsbh-纳税人识别号，qymc-企业名称，hgdm-海关代码
    qySearchVal: '',
    swjgmc: "",
    selRows: [], // 选中项
    searchData: {
      swjgdm: "",
      year: "",
      nsrsbh: "",
      nsrmc: "",
      qyhgdm: "",
      qylx: "",
      flglcd: "",
      qygm: "",
      balx: "",
      status: "",
      reportStatus: "",
      examineStatus: "",
      projectResult: "",
      yqbz: "",
      orderSql: "",
      pageNo: 1,
      pageSize: 20,
    },
    sbpcList: [],
    mainSbpcList: [], // 主列表查询条件中申报批次列表
    rangeList: [], // 新增时选中的核查单证类型
    editRangeList: [], // 编辑/查看时选中的核查单证类型
    modelData: {
      ids: [],
      qymcs: [],
      confirmInfo: '',
      projectResultInit: '1',  // 1-合格 2-整改后合格 3-不合格
      projectResult: '1',  // 1-合格 2-整改后合格 3-不合格
      inspectNote: '',
      problemNum: '',
      problemDatas: [],
      problemSe: '',
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
      lxrDh: ''
    },
    tableArr: [],
    tableOption: [],
    tableData: {},
    setData: {
      zczt: "",
      ktpt: ""
    },
    showNsrsbhList: false,
    nsrsbhList: [],
    timeout: null,
    activeBgIndex: -1,
    isPlsh: false,
    jcxmmxDict: [
      {
        baseTitle: '企业基础信息',
        infos: [
          { infoLabel: '税务机关：', infoIndex: 'swjgmc', infoTitle: '', infoCls: '' },
          { infoLabel: '纳税人识别号：', infoIndex: 'nsrsbh', infoTitle: '', infoCls: '' },
          { infoLabel: '企业名称：', infoIndex: 'nsrmc', infoTitle: '', infoCls: '' },
          { infoLabel: '企业海关代码：', infoIndex: 'qyhgdm', infoTitle: '', infoCls: '' },
          { infoLabel: '企业类型：', infoIndex: 'qylx', infoTitle: '', infoCls: '' },
          { infoLabel: '管理等级：', infoIndex: 'flglcd', infoTitle: '', infoCls: '' },
          { infoLabel: '立项年度：', infoIndex: 'year', infoTitle: '', infoCls: '' },
          { infoLabel: '备案方式：', infoIndex: 'balx', infoTitle: '', infoCls: '' },
          { infoLabel: '项目状态：', infoIndex: 'statusName', infoTitle: '', infoCls: '' },
          { infoLabel: '立项日期：', infoIndex: 'approveTime', infoTitle: '', infoCls: '' },
          { infoLabel: '回证日期：', infoIndex: 'receiptTime', infoTitle: '', infoCls: '' },
          { infoLabel: '项目期限：', infoIndex: 'deadline', infoTitle: '', infoCls: '' },
          { infoLabel: '项目序号：', infoIndex: 'xmxh', infoTitle: '', infoCls: '' },
          { infoLabel: '企业规模：', infoIndex: 'qygm', infoTitle: '', infoCls: '' },
        ]
      },
      {
        baseTitle: '审核信息',
        infos: [
          { infoLabel: '审核人：', infoIndex: 'inspector', infoTitle: '', infoCls: '' },
          { infoLabel: '核查完成日期：', infoIndex: 'inspectTime', infoTitle: '', infoCls: '' },
          { infoLabel: '项目结论：', infoIndex: 'projectResult', infoTitle: '', infoCls: '' },
          { infoLabel: '核查意见：', infoIndex: 'inspectNote', infoTitle: '', infoCls: '' },
        ]
      },
      {
        baseTitle: '复核信息',
        infos: [
          { infoLabel: '复核人：', infoIndex: 'reviewer', infoTitle: '', infoCls: '' },
          { infoLabel: '复核日期：', infoIndex: 'reviewTime', infoTitle: '', infoCls: '' },
          { infoLabel: '复核意见：', infoIndex: 'reviewNote', infoTitle: '', infoCls: '' },
        ]
      },
      {
        baseTitle: '发放信息',
        infos: [
          { infoLabel: '发放人：', infoIndex: 'issuer', infoTitle: '', infoCls: '' },
          { infoLabel: '发放日期：', infoIndex: 'issueTime', infoTitle: '', infoCls: '' },
          { infoLabel: '联系人：', infoIndex: 'lxr', infoTitle: '', infoCls: '' },
          { infoLabel: '联系电话：', infoIndex: 'lxdh', infoTitle: '', infoCls: '' },
          { infoLabel: '业务笔数：', infoIndex: 'ywbs', infoTitle: '', infoCls: '' },
        ]
      },
    ],
    jcxmmxInfo: {
      swjgmc: '',
      nsrsbh: '',
      nsrmc: '',
      qyhgdm: '',
      qylx: '',
      flglcd: '',
      year: '',
      balx: '',
      status: '',
      statusName: '',
      approveTime: '',
      receiptTime: '',
      deadline: '',
      xmxh: '',
      qygm: '',
      inspector: '',
      inspectTime: '',
      projectResult: '',
      inspectNote: '',
      reviewer: '',
      reviewTime: '',
      reviewNote: '',
      issuer: '',
      issueTime: '',
      lxr: '',
      lxdh: '',
      ywbs: '',
    },
    qygmList: jdglinfo.qygmList,

    resetSearchData: function () {
      this.searchData = {
        swjgdm: this.searchData.swjgdm,
        year: this.searchData.year,
        nsrsbh: "",
        nsrmc: "",
        qyhgdm: "",
        qylx: "",
        flglcd: "",
        qygm: "",
        balx: "",
        status: "",
        reportStatus: "",
        examineStatus: "",
        projectResult: "",
        yqbz: "",
        orderSql: "",
        pageNo: 1,
        pageSize: 20,
      }
      this.qySearchVal = '';
    },
    onInit: function (e) {
      avalonRoot.dzhcDzsh = e.vmodel;
    },
    onReady: function () {
      this.isWindows = tools.isWindows();
      this.initUser();
      this.initTree();
      this.initDate();
      this.initHeight();
      this.createTable();
      this.createTableBhgmx();
    },

    // 初始化用户数据
    initUser: function () {
      var self = this;
      if (avalonRoot.user && avalonRoot.user.swjgDm) {
        this.searchData.swjgdm = avalonRoot.user.swjgDm;
        this.swjgmc = avalonRoot.user.swjgMc;
      } else {
        api.preLogin().done(function (res) {
          if (res.code == '0') {
            avalonRoot.user = res.data;
            self.searchData.swjgdm = avalonRoot.user.swjgDm;
            self.swjgmc = avalonRoot.user.swjgMc;
          }
        })
      }
    },

    // 初始化日期输入框
    initDate: function () {
      // this.searchData.year = new Date().getFullYear() - 1 + '';
      var endDate = new Date().getFullYear() + '';
      $('.dzhc-dzsh .datepicker.date-year').datetimepicker({
        format: 'yyyy',
        language: "zh-CN",
        clearBtn: true,
        autoclose: true,
        startView: 4, // 这里就设置了默认视图为年视图
        minView: 4, // 设置最小视图为年视图
        // startDate: '2019',
        endDate: endDate,
      });
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function (e) {
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".dzhc-dzsh .form").height();
        if (h > 100) {
          $("#dzhc-dzsh-table").jqGrid('setGridHeight', h - 70);
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
    createTable: function () {
      var self = this;
      var columns = [
        {
          name: "op2", label: "操作", width: 0, frozen: true, align: "center", resizable: false, search: false, sortable: false, formatter: function (cellVal, op, row) {
            var checkFinish_enable = row.status == 1;
            var issue_enable = row.status == 3;
            var h = '';
            h += "<div class='btn op-btn op-edit' title='查看'>查看</div>" // 查看
            h += "<div class='btn op-btn op-checkFinish " + (checkFinish_enable ? '' : 'op-disabled') + "' title='核查完成'>核查完成</div>" // 核查完成
            h += "<div class='btn op-btn op-issue " + (issue_enable ? '' : 'op-disabled') + "' title='发放'>发放</div>" // 发放
            return h
          }
        },
        {
          name: "id", label: "项目序号", index: "id", width: 50, align: "center", sortable: true,
          formatter: function (cellVal, op, row) {
            var h = '';
            h += "<div class='op-line op-nsrmc' title='点击查看项目详情'>" + cellVal + "</div>"
            return h
          }
        },
        { name: "swjgdm", label: "税务机关代码", index: "swjgdm", hidden: true },
        { name: "swjgmc", label: "税务机关", index: "swjgmc", width: 80, sortable: true },
        { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh", width: 125, sortable: false },
        { name: "nsrmc", label: "企业名称", index: "nsrmc", width: 120, sortable: false },
        { name: "balx", label: "备案方式", index: "balx", width: 80, align: "center", sortable: true },
        { name: "year", label: "年度", index: "year", width: 40, align: "center" },
        { name: "status", label: "项目状态", index: "status", hidden: true },
        { name: "statusName", label: "项目状态", index: "statusName", width: 55, align: "center", sortable: true },
        {
          name: "ywbs", label: "业务笔数", index: "ywbs", width: 55, align: "right", sortable: true,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        { name: "inspector", label: "审核人", index: "inspector", width: 55, align: "center", sortable: true },
        {
          name: "approveTime", label: "立项日期", index: "approveTime", width: 125, align: "center",
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            var h = '';
            if (row.balx == '纸质备案') {
              h += cellVal;
            } else {
              h += "<div class='op-line op-approve' title='点击预览税务事项通知书'>" + cellVal + "</div>";
            }
            return h
          }
        },
        {
          name: "receiptTime", label: "回证日期", index: "receiptTime", width: 125, align: "center",
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            var h = '';
            if (row.balx == '纸质备案') {
              h += cellVal;
            } else {
              h += "<div class='op-line op-receipt' title='点击预览企业回证文件'>" + cellVal + "</div>";
            }
            return h
          }
        },
        { name: "deadline", label: "项目期限", index: "deadline", width: 70, align: "center" },
        { name: "inspectTime", label: "核查完成日期", index: "inspectTime", width: 120, align: "center", sortable: true },
        { name: "projectResult", label: "项目结论", index: "projectResult", width: 80, align: "center", sortable: true },
        { name: "reviewer", label: "复核人", index: "reviewer", width: 55, align: "center", sortable: true },
        { name: "reviewTime", label: "复核日期", index: "reviewTime", width: 120, align: "center", sortable: true },
        { name: "issueTime", label: "发放日期", index: "issueTime", width: 120, align: "center", sortable: true },
        { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm", width: 100, align: "left", sortable: false },
        { name: "qylx", label: "企业类型", index: "qylx", width: 120, align: "center", sortable: true },
        { name: "qygm", label: "企业规模", index: "qygm", width: 60, align: "center" },
        { name: "flglcd", label: "管理等级", index: "flglcd", width: 70, align: "center", sortable: true },
        { name: "op", label: "操作", width: 215, align: "center", resizable: false, search: false, sortable: false }
      ];
      $("#dzhc-dzsh-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#dzhc-dzsh-tablePager',
        shrinkToFit: false,
        width: "100%",
        multiselect: true,
        multiselectWidth: "30",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: 20,
        rownumWidth: 40,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".dzhc-dzsh .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $('#dzhc-dzsh-table').jqGrid('getRowData', rowid);
          row.id = $(row.id).html();
          if ($(e.target).hasClass('op-disabled')) return
          if ($(e.target).hasClass('op-edit')) { // 查看
            // 打开出口业务
            row.queryType = 'sh';
            avalonRoot.addTab({
              title: '单证核查审核-出口业务',
              component: 'dzhcCkyw',
              params: row,
            })
            return false
          } else if ($(e.target).hasClass('op-checkFinish')) { // 核查完成
            self.showModelShPre(false, row);
            return false
          } else if ($(e.target).hasClass('op-issue')) { // 发放
            self.issueConfirm(false, row)
            return false
          } else if ($(e.target).hasClass('op-nsrmc')) { // 企业项目基础信息  
            self.baseInfo(row);
            return false
          } else if ($(e.target).hasClass('op-approve')) { // 立项 - 查看税务事项通知书
            self.showViewPdfApprove(row, '001');
            return false
          } else if ($(e.target).hasClass('op-receipt')) { // 回证 - 查看回证PDF
            self.showViewPdfReceipt(row);
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
          var pageNo = tools.getPageNo(pgButton, "dzhc-dzsh-table");
          self.search(pageNo);
        },
        onSelectRow: function (rowid, status) {
          var index = self.selRows.indexOf(rowid);
          if (status) {
            self.selRows.push(rowid)
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
        }
      })
      $("#dzhc-dzsh-table").jqGrid('setFrozenColumns');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-dzsh')).val();
      this.search(1)
    },
    createTableBhgmx: function () {
      var columns = [
        { name: "id", label: "核查业务序号", index: "id", hidden: true },
        { name: "sbywzl", label: "申报业务种类", index: "sbywzl", width: 80, align: "center", sortable: false },
        { name: "sbnypc", label: "申报年月批次", index: "sbnypc", width: 80, align: "center", sortable: false },
        { name: "entryId", label: "报关单号", index: "entryId", width: 135, sortable: false },
        {
          name: "je", label: "出口销售金额(美元)", index: "je", width: 110, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "se", label: "申报退税额", index: "se", width: 90, align: "right", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        { name: "examineResult", label: "审核结论", index: "examineResult", width: 115, sortable: false },
        { name: "examineNote", label: "审核意见", index: "examineNote", width: 125, sortable: false },
      ];
      $("#dzhc-dzsh-bhgmx-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: true,
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        height: 300,
      })
    },

    // 预览税务事项通知书
    showViewPdfApprove: function (row, type) {
      var self = this;
      var params = {
        id: row.id,
        type: type, // 001-税务事项通知书
      }
      api.dzbaInspectYearProjectView(params).done(function (res) {
        if (res.code == '0') {
          if (!res.data) {
            tools.info('未获取到文件信息');
            return
          }
          if (self.isWindows) {
            // Windows 系统：调用单证助手客户端
            var param = {
              fileName: '',
              fileUrl: res.data.fileUrl,
              fileStream: res.data.fileStream,
              title: '税务事项通知书'
            }
            apiClient.checkDzjNew(param);
          } else {
            // 非 Windows 系统：使用 PDF.js 预览
            if (!res.data.fileStream) {
              tools.info('未获取到文件信息');
              return
            }
            components['pdfViewerglobal-pdf'].showPdf(res.data.fileStream, '税务事项通知书');
          }
        }
      });
    },

    // 预览回证PDF
    showViewPdfReceipt: function (row) {
      var self = this;
      var params = {
        bizType: 'receipt',
        bizKey: row.id,
      }
      api.dzbaFileViewPDF(params).done(function (res) {
        if (res.code == '0') {
          if (!res.data) {
            tools.info('未获取到文件信息');
            return
          }
          if (self.isWindows) {
            // Windows 系统：调用单证助手客户端
            if (!res.data.fileUrl) {
              tools.info('未获取到文件信息');
              return
            }
            var param = {
              fileName: '',
              fileUrl: res.data.fileUrl,
              title: '回证文书'
            }
            apiClient.checkDzjNew(param);
          } else {
            // 非 Windows 系统：使用 PDF.js 预览
            if (!res.data.fileStream) {
              tools.info('未获取到文件信息');
              return
            }
            components['pdfViewerglobal-pdf'].showPdf(res.data.fileStream, '回证文书');
          }
        }
      });
    },

    nsrsbhEnterSearch: function (e) {
      e.target.blur()
      this.showNsrsbhList = false
      this.search(1)
    },
    search: function (pageNo) {
      var self = this;
      var fields = [
        { name: "qyhgdm", rules: 'max_length[10]', message: "海关代码最大长度为10" },
        { name: "nsrmc", rules: 'max_length[30]', message: "纳税人名称最大长度为30" },
      ];

      var isValid = tools.validate("dzhc-dzsh-form", fields);
      if (isValid) {
        // 处理外层查询条件切换时的问题
        this.qySearchValChg();
        this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-dzsh')).val() || 20;
        self.searchData.pageNo = pageNo;
        var params = tools.clone(self.searchData);
        $("#dzhc-dzsh-table").jqGrid('clearGridData')
        api.dzbaYearExamineList(params).done(function (res) {
          if (res.code == '0') {
            $("#dzhc-dzsh-table").resetSelection();
            $("#dzhc-dzsh-table")[0].addJSONData(res.data);
            self.tableData = res.data;
            self.selRows = [];
            tools.HeiKj('dzhc-dzsh', 'dzhc-dzsh-table')
            self.closeHyper()
            $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
          }
        })
      }
    },
    showHyper: function () {
      $('.dzhc-dzsh .page .select-sub').toggle();
      $('.dzhc-dzsh .page .select-wrapper .icon').toggleClass("active");
      if ($('.dzhc-dzsh .page .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
        $('.dzhc-dzsh .page .select-wrapper .icon').attr("title", "收起查询条件");
      } else {
        $('.dzhc-dzsh .page .select-wrapper .icon').attr("title", "展开查询条件")
      }
    },
    closeHyper: function () {
      $('.dzhc-dzsh .select-sub').hide();
      $('.dzhc-dzsh .select-wrapper .icon').removeClass('active');
      $('.dzhc-dzsh .select-wrapper .icon').attr("title", "展开查询条件")
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
        lxrDh: ''
      }
      this.sbpcList = []
    },
    resetTask: function () {
      this.resetNsrxx()
    },

    showBhgmx: function () {
      $('.dzhc-dzsh .page-model-check-bhgmx').show();
      $("#dzhc-dzsh-bhgmx-table").jqGrid('clearGridData');
      $("#dzhc-dzsh-bhgmx-table")[0].addJSONData(this.modelData.problemDatas);
    },

    hideBhgmx: function () {
      $('.dzhc-dzsh .page-model-check-bhgmx').hide();
    },

    // 单笔核查完成 - 服务端前置 - 获取信息
    showModelShPre: function (isPlsh, row) {
      var self = this;
      var params = {
        ids: isPlsh ? this.modelData.ids.join(',') : row.id,
      }
      api.dzbaYearExamineInspectPre(params).done(function (res) {
        if (res.code == '0') {
          self.modelData.projectResultInit = res.data.projectResult;
          self.modelData.projectResult = res.data.projectResult;
          self.modelData.problemNum = avalon.filters.number(res.data.problemNum, 0);
          self.modelData.problemSe = avalon.filters.number(res.data.problemSe, 2);
          self.modelData.problemDatas = res.data.problemDatas || [];
          if (!isPlsh) {
            self.frontCheckFinishSingle(row);
          }
          self.showModelSh(isPlsh);
        }
      })
    },

    // 批量核查完成 - 服务端前置 - 校验当前选中项目是否存在有问题的业务
    showModelShPreCheck: function () {
      var self = this;
      var curRow = this.frontCheckFinishPl();
      if (this.modelData.ids.length == 0) {
        tools.info('请至少选择一笔可核查的任务');
        return
      } else if (this.modelData.ids.length == 1) {  // 如果多选时只有一笔，则按单笔核查完成进行
        this.showModelShPre(false, curRow);
        return
      } else {
        var params = {
          ids: this.modelData.ids.join(','),
        }
        api.dzbaYearExamineInspectBatchCheck(params).done(function (res) {
          if (res.code == '0') {
            if (res.data) {
              // 重置选中行
              self.resetSelrows(res.data);
              var ct = '<p style="text-indent: 2em;">检测到项目序号【';
              ct += res.data;
              ct += '】下存在核查有问题的业务数据。批量核查完成时，仅支持设置项目结论为合格或整改后合格，若要设置核查项目为不合格请单独执行核查完成并录入核查不合格的意见，是否继续？</p>';
              ct += '<p style="color: red; height: 30px; line-height: 30px;">注：点击继续后将忽略核查有问题的项目。</p>'
              $.dialog({
                padding: '10px 20px',
                title: "核查完成",
                content: ct,
                okValue: '确定',
                lock: true,
                ok: function () {
                  self.frontCheckFinishPl();
                  self.showModelShPre(true, '');
                },
              })
            } else {
              self.showModelShPre(true, '');
            }
          }
        })
      }
    },

    resetSelrows: function (ids) {
      var curSelrows = tools.clone(this.selRows);
      this.selRows = [];
      var delIds = ids.split(',');
      for (var i = 0; i < curSelrows.length; i++) {
        if (delIds.indexOf(curSelrows[i]) == -1) {
          $("#dzhc-dzsh-table").jqGrid('setSelection', curSelrows[i]);
          this.selRows.push(curSelrows[i]);
        }
      }
    },

    // 批量核查完成前置处理
    frontCheckFinishPl: function () {
      var curRow = null;
      this.modelData.ids = [];
      this.modelData.qymcs = [];
      for (var i = 0; i < this.selRows.length; i++) {
        for (var j = 0; j < this.tableData.rows.length; j++) {
          if (this.selRows[i] == this.tableData.rows[j].id && this.tableData.rows[j].status != '3') {
            curRow = this.tableData.rows[j];
            this.modelData.ids.push(this.tableData.rows[j].id);
            this.modelData.qymcs.push(this.tableData.rows[j].nsrmc + this.tableData.rows[j].year + '年度');
            continue
          }
        }
      }
      this.modelData.confirmInfo = '确定完成对';
      this.modelData.confirmInfo += this.modelData.qymcs.slice(0, 2).join('，');
      if (this.modelData.qymcs.length > 1) this.modelData.confirmInfo += '等';
      this.modelData.confirmInfo += '的核查吗？';

      return curRow
    },
    // 单项核查完成前置处理
    frontCheckFinishSingle: function (row, isPlsh) {
      this.modelData.ids = [row.id];
      var nsrmc = row.nsrmc;
      this.modelData.qymcs = [nsrmc];
      this.modelData.confirmInfo = '确定完成对' + nsrmc + row.year + '年度的核查吗？'
    },

    showModelSh: function (isPlsh, row) {
      this.isPlsh = isPlsh;
      $('.model').show();
      $('.dzhc-dzsh .page-model-check').show();
      var curResult = this.modelData.projectResult;
      this.modelData.projectResult = -1;
      this.modelData.projectResult = curResult;
    },

    hideModelSh: function () {
      $('.model').hide();
      $('.dzhc-dzsh .page-model-check').hide();
      this.modelData = {
        ids: [],
        qymcs: [],
        confirmInfo: '',
        projectResultInit: '1',  // 1-合格 2-整改后合格 3-不合格
        projectResult: '1',  // 1-合格 2-整改后合格 3-不合格
        inspectNote: '',
        problemNum: '',
        problemDatas: [],
        problemSe: '',
      }
    },
    saveModelSh: function () {
      var self = this
      tools.confirm(self.modelData.confirmInfo, '确定', function () {
        var params = {
          projectResult: self.modelData.projectResult,
        }
        if (self.modelData.projectResult != '3') {
          params.inspectNote = '本次备案单证核查暂无发现问题。';
        } else {
          params.inspectNote = '本次备案单证核查发现';
          params.inspectNote += self.modelData.problemNum;
          params.inspectNote += '个问题，应追回出口退税款';
          params.inspectNote += self.modelData.problemSe;
          params.inspectNote += '元，请于本次备案单证核查项目放发后15个工作日内到主管税务机关补缴。';
        }
        var fnConfirm = api.dzbaYearExamineInspectSingle;
        if (self.isPlsh) {
          params.ids = self.modelData.ids.join(',');
          fnConfirm = api.dzbaYearExamineInspectBatch;
        } else {
          params.id = self.modelData.ids.join(',');
        }
        fnConfirm(params).done(function (res) {
          if (res.code == '0') {
            tools.info('核查完成成功')
            self.search(self.searchData.pageNo);
          }
          self.hideModelSh();
        })
      })
    },

    // 发放确认框
    issueConfirm: function (isPl, row) {
      var self = this;
      var html = '';
      if (isPl) {
        var issueSel = this.getIssueSel();
        if (issueSel.ids.length == 0) {
          tools.info('请至少选择一笔项目状态为【发放】的任务');
          return
        }
        html += issueSel.qymcs.join('，');
        if (issueSel.qymcs.length > 1) html += '等';
      } else {
        var nsrmc = row.nsrmc;
        html += nsrmc + '【' + row.year + '】年度'
      }
      html += '的项目结论和核查意见信息会同步到企业，项目将置结案状态，是否确定发放？';
      $.dialog({
        padding: '10px 20px',
        title: "核查任务发送",
        content: html,
        okValue: '确定',
        lock: true,
        ok: function () {
          if (isPl) {
            self.dzbaYearExamineIssueBatch(issueSel)
          } else {
            self.dzbaYearExamineIssueSingle(row)
          }
        },
      })
    },
    // 批量选中的可发放项
    getIssueSel: function () {
      var issueSel = {
        ids: [],
        qymcs: [],
      };
      for (var i = 0; i < this.selRows.length; i++) {
        for (var j = 0; j < this.tableData.rows.length; j++) {
          if (this.selRows[i] == this.tableData.rows[j].id && this.tableData.rows[j].status != '1') {
            issueSel.ids.push(this.tableData.rows[j].id);
            issueSel.qymcs.push(this.tableData.rows[j].nsrmc + '【' + this.tableData.rows[j].year + '】年度');
            continue
          }
        }
      }
      return issueSel
    },
    // 发送 - 批量
    dzbaYearExamineIssueBatch: function (issueSel) {
      var self = this;
      var params = {
        ids: issueSel.ids.join(',')
      }
      api.dzbaYearExamineIssueBatch(params).done(function (res) {
        if (res.code == '0') {
          tools.info('批量发放成功');
          self.search(self.searchData.pageNo);
        }
      })
    },
    // 发送 - 单笔
    dzbaYearExamineIssueSingle: function (row) {
      var self = this;
      var params = {
        id: row.id
      }
      api.dzbaYearExamineIssueSingle(params).done(function (res) {
        if (res.code == '0') {
          tools.info('发送成功');
          self.search(self.searchData.pageNo);
        }
      })
    },

    // 纳税人识别号钻取弹框 - 状态信息查询
    baseInfo: function (row) {
      var self = this;
      var params = {
        id: row.id,
      }
      api.dzbaYearProjectBaseinfo(params).done(function (res) {
        if (res.code == '0') {
          res.data.xmxh = row.id;
          self.jcxmmxInfo = res.data;

          $('.model').show();
          $('.dzhc-dzsh .page-model-qyDetail').show();
        }
      })
    },

    hideModelBaseinfo: function () {
      $('.model').hide();
      $('.dzhc-dzsh .page-model-qyDetail').hide();
      this.jcxmmxInfo = {
        swjgmc: '',
        nsrsbh: '',
        nsrmc: '',
        qyhgdm: '',
        qylx: '',
        flglcd: '',
        year: '',
        balx: '',
        status: '',
        statusName: '',
        approveTime: '',
        receiptTime: '',
        deadline: '',
        xmxh: '',
        qygm: '',
        inspector: '',
        inspectTime: '',
        projectResult: '',
        inspectNote: '',
        reviewer: '',
        reviewTime: '',
        reviewNote: '',
        issuer: '',
        issueTime: '',
        lxr: '',
        lxdh: '',
        ywbs: '',
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
          $.fn.zTree.init($(".dzhc-dzsh .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.dzhc-dzsh').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }
      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.dzhc-dzsh').off('click');
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
            self.activeBgIndex = self.nsrsbhList.length > 0 ? 0 : -1
            self.showNsrsbh()
          }
        }
      })
    },
    setNsrsbh: function (item, key) {
      this[key].nsrsbh = item.nsrsbh;
      this.showNsrsbhList = false
      if (key == 'nsrxx') {
      } else {
        this.qySearchVal = item.nsrsbh;
        this.search(1)
      }
    },
    // 显示纳税人识别号弹框
    showNsrsbh: function () {
      if (this.qySearchType != 'nsrsbh') return
      var list = this.nsrsbhList
      this.showNsrsbhList = list && list.length > 0;
    },
    // 隐藏纳税人识别号弹框
    hideNsrsbh: function (e) {
      if ($(e.target).parent().hasClass('nsrsbh-group')) return
      this.showNsrsbhList = false
    },
    keydown: function (e, id) {
      if (id == 'dzshNrsbhList') {
        if (this.qySearchType != 'nsrsbh') return
        var index = this.activeBgIndex
        var len = this.nsrsbhList.length
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
      if (id == 'dzshNrsbhList') {
        this.activeBgIndex = index
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
        if (id == 'dzshNrsbhList') {
          item = this.nsrsbhList[index],
            key = 'searchData'
        }
        if (item) {
          this[key].nsrsbh = item.nsrsbh
          if (id == 'dzshNrsbhList') {
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


    exform: function () {
      tools.exform(this.searchData, '/dzba/export/inspect/year/examine');
    },

    // 核查完成输入框变更事件
    modelDataChg: function (item) {
      var n = 0;
      if (item == 'problemSe') n = 2;
      this.modelData[item] = avalon.filters.number(this.modelData[item].replace(/,/g, ''), n);
    },
  }
});