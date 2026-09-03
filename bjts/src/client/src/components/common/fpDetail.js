var fpDetailTpl = require("./fpDetail.html");
require("./fpDetail.css");

function fmtNum(v) {
  if (v === undefined || v === null || v === '') return '';
  return avalon.filters.number(v, 2);
}

avalon.component('fpDetail', {
  template: fpDetailTpl,
  defaults: {
    // 外部传入参数：实例唯一标识
    instanceId: '',
    // 内部状态
    visible: false,
    info: {},
    hwxxs: [],
    onReady: function () {
      var self = this;
      if (!self.instanceId) {
        self.instanceId = 'fp-detail-' + Date.now();
      }
      // 注册到全局 components，供本页面调用
      components['fpDetail' + self.instanceId] = self;
    },

    // 显示发票预览弹框
    showModel: function (fpData) {
      var d = fpData || {};
      var skfhr = '';
      if (d.skr) skfhr += '收款人：' + d.skr + ';';
      if (d.fhr) skfhr += '复核人：' + d.fhr + ';';

      this.info = {
        fphm: d.fphm || '',
        kprq: d.kprq || '',
        gfmc: d.gfmc || '',
        gfsbh: d.gfsbh || '',
        xfmc: d.xfmc || '',
        xfsbh: d.xfsbh || '',
        kpr: d.kpr || '',
        bz: d.bz || '',
        skfhr: skfhr,
        jshjZh: (d.jshj !== undefined && d.jshj !== null && d.jshj !== '') ? tools.Num2CN(d.jshj) : '',
        jshj: fmtNum(d.jshj),
        je: (d.je !== undefined && d.je !== null && d.je !== '') ? ('¥' + fmtNum(d.je)) : '',
        se: (d.se === undefined || d.se === null || d.se === '') ? '' : ((d.se == '0' || d.se == 0) ? '***' : ('¥' + fmtNum(d.se)))
      };

      var rows = [];
      var hwxxs = d.hwxxs || [];
      for (var m = 0; m < hwxxs.length; m++) {
        var h = hwxxs[m];
        rows.push({
          hwmc: h.hwmc || '',
          ggxh: h.ggxh || '',
          dw: h.dw || '',
          sl: h.sl || '',
          dj: h.dj || '',
          je: fmtNum(h.je),
          se: (h.se == '0' || h.se == 0) ? '***' : fmtNum(h.se),
          slv: (h.slv === undefined || h.slv === null || h.slv === '') ? '' : ((h.slv == 0 || h.slv == '0') ? '免税' : (h.slv * 100 + '%'))
        });
      }
      // 不足 8 行时补足空行，保持票样
      var restLen = hwxxs.length > 7 ? 0 : 8 - hwxxs.length;
      for (var j = 0; j < restLen; j++) {
        rows.push({});
      }
      this.hwxxs = rows;
      this.visible = true;
    },

    closeModel: function () {
      this.visible = false;
    }
  }
});
