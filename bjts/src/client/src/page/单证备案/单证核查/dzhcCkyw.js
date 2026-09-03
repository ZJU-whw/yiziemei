var dzhcCkyw = require("./dzhcCkyw.html");

avalon.component('dzhcCkyw', {
  template: dzhcCkyw,
  defaults: {
    propsToPager: {
      templateName: 'page-model-edit-ckyw_'
    },
    propsToAiPager: {
      templateName: 'page-model-edit-ai-ckyw_'
    },
    params: {},
    selRows: [], // 选中项
    aiReviewEnabled: false, // AI审核按钮权限
    searchData: {
      id: '',
      sbywzl: '',
      sssq: '',
      sbpc: '',
      sbnypc: '',
      entryId: '',
      ckrqq: '',
      ckrqz: '',
      queryType: 'sh', // lx-单证核查立项，sh-单证核查审核，fh-单证核查复核
      pageSize: 20,
      pageNo: 1,
      orderSql: '',
    },
    modelDataCheck: {
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
    checkStatus: -1,
    modelDataSh: {
      ids: [],
      qymcs: [],
      confirmInfo: '',
      examineResult: '0',
      examineNote: '',
    },
    tableData: {},
    activeBgIndex: -1,
    activeBgCkywIndex: -1,
    tabIndex: 0, // 0-明细表，1-基础信息
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
    isPlsh: false,
    finisnData: {},
    finisnList: [
      { label: '企业税号', key: 'nsrsbh' },
      { label: '企业名称', key: 'nsrmc' },
      { label: '管理类别', key: 'gllb' },
      { label: '申报业务种类', key: 'sbywzl' },
      { label: '申报年月批次', key: 'sbnypc' },
      { label: '退免税额', key: 'tmse', type: 'number' },
      { label: '报关单号', key: 'entryId' },
      { label: '出口日期', key: 'eDate' },
      { label: '贸易方式', key: 'supvModeCodeName' },
      { label: '合同号', key: 'contrNo' },
      { label: '备案号', key: 'manualNo' },
      { label: '运输方式', key: 'cusTrafModeName' },
      { label: '运输工具', key: 'trafName' },
      { label: '提运单号', key: 'billNo' },
      { label: '贸易国', key: 'cusTradeNationCodeName' }
    ],
    rangeList: [], // 新增时选中的核查单证类型
    editRangeList: [], // 新增时选中的核查单证类型
    typeTreeData: [], // 核查单证类型
    pdfDetailInfo: {},
    curRow: {},
    timer: null,

    isWindows: true,

    resetSearchData: function () {
      this.searchData = {
        id: this.searchData.id,
        sbywzl: this.searchData.sbywzl,
        sssq: '',
        sbpc: '',
        sbnypc: '',
        entryId: '',
        ckrqq: '',
        ckrqz: '',
        queryType: this.searchData.queryType,
        pageSize: 20,
        pageNo: 1,
        orderSql: '',
      }

    },
    onInit: function (e) {
      avalonRoot['dzhcCkyw_'+this.params.queryType] = e.vmodel;
      this.propsToPager.templateName += this.params.queryType;
      this.propsToAiPager.templateName += this.params.queryType;
      this.searchData.queryType = this.params.queryType;
      this.searchData.id = this.params.id;
      this.searchData.sbywzl = this.params.sbywzl;
      this.checkStatus = this.params.status;
      try {
        var swjgDm = avalonRoot.user.swjgDm || '';
        this.aiReviewEnabled = swjgDm.substring(0, 5) === '13310';
      } catch (e) {}
    },
    onReady: function () {
      this.isWindows = tools.isWindows();

      this.initDate();
      this.initHeight();
      this.createTable();
      this.createTableBhgmx();
      this.getBaseInfo(1);
    },

    // 初始化日期输入框
    initDate: function () {
      var self = this;
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2, endDate: new Date() };
      $('.dzhc-ckyw.'+self.searchData.queryType+' .datepicker.date-day').datetimepicker(options);
      var year = this.params.year;
      if (year && year.length == 4) {
        var startDate = year + '-01';
        var endDate = year + '-12';
      }
      $('.dzhc-ckyw.'+self.searchData.queryType+' .datepicker.date-month').datetimepicker({
        language: 'zh-CN',
        format: 'yyyymm',
        weekStart: 1,
        // todayBtn: true,
        clearBtn: true,
        autoclose: 1,
        todayHighlight: 1,
        startView: 3, // 这里就设置了默认视图为年视图
        minView: 3, // 设置最小视图为年视图
        startDate: startDate,
        endDate: endDate,
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
      var self = this;
      $(window).resize(function () {
        var h = $(".dzhc-ckyw."+self.searchData.queryType+" .form").height();
        if (h > 100) {
          $("#dzhc-ckyw-table_"+self.searchData.queryType).jqGrid('setGridHeight', h - 70);
        }
      })
    },

    // 状态信息查询
    getBaseInfo: function (pageNo) {
      var self = this;
      var params = {
        id: this.params.id,
      }
      api.dzbaYearProjectBaseinfo(params).done(function (res) {
        if (res.code == '0') {
          res.data.xmxh = self.searchData.id;
          self.jcxmmxInfo = res.data;
          self.search(pageNo)
          // 纸质备案企业，没有税务事项通知书，立项日期不可点击
          self.resetJcxmmxDict();
        }
      })
    },

    resetJcxmmxDict: function(){
      for(var i=0; i<this.jcxmmxDict.length; i++){
        var item = this.jcxmmxDict[i].infos;
        for(var j=0; j<item.length; j++){
          var subItem = item[j];
          if(this.jcxmmxInfo.balx=='纸质备案'){
            subItem.infoTitle = '';
            subItem.infoCls = '';
          }
        }
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
      var opWidth = this.searchData.queryType == 'sh' ? 280 : 80;
      var isSh = this.searchData.queryType == 'sh';
      var columns = [
        {
          name: "op2", label: "操作", width: 0, frozen: true, align: "center", resizable: false, search: false, sortable: false, formatter: function (cellVal, op, row) {
            var status = row.status; // 业务状态：0-创建，1-已下达(已退回)，2-已收讫，3-已上报，4-已审核
            // 项目状态：0-创建 1-审核 2-复核 3-发放 9-结案
            var edit_title = status == 0 ? '编辑' : '查看';
            var back_enable = self.jcxmmxInfo.status == 1 && status == 3 && row.backCount<1;
            var back_title = row.backCount<'1' ? (status == 3 ? '退回' : '已下达'): '已退回';
            var shjs_enable = status == 3;
            var revoke_enable = status == 4;
            var h = '';
            if (self.aiReviewEnabled) {
              h += "<div class='btn op-btn op-ai-review' title='AI审核'>AI审核</div>" // AI审核
            }
            h += "<div class='btn op-btn op-edit' title='" + edit_title + "'>" + edit_title + "</div>" // 查看/编辑
            if (isSh) {
              h += "<div class='btn op-btn op-back " + (back_enable ? '' : 'op-disabled') + " " + (status == 1 ? 'yxd' : '') + "' title='" + back_title + "'>" + back_title + "</div>" // 退回
              // h += "<div class='btn op-btn op-sh " + (shjs_enable ? '' : 'op-disabled') + "' title='审核'>审核</div>" // 审核
              if (status == 4 && self.jcxmmxInfo.status == 1) {
                h += "<div class='btn op-btn op-revoke " + (revoke_enable ? '' : 'op-disabled') + "' title='审核撤销'>审核撤销</div>" // 审核撤销
              } else {
                h += "<div class='btn op-btn op-shjs " + (shjs_enable ? '' : 'op-disabled') + "' title='审核结束'>审核结束</div>" // 审核结束
              }
            }
            return h
          }
        },
        { name: "id", label: "序号", index: "id", width: 55, align: "center", sortable: false },
        { name: "entryId", label: "报关单号", index: "entryId", width: 125, sortable: false },
        { name: "sbnypc", label: "申报年月批次", index: "sbnypc", width: 80, align: "center", sortable: false },
        { name: "sbywzl", label: "申报业务种类", index: "sbywzl", width: 110, align: "center", sortable: false },
        { name: "status", label: "状态", index: "status", hidden: true },
        { name: "statusName", label: "状态", index: "statusName", width: 55, align: "center", sortable: false },
        { name: "reportTime", label: "上报日期", index: "reportTime", width: 120, align: "center", sortable: true },
        { name: "examineTime", label: "审核日期", index: "examineTime", width: 120, align: "center", sortable: true },
        { name: "ckrq", label: "出口日期", index: "ckrq", width: 70, align: "center", sortable: true },
        { name: "range", label: "单证核查范围", index: "range", hidden: true },
        { name: "rangeName", label: "单证核查范围", index: "rangeName", width: 160, sortable: false },
        { name: "backCount", label: "退回次数", index: "backCount", hidden: true },
        { name: "backReason", label: "退回原因", index: "backReason", width: 160, sortable: false },
        { name: "ywlxCode", label: "业务类型代码", index: "ywlxCode", hidden: true },
        { name: "sbrq", label: "申报日期", index: "sbrq", hidden: true },
        { name: "op", label: "操作", width: opWidth, align: "center", resizable: false, search: false, sortable: false }
      ];
      $("#dzhc-ckyw-table_"+self.searchData.queryType).jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#dzhc-ckyw-table_'+self.searchData.queryType+'Pager',
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
          return $(".dzhc-ckyw."+self.searchData.queryType+" .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          if ($(e.target).hasClass('op-disabled')) return
          var row = $('#dzhc-ckyw-table_'+self.searchData.queryType).jqGrid('getRowData', rowid);
          if ($(e.target).hasClass('op-ai-review')) { // AI审核
            self.triggerAiReview(row);
            return false
          } else if ($(e.target).hasClass('op-edit')) { // 查看
            // 打开出口业务详情
            self.showCkywDetail(row);
            return false
          } else if ($(e.target).hasClass('op-shjs')) { // 审核结束
            self.showModelSh(false, row);
            return false
          } else if ($(e.target).hasClass('op-revoke')) { // 审核撤销
            self.revokeSingle(row);
            return false
          } else if ($(e.target).hasClass('op-back')) { // 退回
            self.backConfirmPre(false, row);
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
          var pageNo = tools.getPageNo(pgButton, "dzhc-ckyw-table_"+self.searchData.queryType);
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
        }
      })
      $("#dzhc-ckyw-table_"+self.searchData.queryType).jqGrid('setFrozenColumns');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-ckyw.'+self.searchData.queryType)).val();
    },
    createTableBhgmx: function () {
      var columns = [
        { name: "id", label: "核查业务序号", index: "id", hidden: true },
        { name: "sbywzl", label: "申报业务种类", index: "sbywzl", width: 80, align: "center", sortable: false },
        { name: "sbnypc", label: "申报年月批次", index: "sbnypc", width: 80, align: "center", sortable: false },
        { name: "entryId", label: "报关单号", index: "entryId", width: 135, sortable: false },
        { name: "je", label: "出口销售金额(美元)", index: "je", width: 110, align: "right", sortable: false,
        formatter: function (cellVal, op, row) {
          cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
          if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
          return cellVal
        }
       },
        { name: "se", label: "申报退税额", index: "se", width: 90, align: "right", sortable: false,
        formatter: function (cellVal, op, row) {
          cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
          if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
          return cellVal
        }
       },
        { name: "examineResult", label: "审核结论", index: "examineResult", width: 115, sortable: false },
        { name: "examineNote", label: "审核意见", index: "examineNote", width: 125, sortable: false },
      ];
      $("#dzhc-ckyw-bhgmx-table").jqGrid({
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

    showCkywDetail: function (row) {
      $('.model').show();
      $('.dzhc-ckyw.'+this.searchData.queryType+' .page-model-edit').show();
      row.type = 'year';
      avalonRoot[this.propsToPager.templateName].search(row);
    },

    // AI审核 - 触发接口后打开详情弹窗
    triggerAiReview: function (row) {
      var self = this;
      // ===== 临时模拟 - 正式接口就绪后删除 =====
      // var jobId = 'JOB-001121';
      // $('.model').show();
      // $('.dzhc-ckyw.'+self.searchData.queryType+' .page-model-edit-ai').show();
      // row.type = 'year';
      // row.aiJobId = jobId;
      // row.projectSeq = self.searchData.id;
      // avalonRoot[self.propsToAiPager.templateName].search(row);
      // return;
      // ===== 临时模拟结束 =====

      var params = {
        projectSeq: self.searchData.id,
        businessId: row.id,
        taxpayerId: self.jcxmmxInfo.nsrsbh || '',
      };
      ajax("POST", "/cxfw/aisdhc/aicompare/business/sync", params).done(function (res) {
        if (res.code == '0') {
          var jobId = (res.data && res.data.jobId) || '';
          var syncStatus = (res.data && res.data.status) || '';
          $('.model').show();
          $('.dzhc-ckyw.'+self.searchData.queryType+' .page-model-edit-ai').show();
          row.type = 'year';
          row.aiJobId = jobId;
          row.projectSeq = self.searchData.id;
          row.isRefreshOperation = (syncStatus == 'completed');
          avalonRoot[self.propsToAiPager.templateName].search(row);
        } else {
          tools.info(res.msg);
        }
      })
    },

    search: function (pageNo) {
      var self = this;

      var dateValid1 = tools.checkDate(this.searchData.ckrqq, this.searchData.ckrqz)
      if (!dateValid1) {
        tools.info('出口日期截止日期必须大于起始日期')
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

      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-ckyw.'+this.searchData.queryType)).val() || 20;
      self.searchData.pageNo = pageNo;
      var params = tools.clone(self.searchData);
      $("#dzhc-ckyw-table_"+self.searchData.queryType).jqGrid('clearGridData')
      api.dzbaYearProjectBusinessList(params).done(function (res) {
        if (res.code == '0') {
          $("#dzhc-ckyw-table_"+self.searchData.queryType).resetSelection();
          $("#dzhc-ckyw-table_"+self.searchData.queryType)[0].addJSONData(res.data);
          self.tableData = res.data;
          self.selRows = [];
          tools.HeiKjNewDzhc('dzhc-ckyw.'+self.searchData.queryType, 'dzhc-ckyw-table_'+self.searchData.queryType)
          self.closeHyper()
          $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },
    showHyper: function () {
      $('.dzhc-ckyw.'+this.searchData.queryType+' .page .select-sub').toggle();
      $('.dzhc-ckyw.'+this.searchData.queryType+' .page .select-wrapper .icon').toggleClass("active");
      if ($('.dzhc-ckyw.'+this.searchData.queryType+' .page .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
        $('.dzhc-ckyw.'+this.searchData.queryType+' .page .select-wrapper .icon').attr("title", "收起查询条件");
      } else {
        $('.dzhc-ckyw.'+this.searchData.queryType+' .page .select-wrapper .icon').attr("title", "展开查询条件")
      }
    },
    closeHyper: function () {
      $('.dzhc-ckyw.'+this.searchData.queryType+' .select-sub').hide();
      $('.dzhc-ckyw.'+this.searchData.queryType+' .select-wrapper .icon').removeClass('active');
      $('.dzhc-ckyw.'+this.searchData.queryType+' .select-wrapper .icon').attr("title", "展开查询条件")
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

    showBhgmx: function(){
      $('.dzhc-ckyw.'+this.searchData.queryType+' .page-model-check-bhgmx').show();
      $("#dzhc-ckyw-bhgmx-table").jqGrid('clearGridData');
      $("#dzhc-ckyw-bhgmx-table")[0].addJSONData(this.modelDataCheck.problemDatas);
    },

    hideBhgmx: function(){
      $('.dzhc-ckyw.'+this.searchData.queryType+' .page-model-check-bhgmx').hide();
    },

    // 单笔核查完成 - 服务端前置 - 获取信息
    showModelShPre: function(){
      var self = this;
      var params = {
        ids: this.params.id,
      }
      api.dzbaYearExamineInspectPre(params).done(function(res){
        if(res.code=='0'){
          self.modelDataCheck.projectResultInit = res.data.projectResult;
          self.modelDataCheck.projectResult = res.data.projectResult;
          self.modelDataCheck.problemNum = avalon.filters.number(res.data.problemNum, 0);
          self.modelDataCheck.problemSe = avalon.filters.number(res.data.problemSe, 2);
          self.modelDataCheck.problemDatas = res.data.problemDatas || [];
          self.frontCheckFinishSingle();
          self.showModelCheck();
        }
      })
    },

    // 单项核查完成前置处理
    frontCheckFinishSingle: function () {
      var row = this.params;
      this.modelDataCheck.ids = [row.id];
      var nsrmc = this.jcxmmxInfo.nsrmc;
      this.modelDataCheck.qymcs = [nsrmc];
      this.modelDataCheck.confirmInfo = '确定完成对' + nsrmc + row.year + '年度的核查吗？'
    },

    showModelCheck: function () {
      $('.model').show();
      $('.dzhc-ckyw.'+this.searchData.queryType+' .page-model-check').show();
      var curResult = this.modelDataCheck.projectResult;
      this.modelDataCheck.projectResult = -1;
      this.modelDataCheck.projectResult = curResult;
    },
    // 核查完成
    saveCheckFinish: function () {
      var self = this
      tools.confirm(self.modelDataCheck.confirmInfo, '确定', function () {
        var params = {
          id: self.modelDataCheck.ids.join(','),
          projectResult: self.modelDataCheck.projectResult,
        }
        if(self.modelDataCheck.projectResult!='3'){
          params.inspectNote = '本次备案单证核查暂无发现问题。';
        } else{
          params.inspectNote = '本次备案单证核查发现';
          params.inspectNote += self.modelDataCheck.problemNum;
          params.inspectNote += '个问题，应追回出口退税款';
          params.inspectNote += self.modelDataCheck.problemSe;
          params.inspectNote += '元，请于本次备案单证核查项目放发后15个工作日内到主管税务机关补缴。';
        }
        api.dzbaYearExamineInspectSingle(params).done(function (res) {
          if (res.code == '0') {
            tools.info('核查完成成功');
            self.getBaseInfo(self.searchData.pageNo);
          }
          self.hideModelCheck();
        })
      })
    },

    hideModelCheck: function () {
      $('.model').hide();
      $('.dzhc-ckyw.'+this.searchData.queryType+' .page-model-check').hide();
      this.modelDataCheck = {
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

    // 批量审核前置处理
    frontShPl: function () {
      for (var i = 0; i < this.selRows.length; i++) {
        for (var j = 0; j < this.tableData.rows.length; j++) {
          if (this.tableData.rows[j].status == 3 && this.selRows[i].indexOf(this.tableData.rows[j].id) > -1) {
            this.modelDataSh.ids.push(this.tableData.rows[j].id);
            this.modelDataSh.qymcs.push('在申报批次【' + this.tableData.rows[j].sbnypc + '】报关单号【' + this.tableData.rows[j].entryId + '】');
            continue
          }
        }
      }
      this.modelDataSh.confirmInfo = '确定对' + this.jcxmmxInfo.nsrmc;
      this.modelDataSh.confirmInfo += this.modelDataSh.qymcs.slice(0, 2).join('；');
      if (this.modelDataSh.qymcs.length > 1) this.modelDataSh.confirmInfo += '等';
      this.modelDataSh.confirmInfo += '的业务进行审核吗？';
    },
    // 单项审核前置处理
    frontShSingle: function (row) {
      var self = this
      this.curRow = row;
      this.typeTreeData = [];
      this.modelDataSh.ids = [row.id];
      this.modelDataSh.qymcs = ['在申报批次【' + row.sbnypc + '】报关单号【' + row.entryId + '】'];
      this.modelDataSh.confirmInfo = '确定对' + this.jcxmmxInfo.nsrmc + '在申报批次【' + row.sbnypc + '】报关单号【' + row.entryId + '】的业务进行审核吗？';

      var params = {
        id: row.id,
      }
      api.dzbaYearBusinessExamineSinglePre(params).done(function (res) {
        if (res.code == 0) {
          self.finisnData = res.data;
          self.resetPdfDetailInfo(row, res.data);
          self.editRangeList = res.data.range && res.data.range.split(',') || [];
          self.modelDataSh.examineNote = res.data.examineNote || '';
          $('.model').show();
          $('.dzhc-ckyw.'+self.searchData.queryType+' .page-model-end').show();
          let para = {
            nsrsbh: self.params.nsrsbh,
            entryIds: [{ ywlxCode: row.ywlxCode, entryId: row.entryId, sbrq: row.sbrq }],
            type: 'year'
          }
          var includeFileFlag = !self.isWindows && ['3','4'].indexOf(row.status) != -1
          if (includeFileFlag) {
            para.includeFileFlag = true
            para.ranges = row.range || ''
          }
          self.getTypeTreeData(para);
        }
      })
    },

    // 获取核查单证类型
    getTypeTreeData: function (params) {
      var self = this
      self.typeTreeData = [];
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

    // 审核弹框显示
    showModelSh: function (isPlsh, row) {
      this.isPlsh = isPlsh;
      if (isPlsh) {
        this.frontShPl();
        if (this.modelDataSh.ids.length == 0) {
          tools.info('请至少选择一笔可审核的业务');
          return
        }
        $('.model').show();
        $('.dzhc-ckyw.'+this.searchData.queryType+' .page-model-end').show();
      } else {
        this.frontShSingle(row);
      }
    },
    // 审核
    saveModelDataSh: function () {
      var self = this
      if (this.modelDataSh.examineResult == '1' && this.modelDataSh.examineNote == '') {
        return false
      }

      tools.confirm(self.modelDataSh.confirmInfo, '确定', function () {
        var params = {
          examineResult: self.modelDataSh.examineResult,
          examineNote: self.modelDataSh.examineNote,
        }
        var fnConfirm = api.dzbaYearBusinessExamineSingle;
        var text = '审核完成';
        if (self.isPlsh) {
          fnConfirm = api.dzbaYearExamineBatch;
          text = '批量审核完成';
          params.ids = self.modelDataSh.ids.join(',');
        } else {
          params.id = self.modelDataSh.ids.join(',');
        }
        fnConfirm(params).done(function (res) {
          if (res.code == '0') {
            tools.info(text)
            self.hideModelSh();
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 审核弹框隐藏
    hideModelSh: function () {
      $('.model').hide();
      $('.dzhc-ckyw.'+this.searchData.queryType+' .page-model-end').hide();
      this.modelDataSh = {
        ids: [],
        qymcs: [],
        confirmInfo: '',
        examineResult: '0',
        examineNote: '',
      }
      this.editRangeList = [];
    },

    // 单笔审核撤销 
    revokeSingle: function (row) {
      var self = this;
      var params = {
        id: row.id,
      }
      var text = '确定对' + this.jcxmmxInfo.nsrmc + '在申报年月批次【' + row.sbnypc + '】报关单号【' + row.entryId + '】的任务进行审核撤销吗？';
      tools.confirm(text, '确定', function () {
        api.dzbaYearBusinessExamineRevokeSingle(params).done(function (res) {
          if (res.code == 0) {
            tools.info('审核撤销成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 批量退回前置处理
    frontBackPl: function () {
      var result = {
        ids: [],
        entryIds: [],
        text: '',
      }
      for (var i = 0; i < this.selRows.length; i++) {
        for (var j = 0; j < this.tableData.rows.length; j++) {
          if (this.jcxmmxInfo.status == 1 && this.tableData.rows[j].status==3 && this.selRows[i].indexOf(this.tableData.rows[j].id) > -1) {
            result.ids.push(this.tableData.rows[j].id);
            result.entryIds.push('在申报批次【' + this.tableData.rows[j].sbnypc + '】报关单号【' + this.tableData.rows[j].entryId + '】');
            continue
          }
        }
      }
      var text = '确定对' + this.jcxmmxInfo.nsrmc;
      text += result.entryIds.slice(0, 2).join('，');
      if (result.entryIds.length > 1) text += '等';
      text += '的业务进行退回吗？';
      result.text = text;
      return result
    },

    // 退回 - 前置，将审核意见写入退回原因
    backConfirmPre: function(isPl, row){
      var self = this;
      var result = {};
      if (isPl) {
        result = this.frontBackPl();
        if (result.ids.length == 0) {
          tools.info('请至少选择一笔可退回业务');
          return
        }
      }
      var params = {
        backType: 'year',
        ids: isPl? result.ids.join(','): row.id,
      }
      api.businessBackPre(params).done(function(res){
        var backReason = '';
        if(res.code==0 && res.data && res.data.length>0){
          if(isPl){
            for(var i=0; i<res.data.length; i++){
              var item = res.data[i];
              if(!item.backReason) continue;
              backReason += '序号' + item.id + '，报关单号' + item.entryId + '：' + item.backReason + '；\n';
            }
          } else{
            for(var i=0; i<res.data.length; i++){
              var item = res.data[i];
              if(item.id==row.id && item.backReason){
                backReason = item.backReason;
              }
            }
          }
        }
        self.backConfirm(isPl, row, result, backReason);
      })

    },

    // 退回
    backConfirm: function (isPl, row, result, backReason) {
      var self = this;
      var html = '<p class="mb-5"><span style="color: red;">*</span>退回原因:</p><textarea rows="8" cols="60" id="dzhcCkywBackReason" style="width:100%"></textarea><p id="dzhcCkywPlBackReasonTip" class="text-red" style="display:none;">原因描述不能为空</p><p class="text-red" style="margin-top:10px;">说明：年度核查的每笔出口业务仅允许退回一次，请谨慎操作</p>'
      $.dialog({
        padding: '10px 20px',
        title: "核查业务退回",
        content: html,
        okValue: '确定',
        lock: true,
        ok: function () {
          var val = $('#dzhcCkywBackReason').val().trim();
          if (val == '') {
            $('#dzhcCkywPlBackReasonTip').show()
            return false;
          }
          if (isPl) {
            self.dzbaYearBackBatch(result, val)
          } else {
            self.dzbaYearBusinessBackSingle(row, val)
          }
        },
        cancelValue: '取消',
        cancel: function () {
        },
      })
      $('.d-buttons').css('text-align', 'center');
      $('#dzhcCkywBackReason').val(backReason);
    },
    // 退回 - 批量  
    dzbaYearBackBatch: function (backSel, backReason) {
      var self = this;
      tools.confirm(backSel.text, '确定', function () {
        var params = {
          ids: backSel.ids.join(','),
          backReason: backReason
        }
        api.dzbaYearBackBatch(params).done(function (res) {
          if (res.code == '0') {
            tools.info('批量退回成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },
    // 退回 - 单笔
    dzbaYearBusinessBackSingle: function (row, backReason) {
      var self = this;
      var text = '确定对';
      text += this.jcxmmxInfo.nsrmc + '在申报批次【' + row.sbnypc + '】报关单号【' + row.entryId + '】的业务进行退回吗？';
      tools.confirm(text, '确定', function () {
        var params = {
          id: row.id,
          backReason: backReason
        }
        api.dzbaYearBusinessBackSingle(params).done(function (res) {
          if (res.code == '0') {
            tools.info('退回成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    dataEntryidChg: function () {
      this.searchData.entryId = this.searchData.entryId.trim();
    },

    // 预览税务事项通知书
    showViewPdfApprove: function (type) {
      var self = this;
      var params = {
        id: this.params.id,
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
    showViewPdfReceipt: function () {
      var self = this;
      var params = {
        bizType: 'receipt',
        bizKey: this.params.id,
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

    // PDF显示
    showViewJcxmmx: function(item){
      if(this.jcxmmxInfo.balx=='纸质备案') return // 纸质备案企业没有立项通知书、回证文书
      if(item=='approveTime'){
        this.showViewPdfApprove('001');
      } else if(item=='receiptTime'){
        this.showViewPdfReceipt();
      }
    },

    // 核查完成输入框变更事件
    modelDataChg: function(item){
      var n = 0;
      if(item=='problemSe') n = 2;
      this.modelDataCheck[item] = avalon.filters.number(this.modelDataCheck[item].replace(/,/g, ''), n);
    },

    showMultiPdf: function () {
      var self = this;
      if (this.curRow.status < 3 || !this.hasTypeTreeFiles()) {
        return;
      }
      var viewer = components['multiPdfViewerglobal-multi-pdf'];
      if (viewer) {
        viewer.showTreePdfs(this.typeTreeData, '核查单证类型', null, 'dzbaFileViewPdf', this.pdfDetailInfo, 'edit', function () {
          self.refreshAfterRemarkSave();
        });
      } else {
        tools.info('PDF预览组件未初始化');
      }
    },

    refreshAfterRemarkSave: function () {
      this.frontShSingle(this.curRow);
    },

    resetPdfDetailInfo: function (row, data) {
      for (var key in this.pdfDetailInfo) {
        if (Object.prototype.hasOwnProperty.call(this.pdfDetailInfo, key)) {
          delete this.pdfDetailInfo[key];
        }
      }
      $.extend(this.pdfDetailInfo, row || {}, data || {});
    },

    hasTypeTreeFiles: function () {
      var list = this.typeTreeData || [];
      for (var i = 0; i < list.length; i++) {
        var items = list[i].item || [];
        for (var j = 0; j < items.length; j++) {
          if (items[j].checked && items[j].fileInfos && items[j].fileInfos.length > 0) {
            return true;
          }
        }
      }
      return false;
    },

    // 调用单证助手-预览文件
    searchDz: function () {
      var self = this
      if (this.curRow.status < 3) {
        return;
      }
      var params = {
        inspectNo: this.curRow.id,
        mode: 'edit',
        type: 'year',
      }
      api.dzbaInspectViewSecond(params).done(function (res) {
        if (res.code == '0') {
          var params = res.data
          if (!params) {
            return;
          }
          apiClient.baywManageNew(params).done(function (res) {
            clearTimeout(self.timer)
            self.timer = setTimeout(self.getRemark, 1000);
          })
        }
      })
    },
    // 从单证助手获取核查意见备注
    getRemark: function(){
      var self = this
      apiClient.getRemark({taskType: '01'}).done(function(res){
        var docInfo = res.docInfo
        if (docInfo.length<=0 && res.inspectInfo.length<=0) {
          clearTimeout(self.timer)
        } else {
          self.timer = setTimeout(self.getRemark, 1000);
        }
        if(docInfo.length > 0) {
          self.resetDocinfo(docInfo);
          ajax("POST","/dzba/file/remark/save",{docInfo: docInfo});
          self.frontShSingle(self.curRow);
        }
      }).fail(function(err){
        clearTimeout(self.timer)
      })
    },
    // 挂载 changeFlag
    resetDocinfo: function(docInfo){
      for(var i=0; i<docInfo.length; i++){
        docInfo[i].changeFlag = docInfo[i].changeFlag? docInfo[i].changeFlag: 'Y';
      }
    },
  }
});
