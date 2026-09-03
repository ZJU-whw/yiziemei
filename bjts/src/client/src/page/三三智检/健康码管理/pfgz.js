var pfgz=require("./pfgz.html");
avalon.component('pfgz', {
	template:pfgz,
	defaults: {
		params:{},
		act:1,
		tcode: "pfgzcx",
		scList: [],
		wmList: [],
    isEdit: false,
		onReady:function(){
      this.search();
      this.getEdit();
		},
		search:function(){
			var self=this;
			ajax("POST","/sszj/zbgl/qyjkm/pz/list",{}).done(function(res){
				if(res.code=='0'){
					self.scList = res.data.sc
					self.wmList = res.data.wm
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
		},
    save:function(){
      var self=this;
      var validSc = this.valid(this.scList)
      if (!validSc) return false;
      var validWm = this.valid(this.wmList)
      if (!validWm) return false;
      var params = {
        sc: this.scList,
        wm: this.wmList
      }
			ajax("POST","/sszj/zbgl/qyjkm/pz/save",params).done(function(res){
				if(res.code=='0'){
          tools.info('保存成功！');
					self.search();
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    },
    valid: function(data){
      var totalObj = data[data.length-1]
      var jkmTotal = 0
      var lineRedTotal = 0
      var lineYellowTotal = 0
      for (var i=0;i<data.length-1;i++) {
        var lineRed = Number(data[i].lineRed)
        var lineYellow = Number(data[i].lineYellow)
        var jkmTotalItem = Number(data[i].jkmTotal)
        jkmTotal += jkmTotalItem
        lineRedTotal += lineRed
        lineYellowTotal += lineYellow
        if (jkmTotalItem < lineRed) {
          tools.info('折算总分不能小于红线分数！');
          return false;
        }
        console.log(lineRed,lineYellow)
        if (lineRed < lineYellow){
          tools.info('红线分数不能小于黄线分数！');
          return false;
        }
      }
      if (jkmTotal != totalObj.jkmTotal) {
        tools.info('健康码（综合）折算总分必须等于6个业务分类的折算总分合计！');
        return false
      }
      if (totalObj.lineRed > lineRedTotal) {
        tools.info('健康码（综合）的红线不能大于6个业务分类的红线合计！');
        return false;
      }
      if (totalObj.lineYellow > lineYellowTotal) {
        tools.info('健康码（综合）的黄线不能大于6个业务分类的黄线合计！');
        return false;
      }
      return true;
    },
    getEdit: function(){
      var self = this
      ajax("POST","/sszj/zbgl/qyjkm/pz/edit",{}).done(function(res){
				if(res.code=='0'){
          self.isEdit = true
				}else if(res.code=='403'){
          self.isEdit = false
        }else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    }
	}
});