var wxxsbMx=require("./wxxsbMx.html");
avalon.component('wxxsbMx', {
    template:wxxsbMx,
    defaults: {
        params:{
            lcslid:"",
            bgd_no: "",
            ckhw_dlzm_no:"",
            pzhm:"",
        },
        form:{
            cksqb_num:0,
            ckjl_num:0,
            ck_amt:0,
            bgd_num:0,
            dlzm_num:0,
            hxd_num:0,
            sh_amt:0,
            yq_num:0,
            qtck_num:0,
            jhsqb_num:0,
            jhjl_num:0,
            zyfp_num:0,
            zysp_num:0,
            zzjk_num:0,
            xfjk_num:0,
            fpd_num:0,
            amt:0,
            se:0,
            zzs_se:0,
            xfs_se:0,
            ts_amt:0,
            zzs_ts_amt:0,
            xfs_ts_amt:0,
            byss_amt:0,
            bnss_amt:0,
            byzz_amt:0,
            bnzz_amt:0,
            byxf_amt:0,
            bnxf_amt:0,
            dlck_num:0,
            dlck_rec:0,
            dljk_num:0,
            dljk_rec:0,
            jljg_num:0,
            jljg_rec:0,
            lljghx_num:0,
            lljghx_rec:0,
            znx_num:0,
            znx_rec:0,
            tgbs_num:0,
            tgbs_rec:0,
            bbgd_num:0,
            bbgd_rec:0,
            bhxd_num:0,
            bhxd_rec:0,
            bdlzm_num:0,
            bdlzm_rec:0,
            hjcp_num:0,
            hjcp_rec:0,
        },
        onReady:function(){
            var self = this;
            this.init();
        },
        init:function(){
            var self=this;
            var params={
                lcslid:self.params.lcslid,
                bgd_no: self.params.bgd_no,
                ckhw_dlzm_no: self.params.ckhw_dlzm_no,
                pzhm: self.params.pzhm,
            }
            ajax("POST","/cxfw/wxxsbcx/second",params).done(function(res){
                if(res.code=='0'){
                    self.form=res.data;
                }else{
                    tools.info(res.msg)
                }
            }).fail(function(err){
                tools.info(err);
            })
        },
        printForm:function(e){
            $('.wxxxMx').print();
        },
        count:function(name){
            var sum=0;
            for(var i=0;i<this.form.rows.length;i++){
                if(!isNaN(this.form.rows[i][name])) {
                    sum += this.form.rows[i][name] - 0;
                }
            }
            return sum;
        },
    }
});