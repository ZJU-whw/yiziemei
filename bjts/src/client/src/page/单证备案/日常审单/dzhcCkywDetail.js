var dzhcCkywDetail = require("./dzhcCkywDetail.html");
avalon.component('dzhcCkywDetail', {
  template: dzhcCkywDetail,
  defaults: {
    // 父组件传参
    templateName: 'page-model-edit-detail',

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
    editRangeList: [], // 编辑/查看时选中的核查单证类型
    typeTreeData: [], // 核查单证类型
    backFileTreeData: [], // 退回文件弹框数据
    rangeList: [],
    timer: null,
    detailType: 'daily',  // daily-日常审单  year-年度核查
    isEdit: false,
    hasBackList: false,
    autoH: 0,
    isWindows: true,
    onInit: function (e) {
      avalonRoot[this.templateName] = e.vmodel;
      this.rewriteAssign();
    },
    onReady: function () {
      this.isWindows = tools.isWindows();
    },

    // 适配ie浏览器 Object.assign
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
     *  1.审单核查页面 dzhcRcsd.js
     *  2.审单核查查询页面  dzhcRwcx.js
     *  3.核查项目明细页面  dzhcJcxmmx.js
     *  4.审核/复核-出口业务页面  dzhcCkyw.js
    */
    search: function (row) {
      var self = this;
      var params = {
        id: row.id
      }
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
          var params = {
            nsrsbh: self.editData.nsrsbh,
            entryIds: [{ ywlxCode: row.ywlxCode, entryId: row.entryId, sbrq: row.sbrq }],
            type: self.editData.type,
            tsjsfsChg: row.tsjsfsChg || '',
          }
          var includeFileFlag = !self.isWindows && ['3','4'].indexOf(row.status) != -1
          if (includeFileFlag) {
            params.includeFileFlag = true
            params.ranges = row.range || ''
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
              self.getTypeTreeData(params);
            })
          } else{
            self.getTypeTreeData(params);
          }

          // 查询退回记录
          self.getBackList(row);
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

    hideEdit: function () {
      $('.model').hide()
      $('.page-model-edit').hide()
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
      // 
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

    // 调用单证助手-预览文件
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
    // 从单证助手获取核查意见备注
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
    // 挂载 changeFlag
    resetDocinfo: function(docInfo){
      for(var i=0; i<docInfo.length; i++){
        docInfo[i].changeFlag = docInfo[i].changeFlag? docInfo[i].changeFlag: 'Y';
      }
    },
    // 获取退回记录列表  
    getBackList: function(row){
      var self = this;
      var params = {
        hclx: row.type == 'daily'? '1': '2',
        inspectNo: row.id,
      }
      this.hasBackList = false;
      self.autoH = 0;
      api.getBackList(params).done(function(res){
        if(res.code=='0' && res.data && res.data.length>0){
          self.hasBackList = true;
          $("#"+self.templateName + '-back-table').jqGrid('clearGridData')
          self.createBackListTable(res.data);
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
        { name: "backReason", label: "退回原因", index: "backReason", width: 600, align: "left", sortable: false },
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
        width: '1000px',
        viewrecords: true,
        shrinkToFit: true,
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: 2000,
        height: 60,
        beforeSelectRow: function (rowid, e) {
          var row = $('#'+self.templateName + '-back-table').jqGrid('getRowData', rowid);
          if ($(e.target).hasClass('op-btn')) { // 查看
            var id = row.id;
            // 打开出口业务详情
            self.showBackFile(id);
            return false
          }
        },
      })
      $("#"+self.templateName + '-back-table').resetSelection();
      $("#"+self.templateName + '-back-table')[0].addJSONData(data);
      if(data && data.length>0){
        $("#"+self.templateName + '-back-table').jqGrid('setGridHeight', 42 * data.length);
        self.autoH = 42 * data.length + 40;
      }
    },
    // 调用单证助手-预览退回文件
    showBackFile: function(id){
      var self = this;
      if (self.isWindows) {
        var params = {
          id: id
        }
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
