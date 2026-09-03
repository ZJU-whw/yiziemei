var atfxmx = require("./atfxmx.html");
avalon.component('atfxmx', {
  template: atfxmx,
  defaults: {
    params: {
      uuid:'',
      startDate:'',
      endDate:'',
      djxh:'',
      fxqq:'',
      fxqz:'',
      nsrmc:'',
      nsrsbh:'',
      atfxrqqz:'',
      swjgDm:'',
      ckhwtmsjsffDm:''  // 出口货物劳务计税方法代码
    },
    // 记录tab是否已初始化
    sjcxInited: false,
    ydyxInited: false,
    fxfxbgInited: false,
    onInit(e) {
      components.atfxmx = e.vmodel;
    },
    onReady: function() {
      // 页面加载时初始化数据查询组件，避免后续跳转时报错
      var self = this;
      setTimeout(function() {
        if (components.atfxzycx) {
          components.atfxzycx.init();
          self.sjcxInited = true;
        }
        // 预加载风险分析报告
        if (components.fxfxbg) {
          components.fxfxbg.init();
          self.fxfxbgInited = true;
        }
      }, 500);
    },
    tabList: [
      { name: '企业基本情况', activeName: 'qyjbqk' },
      { name: '企业经营分析', activeName: 'qyjyfx'},
      // { name: '疑点分析指引', activeName: 'nddxsj', isFirst: true, columns: 'nddxsjColumns', url: '/sszj/zbdata/zbu4year', isPager: false, tabNum: '3', hasTotal: false },
      // { name: '风险分析报告', activeName: 'ackgb', isFirst: true, columns: 'ackgbColumns', url: '/sszj/zbdata/ckgb', isPager: true, tabNum: '4', hasTotal: true },
      { name: '数据查询', activeName: 'atfxSjcx' },
      { name: '疑点分析', activeName: 'atfxYdyx' },
      { name: '风险分析报告', activeName: 'fxfxbg' },
    ],
    activeName: 'qyjbqk',
    changeTab: function (activeName, index, tabNum) {
      var self = this;
      this.activeName = activeName;
      this.tabNum = tabNum;
      
      // 确保 tab 元素存在后再获取位置
      var $tabElement = $('.' + activeName);
      if ($tabElement.length > 0) {
        this.activeBarX = $tabElement.position().left + 10;
        this.activeBarWidth = $tabElement.outerWidth() - 20;
      }
      
      var item = this.tabList[index];

      if (item.activeName === 'qyjyfx') {
        components.atfxCharts.search();
      }
      if (item.activeName === 'atfxSjcx') {
        // 只在第一次点击时初始化，后续只调整高度
        if (!self.sjcxInited) {
          components.atfxzycx.init();
          self.sjcxInited = true;
        } else {
          components.atfxzycx.changeH();
        }
      }
      if (item.activeName === 'atfxYdyx') {
        // 只在第一次点击时初始化，后续只调整高度
        if (!self.ydyxInited) {
          components.atfxydyx.init();
          self.ydyxInited = true;
        } else {
          components.atfxydyx.changeH();
        }
      }
      // 风险分析报告 - 已改为预加载，此处保留兼容
      if (item.activeName === 'fxfxbg') {
        if (!self.fxfxbgInited) {
          components.fxfxbg.init();
          self.fxfxbgInited = true;
        }
      }
      if (item.isFirst) {
        this.tabList[index].isFirst = false;
      }
    },
  }
});