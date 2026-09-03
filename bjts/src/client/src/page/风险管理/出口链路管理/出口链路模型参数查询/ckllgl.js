var ckllgl = require("./ckllgl.html");

avalon.component('ckllgl', {
  template: ckllgl,
  defaults: {
    curKey: '',
    curMenu: {},
    // 一级菜单列表
    menuList: [
      { key: 'xzqhdzb', name: '行政区域对照表', url: '/bjtssw/yj/xzqh' },
      { key: 'hgHydqdzb', name: '海关货源地区域对照表', url: '/bjtssw/yj/hghyd' },
      { key: 'hgKaqydzb', name: '海关口岸区域对照表', url: '/bjtssw/yj/hgcode' },
      { key: 'zzmdgQydzb', name: '最终目的国区域对照表', url: '/bjtssw/yj/gbcode' },
      { key: 'cklFxdjcs', name: '出口链路概率等级参数表', url: '/bjtssw/yj/fxdjsz' },
    ],
    // 各菜单的查询条件（按需扩展）
    searchParams: {
      col1: '',
      col1Type: 'name',
      xzqh: '',
      xzqhType: 'name',
      qy: ''
    },
    // 第一个查询条件的标签（菜单间复用）
    col1Label: '',
    // 第三个查询条件的标签（国内区域/国际区域）
    qyLabel: '',
    // 当前菜单的复合表头配置（无则不设置）
    curGroupHeaders: null,
    tableData: [],
    colNames: [],
    colModel: [],
    total: 0,
    pageSize: 20,
    pageNo: 1,
    orderSql: '',
    // 国内区域下拉选项数据
    qyOptions: [],
    // 国际区域下拉选项数据
    gjqyOptions: [],

    onInit: function (e) {
      components.ckllgl = e.vmodel;
    },
    onReady: function () {
      var self = this;
      $(window).on('resize.ckllgl', function () { self.changeH(); });
      self.loadQyOptions();
      self.loadGjqyOptions();
      self.initTree();
    },
    init: function () {
      this.initTree();
    },
    onDispose: function () {
      $(window).off('resize.ckllgl');
    },

    initTree: function () {
      var self = this;
      var setting = {
        view: { showIcon: false },
        callback: {
          onClick: function (e, id, node) {
            var treeObj = $.fn.zTree.getZTreeObj('ckllglTree');
            treeObj.selectNode(node);
            self.selectMenu(node);
          }
        },
        data: { key: { name: 'name' } }
      };
      // zTree 节点数据（全部为一级叶子节点）
      var treeDataList = self.menuList.map(function (m, i) {
        return { name: '一二三四五'.charAt(i) + '、' + m.name, key: m.key, apiUrl: m.url };
      });
      $.fn.zTree.init($('#ckllglTree'), setting, treeDataList);
      var treeObj = $.fn.zTree.getZTreeObj('ckllglTree');
      var nodes = treeObj.getNodes();
      if (nodes.length > 0) {
        treeObj.selectNode(nodes[0]);
        self.selectMenu(nodes[0]);
      }
    },

    // 加载国内区域下拉选项
    loadQyOptions: function () {
      var self = this;
      ajax('POST', '/bjtssw/yj/xzqh/dic', {}).done(function (res) {
        if (res.code == '0' && res.data) {
          self.qyOptions = res.data;
        }
      });
    },

    // 加载国际区域下拉选项
    loadGjqyOptions: function () {
      var self = this;
      ajax('POST', '/bjtssw/yj/gbcode/dic', {}).done(function (res) {
        if (res.code == '0' && res.data) {
          self.gjqyOptions = res.data;
        }
      });
    },

    selectMenu: function (node) {
      var self = this;
      self.curKey = node.key;
      self.curMenu = { key: node.key, name: node.name, url: node.apiUrl };
      self.orderSql = '';
      self.pageNo = 1;
      // 重置查询条件（下拉默认名称）
      self.searchParams.col1 = '';
      self.searchParams.col1Type = 'name';
      self.searchParams.xzqh = '';
      self.searchParams.xzqhType = 'name';
      self.searchParams.qy = '';
      // 第一个查询条件的标签随菜单变化
      var labelMap = { hgHydqdzb: '货源地', hgKaqydzb: '海关口岸', zzmdgQydzb: '目的国' };
      self.col1Label = labelMap[node.key] || '';
      var qyLabelMap = { hgHydqdzb: '国内区域', hgKaqydzb: '国内区域', zzmdgQydzb: '国际区域', xzqhdzb: '国内区域' };
      self.qyLabel = qyLabelMap[node.key] || '';
      self.buildColumns(node.key);
      // 初始空数据，用户点击查询后再加载
      self.tableData = { rows: [], page: 1, records: 0, total: 0 };
      self.forceRebuildTable();
    },

    // 构建查询参数：根据下拉选择的类型（code/name）决定参数字段
    buildSearchParams: function () {
      var self = this;
      var p = {};
      var col1 = (self.searchParams.col1 || '').trim();
      var xzqh = (self.searchParams.xzqh || '').trim();
      var qy = (self.searchParams.qy || '').trim();
      var col1Type = self.searchParams.col1Type || 'name';
      var xzqhType = self.searchParams.xzqhType || 'name';
      // 字段名映射：[菜单key][查询项][类型]
      var fieldMap = {
        hgHydqdzb: {
          col1: { code: 'hghydDm', name: 'hghydMc' },
          xzqh: { code: 'xzqhDm', name: 'xzqhMc' },
          qy: 'qycode'
        },
        hgKaqydzb: {
          col1: { code: 'hgcode', name: 'hgmc' },
          xzqh: { code: 'xzqhDm', name: 'xzqhMc' },
          qy: 'qycode'
        },
        zzmdgQydzb: {
          col1: { code: 'gbCode', name: 'gbName' },
          qy: 'gjqycode'
        },
        xzqhdzb: {
          xzqh: { code: 'xzqhDm', name: 'xzqhMc' },
          qy: 'qycode'
        }
      };
      var m = fieldMap[self.curKey];
      if (!m) return p;
      if (col1 && m.col1) p[m.col1[col1Type]] = col1;
      if (xzqh && m.xzqh) p[m.xzqh[xzqhType]] = xzqh;
      if (qy && m.qy) p[m.qy] = qy;
      return p;
    },

    // 构建各菜单的列定义（占位，后续按实际接口字段补充）
    buildColumns: function (key) {
      var self = this;
      var defs = {
        hgHydqdzb: {
          colNames: ['代码', '名称', '代码', '名称', '代码', '名称'],
          colModel: [
            { name: 'hghydDm', index: 'hghydDm', width: 140, align: 'center', sortable: false },
            { name: 'hghydMc', index: 'hghydMc', width: 260, align: 'left', sortable: false },
            { name: 'xzqhDm', index: 'xzqhDm', width: 140, align: 'center', sortable: false },
            { name: 'xzqhMc', index: 'xzqhMc', width: 200, align: 'left', sortable: false },
            { name: 'qycode', index: 'qycode', width: 100, align: 'center', sortable: false },
            { name: 'qyname', index: 'qyname', width: 160, align: 'left', sortable: false }
          ],
          groupHeaders: [
            { startColumnName: 'hghydDm', numberOfColumns: 2, titleText: '海关货源地' },
            { startColumnName: 'xzqhDm', numberOfColumns: 2, titleText: '行政区划' },
            { startColumnName: 'qycode', numberOfColumns: 2, titleText: '国内区域' }
          ]
        },
        hgKaqydzb: {
          colNames: ['代码', '名称', '代码', '名称', '代码', '名称'],
          colModel: [
            { name: 'hgcode', index: 'hgcode', width: 140, align: 'center', sortable: false },
            { name: 'hgmc', index: 'hgmc', width: 260, align: 'left', sortable: false },
            { name: 'xzqhDm', index: 'xzqhDm', width: 140, align: 'center', sortable: false },
            { name: 'xzqhMc', index: 'xzqhMc', width: 200, align: 'left', sortable: false },
            { name: 'qycode', index: 'qycode', width: 100, align: 'center', sortable: false },
            { name: 'qyname', index: 'qyname', width: 160, align: 'left', sortable: false }
          ],
          groupHeaders: [
            { startColumnName: 'hgcode', numberOfColumns: 2, titleText: '海关口岸' },
            { startColumnName: 'xzqhDm', numberOfColumns: 2, titleText: '行政区划' },
            { startColumnName: 'qycode', numberOfColumns: 2, titleText: '国内区域' }
          ]
        },
        zzmdgQydzb: {
          colNames: ['代码', '名称', '代码', '名称'],
          colModel: [
            { name: 'gbCode', index: 'gbCode', width: 160, align: 'center', sortable: false },
            { name: 'gbName', index: 'gbName', width: 280, align: 'left', sortable: false },
            { name: 'gjqycode', index: 'gjqycode', width: 160, align: 'center', sortable: false },
            { name: 'gjqyname', index: 'gjqyname', width: 200, align: 'left', sortable: false }
          ],
          groupHeaders: [
            { startColumnName: 'gbCode', numberOfColumns: 2, titleText: '目的国' },
            { startColumnName: 'gjqycode', numberOfColumns: 2, titleText: '国际区域' }
          ]
        },
        xzqhdzb: {
          colNames: ['代码', '名称', '代码', '名称'],
          colModel: [
            { name: 'xzqhDm', index: 'xzqhDm', width: 160, align: 'center', sortable: false },
            { name: 'xzqhMc', index: 'xzqhMc', width: 280, align: 'left', sortable: false },
            { name: 'qycode', index: 'qycode', width: 160, align: 'center', sortable: false },
            { name: 'qyname', index: 'qyname', width: 200, align: 'left', sortable: false }
          ],
          groupHeaders: [
            { startColumnName: 'xzqhDm', numberOfColumns: 2, titleText: '行政区划' },
            { startColumnName: 'qycode', numberOfColumns: 2, titleText: '国内区域' }
          ]
        },
        cklFxdjcs: {
          colNames: ['链路概率等级', '判定标准', '处置方式', '阈值(%)'],
          colModel: [
            { name: 'fxdjMc', index: 'fxdjMc', width: 120, align: 'center', sortable: false },
            { name: 'fxdjPdbj', index: 'fxdjPdbj', width: 300, align: 'left', sortable: false },
            { name: 'fxdjCzfs', index: 'fxdjCzfs', width: 360, align: 'left', sortable: false },
            { name: 'fxdjYz', index: 'fxdjYz', width: 100, align: 'center', sortable: false }
          ]
        },
      };
      var d = defs[key] || { colNames: [], colModel: [] };
      self.colNames = d.colNames;
      self.colModel = d.colModel;
      self.curGroupHeaders = d.groupHeaders || null;
    },

    searchInfo: function (pageNo, notReBuild) {
      var self = this;
      var $root = $("#ckllgl-grid").closest('.ckllgl');
      var pageSize = $(".ui-pg-selbox", $root).val();
      self.pageSize = pageSize ? pageSize : 20;
      if (!self.curKey || !self.curMenu.url) {
        tools.info('请先选择左侧菜单!');
        return;
      }
      var params = self.buildSearchParams();
      params.pageNo = pageNo;
      params.pageSize = self.pageSize;
      if (self.orderSql) params.orderSql = self.orderSql;

      ajax("POST", self.curMenu.url, params).done(function (res) {
        if (res.code == '0' && res.data) {
          self.tableData = {
            rows: res.data.rows || [],
            page: pageNo,
            records: res.data.count || 0,
            total: res.data.total || 0
          };
          if (!notReBuild) {
            self.forceRebuildTable();
          } else {
            $("#ckllgl-grid")[0].addJSONData(self.tableData);
          }
        } else {
          self.tableData = { rows: [], page: pageNo, records: 0, total: 0 };
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg || '查询失败');
        }
      }).fail(function (err) {
        self.tableData = { rows: [], page: pageNo, records: 0, total: 0 };
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      });
    },

    changeH: function () {
      var self = this;
      if ($.isFunction($("#ckllgl-grid").jqGrid)) {
        var $root = $("#ckllgl-grid").closest('.ckllgl');
        var $gridContainer = $root.find('.grid-container');
        var containerHeight = $gridContainer.height();
        var pagerHeight = $('#ckllgl-pager').outerHeight() || 30;
        var h = 40;
        // 复合表头需要再减一行高
        if (self.curGroupHeaders && self.curGroupHeaders.length) h += 30;
        var tableHeight = containerHeight - pagerHeight - h;
        if (tableHeight > 0) {
          $("#ckllgl-grid").jqGrid('setGridHeight', tableHeight);
        }
        $("#ckllgl-grid").jqGrid('setGridWidth', $gridContainer.width(), false);
      }
    },

    forceRebuildTable: function () {
      var self = this;
      this.orderSql = '';
      if ($("#ckllgl-grid").hasClass("ui-jqgrid-btable")) {
        $("#ckllgl-grid").jqGrid('GridUnload');
      }
      var $root = $("#ckllgl-grid").closest('.ckllgl');
      var $gridContainer = $root.find('.grid-container');
      var containerHeight = $gridContainer.height();
      var pagerHeight = $('#ckllgl-pager').outerHeight() || 30;
      var tableHeight = containerHeight - pagerHeight - 55;
      setTimeout(function () {
        $("#ckllgl-grid").jqGrid({
          colNames: self.colNames,
          colModel: self.colModel,
          datatype: "local",
          gridview: true,
          viewrecords: true,
          rownumbers: true,
          pager: '#ckllgl-pager',
          shrinkToFit: false,
          width: "100%",
          autowidth: true,
          forceFit: true,
          altRows: true,
          altclass: "altclasscss",
          rownumWidth: 60,
          lastsort: 1,
          height: tableHeight > 0 ? tableHeight : 'auto',
          rowNum: self.pageSize,
          rowList: [20, 50, 100, 500],
          loadComplete: function () {
            setTimeout(function () {
              $("#ckllgl-grid")[0].addJSONData(self.tableData);
            }, 0);
            self.changeH();
          },
          onPaging: function (pgButton) {
            self.pageNo = tools.getPageNo2(pgButton, "ckllgl-pager");
            self.searchInfo(self.pageNo, true);
          }
        });
        // 设置复合表头
        if (self.curGroupHeaders && self.curGroupHeaders.length) {
          $("#ckllgl-grid").jqGrid('setGroupHeaders', {
            useColSpanStyle: true,
            groupHeaders: self.curGroupHeaders
          });
        }
        $("#ckllgl-grid").css({ "min-height": "1px" });
        $("#ckllgl-grid").closest(".ui-jqgrid-view").css({
          "overflow-x": "auto",
          "overflow-y": "hidden"
        });
        $("#ckllgl-grid").closest(".ui-jqgrid-bdiv").css("overflow-x", "auto");
      }, 200);
    }
  }
});
