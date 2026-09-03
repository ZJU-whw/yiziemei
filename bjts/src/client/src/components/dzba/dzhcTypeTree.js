var dzhcTypeTree = require("./dzhcTypeTree.html");
require("./dzhcTypeTree.css");

// 处理树形数据，添加 rowspan 信息用于合并单元格
function processTreeData(data) {
  var list = data || [];
  var result = [];
  for (var i = 0; i < list.length; i++) {
    var item = list[i];
    var items = item.item || [];
    // 只保留 checked 为 true 的项
    var checkedItems = [];
    for (var k = 0; k < items.length; k++) {
      if (items[k].checked) {
        checkedItems.push(items[k]);
      }
    }
    for (var j = 0; j < checkedItems.length; j++) {
      result.push({
        name: item.name,
        tmpName: checkedItems[j].name,
        fileInfos: checkedItems[j].fileInfos,
        // 每个分类的第一行显示分类名，其他行不显示
        showLabel: j === 0,
        // rowspan 为当前分类下已选中的单证类型数量
        rowspan: checkedItems.length
      });
    }
  }
  return result;
}

avalon.component('dzhcTypeTree', {
  template: dzhcTypeTree,
  defaults: {
    // 外部传入参数
    typeTreeData: [],      // 核查单证类型数据（外部传入）
    detailInfo: {},        // 当前业务信息，用于 PDF 预览左侧底部展示
    onRemarkSave: null,
    // 内部使用
    treeData: [],          // 用于渲染的响应式数组
    currentDetailInfo: {},
    customApi: null,    // 自定义API方法，用于获取PDF文件
    onReady: function () {
      var self = this;
      // 初始化时同步
      self.treeData = processTreeData(self.typeTreeData);
      self.currentDetailInfo = self.detailInfo || {};
      // 监听外部传入的数据变化
      self.$watch('typeTreeData', function(newVal) {
        self.treeData = processTreeData(newVal);
      });
      self.$watch('detailInfo', function(newVal) {
        self.currentDetailInfo = newVal || {};
      });
    },
    showPdf: function(file){
      var viewer = components['multiPdfViewerglobal-multi-pdf'];
      var apiUrl = this.customApi || 'dzbaFileViewPdf';
      if (viewer) {
        viewer.showTreePdfs(this.typeTreeData, '核查单证类型', file && file.edocId, apiUrl, this.currentDetailInfo, null, this.onRemarkSave);
      } else {
        tools.info('PDF预览组件未初始化');
      }
    },
  }
});
