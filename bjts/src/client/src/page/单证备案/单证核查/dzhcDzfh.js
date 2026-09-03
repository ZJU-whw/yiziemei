var jdglinfo = require('../../../config/jdglinfo.js');
var dzhcDzfh = require("./dzhcDzfh.html");

avalon.component('dzhcDzfh', {
  template: dzhcDzfh,
  defaults: {
    qySearchType: 'nsrsbh', // nsrsbh-纳税人识别号，qymc-企业名称，hgdm-海关代码
    qySearchVal: '',
    swjgmc: "",
    selRows: [], // 选中项
    searchData: {
      swjgdm: "",
      status: "2",
      year: "",
      nsrsbh: "",
      nsrmc: "",
      qyhgdm: "",
      qylx: "",
      flglcd: "",
      qygm: "",
      balx: "",
      projectResult: "",
      yqbz: "",
      inspector: "",
      reviewer: "",
      reviewNote: "",
      orderSql: "",
      pageNo: 1,
      pageSize: 20,
    },
    rangeList: [], // 新增时选中的核查单证类型
    editRangeList: [], // 编辑/查看时选中的核查单证类型
    modelData: {
      id: '',
      inspectNo: '',
      inspectResult: '1',
      processType: '',
      resultState: ''
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
          { infoLabel: '立项日期：', infoIndex: 'approveTime', infoTitle: '点击预览税务事项通知书', infoCls: 'cursor' },
          { infoLabel: '回证日期：', infoIndex: 'receiptTime', infoTitle: '点击预览回证文书', infoCls: 'cursor' },
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
    inspectorList: [], // 审核人列表
    qygmList: jdglinfo.qygmList,

    resetSearchData: function () {
      this.searchData = {
        swjgdm: this.searchData.swjgdm,
        year: this.searchData.year,
        status: "2",
        nsrsbh: "",
        nsrmc: "",
        qyhgdm: "",
        qylx: "",
        flglcd: "",
        qygm: "",
        balx: "",
        projectResult: "",
        yqbz: "",
        inspector: "",
        reviewer: "",
        reviewNote: "",
        orderSql: "",
        pageNo: 1,
        pageSize: 20,
      }
      this.qySearchVal = '';
    },
    onInit: function (e) {
      avalonRoot.dzhcDzfh = e.vmodel;
    },
    onReady: function () {
      this.isWindows = tools.isWindows();
      this.initUser();
      this.initTree();
      this.initDate();
      this.initHeight();
      this.getInspectorList();
      this.createTable();
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
      $('.dzhc-dzfh .datepicker.date-year').datetimepicker({
        format: 'yyyy',
        language: "zh-CN",
        clearBtn: true,
        autoclose: true,
        startView: 4, // 这里就设置了默认视图为年视图
        minView: 4, // 设置最小视图为年视图
        // startDate: '2020',
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
        var h = $(".dzhc-dzfh .form").height();
        if (h > 100) {
          $("#dzhc-dzfh-table").jqGrid('setGridHeight', h - 70);
        }
      })
    },

    // 获取审核人列表
    getInspectorList: function () {
      var self = this;
      if (this.inspectorList.length == 0) {
        var params = {
          swjgdm: this.searchData.swjgdm,
        }
        api.dzbaYearProjectInspectorList(params).done(function (res) {
          if (res.code == 0) {
            self.inspectorList = res.data;
          }
        })
      }
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
            var h = '';
            var review_enable = row.status == 2;
            var back_enable = row.status == 2;
            h += "<div class='btn op-btn op-open' title='查看'>查看</div>" // 查看
            h += "<div class='btn op-btn op-review " + (review_enable ? '' : 'op-disabled') + "' title='复核完成'>复核完成</div>" // 复核完成
            h += "<div class='btn op-btn op-back " + (back_enable ? '' : 'op-disabled') + "' title='退回'>退回</div>" // 退回
            return h
          }
        },
        {
          name: "id", label: "项目序号", index: "id", width: 50, align: "center", sortable: true,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
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
        { name: "year", label: "年度", index: "year", width: 40, align: "center", sortable: true },
        { name: "status", label: "项目状态", index: "status", hidden: true },
        { name: "statusName", label: "项目状态", index: "statusName", width: 55, align: "center", sortable: false },
        {
          name: "ywbs", label: "业务笔数", index: "ywbs", width: 55, align: "center", sortable: false,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            if (cellVal) cellVal = avalon.filters.number(cellVal, 0);
            return cellVal
          }
        },
        { name: "inspector", label: "审核人", index: "inspector", width: 55, align: "left", sortable: true },
        {
          name: "approveTime", label: "立项日期", index: "approveTime", width: 125, align: "center", sortable: true,
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
          name: "receiptTime", label: "回证日期", index: "receiptTime", width: 125, align: "center", sortable: true,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
            var h = '';
            if (row.balx == '纸质备案') {
              h += cellVal;
            } else {
              h += "<div class='op-line op-receipt' title='点击预览回证文书'>" + cellVal + "</div>";
            }
            return h
          }
        },
        { name: "deadline", label: "项目期限", index: "deadline", width: 70, align: "center", sortable: true },
        { name: "inspectTime", label: "核查完成日期", index: "inspectTime", width: 120, align: "center", sortable: true },
        { name: "projectResult", label: "项目结论", index: "projectResult", width: 120, align: "center", sortable: false },
        { name: "reviewer", label: "复核人", index: "reviewer", width: 55, align: "center", sortable: true },
        { name: "reviewTime", label: "复核日期", index: "reviewTime", width: 120, align: "center", sortable: true },
        { name: "issueTime", label: "发放日期", index: "issueTime", width: 120, align: "center", sortable: true },
        { name: "qyhgdm", label: "企业海关代码", index: "qyhgdm", width: 100, align: "left", sortable: false },
        { name: "qylx", label: "企业类型", index: "qylx", width: 120, align: "center", sortable: false },
        { name: "qygm", label: "企业规模", index: "qygm", width: 60, align: "center", sortable: true },
        { name: "flglcd", label: "管理等级", index: "flglcd", width: 70, sortable: true },
        { name: "op", label: "操作", width: 215, align: "center", resizable: false, search: false, sortable: false }
      ];
      $("#dzhc-dzfh-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#dzhc-dzfh-tablePager',
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
          return $(".dzhc-dzfh .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          var row = $('#dzhc-dzfh-table').jqGrid('getRowData', rowid);
          row.id = $(row.id).html();
          if ($(e.target).hasClass('op-disabled')) return
          if ($(e.target).hasClass('op-open')) { // 查看
            // 打开出口业务详情
            row.queryType = 'fh';
            avalonRoot.addTab({
              title: '单证核查复核-出口业务',
              component: 'dzhcCkyw',
              params: row,
            })
            return false
          } else if ($(e.target).hasClass('op-review')) { // 复核完成
            self.reviewConfirm(false, row);
            return false
          } else if ($(e.target).hasClass('op-back')) { // 退回
            self.backConfirm(false, row);
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
          var pageNo = tools.getPageNo(pgButton, "dzhc-dzfh-table");
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
      $("#dzhc-dzfh-table").jqGrid('setFrozenColumns');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-dzfh')).val();
      this.search(1)
    },

    // 预览税务事项通知书
    showViewPdfApprove: function (row, type) {
      var self = this;
      var params = {
        id: row.id,
        type: type,
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
        { name: "hgdm", rules: 'max_length[10]', message: "海关代码最大长度为10" },
        { name: "nsrmc", rules: 'max_length[30]', message: "纳税人名称最大长度为30" },
      ];
      var isValid = tools.validate("dzhc-dzfh-form", fields);
      if (isValid) {
        // 处理外层查询条件切换时的问题
        this.qySearchValChg();
        this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-dzfh')).val() || 20;
        self.searchData.pageNo = pageNo;
        var params = tools.clone(self.searchData);
        $("#dzhc-dzfh-table").jqGrid('clearGridData')
        api.dzbaYearReviewList(params).done(function (res) {
          if (res.code == '0') {
            $("#dzhc-dzfh-table").resetSelection();
            $("#dzhc-dzfh-table")[0].addJSONData(res.data);
            self.tableData = res.data;
            self.selRows = [];
            tools.HeiKj('dzhc-dzfh', 'dzhc-dzfh-table')
            self.closeHyper()
            $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
          }
        })
      }
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
          $('.dzhc-dzfh .page-model-qyDetail').show();
        }
      })
    },

    hideModelBaseinfo: function () {
      $('.model').hide();
      $('.dzhc-dzfh .page-model-qyDetail').hide();
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

    // 复核完成
    reviewConfirm: function (isPl, row) {
      var self = this;
      if (isPl) {
        var result = this.getSelRow();
        if (result.ids.length == 0) {
          tools.info('请至少选择一笔项目');
          return
        }
      }
      var html = '<p class="mb-5">复核意见:</p><textarea rows="8" cols="60" id="dzfhReviewReason" style="width:100%"></textarea>'
      $.dialog({
        padding: '10px 20px',
        title: "单证核查复核完成",
        content: html,
        okValue: '确定',
        lock: true,
        ok: function () {
          var val = $('#dzfhReviewReason').val().trim();
          if (isPl) {
            self.dzbaYearReviewInspectBatch(result, val)
          } else {
            self.dzbaYearReviewInspectSingle(row, val)
          }
        },
      })
    },
    // 获取选中的项目
    getSelRow: function () {
      var result = {
        ids: [],
        qymcs: [],
      }
      for (var i = 0; i < this.selRows.length; i++) {
        for (var j = 0; j < this.tableData.rows.length; j++) {
          if (this.selRows[i] == this.tableData.rows[j].id) {
            result.ids.push(this.tableData.rows[j].id);
            result.qymcs.push(this.tableData.rows[j].nsrmc + this.tableData.rows[j].year + '年度');
            continue
          }
        }
      }
      return result
    },
    // 复核完成 - 批量  
    dzbaYearReviewInspectBatch: function (reviewSel, reviewNote) {
      var self = this;
      var text = '确定完成对';
      text += reviewSel.qymcs.slice(0, 2).join('，');
      if (reviewSel.qymcs.length > 1) text += '等';
      text += '的复核吗？';
      tools.confirm(text, '确定', function () {
        var params = {
          ids: reviewSel.ids.join(','),
          reviewNote: reviewNote
        }
        api.dzbaYearReviewInspectBatch(params).done(function (res) {
          if (res.code == '0') {
            tools.info('批量复核成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },
    // 复核 - 单笔
    dzbaYearReviewInspectSingle: function (row, reviewNote) {
      var self = this;
      var text = '确定完成对';
      var nsrmc = row.nsrmc;
      text += nsrmc + row.year + '年度的复核吗？';
      tools.confirm(text, '确定', function () {
        var params = {
          id: row.id,
          reviewNote: reviewNote
        }
        api.dzbaYearReviewInspectSingle(params).done(function (res) {
          if (res.code == '0') {
            tools.info('复核成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 退回
    backConfirm: function (isPl, row) {
      var self = this;
      if (isPl) {
        var result = this.getSelRow();
        if (result.ids.length == 0) {
          tools.info('请至少选择一笔项目');
          return
        }
      }
      var html = '<p class="mb-5"><span style="color: red;">*</span>退回原因:</p><textarea rows="8" cols="60" id="dzfhBackReason" style="width:100%"></textarea><p id="dzfhBackBackReasonTip" class="text-red" style="display:none;">原因描述不能为空</p>'
      $.dialog({
        padding: '10px 20px',
        title: "单证核查退回",
        content: html,
        okValue: '确定',
        lock: true,
        ok: function () {
          var val = $('#dzfhBackReason').val().trim();
          if (val == '') {
            $('#dzfhBackBackReasonTip').show()
            return false;
          }
          if (isPl) {
            self.dzbaYearReviewBackBatch(result, val)
          } else {
            self.dzbaYearReviewBackSingle(row, val)
          }
        },
      })
    },
    // 退回 - 批量  
    dzbaYearReviewBackBatch: function (backSel, reviewNote) {
      var self = this;
      var text = '确定退回';
      text += backSel.qymcs.slice(0, 2).join('，');
      if (backSel.qymcs.length > 1) text += '等';
      text += '的核查吗？';
      tools.confirm(text, '确定', function () {
        var params = {
          ids: backSel.ids.join(','),
          reviewNote: reviewNote
        }
        api.dzbaYearReviewBackBatch(params).done(function (res) {
          if (res.code == '0') {
            tools.info('批量退回成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },
    // 退回 - 单笔
    dzbaYearReviewBackSingle: function (row, reviewNote) {
      var self = this;
      var text = '确定退回';
      var nsrmc = row.nsrmc;
      text += nsrmc + row.year + '年度的核查吗？';
      tools.confirm(text, '确定', function () {
        var params = {
          id: row.id,
          reviewNote: reviewNote
        }
        api.dzbaYearReviewBackSingle(params).done(function (res) {
          if (res.code == '0') {
            tools.info('退回成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },
    showHyper: function () {
      $('.dzhc-dzfh .page .select-sub').toggle();
      $('.dzhc-dzfh .page .select-wrapper .icon').toggleClass("active");
      if ($('.dzhc-dzfh .page .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
        $('.dzhc-dzfh .page .select-wrapper .icon').attr("title", "收起查询条件");
      } else {
        $('.dzhc-dzfh .page .select-wrapper .icon').attr("title", "展开查询条件")
      }
    },
    closeHyper: function () {
      $('.dzhc-dzfh .select-sub').hide();
      $('.dzhc-dzfh .select-wrapper .icon').removeClass('active');
      $('.dzhc-dzfh .select-wrapper .icon').attr("title", "展开查询条件")
    },

    saveModel: function () {
      var self = this
      if (this.modelData.inspectResult == '2' && this.modelData.inspectState == '') {
        return false
      }
      ajax("POST", "/dzba/inspect/finish", this.modelData).done(function (res) {
        if (res.code == '0') {
          tools.info('操作成功！')
          self.hideModel();
          self.search(1)
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
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
          $.fn.zTree.init($(".dzhc-dzfh .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.dzhc-dzfh').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }
      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.dzhc-dzfh').off('click');
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
      if (id == 'dzfhNrsbhList') {
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
      if (id == 'dzfhNrsbhList') {
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
        if (id == 'dzfhNrsbhList') {
          item = this.nsrsbhList[index],
            key = 'searchData'
        }
        if (item) {
          this[key].nsrsbh = item.nsrsbh
          if (id == 'dzfhNrsbhList') {
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
  }
});