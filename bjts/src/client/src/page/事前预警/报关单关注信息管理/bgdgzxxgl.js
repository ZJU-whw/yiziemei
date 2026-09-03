var bgdgzxxgl = require("./bgdgzxxgl.html");
require("./bgdgzxxgl.css");
avalon.component('bgdgzxxgl', {
  template: bgdgzxxgl,
  defaults: {
    params: {},
    tabList: [
      { name: '未申报/审核中', activeName: 'wsbshz' },
      { name: '审核结束', activeName: 'shjs' }
    ],
    activeName: 'wsbshz',
    // 各 TAB 配置：对应接口、表格/分页器 id、查询条件对象、初始化标记
    tabCfg: {
      wsbshz: {
        url: '/bjtssw/yj/bgdgzxx/list/gcb',
        tableId: 'bgdgzxxgl-gcb-table',
        pagerSel: '#bgdgzxxgl-gcb-pager',
        searchKey: 'gcbSearch',
        inited: 'gcbInited'
      },
      shjs: {
        url: '/bjtssw/yj/bgdgzxx/list/jgb',
        tableId: 'bgdgzxxgl-jgb-table',
        pagerSel: '#bgdgzxxgl-jgb-pager',
        searchKey: 'jgbSearch',
        inited: 'jgbInited'
      }
    },
    gcbInited: false,
    jgbInited: false,
    gcbSearch: {
      nsrsbh: '', nsrmc: '', ckbgdh: '', czrqStart: '', czrqEnd: '',
      orderSql: '', pageSize: config.pageSize
    },
    jgbSearch: {
      nsrsbh: '', nsrmc: '', ckbgdh: '', czrqStart: '', czrqEnd: '',
      orderSql: '', pageSize: config.pageSize
    },

    // 新增/编辑 弹窗
    detailUrl: '/bjtssw/yj/bgdgzxx/detail/nsrsbh',
    addUrl: '/bjtssw/yj/bgdgzxx/add',
    updateUrl: '/bjtssw/yj/bgdgzxx/update',
    delUrl: '/bjtssw/yj/bgdgzxx/del',
    modalType: 'add',
    modalTitle: '新增报关单关注信息',
    formData: {
      djxh: '', nsrsbh: '', ckbgdh: '', nsrmc: '', ckrq: '',
      ckspdm: '', ckspmc: '', cksl: '', mylj: '', rmbj: '', cytssb: '', gzxx: ''
    },

    onInit: function (e) {
      components.bgdgzxxgl = e.vmodel;
    },
    onReady: function () {
      var self = this;
      self.initDate();
      // 默认进入「未申报/审核中」TAB，初始化对应表格（延迟以保证布局尺寸已就绪）
      setTimeout(function () { self.createTable('wsbshz'); }, 0);
    },
    // 顶部查询按钮：查询当前 TAB
    searchActive: function () {
      this.doSearch(this.activeName, 1);
    },

    initDate: function () {
      var options = { language: "zh-CN", format: "yyyy-mm-dd", autoclose: true, clearBtn: true, startView: 2, minView: 2 };
      $('.bgdgzxxgl .datepicker.date-day').datetimepicker(options);
    },
    showDatetimepicker: function (e) {
      $(e.target).datetimepicker('show');
    },
    // 展开/收起查询条件（两个 TAB 共享同一展开状态）
    showHyper: function () {
      var self = this;
      var $sub = $('.bgdgzxxgl .select-sub');
      var $icon = $('.bgdgzxxgl .select-wrapper .icon');
      var willOpen = !$icon.first().hasClass('active');
      if (willOpen) {
        $sub.show();
        $icon.addClass('active').attr('title', '收起查询条件');
      } else {
        $sub.hide();
        $icon.removeClass('active').attr('title', '展开查询条件');
      }
      // 搜索区高度变化后，重算当前表格高度
      setTimeout(function () { self.resizeTable(self.activeName); }, 0);
    },
    // 根据剩余空间重算表格高度/宽度
    resizeTable: function (tab) {
      var cfg = this.tabCfg[tab];
      if (!cfg || !this[cfg.inited]) return;
      var h = this.getTableHeight(tab);
      $('#gview_' + cfg.tableId + ' .ui-jqgrid-bdiv').height(h);
      $('#' + cfg.tableId).jqGrid('setGridParam', { height: h });
      $('#' + cfg.tableId).setGridWidth($('#' + cfg.tableId).closest('.form').width());
    },

    // 两个 TAB 共用的列定义；withOp 为 true 时追加操作列（仅 GCB 表）
    getColModel: function (withOp) {
      var numFmt = function (cv) {
        return (cv === null || cv === undefined || cv === '') ? '' : avalon.filters.number(cv, 2);
      };
      var cols = [
        { name: 'djxh', label: 'djxh', index: 'djxh', hidden: true },
        { name: 'nsrsbh', label: '企业税号', index: 'nsrsbh', width: 170, align: 'left', sortable: false },
        { name: 'nsrmc', label: '名称', index: 'nsrmc', width: 220, align: 'left', sortable: false },
        { name: 'ckbgdh', label: '报关单号', index: 'ckbgdh', width: 180, align: 'left', sortable: false },
        { name: 'ckrq', label: '出口日期', index: 'ckrq', width: 100, align: 'center', sortable: false },
        { name: 'ckspdm', label: '出口商品代码', index: 'ckspdm', width: 110, align: 'center', sortable: false },
        { name: 'ckspmc', label: '出口商品名称', index: 'ckspmc', width: 160, align: 'left', sortable: false },
        { name: 'cksl', label: '出口数量', index: 'cksl', width: 100, align: 'right', sortable: false },
        { name: 'mylj', label: '美元离岸价', index: 'mylj', width: 110, align: 'right', sortable: false, formatter: numFmt },
        { name: 'rmbj', label: '人民币离岸价', index: 'rmbj', width: 120, align: 'right', sortable: false, formatter: numFmt },
        { name: 'cytssb', label: '参与退税申报记录', index: 'cytssb', width: 130, align: 'center', sortable: false },
        { name: 'gzxx', label: '关注信息', index: 'gzxx', width: 200, align: 'left', sortable: false },
        { name: 'sfzf', label: '是否作废', index: 'sfzf', width: 80, align: 'center', sortable: false },
        { name: 'czrDm', label: '操作人', index: 'czrDm', width: 100, align: 'center', sortable: false },
        { name: 'czrq', label: '操作日期', index: 'czrq', width: 150, align: 'center', sortable: false }
      ];
      if (withOp) {
        cols.push({
          name: 'cz', label: '操作', index: 'cz', width: 110, align: 'center', sortable: false, fixed: true,
          formatter: function () {
            return "<span class='grid-op op-edit'>编辑</span> <span class='grid-op op-del'>删除</span>";
          }
        });
      }
      return cols;
    },

    getTableHeight: function (tab) {
      var cfg = this.tabCfg[tab];
      var h = 0;
      if (cfg) {
        h = $('#' + cfg.tableId).closest('.form').height();
      }
      if (!h || h < 150) {
        var tc = $('.bgdgzxxgl .tab-content').height();
        var sw = $('.bgdgzxxgl .tab-content-item:visible .select-wrapper').outerHeight() || 48;
        h = (tc && tc > 200 ? tc : 500) - sw;
      }
      // 预留表头与分页器高度
      return Math.max(h - 60, 150);
    },

    createTable: function (tab) {
      var self = this;
      var cfg = self.tabCfg[tab];
      if (!cfg) return;
      var isGcb = tab === 'wsbshz';
      $("#" + cfg.tableId).jqGrid({
        datatype: "local",
        gridview: true,
        colModel: self.getColModel(isGcb),
        viewrecords: true,
        rownumbers: true,
        pager: cfg.pagerSel,
        shrinkToFit: false,
        width: "100%",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: self.getTableHeight(tab),
        beforeSelectRow: function (rowid, e) {
          if (isGcb) {
            var row = $("#" + cfg.tableId).jqGrid("getRowData", rowid);
            if ($(e.target).hasClass("op-edit")) {
              self.showEdit(row);
              return false;
            } else if ($(e.target).hasClass("op-del")) {
              self.doDelete(row);
              return false;
            }
          }
          return true;
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, cfg.tableId);
          self.doSearch(tab, pageNo);
        }
      });
      self[cfg.inited] = true;
      self.doSearch(tab, 1);
    },

    doSearch: function (tab, pageNo) {
      var self = this;
      var cfg = self.tabCfg[tab];
      if (!cfg) return;
      var sd = self[cfg.searchKey];
      var pageSize = $(".ui-pg-selbox", $(cfg.pagerSel)).val() || config.pageSize;
      sd.pageSize = pageSize;
      var params = tools.clone(sd);
      params.pageNo = pageNo;
      params.pageSize = pageSize;
      $("#" + cfg.tableId).jqGrid('clearGridData');
      ajax("POST", cfg.url, params).done(function (res) {
        if (res.code == '0') {
          var records = (res.data && res.data.total) || 0;
          var rows = (res.data && res.data.rows) || [];
          var totalPages = pageSize > 0 ? Math.ceil(records / pageSize) : 0;
          $("#" + cfg.tableId)[0].addJSONData({
            rows: rows,
            page: pageNo,
            records: records,
            total: totalPages
          });
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      });
    },

    doReset: function (tab) {
      var self = this;
      var cfg = self.tabCfg[tab];
      if (!cfg) return;
      self[cfg.searchKey] = {
        nsrsbh: '', nsrmc: '', ckbgdh: '', czrqStart: '', czrqEnd: '',
        orderSql: '', pageSize: config.pageSize
      };
    },

    changeTab: function (activeName) {
      var self = this;
      this.activeName = activeName;
      var cfg = this.tabCfg[activeName];
      if (!cfg) return;
      // 等待 TAB 显示后再初始化/调整表格宽度，避免隐藏时尺寸为 0
      setTimeout(function () {
        if (!self[cfg.inited]) {
          self.createTable(activeName);
        } else {
          self.resizeTable(activeName);
        }
      }, 50);
    },

    // ===== 新增/编辑/删除 =====
    fillForm: function (obj) {
      var keys = ['djxh', 'nsrsbh', 'ckbgdh', 'nsrmc', 'ckrq', 'ckspdm',
        'ckspmc', 'cksl', 'mylj', 'rmbj', 'cytssb', 'gzxx'];
      for (var i = 0; i < keys.length; i++) {
        var k = keys[i];
        this.formData[k] = (obj && obj[k] != null) ? obj[k] : '';
      }
    },
    openModal: function () {
      $(".model").show();
      $(".bgdgzxxgl .bgdgzxx-model").show();
    },
    closeModal: function () {
      $(".model").hide();
      $(".bgdgzxxgl .bgdgzxx-model").hide();
    },
    showAdd: function () {
      this.modalType = 'add';
      this.modalTitle = '新增报关单关注信息';
      this.fillForm({});
      this.openModal();
    },
    showEdit: function (row) {
      this.modalType = 'edit';
      this.modalTitle = '编辑报关单关注信息';
      this.fillForm(row);
      this.openModal();
    },
    // 录入企业税号+报关单号后自动带出报关单详情
    loadDetail: function () {
      var self = this;
      var nsrsbh = $.trim(self.formData.nsrsbh);
      var ckbgdh = $.trim(self.formData.ckbgdh);
      if (!nsrsbh || !ckbgdh) return;
      ajax("POST", self.detailUrl, { nsrsbh: nsrsbh, ckbgdh: ckbgdh }).done(function (res) {
        if (res.code == '0') {
          if(res.data){
            var d = res.data;
            self.formData.djxh = d.djxh || '';
            self.formData.nsrmc = d.nsrmc || '';
            self.formData.ckrq = d.ckrq || '';
            self.formData.ckspdm = d.ckspdm || '';
            self.formData.ckspmc = d.ckspmc || '';
            self.formData.cksl = (d.cksl == null ? '' : d.cksl);
            self.formData.mylj = (d.mylj == null ? '' : d.mylj);
            self.formData.rmbj = (d.rmbj == null ? '' : d.rmbj);
            self.formData.cytssb = d.cytssb || d.cytssbjl || '';
          }else{
            tools.info('报关单信息不存在');
          }
        } else {
          tools.info(res.msg || '未查询到对应报关单信息');
        }
      }).fail(function (err) {
        tools.info(err);
      });
    },
    saveModal: function () {
      var self = this;
      var nsrsbh = $.trim(self.formData.nsrsbh);
      var ckbgdh = $.trim(self.formData.ckbgdh);
      if (!nsrsbh) { tools.info("企业税号不能为空"); return; }
      if (!ckbgdh) { tools.info("报关单号不能为空"); return; }
      if (!self.formData.djxh) {
        tools.info("请填写正确的企业税号和报关单号以带出报关单信息");
        return;
      }
      if (!$.trim(self.formData.gzxx)) { tools.info("关注信息不能为空"); return; }
      var params = {
        djxh: self.formData.djxh,
        ckbgdh: ckbgdh,
        gzxx: self.formData.gzxx
      };
      var url = self.modalType === 'edit' ? self.updateUrl : self.addUrl;
      ajax("POST", url, params).done(function (res) {
        if (res.code == '0') {
          tools.info(self.modalType === 'edit' ? "编辑成功" : "新增成功");
          self.closeModal();
          self.doSearch('wsbshz', 1);
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      });
    },
    doDelete: function (row) {
      var self = this;
      tools.confirm("是否确定删除该条数据？", "确定", function () {
        ajax("POST", self.delUrl, { djxh: row.djxh, ckbgdh: row.ckbgdh }).done(function (res) {
          if (res.code == '0') {
            tools.info("删除成功");
            self.doSearch('wsbshz', 1);
          } else {
            tools.info(res.msg);
          }
        }).fail(function (err) {
          tools.info(err);
        });
      });
    }
  }
});
