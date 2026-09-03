var fxfxbg = require("./fxfxbg.html");

avalon.component('fxfxbg', {
  template: fxfxbg,
  defaults: {
    uuid: '',
    nsrmc: '',
    nsrsbh: '',
    atfxrqqz: '',
    swjgDm: '',
    djxh: '',
    nsrsbhFromList: '', // 从列表带的纳税人识别号
    ckhwtmsjsffDm: '', // 从列表带的纳税人识别号
    componentName: '',
    pdfUrl: '', // PDF链接
    reportStatus: null, // 报告状态
    reportData: {}, // 报告数据
    isInited: false, // 记录是否已初始化
    onInit(e) {
      components.fxfxbg = e.vmodel;
    },
    onReady: function() {
      var self = this;
      console.log('风险分析报告组件已加载', self);
      // 设置PDF预览链接
      self.pdfUrl = '/sszj/report/previewPdf?uuid=' + self.uuid;
      // 初始化 PDF 预览
      setTimeout(function() {
        self.createPdf();
      }, 100);
    },
    // 使用 PDF.js 内嵌预览（隐藏下载/打印等右上角功能按钮）
    createPdf: function() {
      var self = this;
      if (!document.getElementById('pdfReportContainer')) {
        return;
      }
      
      // 使用XMLHttpRequest检查PDF文件是否已生成
      var xhr = new XMLHttpRequest();
      xhr.open('GET', self.pdfUrl, true);
      xhr.responseType = 'blob'; // 设置响应类型为blob
      
      xhr.onload = function() {
        if (xhr.status === 200) {
          // 检查Content-Type是否为PDF
          var contentType = xhr.getResponseHeader('Content-Type');
          if (contentType && contentType.indexOf('application/pdf') !== -1) {
            // PDF生成成功，直接使用原始URL加载
            var options = {
              pdfOpenParams: {
                navpanes: 0,
                toolbar: 0,
                statusbar: 0,
                view: "FitV",
                pagemode: "thumbs",
                page: 1
              },
              forcePDFJS: true,
              PDFJS_URL: "static/pdfjs/web/viewer.html"
            };
            PDFObject.embed(self.pdfUrl, "#pdfReportContainer", options);
          } else {
            // 不是PDF，说明出错了，尝试读取错误信息
            var reader = new FileReader();
            reader.onload = function() {
              try {
                var errorData = JSON.parse(reader.result);
                self.showPdfFailed(errorData.msg || 'PDF预览失败');
              } catch(e) {
                self.showPdfFailed('PDF预览失败');
              }
            };
            reader.onerror = function() {
              self.showPdfFailed('PDF预览失败');
            };
            reader.readAsText(xhr.response);
          }
        } else {
          self.showPdfFailed('PDF预览失败');
        }
      };
      
      xhr.onerror = function() {
        self.showPdfFailed('PDF预览失败');
      };
      
      xhr.send();
    },
    // 显示PDF预览失败占位
    showPdfFailed: function(msg) {
      var container = document.getElementById('pdfReportContainer');
      if (container) {
        var message = msg || 'PDF文件尚未生成或加载失败';
        container.innerHTML = '<div style="text-align: center; padding: 150px 0; color: #909399;">' +
          '<i class="fa fa-exclamation-triangle" style="font-size: 80px; margin-bottom: 20px; color: #F56C6C;"></i>' +
          '<p style="font-size: 14px; margin: 10px 0;">' + 'PDF预览失败，可点击“下载word报告”查看报告内容' + '</p>' +
          '</div>';
      }
    },
    // 初始化方法，点击tab时调用
    init: function() {
      var self = this;
      if (self.isInited) {
        return; // 已初始化过，不重复请求
      }
      self.isInited = true;
      
      // 获取报告年度
      var bgnd = self.getReportYear(self.atfxrqqz);
      console.log('报告年度:', bgnd);
      
      // 请求接口获取报告状态
      var params = {
        uuid: self.uuid,
        bgnd: bgnd,
        bglx: 5,
        swjgDm: self.swjgDm,
        pageNo: 1,
        pageSize: 10
      };
      ajax("POST", "/sszj/report/list", params).done(function (res) {
        if (res.code == '0') {
          console.log('接口返回数据:', res.data);
          // 判断是否为未生成状态
          if (!res.data || !res.data.rows || res.data.rows.length === 0) {
            // 未生成状态，设置默认值
            self.reportData = {
              ztbz: '10' // 未生成状态标志
            };
          } else {
            // 取第0条数据
            self.reportData = res.data.rows[0];
          }
          // 更新 PDF 预览
          setTimeout(function() {
            if (self.reportData.ztbz == '2') {
              self.createPdf();
            }
          }, 100);
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      });
    },
    // 从案头分析期起-止中提取报告年度
    getReportYear: function(atfxrqqz) {
      if (!atfxrqqz) return '';
      // 示例：2025-01至2025-12 -> 2025-01 -> 2025
      var startDate = atfxrqqz.split('至')[0]; // 2025-01
      var year = startDate.split('-')[0]; // 2025
      return year;
    },
    // 生成报告
    generateReport: function() {
      var self = this;
      if (self.ckhwtmsjsffDm !== '2' && self.ckhwtmsjsffDm !== 2) {
        tools.info('该企业尚不支持生成文字报告。');
        return;
      }
      var bgnd = self.getReportYear(self.atfxrqqz);
      var params = {
        uuid: self.uuid,
        bgnd: bgnd,
        bglx: 5,
        bgInfoList: [
          {
            djxh: self.djxh,
            nsrsbh: self.nsrsbhFromList,
            swjgDm: self.swjgDm
          }
        ]
      };
      ajax("POST", "/sszj/report/generate", params).done(function (res) {
        if (res.code == '0') {
          tools.info('生成报告成功！');
          // 刷新页面状态
          self.refreshStatus();
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      });
    },
    // 下载报告
    downloadReport: function() {
      var self = this;
      var params = {
        uuid: self.uuid,
        bglx: 5,
        djxh: self.djxh
      };
      tools.ajaxExform(params, '/sszj/report/download').done(function() {
        // tools.info('下载成功！');
      }).fail(function(err) {
        tools.info(err);
      });
    },
    // 刷新状态
    refreshStatus: function() {
      var self = this;
      // 重新请求接口获取最新状态
      var bgnd = self.getReportYear(self.atfxrqqz);
      var params = {
        uuid: self.uuid,
        bgnd: bgnd,
        bglx: 5,
        swjgDm: self.swjgDm,
        pageNo: 1,
        pageSize: 10
      };
      ajax("POST", "/sszj/report/list", params).done(function (res) {
        if (res.code == '0') {
          console.log('刷新接口返回数据:', res.data);
          // 判断是否为未生成状态
          if (!res.data || !res.data.rows || res.data.rows.length === 0) {
            // 未生成状态，设置默认值
            self.reportData = {
              ztbz: '10' // 未生成状态标志
            };
          } else {
            // 取第0条数据
            self.reportData = res.data.rows[0];
          }
          // 更新 PDF 预览
          setTimeout(function() {
            if (self.reportData.ztbz == '2') {
              self.createPdf();
            }
          }, 100);
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      });
    },
  }
});
