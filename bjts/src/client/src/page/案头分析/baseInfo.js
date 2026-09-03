var baseInfo = require("./baseInfo.html");
avalon.component('baseInfo', {
  template: baseInfo,
  defaults: {
    uuid: '',
    // 企业基本情况 start
    showAllgd: false,
    showAllJcxx: false,
    showAllSy: false,
    showAllJcla: false,
    showAllSwxz: false,

    bgdTableV: true,
    jcxxTableV: true,
    syTableV: true,
    jclaTableV: true,
    swxzTableV: true,

    showAllgdList: [],
    showAllJcxxList: [],
    showAllSyList: [],
    showAllJclaList: [],
    showAllSwxzList: [],
    showUniversalPopover: false,
    popoverTimer: null,
    popoverPosition: {
      top: 0,
      left: 0
    },
    curPopoverKey: '',
    info: {

    },
    syqyxx: [1, 2, 3],
    popoverData: [],
    currentField: '',
    onReady: function () {
      this.getBaseInfo();
    },
    isShowNum(key) {
      if (this.info && this.info.lsjlMeta && this.info.lsjlMeta.bgjlUnitMap && this.info.lsjlMeta.bgjlUnitMap[key] && this.info.lsjlMeta.bgjlUnitMap[key].allSize > 0) {
        return true;
      }
      return false;
    },
    isShow(key) {
      if (key === 'flgldj' || key === 'ybnsrrdsj') {
        if (this.info && this.info.lsjlMeta && this.info.lsjlMeta && this.info.lsjlMeta[key] && this.info.lsjlMeta[key].allSize > 0) {
          return true;
        }
      } else {
        if (this.info && this.info.lsjlMeta && this.info.lsjlMeta.bgjlUnitMap && this.info.lsjlMeta.bgjlUnitMap[key] && this.info.lsjlMeta.bgjlUnitMap[key].allSize > 0) {
          return true;
        }
        return false
      }
    },
    getNum(key) {
      if (key === 'flgldj' || key === 'ybnsrrdsj') {
        if (this.info && this.info.lsjlMeta && this.info.lsjlMeta && this.info.lsjlMeta[key] && this.info.lsjlMeta[key].allSize > 0) {
          return `(${this.info.lsjlMeta[key].allSize}次)`;
        }
      } else {
        if (this.info && this.info.lsjlMeta && this.info.lsjlMeta.bgjlUnitMap && this.info.lsjlMeta.bgjlUnitMap[key] && this.info.lsjlMeta.bgjlUnitMap[key].allSize > 0) {
          return `(${this.info.lsjlMeta.bgjlUnitMap[key].allSize}次)`;
        }
        return ''
      }
    },
    formatMoney(num) {
      num = num === null || num === '' ? '' : num;
      if (num) num = avalon.filters.number(num, 2);
      return num
    },
    getBaseInfo() {
      var self = this;
      var params = {
        uuid: self.uuid,
        selAttrCount: '1'
      }
      ajax("POST", "/cxfw/atfx/qyjbxx/meta", params).done(function (res) {
        if (res.code == '0') {
          if (res.data) {
            self.info = res.data;

          }
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    },
    showUniversalPopoverHandler: function (event, field) {
      var self = this;
      // 清除之前的定时器
      if (this.popoverTimer) {
        clearTimeout(this.popoverTimer);
        this.popoverTimer = null;
      }

      // 如果popover已经显示且是同一个字段，则直接返回
      if (this.showUniversalPopover && this.currentField === field) {
        return;
      }

      // 设置延迟显示
      this.popoverTimer = setTimeout(function () {
        // 根据字段获取对应的历史数据
        self.loadHistoryData(field);

        // 计算popover位置并确保不超出视口
        var target = event.target;
        var rect = target.getBoundingClientRect();

        // 获取视口尺寸
        var viewportWidth = window.innerWidth || document.documentElement.clientWidth;
        var viewportHeight = window.innerHeight || document.documentElement.clientHeight;

        // popover的预估尺寸
        var popoverWidth = 400;
        var popoverHeight = 200;

        // 计算popover的理想位置
        var popoverTop = rect.top + window.scrollY;
        var popoverLeft = rect.right + window.scrollX + 5;

        // 如果右侧空间不足，尝试显示在左侧
        if (popoverLeft + popoverWidth > viewportWidth) {
          popoverLeft = rect.left + window.scrollX - popoverWidth - 5;
          if (popoverLeft < 0) {
            popoverLeft = Math.max(5, viewportWidth - popoverWidth - 5);
          }
        }

        // 垂直居中对齐
        popoverTop = rect.top + window.scrollY + (rect.height / 2) - (popoverHeight / 2);

        // 边界检测和调整
        if (popoverTop + popoverHeight > viewportHeight + window.scrollY) {
          popoverTop = viewportHeight + window.scrollY - popoverHeight - 5;
        }

        if (popoverTop < window.scrollY) {
          popoverTop = window.scrollY + 5;
        }

        self.popoverPosition = {
          top: popoverTop,
          left: popoverLeft
        };

        // 显示popover
        self.showUniversalPopover = true;
        self.currentField = field;
      }, 400);
    },

    // 隐藏popover
    hideUniversalPopover: function () {
      // 清除定时器
      if (this.popoverTimer) {
        clearTimeout(this.popoverTimer);
        this.popoverTimer = null;
      }

      // 设置延迟隐藏，以便检查鼠标是否移入popover
      this.popoverTimer = setTimeout(() => {
        this.showUniversalPopover = false;
      }, 200);
    },

    // 根据字段加载历史数据
    loadHistoryData: function (field) {
      this.curPopoverKey = field
      if (field === 'flgldj' || field === 'ybnsrrdsj') {
        this.popoverData = this.info.lsjlMeta[field].list
      } else {
        this.popoverData = this.info.lsjlMeta.bgjlUnitMap[field].list
      }
    },
    // 清除popover计时器
    clearPopoverTimer: function () {
      if (this.popoverTimer) {
        clearTimeout(this.popoverTimer);
        this.popoverTimer = null;
      }
    },
    changTable: function (key, tableKey) {
      this[tableKey] = false
      this[key] = !this[key];
      if (this[key]) {
        this.getList(key)
      }
      this[tableKey] = true
    },
    getList(key) {
      let url = {
        'showAllgd': '/cxfw/atfx/qyjbxx/gdxx',
        'showAllJcxx': '/cxfw/atfx/qyjbxx/bgxx',
        'showAllSy': '/cxfw/atfx/qyjbxx/sygl',
        'showAllJcla': '/cxfw/atfx/qyjbxx/jcla',
        'showAllSwxz': '/cxfw/atfx/qyjbxx/xzcf',
      }
      var self = this;
      if (self[key + 'List'] && self[key + 'List'].length) {
        return
      }
      let params = {
        uuid: self.uuid
      }
      ajax("POST", url[key], params).done(function (res) {
        if (res.code == '0') {
          if (res.data) {
            self[key + 'List'] = res.data;
          }
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    }
    // 企业基本情况 END
  }
})