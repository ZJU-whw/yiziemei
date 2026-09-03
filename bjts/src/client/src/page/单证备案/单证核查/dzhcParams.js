var dzhcParams = require("./dzhcParams.html");

avalon.component('dzhcParams', {
  template:dzhcParams,
  defaults: {
    ywccblList: [ // 业务抽查比例
    ],
    ywccNum: 100, // 最大业务抽查数
    spdmCheckedList: [ // 意向商品代码 - 初始值
    ],
    spdmSearchList: [ // 意向商品代码 - 搜索
    ],
    mygCheckedList: [ // 贸易国 - 初始值
    ],
    mygSearchList: [ // 贸易国 - 搜索
    ],
    fobStart: 1000, // FOB价
    nameYwccbl: '出口业务抽查比例',
    nameYwccNum: '最大抽查业务数',
    nameSpdm: '意向商品代码',
    nameMyg: '敏感贸易国',
    nameFobstart: 'FOB价起点',
    paramsData: [],
    searchType: 'spdm',  // spdm-意向商品代码，myg-敏感贸易国

    onInit: function(e){
      avalonRoot.dzhcPararms = e.vmodel;
    },

    onReady: function(){
      this.search();
    },

    // 仅限输入数字
    inpChg: function(e){
      var val = e.target.value.replace(/[^0-9|\.]/g, '');
      if(val.split('.').length>2){
        val = parseFloat(val);
        val = isNaN(val)? 0: val;
      }
      val = val? val: 0;
      e.target.value = val;
      return val
    },
    inpChgYwccbl: function(e, ywItem){
      ywItem.ywccbl = this.inpChg(e);
      if(e.target.value>100){
        e.target.value = 0;
        tools.info('业务抽查比例不可超过100');
        return
      }
      // 处理负数情况
      for(var i=0; i<this.ywccblList.length; i++){
        if(this.ywccblList[i].ywccbl<0) this.ywccblList[i].ywccbl = -parseFloat(this.ywccblList[i].ywccbl);
      }
    },
    inpChgYwccnum: function(e){
      e.target.value = e.target.value.replace(/[^0-9]/g, '');
      if(e.target.value>200){
        tools.info('最大抽查业务数不可超过200');
        return false
      }
      return true
    },
    inpChgFob: function(e){
      this.inpChg(e);
      e.target.value = avalon.filters.number(e.target.value, 2);
    },
    getFobStart: function(){
      var fobStart = String(this.fobStart).replace(/,/g, '');
      fobStart = parseFloat(fobStart);
      if(fobStart<0) fobStart = -fobStart;
      return fobStart
    },

    // 检查业务抽查比例是否合规  等级越高比例越小
    ywccblCheck(){
      for(var i=1; i<this.ywccblList.length; i++){
        var start = parseFloat(this.ywccblList[i-1].ywccbl);
        var end = parseFloat(this.ywccblList[i].ywccbl);
        if(end>start){
          var text = '【' + this.ywccblList[i].range + (this.ywccblList[i].range.indexOf('以上')>-1? '': '笔') + '】的抽查比例不能超过【' + this.ywccblList[i-1].range + '笔】的抽查比例';
          tools.info(text);
          return false
        }
      }
      return true
    },

    rersetSpdmSearchList: function(type){
      var checkList = type=='spdm'? this.spdmCheckedList: this.mygCheckedList;
      var searchList = type=='spdm'? this.spdmSearchList: this.mygSearchList;
      var item = type=='spdm'? 'spdm': 'gbCode';
      for(var i=0; i<searchList.length; i++){
        searchList[i].checked = false;
        for(var j=0; j<checkList.length; j++){
          if(searchList[i][item] == checkList[j][item]){
            searchList[i].checked = true;
          }
        }
      }
    },

    // 删除已选择的意向商品
    spCheckDel: function(index, type){
      var checkList = type=='spdm'? this.spdmCheckedList: this.mygCheckedList;
      checkList.splice(index, 1);
      this.rersetSpdmSearchList(type);
    },

    // 意向商品代码勾选/取消勾选
    spSearchChg: function(index, type){
      var checkList = type=='spdm'? this.spdmCheckedList: this.mygCheckedList;
      var searchList = type=='spdm'? this.spdmSearchList: this.mygSearchList;
      var item = type=='spdm'? 'spdm': 'gbCode';
      if(searchList[index].checked){
        var spdmItem = tools.clone(searchList[index]);
        checkList.push(spdmItem);
      } else{
        var curIndex = -1;
        for(var i=0; i<checkList.length; i++){
          if(checkList[i][item] == searchList[index][item]){
            curIndex = i;
          }
        }
        checkList.splice(curIndex, 1);
      }
    },

    // 意向商品代码搜索
    spdmSearchChg: function(e){
      var self = this;
      var spdm = e.target.value;
      if(spdm.length<4) return
      var params = {
        spdm: spdm,
      }
      api.dzbaInspectYearHgspList(params).done(function(res){
        if(res.code=='0'){
          if(!res.data) {
            self.spdmSearchList = [];
            return
          }
          for(var i=0; i<res.data.length; i++){
            res.data[i].checked = false;
          }
          self.spdmSearchList = res.data;
          $(".dzhc-params .dropdown-menu.spdm").show();
          self.rersetSpdmSearchList('spdm');
        }
      })
    },

    // 贸易国代码搜索
    mygSearchChg: function(e){
      var self = this;
      var gbxx = e.target.value;
      // 如果是数字，要求三位
      if(/^[\d|a-z]+$/.test(gbxx) && gbxx.length<3) return;
      if(gbxx.length<2) return
      var params = {
        gbxx: gbxx,
      }
      api.dzbaInspectYearBgxxGet(params).done(function(res){
        if(res.code=='0'){
          if(!res.data) {
            self.mygSearchList = [];
            return
          }
          self.mygSearchList = [
            {
              gbCode: res.data.gbCode,
              gbName: res.data.gbName,
              checked: false,
            }
          ];
          $(".dzhc-params .dropdown-menu.myg").show();
          self.rersetSpdmSearchList('myg');
        }
      })
    },

    // 保存
    save: function(){
      var self = this;
      // 检查业务抽查比例是否合规  等级越高比例越小
      if(!this.ywccblCheck()) return
      // 最大抽查业务数检查
      if(this.ywccNum>200){
        tools.info('最大抽查业务数不可超过200');
        return false
      }
      var fobStart = this.getFobStart();
      for(var i=0; i<this.paramsData.length; i++){
        var item = this.paramsData[i];
        if(item.configType=='02'){
          item.configValue = this.ywccblList;
        } else if(item.configType=='03'){
          item.configValue = this.ywccNum || '';
        } else if(item.configType=='04'){
          item.configValue = this.spdmCheckedList;
        } else if(item.configType=='05'){
          item.configValue = this.mygCheckedList;
        } else if(item.configType=='06'){
          item.configValue = fobStart || '';
        }
      }
      var params = {
        configData: this.paramsData,
      }
      api.dzbaInspectConfigureSave(params).done(function(res){
        if(res.code=='0'){
          tools.info('保存成功');
          self.search();
        }
      })
    },

    // 查询
    search: function(){
      var self = this;
      api.dzbaInspectConfigureList({}).done(function(res){
        if(res.code=='0'){
          if(!res.data) return
          self.paramsData = res.data;
          self.spdmCheckedList = [];
          self.mygCheckedList = [];
          for(var i=0; i<res.data.length; i++){
            var item = res.data[i];
            if(item.configType=='02'){
              self.nameYwccbl = item.configTypeName;
              self.ywccblList = item.configValue;
            } else if(item.configType=='03'){
              self.nameYwccNum = item.configTypeName;
              self.ywccNum = item.configValue || '';
            } else if(item.configType=='04'){
              self.nameSpdm = item.configTypeName;
              var v1 = item.configValue || [];
              self.spdmCheckedList = self.spdmCheckedList.concat(v1);
            } else if(item.configType=='05'){
              self.nameMyg = item.configTypeName;
              var v2 = item.configValue || [];
              self.mygCheckedList = self.mygCheckedList.concat(v2);
            } else if(item.configType=='06'){
              self.nameFobstart = item.configTypeName;
              self.fobStart = avalon.filters.number(item.configValue, 2);
            }
          }
        }
      })
    },

    showDropdown: function (e, targetCls) {
      var self = this;
      if($(e.target, '.dzhc-params .dropdown').length>0 && $(e.target).parent().length>0){
        e.target = $(e.target).parent()[0];
      }
      $(".dropdown-menu."+targetCls, e.target).show();
      $('#dzhcParams'+targetCls).focus();
      $('.dzhc-params').on('click', function (e) {
        var e = e || window.event;
        if ($('.dropdown-menu.'+targetCls).find($(e.target)).length <= 0) {
          self.hideDropdown(targetCls);
        }

      })
    },
    hideDropdown: function (targetCls) {
      $(".dropdown-menu."+targetCls).hide();
      $('.dzhc-params').off('click');
    },

    showModelSearch: function(type){
      this.searchType = type;
      $('.model').show();
      $('.dzhc-params .page-model-search').show();
    },
    hideModelSearch: function(){
      $('.model').hide();
      $('.dzhc-params .page-model-search').hide();
    },
  },
})