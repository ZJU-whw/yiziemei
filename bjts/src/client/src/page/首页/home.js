var home = require("./home.html")

avalon.component("home",{
    template: home,
    defaults: {
        data: "wellcome home",
        contents: [
            {month: "1月",invoiceNum: "",sehj:"",state: "2"},
            {month: "2月",invoiceNum: "",sehj:"",state: "2"},
            {month: "3月",invoiceNum: "",sehj:"",state: "2"},
            {month: "4月",invoiceNum: "",sehj:"",state: "2"},
            {month: "5月",invoiceNum: "",sehj:"",state: "2"},
            {month: "6月",invoiceNum: "",sehj:"",state: "2"},
            {month: "7月",invoiceNum: "",sehj:"",state: "2"},
            {month: "8月",invoiceNum: "",sehj:"",state: "2"},
            {month: "9月",invoiceNum: "",sehj:"",state: "2"},
            {month: "10月",invoiceNum: "",sehj:"",state: "2"},
            {month: "11月",invoiceNum: "",sehj:"",state: "2"},
            {month: "12月",invoiceNum: "",sehj:"",state: "2"},
        ],
        sssq:{
            CanCheckInvBDate:"",
            CanCheckInvEDate:"",
            CurrSubDate:"",
            CurrSubCheckedDate:"",
            CurrCheckYM:"",
            TJ:[]
        },
        monthArr:["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"],
        isHasPermissionLink: false,
        onInit: function(e) {
            components.home = e.vmodel;
        },
        onReady: function () {
            var nsrsbh = tools.GetQueryString('nsrsbh');
            if(nsrsbh){
                document.title = '便捷退税管理系统';
                var sbnypc = tools.GetQueryString('sbnypc');
                var entryId = tools.GetQueryString('entryId');
                window.location.hash = '#';
                var sssq = '';
                var sbpc = '';
                if(sbnypc.split('-').length>1){
                    sssq = sbnypc.split('-')[0];
                    sbpc = sbnypc.split('-')[1];
                }
                avalonRoot.addTab({
                    title: '审单核查查询',
                    component: 'dzhcRwcx',
                    params: {
                        sssq: sssq,
                        sbpc: sbpc,
                        entryId: entryId,
                        nsrsbh: nsrsbh,
                    }
                })
            }
            var self = this
            let timer = setInterval(()=>{
                if(Object.keys(avalonRoot.menuDict).length){
                    self.isHasPermissionLink = !!avalonRoot.menuDict['M_TSGZ_ZHXX']
                    clearInterval(timer)
                }
            },200)
            
            this.init()
        },
        toJsc: function(){
            window.open('/jdgl/dashboard/zhxx')
        },
        init:function(){
            let params = localStorage.getItem('DASHBOARD_JUMP')
            if(params){
                let jumpData = JSON.parse(params)
                var name = jumpData.name
                if(name == 'jcla'){
                    avalonRoot.addTab({
                        title: "稽查立案数据统计",
                        component: "ckqyjclasjtj",
                        sameCheck: false,
                        params: {
                            startDate:jumpData.startDate,
                            endDate:jumpData.endDate,
                            swjgdm:jumpData.swjgDm,
                            swjgMc:jumpData.swjgMc
                        },
                      });
                }else if(name == 'fxyd'){
                    avalonRoot.addTab({
                        title: "风险应对结果管理",
                        component: "fxdyjggl",
                        sameCheck: false,
                        params: {
                            startDate:jumpData.startDate,
                            endDate:jumpData.endDate,
                            swjgdm:jumpData.swjgDm,
                            swjgMc:jumpData.swjgMc
                        },
                      });
                }else if(name == 'hdsjtj'){
                    avalonRoot.addTab({
                        title: "函调数据统计",
                        component: "hdsjtj",
                        sameCheck: false,
                        params: {
                            startDate:jumpData.startDate,
                            endDate:jumpData.endDate,
                            swjgdm:jumpData.swjgDm,
                            swjgMc:jumpData.swjgMc
                        },
                      });
                }else if(name == 'sdhcsj'){
                    avalonRoot.addTab({
                        title: "实地核查数据统计",
                        component: "sdjcsjtj",
                        sameCheck: false,
                        params: {
                            startDate:jumpData.startDate,
                            endDate:jumpData.endDate,
                            swjgdm:jumpData.swjgDm,
                            swjgMc:jumpData.swjgMc
                        },
                      });
                }else if(name == 'hdsjtjMx'){
                    avalonRoot.addTab({
                        title: "函调数据查询",
                        component: "hdsjtjMx",
                        sameCheck: false,
                        params: {
                            selectType:jumpData.select,
                            startDate:jumpData.startDate,
                            endDate:jumpData.endDate,
                            swjgdm:jumpData.swjgDm,
                            swjgMc:jumpData.swjgMc,
                            rqlx:'0'
                        },
                      });
                } else if(name == 'sdhcsjMx'){
                    avalonRoot.addTab({
                        title: "稽查立案数据查询",
                        component: "sdjcsjtjMx",
                        sameCheck: false,
                        params: {
                            selectType:jumpData.select,
                            startDate:jumpData.startDate,
                            endDate:jumpData.endDate,
                            swjgDm:jumpData.swjgDm,
                            swjgMc:jumpData.swjgMc
                        },
                      });
                } else if(name == 'fxsjtj'){
                    avalonRoot.addTab({
                        title: "风险数据统计",
                        component: "fxsjtj",
                        sameCheck: false,
                        params: {
                            startDate:jumpData.startDate,
                            endDate:jumpData.endDate,
                            swjgdm:jumpData.swjgDm,
                            swjgMc:jumpData.swjgMc
                        },
                      });
                } else if(name == 'bagl'){
                    avalonRoot.addTab({
                        title: "企业单证备案情况查询",
                        component: "bagl",
                        sameCheck: false,
                        params: {
                            startDate:jumpData.startDate,
                            endDate:jumpData.endDate,
                            swjgdm:jumpData.swjgDm,
                            swjgMc:jumpData.swjgMc,
                            bazt:jumpData.bazt,
                        },
                      });
                } else if(name == 'sdhcqkcx'){
                    avalonRoot.addTab({
                        title: "审单核查情况查询",
                        component: "sdhcqkcx",
                        sameCheck: false,
                        params: {
                            startDate:jumpData.startDate,
                            endDate:jumpData.endDate,
                            swjgdm:jumpData.swjgDm,
                            swjgMc:jumpData.swjgMc,
                            hczt:jumpData.hczt,
                            jcjg:jumpData.jcjg?jumpData.jcjg:'',
                        },
                      });
                } else if(name == 'zxrcjdydtj'){
                    avalonRoot.addTab({
                        title: "专项日常监管疑点统计",
                        component: "zxrcjdydtj",
                        sameCheck: false,
                        params: {
                            startDate:jumpData.startDate,
                            endDate:jumpData.endDate,
                            swjgdm:jumpData.swjgDm,
                            swjgMc:jumpData.swjgMc,
                        },
                      });
                }
                localStorage.removeItem('DASHBOARD_JUMP')
            }

        }
    }
})