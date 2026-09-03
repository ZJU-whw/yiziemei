var dzhcRwcx = require("./dzhcRwcx.html");

avalon.component('dzhcRwcx', {
  template: dzhcRwcx,
  defaults: {
    params: {},
    propsToPager: {
      templateName: 'page-model-edit-rwcx'
    },
    qySearchType: 'nsrsbh', // nsrsbh-纳税人识别号，qymc-企业名称，hgdm-海关代码
    qySearchVal: '',
    swjgmc: "",
    selRows: [], // 选中项
    searchData: {
      swjgdm: "",
      nsrsbh: "",
      nsrmc: "",
      qyhgdm: "",
      sssq: "",
      sbpc: "",
      sbnypc: "",
      statusMode: '1', // 状态选择框切换，1-任务模式，2-核查模式
      status: "",
      entryId: "",
      sfyq: "",
      releaser: "",//下达人
      releaseStart: "", // 受理下达日期起
      releaseEnd: "", // 受理下达日期止
      reportStart: "", // 上报日期起
      reportEnd: "", // 上报日期止
      examineStart: "", // 核查日期起
      examineEnd: "", // 核查日期止
      pageNo: 1,
      orderSql: "",
      pageSize: 20,
    },
    typeTreeData: [], // 核查单证类型
    isErrorBack: false,
    modelData: {
      id: '',
      inspectNo: '',
      examineResult: '0',
      processType: '',
      examineNote: ''
    },
    tableData: {},
    showNsrsbhList: false,
    nsrsbhList: [],
    activeBgIndex: -1,
    showReleaserList: false,
    releaserList: [],
    activeBgReleaserIndex: -1,
    backData: {
      backReason: '', // 单笔退回原因
      id: '', // 日常审单核查任务序号
      range: '', // 核查类型范围
    },
    currentSdId: -1, // 当前审核任务id
    isPlsd: 1, // 审单弹框 1-批量审单，0-单笔审单
    finisnData: {},
    pdfDetailInfo: {},
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
    curRow: {},
    timer: null,
    editRangeList: [],
    isDZBAGL: false, // 是否为单证备案管理岗
    isManager: false,
    isWindows: true,
    resetSearchData: function () {
      this.searchData = {
        swjgdm: this.searchData.swjgdm,
        nsrsbh: "",
        nsrmc: "",
        qyhgdm: "",
        sssq: "",
        sbpc: "",
        sbnypc: "",
        statusMode: '1', // 状态选择框切换，1-任务模式，2-核查模式
        status: "",
        entryId: "",
        sfyq: "",
        releaser: avalonRoot.user.czrymc,//下达人
        releaseStart: "", // 受理下达日期起
        releaseEnd: "", // 受理下达日期止
        reportStart: "", // 上报日期起
        reportEnd: "", // 上报日期止
        examineStart: "", // 核查日期起
        examineEnd: "", // 核查日期止
        pageNo: "",
        orderSql: "",
        pageSize: 20,
      }
      this.qySearchVal = '';
    },
    onInit: function (e) {
      avalonRoot.dzhcRwcx = e.vmodel;
    },
    onReady: function () {
      this.isWindows = tools.isWindows();
      this.initParams();
      this.initUser();
      this.initTree();
      this.initDate();
      this.initHeight();
      this.getRole();
    },

    // 初始化params，用于适配外部直接跳转到查询页 - 审核助手
    initParams: function(){
      if(!this.params.nsrsbh) return
      this.qySearchVal = this.params.nsrsbh;
      this.searchData.sssq = this.params.sssq;
      this.searchData.sbpc = this.params.sbpc;
      this.searchData.entryId = this.params.entryId;
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
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
      $('.dzhc-rwcx .datepicker.date-day').datetimepicker(options);
      $('.dzhc-rwcx .datepicker.date-month').datetimepicker({
        language: 'zh-CN',
        format: 'yyyymm',
        weekStart: 1,
        // todayBtn: true,
        clearBtn: true,
        autoclose: 1,
        todayHighlight: 1,
        startView: 3, // 这里就设置了默认视图为年视图
        minView: 3, // 设置最小视图为年视图
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
        var h = $(".dzhc-rwcx .form").height();
        if (h > 100) {
          $("#dzhc-rwcx-table").jqGrid('setGridHeight', h - 70);
        }
      })
    },

    getLxrDh: function(nsrsbh){
      var params = {
        qybs: nsrsbh
      }
      api.dzbaNsrxxGet(params).done(function(res){
        if(res.code=='0'){
          var lxrDhCzr = (res.data && res.data.lxrDhCzr) || '';
          if(lxrDhCzr) $('#rwcx-phone').val(lxrDhCzr);
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
    createTable: function () {
      var self = this;
      var columns = [
        {
          name: "op2", label: "操作", width: 0, frozen: true, align: "center", resizable: false, search: false, sortable: false, formatter: function (cellVal, options, row) {
            var status = row.status; // 0-未下达，1-已下达/已退回，2-已收讫，3-已上报，4-已审核
            var isEdit = !row.releaser || self.isDZBAGL && avalonRoot.user.czrymc==row.releaser || !self.isDZBAGL
            var edit_title = status == 0 && isEdit ? '编辑' : '查看';
            var xd_enable = status == 0;
            var del_enable = status != 4;
            var sh_enable = status == 3;
            var h = '';
            h += "<div class='btn op-btn op-edit' title='" + edit_title + "'>" + edit_title + "</div>" // 查看
            if (status != 3) {
              h += "<div class='btn op-btn op-xd " + (xd_enable && isEdit ? '' : 'op-disabled') + "' title='下达'>下达</div>" // 下达
            } else {
              h += "<div class='btn op-btn op-back " + (isEdit ? '' : 'op-disabled') + "' title='退回'>退回</div>" // 退回
            }
            h += "<div class='btn op-btn op-del " + (del_enable && isEdit ? '' : 'op-disabled') + "' title='作废'>作废</div>" // 作废
            if (status != 4) {
              h += "<div class='btn op-btn op-sh " + (sh_enable && isEdit ? '' : 'op-disabled') + "' title='审核'>审核</div>" // 审核
            } else {
              h += "<div class='btn op-btn op-shcx " + (isEdit ? '' : 'op-disabled') + "' title='审核撤销'>审核撤销</div>" // 审核撤销
            }
            return h
          }
        },
        { name: "id", label: "序号", index: "id", width: 55, align: "center", sortable: true },
        { name: "swjgdm", label: "税务机关代码", index: "swjgdm", hidden: true },
        { name: "swjgmc", label: "税务机关", index: "swjgmc", hidden: true },
        { name: "nsrsbh", label: "纳税人识别号", index: "nsrsbh", width: 135, sortable: false },
        { name: "nsrmc", label: "企业名称", index: "nsrmc", width: 120, sortable: false },
        { name: "sbywzl", label: "申报业务种类", index: "sbywzl", hidden: true },
        { name: "sbywzlName", label: "申报业务种类", index: "sbywzlName", width: 110, align: "center", sortable: true },
        { name: "sbnypc", label: "申报年月批次", index: "sbnypc", width: 100, align: "center", sortable: true },
        { name: "entryId", label: "报关单号", index: "entryId", width: 150, sortable: true },
        { name: "status", label: "状态", index: "status", hidden: true },
        { name: "statusName", label: "状态", index: "statusName", width: 55, align: "center", sortable: true },
        { name: "releaser", label: "下达人", index: "releaser", width: 60, sortable: true },
        { name: "releaseTime", label: "下达日期", index: "releaseTime", width: 120, align: "center", sortable: true },
        { name: "reportTime", label: "上报日期", index: "reportTime", width: 120, align: "center", sortable: true },
        { name: "overdule", label: "逾期日期", index: "overdule", width: 80, align: "center", sortable: true },
        {
          name: "yjsl", label: "三新预警", index: "yjsl", width: 60, align: "right", sortable: true, formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal){
               cellVal = avalon.filters.number(cellVal, 0);
               cellVal = '<div class="op-yjxx num">' + cellVal + '</div>'
            }
            return cellVal
          }
        },
        {
          name: "je", label: "出口销售额(美元)", index: "je", width: 100, align: "right", sortable: true, formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "se", label: "退免税额", index: "se", width: 80, align: "right", sortable: true, formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        { name: "examiner", label: "审核人", index: "examiner", width: 60, sortable: true },
        { name: "examineTime", label: "审核日期", index: "examineTime", width: 120, sortable: true },
        { name: "examineResult", label: "审核结论", index: "examineResult", width: 70, sortable: false },
        { name: "examineNote", label: "审核意见", index: "examineNote", width: 120, sortable: false },
        { name: "range", label: "检查类型范围", index: "range", hidden: true },
        { name: "ywlxCode", label: "业务类型代码", index: "ywlxCode", hidden: true },
        { name: "tsjsfsChg", label: "退税计算方式", index: "tsjsfsChg", hidden: true },
        { name: "sbrq", label: "申报日期", index: "sbrq", hidden: true },
        { name: "op", label: "操作", width: 268, align: "center", resizable: false, search: false, sortable: false }
      ];
      $("#dzhc-rwcx-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#dzhc-rwcx-tablePager',
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
          return $(".dzhc-rwcx .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          if ($(e.target).hasClass('op-disabled')) return
          var row = $('#dzhc-rwcx-table').jqGrid('getRowData', rowid);
          if ($(e.target).hasClass('op-edit')) { // 查看
            var isEdit = !row.releaser || self.isDZBAGL && avalonRoot.user.czrymc==row.releaser || !self.isDZBAGL
            // 打开出口业务详情
            var params = tools.clone(row)
            row.isEdit = isEdit
            self.showCkywDetail(row);
            return false
          } else if ($(e.target).hasClass('op-xd')) { // 下达
            self.releaseSingle(row);
          } else if ($(e.target).hasClass('op-del')) { // 作废
            self.withdrawSingle(row);
          } else if ($(e.target).hasClass('op-back')) { // 退回
            self.showBackSinglePre(row);
          } else if ($(e.target).hasClass('op-sh')) { // 审核
            self.showModelSd(0, row);
          } else if ($(e.target).hasClass('op-shcx')) { // 审核撤销
            self.revokeSingle(row);
          } else if($(e.target).hasClass('op-yjxx')){ // 预警信息 
            avalonRoot[self.propsToPager.templateName+'-yjxx'].initParam(row);
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
          var pageNo = tools.getPageNo(pgButton, "dzhc-rwcx-table");
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
      $("#dzhc-rwcx-table").jqGrid('setFrozenColumns');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-rwcx')).val();
      this.search(1)
    },

    // 单笔下达
    releaseSingle: function (row) {
      var self = this;
      var params = {
        id: row.id,
        overdule: '',
      }
      var text = '确定对';
      text += row.nsrmc;
      text += '申报年月批次【' + row.sbnypc;
      text += '】，<br />报关单号【' + row.entryId + '】的任务进行下达吗？';
      self.rwxdDialog(text, api.dzbaDailyReleaseSingle, params, row.nsrsbh);
    },

    // 单笔作废
    withdrawSingle: function (row) {
      var self = this;
      var params = {
        id: row.id,
      }
      var text = '确定对';
      text += row.nsrmc;
      text += '申报年月批次【' + row.sbnypc;
      text += '】，<br />报关单号【' + row.entryId + '】的任务进行作废吗？';
      tools.confirm(text, '确定', function () {
        api.dzbaDailyWithdrawSingle(params).done(function (res) {
          if (res.code == 0) {
            tools.info('作废成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 单笔审核撤销
    revokeSingle: function (row) {
      var self = this;
      var params = {
        id: row.id,
      }
      var text = '确定对';
      text += row.nsrmc;
      text += '申报年月批次【' + row.sbnypc;
      text += '】，<br />报关单号【' + row.entryId + '】的任务进行审核撤销吗？';
      tools.confirm(text, '确定', function () {
        api.dzbaDailyExamineRevokeSingle(params).done(function (res) {
          if (res.code == 0) {
            tools.info('审核撤销成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 获取核查单证类型
    getTypeTreeData: function (params) {
      var deferred = $.Deferred();
      var self = this
      self.typeTreeData = [];
      api.dzbaInspectTree(params).done(function (res) {
        if (res.code == '0') {
          self.typeTreeData = res.data;
          deferred.resolve();
        }
      })
      return deferred.promise()
    },

    hideBackSingle: function () {
      $('.model').hide();
      $('.dzhc-rwcx .page-model-back').hide();
      this.backData.backReason = '';
      this.backData.id = '';
      this.backData.range = '';
      this.editRangeList = [];
    },

    // 单笔退回 - 前置，将审核意见写入退回原因  businessBackPre
    showBackSinglePre: function(row){
      var self = this;
      $('.model').show();
      var params = {
        backType: 'daily',
        ids: row.id,
      }
      api.businessBackPre(params).done(function(res){
        self.showBackSingle(row);
        if(res.code==0 && res.data && res.data.length>0){
          for(var i=0; i<res.data.length; i++){
            var item = res.data[i];
            if(item.id==row.id && item.backReason){
              self.backData.backReason = item.backReason;
            }
          }
        }
      })
    },

    showBackSingle: function (row) {
      var self = this;
      $('.model').show();
      $('.dzhc-rwcx .page-model-back').show();
      this.isErrorBack = false;
      this.backData.id = row.id;
      var resetParams = {
        id: row.id,
        nsrsbh: row.nsrsbh,
        sbywzl: row.sbywzl,
        sbnypc: row.sbnypc,
        entryId: row.entryId,
      }
      api.dzbaInspectYjxxReset(resetParams).done(function(){
        self.editRangeList = row.range && row.range.split(',') || [];
        self.getTypeTreeData({ nsrsbh: row.nsrsbh, entryIds: [{ ywlxCode: row.ywlxCode, entryId: row.entryId, sbrq: row.sbrq }], type: 'daily', tsjsfsChg: row.tsjsfsChg }).done(function(){
          for(var i=0; i<self.typeTreeData.length; i++){
            var item = self.typeTreeData[i].item;
            for(var j=0; j<item.length; j++){
              var tmp = item[j];
              if(self.editRangeList.indexOf(tmp.value)>-1){
                tmp.chkDisabled = true; // 退回时，单证类型可增不可减
              }
            }
          }
        })
      })
    },

    // 单笔退回
    saveBackSingle: function () {
      var self = this;
      if (this.backData.backReason == '') {
        this.isErrorBack = true
        return false
      } else {
        this.isErrorBack = false
      }
      self.backData.range = this.editRangeList.join(',');
      if(!self.backData.range){
        tools.info('请至少选择一种核查单证类型');
        return
      }
      api.dzbaDailyBackSingle(this.backData).done(function (res) {
        if (res.code == 0) {
          tools.info('退回成功');
          self.hideBackSingle();
          self.search(self.searchData.pageNo);
        }
      })
    },

    saveModelSd: function () {
      var self = this
      if (this.modelData.examineResult == '1' && this.modelData.examineNote == '') {
        return false
      }
      if (this.isPlsd == 1) {
        var params = {
          ids: this.getSelRow('plSH').row.join(','),
          examineResult: this.modelData.examineResult,
          examineNote: this.modelData.examineNote,
        }
        api.dzbaDailyExamineBatch(params).done(function (res) {
          if (res.code == '0') {
            tools.info('操作成功！')
            self.hideModelSd();
            self.search(self.searchData.pageNo)
          }
        })
      } else if (this.isPlsd == 0) {
        var params = {
          id: this.currentSdId,
          examineResult: this.modelData.examineResult,
          examineNote: this.modelData.examineNote,
        }
        api.dzbaDailyExamineSingle(params).done(function (res) {
          if (res.code == '0') {
            tools.info('操作成功！')
            self.hideModelSd();
            self.search(self.searchData.pageNo)
          }
        })
      }
    },

    // 审单弹框显示
    showModelSd: function (isPlsd, row) {
      var self = this;
      if (isPlsd == 1) { // 批量审单时，做好前置校验
        var selRow = this.getSelRow('plSH').row;
        if (selRow.length == 0) return
        self.showwModelEnd();
      } else if (isPlsd == 0) {
        self.currentSdId = row.id;
        self.curRow = row;
        var params = {
          id: row.id,
        }
        api.dzbaDailyExamineSinglePre(params).done(function (res) {
          if (res.code == 0) {
            self.finisnData = res.data;
            self.resetPdfDetailInfo(row, res.data);
            self.modelData.examineNote = res.data.examineNote ? res.data.examineNote : '';
            self.editRangeList = res.data.range && res.data.range.split(',') || [];
            if (isPlsd == 0) {
              let para = {
                nsrsbh: row.nsrsbh,
                entryIds: [{ ywlxCode: row.ywlxCode, entryId: row.entryId, sbrq: row.sbrq }],
                type: 'daily',
                tsjsfsChg: row.tsjsfsChg
              }
              var includeFileFlag = !self.isWindows && ['3','4'].indexOf(row.status) != -1
              if (includeFileFlag) {
                para.includeFileFlag = true
                para.ranges = row.range || ''
              }
              self.getTypeTreeData(para)
            };
            self.showwModelEnd();
          }
        })
      }
      this.isPlsd = isPlsd;
    },

    showwModelEnd: function(row){
      $('.model').show();
      $('.dzhc-rwcx .page-model-end').show();
      var examineResult = this.modelData.examineResult;
      this.modelData.examineResult = -1;
      this.modelData.examineResult = examineResult;
    },

    // 审单弹框隐藏
    hideModelSd: function () {
      $('.model').hide();
      $('.dzhc-rwcx .page-model-end').hide();
      this.modelData = {
        id: '',
        inspectNo: '',
        examineResult: '0',
        processType: '',
        examineNote: ''
      }
      this.editRangeList = [];
    },

    // 批量下达
    plReleaseBatch: function () {
      var selRow = this.getSelRow('plXD');
      var row = selRow.row;
      var entryIds = selRow.entryIds;
      if (row.length == 0) return
      var params = {
        ids: row.join(','),
      }
      var text = '确定对';
      var len = entryIds.length > 1 ? 2 : entryIds.length;
      var text_ct = [];
      for (var i = 0; i < len; i++) {
        var text_temp = '';
        var nsrmc = entryIds[i].nsrmc;
        var sbnypc = entryIds[i].sbnypc;
        var entryId = entryIds[i].entryId;
        text_temp += nsrmc;
        text_temp += '申报年月批次【' + sbnypc;
        text_temp += '】，<br />报关单号【' + entryId + '】';
        text_ct.push(text_temp);
      }
      text += text_ct.join('；<br />')
      if (len > 1) text += '等';
      text += '的任务进行下达操作吗？'
      this.rwxdDialog(text, api.dzbaDailyReleaseBatch, params, entryIds[0].nsrsbh);
    },

    // 批量作废
    plWithdrawBatch: function () {
      var self = this;
      var selRow = this.getSelRow('plDel');
      var row = selRow.row;
      var entryIds = selRow.entryIds;
      if (row.length == 0) return
      var params = {
        ids: row.join(','),
      }
      var text = '确定对';
      var len = entryIds.length > 1 ? 2 : entryIds.length;
      var text_ct = [];
      for (var i = 0; i < len; i++) {
        var text_temp = '';
        var nsrmc = entryIds[i].nsrmc;
        var sbnypc = entryIds[i].sbnypc;
        var entryId = entryIds[i].entryId;
        text_temp += nsrmc;
        text_temp += '申报年月批次【' + sbnypc;
        text_temp += '】<br />报关单号【' + entryId + '】';
        text_ct.push(text_temp);
      }
      text += text_ct.join('；<br />')
      if (len > 1) text += '等';
      text += '的任务进行作废操作吗？'
      tools.confirm(text, '确定', function () {
        api.dzbaDailyWithdrawBatch(params).done(function (res) {
          if (res.code == 0) {
            tools.info('批量作废成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    // 批量退回 - 前置，将审核意见写入退回原因
    plBackBatchPre: function(){
      var self = this;
      var selRow = this.getSelRow('plBack');
      var row = selRow.row;
      if (row.length == 0) return
      var params = {
        backType: 'daily',
        ids: row.join(','),
      }
      api.businessBackPre(params).done(function(res){
        var backReason = '';
        if(res.code==0 && res.data && res.data.length>0){
          for(var i=0; i<res.data.length; i++){
            var item = res.data[i];
            if(!item.backReason) continue;
            backReason += '序号' + item.id + '，报关单号' + item.entryId + '：' + item.backReason + '；\n';
          }
        }
        self.plBackBatch(selRow, backReason);
      })

    },

    // 批量退回
    plBackBatch: function (selRow, backReason) {
      var self = this;
      var row = selRow.row;
      var entryIds = selRow.entryIds;
      var html = '<p class="mb-5"><span style="color: red;">*</span>原因描述:</p><textarea rows="8" cols="60" id="rwcxPlBackReason" style="width:100%"></textarea><p id="rwcxPlBackReasonTip" class="text-red" style="display:none;">原因描述不能为空</p>'
      $.dialog({
        padding: '10px 20px',
        title: "核查任务退回重报",
        content: html,
        okValue: '确定',
        lock: true,
        ok: function () {
          var val = $('#rwcxPlBackReason').val().trim()
          if (val == '') {
            $('#rwcxPlBackReasonTip').show()
            return false;
          }
          var params = {
            ids: row.join(','),
            backReason: val,
          }
          var text = '确定对';
          var len = entryIds.length > 1 ? 2 : entryIds.length;
          var text_ct = [];
          for (var i = 0; i < len; i++) {
            var text_temp = '';
            var nsrmc = entryIds[i].nsrmc;
            var sbnypc = entryIds[i].sbnypc;
            var entryId = entryIds[i].entryId;
            text_temp += nsrmc;
            text_temp += '申报年月批次【' + sbnypc;
            text_temp += '】<br />报关单号【' + entryId + '】';
            text_ct.push(text_temp);
          }
          text += text_ct.join('；<br />')
          if (len > 1) text += '等';
          text += '的任务进行退回操作吗？'
          tools.confirm(text, '确定', function () {
            api.dzbaDailyBackBatch(params).done(function (res) {
              if (res.code == 0) {
                tools.info('批量退回成功');
                self.search(self.searchData.pageNo);
              }
            })
          })
        },
        cancelValue: '取消',
        cancel: function () {
        },
      })
      $('.d-buttons').css('text-align', 'center');
      $('#rwcxPlBackReason').val(backReason);
    },

    // 下达任务选择期限弹框
    rwxdDialog: function (text, f, params, nsrsbh) {
      var self = this;
      var content = "<div style='padding: 10px 20px 20px 20px'><div style='padding-bottom: 10px;'><label style='display:inline-block;min-width:84px;text-align:right;'>资料报送期限：</label><input id='rwcx-deadline' type='text' data-date-start-date='1d' data-date-end-date='30d' readonly /></div><div style='padding-bottom: 10px;'><label style='display:inline-block;min-width:84px;text-align:right;'>联系电话：</label><input id='rwcx-phone' type='text' /></div><div>" + text + "</div></div>"
      $.dialog({
        title: "提示",
        padding: 0,
        content: content,
        okValue: '确定',
        lock: true,
        ok: function () {
          var phone = $('#rwcx-phone').val().trim();
          params.overdule = $('#rwcx-deadline').val();
          params.lxdh = phone;
          f(params).done(function (res) {
            if (res.code == '0') {
              tools.info("任务下达成功");
              self.search(self.searchData.pageNo);;
            }
          })
        },
        cancelValue: '取消',
        cancel: function () {
        }
      })
      var startDate = tools.getNextDay(1);
      var endDate = tools.getNextDay(30);
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2, startDate: startDate, endDate: endDate };
      $('#rwcx-deadline').datetimepicker(options);
      $('#rwcx-deadline').val(tools.getNextDay(15));
      self.getLxrDh(nsrsbh);
    },

    /**
     * 根据参数获取选中行数据
     * @type  'plXD'-批量下达  plDel-批量作废  plBack-批量退回  plSH-批量审核
    */
    getSelRow: function (type) {
      var selRow = {
        row: [],
        entryIds: [],
      }
      var tbRows = this.tableData.rows;
      if (type == 'plXD') {
        for (var i = 0; i < tbRows.length; i++) {
          if (tbRows[i].status == 0 && this.selRows.indexOf(String(tbRows[i].id)) > -1) {
            selRow.row.push(String(tbRows[i].id));
            selRow.entryIds.push({
              nsrmc: tbRows[i].nsrmc,
              nsrsbh: tbRows[i].nsrsbh,
              sbnypc: tbRows[i].sbnypc,
              entryId: tbRows[i].entryId,
            });
          }
        }
      };
      if (type == 'plDel') {
        for (var i = 0; i < tbRows.length; i++) {
          if (tbRows[i].status != 4 && this.selRows.indexOf(String(tbRows[i].id)) > -1) {
            selRow.row.push(String(tbRows[i].id));
            selRow.entryIds.push({
              nsrmc: tbRows[i].nsrmc,
              sbnypc: tbRows[i].sbnypc,
              entryId: tbRows[i].entryId,
            });
          }
        }
      }
      if (type == 'plBack') {
        for (var i = 0; i < tbRows.length; i++) {
          if (tbRows[i].status == 3 && this.selRows.indexOf(String(tbRows[i].id)) > -1) {
            selRow.row.push(String(tbRows[i].id));
          }
        }
      }
      if (type == 'plSH') {
        for (var i = 0; i < tbRows.length; i++) {
          if (tbRows[i].status == 3 && this.selRows.indexOf(String(tbRows[i].id)) > -1) {
            selRow.row.push(String(tbRows[i].id));
          }
        }
      }
      var typeStrObj = {
        'plXD': '状态为未下达的',
        'plDel': '状态不为已审核的',
        'plBack': '状态为已上报的',
        'plSH': '状态为已上报的',
      }
      if (selRow.row.length == 0) {
        tools.info('请至少选择一笔' + typeStrObj[type] + '出口业务');
      }
      return selRow
    },

    showCkywDetail: function (row) {
      $('.model').show();
      $('.dzhc-rwcx .page-model-edit').show();
      row.type = 'daily';
      avalonRoot[this.propsToPager.templateName].search(row);
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
        { name: "shxydm", rules: 'max_length[21]', message: "社会信用代码最大长度为10" },
        { name: "nsrmc", rules: 'max_length[30]', message: "纳税人名称最大长度为30" },
      ];
      if (this.searchData.releaser == '') {
        tools.info('下达人不能为空！');
        return;
      }
      var dateValid1 = tools.checkDate(this.searchData.releaseStart, this.searchData.releaseEnd);
      var dateValid2 = tools.checkDate(this.searchData.reportStart, this.searchData.reportEnd);
      var dateValid3 = tools.checkDate(this.searchData.examineStart, this.searchData.examineEnd);
      if (!dateValid1) {
        tools.info('下达日期截止日期必须大于起始日期')
        return false
      }
      if (!dateValid2) {
        tools.info('上报日期截止日期必须大于起始日期')
        return false
      }
      if (!dateValid3) {
        tools.info('审核日期截止日期必须大于起始日期')
        return false
      }
      if (!this.searchData.sssq && !this.searchData.sbpc) {
        this.searchData.sbnypc = ''
      }
      if (this.searchData.sssq) {
        if (!this.searchData.sbpc) {
          tools.info('申报年月不为空时，申报批次也不能为空')
          return;
        } else {
          this.searchData.sbnypc = this.searchData.sssq + '-' + this.searchData.sbpc
        }
      }
      if (!this.searchData.sssq && this.searchData.sbpc) {
        tools.info('申报批次不为空时，申报年月也不能为空')
        return;
      }
      var isValid = tools.validate("dzhc-rwcx-form", fields);
      if (isValid) {
        // 处理外层查询条件切换时的问题
        this.qySearchValChg();
        this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-rwcx')).val() || 20;
        self.searchData.pageNo = pageNo || 1;
        var params = tools.clone(self.searchData);
        $("#dzhc-rwcx-table").jqGrid('clearGridData')
        api.dzbaDailyQueryList(params).done(function (res) {
          if (res.code == '0') {
            $("#dzhc-rwcx-table").resetSelection();
            $("#dzhc-rwcx-table")[0].addJSONData(res.data);
            self.tableData = res.data;
            self.selRows = [];
            tools.HeiKj('dzhc-rwcx', 'dzhc-rwcx-table')
            self.closeHyper()
          }
          $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        })
      }
    },
    showHyper: function () {
      $('.dzhc-rwcx .page .select-sub').toggle();
      $('.dzhc-rwcx .page .select-wrapper .icon').toggleClass("active");
      if ($('.dzhc-rwcx .page .select-wrapper .icon').attr("title").slice(0, 2) === "展开") {
        $('.dzhc-rwcx .page .select-wrapper .icon').attr("title", "收起查询条件");
      } else {
        $('.dzhc-rwcx .page .select-wrapper .icon').attr("title", "展开查询条件")
      }
    },
    closeHyper: function () {
      $('.dzhc-rwcx .select-sub').hide();
      $('.dzhc-rwcx .select-wrapper .icon').removeClass('active');
      $('.dzhc-rwcx .select-wrapper .icon').attr("title", "展开查询条件")
    },

    saveModel: function () {
      var self = this
      if (this.modelData.examineResult == '1' && this.modelData.examineNote == '') {
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
          $.fn.zTree.init($(".dzhc-rwcx .treeDiv"), setting, res.data);
        }
      })
    },
    showTree: function (e) {
      var self = this;
      $(".treeDiv", $(e.target).parent()).show();
      $('.dzhc-rwcx').on('click', function (e) {
        var e = e || window.event;
        if ($('.treeDiv').find($(e.target)).length <= 0) {
          self.hideTree();
        }
      })
    },
    hideTree: function () {
      $(".treeDiv").hide();
      $('.dzhc-rwcx').off('click');
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
          this.searchData.releaser = this.releaserList[index].czryMc
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

    exform: function () {
      tools.ajaxExform(this.searchData, '/dzba/export/inspect/daily/query');
    },

    dataEntryidChg: function () {
      this.searchData.entryId = this.searchData.entryId.trim();
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
      this.showModelSd(0, this.curRow);
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

    resetPdfDetailInfo: function (row, data) {
      for (var key in this.pdfDetailInfo) {
        if (Object.prototype.hasOwnProperty.call(this.pdfDetailInfo, key)) {
          delete this.pdfDetailInfo[key];
        }
      }
      $.extend(this.pdfDetailInfo, row || {}, data || {});
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
        type: 'daily',
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
          self.showModelSd(0, self.curRow);
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

    // 模糊查询下达人，获取下达人列表
    inpChangeReleaser: function () {
      this.searchData.releaser = this.searchData.releaser.trim()
      var params = {
        releaser: this.searchData.releaser
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
      this.searchData.releaser = item.czryMc
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
    getRole: function(){
      var self = this
      api.releaserCheckRole({}).done(function (res) {
        if (res.code == '0') {
          self.isDZBAGL = res.data.isDZBAGL == '1'
          self.createTable();
          let isAdmin = ['super','admin'].indexOf(avalonRoot.user.roleDm) > -1
          if (isAdmin || self.isDZBAGL || res.data.isDZBAFH == '1') {
            self.isManager = true
          }
        }
      })
    },
  }
});
