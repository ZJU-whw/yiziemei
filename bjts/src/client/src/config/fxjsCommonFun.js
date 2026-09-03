var fxjsCommonFun = {}
fxjsCommonFun.delKeySuffix = function(obj){
  var keys = Object.keys(obj)
  var res = {}
  for (var i=0;i<keys.length;i++) {
    let keyName = keys[i].split('#')[0].split('_')[0]
    res[keyName] = obj[keys[i]]
  }
  return res
}
fxjsCommonFun.getFormatter = function(rowObject, name, notNumber){
  let row = fxjsCommonFun.delKeySuffix(rowObject)
  if (typeof(row[name]) == 'undefined') {
    return ' '
  }
  if (notNumber) {
    return row[name]
  } else {
    return avalon.filters.number(row[name],2);
  }
}
// 获取最下面被选中的节点
fxjsCommonFun.getFootNode = function(arrVal){
  var arr = []
  for(var i=0;i<arrVal.length;i++) {
    if (arrVal[i].code != '') {
      arr.push(arrVal[i])
    }
  }
  var codeArr = arr.map(function(item){
    return item.code
  })
  codeArr.push('0')
  var parentIds = []
  var parentArr = []
  for(var i=0;i<arr.length;i++) {
    if ((codeArr.indexOf(arr[i].parentId) > -1) && (parentIds.indexOf(arr[i].parentId) == -1)) {
      parentIds.push(arr[i].parentId)
      parentArr.push({parentId: arr[i].parentId, pLevel: arr[i].pLevel})
    }
  }
  var res = tools.clone(arr)
  for(var i=0;i<res.length;i++) {
    let index = parentIds.indexOf(res[i].code)
    if (index> -1) {
      res.splice(i,1)
      i--
    }
  }
  return res
}
// ztree
fxjsCommonFun.getTree = function(className, swjgList){
  var ul = $('ul');
  ul.attr('id', className+'Tree');
  ul.attr('display', 'none');
  $('.'+className).append(ul)
  var setting = {
    data:{key:{children:"item",name:"text"}}
  }
  $.fn.zTree.init($("#"+className+'Tree'), setting, swjgList);
}
// 树形结构中根据id获取获取指定节点
fxjsCommonFun.getItemByIdInTree = function(id, tree) {
  let res = null
  for(let i=0;i<tree.length;i++) {
    let ele = tree[i]
    ele.id===id ? res = ele : ''
    if(res) break;
    if(ele.item && ele.item.length) {
      res = fxjsCommonFun.getItemByIdInTree(id,ele.item)
    } 
  }
  return res
}
// 获取动态列
// rows:列表数据
// titleList: 列表title数组
// defaultTitleList: 固定列表头名称数组
// trendColumsLen： 动态列长度
fxjsCommonFun.getTrendColumns = function(rows, titleList, defaultTitleList, trendColumsLen){
  var trendColumns = []
  for (var i=0;i<rows.length;i++) {
    let row = rows[i]
    for(var j=0;j<titleList.length;j++) {
      let item = titleList[j]
      let isNumArr = item.split('#')
      let isNum = isNumArr[1] == '千'
      let alignArr = isNumArr[0].split('_')
      let align = alignArr[1] == '左' ? 'left' : (alignArr[1] == '右' ? 'right' : 'center')
      let name = alignArr[0]
      if (defaultTitleList.indexOf(name) < 0) {
        let contentWidth = tools.textSize(row[item]).width + 20
        let keyWidth = tools.textSize(name).width + 20
        contentWidth = contentWidth < 100 ? 100 : contentWidth
        keyWidth = keyWidth < 100 ? 100 : keyWidth
        let width = contentWidth < keyWidth ? keyWidth : contentWidth
        width = width > 200 ? 200 : width
        if (trendColumns.length < trendColumsLen) {
          let obj = {name: name, label: name, index: name, width: width, align: align, sortable: false, formatter: function(cellvalue, options, rowObject){
              return fxjsCommonFun.getFormatter(rowObject, options.colModel.name, !isNum);
            }
          }
          trendColumns.push(obj)
        } else {
          if (trendColumns[j].width < width) {
            trendColumns[j].width = width
          }
        }
      }
    }
  }
  return trendColumns
}
module.exports = fxjsCommonFun;
