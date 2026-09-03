var dzhcRcsd = require("./dzhcRcsd.html");

avalon.component('dzhcRcsd', {
  template: dzhcRcsd,
  defaults: {
    params: {},
    propsToPager: {
      templateName: 'page-model-edit-rcsd'
    },
    searchData: {
      nsrsbh: "",
      sbywzl: "",
      sbnypc: "",
      orderSql: "",
      status: '10',
      statusMode: '1',
      pageNo: 1,
      pageSize: 20,
    },
    tableData: [],
    rcsdInfo: {
      swjgmc: '',
      nsrsbh: '',
      nsrmc: '',
      sbywzl: '',
      sbnypc: '',
      balxName: '',
      statusName: '',
    },
    qySearchType: 'nsrsbh', // nsrsbh-纳税人识别号，qymc-企业名称，hgdm-海关代码
    qySearchVal: '',
    selRows: [], // 选中项
    searchAddCkywData: {
      nsrsbh: '',
      sbnypc: '',
      sbnd: '',
      entryId: '',
      ckrqq: '',
      ckrqz: '',
      tsjsfsChg: '',
      pageNo: "",
      pageSize: 20,
    },
    selRowsCkyw: [],
    ckywChooseList: [],
    addIndex: 0,
    modelAddStyle: {
      0: {
        width: '900px',
        marginLeft: '-450px',
        height: '540px',
        marginTop: '-270px',
        contentHeight: '450px'
      },
      1: {
        width: '600px',
        marginLeft: '-300px',
        height: '300px',
        marginTop: '-150px',
        contentHeight: '200px'
      }
    },
    modelData: {
      id: '',
      inspectNo: '',
      examineResult: '0',
      processType: '',
      examineNote: ''
    },
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
    isErrorBack: false, // 退回意见提示信息显示与否
    currentSdId: -1,
    isPlsd: 1, // 审单弹框 1-批量审单，0-单笔审单
    rangeList: [], // 新增时选中的核查单证类型
    editRangeList: [], // 新增时选中的核查单证类型
    typeTreeData: [], // 核查单证类型
    backData: {
      backReason: '', // 单笔退回原因
      id: '', // 日常审单核查任务序号
      range: '', // 核查类型范围
    },
    lxrDhCzr: '', // 联系电话  下达任务用 从企业信息中获取
    ckywTotal: 0,
    curRow: {},
    timer: null,
    isWindows: true,
    onInit: function (e) {
      avalonRoot.dzhcRcsd = e.vmodel;
    },

    onReady: function () {
      this.isWindows = tools.isWindows();

      this.initParams();
      this.initDate();
      this.initHeight();
      this.createTable();
      this.createTableAddCkyw();
      this.baseInfo();
      this.getLxrDh();
    },

    initParams: function () {
      this.searchData.nsrsbh = this.params.nsrsbh;
      this.searchData.sbywzl = this.params.sbywzl;
      this.searchData.sbnypc = this.params.sbnypc;
      this.searchAddCkywData.nsrsbh = this.params.nsrsbh;
      this.searchAddCkywData.sbnypc = this.params.sbnypc;
      this.searchAddCkywData.tsjsfsChg = this.params.tsjsfsChg || '';
    },

    // 初始化日期输入框
    initDate: function () {
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
      $('.dzhc-rcsd .datepicker.date-day').datetimepicker(options);
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".dzhc-rcsd .form").height();
        if (h > 100) {
          $("#dzhc-rcsd-table").jqGrid('setGridHeight', h - 70);
        }
      })
    },

    getLxrDh: function(){
      var self = this;
      var params = {
        qybs: this.searchData.nsrsbh
      }
      api.dzbaNsrxxGet(params).done(function(res){
        if(res.code=='0'){
          self.lxrDhCzr = (res.data && res.data.lxrDhCzr) || '';
        }
      })
    },

    // 状态信息查询
    baseInfo: function () {
      var self = this;
      var ywsTotal = this.params.ywsTotal.replace(/,/g, '');
      ywsTotal = parseInt(ywsTotal);
      ywsTotal = isNaN(ywsTotal)? '': ywsTotal;
      var ywsWork = this.params.ywsWork.replace(/,/g, '');
      ywsWork = parseInt(ywsWork);
      ywsWork = isNaN(ywsWork)? '': ywsWork;
      var params = {
        nsrsbh: this.params.nsrsbh,
        sbywzl: this.params.sbywzl,
        sbnypc: this.params.sbnypc,
        balxName: this.params.balxName,
        ywsTotal: ywsTotal,
        ywsWork: ywsWork,
      }
      api.dzbaInspectViewBaseinfo(params).done(function (res) {
        if (res.code == '0' && res.data) {
          self.rcsdInfo = res.data;
        }
      })
    },

    sbpcChange: function () {
      var sbpc = this.searchData.sbpc.replace(/[^0-9]/g, '')
      this.searchData.sbpc = sbpc
    },

    nsrsbhEnterSearch: function (e) {
      e.target.blur()
      this.search(1)
    },

    search: function (pageNo) {
      var self = this;
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-rcsd')).val() || 20;
      self.searchData.pageNo = pageNo;
      var params = tools.clone(self.searchData);
      $("#dzhc-rcsd-table").jqGrid('clearGridData')
      api.dzbaInspectViewDetails(params).done(function (res) {
        if (res.code == '0') {
          $("#dzhc-rcsd-table").resetSelection();
          $("#dzhc-rcsd-table")[0].addJSONData(res.data);
          self.tableData = res.data;
          self.selRows = [];
          tools.HeiKj('dzhc-rcsd', 'dzhc-rcsd-table');
        }
        $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
      })
    },

    createTable: function () {
      var self = this;
      var columns = [
        {
          name: "op2", label: "操作", width: 0, frozen: true, align: "center", resizable: false, search: false, sortable: false, formatter: function (cellVal, op, row) {
            var status = row.status; // 0-未下达，1-已下达/已退回，2-已收讫，3-已上报，4-已审核
            var edit_title = status == 0 ? '编辑' : '查看';
            var xd_enable = status == 0;
            var del_enable = status != 4;
            var sh_enable = status == 3;
            var h = '';
            h += "<div class='btn op-btn op-edit' title='" + edit_title + "'>" + edit_title + "</div>" // 编辑/查看
            if (status != 3) {
              h += "<div class='btn op-btn op-xd " + (xd_enable ? '' : 'op-disabled') + "' title='下达'>下达</div>" // 下达
            } else {
              h += "<div class='btn op-btn op-back' title='退回'>退回</div>" // 退回
            }
            h += "<div class='btn op-btn op-del " + (del_enable ? '' : 'op-disabled') + "' title='作废'>作废</div>" // 作废
            if (status != 4) {
              h += "<div class='btn op-btn op-sh " + (sh_enable ? '' : 'op-disabled') + "' title='审核'>审核</div>" // 审核
            } else {
              h += "<div class='btn op-btn op-shcx' title='审核撤销'>审核撤销</div>" // 审核撤销
            }
            return h
          }
        },
        { name: "id", label: "序号", index: "id", width: 55, align: "center", sortable: true },
        { name: "entryId", label: "报关单号", index: "entryId", width: 125 },
        { name: "status", label: "状态", index: "status", hidden: true, },
        { name: "statusName", label: "状态", index: "statusName", width: 55, align: "center", sortable: true },
        { name: "releaser", label: "下达人", index: "releaser", width: 60, align: "center", sortable: true },
        { name: "releaseTime", label: "下达日期", index: "releaseTime", width: 120, align: "center", sortable: true },
        { name: "reportTime", label: "上报日期", index: "reportTime", width: 120, align: "center", sortable: true },
        { name: "overdule", label: "逾期日期", index: "overdule", width: 80, align: "center", sortable: true },
        {
          name: "yjsl", label: "三新预警", index: "yjsl", width: 60, align: "right", sortable: true,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal){
               cellVal = avalon.filters.number(cellVal, 0);
               cellVal = '<div class="op-yjxx num">' + cellVal + '</div>'
            }
            return cellVal
          }
        },
        {
          name: "je", label: "出口销售额(美元)", index: "je", width: 100, align: "right", sortable: true,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "se", label: "退免税额", index: "se", width: 80, align: "right", sortable: true,
          formatter: function (cellVal, op, row) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        { name: "examiner", label: "审核人", index: "examiner", width: 60, align: "center", sortable: true },
        { name: "examineTime", label: "审核日期", index: "examineTime", width: 120, align: "center", sortable: true },
        { name: "examineResult", label: "审核结论", index: "examineResult", width: 70, sortable: true },
        { name: "examineNote", label: "审核意见", index: "examineNote", width: 150, sortable: false },
        { name: "range", label: "检查类型范围", index: "range", hidden: true },
        { name: "rangeName", label: "检查类型范围", index: "rangeName", width: 120, sortable: false },
        { name: "ywlxCode", label: "业务类型code", index: "ywlxCode", hidden: true },
        { name: "sbrq", label: "申报日期", index: "sbrq", hidden: true },
        { name: "op", label: "操作", width: 260, align: "center", resizable: false, search: false, sortable: false }
      ];
      $("#dzhc-rcsd-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#dzhc-rcsd-tablePager',
        shrinkToFit: false,
        width: "100%",
        multiselect: true,
        multiselectWidth: "30",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        rowNum: 20,
        rownumWidth: 40,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".dzhc-rcsd .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          if ($(e.target).hasClass('op-disabled')) return
          var row = $('#dzhc-rcsd-table').jqGrid('getRowData', rowid);
          row.tsjsfsChg = self.searchAddCkywData.tsjsfsChg;
          if ($(e.target).hasClass('op-edit')) { // 查看
            // 打开出口业务详情
            row.sbywzl = self.searchData.sbywzl;
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
          var pageNo = tools.getPageNo(pgButton, "dzhc-rcsd-table");
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
      $("#dzhc-rcsd-table").jqGrid('setFrozenColumns');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-rcsd')).val();
      this.search(1)
    },

    // 单笔下达
    releaseSingle: function (row) {
      var self = this;
      var params = {
        id: row.id,
        overdule: '',
      }
      var text = '确定对' + self.rcsdInfo.nsrmc;
      text += '申报年月批次【' + self.rcsdInfo.sbnypc;
      text += '】，<br/>报关单号【' + row.entryId + '】的任务进行下达吗？';
      self.rwxdDialog(text, api.dzbaDailyReleaseSingle, params);
    },

    // 单笔作废
    withdrawSingle: function (row) {
      var self = this;
      var params = {
        id: row.id,
      }
      var text = '确定对' + self.rcsdInfo.nsrmc;
      text += '申报年月批次【' + self.rcsdInfo.sbnypc;
      text += '】，<br/>报关单号【' + row.entryId + '】的任务进行作废吗？';
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
      var text = '确定对' + self.rcsdInfo.nsrmc;
      text += '申报年月批次【' + self.rcsdInfo.sbnypc;
      text += '】，<br/>报关单号【' + row.entryId + '】的任务进行审核撤销吗？';
      tools.confirm(text, '确定', function () {
        api.dzbaDailyExamineRevokeSingle(params).done(function (res) {
          if (res.code == 0) {
            tools.info('审核撤销成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    hideBackSingle: function () {
      $('.model').hide();
      $('.dzhc-rcsd .page-model-back').hide();
      this.backData.backReason = '';
      this.backData.id = '';
      this.backData.range = '';
      this.editRangeList = [];
    },

    // 单笔退回 - 前置，将审核意见写入退回原因
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
      $('.dzhc-rcsd .page-model-back').show();
      this.isErrorBack = false;
      this.backData.id = row.id;
      var resetParams = {
        id: row.id,
        nsrsbh: self.searchData.nsrsbh,
        sbywzl: self.searchData.sbywzl,
        sbnypc: self.searchData.sbnypc,
        entryId: row.entryId,
      }
      api.dzbaInspectYjxxReset(resetParams).done(function(){
        self.editRangeList = row.range && row.range.split(',') || [];
        self.getTypeTreeData({ nsrsbh: self.searchData.nsrsbh, entryIds: [{ entryId: row.entryId, ywlxCode: row.ywlxCode, sbrq: row.sbrq }], type: 'daily' }, row).done(function(){
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
        this.isErrorBack = true;
        return false
      } else{
        this.isErrorBack = false;
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

    showCkywDetail: function (row) {
      $('.model').show();
      $('.dzhc-rcsd .page-model-edit').show();
      row.type = 'daily';
      avalonRoot[this.propsToPager.templateName].search(row);
    },

    createTask: function () {
      $('.model').show();
      $('.dzhc-rcsd .page-model-add').show();
      this.addIndex = 0;
      this.searchCkyw(1);
    },


    // 查询出口业务列表
    searchCkyw: function (pageNo) {
      var self = this;
      var dateValid = tools.checkDate(this.searchAddCkywData.ckrqq, this.searchAddCkywData.ckrqz)
      if (!dateValid) {
        tools.info('出口日期截止日期必须大于起始日期');
        return false;
      }
      this.searchAddCkywData.pageSize = $(".ui-pg-selbox", $('.dzhc-rcsd .page-model-add')).val() || 20;
      self.searchAddCkywData.pageNo = pageNo;
      var params = tools.clone(self.searchAddCkywData);
      $("#dzhc-rcsd-ckyw-table").jqGrid('clearGridData')
      api.dzbaAvaliableList(params).done(function (res) {
        if (res.code == '0') {
          $("#dzhc-rcsd-ckyw-table").resetSelection();
          $("#dzhc-rcsd-ckyw-table")[0].addJSONData(res.data);
          self.ckywTotal = res.data? res.data.length: 0;
          self.ckywChooseList = []
          self.selRowsCkyw = []
          $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },

    // 新增任务-出口业务表格
    createTableAddCkyw: function () {
      var self = this;
      var columns = [
        { name: "sbywzl", label: "申报业务种类", index: "sbywzl", hidden: true },
        { name: "sbywzlName", label: "申报业务种类", index: "sbywzlName", width: 110, align: "center", sortable: false },
        { name: "sbnypc", label: "退税申报批次", index: "sbnypc", width: 100, align: "center", sortable: false },
        { name: "entryId", label: "报关单号", index: "entryId", width: 150, align: "center", sortable: false },
        { name: "ckrq", label: "出口日期", index: "ckrq", width: 90, align: "center", sortable: false },
        { name: "sbrq", label: "申报日期", index: "sbrq", width: 90, align: "center", sortable: false },
        { name: "ckfpNo", label: "出口发票", index: "ckfpNo", hidden: true },
        { name: "jhfpNo", label: "进项发票", index: "jhfpNo", hidden: true },
        {
          name: "je", label: "出口销售金额(美元)", index: "je", width: 130, align: "right", sortable: false, formatter: function (cellVal, options, rowObject) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "se", label: "退免税额", index: "se", width: 95, align: "right", sortable: false, formatter: function (cellVal, options, rowObject) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        { name: "ywlxCode", label: "业务类型代码", index: "ywlxCode", hidden: true },
      ]
      $("#dzhc-rcsd-ckyw-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        rownumbers: true,
        shrinkToFit: false,
        autoScroll: true,
        multiselect: true,
        viewrecords: true,
        // pager: '#dzhc-rcsd-ckyw-tablePager',
        // rowList: [20, 50, 100, 500],
        rowNum: 100000,
        rownumWidth: 40,
        multiselectWidth: "30",
        altRows: true,
        altclass: "altclasscss",
        width: 900,
        height: 330,
        onSelectRow: function (rowid, status) {
          var rowObj = $('#dzhc-rcsd-ckyw-table').getRowData(rowid)
          var index = self.selRowsCkyw.indexOf(rowid);
          if (status) {
            self.ckywChooseList.push(rowObj)
            self.selRowsCkyw.push(rowid)
          } else {
            self.ckywChooseList.splice(index, 1);
            self.selRowsCkyw.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          var idArr = rowids.map(function (item) {
            return $('#dzhc-rcsd-ckyw-table').getRowData(item)
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
          var pageNo = tools.getPageNo(pgButton, "dzhc-rcsd-ckyw-table");
          self.searchCkyw(pageNo);
        }
      })
      this.searchAddCkywData.pageSize = $(".ui-pg-selbox", $('.dzhc-rcsd .page-model-add .dzhc-rcsd-ckyw-table')).val();
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
            self.editRangeList = res.data.range && res.data.range.split(',') || [];
            self.modelData.examineNote = res.data.examineNote ? res.data.examineNote : '';
            if (isPlsd == 0) {
              let para = {
                nsrsbh: self.searchData.nsrsbh,
                entryIds: [{ ywlxCode: row.ywlxCode, entryId: row.entryId, sbrq: row.sbrq }],
                type: 'daily'
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

    showwModelEnd: function(){
      $('.model').show();
      $('.dzhc-rcsd .page-model-end').show();
      var examineResult = this.modelData.examineResult;
      this.modelData.examineResult = -1;
      this.modelData.examineResult = examineResult;
    },

    // 审单弹框隐藏
    hideModelSd: function () {
      $('.model').hide();
      $('.dzhc-rcsd .page-model-end').hide();
      this.modelData = {
        id: '',
        inspectNo: '',
        examineResult: '0',
        processType: '',
        examineNote: ''
      }
      this.editRangeList = [];
    },

    hideModelTask: function () {
      $('.model').hide();
      $('.dzhc-rcsd .page-model-add').hide();
      this.resetTask()
    },

    resetTask: function () {
      this.searchAddCkywData.ckrqq = '';
      this.searchAddCkywData.ckrqz = '';
      this.searchAddCkywData.entryId = '';
      this.resetCkywTable();
    },

    resetCkywTable: function () {
      this.ckywChooseList = []
      this.selRowsCkyw = []
      $("#dzhc-rcsd-ckyw-table").resetSelection();
      $("#dzhc-rcsd-ckyw-table")[0].addJSONData([]);
    },

    // 批量下达
    plReleaseBatch: function () {
      var self = this;
      var selRow = this.getSelRow('plXD');
      var row = selRow.row;
      var entryIds = selRow.entryIds;
      if (row.length == 0) return
      var params = {
        ids: row.join(','),
      }
      var text = '确定对' + self.rcsdInfo.nsrmc;
      text += '申报年月批次【' + self.rcsdInfo.sbnypc;
      text += '】，<br/>报关单号【' + entryIds.slice(0, 2).join('、') + '】';
      if (entryIds.length > 1) text += '等';
      text += '的任务进行下达操作吗？'
      self.rwxdDialog(text, api.dzbaDailyReleaseBatch, params);
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
      var text = '确定对' + self.rcsdInfo.nsrmc;
      text += '申报年月批次【' + self.rcsdInfo.sbnypc;
      text += '】，<br/>报关单号【' + entryIds.slice(0, 2).join('、') + '】';
      if (entryIds.length > 1) text += '等';
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
      var html = '<p class="mb-5"><span style="color: red;">*</span>原因描述:</p><textarea rows="8" cols="60" id="rcsdPlBackReason" style="width:100%"></textarea><p id="rcsdPlBackReasonTip" class="text-red" style="display:none;">原因描述不能为空</p>'
      $.dialog({
        padding: '10px 20px',
        title: "核查任务退回重报",
        content: html,
        okValue: '确定',
        lock: true,
        ok: function () {
          var val = $('#rcsdPlBackReason').val().trim()
          if (val == '') {
            $('#rcsdPlBackReasonTip').show()
            return false;
          }
          var params = {
            ids: row.join(','),
            backReason: val,
          }
          var text = '确定对' + self.rcsdInfo.nsrmc;
          text += '申报年月批次【' + self.rcsdInfo.sbnypc;
          text += '】，<br/>报关单号【' + entryIds.slice(0, 2).join('、') + '】';
          if (entryIds.length > 1) text += '等';
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
      $('#rcsdPlBackReason').val(backReason);
    },

    // 下达任务选择期限弹框
    rwxdDialog: function (text, f, params) {
      var self = this;
      var content = "<div style='padding: 10px 20px 20px 20px'><div style='padding-bottom: 10px;'><label style='display:inline-block;min-width:84px;text-align:right;'>资料报送期限：</label><input id='rcsd-deadline' type='text' data-date-start-date='1d' data-date-end-date='30d' readonly /></div><div style='padding-bottom: 10px;'><label style='display:inline-block;min-width:84px;text-align:right;'>联系电话：</label><input id='rcsd-phone' type='text' /></div><div>" + text + "</div></div>"
      $.dialog({
        title: "提示",
        padding: 0,
        content: content,
        okValue: '确定',
        lock: true,
        ok: function () {
          var phone = $('#rcsd-phone').val().trim();
          params.overdule = $('#rcsd-deadline').val();
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
        }
      })
      var startDate = tools.getNextDay(1);
      var endDate = tools.getNextDay(30);
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, startView: 2, minView: 2, startDate: startDate, endDate: endDate };
      $('#rcsd-deadline').datetimepicker(options);
      $('#rcsd-deadline').val(tools.getNextDay(15));
      if(self.lxrDhCzr) $('#rcsd-phone').val(self.lxrDhCzr);
    },

    /**
     * 根据参数获取选中行数据
     * type  'plXD'-批量下达  plDel-批量作废  plBack-批量退回  plSH-批量审核
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
            selRow.entryIds.push(tbRows[i].entryId);
          }
        }
      };
      if (type == 'plDel') {
        for (var i = 0; i < tbRows.length; i++) {
          if (tbRows[i].status != 4 && this.selRows.indexOf(String(tbRows[i].id)) > -1) {
            selRow.row.push(String(tbRows[i].id));
            selRow.entryIds.push(tbRows[i].entryId);
          }
        }
      }
      if (type == 'plBack') {
        for (var i = 0; i < tbRows.length; i++) {
          if (tbRows[i].status == 3 && this.selRows.indexOf(String(tbRows[i].id)) > -1) {
            selRow.row.push(String(tbRows[i].id));
            selRow.entryIds.push(tbRows[i].entryId);
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
    // 新增
    createTaskConfirm: function () {
      var self = this;
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
        tsjsfsChg: this.searchAddCkywData.tsjsfsChg,
      }
      if(!params.range){
        tools.info('请至少选择一种核查单证类型');
        return
      }
      api.dzbaDailyBusinessAdd(params).done(function (res) {
        if (res.code == '0') {
          self.hideModelTask();
          tools.info('添加成功');
          self.search(1);
        }
      })
    },

    nextStep: function () {
      if (this.ckywChooseList.length <= 0) {
        tools.info('请先查询并选择出口业务数据！')
        return false;
      }
      this.addIndex = 1
      var entryIds = []
      for (var i = 0; i < this.ckywChooseList.length; i++) {
        var ywlxCode = this.ckywChooseList[i].ywlxCode ? this.ckywChooseList[i].ywlxCode : ''
        var entryId = this.ckywChooseList[i].entryId;
        var sbrq = this.ckywChooseList[i].sbrq;
        var sbrq = this.ckywChooseList[i].sbrq;
        var sbrq = this.ckywChooseList[i].sbrq;
        var sbywzl = this.ckywChooseList[i].sbywzl;
        var sbnypc = this.ckywChooseList[i].sbnypc;
        entryIds.push({ 
          entryId: entryId, 
          ywlxCode: ywlxCode, 
          sbrq: sbrq,
          sbywzl: sbywzl,
          sbnypc: sbnypc,
        })
      }
      this.getTypeTreeData({ nsrsbh: this.searchData.nsrsbh, entryIds: entryIds, type: 'daily' })
    },
    // 获取核查单证类型
    getTypeTreeData: function (params) {
      var deferred = $.Deferred();
      var self = this;
      self.typeTreeData = [];
      params.tsjsfsChg = this.searchAddCkywData.tsjsfsChg;
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
          deferred.resolve();
        }
      })
      return deferred.promise()
    },

    ckywEntryidChg: function () {
      this.searchAddCkywData.entryId = this.searchAddCkywData.entryId.trim();
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
    // 状态切换
    statusChg: function(){
      this.searchData.status = '';
      this.searchData.statusMode=='1'? this.searchData.statusMode='2': this.searchData.statusMode='1';
    },
  }
})
