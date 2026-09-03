var yqtxsz = require("./yqtxsz.html");
avalon.component("yqtxsz",{
  template:yqtxsz,
  defaults: {
    dataList: [
      {dcode: 'A', dvalue1: '', dvalue2: ''},
      {dcode: 'B', dvalue1: '', dvalue2: ''},
      {dcode: 'C', dvalue1: '', dvalue2: ''},
      {dcode: 'C', dvalue1: '', dvalue2: ''}
    ],
    codeMap: {
      'A': '一类',
      'B': '二类',
      'C': '三类',
      'D': '四类'
    },
    onInit:function(){
      this.getDataList();
    },
    getDataList: function(){
      var self = this;
      ajax("POST", "/cxfw/zbrw/yqcs/list", {}).done(function (res) {
        if (res.code == '0') {
          var data = res.data
          var arr = []
          for(var i=0;i<data.length;i++) {
            var value = data[i].DVALUE.split(',')
            arr.push({dcode: data[i].DCODE, dvalue1: value[0], dvalue2: value[1] })
          }
          self.dataList = arr
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    },
    numberValid: function(index,key){
      this.dataList[index][key] = this.dataList[index][key].replace(/[^0-9]/g, '')
    },
    save: function(){
      var self = this;
      var arr = []
      for (var i=0;i<this.dataList.length;i++) {
        var item = this.dataList[i]
        if (!item.dvalue1 || !item.dvalue2) {
          tools.info('有必填项未填！');
          return false;
        }
        if (Number(item.dvalue1) >= Number(item.dvalue2)) {
          tools.info('逾期期限必须大于即将逾期期限');
          return false;
        }
        arr.push({dcode: item.dcode, dvalue: item.dvalue1 + ',' + item.dvalue2})
      }
      ajax("POST", "/cxfw/zbrw/yqcs/update", arr).done(function (res) {
        if (res.code == '0') {
          tools.info('保存成功！');
        } else {
          tools.info(res.msg);
        }
      }).fail(function (err) {
        tools.info(err);
      })
    }
  },
})