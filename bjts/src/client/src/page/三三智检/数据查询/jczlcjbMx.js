var jczlcjbMx=require("./jczlcjbMx.html");
avalon.component('jczlcjbMx', {
	template:jczlcjbMx,
	defaults: {
		params:{
      djxh: '',
      zlbdlx: ''
    },
    dataForm: {},
    myfsCheckList: ['来料加工'],
    onReady: function(){
      this.getData()
    },
    getData: function(){
      var self = this
      ajax("POST","/sszj/zbdata/cjbxx",{djxh: this.params.djxh}).done(function(res){
				if(res.code=='0'){
					self.dataForm = res.data
          self.myfsCheckList = self.dataForm.myfs.split(',')
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    }
  }
})