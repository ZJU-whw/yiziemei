var atfxydyx = require("./atfxydyx.html");

avalon.component('atfxydyx', {
  template: atfxydyx,
  defaults: {
    uuid: '',
    fxqq: '',
    fxqz: '',
    djxh: '',
    componentName: '',
    searchData: {
    },
    searchParams: {
      uuid: '',
      fxqq: '',
      fxqz: ''
    },
    curNode: {},
    tableData: [],
    yd10DetailData: [], // yd_10 明细表格数据
    colModel: [],
    colNames: [],
    fList: [],
    total: 0,
    pageSize: 20,
    pageNo: 1,
    showFilterRow: false,
    filterValues: {},
    // 树结构数据
    treeData: [],
    orderSql: '',
    // yd_1_4特殊条件
    showThresholdInput: false,
    threshold: 20,
    // yd_8特殊条件
    showYd8Inputs: false,
    deviationThreshold: 60,
    amountThreshold: 50000,
    // yd_9特殊条件
    showYd9Input: false,
    splitThreshold: 2,
    // yd_7特殊条件
    showYd7Input: false,
    fourSameThreshold: 5,
    // yd_3特殊条件
    showYd3Input: false,
    diffThreshold: 50,
    // yd_4特殊条件
    showYd4Input: false,
    yd4DiffThreshold: 50,
    // yd_6特殊条件
    showYd6Input: false,
    supplierThreshold: 3,
    // yd_13特殊条件
    showYd13Input: false,
    dayThreshold: 100,
    // yd_11特殊条件
    showYd11Input: false,
    growthThreshold: 100,
    yd11AmountThreshold: 50,
    // yd_12特殊条件
    showYd12Input: false,
    ratioThreshold: 10,
    termThreshold: 12,
    // yd_14_3特殊条件
    showYd143Input: false,
    elasticThreshold: 0.7,
    // yd_15_1特殊条件
    showYd151Input: false,
    yd151DiffThreshold: 10,
    // yd_15_3特殊条件
    showYd153Input: false,
    yd153ElasticThreshold: 0.7,
    // yd_10特殊条件
    showYd10Input: false,
    outProvinceThreshold: 50,
    onInit(e) {
      components.atfxydyx = e.vmodel;
    },
    onReady: function () {
      var self = this;
      // 初始化筛选参数
      self.searchParams.uuid = self.uuid || '';
      self.searchParams.fxqq = self.fxqq || '';
      self.searchParams.fxqz = self.fxqz || '';
      // 初始化日期选择器
      self.initSearchDatepicker();
      // 监听窗口大小变化，重新调整表格大小
      $(window).on('resize.atfxydyx', function () {
        self.changeH()
      });
    },
    init() {
      var self = this;
      // 初始化筛选参数
      console.log('uuid:', self.uuid, 'fxqq:', self.fxqq, 'fxqz:', self.fxqz)
      self.searchParams.uuid = self.uuid || '';
      self.searchParams.fxqq = self.fxqq || '';
      self.searchParams.fxqz = self.fxqz || '';
      // 初始化树结构
      self.initTree();
      // 初始化表格
      // self.initTable();
      // 初始化日期选择器
      self.initSearchDatepicker();
    },
    onDispose: function () {
      $(window).off('resize.atfxydyx');
    },
    exportList: function () {
      var self = this;
      
      // 验证分析期起止不能为空
      if (!self.searchParams.fxqq || !self.searchParams.fxqq.trim()) {
        tools.info('请选择分析期起!')
        return
      }
      if (!self.searchParams.fxqz || !self.searchParams.fxqz.trim()) {
        tools.info('请选择分析期止!')
        return
      }
      
      // yd_10 使用双表格，需要检查明细表格
      if (self.curNode.tableName === 'yd_10') {
        if ($("#atfxydyx-grid-yd10-detail").jqGrid("getRowData").length <= 0) {
          tools.info("请先查询列表");
          return;
        }
      } else if ($("#atfxydyx-grid").jqGrid("getRowData").length <= 0) {
        tools.info("请先查询列表");
        return;
      }
      
      // 根据菜单类型获取 businessType 和特殊参数
      var businessTypeMap = {
        'yd_1_1': 'cpdy',
        'yd_1_3': 'ppMultiType',
        'yd_1_4': 'zldjAbnormal',
        'yd_2': 'sensitivePort',
        'yd_3': 'weightPriceDiff',
        'yd_4': 'thirdPartyRemittance',
        'yd_5': 'doubleHeader',
        'yd_6': 'multiSupplier',
        'yd_7': 'fourSame',
        'yd_8': 'abnormalLarge',
        'yd_9': 'splitBill',
        'yd_10': 'outProvinceSupply',
        'yd_11': 'supplyRatioAbnormal',
        'yd_12': 'newSupplyHighRatio',
        'yd_13': 'exportInvoiceTimeDiff',
        'yd_14_1': 'perCapitaSales',
        'yd_14_2': 'unitEnergyConsumption',
        'yd_14_3': 'energySalesElastic',
        'yd_15_1': 'customsFeeChange',
        'yd_15_2': 'transportFeeChange',
        'yd_15_3': 'transportFeeElastic',
        'yd_16': 'sensitiveGoods',
        'yd_17': 'dailySpecialIndex'
      };
      
      var businessType = businessTypeMap[self.curNode.tableName];
      if (!businessType) {
        tools.info("该菜单暂不支持导出");
        return;
      }
      
      // 共性参数
      var params = {
        businessType: businessType,
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz
      };
      
      // 根据菜单类型添加特殊参数
      switch (self.curNode.tableName) {
        case 'yd_1_4':
          params.threshold = self.threshold / 100;
          break;
        case 'yd_3':
          params.diffThreshold = self.diffThreshold / 100;
          break;
        case 'yd_4':
          params.diffThreshold = self.yd4DiffThreshold / 100;
          break;
        case 'yd_6':
          params.supplierThreshold = self.supplierThreshold;
          break;
        case 'yd_7':
          params.fourSameThreshold = self.fourSameThreshold;
          break;
        case 'yd_8':
          params.deviationThreshold = self.deviationThreshold / 100;
          params.amountThreshold = self.amountThreshold;
          break;
        case 'yd_9':
          params.splitThreshold = self.splitThreshold;
          break;
        case 'yd_10':
          params.outProvinceThreshold = self.outProvinceThreshold / 100;
          break;
        case 'yd_11':
          params.growthThreshold = self.growthThreshold / 100;
          params.amountThreshold = self.yd11AmountThreshold * 10000;
          break;
        case 'yd_12':
          params.ratioThreshold = self.ratioThreshold / 100;
          params.termThreshold = self.termThreshold;
          break;
        case 'yd_13':
          params.dayThreshold = self.dayThreshold;
          break;
        case 'yd_14_3':
          params.elasticThreshold = self.elasticThreshold;
          break;
        case 'yd_15_1':
          params.diffThreshold = self.yd151DiffThreshold / 100;
          break;
        case 'yd_15_3':
          params.elasticThreshold = self.yd153ElasticThreshold;
          break;
      }
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/list/export");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    changeH() {
      if ($.isFunction($("#atfxydyx-grid").jqGrid)) {
        var containerHeight = $('.atfxydyx .grid-container').height();
        var pagerHeight = $('#atfxydyx-pager').outerHeight() || 30;
        let h = this.showFilterRow ? 70 : 40;
        // 复合表头表格需要多减去40
        var groupHeaderTables = ['yd_14_1', 'yd_14_3', 'yd_15_1', 'yd_15_3'];
        if (this.curNode && groupHeaderTables.includes(this.curNode.tableName)) {
          h += 30;
        }
        var tableHeight = containerHeight - pagerHeight - h;

        if (tableHeight > 0) {
          $("#atfxydyx-grid").jqGrid('setGridHeight', tableHeight);
        }
        // 始终设置网格宽度以确保水平滚动
        $("#atfxydyx-grid").jqGrid('setGridWidth', $('.atfxydyx .grid-container').width(), false);
        // 确保容器有正确的滚动样式
        $("#atfxydyx-grid").closest(".ui-jqgrid-view").css("overflow-x", "auto");
        $("#atfxydyx-grid").closest(".ui-jqgrid-bdiv").css("overflow-x", "auto");
      }
    },
    initTree: function () {
      var self = this;
      var setting = {
        view: {
          showIcon: false,
        },
        callback: {
          onClick: function (e, id, node) {
            var treeObj = $.fn.zTree.getZTreeObj('atfxydyxTree');
            // 如果是父节点，只展开/折叠
            if (node.isParent) {
              treeObj.expandNode(node);
              return;
            }
            // 如果是叶子节点，选中它并取消其他节点的选中状态
            treeObj.selectNode(node);
            // 更新选中的节点信息
            self.updateSelectedNode(node);
            return;
          }
        },
        data: { 
          key: { 
            children: "items", 
            name: "name" 
          } 
        }
      };
      
      // 硬编码的树形数据
      var treeDataList = [
        {
          name: "一、商品规格型号信息异常",
          isParent: true,
          open: false,
          items: [
            { name: "(一) 产品电压与目的国电压不匹配", tableName: "yd_1_1", fieldList: [] },
            // { name: "(二) 疑似贵金属进出口", tableName: "yd_1_2", fieldList: [] },
            { name: "(二) 同一品牌有两种以上的品牌类型", tableName: "yd_1_3", fieldList: [] },
            { name: "(三) 相同商品规格型号一致，重量单价异常", tableName: "yd_1_4", fieldList: [] }
          ]
        },
        {
          name: "二、敏感口岸",
          tableName: "yd_2",
          fieldList: []
        },
        {
          name: "三、重量单价与全省平均单价差异",
          tableName: "yd_3",
          fieldList: []
        },
        {
          name: "四、第三方收汇",
          tableName: "yd_4",
          fieldList: []
        },
        {
          name: "五、双抬头报关",
          tableName: "yd_5",
          fieldList: []
        },
        {
          name: "六、同一个报关单项号匹配多个供应商（外贸）",
          tableName: "yd_6",
          fieldList: []
        },
        {
          name: "七、四同（商品、出口日期、离境口岸、贸易国）报关单超过阈值",
          tableName: "yd_7",
          fieldList: []
        },
        {
          name: "八、异常大额报关单",
          tableName: "yd_8",
          fieldList: []
        },
        {
          name: "九、同一提单分单报关",
          tableName: "yd_9",
          fieldList: []
        },
        {
          name: "十、省外企业供货比例偏高（外贸）",
          tableName: "yd_10",
          fieldList: []
        },
        {
          name: "十一、供货企业供货比例异常增大（外贸）",
          tableName: "yd_11",
          fieldList: []
        },
        {
          name: "十二、供货企业成立时间短且供货比例高（外贸）",
          tableName: "yd_12",
          fieldList: []
        },
        {
          name: "十三、出口时间与进货发票时间相差较大（外贸）",
          tableName: "yd_13",
          fieldList: []
        },
        {
          name: "十四、销售增长与人员、能耗变化",
          isParent: true,
          open: false,
          items: [
            { name: "(一) 人均销售收入变动情况分析", tableName: "yd_14_1", fieldList: [] },
            { name: "(二) 单位能耗变动情况分析（生产）", tableName: "yd_14_2", fieldList: [] },
            { name: "(三) 能耗与销售变动的弹性系数（生产）", tableName: "yd_14_3", fieldList: [] }
          ]
        },
        {
          name: "十五、销售增长与报关费、运输费变化",
          isParent: true,
          open: false,
          items: [
            { name: "(一) 报关费用变动情况分析", tableName: "yd_15_1", fieldList: [] },
            { name: "(二) 运输费用变动情况分析", tableName: "yd_15_2", fieldList: [] },
            { name: "(三) 运输费用变动弹性系数", tableName: "yd_15_3", fieldList: [] }
          ]
        },
        {
          name: "十六、出口敏感商品",
          tableName: "yd_16",
          fieldList: []
        },
        {
          name: "十七、触发日常专项指标情况",
          tableName: "yd_17",
          fieldList: []
        }
      ];
      
      $.fn.zTree.init($("#atfxydyxTree"), setting, treeDataList);
      var treeObj = $.fn.zTree.getZTreeObj('atfxydyxTree');
      var nodes = treeObj.getNodes();
      if (nodes.length > 0) {
        treeObj.expandNode(nodes[0], true, false, false);
        // 自动选中第一个叶子节点
        var firstLeafNode = self.findFirstLeafNode(nodes[0]);
        if (firstLeafNode) {
          treeObj.selectNode(firstLeafNode);
          self.updateSelectedNode(firstLeafNode);
        }
      }
    },
    // 查找第一个叶子节点
    findFirstLeafNode: function(node) {
      if (!node.isParent) {
        return node;
      }
      if (node.items && node.items.length > 0) {
        return this.findFirstLeafNode(node.items[0]);
      }
      return null;
    },
    updateSelectedNode: function (selectedNode) {
      var self = this;
      self.filterValues = {}
      self.colNames = [];
      self.colModel = [];
      self.orderSql = ''; // 重置排序条件
      this.curNode = selectedNode
      
      // 先重置所有特殊条件输入框为隐藏
      self.showThresholdInput = false;
      self.showYd8Inputs = false;
      self.showYd9Input = false;
      self.showYd7Input = false;
      self.showYd3Input = false;
      self.showYd4Input = false;
      self.showYd6Input = false;
      self.showYd13Input = false;
      self.showYd11Input = false;
      self.showYd12Input = false;
      self.showYd143Input = false;
      self.showYd151Input = false;
      self.showYd153Input = false;
      self.showYd10Input = false;
      
      // 根据选中的菜单显示对应的特殊条件输入框
      if (selectedNode.tableName === 'yd_1_4') {
        self.showThresholdInput = true;
        self.threshold = 20; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_8') {
        self.showYd8Inputs = true;
        self.deviationThreshold = 60; // 重置为默认值
        self.amountThreshold = 50000; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_9') {
        self.showYd9Input = true;
        self.splitThreshold = 2; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_7') {
        self.showYd7Input = true;
        self.fourSameThreshold = 5; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_3') {
        self.showYd3Input = true;
        self.diffThreshold = 50; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_4') {
        self.showYd4Input = true;
        self.yd4DiffThreshold = 50; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_6') {
        self.showYd6Input = true;
        self.supplierThreshold = 3; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_13') {
        self.showYd13Input = true;
        self.dayThreshold = 100; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_11') {
        self.showYd11Input = true;
        self.growthThreshold = 100; // 重置为默认值
        self.yd11AmountThreshold = 50; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_12') {
        self.showYd12Input = true;
        self.ratioThreshold = 10; // 重置为默认值
        self.termThreshold = 12; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_14_3') {
        self.showYd143Input = true;
        self.elasticThreshold = 0.7; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_15_1') {
        self.showYd151Input = true;
        self.yd151DiffThreshold = 10; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_15_3') {
        self.showYd153Input = true;
        self.yd153ElasticThreshold = 0.7; // 重置为默认值
      } else if (selectedNode.tableName === 'yd_10') {
        self.showYd10Input = true;
        self.outProvinceThreshold = 50; // 重置为默认值
      }
      
      // 只处理叶子节点
      if (!selectedNode.isParent) {
        // 根据不同的tableName获取不同的字段列表
        self.getFieldListByTableName(selectedNode.tableName);
      }
    },
    getFieldListByTableName: function(tableName) {
      var self = this;
      
      // 根据tableName构建固定列
      switch(tableName) {
        case 'yd_1_1':
          self.buildFixedColumnsForYd11();
          break;
        case 'yd_1_2':
          // TODO: 疑似贵金属进出口
          self.buildFixedColumnsForYd12();
          break;
        case 'yd_1_3':
          // 同一品牌有两种以上的品牌类型
          self.buildFixedColumnsForYd1_3();
          break;
        case 'yd_1_4':
          // 规格型号、名称一致、单位重量异常
          self.buildFixedColumnsForYd14();
          break;
        case 'yd_2':
          // 敏感口岸
          self.buildFixedColumnsForYd2();
          break;
        case 'yd_3':
          // 重量单价
          self.buildFixedColumnsForYd3();
          break;
        case 'yd_4':
          // 第三方收汇
          self.buildFixedColumnsForYd4();
          break;
        case 'yd_5':
          // 双抬头报关
          self.buildFixedColumnsForYd5();
          break;
        case 'yd_6':
          // 同一个报关单项号匹配3个以上供应商（外贸）
          self.buildFixedColumnsForYd6();
          break;
        case 'yd_7':
          // 四同出口出现5次以上报关单
          self.buildFixedColumnsForYd7();
          break;
        case 'yd_8':
          // 异常大额报关单
          self.buildFixedColumnsForYd8();
          break;
        case 'yd_9':
          // 同一提单分单报关
          self.buildFixedColumnsForYd9();
          break;
        case 'yd_10':
          // TODO: 省外企业供货比例偏高（外贸）
          self.buildFixedColumnsForYd10();
          break;
        case 'yd_11':
          // TODO: 供货企业供货比例异常增大（外贸）
          self.buildFixedColumnsForYd11Biz();
          break;
        case 'yd_12':
          // TODO: 供货企业成立时间短且供货比例高（外贸）
          self.buildFixedColumnsForYd12();
          break;
        case 'yd_13':
          // 出口时间与进货发票时间相差较大（外贸）
          self.buildFixedColumnsForYd13();
          break;
        case 'yd_14_1':
          // 人均销售收入变动情况分析
          self.buildFixedColumnsForYd141();
          break;
        case 'yd_14_2':
          // TODO: 单位能耗变动情况分析（生产）
          self.buildFixedColumnsForYd142();
          break;
        case 'yd_14_3':
          // TODO: 能耗与销售变动的弹性系数
          self.buildFixedColumnsForYd143();
          break;
        case 'yd_15_1':
          // TODO: 报关费用变动情况分析
          self.buildFixedColumnsForYd151();
          break;
        case 'yd_15_2':
          // 运输费用变动情况分析
          self.buildFixedColumnsForYd152();
          break;
        case 'yd_15_3':
          // 运输费用变动弹性系数
          self.buildFixedColumnsForYd153();
          break;
        case 'yd_16':
          // 出口敏感商品
          self.buildFixedColumnsForYd16();
          break;
        case 'yd_17':
          // 触发日常专项指标情况
          self.buildFixedColumnsForYd17();
          break;
        default:
          tools.info('未配置该菜单的字段定义');
          break;
      }
    },
    formatAmount(amount, maxFractionDigits = 8) {
      if (amount === null || amount === undefined || isNaN(Number(amount))) {
        return "-";
      }
      const num = Number(amount);
      const options = {
        useGrouping: true,
        minimumFractionDigits: 2,
        maximumFractionDigits: maxFractionDigits,
      };
      return num.toLocaleString("zh-CN", options);
    },
    searchInfo(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20
      let selParamList = []
      
      // 验证分析期起止不能为空
      if (!self.searchParams.fxqq || !self.searchParams.fxqq.trim()) {
        tools.info('请选择分析期起!')
        return
      }
      if (!self.searchParams.fxqz || !self.searchParams.fxqz.trim()) {
        tools.info('请选择分析期止!')
        return
      }
      
      if (!self.curNode.tableName) {
        tools.info('请选择数据表!')
        return
      }
      
      // 特殊处理：各菜单使用专用接口
      if (self.curNode.tableName === 'yd_1_1') {
        self.searchYd1_1(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_1_3') {
        self.searchYd1_3(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_1_4') {
        self.searchYd14(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_5') {
        self.searchYd5(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_8') {
        self.searchYd8(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_9') {
        self.searchYd9(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_7') {
        self.searchYd7(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_2') {
        self.searchYd2(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_3') {
        self.searchYd3(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_4') {
        self.searchYd4(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_6') {
        self.searchYd6(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_13') {
        self.searchYd13(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_11') {
        self.searchYd11(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_12') {
        self.searchYd12(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_15_2') {
        self.searchYd152(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_14_1') {
        self.searchYd141(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_14_2') {
        self.searchYd142(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_14_3') {
        self.searchYd143(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_15_1') {
        self.searchYd151(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_15_3') {
        self.searchYd153(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_10') {
        self.searchYd10(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_16') {
        self.searchYd16(pageNo, notReBuild);
        return;
      }
      if (self.curNode.tableName === 'yd_17') {
        self.searchYd17(pageNo, notReBuild);
        return;
      }
      
      let params = {
        tableName: self.curNode.tableName,
        djxh: self.djxh,
        uuid: self.searchParams.uuid,
        fxqq: self.searchParams.fxqq,
        fxqz: self.searchParams.fxqz
      }
      for (var key in self.filterValues) {
        selParamList.push({
          selKey: key,
          selValue: self.filterValues[key]
        })
      }
      params.selParamList = selParamList
      params.orderSql = this.orderSql
      params.pageNo = pageNo
      params.pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      ajax("POST", "/cxfw/atfx/suspicious/data", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    forceRebuildTable: function () {
      this.orderSql = ''
      var self = this;
      if ($("#atfxydyx-grid").hasClass("ui-jqgrid-btable")) {
        $("#atfxydyx-grid").jqGrid('GridUnload');
      }
      var containerHeight = $('.atfxydyx .grid-container').height();
      var pagerHeight = $('#atfxydyx-pager').outerHeight() || 30;
      var tableHeight = containerHeight - pagerHeight - 55;
      setTimeout(function () {
        $("#atfxydyx-grid").jqGrid({
          colNames: self.colNames,
          colModel: self.colModel,
          datatype: "local",
          gridview: true,
          viewrecords: true,
          rownumbers: true,
          pager: '#atfxydyx-pager',
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
              $("#atfxydyx-grid")[0].addJSONData(self.tableData)
            }, 0);
            self.changeH()

          },
          onSortCol: function (index, iCol, sortorder) {
            var orderSql = index + " " + sortorder;
            self.orderSql = orderSql;
            self.searchInfo(1, true);
            return;
          },
          onPaging: function (pgButton) {
            self.pageNo = tools.getPageNo2(pgButton, "atfxydyx-pager");
            self.searchInfo(self.pageNo, true);
          }
        });
        $("#atfxydyx-grid").css({
          "min-height": "1px"
        });
        $("#atfxydyx-grid").closest(".atfxydyx .ui-jqgrid-view").css({
          "overflow-x": "auto",
          "overflow-y": "hidden"
        });
        $("#atfxydyx-grid").closest(".atfxydyx .ui-jqgrid-bdiv").css("overflow-x", "auto");
      }, 200);
    },
    initTable: function () {
      var self = this;
      if ($("#atfxydyx-grid").hasClass("ui-jqgrid")) {
        $("#atfxydyx-grid").jqGrid('GridUnload');
      }
      self.renderTable();
    },
    renderTable: function () {
      var self = this;
      if ($("#atfxydyx-grid").hasClass("ui-jqgrid")) {
        $("#atfxydyx-grid").jqGrid('GridUnload');
      }
      var containerHeight = $('.atfxydyx .grid-container').height();
      var pagerHeight = $('#atfxydyx-pager').outerHeight() || 30;
      var tableHeight = containerHeight - pagerHeight - 55;
      $("#atfxydyx-grid").jqGrid({
        colNames: self.colNames,
        colModel: self.colModel,
        datatype: "local",
        gridview: true,
        viewrecords: true,
        rownumbers: true,
        pager: '#atfxydyx-pager',
        shrinkToFit: true,
        width: "100%",
        autowidth: true,
        forceFit: true,
        rownumWidth: 60,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        height: tableHeight > 0 ? tableHeight : 'auto',
        rowNum: self.pageSize,
        rowList: [20, 50, 100, 500],
        loadComplete: function () {
        //   if (self.showFilterRow) {
        //     setTimeout(function () {
        //       if (self.showFilterRow && $("#filter-row-ydyx").length === 0) {
        //         self.addCustomFilterRow();
        //       }
        //     }, 0);
        //   }
          setTimeout(function () {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          }, 0);
        },
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo2(pgButton, "atfxydyx-pager");
          self.searchInfo(pageNo, true);
        }
      });
    },
    initDatepicker() {
      setTimeout(() => {
        var options = { 
          language: "zh-CN", 
          format: "yyyy-mm-dd", 
          autoclose: true, 
          clearBtn: true, 
          startView: 2, 
          minView: 2, 
          endDate: new Date() 
        };
        $('.atfxydyx .datepicker').datetimepicker(options);
      }, 100)
    },
    initSearchDatepicker() {
      setTimeout(() => {
        var options = { 
          language: "zh-CN", 
          format: "yyyy-mm-dd", 
          autoclose: true, 
          clearBtn: false, // 禁用清空按钮
          startView: 2, 
          minView: 2, 
          endDate: new Date() 
        };
        $('.atfxydyx .date-fxqq').datetimepicker(options);
        $('.atfxydyx .date-fxqz').datetimepicker(options);
      }, 100)
    },
    removeCustomFilterRow: function () {
      $("#filter-row-ydyx").remove();
    },
    debounce: function (func, wait) {
      let timeout;
      return function executedFunction(...args) {
        const later = () => {
          clearTimeout(timeout);
          func.apply(this, args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
      };
    },
    getAlign(e, dataType) {
      if (e == '1' || e == '3') {
        return 'right'
      } else if (e == '2') {
        return 'center'
      } else {
        if (dataType == '3') {
          return 'center'
        } else {
          return 'left'
        }
      }
    },
    // 产品电压与目的国电压不匹配 - 构建固定列
    buildFixedColumnsForYd11: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      var columns = [
        { fieldName: 'ckbgdh', fieldCname: '出口报关单号', width: 175, align: 'center' },
        { fieldName: 'ckspDm', fieldCname: '商品代码', width: 100, align: 'center' },
        { fieldName: 'gfhhgspmc', fieldCname: '规范化海关商品名称', width: 200, align: 'left' },
        { fieldName: 'ggxh', fieldCname: '规格型号', width: 150, align: 'left' },
        { fieldName: 'ggxhDy', fieldCname: '产品电压信息', width: 120, align: 'center' },
        { fieldName: 'gjhdqmc', fieldCname: '出口目的国', width: 120, align: 'center' },
        { fieldName: 'mydy', fieldCname: '出口目的国民用电压', width: 150, align: 'center' },
        { fieldName: 'gydy', fieldCname: '出口目的国工业电压', width: 150, align: 'center' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        self.colModel.push({
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false,
          align: col.align,
          width: col.width
        });
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 产品电压与目的国电压不匹配 - 查询数据
    searchYd1_1: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      ajax("POST", "/cxfw/atfx/ydfx/cpdy/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 产品电压与目的国电压不匹配 - 导出
    exportYd1_1: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/atfx/ydfx/cpdy/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 同一品牌有两种以上的品牌类型 - 构建固定列
    buildFixedColumnsForYd1_3: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要启用排序的字段：出口报关单号、品牌、品牌类型
      var sortableFields = ['ckbgdh', 'ggxhPp', 'pplx'];
      
      var columns = [
        { fieldName: 'ckbgdh', fieldCname: '出口报关单号', width: 175, align: 'center' },
        { fieldName: 'ckspDm', fieldCname: '商品代码', width: 100, align: 'center' },
        { fieldName: 'gfhhgspmc', fieldCname: '规范化海关商品名称', width: 200, align: 'left' },
        { fieldName: 'ggxh', fieldCname: '规格型号', width: 150, align: 'left' },
        { fieldName: 'ggxhPp', fieldCname: '品牌', width: 120, align: 'center' },
        { fieldName: 'pplx', fieldCname: '品牌类型', width: 150, align: 'center' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        self.colModel.push({
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: sortableFields.includes(col.fieldName), // 仅特定列可排序
          align: col.align,
          width: col.width
        });
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 同一品牌有两种以上的品牌类型 - 查询数据
    searchYd1_3: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/ppMultiType/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 同一品牌有两种以上的品牌类型 - 导出
    exportYd1_3: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/ppMultiType/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 规格型号、名称一致、单位重量异常 - 构建固定列
    buildFixedColumnsForYd14: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要启用排序的字段：商品代码、名称、规格型号、重量单价
      var sortableFields = ['ckspDm', 'gfhhgspmc', 'ggxh', 'zldjBgd'];
      
      var columns = [
        { fieldName: 'ckbgdh', fieldCname: '出口报关单号', width: 175, align: 'center' },
        { fieldName: 'ckspDm', fieldCname: '商品代码', width: 100, align: 'center' },
        { fieldName: 'gfhhgspmc', fieldCname: '规范化海关商品名称', width: 200, align: 'left' },
        { fieldName: 'ggxh', fieldCname: '规格型号', width: 150, align: 'left' },
        { fieldName: 'zldjBgd', fieldCname: '重量单价', width: 120, align: 'right' },
        { fieldName: 'zldjPj', fieldCname: '同商品同规格型号平均重量单价', width: 200, align: 'right' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        self.colModel.push({
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: sortableFields.includes(col.fieldName),
          align: col.align,
          width: col.width
        });
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 规格型号、名称一致、单位重量异常 - 查询数据
    searchYd14: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        threshold: self.threshold / 100, // 将百分比转换为小数
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/zldjAbnormal/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 规格型号、名称一致、单位重量异常 - 导出
    exportYd14: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        threshold: self.threshold / 100 // 将百分比转换为小数
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/zldjAbnormal/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 双抬头报关 - 构建固定列
    buildFixedColumnsForYd5: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要金额格式化的字段
      var amountFields = ['mylaj'];
      
      var columns = [
        { fieldName: 'ckbgdh', fieldCname: '出口报关单号', width: 175, align: 'center' },
        { fieldName: 'ckspDm', fieldCname: '商品代码', width: 100, align: 'center' },
        { fieldName: 'gfhhgspmc', fieldCname: '规范化海关商品名称', width: 200, align: 'left' },
        { fieldName: 'mylaj', fieldCname: '美元离岸价', width: 120, align: 'right' },
        { fieldName: 'jydwmc', fieldCname: '经营单位名称', width: 180, align: 'left' },
        { fieldName: 'hzdwmc', fieldCname: '货主单位名称', width: 180, align: 'left' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false,
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 双抬头报关 - 查询数据
    searchYd5: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      ajax("POST", "/cxfw/atfx/ydfx/doubleHeader/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 双抬头报关 - 导出
    exportYd5: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/doubleHeader/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 异常大额报关单 - 构建固定列
    buildFixedColumnsForYd8: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要启用排序的字段：出口日期、报关单号
      var sortableFields = ['ckrq1', 'ckbgdh'];
      // 需要金额格式化的字段
      var amountFields = ['mylajPj', 'mylaj18', 'mylaj'];
      
      var columns = [
        { fieldName: 'mylajPj', fieldCname: '报关平均美元值', width: 120, align: 'right' },
        { fieldName: 'mylaj18', fieldCname: '本报关单美元值', width: 120, align: 'right' },
        { fieldName: 'ckrq1', fieldCname: '出口日期', width: 100, align: 'center' },
        { fieldName: 'ckbgdh', fieldCname: '出口报关单号', width: 175, align: 'center' },
        { fieldName: 'ckspDm', fieldCname: '出口商品', width: 100, align: 'center' },
        { fieldName: 'gfhhgspmc', fieldCname: '规范化海关商品名称', width: 200, align: 'left' },
        { fieldName: 'mylaj', fieldCname: '美元离岸价', width: 120, align: 'right' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: sortableFields.includes(col.fieldName),
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 异常大额报关单 - 查询数据
    searchYd8: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        deviationThreshold: self.deviationThreshold / 100, // 将百分比转换为小数
        amountThreshold: self.amountThreshold, // 金额阈值，直接传数字
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/abnormalLarge/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 异常大额报关单 - 导出
    exportYd8: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        deviationThreshold: self.deviationThreshold / 100, // 将百分比转换为小数
        amountThreshold: self.amountThreshold // 金额阈值，直接传数字
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/abnormalLarge/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 同一提单分单报关 - 构建固定列
    buildFixedColumnsForYd9: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要启用排序的字段：提单号、出口日期、报关单
      var sortableFields = ['tydh', 'ckrq1', 'ckbgdh'];
      // 需要金额格式化的字段
      var amountFields = ['mylaj'];
      
      var columns = [
        { fieldName: 'ckrq1', fieldCname: '出口日期', width: 100, align: 'center' },
        { fieldName: 'ckbgdh', fieldCname: '出口报关单', width: 175, align: 'center' },
        { fieldName: 'ckspDm', fieldCname: '商品代码', width: 100, align: 'center' },
        { fieldName: 'gfhhgspmc', fieldCname: '规范化海关商品名称', width: 200, align: 'left' },
        { fieldName: 'mylaj', fieldCname: '美元离岸价', width: 120, align: 'right' },
        { fieldName: 'hggqkaDm', fieldCname: '离境口岸', width: 100, align: 'center' },
        { fieldName: 'hgmc', fieldCname: '口岸名称', width: 150, align: 'left' },
        { fieldName: 'mygdqszDm', fieldCname: '贸易国', width: 100, align: 'center' },
        { fieldName: 'gbName', fieldCname: '国家名称', width: 120, align: 'left' },
        { fieldName: 'ckhth', fieldCname: '合同号', width: 150, align: 'center' },
        { fieldName: 'tydh', fieldCname: '提单号', width: 150, align: 'center' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: sortableFields.includes(col.fieldName),
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 同一提单分单报关 - 查询数据
    searchYd9: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        splitThreshold: self.splitThreshold, // 分单报关阈值
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/splitBill/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 同一提单分单报关 - 导出
    exportYd9: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        splitThreshold: self.splitThreshold // 分单报关阈值
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/splitBill/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 四同出口出现5次以上报关单 - 构建固定列
    buildFixedColumnsForYd7: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要启用排序的字段
      var sortableFields = ['ckrq1', 'ckspDm', 'hggqkaDm', 'mygdqszDm', 'ckbgdh'];
      // 需要金额格式化的字段
      var amountFields = ['mylaj'];
      
      var columns = [
        { fieldName: 'ckrq1', fieldCname: '出口日期', width: 100, align: 'center' },
        { fieldName: 'ckspDm', fieldCname: '商品代码', width: 100, align: 'center' },
        { fieldName: 'gfhhgspmc', fieldCname: '规范化海关商品名称', width: 200, align: 'left' },
        { fieldName: 'hggqkaDm', fieldCname: '离境口岸', width: 100, align: 'center' },
        { fieldName: 'hgmc', fieldCname: '口岸名称', width: 150, align: 'left' },
        { fieldName: 'mygdqszDm', fieldCname: '贸易国', width: 100, align: 'center' },
        { fieldName: 'gbName', fieldCname: '国家名称', width: 120, align: 'left' },
        { fieldName: 'ckbgdh', fieldCname: '出口报关单', width: 175, align: 'center' },
        { fieldName: 'mylaj', fieldCname: '美元离岸价', width: 120, align: 'right' },
        { fieldName: 'jwshr', fieldCname: '境外客户', width: 180, align: 'left' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: sortableFields.includes(col.fieldName), // 仅特定列可排序
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 四同出口出现5次以上报关单 - 查询数据
    searchYd7: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        fourSameThreshold: self.fourSameThreshold, // 四同报关单数量阈值
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/fourSame/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 四同出口出现5次以上报关单 - 导出
    exportYd7: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        fourSameThreshold: self.fourSameThreshold // 四同报关单数量阈值
      };
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/fourSame/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 敏感口岸 - 构建固定列
    buildFixedColumnsForYd2: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 将当前组件实例挂载到全局，供 onclick 调用
      window.atfxydyxComponent = self;
      
      // 需要启用排序的字段：口岸代码、口岸名称
      var sortableFields = ['hggqkaDm', 'hgmc'];
      // 需要金额格式化的字段
      var amountFields = ['mylaj'];
      
      var columns = [
        { fieldName: 'hggqkaDm', fieldCname: '口岸代码', width: 100, align: 'center' },
        { fieldName: 'hgmc', fieldCname: '口岸名称', width: 150, align: 'left', isLink: true },
        { fieldName: 'mylaj', fieldCname: '出口额(USD)', width: 120, align: 'right' },
        { fieldName: 'ckezb', fieldCname: '出口额占比(%)', width: 100, align: 'right' },
        { fieldName: 'sbdwsl', fieldCname: '申报单位数量', width: 100, align: 'center' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: sortableFields.includes(col.fieldName),
          align: col.align,
          width: col.width
        };
        
        // 口岸名称列添加超链接格式化，使用 onclick 直接调用全局函数
        if (col.isLink) {
          colConfig.formatter = function(cellValue, options, rowObject) {
            var hggqkaDm = rowObject.hggqkaDm || '';
            return '<a href="javascript:void(0);" onclick="window.atfxydyxComponent.goToDataQueryWithPort(\'' + hggqkaDm + '\');return false;" style="color: #337ab7; text-decoration: underline; cursor: pointer;">' + (cellValue || '') + '</a>';
          };
        }
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
    },
    // 跳转到数据查询tab并带上口岸参数
    goToDataQueryWithPort: function(portCode) {
      var self = this;
      // 获取当前的出口日期筛选条件
      var dateStart = self.searchParams.fxqq || '';
      var dateEnd = self.searchParams.fxqz || '';
      
      // 切换到数据查询tab
      if (components.atfxmx) {
        components.atfxmx.activeName = 'atfxSjcx';
      }
      
      // 等待tab切换完成后设置筛选条件
      setTimeout(function() {
        if (components.atfxzycx) {
          // 获取树对象
          var treeObj = $.fn.zTree.getZTreeObj('atfxzycxTree');
          if (treeObj) {
            // 先展开父节点 1_CK
            var parentNode = treeObj.getNodeByParam('tableName', '1_CK');
            if (parentNode) {
              treeObj.expandNode(parentNode, true, false, false);
            }
            // 查找出口单证信息表节点（tableName 为 ATFX_CK_YS_CKDZXX）
            var node = treeObj.getNodeByParam('tableName', 'ATFX_CK_YS_CKDZXX');
            if (node) {
              treeObj.selectNode(node);
              // 先清空筛选条件
              components.atfxzycx.filterValues = {};
              components.atfxzycx.updateSelectedNode(node);
              
              // 设置筛选条件
              setTimeout(function() {
                // 设置口岸代码筛选条件
                components.atfxzycx.filterValues['HGGQKA_DM'] = portCode;
                // 设置出口日期筛选条件（两个时间用逗号拼接）
                if (dateStart || dateEnd) {
                  components.atfxzycx.filterValues['CKRQ_1'] = (dateStart || '') + ',' + (dateEnd || '');
                }
                // 触发查询
                components.atfxzycx.searchInfo(1);
              }, 300);
            }
          }
          components.atfxzycx.changeH();
        }
      }, 300);
    },
    // 跳转到数据查询tab并带上商品代码参数
    goToDataQueryWithProduct: function(productCode) {
      var self = this;
      // 获取当前的出口日期筛选条件
      var dateStart = self.searchParams.fxqq || '';
      var dateEnd = self.searchParams.fxqz || '';
      
      // 切换到数据查询tab
      if (components.atfxmx) {
        components.atfxmx.activeName = 'atfxSjcx';
      }
      
      // 等待tab切换完成后设置筛选条件
      setTimeout(function() {
        if (components.atfxzycx) {
          // 获取树对象
          var treeObj = $.fn.zTree.getZTreeObj('atfxzycxTree');
          if (treeObj) {
            // 先展开父节点 1_CK
            var parentNode = treeObj.getNodeByParam('tableName', '1_CK');
            if (parentNode) {
              treeObj.expandNode(parentNode, true, false, false);
            }
            // 查找出口单证信息表节点（tableName 为 ATFX_CK_YS_CKDZXX）
            var node = treeObj.getNodeByParam('tableName', 'ATFX_CK_YS_CKDZXX');
            if (node) {
              treeObj.selectNode(node);
              // 先清空筛选条件
              components.atfxzycx.filterValues = {};
              components.atfxzycx.updateSelectedNode(node);
              
              // 设置筛选条件
              setTimeout(function() {
                // 设置商品代码筛选条件
                components.atfxzycx.filterValues['CKSP_DM'] = productCode;
                // 设置出口日期筛选条件（两个时间用逗号拼接）
                if (dateStart || dateEnd) {
                  components.atfxzycx.filterValues['CKRQ_1'] = (dateStart || '') + ',' + (dateEnd || '');
                }
                // 触发查询
                components.atfxzycx.searchInfo(1);
              }, 300);
            }
          }
          components.atfxzycx.changeH();
        }
      }, 300);
    },
    // 跳转到数据查询tab并带上贸易国代码参数（出口单证信息）
    goToDataQueryWithTradeCountry: function(tradeCountryCode) {
      var self = this;
      var dateStart = self.searchParams.fxqq || '';
      var dateEnd = self.searchParams.fxqz || '';
      
      // 切换到数据查询tab
      if (components.atfxmx) {
        components.atfxmx.activeName = 'atfxSjcx';
      }
      
      setTimeout(function() {
        if (components.atfxzycx) {
          var treeObj = $.fn.zTree.getZTreeObj('atfxzycxTree');
          if (treeObj) {
            var parentNode = treeObj.getNodeByParam('tableName', '1_CK');
            if (parentNode) {
              treeObj.expandNode(parentNode, true, false, false);
            }
            var node = treeObj.getNodeByParam('tableName', 'ATFX_CK_YS_CKDZXX');
            if (node) {
              treeObj.selectNode(node);
              // 先清空筛选条件
              components.atfxzycx.filterValues = {};
              components.atfxzycx.updateSelectedNode(node);
              
              setTimeout(function() {
                // 设置贸易国代码筛选条件
                components.atfxzycx.filterValues['MYGDQSZ_DM'] = tradeCountryCode;
                // 设置出口日期筛选条件
                if (dateStart || dateEnd) {
                  components.atfxzycx.filterValues['CKRQ_1'] = (dateStart || '') + ',' + (dateEnd || '');
                }
                components.atfxzycx.searchInfo(1);
              }, 300);
            }
          }
          components.atfxzycx.changeH();
        }
      }, 300);
    },
    // 跳转到数据查询tab并带上付汇国代码参数（收汇信息）
    goToDataQueryWithRemitCountry: function(remitCountryCode) {
      var self = this;
      var dateStart = self.searchParams.fxqq || '';
      var dateEnd = self.searchParams.fxqz || '';
      
      // 切换到数据查询tab
      if (components.atfxmx) {
        components.atfxmx.activeName = 'atfxSjcx';
      }
      
      setTimeout(function() {
        if (components.atfxzycx) {
          var treeObj = $.fn.zTree.getZTreeObj('atfxzycxTree');
          if (treeObj) {
            var parentNode = treeObj.getNodeByParam('tableName', '1_CK');
            if (parentNode) {
              treeObj.expandNode(parentNode, true, false, false);
            }
            var node = treeObj.getNodeByParam('tableName', 'ATFX_SH_YS_CKSHXX');
            if (node) {
              treeObj.selectNode(node);
              // 先清空筛选条件
              components.atfxzycx.filterValues = {};
              components.atfxzycx.updateSelectedNode(node);
              
              setTimeout(function() {
                // 设置付汇国代码筛选条件
                components.atfxzycx.filterValues['HGGJHDQSZ_DM'] = remitCountryCode;
                // 设置收汇日期筛选条件
                if (dateStart || dateEnd) {
                  components.atfxzycx.filterValues['CKSHRQ'] = (dateStart || '') + ',' + (dateEnd || '');
                }
                components.atfxzycx.searchInfo(1);
              }, 300);
            }
          }
          components.atfxzycx.changeH();
        }
      }, 300);
    },
    // 敏感口岸 - 查询数据
    searchYd2: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/sensitivePort/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 敏感口岸 - 导出
    exportYd2: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz
      };
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/sensitivePort/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 重量单价 - 构建固定列
    buildFixedColumnsForYd3: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 将当前组件实例挂载到全局，供 onclick 调用
      window.atfxydyxComponent = self;
      
      // 商品代码和商品名称列需要启用排序
      var sortableFields = ['ckspDm', 'gfhhgspmc'];
      // 需要金额格式化的字段
      var amountFields = ['bqyJzqks', 'qsMylaj', 'bqyPj', 'qsZldj'];
      
      var columns = [
        { fieldName: 'ckspDm', fieldCname: '商品代码', width: 100, align: 'center' },
        { fieldName: 'gfhhgspmc', fieldCname: '商品名称', width: 200, align: 'left', isLink: true },
        { fieldName: 'bqyJzqks', fieldCname: '出口数量(kg)', width: 120, align: 'right' },
        { fieldName: 'qsMylaj', fieldCname: '美元离岸价', width: 120, align: 'right' },
        { fieldName: 'bqyPj', fieldCname: '平均单价(美元/kg)', width: 120, align: 'right' },
        { fieldName: 'qsZldj', fieldCname: '全省平均单价(美元/kg)', width: 150, align: 'right' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: sortableFields.includes(col.fieldName),
          align: col.align,
          width: col.width
        };
        
        // 商品名称列添加超链接格式化，点击跳转到数据查询
        if (col.isLink) {
          colConfig.formatter = function(cellValue, options, rowObject) {
            var ckspDm = rowObject.ckspDm || '';
            return '<a href="javascript:void(0);" onclick="window.atfxydyxComponent.goToDataQueryWithProduct(\'' + ckspDm + '\');return false;" style="color: #337ab7; text-decoration: underline; cursor: pointer;">' + (cellValue || '') + '</a>';
          };
        }
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 重量单价 - 查询数据
    searchYd3: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        diffThreshold: self.diffThreshold / 100, // 将百分比转换为小数
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/weightPriceDiff/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 重量单价 - 导出
    exportYd3: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        diffThreshold: self.diffThreshold / 100 // 将百分比转换为小数
      };
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/weightPriceDiff/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 第三方收汇 - 构建固定列
    buildFixedColumnsForYd4: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 将当前组件实例挂载到全局，供 onclick 调用
      window.atfxydyxComponent = self;
      
      // 需要金额格式化的字段
      var amountFields = ['ckMylaj', 'shMyje'];
      
      // 所有列都禁用排序
      var columns = [
        { fieldName: 'mygdqszDm', fieldCname: '出口国别', width: 120, align: 'center' },
        { fieldName: 'ckgb', fieldCname: '贸易国', width: 150, align: 'left', linkType: 'trade' },
        { fieldName: 'ckMylaj', fieldCname: '美元离岸价', width: 120, align: 'right' },
        { fieldName: 'hggjhdqszDm', fieldCname: '付汇国别', width: 120, align: 'right' },
        { fieldName: 'shgb', fieldCname: '付汇国', width: 120, align: 'right', linkType: 'remit' },
        { fieldName: 'shMyje', fieldCname: '美元收汇金额', width: 120, align: 'right' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false,
          align: col.align,
          width: col.width
        };
        
        // 贸易国列添加超链接，点击跳转到出口单证信息
        if (col.linkType === 'trade') {
          colConfig.formatter = function(cellValue, options, rowObject) {
            var mygdqszDm = rowObject.mygdqszDm || '';
            return '<a href="javascript:void(0);" onclick="window.atfxydyxComponent.goToDataQueryWithTradeCountry(\'' + mygdqszDm + '\');return false;" style="color: #337ab7; text-decoration: underline; cursor: pointer;">' + (cellValue || '') + '</a>';
          };
        }
        
        // 付汇国列添加超链接，点击跳转到收汇信息
        if (col.linkType === 'remit') {
          colConfig.formatter = function(cellValue, options, rowObject) {
            var hggjhdqszDm = rowObject.hggjhdqszDm || '';
            return '<a href="javascript:void(0);" onclick="window.atfxydyxComponent.goToDataQueryWithRemitCountry(\'' + hggjhdqszDm + '\');return false;" style="color: #337ab7; text-decoration: underline; cursor: pointer;">' + (cellValue || '') + '</a>';
          };
        }
        
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 第三方收汇 - 查询数据
    searchYd4: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        diffThreshold: self.yd4DiffThreshold / 100, // 将百分比转换为小数
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      ajax("POST", "/cxfw/atfx/ydfx/thirdPartyRemittance/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 第三方收汇 - 导出
    exportYd4: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        diffThreshold: self.yd4DiffThreshold / 100 // 将百分比转换为小数
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/thirdPartyRemittance/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 同一个报关单项号匹配3个以上供应商（外贸） - 构建固定列
    buildFixedColumnsForYd6: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要启用排序的字段：出口日期、报关单号、供货方税号
      var sortableFields = ['ckrq1', 'ckbgdh', 'ghfnsrsbh1'];
      // 需要金额格式化的字段
      var amountFields = ['mylaj', 'jsje', 'dj'];
      
      var columns = [
        { fieldName: 'ckbgdh', fieldCname: '出口报关单号', width: 175, align: 'center' },
        { fieldName: 'ckrq1', fieldCname: '出口日期', width: 100, align: 'center' },
        { fieldName: 'ckspDm', fieldCname: '商品代码', width: 100, align: 'left' },
        { fieldName: 'sbhgspmc', fieldCname: '规范化海关商品名称', width: 200, align: 'left' },
        { fieldName: 'mylaj', fieldCname: '美元离岸价', width: 120, align: 'right' },
        { fieldName: 'ghfnsrsbh1', fieldCname: '供货企业识别号', width: 150, align: 'left' },
        { fieldName: 'gysmc', fieldCname: '供货企业名称', width: 180, align: 'left' },
        { fieldName: 'kprq', fieldCname: '开票日期', width: 100, align: 'center' },
        { fieldName: 'jsje', fieldCname: '计税金额', width: 120, align: 'right' },
        { fieldName: 'sl', fieldCname: '数量', width: 80, align: 'right' },
        { fieldName: 'hgjldwmc', fieldCname: '单位', width: 60, align: 'center' },
        { fieldName: 'dj', fieldCname: '单价', width: 120, align: 'right' },
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: sortableFields.includes(col.fieldName),
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 同一个报关单项号匹配3个以上供应商（外贸） - 查询数据
    searchYd6: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        supplierThreshold: self.supplierThreshold, // 供应商个数阈值
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      // 如果有排序条件，添加到参数中
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/multiSupplier/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 同一个报关单项号匹配3个以上供应商（外贸） - 导出
    exportYd6: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        supplierThreshold: self.supplierThreshold // 供应商个数阈值
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/multiSupplier/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 出口时间与进货发票时间相差较大 - 构建固定列
    buildFixedColumnsForYd13: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要金额格式化的字段
      var amountFields = ['jsje', 'tse', 'rmblaj', 'mylaj'];
      
      // 所有列都禁用排序
      var columns = [
        { fieldName: 'glh', fieldCname: '关联号', width: 140, align: 'center' },
        { fieldName: 'ckbgdh', fieldCname: '出口报关单号', width: 175, align: 'center' },
        { fieldName: 'ckrq1', fieldCname: '出口日期', width: 100, align: 'center' },
        { fieldName: 'jhpzh', fieldCname: '进货凭证号', width: 175, align: 'center' },
        { fieldName: 'kprq', fieldCname: '供方开票时间', width: 100, align: 'center' },
        { fieldName: 'jsje', fieldCname: '供货不含税金额', width: 120, align: 'right' },
        { fieldName: 'tse', fieldCname: '退税额', width: 120, align: 'right' },
        { fieldName: 'kpzhts', fieldCname: '开票滞后天数', width: 100, align: 'center' },
        { fieldName: 'ckspDm', fieldCname: '商品代码', width: 100, align: 'center' },
        { fieldName: 'gfhhgspmc', fieldCname: '海关商品名称', width: 180, align: 'left' },
        { fieldName: 'ggxh', fieldCname: '规格型号', width: 150, align: 'left' },
        { fieldName: 'rmblaj', fieldCname: '人民币离岸价', width: 120, align: 'right' },
        { fieldName: 'mylaj', fieldCname: '美元离岸价', width: 120, align: 'right' },
        { fieldName: 'sbjldwDm', fieldCname: '申报计量单位代码', width: 130, align: 'center' },
        { fieldName: 'sbsl1', fieldCname: '申报数量', width: 80, align: 'right' },
        { fieldName: 'dyjldwDm', fieldCname: '第一计量单位代码', width: 130, align: 'center' },
        { fieldName: 'cksl', fieldCname: '出口数量', width: 80, align: 'right' },
        { fieldName: 'dejldwDm', fieldCname: '第二计量单位代码', width: 130, align: 'center' },
        { fieldName: 'decksl', fieldCname: '第二出口数量', width: 100, align: 'right' },
        { fieldName: 'jydwmc', fieldCname: '经营单位名称', width: 180, align: 'left' },
        { fieldName: 'ysfsDm', fieldCname: '运输方式', width: 80, align: 'center' },
        { fieldName: 'tydh', fieldCname: '提运单号', width: 150, align: 'center' },
        { fieldName: 'hgcjfsDm', fieldCname: '海关成交方式', width: 100, align: 'center' },
        { fieldName: 'mygdqszDm', fieldCname: '贸易国别', width: 80, align: 'center' },
        { fieldName: 'zzmdgdqszDm', fieldCname: '最终目的国', width: 80, align: 'center' },
        { fieldName: 'ghfnsrsbh1', fieldCname: '供货方识别号', width: 150, align: 'left' },
        { fieldName: 'gysmc', fieldCname: '供货方名称', width: 200, align: 'left' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false, // 禁用排序
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 出口时间与进货发票时间相差较大 - 查询数据
    searchYd13: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        dayThreshold: self.dayThreshold, // 时间差阈值（天）
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      ajax("POST", "/cxfw/atfx/ydfx/exportInvoiceTimeDiff/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 出口时间与进货发票时间相差较大 - 导出
    exportYd13: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        dayThreshold: self.dayThreshold // 时间差阈值（天）
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/exportInvoiceTimeDiff/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 供货企业供货比例异常增大 - 构建固定列
    buildFixedColumnsForYd11Biz: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 将当前组件实例挂载到全局，供 onclick 调用
      window.atfxydyxComponent = self;
      
      // 按照开票月份、供应商税号排序
      var sortableFields = ['byue', 'ghfnsrsbh1'];
      // 需要金额格式化的字段
      var amountFields = ['jsje', 'jsjeSyue', 'jsjeHbzz'];
      
      // 需要添加超链接的金额字段
      var linkAmountFields = ['jsje', 'jsjeSyue'];
      
      var columns = [
        { fieldName: 'ghfnsrsbh1', fieldCname: '供应商税号', width: 175, align: 'left' },
        { fieldName: 'gysmc', fieldCname: '供应商名称', width: 200, align: 'left' },
        { fieldName: 'mc', fieldCname: '供应商省份', width: 100, align: 'center' },
        { fieldName: 'gysDjRq', fieldCname: '开业日期', width: 100, align: 'center' },
        { fieldName: 'byue', fieldCname: '开票月份', width: 80, align: 'center' },
        { fieldName: 'jsje', fieldCname: '本月开票金额', width: 120, align: 'right' },
        { fieldName: 'jsjeSyue', fieldCname: '上月开票金额', width: 120, align: 'right' },
        { fieldName: 'jsjeHbzz', fieldCname: '开票增加额', width: 120, align: 'right' },
        { fieldName: 'jsjeHb', fieldCname: '环比增长', width: 100, align: 'right' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: sortableFields.includes(col.fieldName),
          align: col.align,
          width: col.width
        };
        
        // 本月开票金额和上月开票金额列添加超链接，点击跳转到数据查询
        if (linkAmountFields.includes(col.fieldName)) {
          (function(fieldName) {
            colConfig.formatter = function(cellValue, options, rowObject) {
              if (cellValue === undefined || cellValue === null || cellValue === '') return '';
              var ghfnsrsbh1 = rowObject.ghfnsrsbh1 || '';
              var byue = rowObject.byue || '';
              // 上月开票金额需要计算上月的月份
              var targetByue = byue;
              if (fieldName === 'jsjeSyue' && byue && byue.length === 6) {
                var year = parseInt(byue.substring(0, 4), 10);
                var month = parseInt(byue.substring(4, 6), 10);
                month = month - 1;
                if (month === 0) {
                  month = 12;
                  year = year - 1;
                }
                targetByue = year + (month < 10 ? '0' + month : '' + month);
              }
              var formattedValue = self.formatAmount(cellValue, 2);
              return '<a href="javascript:void(0);" onclick="window.atfxydyxComponent.goToDataQueryWithYd11(\'' + ghfnsrsbh1 + '\', \'' + targetByue + '\');return false;" style="color: #337ab7; text-decoration: underline; cursor: pointer;">' + formattedValue + '</a>';
            };
          })(col.fieldName);
        }
        // 其他金额字段格式化（不带超链接）
        else if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 供货企业供货比例异常增大 - 跳转到数据查询tab（进货明细申报表）
    goToDataQueryWithYd11: function(ghfnsrsbh1, byue) {
      var self = this;
      // 获取共性条件的日期
      var dateStart = self.searchParams.fxqq || '';
      var dateEnd = self.searchParams.fxqz || '';
      
      // 将byue（如"202512"）转换为月初到月底日期（如"2025-12-01,2025-12-31"）
      var kprqDateRange = '';
      if (byue && byue.length === 6) {
        var year = byue.substring(0, 4);
        var month = byue.substring(4, 6);
        var monthInt = parseInt(month, 10);
        // 计算该月最后一天
        var lastDay = new Date(parseInt(year), monthInt, 0).getDate();
        var startDate = year + '-' + month + '-01';
        var endDate = year + '-' + month + '-' + (lastDay < 10 ? '0' + lastDay : lastDay);
        kprqDateRange = startDate + ',' + endDate;
      }
      
      // 切换到数据查询tab
      if (components.atfxmx) {
        components.atfxmx.activeName = 'atfxSjcx';
      }
      
      // 等待tab切换完成后设置筛选条件
      setTimeout(function() {
        if (components.atfxzycx) {
          var treeObj = $.fn.zTree.getZTreeObj('atfxzycxTree');
          if (treeObj) {
            // 先展开父节点 3_TSBL
            var parentNode = treeObj.getNodeByParam('tableName', '3_TSBL');
            if (parentNode) {
              treeObj.expandNode(parentNode, true, false, false);
            }
            // 查找进货明细申报表节点（tableName 为 ATFX_TS_YS_JHMXSBB）
            var node = treeObj.getNodeByParam('tableName', 'ATFX_TS_YS_JHMXSBB');
            if (node) {
              treeObj.selectNode(node);
              // 先清空筛选条件
              components.atfxzycx.filterValues = {};
              components.atfxzycx.updateSelectedNode(node);
              
              // 设置筛选条件
              setTimeout(function() {
                // 设置供货方纳税人识别号筛选条件
                components.atfxzycx.filterValues['GHFNSRSBH_1'] = ghfnsrsbh1;
                // 设置共性条件日期（用逗号拼接传入CKRQ_1）
                if (dateStart || dateEnd) {
                  components.atfxzycx.filterValues['CKRQ_1'] = (dateStart || '') + ',' + (dateEnd || '');
                }
                // 设置开票日期筛选条件（月初到月底）
                if (kprqDateRange) {
                  components.atfxzycx.filterValues['KPRQ'] = kprqDateRange;
                }
                // 触发查询
                components.atfxzycx.searchInfo(1);
              }, 300);
            }
          }
          components.atfxzycx.changeH();
        }
      }, 300);
    },
    // 供货企业供货比例异常增大 - 查询数据
    searchYd11: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        growthThreshold: self.growthThreshold / 100, // 将百分比转换为小数
        amountThreshold: self.yd11AmountThreshold * 10000, // 将万元转换为元
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      // 添加排序条件
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/supplyRatioAbnormal/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 供货企业供货比例异常增大 - 导出
    exportYd11: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        growthThreshold: self.growthThreshold / 100, // 将百分比转换为小数
        amountThreshold: self.yd11AmountThreshold * 10000 // 将万元转换为元
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/supplyRatioAbnormal/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 供货企业成立时间短且供货比例高 - 构建固定列
    buildFixedColumnsForYd12: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 将当前组件实例挂载到全局，供 onclick 调用
      window.atfxydyxComponent = self;
      
      // 需要金额格式化的字段
      var amountFields = ['jsje', 'jsjeHj'];
      // 需要添加超链接的金额字段
      var linkAmountFields = ['jsje', 'jsjeHj'];
      
      // 所有列都禁用排序
      var columns = [
        { fieldName: 'ghfnsrsbh1', fieldCname: '供应商税号', width: 175, align: 'left' },
        { fieldName: 'gysmc', fieldCname: '供应商名称', width: 200, align: 'left' },
        { fieldName: 'mc', fieldCname: '供应商省份', width: 100, align: 'center' },
        { fieldName: 'gysDjRq', fieldCname: '开业日期', width: 100, align: 'center' },
        { fieldName: 'gysSckprq', fieldCname: '最早开票日期', width: 100, align: 'center' },
        { fieldName: 'jsje', fieldCname: '开票金额', width: 120, align: 'right', sortable: true },
        { fieldName: 'jsjeHj', fieldCname: '当月总进货金额', width: 120, align: 'right' },
        { fieldName: 'zb', fieldCname: '占比(%)', width: 80, align: 'right' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: col.sortable || false, // 根据列定义决定是否启用排序
          align: col.align,
          width: col.width
        };
        // 开票金额和当月总进货金额列添加超链接
        if (linkAmountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            var ghfnsrsbh1 = row.ghfnsrsbh1 || '';
            var formattedValue = self.formatAmount(cellVal, 2);
            return '<a href="javascript:void(0);" onclick="window.atfxydyxComponent.goToDataQueryWithYd12(\'' + ghfnsrsbh1 + '\');return false;" style="color: #337ab7; text-decoration: underline; cursor: pointer;">' + formattedValue + '</a>';
          };
        }
        // 其他金额字段格式化（不带超链接）
        else if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 供货企业成立时间短且供货比例高 - 跳转到数据查询tab（进货明细申报表）
    goToDataQueryWithYd12: function(ghfnsrsbh1) {
      var self = this;
      // 获取共性条件的日期
      var dateStart = self.searchParams.fxqq || '';
      var dateEnd = self.searchParams.fxqz || '';
      
      // 切换到数据查询tab
      if (components.atfxmx) {
        components.atfxmx.activeName = 'atfxSjcx';
      }
      
      // 等待tab切换完成后设置筛选条件
      setTimeout(function() {
        if (components.atfxzycx) {
          var treeObj = $.fn.zTree.getZTreeObj('atfxzycxTree');
          if (treeObj) {
            // 先展开父节点 3_TSBL
            var parentNode = treeObj.getNodeByParam('tableName', '3_TSBL');
            if (parentNode) {
              treeObj.expandNode(parentNode, true, false, false);
            }
            // 查找进货明细申报表节点（tableName 为 ATFX_TS_YS_JHMXSBB）
            var node = treeObj.getNodeByParam('tableName', 'ATFX_TS_YS_JHMXSBB');
            if (node) {
              treeObj.selectNode(node);
              // 先清空筛选条件
              components.atfxzycx.filterValues = {};
              components.atfxzycx.updateSelectedNode(node);
              
              // 设置筛选条件
              setTimeout(function() {
                // 设置供货方纳税人识别号筛选条件
                components.atfxzycx.filterValues['GHFNSRSBH_1'] = ghfnsrsbh1;
                // 设置共性条件日期（用逗号拼接传入KPRQ）
                if (dateStart || dateEnd) {
                  components.atfxzycx.filterValues['KPRQ'] = (dateStart || '') + ',' + (dateEnd || '');
                }
                // 触发查询
                components.atfxzycx.searchInfo(1);
              }, 300);
            }
          }
          components.atfxzycx.changeH();
        }
      }, 300);
    },
    // 供货企业成立时间短且供货比例高 - 查询数据
    searchYd12: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        ratioThreshold: self.ratioThreshold / 100, // 将百分比转换为小数
        termThreshold: self.termThreshold, // 月份，直接传递
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      // 添加排序条件
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/newSupplyHighRatio/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 供货企业成立时间短且供货比例高 - 导出
    exportYd12: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        ratioThreshold: self.ratioThreshold / 100, // 将百分比转换为小数
        termThreshold: self.termThreshold // 月份，直接传递
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/newSupplyHighRatio/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 运输费用变动情况分析 - 构建固定列
    buildFixedColumnsForYd152: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要金额格式化的字段
      var amountFields = ['mylaj', 'bgfy'];
      
      // 所有列都禁用排序
      var columns = [
        { fieldName: 'tjyear', fieldCname: '年度', width: 80, align: 'center' },
        { fieldName: 'mylaj', fieldCname: '销售收入', width: 120, align: 'right' },
        { fieldName: 'bgfy', fieldCname: '运输费用', width: 120, align: 'right' },
        { fieldName: 'ysfyl', fieldCname: '费用率', width: 80, align: 'right' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false, // 禁用排序
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 运输费用变动情况分析 - 查询数据
    searchYd152: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq ,
        dateEnd: self.searchParams.fxqz ,
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      ajax("POST", "/cxfw/atfx/ydfx/transportFeeChange/list", params).done(function (res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable()
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData)
          };
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function (err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      })
    },
    // 运输费用变动情况分析 - 导出
    exportYd152: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/transportFeeChange/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 运输费用变动弹性系数 - 构建固定列（带复合表头）
    buildFixedColumnsForYd153: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要金额格式化的字段
      var amountFields = ['mylaj', 'mylajSn', 'ysfy', 'ysfySn'];
      
      // 定义列配置
      var columns = [
        { fieldName: 'tjyear', fieldCname: '年度', width: 80, align: 'center' },
        { fieldName: 'mylaj', fieldCname: '本年', width: 120, align: 'right', group: 'sales' },
        { fieldName: 'mylajSn', fieldCname: '上年', width: 120, align: 'right', group: 'sales' },
        { fieldName: 'mylajBdl', fieldCname: '变动率', width: 100, align: 'right', group: 'sales' },
        { fieldName: 'ysfy', fieldCname: '本年', width: 120, align: 'right', group: 'transport' },
        { fieldName: 'ysfySn', fieldCname: '上年', width: 120, align: 'right', group: 'transport' },
        { fieldName: 'fyBdl', fieldCname: '变动率', width: 100, align: 'right', group: 'transport' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false,
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      // 构建带复合表头的空表格，不自动查询
      self.forceRebuildTableWithGroupHeaderYd153();
    },
    // 运输费用变动弹性系数 - 构建带复合表头的表格
    forceRebuildTableWithGroupHeaderYd153: function() {
      this.orderSql = '';
      var self = this;
      if ($("#atfxydyx-grid").hasClass("ui-jqgrid-btable")) {
        $("#atfxydyx-grid").jqGrid('GridUnload');
      }
      var containerHeight = $('.atfxydyx .grid-container').height();
      var pagerHeight = $('#atfxydyx-pager').outerHeight() || 30;
      var tableHeight = containerHeight - pagerHeight - 55;
      setTimeout(function() {
        $("#atfxydyx-grid").jqGrid({
          colNames: self.colNames,
          colModel: self.colModel,
          datatype: "local",
          gridview: true,
          viewrecords: true,
          rownumbers: true,
          pager: '#atfxydyx-pager',
          shrinkToFit: false,
          width: "100%",
          autowidth: true,
          rownumWidth: 60,
          forceFit: true,
          altRows: true,
          altclass: "altclasscss",
          lastsort: 1,
          height: tableHeight > 0 ? tableHeight : 'auto',
          rowNum: self.pageSize,
          rowList: [20, 50, 100, 500],
          loadComplete: function() {
            setTimeout(function() {
              $("#atfxydyx-grid")[0].addJSONData(self.tableData);
            }, 0);
            self.changeH();
          },
          onSortCol: function(index, iCol, sortorder) {
            var orderSql = index + " " + sortorder;
            self.orderSql = orderSql;
            self.searchInfo(1, true);
            return;
          },
          onPaging: function(pgButton) {
            self.pageNo = tools.getPageNo2(pgButton, "atfxydyx-pager");
            self.searchInfo(self.pageNo, true);
          }
        });
        
        // 设置复合表头
        $("#atfxydyx-grid").jqGrid('setGroupHeaders', {
          useColSpanStyle: true,
          groupHeaders: [
            { startColumnName: 'mylaj', numberOfColumns: 3, titleText: '报关单美元离岸价变动情况' },
            { startColumnName: 'ysfy', numberOfColumns: 3, titleText: '运输费用变动情况' }
          ]
        });
        
        $("#atfxydyx-grid").css({
          "min-height": "1px"
        });
        $("#atfxydyx-grid").closest(".atfxydyx .ui-jqgrid-view").css({
          "overflow-x": "auto",
          "overflow-y": "hidden"
        });
        $("#atfxydyx-grid").closest(".atfxydyx .ui-jqgrid-bdiv").css("overflow-x", "auto");
      }, 200);
    },
    // 运输费用变动弹性系数 - 查询数据
    searchYd153: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        elasticThreshold: self.yd153ElasticThreshold, // 弹性系数阈值
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      ajax("POST", "/cxfw/atfx/ydfx/transportFeeElastic/list", params).done(function(res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTableWithGroupHeaderYd153();
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData);
          }
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTableWithGroupHeaderYd153();
          tools.info(res.msg);
        }
      }).fail(function(err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTableWithGroupHeaderYd153();
        tools.info(err);
      });
    },
    // 运输费用变动弹性系数 - 导出
    exportYd153: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        elasticThreshold: self.yd153ElasticThreshold // 弹性系数阈值
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/transportFeeElastic/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 人均销售收入变动情况分析 - 构建固定列（带复合表头）
    buildFixedColumnsForYd141: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要金额格式化的字段
      var amountFields = ['yysr', 'yysrSn', 'rjsr', 'rjsrSn'];
      
      // 定义列配置
      var columns = [
        { fieldName: 'byear', fieldCname: '年度', width: 80, align: 'center' },
        { fieldName: 'yysr', fieldCname: '本年', width: 120, align: 'right', group: 'sales' },
        { fieldName: 'yysrSn', fieldCname: '上年', width: 120, align: 'right', group: 'sales' },
        { fieldName: 'yysrBdl', fieldCname: '变动率', width: 100, align: 'right', group: 'sales' },
        { fieldName: 'cyrs', fieldCname: '本年', width: 120, align: 'right', group: 'staff' },
        { fieldName: 'cyrsSn', fieldCname: '上年', width: 120, align: 'right', group: 'staff' },
        { fieldName: 'cyrsBdl', fieldCname: '变动率', width: 100, align: 'right', group: 'staff' },
        { fieldName: 'rjsr', fieldCname: '本年', width: 120, align: 'right', group: 'perCapita' },
        { fieldName: 'rjsrSn', fieldCname: '上年', width: 120, align: 'right', group: 'perCapita' },
        { fieldName: 'rjsrBdl', fieldCname: '变动率', width: 100, align: 'right', group: 'perCapita' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false,
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      // 构建带复合表头的空表格，不自动查询
      self.forceRebuildTableWithGroupHeader();
    },
    // 人均销售收入变动情况分析 - 构建带复合表头的表格
    forceRebuildTableWithGroupHeader: function() {
      this.orderSql = '';
      var self = this;
      if ($("#atfxydyx-grid").hasClass("ui-jqgrid-btable")) {
        $("#atfxydyx-grid").jqGrid('GridUnload');
      }
      var containerHeight = $('.atfxydyx .grid-container').height();
      var pagerHeight = $('#atfxydyx-pager').outerHeight() || 30;
      var tableHeight = containerHeight - pagerHeight - 55;
      setTimeout(function() {
        $("#atfxydyx-grid").jqGrid({
          colNames: self.colNames,
          colModel: self.colModel,
          datatype: "local",
          gridview: true,
          viewrecords: true,
          rownumbers: true,
          pager: '#atfxydyx-pager',
          shrinkToFit: false,
          width: "100%",
          autowidth: true,
          rownumWidth: 60,
          forceFit: true,
          altRows: true,
          altclass: "altclasscss",
          lastsort: 1,
          height: tableHeight > 0 ? tableHeight : 'auto',
          rowNum: self.pageSize,
          rowList: [20, 50, 100, 500],
          loadComplete: function() {
            setTimeout(function() {
              $("#atfxydyx-grid")[0].addJSONData(self.tableData);
            }, 0);
            self.changeH();
          },
          onSortCol: function(index, iCol, sortorder) {
            var orderSql = index + " " + sortorder;
            self.orderSql = orderSql;
            self.searchInfo(1, true);
            return;
          },
          onPaging: function(pgButton) {
            self.pageNo = tools.getPageNo2(pgButton, "atfxydyx-pager");
            self.searchInfo(self.pageNo, true);
          }
        });
        
        // 设置复合表头
        $("#atfxydyx-grid").jqGrid('setGroupHeaders', {
          useColSpanStyle: true,
          groupHeaders: [
            { startColumnName: 'yysr', numberOfColumns: 3, titleText: '销售额变动情况' },
            { startColumnName: 'cyrs', numberOfColumns: 3, titleText: '人数变动情况' },
            { startColumnName: 'rjsr', numberOfColumns: 3, titleText: '人均销售收入情况' }
          ]
        });
        
        $("#atfxydyx-grid").css({
          "min-height": "1px"
        });
        $("#atfxydyx-grid").closest(".atfxydyx .ui-jqgrid-view").css({
          "overflow-x": "auto",
          "overflow-y": "hidden"
        });
        $("#atfxydyx-grid").closest(".atfxydyx .ui-jqgrid-bdiv").css("overflow-x", "auto");
      }, 200);
    },
    // 人均销售收入变动情况分析 - 查询数据
    searchYd141: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      ajax("POST", "/cxfw/atfx/ydfx/perCapitaSales/list", params).done(function(res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTableWithGroupHeader();
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData);
          }
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTableWithGroupHeader();
          tools.info(res.msg);
        }
      }).fail(function(err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTableWithGroupHeader();
        tools.info(err);
      });
    },
    // 人均销售收入变动情况分析 - 导出
    exportYd141: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/perCapitaSales/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 单位能耗变动情况分析 - 构建固定列
    buildFixedColumnsForYd142: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要金额格式化的字段
      var amountFields = ['allXs', 'dianJh', 'qiJh', 'shuiJh'];
      
      var columns = [
        { fieldName: 'tjyear', fieldCname: '年度', width: 80, align: 'center' },
        { fieldName: 'allXs', fieldCname: '总销售额（元）', width: 120, align: 'right' },
        { fieldName: 'dianJh', fieldCname: '总耗电量（元）', width: 120, align: 'right' },
        { fieldName: 'perDianJh', fieldCname: '单位产值耗电量', width: 120, align: 'right' },
        { fieldName: 'qiJh', fieldCname: '总耗气量（元）', width: 120, align: 'right' },
        { fieldName: 'perQiJh', fieldCname: '单位产值耗气量', width: 120, align: 'right' },
        { fieldName: 'shuiJh', fieldCname: '总耗水量（元）', width: 120, align: 'right' },
        { fieldName: 'perShuiJh', fieldCname: '单位产值耗水量', width: 120, align: 'right' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false,
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 单位能耗变动情况分析 - 查询数据
    searchYd142: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      ajax("POST", "/cxfw/atfx/ydfx/unitEnergyConsumption/list", params).done(function(res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable();
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData);
          }
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function(err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      });
    },
    // 单位能耗变动情况分析 - 导出
    exportYd142: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/unitEnergyConsumption/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 能耗与销售变动的弹性系数 - 构建固定列（带复合表头）
    buildFixedColumnsForYd143: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要金额格式化的字段
      var amountFields = ['xhAll', 'xsSn'];
      
      // 定义列配置
      var columns = [
        { fieldName: 'tjyear', fieldCname: '年度', width: 80, align: 'center' },
        { fieldName: 'xhAll', fieldCname: '本年', width: 120, align: 'right', group: 'sales' },
        { fieldName: 'xsSn', fieldCname: '上年', width: 120, align: 'right', group: 'sales' },
        { fieldName: 'xsBdl', fieldCname: '变动率', width: 100, align: 'right', group: 'sales' },
        { fieldName: 'nhAll', fieldCname: '本年', width: 120, align: 'right', group: 'energy' },
        { fieldName: 'nhSn', fieldCname: '上年', width: 120, align: 'right', group: 'energy' },
        { fieldName: 'nhBdl', fieldCname: '变动率', width: 100, align: 'right', group: 'energy' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false,
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      // 构建带复合表头的空表格，不自动查询
      self.forceRebuildTableWithGroupHeaderYd143();
    },
    // 能耗与销售变动的弹性系数 - 构建带复合表头的表格
    forceRebuildTableWithGroupHeaderYd143: function() {
      this.orderSql = '';
      var self = this;
      if ($("#atfxydyx-grid").hasClass("ui-jqgrid-btable")) {
        $("#atfxydyx-grid").jqGrid('GridUnload');
      }
      var containerHeight = $('.atfxydyx .grid-container').height();
      var pagerHeight = $('#atfxydyx-pager').outerHeight() || 30;
      var tableHeight = containerHeight - pagerHeight - 55;
      setTimeout(function() {
        $("#atfxydyx-grid").jqGrid({
          colNames: self.colNames,
          colModel: self.colModel,
          datatype: "local",
          gridview: true,
          viewrecords: true,
          rownumbers: true,
          pager: '#atfxydyx-pager',
          shrinkToFit: false,
          width: "100%",
          autowidth: true,
          rownumWidth: 60,
          forceFit: true,
          altRows: true,
          altclass: "altclasscss",
          lastsort: 1,
          height: tableHeight > 0 ? tableHeight : 'auto',
          rowNum: self.pageSize,
          rowList: [20, 50, 100, 500],
          loadComplete: function() {
            setTimeout(function() {
              $("#atfxydyx-grid")[0].addJSONData(self.tableData);
            }, 0);
            self.changeH();
          },
          onSortCol: function(index, iCol, sortorder) {
            var orderSql = index + " " + sortorder;
            self.orderSql = orderSql;
            self.searchInfo(1, true);
            return;
          },
          onPaging: function(pgButton) {
            self.pageNo = tools.getPageNo2(pgButton, "atfxydyx-pager");
            self.searchInfo(self.pageNo, true);
          }
        });
        
        // 设置复合表头
        $("#atfxydyx-grid").jqGrid('setGroupHeaders', {
          useColSpanStyle: true,
          groupHeaders: [
            { startColumnName: 'xhAll', numberOfColumns: 3, titleText: '销售额变动情况' },
            { startColumnName: 'nhAll', numberOfColumns: 3, titleText: '能耗变动情况' }
          ]
        });
        
        $("#atfxydyx-grid").css({
          "min-height": "1px"
        });
        $("#atfxydyx-grid").closest(".atfxydyx .ui-jqgrid-view").css({
          "overflow-x": "auto",
          "overflow-y": "hidden"
        });
        $("#atfxydyx-grid").closest(".atfxydyx .ui-jqgrid-bdiv").css("overflow-x", "auto");
      }, 200);
    },
    // 能耗与销售变动的弹性系数 - 查询数据
    searchYd143: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        elasticThreshold: self.elasticThreshold, // 弹性系数阈值
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      ajax("POST", "/cxfw/atfx/ydfx/energySalesElastic/list", params).done(function(res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTableWithGroupHeaderYd143();
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData);
          }
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTableWithGroupHeaderYd143();
          tools.info(res.msg);
        }
      }).fail(function(err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTableWithGroupHeaderYd143();
        tools.info(err);
      });
    },
    // 能耗与销售变动的弹性系数 - 导出
    exportYd143: function() {
      var self = this;
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        elasticThreshold: self.elasticThreshold // 弹性系数阈值
      };
      
      var form = $("<form>");
      form.attr("style", "display:none");
      form.attr("target", "hiddenframe");
      form.attr("method", "post");
      form.attr("action", "/cxfw/atfx/ydfx/energySalesElastic/export/excel");
      var input1 = $("<input>");
      input1.attr("type", "hidden");
      input1.attr("name", "data");
      input1.attr("value", JSON.stringify(params));
      $("body").append(form);
      form.append(input1);
      form.submit();
      form.remove();
    },
    // 报关费用变动情况分析 - 构建固定列（带复合表头）
    buildFixedColumnsForYd151: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要金额格式化的字段
      var amountFields = ['bgfy', 'bgfySn'];
      
      // 定义列配置
      var columns = [
        { fieldName: 'tjyear', fieldCname: '年度', width: 80, align: 'center' },
        { fieldName: 'bgdfs', fieldCname: '本年', width: 120, align: 'right', group: 'count' },
        { fieldName: 'bgdfsSn', fieldCname: '上年', width: 120, align: 'right', group: 'count' },
        { fieldName: 'fsBdl', fieldCname: '变动率', width: 100, align: 'right', group: 'count' },
        { fieldName: 'bgfy', fieldCname: '本年', width: 120, align: 'right', group: 'fee' },
        { fieldName: 'bgfySn', fieldCname: '上年', width: 120, align: 'right', group: 'fee' },
        { fieldName: 'fyBdl', fieldCname: '变动率', width: 100, align: 'right', group: 'fee' },
        { fieldName: 'bdcy', fieldCname: '变动率差异', width: 100, align: 'right' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false,
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      // 构建带复合表头的空表格，不自动查询
      self.forceRebuildTableWithGroupHeaderYd151();
    },
    // 报关费用变动情况分析 - 构建带复合表头的表格
    forceRebuildTableWithGroupHeaderYd151: function() {
      this.orderSql = '';
      var self = this;
      if ($("#atfxydyx-grid").hasClass("ui-jqgrid-btable")) {
        $("#atfxydyx-grid").jqGrid('GridUnload');
      }
      var containerHeight = $('.atfxydyx .grid-container').height();
      var pagerHeight = $('#atfxydyx-pager').outerHeight() || 30;
      var tableHeight = containerHeight - pagerHeight - 55;
      setTimeout(function() {
        $("#atfxydyx-grid").jqGrid({
          colNames: self.colNames,
          colModel: self.colModel,
          datatype: "local",
          gridview: true,
          rownumWidth: 60,
          viewrecords: true,
          rownumbers: true,
          pager: '#atfxydyx-pager',
          shrinkToFit: false,
          width: "100%",
          autowidth: true,
          forceFit: true,
          altRows: true,
          altclass: "altclasscss",
          lastsort: 1,
          height: tableHeight > 0 ? tableHeight : 'auto',
          rowNum: self.pageSize,
          rowList: [20, 50, 100, 500],
          loadComplete: function() {
            setTimeout(function() {
              $("#atfxydyx-grid")[0].addJSONData(self.tableData);
            }, 0);
            self.changeH();
          },
          onSortCol: function(index, iCol, sortorder) {
            var orderSql = index + " " + sortorder;
            self.orderSql = orderSql;
            self.searchInfo(1, true);
            return;
          },
          onPaging: function(pgButton) {
            self.pageNo = tools.getPageNo2(pgButton, "atfxydyx-pager");
            self.searchInfo(self.pageNo, true);
          }
        });
        
        // 设置复合表头
        $("#atfxydyx-grid").jqGrid('setGroupHeaders', {
          useColSpanStyle: true,
          groupHeaders: [
            { startColumnName: 'bgdfs', numberOfColumns: 3, titleText: '报关单份数变动情况' },
            { startColumnName: 'bgfy', numberOfColumns: 3, titleText: '报关费用变动情况' }
          ]
        });
        
        $("#atfxydyx-grid").css({
          "min-height": "1px"
        });
        $("#atfxydyx-grid").closest(".atfxydyx .ui-jqgrid-view").css({
          "overflow-x": "auto",
          "overflow-y": "hidden"
        });
        $("#atfxydyx-grid").closest(".atfxydyx .ui-jqgrid-bdiv").css("overflow-x", "auto");
      }, 200);
    },
    // 报关费用变动情况分析 - 查询数据
    searchYd151: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        diffThreshold: self.yd151DiffThreshold / 100, // 变化率差异阈值
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      ajax("POST", "/cxfw/atfx/ydfx/customsFeeChange/list", params).done(function(res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTableWithGroupHeaderYd151();
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData);
          }
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTableWithGroupHeaderYd151();
          tools.info(res.msg);
        }
      }).fail(function(err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTableWithGroupHeaderYd151();
        tools.info(err);
      });
    },
    // 省外企业供货比例偏高 - 构建固定列（双表格）
    buildFixedColumnsForYd10: function() {
      var self = this;
      // 初始化两个空表格，不自动查询
      self.buildYd10SummaryTable(null);
      self.buildYd10DetailTable();
    },
    // 省外企业供货比例偏高 - 构建汇总表格（单行）
    buildYd10SummaryTable: function(summaryData) {
      var self = this;
      if ($("#atfxydyx-grid-yd10-summary").hasClass("ui-jqgrid-btable")) {
        $("#atfxydyx-grid-yd10-summary").jqGrid('GridUnload');
      }
      
      var colNames = ['全部供货金额', '省内供货金额', '省外供货金额', '省外供货占比(%)'];
      var colModel = [
        { name: 'jsjeAll', index: 'jsjeAll', label: '全部供货金额', sortable: false, align: 'right', width: 120, formatter: function(cellVal) { if (cellVal === undefined || cellVal === null || cellVal === '') return ''; return self.formatAmount(cellVal, 2); } },
        { name: 'jsjeSn', index: 'jsjeSn', label: '省内供货金额', sortable: false, align: 'right', width: 120, formatter: function(cellVal) { if (cellVal === undefined || cellVal === null || cellVal === '') return ''; return self.formatAmount(cellVal, 2); } },
        { name: 'jsjeSw', index: 'jsjeSw', label: '省外供货金额', sortable: false, align: 'right', width: 120, formatter: function(cellVal) { if (cellVal === undefined || cellVal === null || cellVal === '') return ''; return self.formatAmount(cellVal, 2); } },
        { name: 'swZb', index: 'swZb', label: '省外供货占比(%)', sortable: false, align: 'right', width: 120 }
      ];
      setTimeout(() => {
        $("#atfxydyx-grid-yd10-summary").jqGrid({
          colNames: colNames,
          colModel: colModel,
          datatype: "local",
          data: summaryData ? [summaryData] : [],
          gridview: true,
          viewrecords: false,
          rownumbers: false,
          rownumWidth: 60,
          shrinkToFit: false,
          width: "100%",
          autowidth: true,
          height: 'auto',
          rowNum: 1,
          loadComplete:function(){
            // if ($.isFunction($("#atfxydyx-grid-yd10-summary").jqGrid)) {
            //   // 始终设置网格宽度以确保水平滚动
            //   $("#atfxydyx-grid-yd10-summary").jqGrid('setGridWidth', $('.atfxydyx .grid-container').width(), false);
            //   // 确保容器有正确的滚动样式
            //   $("#atfxydyx-grid-yd10-summary").closest(".ui-jqgrid-view").css("overflow-x", "auto");
            //   $("#atfxydyx-grid-yd10-summary").closest(".ui-jqgrid-bdiv").css("overflow-x", "auto");
            // }
          }
        });
      },2);





      
    },
    // 省外企业供货比例偏高 - 构建明细表格（带分页）
    buildYd10DetailTable: function() {
      var self = this;
      
      // 将当前组件实例挂载到全局，供 onclick 调用
      window.atfxydyxComponent = self;
      
      if ($("#atfxydyx-grid-yd10-detail").hasClass("ui-jqgrid-btable")) {
        $("#atfxydyx-grid-yd10-detail").jqGrid('GridUnload');
      }
      
      var colNames = ['省外供应商纳税人识别号', '省外供应商纳税人名称', '省外供应商所在省份', '发票开具总金额', '总金额占比(%)'];
      var colModel = [
        { 
          name: 'gyssbh', 
          index: 'gyssbh', 
          label: '省外供应商纳税人识别号', 
          sortable: true, 
          align: 'left', 
          width: 175,
          formatter: function(cellValue, options, rowObject) {
            var gyssbh = rowObject.gyssbh || '';
            return '<a href="javascript:void(0);" onclick="window.atfxydyxComponent.goToDataQueryWithYd10(\'' + gyssbh + '\');return false;" style="color: #337ab7; text-decoration: underline; cursor: pointer;">' + (cellValue || '') + '</a>';
          }
        },
        { name: 'gysmc', index: 'gysmc', label: '省外供应商纳税人名称', sortable: true, align: 'left', width: 200 },
        { name: 'mc', index: 'mc', label: '省外供应商所在省份', sortable: true, align: 'center', width: 120 },
        { name: 'jsje', index: 'jsje', label: '发票开具总金额', sortable: true, align: 'right', width: 120, formatter: function(cellVal) { if (cellVal === undefined || cellVal === null || cellVal === '') return ''; return self.formatAmount(cellVal, 2); } },
        { name: 'zb', index: 'zb', label: '总金额占比(%)', sortable: true, align: 'right', width: 100 }
      ];
      
      var containerHeight = $('.atfxydyx .grid-container-yd10').height();
      var summaryHeight = 100; // 汇总表格高度
      var pagerHeight = 30;
      var tableHeight = containerHeight - summaryHeight - pagerHeight - 80;
      setTimeout(() => {
        $("#atfxydyx-grid-yd10-detail").jqGrid({
          colNames: colNames,
          colModel: colModel,
          datatype: "local",
          gridview: true,
          viewrecords: true,
          rownumbers: true,
          pager: '#atfxydyx-pager-yd10',
          shrinkToFit: false,
          width: "100%",
          rownumWidth: 60,
          autowidth: true,
          forceFit: true,
          altRows: true,
          altclass: "altclasscss",
          height: tableHeight > 0 ? tableHeight : 'auto',
          rowNum: self.pageSize,
          rowList: [20, 50, 100, 500],
          loadComplete: function() {
            setTimeout(function() {
              $("#atfxydyx-grid-yd10-detail")[0].addJSONData(self.yd10DetailData);
            }, 0);
            // if ($.isFunction($("#atfxydyx-grid-yd10-detail").jqGrid)) {
            //   // 始终设置网格宽度以确保水平滚动
            //   $("#atfxydyx-grid-yd10-detail").jqGrid('setGridWidth', $('.atfxydyx .grid-container').width(), false);
            //   // 确保容器有正确的滚动样式
            //   $("#atfxydyx-grid-yd10-detail").closest(".ui-jqgrid-view").css("overflow-x", "auto");
            //   $("#atfxydyx-grid-yd10-detail").closest(".ui-jqgrid-bdiv").css("overflow-x", "auto");
            // }
              var containerHeight = $('.atfxydyx .grid-container-yd10-cont').height();
              var pagerHeight = $('#atfxydyx-pager-yd10').outerHeight() || 30;
              var tableHeight = containerHeight - pagerHeight - 40;
              if (tableHeight > 0) {
                $("#atfxydyx-grid-yd10-detail").jqGrid('setGridHeight', tableHeight);
              }













            
          },
          onSortCol: function(index, iCol, sortorder) {
            var orderSql = index + " " + sortorder;
            self.orderSql = orderSql;
            self.searchYd10(1, true);
            return;
          },
          onPaging: function(pgButton) {
            self.pageNo = tools.getPageNo2(pgButton, "atfxydyx-pager-yd10");
            self.searchYd10(self.pageNo, true);
          }
        });
      },2);

    },
    // 省外企业供货比例偏高 - 跳转到数据查询tab（进货明细申报表）
    goToDataQueryWithYd10: function(gyssbh) {
      var self = this;
      // 获取共性条件的日期
      var dateStart = self.searchParams.fxqq || '';
      var dateEnd = self.searchParams.fxqz || '';
      
      // 切换到数据查询tab
      if (components.atfxmx) {
        components.atfxmx.activeName = 'atfxSjcx';
      }
      
      // 等待tab切换完成后设置筛选条件
      setTimeout(function() {
        if (components.atfxzycx) {
          var treeObj = $.fn.zTree.getZTreeObj('atfxzycxTree');
          if (treeObj) {
            // 先展开父节点 3_TSBL
            var parentNode = treeObj.getNodeByParam('tableName', '3_TSBL');
            if (parentNode) {
              treeObj.expandNode(parentNode, true, false, false);
            }
            // 查找进货明细申报表节点（tableName 为 ATFX_TS_YS_JHMXSBB）
            var node = treeObj.getNodeByParam('tableName', 'ATFX_TS_YS_JHMXSBB');
            if (node) {
              treeObj.selectNode(node);
              // 先清空筛选条件
              components.atfxzycx.filterValues = {};
              components.atfxzycx.updateSelectedNode(node);
              
              // 设置筛选条件
              setTimeout(function() {
                // 设置供货方纳税人识别号筛选条件
                components.atfxzycx.filterValues['GHFNSRSBH_1'] = gyssbh;
                // 设置共性条件日期（用逗号拼接传入KPRQ）
                if (dateStart || dateEnd) {
                  components.atfxzycx.filterValues['KPRQ'] = (dateStart || '') + ',' + (dateEnd || '');
                }
                // 触发查询
                components.atfxzycx.searchInfo(1);
              }, 300);
            }
          }
          components.atfxzycx.changeH();
        }
      }, 300);
    },
    // 省外企业供货比例偏高 - 查询数据
    searchYd10: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        outProvinceThreshold: self.outProvinceThreshold / 100, // 省外供货占比阈值
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/outProvinceSupply/list", params).done(function(res) {
        if (res.code == '0') {
          // 汇总数据（取第一行）
          var summaryData = null;
          if (res.data.rows && res.data.rows.length > 0) {
            summaryData = {
              jsjeAll: res.data.rows[0].jsjeAll,
              jsjeSn: res.data.rows[0].jsjeSn,
              jsjeSw: res.data.rows[0].jsjeSw,
              swZb: res.data.rows[0].swZb
            };
          }
          
          // 明细数据
          self.yd10DetailData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          
          if (!notReBuild) {
            self.buildYd10SummaryTable(summaryData);
            self.buildYd10DetailTable();
          } else {
            $("#atfxydyx-grid-yd10-detail")[0].addJSONData(self.yd10DetailData);
          }
        } else {
          self.yd10DetailData = [];
          if (!notReBuild) {
            self.buildYd10SummaryTable(null);
            self.buildYd10DetailTable();
          }
          tools.info(res.msg);
        }
      }).fail(function(err) {
        self.yd10DetailData = [];
        if (!notReBuild) {
          self.buildYd10SummaryTable(null);
          self.buildYd10DetailTable();
        }
        tools.info(err);
      });
    },
    // 出口敏感商品 - 构建固定列
    buildFixedColumnsForYd16: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      // 需要金额格式化的字段
      var amountFields = ['mylaj'];
      
      var columns = [
        { fieldName: 'ckbgdh', fieldCname: '出口报关单号', width: 175, align: 'center' },
        { fieldName: 'ckspDm', fieldCname: '商品代码', width: 100, align: 'center' },
        { fieldName: 'gfhhgspmc', fieldCname: '规范化海关商品名称', width: 200, align: 'left' },
        { fieldName: 'mylaj', fieldCname: '美元离岸价', width: 120, align: 'right' },
        { fieldName: 'gzMc', fieldCname: '规则名称', width: 150, align: 'left' },
        { fieldName: 'gzFxms', fieldCname: '规则描述', width: 250, align: 'left' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        var colConfig = {
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false,
          align: col.align,
          width: col.width
        };
        // 金额字段格式化
        if (amountFields.includes(col.fieldName)) {
          colConfig.formatter = function(cellVal, op, row) {
            if (cellVal === undefined || cellVal === null || cellVal === '') return '';
            return self.formatAmount(cellVal, 2);
          };
        }
        self.colModel.push(colConfig);
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 出口敏感商品 - 查询数据
    searchYd16: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/sensitiveGoods/list", params).done(function(res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable();
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData);
          }
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function(err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      });
    },
    // 触发日常专项指标情况 - 构建固定列
    buildFixedColumnsForYd17: function() {
      var self = this;
      self.colNames = [];
      self.colModel = [];
      self.fList = [];
      
      var columns = [
        { fieldName: 'smrq', fieldCname: '扫描日期', width: 100, align: 'center' },
        { fieldName: 'zbmc', fieldCname: '专项监管指标名称', width: 200, align: 'left' },
        { fieldName: 'smjg', fieldCname: '扫描结果', width: 150, align: 'left' },
        { fieldName: 'hsjg', fieldCname: '核实结果类型', width: 100, align: 'center' },
        { fieldName: 'hsrq', fieldCname: '核实日期', width: 100, align: 'center' },
        { fieldName: 'hsry', fieldCname: '核实人员', width: 80, align: 'center' },
        { fieldName: 'hsclqk', fieldCname: '核实处理情况', width: 200, align: 'left' }
      ];
      
      for (let i = 0; i < columns.length; i++) {
        let col = columns[i];
        self.colNames.push(col.fieldCname);
        self.colModel.push({
          name: col.fieldName,
          index: col.fieldName,
          label: col.fieldCname,
          sortable: false,
          align: col.align,
          width: col.width
        });
        self.fList.push({
          fieldName: col.fieldName,
          fieldCname: col.fieldCname
        });
      }
      
      self.curNode.fieldList = self.fList;
      self.tableData = {};
      self.forceRebuildTable();
       
    },
    // 触发日常专项指标情况 - 查询数据
    searchYd17: function(pageNo, notReBuild) {
      var self = this;
      let pageSize = $(".ui-pg-selbox", $('.atfxydyx')).val();
      self.pageSize = pageSize ? pageSize : 20;
      
      let params = {
        uuid: self.searchParams.uuid,
        dateStart: self.searchParams.fxqq,
        dateEnd: self.searchParams.fxqz,
        pageNo: pageNo,
        pageSize: pageSize || 20
      };
      
      if (self.orderSql) {
        params.orderSql = self.orderSql;
      }
      
      ajax("POST", "/cxfw/atfx/ydfx/dailySpecialIndex/list", params).done(function(res) {
        if (res.code == '0') {
          self.tableData = {
            rows: res.data.rows,
            page: res.data.page,
            records: res.data.count,
            total: res.data.total,
          };
          if (!notReBuild) {
            self.forceRebuildTable();
          } else {
            $("#atfxydyx-grid")[0].addJSONData(self.tableData);
          }
        } else {
          self.tableData = [];
          if (!notReBuild) self.forceRebuildTable();
          tools.info(res.msg);
        }
      }).fail(function(err) {
        self.tableData = [];
        if (!notReBuild) self.forceRebuildTable();
        tools.info(err);
      });
    }
  }
});
