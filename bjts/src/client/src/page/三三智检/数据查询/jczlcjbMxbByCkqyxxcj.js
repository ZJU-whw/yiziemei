var jczlcjbMxbByCkqyxxcj=require("./jczlcjbMxbByCkqyxxcj.html");
avalon.component('jczlcjbMxbByCkqyxxcj', {
	template:jczlcjbMxbByCkqyxxcj,
	defaults: {
		params:{
      djxh: '',
      zlbdlx: '',
      nsrsbh: '',
      tsjsfs: ''
    },
    dataForm: {},
    yjbgcsCq: [],
    onReady: function(){
      this.getData()
    },
    getData: function(){
      var self = this
      var params = {
        nsrsbh: this.params.nsrsbh,
        cjlx: 'a'
      }
      ajax("POST","/sszj/zbdata/ckqycjxx/get",params).done(function(res){
				if(res.code=='0'){
					self.dataForm = res.data
          self.yjbgcsCq = self.dataForm.yjbgcsCq.split(',')
				}else{
					tools.info(res.msg);
				}
			}).fail(function(err){
				tools.info(err);
			})
    }
  }
})