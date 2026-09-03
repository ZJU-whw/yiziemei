var jkmpfgz=require("./jkmpfgz.html");
avalon.component('jkmpfgz', {
	template:jkmpfgz,
	defaults: {
		params:{},
		act:1,
		tcode: "jkmpfgzcx",
		scList: [],
		wmList: [],
    swjgDm: '',
    swjgmc: '',
		onReady:function(){
      try {
				this.swjgDm=avalonRoot.user.swjgDm;
				this.swjgmc=avalonRoot.user.swjgMc;
			} catch (e) {

			}
      this.search();
      this.initTree();
		},
		search:function(){
			var self=this;
			ajax("POST","/sszj/jkmpd/pzList",{swjgDm: this.swjgDm}).done(function(res){
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
      var pzList = this.scList.concat(this.wmList)
      var params = {
        swjgDm: this.swjgDm,
        pzList: pzList
      }
			ajax("POST","/sszj/jkmpd/pzSave",params).done(function(res){
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
    initTree:function() {
			var self = this;
			var setting = {
				callback:{
					onClick:function(e,id,node){
						self.swjgDm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
            self.search();
						return;
					},
					onDblClick:function(e,id,node){
						self.swjgDm = node.id;
						self.swjgmc = node.text;
						self.hideTree();
            self.search();
						return;
					}
				},
				data:{key:{children:"item",name:"text"}}
			};
			tools.getCachedSwjg(avalonRoot,ajax).done(function (data) {
				$.fn.zTree.init($(".jkmpfgz .jkmpfgzSwjgTree.treeDiv"), setting,data);
			}).fail(function (err) {
				tools.info(err);
			});
		},
    showTree:function(e){
			var self=this;
			$(".treeDiv",$(e.target).parent()).show();
			$('.jkmpfgz').on('click',function(e){
				var e=e||window.event;
				if($('.treeDiv').find($(e.target)).length<=0){
					self.hideTree();
				}
			})
		},
		hideTree:function(){
			$(".treeDiv").hide();
			$('.jkmpfgz').off('click');
		},
	}
});