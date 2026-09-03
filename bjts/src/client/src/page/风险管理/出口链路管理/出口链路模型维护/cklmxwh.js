var cklmxwh = require("./cklmxwh.html");
var fxjsCommonFun = require('../../../../config/fxjsCommonFun.js');

avalon.component('cklmxwh', {
  template: cklmxwh,
  defaults: {
    act: 1,
    apiUrl: '/bjtssw/yj/wmll',
    searchParams: {
      ysfsDm: '',
      spdlDm: '',
      qycodeHyd: '',
      qycodeHg: '',
      qycodeMdg: '',
      qyzbType: 'upper', qyzbVal: '',
      bgdfsType: 'upper', bgdfsVal: '',
      mylajType: 'upper', mylajVal: '',
      qyzbSxType: 'upper', qyzbSxVal: '',
      bgdzbSxType: 'upper', bgdzbSxVal: '',
      myzbSxType: 'upper', myzbSxVal: '',
      fxdjDm: '',
      fxdjDz: ''
    },
    spdlMc: '',
    spdlList: [],
    tableData: { rows: [], page: 1, records: 0, total: 0 },
    pageSize: 20,
    pageNo: 1,
    orderSql: '',
    userLevel: '',  // 用户级别：province(省局)/city(市局)/county(区县局)
    swjgTreeData: [],  // 税务机关树形数据
    fxdjList: [],  // 链路概率等级列表
    gnqyOptions: [],  // 国内区域下拉选项（启运区域、供应商区域）
    gjQyOptions: [],  // 国际区域下拉选项（贸易区域）
    editDialog: {  // 编辑弹窗数据
      show: false,
      fxdjTz: '',
      fxdjTzYY: '',
      currentRow: null  // 当前编辑的行数据
    },

    onInit: function (e) {
      components.cklmxwh = e.vmodel;
    },
    onReady: function () {
      var self = this;
      $(window).on('resize.cklmxwh', function () { self.changeH(); });
      // 加载税务机关数据并判断用户级别
      self.loadSwjgData();
      // 加载链路概率等级列表
      self.loadFxdjList();
      // 加载区域下拉选项
      self.loadGnqyOptions();
      self.loadGjQyOptions();
      self.initSpdlTree();
      self.forceRebuildTable();
    },
    init: function () {
      // 加载税务机关数据并判断用户级别
      this.loadSwjgData();
      // 加载链路概率等级列表
      this.loadFxdjList();
      // 加载区域下拉选项
      this.loadGnqyOptions();
      this.loadGjQyOptions();
      this.initSpdlTree();
      this.forceRebuildTable();
    },
    onDispose: function () {
      $(window).off('resize.cklmxwh');
      $('.cklmxwh').off('click.spdlTree');
    },

    // 加载税务机关数据
    loadSwjgData: function() {
      var self = this;
      ajax("GET", "static/swjg.json", {}).done(function(res) {
        if (res.code == '0') {
          self.swjgTreeData = res.data;
          // 判断用户级别
          self.userLevel = self.getUserLevel();
          console.log('用户级别:', self.userLevel, 'swjgDm:', avalonRoot.user.swjgDm);
        }
      }).fail(function(err) {
        console.error('加载税务机关数据失败:', err);
      });
    },
    
    // 判断用户级别：province(省局)/city(市局)/county(区县局)
    getUserLevel: function() {
      var currentSwjgDm = avalonRoot.user.swjgDm;
      if (!currentSwjgDm || !this.swjgTreeData.length) {
        return "unknown";
      }
      
      // 遍历树形结构，查找当前税务机关所在的层级
      var treeData = this.swjgTreeData;
      
      // 第一层：省局
      for (var i = 0; i < treeData.length; i++) {
        if (treeData[i].id === currentSwjgDm) {
          return "province";  // 省局
        }
        
        // 第二层：市局
        var cityNodes = treeData[i].item || [];
        for (var j = 0; j < cityNodes.length; j++) {
          if (cityNodes[j].id === currentSwjgDm) {
            return "city";  // 市局
          }
          
          // 第三层：区县局
          var countyNodes = cityNodes[j].item || [];
          for (var k = 0; k < countyNodes.length; k++) {
            if (countyNodes[k].id === currentSwjgDm) {
              return "county";  // 区县局
            }
          }
        }
      }
      
      return "unknown";
    },
    
    // 加载链路概率等级列表
    loadFxdjList: function() {
      var self = this;
      ajax("POST", "/bjtssw/yj/fxdjsz", { pageNo: 1, pageSize: 20 }).done(function(res) {
        if (res.code == '0' && res.data && res.data.rows) {
          self.fxdjList = res.data.rows;
        }
      }).fail(function(err) {
        console.error('加载链路概率等级列表失败:', err);
      });
    },

    // 加载国内区域下拉选项（启运区域、供应商区域）
    loadGnqyOptions: function() {
      var self = this;
      ajax('POST', '/bjtssw/yj/xzqh/dic', {}).done(function (res) {
        if (res.code == '0' && res.data) {
          self.gnqyOptions = res.data;
        }
      });
    },

    // 加载国际区域下拉选项（贸易区域）
    loadGjQyOptions: function() {
      var self = this;
      ajax('POST', '/bjtssw/yj/gbcode/dic', {}).done(function (res) {
        if (res.code == '0' && res.data) {
          self.gjQyOptions = res.data;
        }
      });
    },
    
    // 打开编辑弹窗
    openEditDialog: function(rowid) {
      var self = this;
      var rowData = $("#cklmxwh-grid").jqGrid('getRowData', rowid);
      // 赋值弹窗数据
      self.editDialog = {
        show: true,
        fxdjTz: rowData.fxdjDzDm || '',  // 代入调整链路概率等级代码
        fxdjTzYY: rowData.fxdjDzYy || '',  // 代入调整原因
        currentRow: rowData
      };
      
      // 显示弹窗
      $('.model').show();
      $('.cklmxwh .cklmxwh-edit-model').show();
      
      console.log('打开弹窗 - fxdjTz:', rowData.fxdjDzDm, 'fxdjTzYY:', rowData.fxdjDzYy);
    },
    
    // 关闭编辑弹窗
    closeEditDialog: function() {
      this.editDialog = {
        show: false,
        fxdjTz: '',
        fxdjTzYY: '',
        currentRow: null
      };
      // 使用 jQuery 隐藏弹窗
      $('.model').hide();
      $('.cklmxwh .cklmxwh-edit-model').hide();
    },
    
    // 保存链路概率等级调整
    saveFxdjTz: function() {
      var self = this;
      var dialog = self.editDialog;
      
      // 验证必填字段
      if (!dialog.fxdjTz) {
        tools.info('请选择调整链路概率等级');
        return;
      }
      
      var rowData = dialog.currentRow;
      var params = {
        ysfsDm: rowData.ysfsDm,
        spdlDm: rowData.spdlDm,
        qycodeHyd: rowData.qycodeHyd,
        qycodeHg: rowData.qycodeHg,
        qycodeMdg: rowData.qycodeMdg,
        fxdjTz: dialog.fxdjTz,
        fxdjTzYY: dialog.fxdjTzYY || ''
      };
      
      ajax("POST", "/bjtssw/yj/wmll/fxdjtz", params).done(function(res) {
        if (res.code == '0') {
          tools.info('保存成功');
          self.closeEditDialog();
          // 刷新当前页数据
          self.searchInfo(self.pageNo, true);
        } else {
          tools.info(res.msg || '保存失败');
        }
      }).fail(function(err) {
        tools.info('网络异常');
      });
    },

    reset: function () {
      this.searchParams = {
        ysfsDm: '',
        spdlDm: '',
        qycodeHyd: '',
        qycodeHg: '',
        qycodeMdg: '',
        qyzbType: 'upper', qyzbVal: '',
        bgdfsType: 'upper', bgdfsVal: '',
        mylajType: 'upper', mylajVal: '',
        qyzbSxType: 'upper', qyzbSxVal: '',
        bgdzbSxType: 'upper', bgdzbSxVal: '',
        myzbSxType: 'upper', myzbSxVal: '',
        fxdjDm: '',
        fxdjDz: ''
      };
      this.spdlMc = '';
      this.spdlList = [];
      this.initSpdlTree();
    },

    initSpdlTree: function () {
      var self = this;
      var setting = {
        check: { enable: true },
        view: { selectedMulti: false },
        data: {
          simpleData: { enable: true, idKey: 'code' },
          key: { children: 'item', name: 'name' }
        },
        async: {
          enable: true,
          url: '/bjtssw/sjjc/dynamic/init/spdmtree?codes=&level=02',
          autoParam: ['id=code', 'name=name', 'children=item'],
          type: 'get',
          dataFilter: function (treeId, parentNode, responseData) {
            var data = responseData && responseData.data;
            if (!data || !data.length) return data;
            return [data[0]];
          }
        },
        callback: {
          onAsyncSuccess: function (event, treeId, treeNode, msg) {
            var treeObj = $.fn.zTree.getZTreeObj(treeId);
            if (treeObj) {
              var nodes = treeObj.transformToArray(treeObj.getNodes());
              for (var i = 0; i < nodes.length; i++) {
                if (nodes[i].isParent) {
                  treeObj.expandNode(nodes[i], true, true, false);
                }
              }
            }
          },
          onCheck: function () {
            self.treeCheckHandler();
          }
        }
      };
      $.fn.zTree.init($('#cklmxwhSpdlTree'), setting);
    },
    treeCheckHandler: function () {
      var self = this;
      var treeObj = $.fn.zTree.getZTreeObj('cklmxwhSpdlTree');
      if (!treeObj) return;
      var nodes = treeObj.getCheckedNodes(true);
      var res = fxjsCommonFun.getFootNode(nodes);
      var codes = [];
      var names = [];
      for (var i = 0; i < res.length; i++) {
        codes.push(res[i].code);
        names.push(res[i].name);
      }
      self.searchParams.spdlDm = codes.join(',');
      self.spdlList = codes;
      self.spdlMc = names.join(',');
    },
    showSpdlTree: function (e) {
      var self = this;
      $('.cklmxwh #cklmxwhSpdlTree').show();
      $('.cklmxwh').off('click.spdlTree').on('click.spdlTree', function (ev) {
        var event = ev || window.event;
        if ($('.cklmxwh #cklmxwhSpdlTree').find($(event.target)).length <= 0
          && !$(event.target).hasClass('showSelect')) {
          self.hideSpdlTree();
        }
      });
    },
    hideSpdlTree: function () {
      $('.cklmxwh #cklmxwhSpdlTree').hide();
      $('.cklmxwh').off('click.spdlTree');
    },
    showHyper: function () {
      $('.cklmxwh .select-sub').toggle();
      $('.cklmxwh .select-wrapper .icon').toggleClass('active');
      if ($('.cklmxwh .select-wrapper .icon').attr('title').slice(0, 2) === '展开') {
        $('.cklmxwh .select-wrapper .icon').attr('title', '收起查询条件');
      } else {
        $('.cklmxwh .select-wrapper .icon').attr('title', '展开查询条件');
      }
    },
    closeHyper: function () {
      $('.cklmxwh .select-sub').hide();
      $('.cklmxwh .select-wrapper .icon').removeClass('active');
      $('.cklmxwh .select-wrapper .icon').attr('title', '展开查询条件');
    },
    buildSearchParams: function () {
      var self = this;
      var sp = self.searchParams;
      var p = {};
      if (sp.ysfsDm) p.ysfsDm = sp.ysfsDm.trim();
      if (sp.spdlDm) p.spdlDm = sp.spdlDm.trim();
      if (sp.qycodeHyd) p.qycodeHyd = sp.qycodeHyd.trim();
      if (sp.qycodeHg) p.qycodeHg = sp.qycodeHg.trim();
      if (sp.qycodeMdg) p.qycodeMdg = sp.qycodeMdg.trim();
      if (sp.qyzbVal !== '' && sp.qyzbVal != null) {
        p[sp.qyzbType === 'lower' ? 'qyzbLower' : 'qyzbUpper'] = Number(sp.qyzbVal);
      }
      if (sp.bgdfsVal !== '' && sp.bgdfsVal != null) {
        p[sp.bgdfsType === 'lower' ? 'bgdfsLower' : 'bgdfsUpper'] = parseInt(sp.bgdfsVal, 10);
      }
      if (sp.mylajVal !== '' && sp.mylajVal != null) {
        p[sp.mylajType === 'lower' ? 'mylajLower' : 'mylajUpper'] = Number(sp.mylajVal);
      }
      if (sp.qyzbSxVal !== '' && sp.qyzbSxVal != null) {
        p[sp.qyzbSxType === 'lower' ? 'qyzbSxLower' : 'qyzbSxUpper'] = Number(sp.qyzbSxVal);
      }
      if (sp.bgdzbSxVal !== '' && sp.bgdzbSxVal != null) {
        p[sp.bgdzbSxType === 'lower' ? 'bgdzbSxLower' : 'bgdzbSxUpper'] = Number(sp.bgdzbSxVal);
      }
      if (sp.myzbSxVal !== '' && sp.myzbSxVal != null) {
        p[sp.myzbSxType === 'lower' ? 'myzbSxLower' : 'myzbSxUpper'] = Number(sp.myzbSxVal);
      }
      if (sp.fxdjDm) p.fxdjDm = sp.fxdjDm.trim();
      if (sp.fxdjDz) p.fxdjDz = sp.fxdjDz.trim();
      return p;
    },

    searchInfo: function (pageNo, notReBuild) {
      var self = this;
      var $root = $("#cklmxwh-grid").closest('.cklmxwh');
      var pageSize = $(".ui-pg-selbox", $root).val();
      self.pageSize = pageSize ? pageSize : 20;
      var params = self.buildSearchParams();
      params.pageNo = pageNo;
      params.pageSize = self.pageSize;
      if (self.orderSql) params.orderSql = self.orderSql;

      ajax("POST", self.apiUrl, params).done(function (res) {
        if (res.code == '0' && res.data) {
          self.tableData = {
            rows: res.data.rows || [],
            page: pageNo,
            records: res.data.count || 0,
            total: res.data.total || 0
          };
          if (!notReBuild) self.forceRebuildTable();
          else $("#cklmxwh-grid")[0].addJSONData(self.tableData);
          self.closeHyper();
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
      if ($.isFunction($("#cklmxwh-grid").jqGrid)) {
        var $root = $("#cklmxwh-grid").closest('.cklmxwh');
        var $gridContainer = $root.find('.form');
        var containerHeight = $gridContainer.height();
        var pagerHeight = $('#cklmxwh-pager').outerHeight() || 30;
        var h = 70; // 复合表头 + 边距
        var tableHeight = containerHeight - pagerHeight - h;
        if (tableHeight > 0) {
          $("#cklmxwh-grid").jqGrid('setGridHeight', tableHeight);
        }
        $("#cklmxwh-grid").jqGrid('setGridWidth', $gridContainer.width(), false);
      }
    },

    forceRebuildTable: function () {
      var self = this;
      self.orderSql = '';
      if ($("#cklmxwh-grid").hasClass("ui-jqgrid-btable")) {
        $("#cklmxwh-grid").jqGrid('GridUnload');
      }
      var $root = $("#cklmxwh-grid").closest('.cklmxwh');
      var $gridContainer = $root.find('.form');
      var containerHeight = $gridContainer.height();
      var pagerHeight = $('#cklmxwh-pager').outerHeight() || 30;
      var tableHeight = containerHeight - pagerHeight - 70;
      var colNames = [
        '代码', '名称',
        '代码', '名称',
        '代码', '名称',
        '代码', '名称',
        '代码', '名称',
        '户数', '占比',
        '笔数', '占比',
        '美元', '占比',
        '户数', '占比',
        '笔数', '占比',
        '美元', '占比',
        '综合概率指数 <span class="cklmxwh-tip" title="综合概率指数=企业占比*0.1+报关单占比*0.2+出口额占比*0.2+规模以上业务（企业占比*0.1+报关单占比*0.2+出口额占比*0.2）" style="cursor:help;font-weight:bold;">ⓘ</span>', '系统链路概率等级', '调整链路概率等级代码', '调整链路概率等级', '调整原因'
      ];
      var colModel = [
        { name: 'ysfsDm', index: 'ysfsDm', width: 80, align: 'center', sortable: false },
        { name: 'ysfsMc', index: 'ysfsMc', width: 120, align: 'left', sortable: false },
        { name: 'spdlDm', index: 'spdlDm', width: 80, align: 'center', sortable: false },
        { name: 'spdlMc', index: 'spdlMc', width: 140, align: 'left', sortable: false },
        { name: 'qycodeHyd', index: 'qycodeHyd', width: 80, align: 'center', sortable: false },
        { name: 'qynameHyd', index: 'qynameHyd', width: 100, align: 'left', sortable: false },
        { name: 'qycodeHg', index: 'qycodeHg', width: 80, align: 'center', sortable: false },
        { name: 'qynameHg', index: 'qynameHg', width: 100, align: 'left', sortable: false },
        { name: 'qycodeMdg', index: 'qycodeMdg', width: 80, align: 'center', sortable: false },
        { name: 'qynameMdg', index: 'qynameMdg', width: 100, align: 'left', sortable: false },
        { name: 'qyhsAll', index: 'qyhsAll', width: 80, align: 'right', sortable: false },
        { name: 'qyzbAll', index: 'qyzbAll', width: 80, align: 'right', sortable: false },
        { name: 'bgdfsAll', index: 'bgdfsAll', width: 80, align: 'right', sortable: false },
        { name: 'bgdzbAll', index: 'bgdzbAll', width: 80, align: 'right', sortable: false },
        { name: 'mylajAll', index: 'mylajAll', width: 120, align: 'right', sortable: false, formatter: function (cellvalue) {
          return (cellvalue || cellvalue === 0) ? avalon.filters.number(cellvalue, 2) : '';
        } },
        { name: 'myzbAll', index: 'myzbAll', width: 80, align: 'right', sortable: false },
        { name: 'qyhsSx', index: 'qyhsSx', width: 80, align: 'right', sortable: false },
        { name: 'qyzbSx', index: 'qyzbSx', width: 80, align: 'right', sortable: false },
        { name: 'bgdfsSx', index: 'bgdfsSx', width: 80, align: 'right', sortable: false },
        { name: 'bgdzbSx', index: 'bgdzbSx', width: 80, align: 'right', sortable: false },
        { name: 'mylajSx', index: 'mylajSx', width: 120, align: 'right', sortable: false, formatter: function (cellvalue) {
          return (cellvalue || cellvalue === 0) ? avalon.filters.number(cellvalue, 2) : '';
        } },
        { name: 'myzbSx', index: 'myzbSx', width: 80, align: 'right', sortable: false },
        { name: 'fxdjZhfxzs', index: 'fxdjZhfxzs', width: 120, align: 'center', sortable: false },
        { name: 'fxdjMc', index: 'fxdjMc', width: 120, align: 'center', sortable: false },
        { name: 'fxdjDzDm', index: 'fxdjDzDm', width: 0, hidden: true },  // 隐藏列：调整链路概率等级代码
        { name: 'fxdjDz', index: 'fxdjDz', width: 150, align: 'center', sortable: false, formatter: function (cellvalue, options, rowObject) {
          var userLevel = self.userLevel;
          // 省局：只读，显示文字
          if (userLevel === 'province') {
            return cellvalue || '';
          }
          // 市局和区县局：可编辑，显示文字+编辑按钮
          return (cellvalue || '') + '<span class="cklmxwh-edit-btn" data-rowid="' + options.rowId + '" title="编辑" style="cursor:pointer;margin-left:5px;">✎</span>';
        } },
        { name: 'fxdjDzYy', index: 'fxdjDzYy', width: 200, align: 'left', sortable: false }
      ];
      var groupHeaders = [
        { startColumnName: 'ysfsDm', numberOfColumns: 2, titleText: '运输方式' },
        { startColumnName: 'spdlDm', numberOfColumns: 2, titleText: '商品大类' },
        { startColumnName: 'qycodeHyd', numberOfColumns: 2, titleText: '供应商区域' },
        { startColumnName: 'qycodeHg', numberOfColumns: 2, titleText: '启运区域' },
        { startColumnName: 'qycodeMdg', numberOfColumns: 2, titleText: '贸易区域' },
        { startColumnName: 'qyhsAll', numberOfColumns: 2, titleText: '企业统计' },
        { startColumnName: 'bgdfsAll', numberOfColumns: 2, titleText: '报关单占比' },
        { startColumnName: 'mylajAll', numberOfColumns: 2, titleText: '出口额占比' },
        { startColumnName: 'qyhsSx', numberOfColumns: 2, titleText: '企业统计(规模以上)' },
        { startColumnName: 'bgdfsSx', numberOfColumns: 2, titleText: '报关单占比(规模以上)' },
        { startColumnName: 'mylajSx', numberOfColumns: 2, titleText: '出口额占比(规模以上)' }
      ];
      setTimeout(function () {
        $("#cklmxwh-grid").jqGrid({
          colNames: colNames,
          colModel: colModel,
          datatype: "local",
          gridview: true,
          viewrecords: true,
          rownumbers: true,
          pager: '#cklmxwh-pager',
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
              $("#cklmxwh-grid")[0].addJSONData(self.tableData);
            }, 0);
            self.changeH();
          },
          onPaging: function (pgButton) {
            self.pageNo = tools.getPageNo2(pgButton, "cklmxwh-pager");
            self.searchInfo(self.pageNo, true);
          },
          beforeSelectRow: function (rowid, e) {
            // 点击编辑按钮
            if ($(e.target).hasClass('cklmxwh-edit-btn')) {
              self.openEditDialog(rowid);
              return false;
            }
            // 点击单元格高亮行
            if (e.target.nodeName == "TD") {
              $(e.target).parent().addClass('ui-state-highlight').siblings().removeClass("ui-state-highlight");
              return false;
            }
            return true;
          }
        });
        $("#cklmxwh-grid").jqGrid('setGroupHeaders', {
          useColSpanStyle: true,
          groupHeaders: groupHeaders
        });
        $("#cklmxwh-grid").css({ "min-height": "1px" });
        $("#cklmxwh-grid").closest(".ui-jqgrid-view").css({
          "overflow-x": "auto",
          "overflow-y": "hidden"
        });
        $("#cklmxwh-grid").closest(".ui-jqgrid-bdiv").css("overflow-x", "auto");
      }, 200);
    }
  }
});
