var pdfViewer = require("./pdfViewer.html");
require("./pdfViewer.css");

avalon.component('pdfViewer', {
  template: pdfViewer,
  defaults: {
    // 外部传入参数
    pdfContainerId: '',    // PDF容器ID（外部传入，需唯一）
    pdfResultsId: '',      // 结果提示容器ID（外部传入，需唯一）
    title: '',

    onInit: function onInit(e) {
    },
    onReady: function () {
      var self = this;
      // 如果没有传入ID，生成唯一ID
      if (!self.pdfContainerId) {
        self.pdfContainerId = 'pdf-viewer-container-' + Date.now();
      }
      if (!self.pdfResultsId) {
        self.pdfResultsId = 'pdf-viewer-results-' + Date.now();
      }
      // 注册到全局 components
      components['pdfViewer'+self.pdfContainerId] = self;
    },

    // 显示PDF
    showPdf: function(fileData, title) {
      $('.'+this.pdfContainerId+'-pdfmodel'+'.pdf-viewer .pdf-viewer-overlay').show();
      $('.'+this.pdfContainerId+'-pdfmodel'+'.pdf-viewer .pdf-viewer-model').show();
      var pdfBlob = tools.dataURLtoBlob("data:application/pdf;base64," + fileData);
      var pdfUrl = URL.createObjectURL(pdfBlob);
      this.title = title;
      this.createPdf(pdfUrl);
    },

    // 创建PDF预览
    createPdf: function(url) {
      var self = this;
      var options = tools.pdfOptions();
      var myPDF = PDFObject.embed(url, "#" + self.pdfContainerId, options);
      var el = document.querySelector("#" + self.pdfResultsId);
      if (el) {
        el.setAttribute("class", (myPDF) ? "success" : "fail");
        el.innerHTML = (myPDF) ? "" : "Uh-oh, the embed didn't work.";
      }
    },

    // 隐藏PDF弹框
    hidePdf: function() {
      $('.pdf-viewer .pdf-viewer-overlay').hide();
      $('.pdf-viewer .pdf-viewer-model').hide();
    }
  }
});
