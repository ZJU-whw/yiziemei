var dzhcCkywDetailYear = require("./dzhcCkywDetailYear.html");

// 单证类型编码字典
var DOC_TYPE_DICT = {
  'export_license': '进出口许可证件',
  'packing_list': '装箱单',
  'invoice': '发票',
  'bill_of_lading': '提单',
  'customs_declaration': '报关单',
  'customs_agency_agreement': '报关代理协议',
  'purchase_contract': '采购合同',
  'sales_contract': '销售合同',
  'purchase_invoice': '采购发票',
  'sales_invoice': '销售发票',
  'payment_voucher': '付款凭证',
  'receipt_voucher': '收款凭证',
  'warehouse_notice': '仓库通知',
  'transport_invoice': '运输发票',
  'freight_invoice': '货运发票',
  'other': '其他单证',
  'unclassified': '未分类',
  'unknown': '未知类型'
};

// 严重等级字典
var SEVERITY_DICT = {
  'error': '严重',
  'warning': '警告',
  'info': '提示',
  'pass': '通过'
};

avalon.component('dzhcCkywDetailYear', {
  template: dzhcCkywDetailYear,
  defaults: {
    templateName: 'page-model-edit-ai-detail',
    params: {},
    editData: {},
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
    editRangeList: [],
    typeTreeData: [],
    backFileTreeData: [], // 退回文件弹框数据
    rangeList: [],
    timer: null,
    detailType: 'year',
    isEdit: false,
    hasBackList: false,
    isWindows: true,

    // ===== 右侧智审相关 =====
    aiTabIndex: 0,           // 0-智审详情 1-跨单证比对
    aiItems: [],             // 接口返回的原始 items
    aiFilteredItems: [],     // 筛选后的 items
    aiFilterSeverity: '',    // 筛选条件-严重等级
    aiFilterStatus: '',      // 筛选条件-结果状态
    aiSummary: {
      rules_total: 0,
      errors: 0,
      warnings: 0,
      non_ok_rules: 0,
    },
    aiRefreshState: '',
    aiSnapshotAt: '',
    aiWorkflowStatus: '',
    aiWorkflowError: '',
    aiTaskId: '',
    aiInputHash: '',
    aiJobId: '',                // 任务编号
    aiRefreshStateText: '',     // 任务状态文本
    aiBusinessStatus: '',       // 工作流状态原始值
    aiBusinessStatusText: '',   // 工作流状态文本
    aiBusinessStatusColor: '#333', // 工作流状态颜色

    // ===== 跨单证比对相关 =====
    ccGroups: [],          // 处理后的分组数据 [{label, key, docTypes, docCount, fieldCount, mismatchCount, warningCount, fields}]
    ccTimeline: [],        // 时间线数据
    ccGroupTags: [],       // 顶部环节统计标签
    ccSelectedCount: 0,    // 已选字段数
    ccTotalFields: 0,      // 总字段数
    currentRow: {},        // 当前行数据
    projectSeq: '',        // 项目序号

    onInit: function (e) {
      avalonRoot[this.templateName] = e.vmodel;
      this.rewriteAssign();
    },
    onReady: function () {
      this.isWindows = tools.isWindows();
    },

    rewriteAssign: function(){
      if (typeof Object.assign != 'function') {
        Object.assign = function(target) {
          'use strict';
          if (target == null) {
            throw new TypeError('Cannot convert undefined or null to object');
          }
          target = Object(target);
          for (var index = 1; index < arguments.length; index++) {
            var source = arguments[index];
            if (source != null) {
              for (var key in source) {
                if (Object.prototype.hasOwnProperty.call(source, key)) {
                  target[key] = source[key];
                }
              }
            }
          }
          return target;
        };
      }
    },

    /**
     * 外部页面调用  avalonRoot[this.propsToPager.templateName].search
     * 年度核查-出口业务页面  dzhcCkyw.js
    */
    search: function (row) {
      var self = this;
      self.currentRow = row;
      self.projectSeq = row.projectSeq || '';
      var params = { id: row.id }
      self.detailType = row.type;
      self.typeTreeData = [];
      var viewFn = row.type == 'daily' ? api.dzbaDailyBusinessView : api.dzbaYearBusinessView;
      viewFn(params).done(function (res) {
        if (res.code == '0') {
          var data = res.data
          self.editData = Object.assign({}, data.nsrxx, data.extra, data.business, row)
          self.editData.note = self.editData.note || '';
          self.editData.examineResult = self.editData.examineResult || '';
          self.editRangeList = data.range && data.range.split(',') || [];
          self.isEdit = (self.templateName=='page-model-edit-rwcx' && self.editData.isEdit) || (self.templateName!='page-model-edit-rwcx')
          var treeParams = {
            nsrsbh: self.editData.nsrsbh,
            entryIds: [{ ywlxCode: row.ywlxCode, entryId: row.entryId, sbrq: row.sbrq }],
            type: self.editData.type,
            tsjsfsChg: row.tsjsfsChg || '',
          }
          var includeFileFlag = !self.isWindows && ['3','4'].indexOf(row.status) != -1
          if (includeFileFlag) {
            treeParams.includeFileFlag = true
            treeParams.ranges = row.range || ''
          }
          if(row.type=='daily' && self.editData.status=='0'){
            var resetParams = {
              id: row.id,
              nsrsbh: self.editData.nsrsbh,
              sbywzl: self.editData.sbywzl,
              sbnypc: self.editData.sbnypc,
              entryId: row.entryId,
            }
            api.dzbaInspectYjxxReset(resetParams).done(function(){
              self.getTypeTreeData(treeParams);
            })
          } else{
            self.getTypeTreeData(treeParams);
          }
          self.getBackList(row);

          // 加载智审详情数据
          self.loadAiReviewBundle(row);
        }
      })
    },

    // ===== 智审详情数据加载 =====
    loadAiReviewBundle: function(row) {
      var self = this;
      // 重置状态
      self.aiTabIndex = 0;
      self.aiItems = [];
      self.aiFilteredItems = [];
      self.aiFilterSeverity = '';
      self.aiFilterStatus = '';
      self.aiSummary = { rules_total: 0, errors: 0, warnings: 0, non_ok_rules: 0 };
      self.aiRefreshState = '';
      self.aiSnapshotAt = '';
      self.aiWorkflowStatus = '';
      self.aiWorkflowError = '';
      self.aiTaskId = '';
      self.aiInputHash = '';
      // self.aiJobId = '';
      self.aiRefreshStateText = '';
      self.aiBusinessStatus = '';
      self.aiBusinessStatusText = '';
      self.aiBusinessStatusColor = '#333';

      // 调用智审详情接口
      var aiParams = {
        businessId: row.id,
        taxpayerId: self.editData.nsrsbh || '',
        projectSeq: self.projectSeq,
        isRefreshOperation: !!row.isRefreshOperation,
      };
      ajax("POST", "/cxfw/aisdhc/aicompare/view", aiParams).done(function(res) {
        if (res.code == '0' && res.data) {
          var data = res.data;
          // 头部状态字段
          if (data.refreshStatus) {
            self.aiRefreshState = data.refreshStatus.refreshState || '';
            self.aiSnapshotAt = data.refreshStatus.resultSnapshotAt || '';
          }
          if (data.business) {
            self.aiBusinessStatus = data.business.status || '';
            // self.aiJobId = data.business.jobId || '';
          }
          // 如果 trigger 接口传入了 jobId，优先使用
          if (row.aiJobId) {
            self.aiJobId = row.aiJobId;
          }
          self.updateStatusTexts();
          self.handleAiReviewData(data);
        } else if (res.code != '0') {
          tools.info(res.msg);
        }
      })

      // 加载跨单证比对数据
      self.loadCrossCheckBundle(row);
    },

    // ===== 跨单证比对数据加载 =====
    loadCrossCheckBundle: function(row) {
      var self = this;
      self.ccGroups = [];
      self.ccTimeline = [];
      self.ccGroupTags = [];
      self.ccSelectedCount = 0;
      self.ccTotalFields = 0;

      // 调用跨单证比对接口
      var ccParams = {
        businessId: row.id,
        taxpayerId: self.editData.nsrsbh || '',
        projectSeq: self.projectSeq,
        isRefreshOperation: !!row.isRefreshOperation,
      };
      ajax("POST", "/cxfw/aisdhc/aicompare/crosscheck", ccParams).done(function(res) {
        if (res.code == '0' && res.data) {
          self.handleCrossCheckData(res.data);
        } else if (res.code != '0') {
          tools.info(res.msg);
        }
      })
    },

    // 状态文本映射
    updateStatusTexts: function() {
      var self = this;
      // 任务状态
      var refreshDict = { 'ready': '已完成', 'refreshing': '刷新中' };
      self.aiRefreshStateText = refreshDict[self.aiRefreshState] || self.aiRefreshState || '-';
      // 工作流状态
      var statusDict = {
        'pending': '待处理', 'running': '进行中',
        'succeeded': '已通过', 'completed': '已完成',
        'failed': '执行失败', 'blocked': '执行失败', 'cancelled': '执行失败'
      };
      var colorDict = {
        'pending': '#faad14', 'running': '#1890ff',
        'succeeded': '#52c41a', 'completed': '#52c41a',
        'failed': '#f5222d', 'blocked': '#f5222d', 'cancelled': '#f5222d'
      };
      self.aiBusinessStatusText = statusDict[self.aiBusinessStatus] || self.aiBusinessStatus || '-';
      self.aiBusinessStatusColor = colorDict[self.aiBusinessStatus] || '#333';
    },

    // 刷新结果
    refreshAiResult: function() {
      var self = this;
      var row = { id: self.editData.id, type: self.detailType, isRefreshOperation: true };
      self.loadAiReviewBundle(row);
    },

    // 处理智审详情接口返回数据
    handleAiReviewData: function(data) {
      var self = this;
      if (!data) return;

      // refreshStatus (驼峰)
      if (data.refreshStatus) {
        self.aiRefreshState = data.refreshStatus.refreshState || '';
        self.aiSnapshotAt = data.refreshStatus.resultSnapshotAt || '';
      }

      // workflowStatus (驼峰)
      if (data.workflowStatus) {
        self.aiWorkflowStatus = data.workflowStatus.status || '';
        self.aiWorkflowError = data.workflowStatus.lastError || '';
      }

      // items - 转换展示字段 (驼峰)
      var items = data.items || [];
      var errorCount = 0;
      var warningCount = 0;
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        item.severityText = SEVERITY_DICT[item.severity] || item.severity || '';
        if (item.severity == 'error') errorCount++;
        if (item.severity == 'warning') warningCount++;
        // leftDocumentType -> 文件类型中文名
        item.leftDocTypeName = item.leftDocumentType ? (DOC_TYPE_DICT[item.leftDocumentType] || item.leftDocumentType) : '';
        // rightDocumentType -> 文件类型中文名
        item.rightDocTypeName = item.rightDocumentType ? (DOC_TYPE_DICT[item.rightDocumentType] || item.rightDocumentType) : '';
      }
      self.aiItems = items;

      // summary - errors/warnings 从 items 列表按 severity 统计
      var rulesTotal = (data.summary && data.summary.rulesTotal) || items.length;
      var nonOkRules = (data.summary && data.summary.nonOkRules) || 0;
      self.aiSummary = {
        rules_total: rulesTotal,
        errors: errorCount,
        warnings: warningCount,
        non_ok_rules: nonOkRules,
      };

      self.filterAiItems();
    },

    // 筛选智审列表
    filterAiItems: function() {
      var self = this;
      var severity = self.aiFilterSeverity;
      var status = self.aiFilterStatus;
      var filtered = [];
      for (var i = 0; i < self.aiItems.length; i++) {
        var item = self.aiItems[i];
        if (severity && item.severity !== severity) continue;
        if (status && item.status !== status) continue;
        filtered.push(item);
      }
      self.aiFilteredItems = filtered;
    },

    // ===== 跨单证比对数据处理 =====
    handleCrossCheckData: function(data) {
      var self = this;
      if (!data) return;
      var STAGE_DICT = { purchase: '采购/生产环节', sales: '销售环节', other: '其他' };
      var stages = ['purchase', 'sales', 'other'];

      // 时间线 - 固定7个节点，接口返回的做匹配
      var TIMELINE_TEMPLATE = [
        { key: 'sales-contract-signed-at', label: '销售合同签订时间', value: '-', hasIssue: false },
        { key: 'purchase-contract-signed-at', label: '采购合同签订时间', value: '-', hasIssue: false },
        { key: 'purchase-invoice-issued-at', label: '采购发票开具时间', value: '-', hasIssue: false },
        { key: 'declaration-applied-at', label: '报关单申报时间', value: '-', hasIssue: false },
        { key: 'declaration-exported-at', label: '报关单出口时间', value: '-', hasIssue: false },
        { key: 'bill-of-lading-issued-at', label: '提单签发时间', value: '-', hasIssue: false },
        { key: 'sales-invoice-issued-at', label: '销售发票开具时间', value: '-', hasIssue: false }
      ];
      var apiTimeline = data.timeline || [];
      var timelineMap = {};
      for (var t = 0; t < apiTimeline.length; t++) {
        timelineMap[apiTimeline[t].key] = apiTimeline[t];
      }
      var timeline = [];
      for (var t = 0; t < TIMELINE_TEMPLATE.length; t++) {
        var tpl = TIMELINE_TEMPLATE[t];
        var matched = timelineMap[tpl.key];
        timeline.push({
          key: tpl.key,
          label: (matched && matched.label) || tpl.label,
          value: (matched && matched.value) || tpl.value,
          hasIssue: matched ? (matched.hasIssue || matched.has_issue || false) : false
        });
      }
      self.ccTimeline = timeline;

      // 统计已选字段
      var defaults = data.defaults || {};
      var selectedKeys = defaults.selectedFieldKeys || [];

      // 构建分组
      var groups = [];
      var groupTags = [];
      var totalFields = 0;

      for (var s = 0; s < stages.length; s++) {
        var stageKey = stages[s];
        var docs = (data.documents && data.documents[stageKey]) || [];
        var fields = (data.comparisonFields && data.comparisonFields[stageKey]) || [];
        if (docs.length === 0 && fields.length === 0) {
          groupTags.push({ label: STAGE_DICT[stageKey] || stageKey, count: 0 });
          continue;
        }

        // 提取单证类型列表（表头）
        var docTypes = [];
        for (var d = 0; d < docs.length; d++) {
          docTypes.push({ type: docs[d].docType, name: docs[d].docTypeName || DOC_TYPE_DICT[docs[d].docType] || docs[d].docType });
        }

        // 处理每行字段
        var mismatchCount = 0;
        var warningCount = 0;
        var processedFields = [];
        for (var f = 0; f < fields.length; f++) {
          var row = fields[f];
          totalFields++;
          // 计算行级状态图标
          var rowStatus = 'match';
          var cells = [];
          for (var v = 0; v < docTypes.length; v++) {
            var cell = { value: '-', status: 'empty' };
            if (row.values) {
              for (var vi = 0; vi < row.values.length; vi++) {
                if (row.values[vi].docType === docTypes[v].type) {
                  cell = { value: row.values[vi].value || '-', status: row.values[vi].status || 'empty' };
                  break;
                }
              }
            }
            if (cell.status === 'mismatch') rowStatus = 'mismatch';
            else if (cell.status === 'warning' && rowStatus !== 'mismatch') rowStatus = 'warning';
            cells.push(cell);
          }
          if (rowStatus === 'mismatch') mismatchCount++;
          if (rowStatus === 'warning') warningCount++;
          processedFields.push({
            fieldKey: row.fieldKey,
            fieldName: row.fieldName,
            statusIcon: rowStatus,
            cells: cells
          });
        }

        groupTags.push({ label: STAGE_DICT[stageKey] || stageKey, count: docs.length });
        groups.push({
          key: stageKey,
          label: STAGE_DICT[stageKey] || stageKey,
          docTypes: docTypes,
          docCount: docs.length,
          fieldCount: fields.length,
          mismatchCount: mismatchCount,
          warningCount: warningCount,
          fields: processedFields
        });
      }

      self.ccGroups = groups;
      self.ccGroupTags = groupTags;
      self.ccSelectedCount = selectedKeys.length;
      self.ccTotalFields = totalFields;
    },

    // ===== 原有方法保持不变 =====
    // 重新智审
    reAiReview: function() {
      var self = this;
      var params = {
        projectSeq: self.projectSeq,
        businessId: self.editData.id || '',
        taxpayerId: self.editData.nsrsbh || '',
      };
      ajax("POST", "/cxfw/aisdhc/aicompare/business/retrigger", params).done(function(res) {
        if (res.code == '0') {
          var jobId = (res.data && res.data.jobId) || '';
          if (jobId) {
            self.aiJobId = jobId;
          }
          tools.info('重新智审已触发');
          // 刷新两个tab的数据，保留新jobId
          var row = { id: self.editData.id, type: self.detailType, aiJobId: jobId, isRefreshOperation: true };
          self.loadAiReviewBundle(row);
        } else {
          tools.info(res.msg);
        }
      })
    },

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

    hideEdit: function () {
      $('.model').hide()
      $('.page-model-edit-ai').hide()
      this.editData = {}
      this.editRangeList = []
    },

    saveEdit: function () {
      var self = this
      var params = {
        id: this.editData.id,
        range: this.editRangeList.join(','),
        note: this.editData.note,
      }
      if(!params.range){
        tools.info('请至少选择一种核查单证类型');
        return
      }
      var saveFn = self.detailType == 'daily' ? api.dzbaDailyBusinessSave : api.dzbaYearBusinessSave;
      saveFn(params).done(function (res) {
        if (res.code == '0') {
          self.hideEdit()
          tools.info('保存成功！');
        }
      })
    },

    showMultiPdf: function () {
      if (this.editData.status < 3 || this.editData.balx == 1 || !this.hasTypeTreeFiles()) {
        return;
      }
      var viewer = components['multiPdfViewerglobal-multi-pdf'];
      if (viewer) {
        viewer.showTreePdfs(this.typeTreeData, '核查单证类型', null, 'dzbaFileViewPdf', this.editData, this.editData.status > 3 ? 'view' : 'edit');
      } else {
        tools.info('PDF预览组件未初始化');
      }
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

    searchDz: function () {
      var self = this
      if (this.editData.status < 3 || this.editData.balx==1) {
        return;
      }
      var params = {
        inspectNo: this.editData.id,
        mode: this.editData.status>3? 'view': 'edit',
        type: self.detailType,
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

    getRemark: function () {
      var self = this
      apiClient.getRemark({ taskType: '01' }).done(function (res) {
        var docInfo = res.docInfo
        if (docInfo.length <= 0 && res.inspectInfo.length <= 0) {
          clearTimeout(self.timer)
        } else {
          self.timer = setTimeout(self.getRemark, 1000);
        }
        if (docInfo.length > 0) {
          self.resetDocinfo(docInfo);
          ajax("POST", "/dzba/file/remark/save", { docInfo: docInfo })
        }
      }).fail(function (err) {
        clearTimeout(self.timer)
      })
    },

    resetDocinfo: function(docInfo){
      for(var i=0; i<docInfo.length; i++){
        docInfo[i].changeFlag = docInfo[i].changeFlag? docInfo[i].changeFlag: 'Y';
      }
    },

    getBackList: function(row){
      var self = this;
      var params = {
        hclx: row.type == 'daily'? '1': '2',
        inspectNo: row.id,
      }
      this.hasBackList = false;
      // 先销毁已存在的表格
      var tableId = self.templateName + '-back-table';
      if($.jgrid && $.jgrid.gridUnload) {
        try {
          $.jgrid.gridUnload(tableId);
        } catch(e) {}
      }
      api.getBackList(params).done(function(res){
        if(res.code=='0' && res.data && res.data.length>0){
          self.hasBackList = true;
          // 等待 DOM 更新后再初始化表格
          setTimeout(function(){
            self.createBackListTable(res.data);
          }, 100);
        }
      })
    },

    createBackListTable: function(data){
      var self = this;
      for(var i=0; i<data.length; i++){
        data[i].num = i+1;
      }
      var columns = [
        { name: "id", label: "任务id", index: "id", hidden: true },
        { name: "num", label: "序号", index: "num", width: 55, align: "center", sortable: false },
        { name: "backTime", label: "退回时间", index: "backTime", width: 160, sortable: false },
        { name: "returnee", label: "退回人", index: "returnee", width: 100, align: 'center', sortable: false },
        { name: "backReason", label: "退回原因", index: "backReason", width: 300, align: "left", sortable: false },
        {
          name: "", label: "操作", index: "", width: 120, align: "center", sortable: false, formatter: function (cellVal, op, row) {
            return '<div class="btn op-btn min" title="查看退回时对应的单证">查看单证</div>'
          }
        },
      ];
      $("#"+self.templateName + '-back-table').jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        shrinkToFit: true,
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: 2000,
        height: 'auto',
        beforeSelectRow: function (rowid, e) {
          var row = $('#'+self.templateName + '-back-table').jqGrid('getRowData', rowid);
          if ($(e.target).hasClass('op-btn')) {
            var id = row.id;
            self.showBackFile(id);
            return false
          }
        },
      })
      $("#"+self.templateName + '-back-table').resetSelection();
      $("#"+self.templateName + '-back-table')[0].addJSONData(data);
    },

    showBackFile: function(id){
      var self = this;
      if (self.isWindows) {
        var params = { id: id }
        api.getBackFileView(params).done(function(res){
          if (res.code == '0') {
            var data = res.data
            if (!data) {
              return;
            }
            apiClient.baywManageNew(data);
          }
        })
        return;
      }
      var params = {
        nsrsbh: this.editData.nsrsbh,
        id: id
      }
      api.dzbaInspectDailyBackTree(params).done(function(res){
        if (res.code == '0') {
          var data = res.data
          if (!data) {
            return;
          }
          self.backFileTreeData = data;
          var viewer = components['multiPdfViewerglobal-multi-pdf'];
          if (viewer) {
            viewer.showTreePdfs(data, '退回文件', null, 'dzbaInspectDailyBackFileViewPdf', self.editData, 'view');
          } else {
            tools.info('PDF预览组件未初始化');
          }
        }
      })
    },
    // 隐藏退回文件弹框
    hideBackFile: function(){
      $('.page-model-back-file-overlay').hide();
      $('.page-model-back-file').hide();
    },
  }
})
