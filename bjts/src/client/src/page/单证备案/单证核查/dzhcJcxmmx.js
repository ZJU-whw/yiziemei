var dzhcJcxmmx = require("./dzhcJcxmmx.html");

avalon.component('dzhcJcxmmx', {
  template: dzhcJcxmmx,
  defaults: {
    propsToPager: {
      templateName: 'page-model-edit-jcxmmx'
    },
    params: {},
    searchData: {
      id: '',
      sssq: '',
      sbpc: '',
      sbnypc: '',
      entryId: '',
      ckrqq: '',
      ckrqz: '',
      queryType: 'lx', // lx-单证核查立项，sh-单证核查审核，fh-单证核查复核
      pageSize: 20,
      pageNo: 1,
      orderSql: '',
    },
    tableData: [],
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
    selRows: [], // 选中项
    searchAddCkywData: {
      nsrsbh: '',
      sbnd: '',
      sbnypc: '',
      entryId: '',
      ckrqq: '',
      ckrqz: '',
      orderSql: "",
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
    currentSdId: -1,
    isPlsd: 1, // 审单弹框 1-批量审单，0-单笔审单
    rangeList: [], // 新增时选中的核查单证类型
    editRangeList: [], // 新增时选中的核查单证类型
    typeTreeData: [], // 核查单证类型
    pdfDetailInfo: {},
    tabIndex: 0, // 0-明细表，1-基础信息
    ckywTotal: 0,
    sbnypcList: [],
    timer: null,
    curRow: {},
    isWindows: true,

    resetSearchData: function () {
      this.searchData = {
        id: this.searchData.id,
        sssq: '',
        sbpc: '',
        sbnypc: '',
        entryId: '',
        ckrqq: '',
        ckrqz: '',
        queryType: 'lx', // lx-单证核查立项，sh-单证核查审核，fh-单证核查复核
        pageSize: 20,
        pageNo: 1,
        orderSql: '',
      }
    },
    onInit: function (e) {
      avalonRoot.dzhcJcxmmx = e.vmodel;
    },

    onReady: function () {
      this.isWindows = tools.isWindows();
      this.initParams();
      this.initDate();
      this.initHeight();
      this.createTable();
      this.createTableAddCkyw();
      this.getBaseInfo();
      this.getSbpcs();
    },

    initParams: function () {
      this.searchData.id = this.params.id;
      this.searchAddCkywData.nsrsbh = this.params.nsrsbh;
      this.searchAddCkywData.sbnd = this.params.year;
      this.searchAddCkywData.sbywzl = this.params.sbywzl;
    },

    // 初始化日期输入框
    initDate: function () {
      var self = this;
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2, endDate: new Date() };
      $('.dzhc-jcxmmx .datepicker.date-day').datetimepicker(options);
      var optionsMonth = {
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
      }
      if (this.searchAddCkywData.sbnd && this.searchAddCkywData.sbnd.length == 4) {
        optionsMonth.startDate = this.searchAddCkywData.sbnd + '-01';
        optionsMonth.endDate = this.searchAddCkywData.sbnd + '-12';
      }
      $('.dzhc-jcxmmx .datepicker.date-month').datetimepicker(optionsMonth).on('hide', function (e) {
        if (!e.target.value) self.searchData.sbpc = '';
      })
    },

    // 根据申报年月过滤申报批次
    getSbpcs: function () {
      var params = {
        qybs: this.searchAddCkywData.nsrsbh,
        sbnd: this.searchAddCkywData.sbnd,
      }
      var self = this;
      self.sbnypcList = []
      self.searchAddCkywData.sbnypc = ''
      api.dzbaDailySbnypcList(params).done(function (res) {
        if (res.code == '0') {
          self.sbnypcList = res.data || [];
          if(self.sbnypcList.length>0) self.searchAddCkywData.sbnypc = self.sbnypcList[0].sbnypc;
        }
      })
    },

    // 日期选择框多次点击会隐藏的bug修复
    showDatetimepicker: function(e){
      $(e.target).datetimepicker('show');
    },

    // 重置表格高度
    initHeight: function () {
      $(window).resize(function () {
        var h = $(".dzhc-jcxmmx .form").height();
        if (h > 100) {
          $("#dzhc-jcxmmx-table").jqGrid('setGridHeight', h - 70);
        }
      })
    },

    // 状态信息查询
    getBaseInfo: function () {
      var self = this;
      var params = {
        id: this.params.id,
      }
      api.dzbaYearProjectBaseinfo(params).done(function (res) {
        if (res.code == '0') {
          res.data.xmxh = self.searchData.id;
          self.jcxmmxInfo = res.data;
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
      this.search(1)
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
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-jcxmmx')).val() || 20;
      self.searchData.pageNo = pageNo;
      var params = tools.clone(self.searchData);
      $("#dzhc-jcxmmx-table").jqGrid('clearGridData')
      api.dzbaYearProjectBusinessList(params).done(function (res) {
        if (res.code == '0') {
          $("#dzhc-jcxmmx-table").resetSelection();
          $("#dzhc-jcxmmx-table")[0].addJSONData(res.data);
          self.tableData = res.data;
          self.selRows = [];
          tools.HeiKj('dzhc-jcxmmx', 'dzhc-jcxmmx-table')
          $('.dzhc-new .ui-state-active.loading').css('display', 'none'); // 特殊处理 隐藏“读取中...”
        }
      })
    },

    createTable: function () {
      var self = this;
      var columns = [
        {
          name: "op2", label: "操作", width: 0, frozen: true, align: "center", resizable: false, search: false, sortable: false, formatter: function (cellVal, op, row) {
            var status = row.status; // 业务状态：0-创建，1-已下达(已退回)，2-已收讫，3-已上报，4-已审核
            // 项目状态：0-创建 1-审核 2-复核 3-发放 9-结案
            var edit_title = self.params.status == 0 && status == 0 ? '编辑' : '查看';  // 项目状态为创建，且业务状态为创建时，可编辑
            var del_enable = self.params.status == 0 && status == 0;
            var back_enable = self.params.status == 1 && status == 3 && row.backCount<1;
            var back_title = row.backCount<'1' ? (status == 3 ? '退回' : '已下达'): '已退回';
            var shjs_enable = status == 3;
            var revoke_enable = status == 4;
            var h = '';
            h += "<div class='btn op-btn op-edit' title='" + edit_title + "'>" + edit_title + "</div>" // 查看
            h += "<div class='btn op-btn op-del " + (del_enable ? '' : 'op-disabled') + "' title='删除'>删除</div>" // 删除
            h += "<div class='btn op-btn op-back " + (back_enable ? '' : 'op-disabled') + " " + (status == 1 ? 'yxd' : '') + "' title='" + back_title + "'>" + back_title + "</div>" // 退回
            if (status == 4 && self.params.status == 1) {
              h += "<div class='btn op-btn op-revoke " + (revoke_enable ? '' : 'op-disabled') + "' title='审核撤销'>审核撤销</div>" // 审核撤销
            } else {
              h += "<div class='btn op-btn op-shjs " + (shjs_enable ? '' : 'op-disabled') + "' title='审核结束'>审核结束</div>" // 审核结束
            }
            return h
          }
        },
        { name: "id", label: "序号", index: "id", width: 55, align: "center", sortable: true },
        { name: "entryId", label: "报关单号", index: "entryId", width: 125, sortable: false },
        { name: "sbnypc", label: "申报年月批次", index: "sbnypc", width: 100, align: "center", sortable: true, formatter: function(cellVal, op, row){
          var res = '';
          if(row.sbrqBeforeApply=='Y'){
            res = '<span style="color: #e67e22;" title="该报关单为企业开通数字化单证备案前申报">'+cellVal+'</span>';
          } else{
            res = '<span>'+cellVal+'</span>';
          }
          return res
        } },
        { name: "sbywzl", label: "申报业务种类", index: "sbywzl", width: 110, align: "center", sortable: true },
        { name: "status", label: "状态", index: "status", hidden: true },
        { name: "statusName", label: "状态", index: "statusName", width: 55, align: "center", sortable: true },
        { name: "reportTime", label: "上报日期", index: "reportTime", width: 120, align: "center", sortable: true },
        { name: "examineTime", label: "审核日期", index: "examineTime", width: 120, align: "center", sortable: true },
        { name: "ckrq", label: "出口日期", index: "ckrq", width: 70, align: "center", sortable: true },
        { name: "range", label: "单证核查范围", index: "range", hidden: true },
        { name: "rangeName", label: "单证核查范围", index: "rangeName", width: 160, sortable: false },
        { name: "backCount", label: "退回次数", index: "backCount", hidden: true },
        { name: "backReason", label: "退回原因", index: "backReason", width: 160, sortable: false },
        { name: "ywlxCode", label: "业务类型代码", index: "ywlxCode", hidden: true },
        { name: "op", label: "操作", width: 280, align: "center", resizable: false, search: false, sortable: false }
      ];
      $("#dzhc-jcxmmx-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        viewrecords: true,
        rownumbers: true,
        pager: '#dzhc-jcxmmx-tablePager',
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
          return $(".dzhc-jcxmmx .form").height() - 70;
        })(),
        beforeSelectRow: function (rowid, e) {
          if ($(e.target).hasClass('op-disabled')) return
          var row = $('#dzhc-jcxmmx-table').jqGrid('getRowData', rowid);
          row.sbnypc = $(row.sbnypc).html();
          if ($(e.target).hasClass('op-edit')) { // 查看
            // 打开出口业务详情
            self.showCkywDetail(row);
            return false
          } else if ($(e.target).hasClass('op-del')) { // 删除
            self.delSingle(row);
          } else if ($(e.target).hasClass('op-back')) { // 退回
            self.saveBackSinglePre(row);
          } else if ($(e.target).hasClass('op-shjs')) { // 审核结束
            self.showModelSd(0, row);
          } else if ($(e.target).hasClass('op-revoke')) { // 审核撤销
            self.revokeSingle(row);
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
          var pageNo = tools.getPageNo(pgButton, "dzhc-jcxmmx-table");
          self.search(pageNo);
        },
        onSelectRow: function (rowid, status) {
          var index = self.selRows.indexOf(rowid);
          if (status) {
            if(index==-1)self.selRows.push(rowid)
          } else {
            if(index!=-1)self.selRows.splice(index, 1);
          }
        },
        onSelectAll: function (rowids, status) {
          if (status) {
            self.selRows = rowids;
          } else {
            self.selRows = [];
          }
        }
      })
      $("#dzhc-jcxmmx-table").jqGrid('setFrozenColumns');
      this.searchData.pageSize = $(".ui-pg-selbox", $('.dzhc-jcxmmx')).val();
      this.search(1)
    },

    // 单笔删除
    delSingle: function (row) {
      var self = this;
      var params = {
        id: row.id,
      }
      var text = '确定删除' + this.jcxmmxInfo.nsrmc + '在申报年月批次【' + row.sbnypc + '】报关单号【' + row.entryId + '】的业务吗？'
      tools.confirm(text, '确定', function () {
        api.dzbaYearBusinessDelSingle(params).done(function (res) {
          if (res.code == 0) {
            tools.info('删除成功');
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

    // 单笔退回 - 前置，将审核意见写入退回原因
    saveBackSinglePre: function(row){
      var self = this;
      var params = {
        backType: 'year',
        ids: row.id,
      }
      api.businessBackPre(params).done(function(res){
        var backReason = '';
        if(res.code==0 && res.data && res.data.length>0){
          for(var i=0; i<res.data.length; i++){
            var item = res.data[i];
            if(item.id==row.id && item.backReason){
              backReason = item.backReason;
            }
          }
        }
        self.saveBackSingle(row, backReason);
      })
    },

    // 单笔退回
    saveBackSingle: function (row, backReason) {
      var self = this;
      var html = '<p class="mb-5"><span style="color: red;">*</span>退回原因:</p><textarea rows="8" cols="60" id="jcxmmxPlBackReason" style="width:100%"></textarea><p id="jcxmmxPlBackReasonTip" class="text-red" style="display:none;">原因描述不能为空</p><p class="text-red" style="margin-top:10px;">说明：年度核查的每笔出口业务仅允许退回一次，请谨慎操作</p>'
      $.dialog({
        padding: '10px 20px',
        title: "核查任务退回重报",
        content: html,
        okValue: '确定',
        lock: true,
        ok: function () {
          var val = $('#jcxmmxPlBackReason').val().trim()
          if (val == '') {
            $('#jcxmmxPlBackReasonTip').show()
            return false;
          }
          var params = {
            id: row.id,
            backReason: val,
          }
          var text = '确定对' + self.jcxmmxInfo.nsrmc;
          text += '申报年月批次【' + row.sbnypc;
          text += '】报关单号【' + row.entryId;
          text += '】的业务进行退回吗？'
          tools.confirm(text, '确定', function () {
            api.dzbaYearBusinessBackSingle(params).done(function (res) {
              if (res.code == 0) {
                tools.info('退回成功');
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
      $('#jcxmmxPlBackReason').val(backReason);
    },

    showCkywDetail: function (row) {
      $('.model').show();
      $('.dzhc-jcxmmx .page-model-edit').show();
      row.type = 'year';
      if (row.status == 0) {
        row.status = this.params.status == 0 ? 0 : 1;
      }
      avalonRoot[this.propsToPager.templateName].search(row);
    },

    createTask: function () {
      if(this.params.status!= 0) return
      $('.model').show();
      $('.dzhc-jcxmmx .page-model-add').show();
      this.searchCkyw(1);
      this.addIndex = 0;
    },


    // 查询出口业务列表
    searchCkyw: function (pageNo) {
      var self = this;
      var dateValid = tools.checkDate(this.searchAddCkywData.ckrqq, this.searchAddCkywData.ckrqz)
      if (!dateValid) {
        tools.info('出口日期截止日期必须大于起始日期');
        return false;
      }
      if(!(self.searchAddCkywData.sbnypc || self.searchAddCkywData.entryId)){
        tools.info('申报年月批次和报关单号不能同时为空');
        return
      }
      this.searchAddCkywData.pageSize = $(".ui-pg-selbox", $('.dzhc-jcxmmx .page-model-add')).val() || 20;
      var params = tools.clone(self.searchAddCkywData);
      params.pageNo = pageNo
      $("#dzhc-jcxmmx-ckyw-table").jqGrid('clearGridData');
      api.dzbaAvaliableList(params).done(function (res) {
        if (res.code == '0') {
          $("#dzhc-jcxmmx-ckyw-table").resetSelection();
          $("#dzhc-jcxmmx-ckyw-table")[0].addJSONData(res.data);
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
        { name: "ywlxCode", label: "ywlxCode", index: "ywlxCode", hidden: true },
        { name: "inspectNo", label: "inspectNo", index: "inspectNo", hidden: true },
        { name: "sbywzl", label: "申报业务种类", index: "sbywzl", hidden: true },
        { name: "sbywzlName", label: "申报业务种类", index: "sbywzlName", width: 110, align: "center", sortable: false },
        { name: "sbnypc", label: "退税申报批次", index: "sbnypc", width: 100, align: "center", sortable: false },
        { name: "entryId", label: "报关单号", index: "entryId", width: 150, align: "center", sortable: false },
        { name: "ckrq", label: "出口日期", index: "ckrq", width: 90, align: "center", sortable: true },
        { name: "sbrq", label: "申报日期", index: "sbrq", width: 90, align: "center", sortable: true },
        { name: "ckfpNo", label: "出口发票", index: "ckfpNo", hidden: true },
        { name: "jhfpNo", label: "进项发票", index: "jhfpNo", hidden: true },
        {
          name: "je", label: "出口销售金额(美元)", index: "je", width: 130, align: "right", sortable: true, formatter: function (cellVal, options, rowObject) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        {
          name: "se", label: "退免税额", index: "se", width: 95, align: "right", sortable: true, formatter: function (cellVal, options, rowObject) {
            cellVal = cellVal===null || cellVal==='' ?  '': cellVal ;
            if(cellVal) cellVal = avalon.filters.number(cellVal, 2);
            return cellVal
          }
        },
        { name: "ywlxCode", label: "业务类型代码", index: "ywlxCode", hidden: true },
      ]
      $("#dzhc-jcxmmx-ckyw-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: columns,
        rownumbers: true,
        shrinkToFit: false,
        autoScroll: true,
        multiselect: true,
        viewrecords: true,
        // pager: '#dzhc-jcxmmx-ckyw-tablePager',
        // rowList: [20, 50, 100, 500],
        rowNum: 100000,
        rownumWidth: 40,
        multiselectWidth: "30",
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        width: 900,
        height: 330,
        onSortCol: function (index, iCol, sortorder) {
          self.searchAddCkywData.orderSql = index + ' ' + sortorder;
          self.searchCkyw(1);
          return;
        },
        onSelectRow: function (rowid, status) {
          var rowObj = $('#dzhc-jcxmmx-ckyw-table').getRowData(rowid)
          var index = self.selRowsCkyw.indexOf(rowid);
          if (status) {
            self.ckywChooseList.push(rowObj)
            self.selRowsCkyw.push(rowid)
          } else {
            self.ckywChooseList.splice(index,1);
            self.selRowsCkyw.splice(index,1);
          }
        },
        onSelectAll: function (rowids, status) {
          var idArr = rowids.map(function (item) {
            return $('#dzhc-jcxmmx-ckyw-table').getRowData(item)
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
          var pageNo = tools.getPageNo(pgButton, "dzhc-jcxmmx-ckyw-table");
          self.searchCkyw(pageNo);
        }
      })
      this.searchAddCkywData.pageSize = $(".ui-pg-selbox", $('.dzhc-jcxmmx .page-model-add .dzhc-jcxmmx-ckyw-table')).val();
    },

    saveModelShjs: function () {
      var self = this
      if (this.modelData.examineResult == '2' && this.modelData.inspectState == '') {
        return false
      }
      if (this.isPlsd == 1) {
      } else if (this.isPlsd == 0) {
        var params = {
          id: this.currentSdId,
          examineResult: this.modelData.examineResult,
          examineNote: this.modelData.examineNote,
        }
        api.dzbaYearBusinessExamineSingle(params).done(function (res) {
          if (res.code == '0') {
            tools.info('操作成功！')
            self.hideModel();
            self.search(self.searchData.pageNo);
          }
        })
      }
    },

    // 审单弹框显示
    showModelSd: function (isPlsd, row) {
      var self = this;
      if (isPlsd == 1) { // 批量审单时，做好前置校验
      } else if (isPlsd == 0) {
        self.currentSdId = row.id;
        self.curRow = row;
        var params = {
          id: row.id,
        }
        api.dzbaYearBusinessExamineSinglePre(params).done(function (res) {
          if (res.code == 0) {
            self.finisnData = res.data;
            self.resetPdfDetailInfo(row, res.data);
            self.editRangeList = res.data.range && res.data.range.split(',') || [];
            self.modelData.examineNote = res.data.examineNote || '';
            $('.model').show();
            $('.dzhc-jcxmmx .page-model-end').show();
            if (isPlsd == 0) {
              let para = {
                nsrsbh: self.searchAddCkywData.nsrsbh,
                entryIds: [{ ywlxCode: row.ywlxCode, entryId: row.entryId, sbrq: row.sbrq }],
                type: 'year'
              }
              var includeFileFlag = !self.isWindows && ['3','4'].indexOf(row.status) != -1
              if (includeFileFlag) {
                para.includeFileFlag = true
                para.ranges = row.range || ''
              }
              self.getTypeTreeData(para)
            };
          }
        })
      }
      this.isPlsd = isPlsd;
    },

    // 审单弹框隐藏
    hideModelSd: function () {
      $('.model').hide();
      $('.dzhc-jcxmmx .page-model-end').hide();
      this.modelData = {
        id: '',
        inspectNo: '',
        examineResult: '0',
        processType: '',
        examineNote: ''
      }
    },

    saveModelSd: function () {
      var self = this
      if (this.modelData.examineResult == '1' && this.modelData.examineNote == '') {
        return false
      }
      if (this.isPlsd == 1) {
      } else if (this.isPlsd == 0) {
        var params = {
          id: this.currentSdId,
          examineResult: this.modelData.examineResult,
          examineNote: this.modelData.examineNote,
        }
        api.dzbaYearBusinessExamineSingle(params).done(function (res) {
          if (res.code == '0') {
            tools.info('操作成功！')
            self.hideModelSd();
            self.search(self.searchData.pageNo);
          }
        })
      }
    },

    hideModelTask: function () {
      $('.model').hide();
      $('.dzhc-jcxmmx .page-model-add').hide();
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
      $("#dzhc-jcxmmx-ckyw-table").resetSelection();
      $("#dzhc-jcxmmx-ckyw-table")[0].addJSONData([]);
    },

    // 批量删除
    plDelBatch: function () {
      if(this.params.status != 0) return
      var self = this;
      var selRow = this.getSelRow('plDel');
      var row = selRow.row;
      var ids = selRow.ids;
      if (row.length == 0) {
        tools.info('请至少选择一笔可删除的业务');
        return
      }
      var params = {
        ids: ids.join(','),
      }
      var text = '确定删除';
      var len = row.length > 1 ? 2 : row.length;
      var pcs = [];
      for (var i = 0; i < len; i++) {
        pcs.push(row[i].nsrmc + '在申报年月批次' + row[i].sbnypc + '，报关单' + row[i].entryId);
      }
      text += pcs.join('，');
      if (pcs.length > 1) text += '等';
      text += '的任务吗？'
      tools.confirm(text, '确定', function () {
        api.dzbaYearBusinessDelBatch(params).done(function (res) {
          if (res.code == 0) {
            tools.info('批量删除成功');
            self.search(self.searchData.pageNo);
          }
        })
      })
    },

    /**
     * 根据参数获取选中行数据
     * type  plDel-批量删除
    */
    getSelRow: function (type) {
      var selRow = {
        row: [],
        ids: [],
      }
      if (type == 'plDel') {
        for (var i = 0; i < this.tableData.rows.length; i++) {
          if (this.tableData.rows[i].status == 0 && this.selRows.indexOf(String(this.tableData.rows[i].id)) > -1) {
            selRow.ids.push(this.tableData.rows[i].id);
            selRow.row.push(this.tableData.rows[i]);
          }
        }
      }
      return selRow
    },
    // 新增
    createTaskConfirm: function () {
      var self = this;
      var params = {
        projectId: this.params.id,
        nsrsbh: this.searchAddCkywData.nsrsbh,
        range: this.rangeList.join(','),
        inspectDatas: this.ckywChooseList
      }
      if(!params.range){
        tools.info('请至少选择一种核查单证类型');
        return
      }
      api.dzbaYearBusinessAdd(params).done(function (res) {
        if (res.code == '0') {
          self.hideModelTask()
          tools.info('操作成功');
          self.search(self.searchData.pageNo);
        }
      })
    },

    nextStep: function () {
      if (this.ckywChooseList.length <= 0) {
        tools.info('请至少选择一笔出口业务')
        return false;
      }
      var self = this;
      var entryIds = [];
      var params = {
        nsrsbh: this.jcxmmxInfo.nsrsbh,
        sbrq: '',
      }
      var sbnypc = '';
      for (var i = 0; i < this.ckywChooseList.length; i++) {
        var ywlxCode = this.ckywChooseList[i].ywlxCode ? this.ckywChooseList[i].ywlxCode : ''
        var entryId = this.ckywChooseList[i].entryId;
        var sbrq = this.ckywChooseList[i].sbrq;
        if(sbrq) {
          params.sbrq = sbrq;
          sbnypc = this.ckywChooseList[i].sbnypc;
        }
        entryIds.push({ ywlxCode: ywlxCode, entryId: entryId, sbrq: sbrq })
      }
      // 添加任务时，先判断申报日期是否在开通数字化单证备案前
      api.dzbaDailyJudge(params).done(function(res){
        if(res.code==0){
          if(res.data=='Y'){
            $.dialog({
              title: '提示',
              content: '您选择的申报批次【'+sbnypc+'】，为企业开通数字化单证备案前的申报批次，是否继续？',
              lock: true,
              okValue: '确定',
              ok: function(){
                self.getTypeTreeData({ nsrsbh: self.searchAddCkywData.nsrsbh, entryIds: entryIds, type: 'year' });
                self.addIndex = 1;
              },
              cancelValue: '取消',
              cancel: function(){},
            })
          } else{
            self.getTypeTreeData({ nsrsbh: self.searchAddCkywData.nsrsbh, entryIds: entryIds, type: 'year' });
            self.addIndex = 1;
          }
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

    dataEntryidChg: function () {
      this.searchData.entryId = this.searchData.entryId.trim();
    },

    ckywEntryidChg: function () {
      this.searchAddCkywData.entryId = this.searchAddCkywData.entryId.trim();
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
  }
})
