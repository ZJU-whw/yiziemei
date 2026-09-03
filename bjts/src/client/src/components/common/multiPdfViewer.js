var multiPdfViewer = require("./multiPdfViewer.html");
require("./multiPdfViewer.css");

avalon.component('multiPdfViewer', {
  template: multiPdfViewer,
  defaults: {
    pdfContainerId: '',
    title: 'PDF预览',
    pdfList: [],
    panelList: [],
    treeData: [],
    treeFileList: [],
    detailInfo: {},
    viewMode: 'edit',
    activeIndex: 0,
    layoutCount: 1,
    layoutStorageKey: 'multiPdfViewer.layoutCount',
    treeCollapsed: false,
    fullscreenPanelIndex: -1,
    renderTimer: null,
    dragMaskTimer: null,
    toastTimer: null,
    dragState: null,
    justDragged: false,
    ctrlWheelGuard: null,
    onRemarkSave: null,

    onReady: function () {
      var self = this;
      if (!self.pdfContainerId) {
        self.pdfContainerId = 'multi-pdf-viewer-container-' + Date.now();
      }
      components['multiPdfViewer' + self.pdfContainerId] = self;
    },

    // 兼容旧入口：调用方已经拿到 PDF 流时，直接传文件列表打开预览。
    showPdfs: function (files, title, activeEdocId, detailInfo, mode, onRemarkSave) {
      var self = this;
      self.clearUrls();
      self.treeData = [];
      self.treeFileList = [];
      self.detailInfo = detailInfo || {};
      self.viewMode = self.resolveViewMode(mode, self.detailInfo);
      self.onRemarkSave = typeof onRemarkSave == 'function' ? onRemarkSave : null;
      self.pdfList = self.normalizeFiles(files, false);
      if (!self.pdfList.length) {
        tools.info('未获取到文件信息');
        return;
      }
      self.title = title || 'PDF预览';
      self.activeIndex = self.getActiveIndex(activeEdocId);
      self.layoutCount = self.getSavedLayoutCount();
      self.fullscreenPanelIndex = -1;
      $('.' + self.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-overlay').show();
      $('.' + self.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-model').show();
      self.refreshPanels();
      self.bindPanelEvents();
      self.bindLayoutEvents();
      self.bindCtrlWheelGuard();
      self.renderTreeHtml();
      self.renderBusinessInfo();
    },

    // 主入口：调用方只传整棵单证树；组件内部负责展平树、请求 PDF、渲染左树和右侧分屏。
    showTreePdfs: function (treeData, title, activeEdocId, apiUrl, detailInfo, mode, onRemarkSave) {
      var self = this;
      var files = self.flattenTreeFiles(treeData);
      if (!files.length) {
        tools.info('未获取到文件信息');
        return;
      }
      var requests = [];
      var viewApi = apiUrl || 'dzbaFileViewPdf';
      for (var i = 0; i < files.length; i++) {
        requests.push(self.getPdfFile(files[i], viewApi));
      }
      $.when.apply($, requests).done(function () {
        var pdfFiles = [];
        var args = files.length === 1 ? [arguments] : arguments;
        for (var i = 0; i < args.length; i++) {
          var item = args[i];
          if (item && item[0]) {
            pdfFiles.push(item[0]);
          } else if (item) {
            pdfFiles.push(item);
          }
        }
        self.clearUrls();
        self.treeData = treeData || [];
        self.treeFileList = files;
        self.detailInfo = detailInfo || {};
        self.viewMode = self.resolveViewMode(mode, self.detailInfo);
        self.onRemarkSave = typeof onRemarkSave == 'function' ? onRemarkSave : null;
        self.pdfList = self.normalizeFiles(pdfFiles, true);
        self.title = title || 'PDF预览';
        self.activeIndex = self.getActiveIndex(activeEdocId);
        self.layoutCount = self.getSavedLayoutCount();
        self.treeCollapsed = false;
        self.fullscreenPanelIndex = -1;
        $('.' + self.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-overlay').show();
        $('.' + self.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-model').show();
        self.refreshPanels();
        self.bindPanelEvents();
        self.bindLayoutEvents();
        self.bindCtrlWheelGuard();
        self.renderTreeHtml();
        self.renderBusinessInfo();
      });
    },

    // 从核查单证树中提取所有 checked 单证类型下的文件，并记录所属分类/单证类型名称。
    flattenTreeFiles: function (treeData) {
      var files = [];
      var map = {};
      var list = treeData || [];
      for (var i = 0; i < list.length; i++) {
        var items = list[i].item || [];
        for (var j = 0; j < items.length; j++) {
          if (!items[j].checked) {
            continue;
          }
          var fileInfos = items[j].fileInfos || [];
          for (var k = 0; k < fileInfos.length; k++) {
            var file = fileInfos[k];
            var key = file.edocId || (file.title + '_' + i + '_' + j + '_' + k);
            if (!map[key]) {
              map[key] = true;
              file.typeName = items[j].name;
              file.groupName = list[i].name;
              files.push(file);
            }
          }
        }
      }
      return files;
    },

    // 根据 edocId 调后端接口获取单个 PDF 的 base64 文件流；未取到流时也返回文件占位，避免整批预览被打断。
    getPdfFile: function (file, apiUrl) {
      var deferred = $.Deferred();
      file = file || {};
      var params = {
        bizType: 'inspect',
        bizKey: file.edocId
      };
      api[apiUrl](params, true).done(function (res) {
        if (res.code == 0 && res.data && res.data.fileStream) {
          deferred.resolve({
            edocId: file.edocId,
            title: file.title,
            groupName: file.groupName,
            typeName: file.typeName,
            remark: file.remark || '',
            fileStream: res.data.fileStream
          });
        } else {
          deferred.resolve({
            edocId: file.edocId,
            title: file.title,
            groupName: file.groupName,
            typeName: file.typeName,
            remark: file.remark || '',
            noFile: true
          });
        }
      }).fail(function () {
        deferred.resolve({
          edocId: file.edocId,
          title: file.title,
          groupName: file.groupName,
          typeName: file.typeName,
          remark: file.remark || '',
          noFile: true
        });
      });
      return deferred.promise();
    },

    // 把 base64 PDF 转成浏览器可预览的 blob URL；没有流的文件保留为 noFile 占位标签。
    normalizeFiles: function (files, keepMissing) {
      var result = [];
      var list = files || [];
      for (var i = 0; i < list.length; i++) {
        var item = list[i] || {};
        var fileStream = item.fileStream || item.fileData || item.data || '';
        if (!fileStream) {
          if (!keepMissing) {
            continue;
          }
          result.push({
            edocId: item.edocId,
            title: item.title || item.name || ('文件' + (result.length + 1)),
            remark: item.remark || '',
            noFile: true
          });
          continue;
        }
        var pdfBlob = tools.dataURLtoBlob('data:application/pdf;base64,' + fileStream);
        result.push({
          edocId: item.edocId,
          title: item.title || item.name || ('文件' + (result.length + 1)),
          remark: item.remark || '',
          url: URL.createObjectURL(pdfBlob),
          noFile: false
        });
      }
      return result;
    },

    getActiveIndex: function(activeEdocId) {
      if (!activeEdocId) {
        return 0;
      }
      for (var i = 0; i < this.pdfList.length; i++) {
        if (this.pdfList[i].edocId == activeEdocId) {
          return i;
        }
      }
      return 0;
    },

    resolveViewMode: function (mode, detailInfo) {
      if (mode == 'view' || mode == 'edit') {
        return mode;
      }
      detailInfo = detailInfo || {};
      return detailInfo.status > 3 ? 'view' : 'edit';
    },

    toggleTreePanel: function () {
      this.treeCollapsed = !this.treeCollapsed;
    },

    bindLayoutEvents: function () {
      var self = this;
      var root = $('.' + self.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer');
      root.off('click.multiPdfViewerLayout', '.layout-btn').on('click.multiPdfViewerLayout', '.layout-btn', function () {
        var layout = parseInt($(this).attr('data-layout'), 10);
        if (layout) {
          self.changeLayout(layout);
        }
      });
    },

    changeLayout: function (count) {
      count = this.normalizeLayoutCount(count);
      $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .layout-btn').removeClass('active');
      $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .layout-btn[data-layout="' + count + '"]').addClass('active');
      this.layoutCount = count;
      this.saveLayoutCount(count);
      this.fullscreenPanelIndex = -1;
      this.refreshPanels();
    },

    normalizeLayoutCount: function (count) {
      count = parseInt(count, 10);
      return count == 1 || count == 2 || count == 3 || count == 4 || count == 5 ? count : 1;
    },

    getSavedLayoutCount: function () {
      try {
        return this.normalizeLayoutCount(window.localStorage && window.localStorage.getItem(this.layoutStorageKey));
      } catch (e) {
        return 1;
      }
    },

    saveLayoutCount: function (count) {
      try {
        if (window.localStorage) {
          window.localStorage.setItem(this.layoutStorageKey, this.normalizeLayoutCount(count));
        }
      } catch (e) {}
    },

    // 按当前布局把 pdfList 分配到各个分屏；layoutCount=5 表示左一右二，实际是 3 个分屏。
    refreshPanels: function () {
      var self = this;
      var panels = [];
      var total = self.pdfList.length;
      var panelCount = self.getPanelCount();
      var baseSize = Math.floor(total / panelCount);
      var extraSize = total % panelCount;
      var cursor = 0;
      for (var i = 0; i < panelCount; i++) {
        var size = baseSize + (i < extraSize ? 1 : 0);
        var pdfs = [];
        for (var j = 0; j < size; j++) {
          var sourceIndex = cursor + j;
          if (sourceIndex < total) {
            pdfs.push({
              title: self.pdfList[sourceIndex].title,
              sourceIndex: sourceIndex
            });
          }
        }
        panels.push({
          pdfs: pdfs,
          activeSourceIndex: self.getPanelActiveIndex(pdfs),
          containerId: self.pdfContainerId + '-slot-' + i,
          resultsId: self.pdfContainerId + '-results-' + i,
          fitMode: self.panelList[i] && self.panelList[i].fitMode ? self.panelList[i].fitMode : 'page-fit'
        });
        cursor += size;
      }
      self.panelList = panels;
      self.renderPanelsHtml();
      self.renderPanelPdfs();
    },

    // 布局标识和实际分屏数不总是一致：左一右二布局用 5 表示，但只生成 3 个 panel。
    getPanelCount: function () {
      return this.layoutCount == 5 ? 3 : this.layoutCount;
    },

    getPanelActiveIndex: function(pdfs) {
      if (!pdfs.length) {
        return -1;
      }
      for (var i = 0; i < pdfs.length; i++) {
        if (pdfs[i].sourceIndex == this.activeIndex) {
          return this.activeIndex;
        }
      }
      return pdfs[0].sourceIndex;
    },

    switchPanelPdf: function (panelIndex, sourceIndex) {
      this.activeIndex = sourceIndex;
      for (var i = 0; i < this.panelList.length; i++) {
        if (i == panelIndex) {
          this.panelList[i].activeSourceIndex = sourceIndex;
          break;
        }
      }
      this.updatePanelActiveTab(panelIndex, sourceIndex);
      this.updatePanelRemark(panelIndex);
      this.updatePanelDownloadButton(panelIndex);
      this.renderSinglePanelPdf(panelIndex);
      this.updateTreeActive();
    },

    updatePanelDownloadButton: function (panelIndex) {
      var panel = this.panelList[panelIndex];
      if (!panel) {
        return;
      }
      var item = this.pdfList[panel.activeSourceIndex] || {};
      var btn = $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-panel').eq(panelIndex).find('.multi-pdf-download-btn');
      btn.toggleClass('disabled', !item.url);
    },

    updatePanelActiveTab: function (panelIndex, sourceIndex) {
      var panelEl = $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-panel').eq(panelIndex);
      panelEl.find('.multi-pdf-viewer-tab').removeClass('active');
      panelEl.find('.multi-pdf-viewer-tab[data-source-index="' + sourceIndex + '"]').addClass('active');
    },

    updatePanelRemark: function (panelIndex) {
      var panel = this.panelList[panelIndex];
      var panelEl = $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-panel').eq(panelIndex);
      if (panel && panel.pdfs.length) {
        panelEl.find('.multi-pdf-viewer-remark').replaceWith(this.getPanelRemarkHtml(panel));
      }
    },

    // 右侧分屏使用 jQuery 拼 DOM，避免 Avalon 动态渲染时 PDFObject 找不到容器。
    renderPanelsHtml: function () {
      this.normalizePanelUniqueness();
      var body = $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-body');
      var html = [];
      body.removeClass('layout-1 layout-2 layout-3 layout-4 layout-5 has-fullscreen-panel').addClass('layout-' + this.layoutCount);
      for (var i = 0; i < this.panelList.length; i++) {
        html.push(this.getPanelHtml(i));
      }
      body.html(html.join(''));
      this.applyFullscreenState();
    },

    // 生成单个分屏的标签栏、PDF 容器和拖拽投放层。
    getPanelHtml: function (panelIndex) {
      var panel = this.panelList[panelIndex];
      var hasPdf = panel.pdfs.length > 0;
      var showMore = this.layoutCount != 1;
      var showRemark = hasPdf;
      var html = [];
      html.push('<div class="multi-pdf-viewer-panel' + ((hasPdf || showMore) ? ' has-pdf' : '') + (showRemark ? ' has-remark' : '') + (this.fullscreenPanelIndex == panelIndex ? ' fullscreen-panel' : '') + '" data-panel-index="' + panelIndex + '">');
      if (hasPdf || showMore) {
        html.push('<div class="multi-pdf-viewer-tabs">');
        html.push('<div class="multi-pdf-viewer-tab-list">');
        for (var j = 0; j < panel.pdfs.length; j++) {
          var pdf = panel.pdfs[j];
          html.push('<span class="multi-pdf-viewer-tab' + (panel.activeSourceIndex == pdf.sourceIndex ? ' active' : '') + '" draggable="true" title="' + this.escapeHtml(pdf.title) + '" data-panel-index="' + panelIndex + '" data-source-index="' + pdf.sourceIndex + '">' + this.escapeHtml(pdf.title) + '</span>');
        }
        html.push('</div>');
        if (showMore) {
          html.push(this.getPanelMoreHtml(panelIndex));
        }
        html.push(this.getPanelDownloadButtonHtml(panelIndex));
        html.push(this.getPanelFitButtonHtml(panelIndex));
        html.push(this.getPanelFullscreenButtonHtml(panelIndex));
        html.push('</div>');
      }
      if (hasPdf) {
        html.push('<div class="multi-pdf-viewer-container" id="' + panel.containerId + '"></div>');
        html.push('<div class="multi-pdf-viewer-results" id="' + panel.resultsId + '"></div>');
        if (showRemark) {
          html.push(this.getPanelRemarkHtml(panel));
        }
      } else {
        html.push('<div class="multi-pdf-viewer-empty"></div>');
      }
      html.push('<div class="multi-pdf-viewer-drop-mask" data-panel-index="' + panelIndex + '"></div>');
      html.push('</div>');
      return html.join('');
    },

    getPanelRemarkHtml: function (panel) {
      var item = this.pdfList[panel.activeSourceIndex] || {};
      if (this.viewMode == 'view') {
        return '<div class="multi-pdf-viewer-remark view-mode"><input type="text" class="multi-pdf-viewer-remark-input" value="' + this.escapeHtml(item.remark || '') + '" placeholder="核查意见" disabled="disabled"></div>';
      }
      return '<div class="multi-pdf-viewer-remark"><input type="text" class="multi-pdf-viewer-remark-input" value="' + this.escapeHtml(item.remark || '') + '" placeholder="核查意见，回车键（Enter）保存" data-source-index="' + panel.activeSourceIndex + '"><button type="button" class="multi-pdf-viewer-remark-save" data-source-index="' + panel.activeSourceIndex + '">保存</button></div>';
    },

    getPanelDownloadButtonHtml: function (panelIndex) {
      var panel = this.panelList[panelIndex] || {};
      var item = this.pdfList[panel.activeSourceIndex] || {};
      var disabled = !item.url;
      return '<button type="button" class="multi-pdf-download-btn' + (disabled ? ' disabled' : '') + '" title="下载文件" data-panel-index="' + panelIndex + '"><span></span></button>';
    },

    // 下载当前分屏正在展示的 PDF 文件。
    downloadPanelPdf: function (panelIndex) {
      var panel = this.panelList[panelIndex];
      if (!panel) {
        return;
      }
      var item = this.pdfList[panel.activeSourceIndex];
      if (!item || !item.url) {
        tools.info('当前文件不可下载');
        return;
      }
      var fileName = (item.title || '文件');
      if (!/\.pdf$/i.test(fileName)) {
        fileName += '.pdf';
      }
      var link = document.createElement('a');
      link.href = item.url;
      link.download = fileName;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    },

    getPanelFitButtonHtml: function (panelIndex) {
      var panel = this.panelList[panelIndex] || {};
      var fitMode = panel.fitMode || 'page-fit';
      var title = fitMode == 'page-width' ? '适应页宽' : '适应页面';
      return '<button type="button" class="multi-pdf-fit-btn ' + fitMode + '" title="' + title + '" data-panel-index="' + panelIndex + '" data-fit-mode="' + fitMode + '"><span></span></button>';
    },

    getPanelFullscreenButtonHtml: function (panelIndex) {
      var active = this.fullscreenPanelIndex == panelIndex;
      return '<button type="button" class="multi-pdf-fullscreen-btn' + (active ? ' active' : '') + '" title="' + (active ? '退出全屏' : '全屏展示') + '" data-panel-index="' + panelIndex + '"><span></span></button>';
    },

    saveRemark: function (sourceIndex, remark) {
      var self = this;
      var item = this.pdfList[sourceIndex];
      if (!item || !item.edocId) {
        tools.info('未获取到文件信息');
        return;
      }
      item.remark = remark || '';
      api.dzbaFileRemarkSave({
        docInfo: [{
          docid: item.edocId,
          remark: item.remark,
          changeFlag: 'Y'
        }]
      }).done(function (res) {
        if (res.code == 0) {
          self.showToast('保存成功');
          if (typeof self.onRemarkSave == 'function') {
            self.onRemarkSave(item, item.remark, res);
          }
        }
      });
    },

    showToast: function (text) {
      var root = $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer');
      var toast = root.find('.multi-pdf-viewer-toast');
      if (!toast.length) {
        toast = $('<div class="multi-pdf-viewer-toast"><div class="multi-pdf-viewer-toast-dialog d-outer d-state-focus d-state-visible d-state-lock"><div class="d-inner"><div class="d-dialog"><div class="d-header"><div class="d-titleBar"><div class="d-title">提示</div></div></div><div class="d-main"><div class="d-content multi-pdf-viewer-toast-content"></div></div><div class="d-footer"><div class="d-buttons"><button type="button" class="d-button d-state-highlight">确定</button></div></div></div></div></div></div>');
        root.find('.multi-pdf-viewer-model').append(toast);
        toast.on('click', 'button', function () {
          toast.hide();
        });
      }
      toast.find('.multi-pdf-viewer-toast-content').text(text || '');
      toast.show();
      this.toastTimer && clearTimeout(this.toastTimer);
      this.toastTimer = null;
    },

    // 非单屏时，每个分屏标签末尾提供更多菜单，只列出当前分屏未打开的 PDF。
    getPanelMoreHtml: function (panelIndex) {
      var panel = this.panelList[panelIndex];
      var existsMap = {};
      var options = [];
      for (var i = 0; i < panel.pdfs.length; i++) {
        existsMap[panel.pdfs[i].sourceIndex] = true;
      }
      for (var j = 0; j < this.pdfList.length; j++) {
        if (!existsMap[j]) {
          options.push({
            title: this.pdfList[j].title,
            sourceIndex: j
          });
        }
      }
      var html = [];
      html.push('<span class="multi-pdf-tab-more-wrap">');
      html.push('<span class="multi-pdf-tab-more" title="选择单证" data-panel-index="' + panelIndex + '">▾</span>');
      html.push('<div class="multi-pdf-tab-menu">');
      if (!options.length) {
        html.push('<div class="multi-pdf-tab-menu-empty">无可选文件</div>');
      }
      for (var k = 0; k < options.length; k++) {
        html.push('<div class="multi-pdf-tab-menu-item" title="' + this.escapeHtml(options[k].title) + '" data-panel-index="' + panelIndex + '" data-source-index="' + options[k].sourceIndex + '">' + this.escapeHtml(options[k].title) + '</div>');
      }
      html.push('</div>');
      html.push('</span>');
      return html.join('');
    },

    // 局部重绘单个分屏，用于标签切换/拖拽移动，减少其它分屏闪烁。
    renderPanelHtml: function (panelIndex) {
      this.normalizePanelUniqueness();
      var panelEl = $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-panel').eq(panelIndex);
      panelEl.replaceWith(this.getPanelHtml(panelIndex));
      this.applyFullscreenState();
    },

    // 渲染前兜底去重，保证同一个 sourceIndex 不会同时留在多个分屏中。
    normalizePanelUniqueness: function () {
      var ownerMap = {};
      for (var i = 0; i < this.panelList.length; i++) {
        var panel = this.panelList[i];
        for (var j = 0; j < panel.pdfs.length; j++) {
          var sourceIndex = panel.pdfs[j].sourceIndex;
          if (panel.activeSourceIndex == sourceIndex || ownerMap[sourceIndex] === undefined) {
            ownerMap[sourceIndex] = i;
          }
        }
      }
      for (var k = 0; k < this.panelList.length; k++) {
        var currentPanel = this.panelList[k];
        for (var m = currentPanel.pdfs.length - 1; m >= 0; m--) {
          if (ownerMap[currentPanel.pdfs[m].sourceIndex] !== k) {
            currentPanel.pdfs.splice(m, 1);
          }
        }
        currentPanel.activeSourceIndex = this.getPanelActiveIndex(currentPanel.pdfs);
      }
    },

    // 左侧树也用 jQuery 渲染，展示 分类 -> 单证类型 -> 文件，默认全部展开。
    renderTreeHtml: function () {
      var treeBody = $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-tree-body');
      var treeData = this.treeData || [];
      var html = [];
      if (!treeData.length) {
        treeBody.html('');
        return;
      }
      for (var i = 0; i < treeData.length; i++) {
        var group = treeData[i];
        var items = group.item || [];
        var groupHtml = [];
        for (var j = 0; j < items.length; j++) {
          var fileInfos = items[j].fileInfos || [];
          if (!items[j].checked || !fileInfos.length) {
            continue;
          }
          groupHtml.push('<div class="multi-pdf-tree-type">');
          groupHtml.push('<div class="multi-pdf-tree-type-title" title="' + this.escapeHtml(items[j].name) + '">' + this.escapeHtml(items[j].name) + '</div>');
          for (var k = 0; k < fileInfos.length; k++) {
            groupHtml.push('<div class="multi-pdf-tree-file" draggable="true" title="' + this.escapeHtml(fileInfos[k].title) + '" data-edoc-id="' + this.escapeHtml(fileInfos[k].edocId) + '"><span class="multi-pdf-tree-file-icon"></span><span class="multi-pdf-tree-file-title">' + this.escapeHtml(fileInfos[k].title) + '</span></div>');
          }
          groupHtml.push('</div>');
        }
        if (groupHtml.length) {
          html.push('<div class="multi-pdf-tree-group">');
          html.push('<div class="multi-pdf-tree-group-title" title="' + this.escapeHtml(group.name) + '">' + this.escapeHtml(group.name) + '</div>');
          html.push(groupHtml.join(''));
          html.push('</div>');
        }
      }
      treeBody.html(html.join(''));
      this.updateTreeActive();
    },

    renderBusinessInfo: function () {
      var root = $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer');
      var panel = root.find('.multi-pdf-viewer-tree-panel');
      var infoBox = root.find('.multi-pdf-viewer-business-info');
      var info = this.detailInfo || {};
      var fields = [
        { label: '企业名称', key: 'nsrmc' },
        { label: '出口日期', key: ['eDate', 'ckrq'] },
        { label: '贸易方式', key: ['supvModeCodeName', 'supvModeName', 'myfs', 'myfsmc'] },
        { label: '合同号', key: ['contrNo', 'hth'] },
        { label: '备案号', key: ['manualNo', 'bah'] },
        { label: '运输方式', key: ['cusTrafModeName', 'trafModeName', 'ysfs', 'ysfsmc'] },
        { label: '成交方式', key: ['transModeName', 'cjfs', 'cjfscodeName'] },
        { label: '提运单号', key: ['billNo', 'tydh', 'tydNo'] },
        { label: '贸易国', key: ['cusTradeNationCodeName', 'tradeNationName', 'myg', 'mygmc'] },
        { label: '申报单位', key: ['sbdwmc', 'sbdw', 'sbdwMc'] }
      ];
      var hasValue = false;
      var html = ['<table><tbody>'];
      for (var i = 0; i < fields.length; i++) {
        var value = this.getInfoValue(info, fields[i].key);
        if (value !== '') {
          hasValue = true;
        }
        html.push('<tr><th>' + fields[i].label + '</th><td title="' + this.escapeHtml(value) + '">' + this.escapeHtml(value) + '</td></tr>');
      }
      html.push('</tbody></table>');
      if (hasValue) {
        infoBox.html(html.join('')).show();
        panel.addClass('has-business-info');
      } else {
        infoBox.empty().hide();
        panel.removeClass('has-business-info');
      }
    },

    getInfoValue: function (info, key) {
      info = info || {};
      var keys = $.isArray(key) ? key : [key];
      for (var i = 0; i < keys.length; i++) {
        var value = info[keys[i]];
        if (value !== undefined && value !== null && value !== '') {
          return value;
        }
      }
      return '';
    },

    // 左侧树高亮当前正在右侧展示/激活的 PDF。
    updateTreeActive: function () {
      var activePdf = this.pdfList[this.activeIndex];
      var treeBody = $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-tree-body');
      treeBody.find('.multi-pdf-tree-file').removeClass('active');
      if (activePdf && activePdf.edocId) {
        treeBody.find('.multi-pdf-tree-file[data-edoc-id="' + activePdf.edocId + '"]').addClass('active');
      }
    },

    // 从左侧树点击文件时，把该 PDF 放入当前激活分屏；放入前会先从其它分屏移除。
    showPdfInPanel: function (sourceIndex, panelIndex) {
      var targetPanelIndex = typeof panelIndex === 'number' ? panelIndex : this.getActivePanelIndex();
      if (targetPanelIndex < 0) {
        targetPanelIndex = 0;
      }
      var panel = this.panelList[targetPanelIndex];
      if (!panel) {
        return;
      }
      var changedPanels = this.removePdfFromOtherPanels(sourceIndex, targetPanelIndex);
      this.addPdfToPanel(sourceIndex, targetPanelIndex);
      panel.activeSourceIndex = sourceIndex;
      this.activeIndex = sourceIndex;
      changedPanels.push(targetPanelIndex);
      this.renderChangedPanels(changedPanels);
      this.updateTreeActive();
    },

    // 将 PDF 加到指定分屏的标签列表，若已存在则不重复添加。
    addPdfToPanel: function (sourceIndex, panelIndex) {
      var panel = this.panelList[panelIndex];
      if (!panel || !this.pdfList[sourceIndex]) {
        return;
      }
      for (var i = 0; i < panel.pdfs.length; i++) {
        if (panel.pdfs[i].sourceIndex == sourceIndex) {
          return;
        }
      }
      panel.pdfs.push({
        title: this.pdfList[sourceIndex].title,
        sourceIndex: sourceIndex
      });
    },

    // 唯一展示约束：把同一个 PDF 从非目标分屏移除，并返回受影响的分屏下标。
    removePdfFromOtherPanels: function (sourceIndex, keepPanelIndex) {
      var changed = [];
      for (var i = 0; i < this.panelList.length; i++) {
        if (i == keepPanelIndex) {
          continue;
        }
        var panel = this.panelList[i];
        for (var j = panel.pdfs.length - 1; j >= 0; j--) {
          if (panel.pdfs[j].sourceIndex == sourceIndex) {
            panel.pdfs.splice(j, 1);
            panel.activeSourceIndex = this.getPanelActiveIndex(panel.pdfs);
            changed.push(i);
          }
        }
      }
      return changed;
    },

    // 重绘一组受影响分屏，并只重新 embed 这些分屏的 PDF。
    renderChangedPanels: function (panelIndexes) {
      var map = {};
      for (var i = 0; i < panelIndexes.length; i++) {
        var panelIndex = panelIndexes[i];
        if (panelIndex < 0 || map[panelIndex]) {
          continue;
        }
        map[panelIndex] = true;
        this.renderPanelHtml(panelIndex);
        this.renderSinglePanelPdf(panelIndex);
      }
    },

    getActivePanelIndex: function () {
      for (var i = 0; i < this.panelList.length; i++) {
        if (this.panelList[i].activeSourceIndex == this.activeIndex) {
          return i;
        }
      }
      return this.panelList.length ? 0 : -1;
    },

    getPanelIndexBySourceIndex: function (sourceIndex) {
      for (var i = 0; i < this.panelList.length; i++) {
        var panel = this.panelList[i];
        for (var j = 0; j < panel.pdfs.length; j++) {
          if (panel.pdfs[j].sourceIndex == sourceIndex) {
            return i;
          }
        }
      }
      return -1;
    },

    activatePdfFromTree: function (sourceIndex) {
      var panelIndex = this.getPanelIndexBySourceIndex(sourceIndex);
      if (panelIndex < 0) {
        return;
      }
      this.switchPanelPdf(panelIndex, sourceIndex);
    },

    // 绑定右侧标签拖拽、分屏投放、左侧树点击/拖拽事件。
    bindPanelEvents: function () {
      var self = this;
      var body = $('.' + self.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-body');
      body.off('click.multiPdfViewer').on('click.multiPdfViewer', '.multi-pdf-viewer-tab', function () {
        if (self.justDragged) {
          self.justDragged = false;
          return;
        }
        var panelIndex = parseInt($(this).attr('data-panel-index'), 10);
        var sourceIndex = parseInt($(this).attr('data-source-index'), 10);
        self.switchPanelPdf(panelIndex, sourceIndex);
      }).on('wheel.multiPdfViewer', '.multi-pdf-viewer-tab-list', function (event) {
        var e = event.originalEvent || event;
        if (e.ctrlKey) {
          return;
        }
        if (Math.abs(e.deltaY) > Math.abs(e.deltaX)) {
          this.scrollLeft += e.deltaY;
          event.preventDefault();
        }
      }).on('click.multiPdfViewer', '.multi-pdf-tab-more', function (event) {
        event.stopPropagation();
        var menu = $(this).next('.multi-pdf-tab-menu');
        body.find('.multi-pdf-tab-menu').not(menu).hide();
        menu.css({ left: 0 });
        menu.toggle();
        if (menu.is(':visible')) {
          var panelEl = $(this).closest('.multi-pdf-viewer-panel');
          var overflowRight = menu.offset().left + menu.outerWidth() - (panelEl.offset().left + panelEl.outerWidth());
          if (overflowRight > 0) {
            menu.css({ left: -overflowRight - 6 });
          }
        }
      }).on('click.multiPdfViewer', '.multi-pdf-tab-menu-item', function (event) {
        event.stopPropagation();
        var panelIndex = parseInt($(this).attr('data-panel-index'), 10);
        var sourceIndex = parseInt($(this).attr('data-source-index'), 10);
        body.find('.multi-pdf-tab-menu').hide();
        self.showPdfInPanel(sourceIndex, panelIndex);
      }).on('click.multiPdfViewer', '.multi-pdf-download-btn', function (event) {
        event.stopPropagation();
        var panelIndex = parseInt($(this).attr('data-panel-index'), 10);
        self.downloadPanelPdf(panelIndex);
      }).on('click.multiPdfViewer', '.multi-pdf-fit-btn', function (event) {
        event.stopPropagation();
        var panelIndex = parseInt($(this).attr('data-panel-index'), 10);
        self.togglePanelFitMode(panelIndex);
      }).on('click.multiPdfViewer', '.multi-pdf-fullscreen-btn', function (event) {
        event.stopPropagation();
        var panelIndex = parseInt($(this).attr('data-panel-index'), 10);
        self.togglePanelFullscreen(panelIndex);
      }).on('click.multiPdfViewer', '.multi-pdf-viewer-remark-save', function (event) {
        event.stopPropagation();
        var sourceIndex = parseInt($(this).attr('data-source-index'), 10);
        var remark = $(this).siblings('.multi-pdf-viewer-remark-input').val();
        self.saveRemark(sourceIndex, remark);
      }).on('input.multiPdfViewer', '.multi-pdf-viewer-remark-input', function () {
        var sourceIndex = parseInt($(this).attr('data-source-index'), 10);
        if (self.pdfList[sourceIndex]) {
          self.pdfList[sourceIndex].remark = $(this).val();
        }
      }).on('keydown.multiPdfViewer', '.multi-pdf-viewer-remark-input', function (event) {
        var e = event.originalEvent || event;
        if (e.isComposing || e.keyCode == 229) {
          return;
        }
        if (e.keyCode == 13 || e.key == 'Enter') {
          event.preventDefault();
          var sourceIndex = parseInt($(this).attr('data-source-index'), 10);
          self.saveRemark(sourceIndex, $(this).val());
        }
      }).on('dragstart.multiPdfViewer', '.multi-pdf-viewer-tab', function (event) {
        var e = event.originalEvent || event;
        var panelIndex = parseInt($(this).attr('data-panel-index'), 10);
        var sourceIndex = parseInt($(this).attr('data-source-index'), 10);
        self.dragState = {
          from: 'panel',
          panelIndex: panelIndex,
          sourceIndex: sourceIndex
        };
        if (e.dataTransfer) {
          e.dataTransfer.effectAllowed = 'move';
          e.dataTransfer.setData('text/plain', sourceIndex);
        }
        self.dragMaskTimer && clearTimeout(self.dragMaskTimer);
        self.dragMaskTimer = setTimeout(function () {
          if (self.dragState) {
            body.addClass('dragging-file');
          }
        }, 80);
        $(this).addClass('dragging');
      }).on('dragend.multiPdfViewer', '.multi-pdf-viewer-tab', function () {
        self.justDragged = true;
        self.dragState = null;
        self.dragMaskTimer && clearTimeout(self.dragMaskTimer);
        body.removeClass('dragging-file');
        body.find('.multi-pdf-viewer-tab').removeClass('dragging');
        body.find('.multi-pdf-viewer-panel').removeClass('drag-over');
        setTimeout(function () {
          self.justDragged = false;
        }, 0);
      }).on('dragover.multiPdfViewer', '.multi-pdf-viewer-drop-mask', function (event) {
        var e = event.originalEvent || event;
        if (!self.dragState) {
          return;
        }
        event.preventDefault();
        if (e.dataTransfer) {
          e.dataTransfer.dropEffect = 'move';
        }
        body.find('.multi-pdf-viewer-panel').removeClass('drag-over');
        $(this).closest('.multi-pdf-viewer-panel').addClass('drag-over');
      }).on('dragleave.multiPdfViewer', '.multi-pdf-viewer-drop-mask', function (event) {
        var related = event.relatedTarget;
        if (!related || !$.contains(this, related)) {
          $(this).closest('.multi-pdf-viewer-panel').removeClass('drag-over');
        }
      }).on('drop.multiPdfViewer', '.multi-pdf-viewer-drop-mask', function (event) {
        event.preventDefault();
        var targetPanelIndex = parseInt($(this).attr('data-panel-index'), 10);
        self.dragMaskTimer && clearTimeout(self.dragMaskTimer);
        body.removeClass('dragging-file');
        body.find('.multi-pdf-viewer-panel').removeClass('drag-over');
        self.movePdfToPanel(targetPanelIndex);
      });

      $(document).off('click.multiPdfViewerMenu').on('click.multiPdfViewerMenu', function () {
        body.find('.multi-pdf-tab-menu').hide();
      });

      var treeBody = $('.' + self.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-tree-body');
      treeBody.off('click.multiPdfViewer').on('click.multiPdfViewer', '.multi-pdf-tree-file', function () {
        var edocId = $(this).attr('data-edoc-id');
        var sourceIndex = self.getSourceIndexByEdocId(edocId);
        if (sourceIndex >= 0) {
          self.activatePdfFromTree(sourceIndex);
        }
      }).on('dragstart.multiPdfViewer', '.multi-pdf-tree-file', function (event) {
        var e = event.originalEvent || event;
        var edocId = $(this).attr('data-edoc-id');
        var sourceIndex = self.getSourceIndexByEdocId(edocId);
        if (sourceIndex < 0) {
          return;
        }
        self.dragState = {
          from: 'tree',
          panelIndex: -1,
          sourceIndex: sourceIndex
        };
        if (e.dataTransfer) {
          e.dataTransfer.effectAllowed = 'move';
          e.dataTransfer.setData('text/plain', sourceIndex);
        }
        self.dragMaskTimer && clearTimeout(self.dragMaskTimer);
        self.dragMaskTimer = setTimeout(function () {
          if (self.dragState) {
            body.addClass('dragging-file');
          }
        }, 80);
        $(this).addClass('dragging');
      }).on('dragend.multiPdfViewer', '.multi-pdf-tree-file', function () {
        self.justDragged = true;
        self.dragState = null;
        self.dragMaskTimer && clearTimeout(self.dragMaskTimer);
        body.removeClass('dragging-file');
        treeBody.find('.multi-pdf-tree-file').removeClass('dragging');
        body.find('.multi-pdf-viewer-panel').removeClass('drag-over');
        setTimeout(function () {
          self.justDragged = false;
        }, 0);
      });
    },

    togglePanelFullscreen: function (panelIndex) {
      this.fullscreenPanelIndex = this.fullscreenPanelIndex == panelIndex ? -1 : panelIndex;
      this.applyFullscreenState();
      if (this.fullscreenPanelIndex >= 0) {
        var self = this;
        setTimeout(function () {
          var panel = self.panelList[panelIndex];
          if (panel) {
            self.applyPanelFitMode(panelIndex, panel.fitMode || 'page-fit');
          }
        }, 80);
      }
    },

    applyFullscreenState: function () {
      var root = $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer');
      var main = root.find('.multi-pdf-viewer-main');
      var body = root.find('.multi-pdf-viewer-body');
      var panels = body.find('.multi-pdf-viewer-panel');
      var isFullscreen = this.fullscreenPanelIndex >= 0;
      main.toggleClass('pdf-fullscreen', isFullscreen);
      body.toggleClass('has-fullscreen-panel', isFullscreen);
      panels.removeClass('fullscreen-panel');
      body.find('.multi-pdf-fullscreen-btn').removeClass('active').attr('title', '全屏展示');
      if (isFullscreen) {
        var panelEl = panels.eq(this.fullscreenPanelIndex);
        panelEl.addClass('fullscreen-panel');
        panelEl.find('.multi-pdf-fullscreen-btn').addClass('active').attr('title', '退出全屏');
      }
    },

    // 在“适应页面”和“适应页宽”之间切换，只作用于当前分屏 iframe。
    togglePanelFitMode: function (panelIndex) {
      var panel = this.panelList[panelIndex];
      if (!panel) {
        return;
      }
      var nextMode = panel.fitMode == 'page-width' ? 'page-fit' : 'page-width';
      this.applyPanelFitMode(panelIndex, nextMode);
    },

    applyPanelFitMode: function (panelIndex, fitMode) {
      var panel = this.panelList[panelIndex];
      if (!panel) {
        return;
      }
      panel.fitMode = fitMode || 'page-fit';
      var iframe = $('#' + panel.containerId).find('iframe')[0];
      if (!iframe) {
        return;
      }
      try {
        var app = iframe.contentWindow && iframe.contentWindow.PDFViewerApplication;
        if (app && app.pdfViewer) {
          app.pdfViewer.currentScaleValue = panel.fitMode;
          this.updatePanelFitButton(panelIndex);
        }
      } catch (e) {
        tools.info('当前PDF暂不支持缩放调整');
      }
    },

    updatePanelFitButton: function (panelIndex) {
      var panel = this.panelList[panelIndex];
      var fitMode = panel && panel.fitMode ? panel.fitMode : 'page-fit';
      var btn = $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-panel').eq(panelIndex).find('.multi-pdf-fit-btn');
      btn.removeClass('page-fit page-width').addClass(fitMode);
      btn.attr('data-fit-mode', fitMode);
      btn.attr('title', fitMode == 'page-width' ? '适应页宽' : '适应页面');
    },

    getSourceIndexByEdocId: function (edocId) {
      for (var i = 0; i < this.pdfList.length; i++) {
        if (this.pdfList[i].edocId == edocId) {
          return i;
        }
      }
      return -1;
    },

    // 处理拖拽投放：来源可以是右侧标签或左侧树文件，目标是某个右侧分屏。
    movePdfToPanel: function (targetPanelIndex) {
      var state = this.dragState;
      if (!state) {
        return;
      }
      if (state.from == 'panel' && state.panelIndex == targetPanelIndex) {
        return;
      }
      var targetPanel = this.panelList[targetPanelIndex];
      if (!targetPanel) {
        return;
      }
      var changedPanels = this.removePdfFromOtherPanels(state.sourceIndex, targetPanelIndex);
      this.addPdfToPanel(state.sourceIndex, targetPanelIndex);
      targetPanel.activeSourceIndex = state.sourceIndex;
      this.activeIndex = state.sourceIndex;
      changedPanels.push(targetPanelIndex);
      this.renderChangedPanels(changedPanels);
      this.updateTreeActive();
    },

    escapeHtml: function (text) {
      return String(text === undefined || text === null ? '' : text).replace(/[&<>"]/g, function (item) {
        return {
          '&': '&amp;',
          '<': '&lt;',
          '>': '&gt;',
          '"': '&quot;'
        }[item];
      });
    },

    // 本组件默认关闭 PDF.js 左侧 sidebarContainer；tools.pdfOptions 里 pagemode=thumbs 会默认打开缩略图栏。
    getPdfOptions: function (fitMode) {
      var options = tools.pdfOptions();
      options.pdfOpenParams = options.pdfOpenParams || {};
      options.pdfOpenParams.navpanes = 0;
      options.pdfOpenParams.pagemode = 'none';
      options.pdfOpenParams.zoom = fitMode || 'page-fit';
      return options;
    },

    renderNoFile: function (container, item) {
      if (!container) {
        return;
      }
      container.innerHTML = '<div class="multi-pdf-viewer-no-file"><div class="no-file-title">无文件</div><div class="no-file-subtitle">' + this.escapeHtml((item && item.title) || '') + '</div></div>';
      var resultEl = container.parentNode && container.parentNode.querySelector('.multi-pdf-viewer-results');
      if (resultEl) {
        resultEl.setAttribute('class', '');
        resultEl.innerHTML = '';
      }
    },

    // 弹窗内 Ctrl+滚轮 会触发浏览器页面缩放；这里阻止默认页面缩放，避免主页面和 PDF 同时缩放。
    bindCtrlWheelGuard: function () {
      var self = this;
      if (!self.ctrlWheelGuard) {
        self.ctrlWheelGuard = function (event) {
          if (event.ctrlKey) {
            event.preventDefault();
          }
        };
      }
      document.removeEventListener('wheel', self.ctrlWheelGuard, true);
      document.addEventListener('wheel', self.ctrlWheelGuard, { passive: false, capture: true });
    },

    unbindCtrlWheelGuard: function () {
      if (this.ctrlWheelGuard) {
        document.removeEventListener('wheel', this.ctrlWheelGuard, true);
      }
    },

    // PDFObject 使用 iframe 承载 PDF.js，同源时给 iframe 内部也挂一层保护。
    bindIframeCtrlWheelGuard: function (containerId) {
      var self = this;
      setTimeout(function () {
        var iframe = $('#' + containerId).find('iframe')[0];
        if (!iframe) {
          return;
        }
        var bind = function () {
          try {
            var doc = iframe.contentWindow && iframe.contentWindow.document;
            if (doc && self.ctrlWheelGuard) {
              doc.removeEventListener('wheel', self.ctrlWheelGuard, true);
              doc.addEventListener('wheel', self.ctrlWheelGuard, { passive: false, capture: true });
            }
          } catch (e) {}
        };
        bind();
        iframe.onload = bind;
      }, 0);
    },

    // 初次打开或切换布局后，批量渲染所有分屏中的 PDF。
    renderPanelPdfs: function () {
      var self = this;
      self.renderTimer && clearTimeout(self.renderTimer);
      self.renderTimer = setTimeout(function () {
        self.embedPanelPdfs(0);
      }, 60);
    },

    // 等待 DOM 容器可用后，将每个分屏当前激活 PDF 嵌入对应容器。
    embedPanelPdfs: function (retryCount) {
      var self = this;
      var allReady = true;
      for (var i = 0; i < self.panelList.length; i++) {
        var panel = self.panelList[i];
        if (panel.activeSourceIndex < 0) {
          continue;
        }
        var container = document.getElementById(panel.containerId);
        if (!container) {
          allReady = false;
          continue;
        }
        var item = self.pdfList[panel.activeSourceIndex];
        if (!item) {
          continue;
        }
        if (!item.url) {
          self.renderNoFile(container, item);
          continue;
        }
        var myPDF = PDFObject.embed(item.url, '#' + panel.containerId, self.getPdfOptions(panel.fitMode));
        self.bindIframeCtrlWheelGuard(panel.containerId);
        var el = document.querySelector('#' + panel.resultsId);
        if (el) {
          el.setAttribute('class', (myPDF) ? 'success' : 'fail');
          el.innerHTML = (myPDF) ? '' : 'Uh-oh, the embed didn\'t work.';
        }
      }
      if (!allReady && retryCount < 10) {
        self.renderTimer && clearTimeout(self.renderTimer);
        self.renderTimer = setTimeout(function () {
          self.embedPanelPdfs(retryCount + 1);
        }, 80);
      }
    },

    // 标签切换或拖拽后，只重新渲染某一个分屏，避免其它分屏闪烁。
    renderSinglePanelPdf: function (panelIndex) {
      var self = this;
      var panel = self.panelList[panelIndex];
      if (!panel || panel.activeSourceIndex < 0) {
        return;
      }
      setTimeout(function () {
        self.embedSinglePanelPdf(panelIndex);
      }, 0);
    },

    // 用 PDFObject 把单个 PDF blob URL 嵌入到指定分屏容器中。
    embedSinglePanelPdf: function (panelIndex) {
      var panel = this.panelList[panelIndex];
      if (!panel || panel.activeSourceIndex < 0) {
        return;
      }
      var item = this.pdfList[panel.activeSourceIndex];
      var container = document.getElementById(panel.containerId);
      if (!item || !container) {
        return;
      }
      if (!item.url) {
        this.renderNoFile(container, item);
        return;
      }
      var myPDF = PDFObject.embed(item.url, '#' + panel.containerId, this.getPdfOptions(panel.fitMode));
      this.bindIframeCtrlWheelGuard(panel.containerId);
      var el = document.querySelector('#' + panel.resultsId);
      if (el) {
        el.setAttribute('class', (myPDF) ? 'success' : 'fail');
        el.innerHTML = (myPDF) ? '' : 'Uh-oh, the embed didn\'t work.';
      }
    },

    // 关闭弹窗时清理 DOM、定时器和 blob URL，避免内存泄漏。
    hidePdf: function () {
      $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-overlay').hide();
      $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-model').hide();
      this.renderTimer && clearTimeout(this.renderTimer);
      this.dragMaskTimer && clearTimeout(this.dragMaskTimer);
      this.toastTimer && clearTimeout(this.toastTimer);
      this.unbindCtrlWheelGuard();
      $(document).off('click.multiPdfViewerMenu');
      $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-body').empty();
      $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-toast').hide();
      $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-business-info').empty().hide();
      $('.' + this.pdfContainerId + '-pdfmodel' + '.multi-pdf-viewer .multi-pdf-viewer-tree-panel').removeClass('has-business-info');
      this.panelList = [];
      this.fullscreenPanelIndex = -1;
      this.detailInfo = {};
      this.viewMode = 'edit';
      this.clearUrls();
    },

    // 释放所有 createObjectURL 生成的 blob URL。
    clearUrls: function () {
      var list = this.pdfList || [];
      for (var i = 0; i < list.length; i++) {
        if (list[i].url) {
          URL.revokeObjectURL(list[i].url);
        }
      }
      this.pdfList = [];
    }
  }
});
