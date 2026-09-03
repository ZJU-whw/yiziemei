/**
 * 企业经营情况图表组件
 * 用于展示企业的进货、销售、出口、退税、收汇等业务数据图表
 */
var atfxCharts = require("./atfxCharts.html");
avalon.component('atfxCharts', {
  template: atfxCharts,
  defaults: {
    uuid: '',
    endDate: '',
    showChart: false,
    startDate: '',
    // 图表搜索条件
    searchData: {
      fxqq: '',     // 分析期间起
      fxqz: '',     // 分析期间止
      hzwd: 'y',    // 汇总维度：n-年、j-季度、y-月
      chartType: 'line'  // 图表类型：line-折线图、bar-柱状图
    },
    curDialogTitle: '',   // 当前弹窗标题
    curClickType: '',     // 当前点击的业务类型
    // 图表颜色配置
    chartColors: {
      'jhHw': '#5470c6',
      'jhFw': '#91cc75',
      'ck': '#fac858',
      'xsNx': '#ee6666',
      'xsWx': '#73c0de',
      'ts': '#3ba272',
      'sh': '#fc8452'
    },
    historyData: {},      // 历史搜索数据
    businessChart: null,  // ECharts实例
    chartPeriod: '2025年1月-2025年12月',  // 图表显示期间
    // 图表数据控制项（可控制显示/隐藏和偏移量）
    chartDataControls: [
      { key: 'jh', label: '进货', visible: true, offset: 0 },
      { key: 'ck', label: '出口', visible: true, offset: 0 },
      { key: 'xs', label: '销售', visible: true, offset: 0 },
      { key: 'ts', label: '退税', visible: true, offset: 0 },
      { key: 'sh', label: '收汇', visible: true, offset: 0 },
    ],
    // 图表数据结构
    chartData: {
      months: [],      // 月份列表
      series: {}       // 各系列数据
    },
    // 列表信息配置（一级详情）
    listInfo: {
      jh: {
        gys: {
          label: '供应商详情',
          url: '/cxfw/atfx/jyqk/jhxx/gysZbxq'
        },
        sp: {
          label: '商品详情',
          url: '/cxfw/atfx/jyqk/jhxx/spOrFwZbxq',
          otherParams: {
            type: 'sp'
          }
        },
        lineChart: {
          label: '服务类项目详情',
          url: '/cxfw/atfx/jyqk/jhxx/spOrFwZbxq',
          otherParams: {
            type: 'fw'
          }
        },
        pieChart: {
          url: '/cxfw/atfx/jyqk/jhxx/zb'
        }
      },
      xs: {
        pieChart: {
          url: '/cxfw/atfx/jyqk/xsxx/zb'
        },
        kh: {
          label: '客户详情',
          url: '/cxfw/atfx/jyqk/xsxx/khZbxq'
        },
        sp: {
          label: '商品详情',
          url: '/cxfw/atfx/jyqk/xsxx/spZbxq'
        }
      },
      ts: {
        pieChart: {
          url: '/cxfw/atfx/jyqk/tsxx/zb'
        },
        sp: {
          label: '出口商品详情',
          url: '/cxfw/atfx/jyqk/tsxx/ckspZbxq'
        },
        hyd: {
          label: '货源地详情',
          url: '/cxfw/atfx/jyqk/tsxx/hydZbxq'
        },
        ghs: {
          label: '供应商详情',
          url: '/cxfw/atfx/jyqk/tsxx/ghsZbxq'
        },
      },
      sh: {
        pieChart: {
          url: '/cxfw/atfx/jyqk/shxx/zb'
        },
        gb: {
          label: '收汇国别',
          url: '/cxfw/atfx/jyqk/shxx/shgbZbxq'
        },
        bz: {
          label: '收汇币种',
          url: '/cxfw/atfx/jyqk/shxx/shbzZbxq'
        }
      },
      ck: {
        pieChart: {
          url: '/cxfw/atfx/jyqk/ckxx/zb'
        },
        cksp: {
          label: '出口商品详情',
          url: '/cxfw/atfx/jyqk/ckxx/ckspZbxq'
        },
        ckkh: {
          label: '出口客户详情',
          url: '/cxfw/atfx/jyqk/ckxx/ckkhZbxq'
        },
        mdg: {
          label: '目的国详情',
          url: '/cxfw/atfx/jyqk/ckxx/mulZbxq'
        },
        myg: {
          label: '贸易国详情',
          url: '/cxfw/atfx/jyqk/ckxx/mulZbxq'
        },
        ckka: {
          label: '口岸详情',
          url: '/cxfw/atfx/jyqk/ckxx/mulZbxq'
        },
        jgfs: {
          label: '监管方式详情',
          url: '/cxfw/atfx/jyqk/ckxx/mulZbxq'
        },
        cjfs: {
          label: '成交方式详情',
          url: '/cxfw/atfx/jyqk/ckxx/mulZbxq'
        },
        ysfs: {
          label: '运输方式详情',
          url: '/cxfw/atfx/jyqk/ckxx/mulZbxq'
        },
        hyd: {
          label: '货源地详情',
          url: '/cxfw/atfx/jyqk/ckxx/mulZbxq'
        },
      }
    },
    // 二级列表信息配置
    secondInfo: {},
    listInfoSecond: {
      jh: {
        gys: {
          label: '主要供货商品',
          url: '/cxfw/atfx/jyqk/jhxx/spOrFwZbxq',
          otherKey: 'gyssbh'
        },
        lineChart: {
          label: '供货企业',
          url: '/cxfw/atfx/jyqk/jhxx/gysZbxq',
          otherParams: {
            type: 'fw'
          },
          otherKey: 'sphfwssflhbbm'
        },
        sp: {
          label: '供货企业',
          url: '/cxfw/atfx/jyqk/jhxx/gysZbxq',
          otherKey: 'sphfwssflhbbm'
        }
      },
      xs: {
        kh: {
          label: '主要供货商品',
          url: '/cxfw/atfx/jyqk/xsxx/spZbxq',
          otherKey: 'khmc'
        },
        sp: {
          label: '供货企业',
          url: '/cxfw/atfx/jyqk/xsxx/khZbxq',
          otherKey: 'sphfwssflhbbm'
        },
      }
    },
    curType: '',

    /**
     * 组件初始化回调函数
     * @param {Object} e - 事件对象
     */
    onInit: function (e) {
      components.atfxCharts = e.vmodel;
    },

    /**
     * 组件准备完成回调函数
     */
    onReady: function () {
      var self = this;
      // 初始化日期选择器的起止时间
      self.searchData.fxqq = self.getYearMonth(self.startDate)
      self.searchData.fxqz = self.getYearMonth(self.endDate)
      var options = {
        language: "zh-CN",
        format: "yyyy-mm",
        autoclose: true,
        clearBtn: true,
        startView: 3,
        minView: 3,
        endDate: new Date()
      };
      $('.qyjyqk-form .datepicker').datetimepicker(options);

      // 监听窗口大小变化，调整图表大小
      var resizeHandler = function () {
        if (self.businessChart && typeof self.businessChart.resize === 'function') {
          try {
            self.businessChart.resize();
          } catch (e) {
            console.warn('图表调整大小出错:', e);
          }
        }
      };
      window.addEventListener('resize', resizeHandler);

      // 组件销毁时移除事件监听器
      this.$watch('onDispose', function () {
        window.removeEventListener('resize', resizeHandler);
        self.disposeChart();
      });
    },

    /**
     * 显示列表详情
     * @param {Object} e - 包含type属性的对象，表示要显示的详情类型
     */
    showList: function (e) {
      this.curType = e.type;
      $(".atfx-chart .atfx-xq-list").show();
      setTimeout(() => {
        this.initListTable();
      }, 100)
    },

    /**
     * 根据当前业务类型和详情类型获取表格列配置
     * @returns {Array} 表格列配置数组
     */
    getCol() {
      if (this.curClickType == 'jh') {
        if (this.curType == 'gys') {
          return [
            { name: "gyssbh", label: "供应商识别号", index: "gyssbh", width: 150, align: "left", sortable: false },
            { name: "gysmc", label: "供应商名称", index: "gysmc", width: 150, align: "left", sortable: false },
            { name: "gysSsxSwjgmc", label: "所属省市县", index: "gysSsxSwjgmc", width: 150, align: "left", sortable: false },
            { name: "gysDjrq", label: "登记日期", index: "gysDjrq", width: 120, align: "center", sortable: false },
            { name: "gysNsrztMc", label: "纳税人状态", index: "gysNsrztMc", width: 80, align: "center", sortable: false },
            { name: "gysSckprq", label: "首次供货日期", index: "gysSckprq", width: 120, align: "center", sortable: false },
            { name: "gysBskphs", label: "省内供货户数", index: "gysBskphs", width: 80, align: "right", sortable: false },
            { name: "gysBssckprq", label: "首次省内供货日期", index: "gysBssckprq", width: 120, align: "center", sortable: false },
            {
              name: "zyghsp", label: "主要供货商品", index: "zyghsp", width: 80, align: "center", sortable: false, formatter: function (cellvalue, options, rowObject) {
                return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='lookSecond'>查看详情</span>"
              }
            },
            {
              name: "fzZje", label: "供货金额", index: "fzZje", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "fzZse", label: "进项税额", index: "fzZse", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "jeZb", label: "供货金额占比", index: "jeZb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
            {
              name: "jeTb", label: "金额同比", index: "jeTb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ];
        } else if (this.curType == 'sp' || this.curType == 'lineChart') {
          return [
            { name: "sphfwssflhbbm", label: "税收分类编码", index: "sphfwssflhbbm", width: 150, align: "left", sortable: false },
            { name: "hwhyslwfwmc", label: "商品名称", index: "hwhyslwfwmc", width: 150, align: "left", sortable: false },
            {
              name: "ghqyhs", label: "供货企业户数", index: "ghqyhs", width: 80, align: "center", sortable: false,
              formatter: function (cellvalue, options, rowObject) {
                return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='lookSecond'>查看详情</span>"
              }
            },
            {
              name: "fzZje", label: "金额", index: "fzZje", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "fzZse", label: "税额", index: "fzZse", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "jeZb", label: "占比", index: "jeZb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
            {
              name: "jeTb", label: "同比", index: "jeTb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ]
        }
      } else if (this.curClickType == 'xs') {
        if (this.curType == 'kh') {
          return [
            { name: "khmc", label: "客户名称", index: "khmc", width: 150, align: "left", sortable: false },
            { name: "sfjwkh", label: "是否境外客户", index: "sfjwkh", width: 100, align: "center", sortable: false },
            { name: "gmfSckprq", label: "首次销售日期", index: "gmfSckprq", width: 120, align: "center", sortable: false },
            {
              name: "zyghsp", label: "主要供货商品", index: "zyghsp", width: 80, align: "center", sortable: false, formatter: function (cellvalue, options, rowObject) {
                return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='lookSecond'>查看详情</span>"
              }
            },
            {
              name: "fzZje", label: "金额", index: "fzZje", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "fzZse", label: "税额", index: "fzZse", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "jeZb", label: "金额占比", index: "jeZb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
            {
              name: "jeTb", label: "金额同比", index: "jeTb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ]
        } else {
          return [
            { name: "sphfwssflhbbm", label: "税收分类编码", index: "sphfwssflhbbm", width: 150, align: "left", sortable: false },
            { name: "hwhyslwfwmc", label: "商品名称", index: "hwhyslwfwmc", width: 150, align: "left", sortable: false },
            {
              name: "ghqyhs", label: "供货企业户数", index: "ghqyhs", width: 80, align: "center", sortable: false,
              formatter: function (cellvalue, options, rowObject) {
                return "<span style='color:#0000ff;text-decoration: underline;cursor:pointer;' class='lookSecond'>查看详情</span>"
              }
            },
            {
              name: "fzZje", label: "金额", index: "fzZje", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "fzZse", label: "税额", index: "fzZse", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "jeZb", label: "金额占比", index: "jeZb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
            {
              name: "jeTb", label: "金额同比", index: "jeTb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ]
        }
      } else if (this.curClickType == 'ts') {
        if (this.curType == 'sp') {
          return [
            { name: "ckspDm", label: "商品代码", index: "ckspDm", width: 150, align: "left", sortable: false },
            { name: "ckspmc", label: "商品名称", index: "ckspmc", width: 150, align: "left", sortable: false },
            { name: "sctssbrq", label: "首次退税日期", index: "sctssbrq", width: 120, align: "center", sortable: false },
            {
              name: "fzZmylaj", label: "申报美元离岸价", index: "fzZmylaj", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "fzZjsje", label: "计税金额", index: "fzZjsje", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "fzZtseMde", label: "退税额", index: "fzZtseMde", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "zb", label: "退税额占比", index: "zb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ]
        } else if (this.curType == 'ghs') {
          return [
            { name: "gyssbh", label: "供应商识别号", index: "gyssbh", width: 150, align: "left", sortable: false },
            { name: "gysmc", label: "供应商名称", index: "gysmc", width: 150, align: "left", sortable: false },
            { name: "gysSsxSwjgmc", label: "所属省市县", index: "gysSsxSwjgmc", width: 150, align: "left", sortable: false },
            { name: "sctssbrq", label: "首次退税日期", index: "sctssbrq", width: 120, align: "center", sortable: false },
            {
              name: "fzZjsje", label: "计税金额", index: "fzZjsje", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "fzZtse", label: "退税额", index: "fzZtse", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "zb", label: "退税额占比", index: "zb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ]
        } else if (this.curType == 'hyd') {
          return [
            { name: "swjgDm", label: "代码", index: "swjgDm", width: 150, align: "left", sortable: false },
            { name: "swjgMc", label: "名称", index: "swjgMc", width: 150, align: "left", sortable: false },
            {
              name: "fzZjsje", label: "计税金额", index: "fzZjsje", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "fzZtse", label: "退税额", index: "fzZtse", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "zb", label: "退税额占比", index: "zb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ]
        }
      } else if (this.curClickType == 'sh') {
        if (this.curType == 'gb') {
          return [
            { name: "hggjhdqszMc", label: "国别", index: "hggjhdqszMc", width: 150, align: "left", sortable: false },
            {
              name: "fzZckshjemy", label: "折美元收汇", index: "fzZckshjemy", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "fzZckshjermb", label: "折人民币收汇", index: "fzZckshjermb", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "fzZqzkjrmb", label: "其中跨境人民币金额", index: "fzZqzkjrmb", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "zb", label: "占比", index: "zb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
            {
              name: "tb", label: "同比", index: "tb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ]
        } else if (this.curType == 'bz') {
          return [
            { name: "ckshhbzmDm", label: "币种", index: "ckshhbzmDm", width: 120, align: "left", sortable: false },
            {
              name: "fzZckshjemy", label: "折美元收汇", index: "fzZckshjemy", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "fzZckshjermb", label: "折人民币收汇", index: "fzZckshjermb", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "zb", label: "占比", index: "zb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
            {
              name: "tb", label: "同比", index: "tb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ]
        }
      } else if (this.curClickType == 'ck') {
        if (this.curType == 'cksp') {
          return [
            { name: "bm", label: "编码", index: "ckspDm", width: 150, align: "left", sortable: false },
            { name: "mc", label: "名称", index: "ckspmc", width: 150, align: "left", sortable: false },
            { name: "scckrq", label: "首次出口日期", index: "scckrq", width: 120, align: "center", sortable: false },
            {
              name: "fzZckeRmb", label: "出口额", index: "fzZckeRmb", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "ckeZb", label: "出口额占比", index: "ckeZb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
            {
              name: "ckeTb", label: "出口额同比", index: "ckeTb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ]
        } else if (this.curType == 'ckkh') {
          return [
            { name: "mc", label: "客户名称", index: "mc", width: 150, align: "left", sortable: false },
            { name: "gmfGbdqMc", label: "贸易国别", index: "gmfGbdqMc", width: 150, align: "left", sortable: false },
            { name: "gmfSckprq", label: "首次出口日期", index: "gmfSckprq", width: 120, align: "center", sortable: false },
            {
              name: "fzZckeRmb", label: "出口额", index: "fzZckeRmb", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "ckeZb", label: "出口额占比", index: "ckeZb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
            {
              name: "ckeTb", label: "出口额同比", index: "ckeTb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ]
        } else {
          return [
            { name: "bm", label: "编码", index: "ckspDm", width: 150, align: "left", sortable: false },
            { name: "mc", label: "名称", index: "ckspmc", width: 150, align: "left", sortable: false },
            {
              name: "fzZckeRmb", label: "出口额", index: "fzZckeRmb", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
                if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
                return cellVal
              }
            },
            {
              name: "ckeZb", label: "出口额占比", index: "ckeZb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
            {
              name: "ckeTb", label: "出口额同比", index: "ckeTb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
                cellVal = cellVal ? cellVal : 0
                return cellVal + '%'
              }
            },
          ]
        }
      }
    },

    /**
     * 获取二级详情表格列配置
     * @returns {Array} 表格列配置数组
     */
    getColSecond() {
      if (this.curClickType == 'jh') {
        return [
          { name: "gyssbh", label: "供应商识别号", index: "gyssbh", width: 150, align: "left", sortable: false },
          { name: "gysmc", label: "供应商名称", index: "gysmc", width: 150, align: "left", sortable: false },
          { name: "sphfwssflhbbm", label: "税收分类编码", index: "sphfwssflhbbm", width: 150, align: "left", sortable: false },
          { name: "hwhyslwfwmc", label: "商品名称", index: "hwhyslwfwmc", width: 150, align: "left", sortable: false },
          {
            name: "fzZje", label: "金额", index: "fzZje", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
              cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
              if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
              return cellVal
            }
          },
          {
            name: "fzZse", label: "税额", index: "fzZse", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
              cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
              if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
              return cellVal
            }
          },
          {
            name: "jeZb", label: "占比", index: "jeZb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
              cellVal = cellVal ? cellVal : 0
              return cellVal + '%'
            }
          },
          {
            name: "jeTb", label: "同比", index: "jeTb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
              cellVal = cellVal ? cellVal : 0
              return cellVal + '%'
            }
          },
        ];
      } else if (this.curClickType == 'xs') {
        return [
          { name: "khmc", label: "客户名称", index: "khmc", width: 150, align: "left", sortable: false },
          { name: "sfjwkh", label: "是否境外客户", index: "sfjwkh", width: 100, align: "center", sortable: false },
          { name: "sphfwssflhbbm", label: "税收分类编码", index: "sphfwssflhbbm", width: 150, align: "left", sortable: false },
          { name: "hwhyslwfwmc", label: "商品名称", index: "hwhyslwfwmc", width: 150, align: "left", sortable: false },
          {
            name: "fzZje", label: "金额", index: "fzZje", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
              cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
              if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
              return cellVal
            }
          },
          {
            name: "fzZse", label: "税额", index: "fzZse", width: 120, align: "right", sortable: false, formatter: function (cellVal, op, row) {
              cellVal = cellVal === null || cellVal === '' ? '' : cellVal;
              if (cellVal) cellVal = avalon.filters.number(cellVal, 2);
              return cellVal
            }
          },
          {
            name: "jeZb", label: "占比", index: "jeZb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
              cellVal = cellVal ? cellVal : 0
              return cellVal + '%'
            }
          },
          {
            name: "jeTb", label: "同比", index: "jeTb", width: 100, align: "right", sortable: false, formatter: function (cellVal, op, row) {
              cellVal = cellVal ? cellVal : 0
              return cellVal + '%'
            }
          },
        ]
      }
    },

    /**
     * 初始化一级详情表格
     */
    initListTable: function () {
      var self = this;
      var tableColumns = this.getCol()
      $("#atfxtz-chart-first-table").jqGrid('clearGridData');
      $("#atfxtz-chart-first-table").jqGrid('GridUnload');
      $("#atfxtz-chart-first-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: tableColumns,
        viewrecords: true,
        rownumbers: true,
        pager: '#atfxtz-chart-first-tablePager',
        shrinkToFit: false,
        width: "100%",
        autowidth: true,
        altRows: true,
        altclass: "altclasscss",
        lastsort: 1,
        rownumWidth:60,
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".atfx-xq-list .form").height() - 60;
        })(),
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "atfxtz-chart-first-table");
          self.loadListData(pageNo);
        },
        beforeSelectRow: function (rowid, e) {
          if ($(e.target).hasClass("lookSecond")) {
            var row = $("#atfxtz-chart-first-table").jqGrid("getRowData", rowid);
            self.secondInfo = row;
            $(".atfx-chart .atfx-xq-list-inner").show();
            setTimeout(() => {
              self.initListTableSecond()
            }, 100);
          }
        }
      });
      self.loadListData(1);
    },

    /**
     * 初始化二级详情表格
     */
    initListTableSecond: function () {
      var self = this;
      var tableColumns = this.getColSecond()
      $("#atfxtz-chart-second-table").jqGrid('clearGridData');
      $("#atfxtz-chart-second-table").jqGrid('GridUnload');
      $("#atfxtz-chart-second-table").jqGrid({
        datatype: "local",
        gridview: true,
        colModel: tableColumns,
        viewrecords: true,
        rownumbers: true,
        pager: '#atfxtz-chart-second-tablePager',
        shrinkToFit: false,
        width: "100%",
        autowidth: true,
        altRows: true,
        rownumWidth:60,
        altclass: "altclasscss",
        lastsort: 1,
        rowNum: config.pageSize,
        rowList: [20, 50, 100, 500],
        height: (function () {
          return $(".atfx-xq-list-inner .form").height() - 60;
        })(),
        onPaging: function (pgButton) {
          var pageNo = tools.getPageNo(pgButton, "atfxtz-chart-second-table");
          self.loadListDataSecond(pageNo);
        }
      });
      self.loadListDataSecond(1);
    },

    /**
     * 加载二级详情数据
     * @param {Number} pageNo - 页码
     */
    loadListDataSecond: function (pageNo) {
      var self = this;
      var pageSize = $(".ui-pg-selbox", $('.atfx-chart .atfx-xq-list-inner')).val() || config.pageSize;
      var params = {
        pageSize: pageSize,
        pageNo: pageNo,
        uuid: self.uuid,
        fxqq: self.historyData.fxqq ? self.historyData.fxqq + '-01' : '',
        fxqz: self.historyData.fxqz ? self.historyData.fxqz + '-' + self.getLastDayOfMonth(self.historyData.fxqz) : ''
      };
      let d = self.listInfoSecond[self.curClickType][self.curType]
      if (d.otherParams) {
        params = Object.assign(params, d.otherParams)
      }
      if (d.otherKey) {
        params[d.otherKey] = self.secondInfo[d.otherKey]
      }
      ajax("POST", d.url, params).done(function (res) {
        if (res.code == '0') {
          $("#atfxtz-chart-second-table").resetSelection();
          $("#atfxtz-chart-second-table")[0].addJSONData(res.data);
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info("数据加载失败");
      });
    },

    /**
     * 加载一级详情数据
     * @param {Number} pageNo - 页码
     */
    loadListData: function (pageNo) {
      var self = this;
      var pageSize = $(".ui-pg-selbox", $('.atfx-chart .atfx-xq-list')).val() || config.pageSize;
      var params = {
        pageSize: pageSize,
        pageNo: pageNo,
        uuid: self.uuid,
        fxqq: self.historyData.fxqq ? self.historyData.fxqq + '-01' : '',
        fxqz: self.historyData.fxqz ? self.historyData.fxqz + '-' + self.getLastDayOfMonth(self.historyData.fxqz) : ''
      };
      if (self.curClickType == 'ck') {
        params.type = self.curType
      }
      let d = self.listInfo[self.curClickType][self.curType]
      if (d.otherParams) {
        params = Object.assign(params, d.otherParams)
      }
      ajax("POST", d.url, params).done(function (res) {
        if (res.code == '0') {
          $("#atfxtz-chart-first-table").resetSelection();
          $("#atfxtz-chart-first-table")[0].addJSONData(res.data);
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info("数据加载失败");
      });
    },

    /**
     * 隐藏一级详情弹窗
     */
    hideModelFirst() {
      $(".atfx-chart .atfx-xq-list").hide();
    },

    /**
     * 隐藏二级详情弹窗
     */
    hideModelSecond() {
      $(".atfx-chart .atfx-xq-list-inner").hide();
    },

    /**
     * 查看详情
     * @param {Object} item - 详情项配置
     */
    goDetail(item) {
      this.curDialogTitle = item.label + '信息'
      this.curClickType = item.key
      $(".model").show();
      $(".atfx-chart .atfx-jh-model").show();
      this.showChart = true
      setTimeout(() => {
        components[item.key + 'LineChart'].search()
        components[item.key + 'PieChart'].search()
        if (item.key == 'jh') {
          components[item.key + 'LineChartFw'].search()
        }
      }, 100)
    },

    /**
     * 隐藏详情弹窗
     */
    hideModel() {
      this.showChart = false
      $(".model").hide();
      $(".atfx-chart .atfx-jh-model").hide();
    },

    /**
     * 搜索数据并生成图表
     * @param {String} type - 搜索类型，'py'表示平移
     */
    search(type) {
      var self = this;
      if (!self.searchData.fxqq) {
        tools.info('请选择案头分析期起日期！');
        return
      }
      if (!self.searchData.fxqz) {
        tools.info('请选择案头分析期止日期！');
        return
      }
      if (self.searchData.fxqq > self.searchData.fxqz) {
        tools.info('案头分析期起不能大于案头分析期止！');
        return
      }
      let selfParamList = []
      if (type !== 'py') {
        self.historyData = tools.clone(self.searchData)
      }
      let searchData = {}
      if (type === 'py') {
        searchData = tools.clone(self.historyData)
      } else {
        searchData = tools.clone(self.historyData)
      }
      for (let i in self.chartDataControls) {
        selfParamList.push({
          type: self.chartDataControls[i].key,
          paramInfo: {
            pyl:-1 * self.chartDataControls[i].offset
          }
        })
      }
      let params = {
        fxqq: searchData.fxqq + '-01',
        fxqz: searchData.fxqz + '-' + self.getLastDayOfMonth(searchData.fxqz),
        hzwd: searchData.hzwd,
        uuid: self.uuid,
        selfParamList
      };
      ajax("POST", "/cxfw/atfx/jyqk/gyxx", params).done(function (res) {
        if (res.code == '0') {
          self.setChartData(res.data, searchData);
          self.chartInit()
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    },

    /**
     * 格式化日期字符串为年月格式
     * @param {String} dateString - 日期字符串
     * @returns {String} 年月格式的日期字符串
     */
    getYearMonth: function (dateString) {
      if (!dateString) return '';
      if (/^\d{4}-\d{2}$/.test(dateString)) {
        return dateString;
      }
      if (/^\d{4}-\d{2}-\d{2}$/.test(dateString)) {
        return dateString.substring(0, 7);
      }
      return '';
    },

    /**
     * 设置图表数据
     * @param {Object} data - 图表原始数据
     * @param {Object} searchData - 搜索条件
     */
    setChartData(data, searchData) {
      this.chartData = {
        months: [],
        series: {}
      }
      let m = this.getMonthsBetween(searchData.fxqq, searchData.fxqz, searchData.hzwd)
      for (let i in data) {
        let arr = []
        for (let j in data[i].qssjMetaList) {
          arr.push(data[i].qssjMetaList[j].tjjg)
        }
        this.chartData.series[data[i].type] = arr
        this.chartData.months = m
      }
    },

    /**
     * 获取指定年月的最后一天
     * @param {String} dateString - 年月字符串，格式为YYYY-MM
     * @returns {Number} 该月的天数
     */
    getLastDayOfMonth(dateString) {
      const [year, month] = dateString.split('-').map(Number);
      return new Date(year, month, 0).getDate();
    },

    /**
     * 获取两个日期之间的所有月份
     * @param {String} startDate - 开始日期
     * @param {String} endDate - 结束日期
     * @param {String} mode - 模式：'y'-按月、'j'-按季度、'n'-按年
     * @returns {Array} 日期数组
     */
    getMonthsBetween(startDate, endDate, mode = 'y') {
      const result = [];
      const formatStartDate = this.getYearMonth(startDate);
      const formatEndDate = this.getYearMonth(endDate);
      if (!formatStartDate || !formatEndDate) {
        return result;
      }
      const [startYear, startMonth] = formatStartDate.split('-').map(Number);
      const [endYear, endMonth] = formatEndDate.split('-').map(Number);
      let currentYear = startYear;
      let currentMonth = startMonth;
      while (currentYear < endYear || (currentYear === endYear && currentMonth <= endMonth)) {
        let periodStr = '';
        switch (mode) {
          case 'n':
            periodStr = `${currentYear}`;
            currentYear++;
            currentMonth = startMonth;
            if (result.includes(periodStr)) {
              continue;
            }
            break;
          case 'j':
            const quarter = Math.ceil(currentMonth / 3);
            periodStr = `${currentYear}-Q${quarter}`;
            currentMonth = quarter * 3 + 1;
            if (currentMonth > 12) {
              currentMonth = 1;
              currentYear++;
            }
            if (result.includes(periodStr)) {
              continue;
            }
            break;
          case 'y':
          default:
            periodStr = `${currentYear}-${currentMonth.toString().padStart(2, '0')}`;
            currentMonth++;
            if (currentMonth > 12) {
              currentMonth = 1;
              currentYear++;
            }
            break;
        }
        result.push(periodStr);
      }
      return result;
    },

    /**
     * 初始化图表
     */
    chartInit() {
      this.initChartDataControls();
      var self = this;
      setTimeout(function () {
        self.initChart();
        setTimeout(function () {
          if (self.businessChart && typeof self.businessChart.resize === 'function') {
            try {
              self.businessChart.resize();
            } catch (e) {
              console.warn('图表调整大小出错:', e);
            }
          }
        }, 100);
      }, 200);
    },

    /**
     * 检查图表实例是否有效
     * @returns {Boolean} 图表实例是否有效
     */
    isChartValid: function () {
      try {
        return this.businessChart &&
          typeof this.businessChart.getOption === 'function' &&
          typeof this.businessChart.setOption === 'function' &&
          typeof this.businessChart.dispose === 'function';
      } catch (e) {
        return false;
      }
    },

    /**
     * 销毁图表实例
     */
    disposeChart: function () {
      if (this.businessChart) {
        try {
          if (this.businessChart.dispose && typeof this.businessChart.dispose === 'function') {
            this.businessChart.dispose();
          }
        } catch (e) {
          console.warn('图表销毁出错:', e);
          try {
            if (this.businessChart.off && typeof this.businessChart.off === 'function') {
              this.businessChart.off();
            }
          } catch (e2) {
            console.warn('图表事件清理出错:', e2);
          }
        } finally {
          this.businessChart = null;
        }
      }
    },

    /**
     * 对数据应用偏移量
     * @param {Array} data - 原始数据
     * @param {Number} offset - 偏移量
     * @returns {Array} 应用偏移后的数据
     */
    applyOffset: function (data, offset) {
      return data.slice();
    },

    /**
     * 初始化ECharts图表
     */
    initChart: function () {
      if (typeof echarts !== 'undefined') {
        var chartDom = document.getElementById('businessChart');
        if (!chartDom) {
          console.warn('图表容器未找到');
          return;
        }
        this.disposeChart();
        try {
          var myChart = echarts.init(chartDom);
          this.businessChart = myChart;
          var legendData = [];
          var selected = {};
          var series = [];
          var seriesColors = {
            '进货(货物)': '#5470c6',
            '进货(服务)': '#91cc75',
            '出口': '#fac858',
            '销售(内销)': '#ee6666',
            '销售(外销)': '#73c0de',
            '退税': '#3ba272',
            '收汇': '#fc8452'
          };
          for (var i = 0; i < this.chartDataControls.length; i++) {
            var control = this.chartDataControls[i];
            if (control.key === 'jh') {
              var seriesName1 = this.getSeriesNameByKey('jh-hw');
              legendData.push(seriesName1);
              selected[seriesName1] = control.visible;
              var seriesName2 = this.getSeriesNameByKey('jh-fw');
              legendData.push(seriesName2);
              selected[seriesName2] = control.visible;
            } else if (control.key === 'xs') {
              var seriesName1 = this.getSeriesNameByKey('xs-nx');
              legendData.push(seriesName1);
              selected[seriesName1] = control.visible;
              var seriesName2 = this.getSeriesNameByKey('xs-wx');
              legendData.push(seriesName2);
              selected[seriesName2] = control.visible;
            } else {
              var seriesName = this.getSeriesNameByKey(control.key);
              legendData.push(seriesName);
              selected[seriesName] = control.visible;
            }
            var checkbox = document.getElementById('chart-control-' + i);
            if (checkbox) {
              checkbox.checked = control.visible;
            }
          }
          var chartType = this.searchData.chartType === 'line' ? 'line' : 'bar';
          if (this.chartDataControls[0].visible) {
            series.push({
              name: '进货(货物)',
              type: chartType,
              data: this.applyOffset(this.chartData.series['jh-hw'], this.chartDataControls[0].offset),
              itemStyle: { color: seriesColors['进货(货物)'] }
            });
            series.push({
              name: '进货(服务)',
              type: chartType,
              data: this.applyOffset(this.chartData.series['jh-fw'], this.chartDataControls[0].offset),
              itemStyle: { color: seriesColors['进货(服务)'] }
            });
          }
          if (this.chartDataControls[1].visible) {
            series.push({
              name: '出口',
              type: chartType,
              data: this.applyOffset(this.chartData.series.ck, this.chartDataControls[1].offset),
              itemStyle: { color: seriesColors['出口'] }
            });
          }
          if (this.chartDataControls[2].visible) {
            series.push({
              name: '销售(内销)',
              type: chartType,
              data: this.applyOffset(this.chartData.series['xs-nx'], this.chartDataControls[2].offset),
              itemStyle: { color: seriesColors['销售(内销)'] }
            });
            series.push({
              name: '销售(外销)',
              type: chartType,
              data: this.applyOffset(this.chartData.series['xs-wx'], this.chartDataControls[2].offset),
              itemStyle: { color: seriesColors['销售(外销)'] }
            });
          }
          if (this.chartDataControls[3].visible) {
            series.push({
              name: '退税',
              type: chartType,
              data: this.applyOffset(this.chartData.series.ts, this.chartDataControls[3].offset),
              itemStyle: { color: seriesColors['退税'] }
            });
          }
          if (this.chartDataControls[4].visible) {
            series.push({
              name: '收汇',
              type: chartType,
              data: this.applyOffset(this.chartData.series.sh, this.chartDataControls[4].offset),
              itemStyle: { color: seriesColors['收汇'] }
            });
          }
          var option = {
            title: {
              text: '企业经营数据分析'
            },
            tooltip: {
              trigger: 'axis',
              show: true,
              showContent: true,
              alwaysShowContent: false,
              triggerOn: 'mousemove|click',
              confine: true,
              backgroundColor: 'rgba(50,50,50,0.7)',
              textStyle: {
                color: '#fff',
                fontSize: 12
              }
            },
            legend: {
              data: legendData,
              selected: selected
            },
            grid: {
              left: '3%',
              right: '4%',
              bottom: '3%',
              containLabel: true
            },
            xAxis: {
              type: 'category',
              boundaryGap: false,
              data: this.chartData.months
            },
            yAxis: {
              type: 'value',
              name: '元',
              nameLocation: 'end',
              nameGap: 15
            },
            series: series
          };
          myChart.setOption(option);
        } catch (e) {
          console.error('图表初始化出错:', e);
          this.businessChart = null;
        }
      }
    },

    /**
     * 切换图表数据显示/隐藏状态
     * @param {Number} index - 控制项索引
     * @param {String} key - 控制项键名
     * @param {Event} event - 事件对象
     */
    toggleChartData: function (index, key, event) {
      var self = this;
      if (event && event.stopPropagation) {
        event.stopPropagation();
      }
      var newState = !this.chartDataControls[index].visible;
      this.chartDataControls[index].visible = newState;
      var checkbox = document.getElementById('chart-control-' + index);
      if (checkbox) {
        checkbox.checked = newState;
      }
      setTimeout(function () {
        self.reRenderChart();
      }, 50);
    },

    /**
     * 初始化图表数据控制项
     */
    initChartDataControls: function () {
      if (!this.chartDataControls || this.chartDataControls.length === 0) {
        this.chartDataControls = [
          { key: 'jh', label: '进货', visible: true, offset: 0 },
          { key: 'ck', label: '出口', visible: true, offset: 0 },
          { key: 'xs', label: '销售', visible: true, offset: 0 },
          { key: 'ts', label: '退税', visible: true, offset: 0 },
          { key: 'sh', label: '收汇', visible: true, offset: 0 },
        ];
      }
      for (var i = 0; i < this.chartDataControls.length; i++) {
        if (this.chartDataControls[i].visible === undefined) {
          this.chartDataControls[i].visible = true;
        }
        if (this.chartDataControls[i].offset === undefined) {
          this.chartDataControls[i].offset = 0;
        }
      }
    },

    /**
     * 重新渲染图表
     */
    reRenderChart: function () {
      if (this.businessChart) {
        try {
          this.disposeChart();
        } catch (e) {
          console.warn('图表销毁出错:', e);
        }
      }
      var self = this;
      setTimeout(function () {
        self.initChart();
      }, 50);
    },

    /**
     * 根据键名获取系列名称
     * @param {String} key - 键名
     * @returns {String} 系列名称
     */
    getSeriesNameByKey: function (key) {
      var nameMap = {
        'jh-hw': '进货(货物)',
        'jh-fw': '进货(服务)',
        'ck': '出口',
        'xs-nx': '销售(内销)',
        'xs-wx': '销售(外销)',
        'ts': '退税',
        'sh': '收汇'
      };
      return nameMap[key] || '';
    },

    /**
     * 向前平移月份
     * @param {Number} index - 控制项索引
     */
    prevMonth: function (index) {
      if (index !== undefined) {
        this.updateChartData(-1, index);
      } else {
        this.updateChartData(-1);
      }
    },

    /**
     * 向后平移月份
     * @param {Number} index - 控制项索引
     */
    nextMonth: function (index) {
      if (index !== undefined) {
        this.updateChartData(1, index);
      } else {
        this.updateChartData(1);
      }
    },

    /**
     * 更新图表数据（平移）
     * @param {Number} monthOffset - 月份偏移量
     * @param {Number} index - 控制项索引
     */
    updateChartData: function (monthOffset, index) {
      if (index !== undefined) {
        this.chartDataControls[index].offset += monthOffset;
        this.search('py')
      } else {
        if (this.businessChart) {
          var option = this.businessChart.getOption();
          this.businessChart.setOption(option);
        }
      }
    },
  }
})