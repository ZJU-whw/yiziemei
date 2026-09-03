var bgdDetailTpl = require("./bgdDetail.html");
require("./bgdDetail.css");

avalon.component('bgdDetail', {
  template: bgdDetailTpl,
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
        self.instanceId = 'bgd-detail-' + Date.now();
      }
      // 注册到全局 components，供其他组件调用
      components['bgdDetail' + self.instanceId] = self;
    },

    // 显示报关单预览弹框
    showModel: function (bgdData) {
      var d = bgdData || {};
      var rows = (d.hwxxs || []).slice();
      // 至少补足 5 行，保持表格样式
      var padLen = 5 - rows.length;
      for (var i = 0; i < padLen; i++) {
        rows.push({});
      }
      this.info = d;
      this.hwxxs = rows;
      this.visible = true;
    },

    closeModel: function () {
      this.visible = false;
    }
  }
});
