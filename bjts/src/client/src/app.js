require("../static/css/app.css");
require("./filters");
import api from "../static/js/api.js";
window.api = api;

avalon.ready(function () {
    avalon.config({
        debug: false
        // debug: true
    })
    //引入子页面
    require("./component");
    window.components={};
    window.avalonRoot = avalon.define({
        $id: "app",
        name: "app",
        version: "1.0.0",
        yjxxzhcx: "",
        bbtest: "",
        menuDict: {},
        activeTabIndex: -1,
        hideHeader: false,
        //配置菜单
        menus:{
          tsgz: {
            id: "M_TSGZ",
            title: "态势感知",
            tip: "态势感知",
            icon: "icon-fptj",
        		children: [
              { id: "M_TSGZ_ZHXX", title: "出口退（免）税综合信息态势感知", component: "-1", params: {}, children: [], url: '/jdgl/dashboard/zhxx/' },
              { id: "M_TSGZ_DZBA", title: "备案单证数字化管理态势感知", component: "-1", params: {}, children: [], url: '/jdgl/dashboard/' },
        		  { id: "M_TSGZ_TJBB", title: "态势感知出口退税分类情况统计", component: "-1", params: {}, children: [], url: '/jdgl/dashboard/tjbb' },
        		  { id: "M_TSGZ_FXJKZL", title: "全省企业风险健康总览", component: "ckqyfxjkxx", params: {}, children: [] }
        		]
        	},
          rcgl: {
            id: "M_RCGL",
            title: "日常管理",
            tip: "日常管理",
            icon: "icon-fzgl",
            children: [
              {
                // id: "M_JCXXCX",
                title: "企业基本信息查询",
                children: [
                  { id: "M_QYXXCX", title: "企业信息一户式查询", component: "qyjcxx", params: {}, children: [] }
                ]
              },
              {
                // id: "M_DZBA",
                title: '备案单证管理',
                children: [
                  // { id: "M_DZBA_TSGZ", title: "备案单证数字化管理态势感知", component: "-1", params: {}, children: [], url: '/jdgl/dashboard/' },
                  {
                    // id: "M_DZBA_CXTJ",
                    title: "企业备案单证数字化管理情况",
                    children: [
                      { id: "M_DZBA_CGTJ", title: "备案单证数字化管理成果统计", component: "dzbaCgtj", params: {}, children: [] },
                      { id: "M_DZBA_QKFX", title: "备案单证数字化管理情况分析", component: "dzbaQkfx", params: {}, children: [] },
                      { id: "M_DZBA_KTQY", title: "开通数字化单证备案企业查询", component: "zgsh", params: {}, children: [] },
                      { id: "M_DZBA_WKTQY", title: "未开通数字化单证备案企业查询", component: "wktDzbaQycx", params: {}, children: [] },
                      { id: "M_DZBA_BARWCX", title: "企业单证备案情况查询", component: "bagl", params: {}, children: [] },
                      { id: "M_DZBA_SHQKCX", title: "单证核查情况查询", component: "dzshqkcx", params: {}, children: [] },
                      { id: "M_DZBA_HCRWTJ", title: "单证核查结果分类统计", component: "hcrwtj", params: {}, children: [] },
                      { id: "M_DZBA_FHHCTJ", title: "单证核查结果分户统计", component: "fhhctj", params: {}, children: [] },
                      { id: "M_DZBA_DQTJ", title: "各地区单证备案情况统计", component: "dzbaqktj", params: {}, children: [] },
                      { id: "M_DZBA_TGQKTJ", title: "备案单证数字化管理推广情况统计", component: "batgTj", params: {}, children: [] },
                      // { id: "M_DZBA_TJBB", title: "态势感知出口退税分类情况统计", component: "-1", params: {}, children: [], url: '/jdgl/dashboard/tjbb' }
                    ]
                  },
                  {
                    // id: "M_DZBA_RCSDHC",
                    title: "日常审单核查",
                    children: [
                      { id: "M_DZBA_RCSDHC_ZB", title: "审单核查在办", component: "dzhcZbrw", params: {}, children: [] },
                      { id: "M_DZBA_RCSDHC_CX", title: "审单核查查询", component: "dzhcRwcx", params: {}, children: [] }
                    ]
                  },
                  {
                    // id: "M_DZBA_NDDZHC",
                    title: "年度单证核查",
                    children: [
                      { id: "M_DZBA_NDDZHC_LX", title: "单证核查立项", component: "dzhcLxgl", params: {}, children: [] },
                      { id: "M_DZBA_NDDZHC_SH", title: "单证核查审核", component: "dzhcDzsh", params: {}, children: [] },
                      { id: "M_DZBA_NDDZHC_FH", title: "单证核查复核", component: "dzhcDzfh", params: {}, children: [] },
                      { id: "M_DZBA_NDDZHC_CSPZ", title: "核查规则设置", component: "dzhcParams", params: {}, children: [] }
                    ]
                  },
                  {
                    // id: "M_DZBA_DZHCQKCX",
                    title: "单证核查情况查询",
                    children: [
                      { id: "M_DZBA_SDHCCX", title: "审单核查情况查询", component: "sdhcqkcx", params: {}, children: [] },
                      { id: "M_DZBA_RCSDHXTJ", title: "审单核查情况统计", component: "rcsdhcTj", params: {}, children: [] },
                      { id: "M_DZBA_RCSDHXTJ_FH", title: "审单核查情况(分户)统计", component: "rcsdhcFhTj", params: {}, children: [] },
                      { id: "M_DZBA_RCSDHXTJ_MONTH", title: "审单核查情况(月度)统计", component: "rcsdhcYdTj", params: {}, children: [] },
                      { id: "M_DZBA_NDDZHC_GZKH", title: "年度单证核查工作考核统计", component: "ndhckhTj", params: {}, children: [] }
                    ]
                  },
                  { id: "M_DZBA_HCGL", title: "单证核查", component: "hcgl", params: {}, children: [] }
                ]
              },
              {
                // id: "M_TSJH",
                title: "退税计划管理",
                children: [
                  { id: "M_TSJHXDWH", title: "退税计划下达维护", component: "tsjhxdwh", params: {}, children: [] },
                  {
                    // id: "M_TSZBCS",
                    title: "退税指标测算调查",
                  	children: [
		                  { id: "M_TSZBCS_CX", title: "出口企业退税预测情况查询", component: "dcbcx", params: {}, children: [] },
		                  { id: "M_TSZBCS_SBZT", title: "退税预测企业报送状态查询", component: "sbzt", params: {}, children: [] },
		                  { id: "M_TSZBCS_SYQK", title: "各地企业调查表使用情况统计", component: "syqk", params: {}, children: [] },
		                  { id: "M_TSZBCS_ZDQY", title: "退税预测重点企业名册", component: "tsyczdqymc", params: {}, children: [] },
		                  { id: "M_TSZBCS_JDRZ", title: "退税预测不符接单日志", component: "tsycbfjdrz", params: {}, children: [] },
		                  { id: "M_TSZBCS_TJ4TSXQ", title: "退税需求情况统计", component: "tsxq", params: {}, children: [] },
		                  { id: "M_TSZBCS_TJ4DDBD", title: "订单变动情况统计", component: "ddbd", params: {}, children: [] }
                  	]
                  },
                  {
                    // id: "M_SRTHS",
                    title: "收入退还书",
                  	children: [
		                  { id: "M_SRTHSQD_SC", title: "收入退还书清单生成", component: "srths_sc", params: {}, children: [] },
		                  { id: "M_SRTHSQD", title: "收入退还书清单查询", component: "srths", params: {}, children: [] }
                  	]
                  },
                  {
                    // id: "M_TKTZS",
                    title: "调库通知书",
                  	children: [
                      { id: "M_TKTZSQD_SC", title: "调库通知书清单生成", component: "tktzs_sc", params: {}, children: [] },
                      { id: "M_TKTZSQD", title: "调库通知书清单查询", component: "tktzs", params: {}, children: [] }
                  	]
                  },
                  {
                    // id: "M_CKTSFN",
                    title: "出口退税返纳",
                  	children: [
                      { id: "M_TSFNCXZG", title: "退税返纳查询(征管)", component: "fncxzg", params: {}, children: [] },
                      { id: "M_TSFNCXCK", title: "退税返纳查询(出口)", component: "fncxck", params: {}, children: [] },
                      { id: "M_CKTSFNDZ", title: "出口退税返纳对账", component: "fncxdz", params: {}, children: [] }
                  	]
                  },
                  { id: "M_CKTSBLQKCX", title: "出口退税办理情况查询", component: "blqk", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_HZBB",
                title: "报表管理",
                name: 'tjbb',
                children: [
                  { id: "M_DBRWLB", title: "报表生成", component: "rwlb", params: {}, children: [] },
                  { id: "M_ZJCKTSYBB", title: "总局出口退税月报表", component: "", params: {}, children: [] },
                  { id: "M_ZJZXBB", title: "总局专项报表", component: "", params: {}, children: [] },
                  { id: "M_SJCKTSYBB", title: "省局出口退税月报表", component: "", params: {}, children: [] },
                  { id: "M_HZBB_ZJZXBB2", title: "总局专项报表（二）", component: "", params: {}, children: [] },
                  { id: "M_HZBB_KJDS", title: "跨境电商统计表", component: "", params: {}, children: [] },
                  { id: "M_HZBB_SCCG", title: "市场采购情况统计表", component: "", params: {}, children: [] },
                  { id: "M_HZBB_BJJZ", title: "出口退税月报表（不计结转）", component: "", params: {}, children: [] },
                  { id: "M_VDBRWLB", title: "自定义合并（地区）报表", component: "virtualRwlb", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_TJFX",
                title: "统计分析",
                children: [
                  { id: "M_CKTSWMCK", title: "出口退税和外贸出口情况", component: "cktshwmck", params: {}, children: [] },
                  { id: "M_DQCKTS", title: "分地区出口退税基本情况", component: "dqckts", params: {}, children: [] },
                  { id: "M_FDLSPCK", title: "分大类商品出口数据统计", component: "fdlsp", params: {}, children: [] },
                  { id: "M_CKMYGJFB", title: "出口贸易国家分布查询统计", component: "ckmygjfb", params: {}, children: [] },
                  { id: "M_CKQYPMSH", title: "出口企业排名(审核数据口径)", component: "qypmsh", params: {}, children: [] },
                  { id: "M_CKQYPMBGD", title: "出口企业排名(报关单数据口径)", component: "qypmbgd", params: {}, children: [] },
                  { id: "M_CKSPTSLFB", title: "出口商品退税率分布情况统计", component: "sptslfb", params: {}, children: [] },
                  { id: "M_SCQYHYFB", title: "出口企业行业分布情况统计", component: "ckqyhyfb", params: {}, children: [] },
                  { id: "M_CKHGFB", title: "出口海关分布情况统计", component: "ckhgfb", params: {}, children: [] },
                  { id: "M_CKJGFS", title: "出口监管方式情况统计表", component: "ckjgfs", params: {}, children: [] },
                  { id: "M_WMGHQYFX", title: "外贸供货企业分析", component: "wmghqy", params: {}, children: [] },
                  { id: "M_TJRWCX", title: "统计任务查询", component: "jgcx", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_JCFX",
                title: "监测分析",
                children: [
                  { id: "M_ZHZBFZ", title: "综合指标分组汇总统计", component: "zhzbfzhztj", params: {}, children: [] },
                  { id: "M_TJZB", title: "出口退（免）税统计总表", component: "cktstjzb", params: {}, children: [] },
                  { id: "M_XSJCTJ", title: "出口退（免）税形势监测统计表", component: "cktsxsjctjb", params: {}, children: [] },
                  { id: "M_CKQKTJ", title: "出口退税情况统计表", component: "ckqktjb", params: {}, children: [] },
                  { id: "M_FPQKTJ", title: "发票情况统计表", component: "fpqktjb", params: {}, children: [] },
                  { id: "M_CWQKTJ", title: "财务情况统计表", component: "cwqktjb", params: {}, children: [] },
                  { id: "M_TSYWCX", title: "出口企业特殊业务信息综合查询表", component: "ckqytsywxx", params: {}, children: [] },
                  { id: "M_SCCGCKQK", title: "市场采购监管方式出口情况", component: "sccgjgfsckqk", params: {}, children: [] },
                  { id: "M_HDJDSSCX", title: "函调进度实时查询表", component: "hdjdsscx", params: {}, children: [] },
                  { id: "M_WMYJZTTJB", title: "外贸出口经营主体情况统计表", component: "wmckjyzt", params: {}, children: [] },
                  { id: "M_YBQYWH", title: "样本企业维护", component: "ybqywh", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_TZGL",
                title: "通知管理",
                children: [
                  { id: "M_TZTX", title: "通知提醒", component: "tztx", params: {}, children: [] },
                  { id: "M_QYTZFBGL", title: "企业通知发布管理", component: "qytzfb", params: {}, children: [] },
                  { id: "M_QYLSTZCX", title: "企业历史通知查询", component: "qylstz", params: {}, children: [] },
                  { id: "M_SWTZFBGL", title: "税务通知发布管理", component: "swtzfb", params: {}, children: [] },
                  { id: "M_SWLSTZCX", title: "税务历史通知查询", component: "swlstz", params: {}, children: [] },
                  { id: "M_PXFBWH", title: "培训发布维护", component: "pxwh", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_FLGLPDZB",
                title: "分类管理评定指标",
                children: [
                  { id: "M_FLGLPD_JCXXTJ", title: "基础信息统计", component: "flgljcxx", params: {}, children: [] },
                  { id: "M_FLGLPD_DTTXCX", title: "动态提醒查询", component: "flgldttx", params: {}, children: [] }
                ]
              },
              // { id: "M_RCGL_SDQY", title: "跨境电商9810试点企业", component: "kjdssd", params: {}, children: [] },
              { id: "M_RCGL_YTSQY", title: "9810预退税企业", component: "ytsqy", params: {}, children: [] },
              {
              	// id: "M_RCGL_CQWSB",
                title: "长期未申报业务管理",
                children: [
                  // { id: "M_RCGL_CQWSB_YZQCL", title: "依职权处理", component: "yzqcl", params: {}, children: [] },
                  { id: "M_RCGL_CQWSB_YZQCL", title: "不适用退免税政策出口明细查询", component: "bsyckmts", params: {}, children: [] },
                  { id: "M_RCGL_CQWSB_WSHMXCX", title: "待审核业务处理", component: "dshywcl", params: {}, children: [] },
                  { id: "M_RCGL_CQWSB_SHMXCX", title: "明细查询与审核", component: "shmxcx", params: {}, children: [] },
                  { id: "M_RCGL_CQWSB_SHRWTJ", title: "审核任务统计", component: "shrwtj", params: {}, children: [] },
                  { id: "M_RCGL_CQWSB_FJCX", title: "附件管理", component: "fjlb", params: {}, children: [] },
                ]
              },
            ]
          },
          shgl: {
           	id: "M_SHGL",
            title: "审核管理",
            tip: "审核管理",
            icon: "icon-ckfp",
            children: [
              {
              	// id: "M_JDGL",
                title: "接单管理",
                children: [
                  { id: "M_JDRCX", title: "接单人查询", component: "jdrcx", params: {}, children: [] },
                  { id: "M_JDRWH", title: "接单人维护", component: "jdrwh", params: {}, children: [] },
                  { id: "M_JDFSWH", title: "接单方式维护", component: "jdfswh", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_SHFHFZ",
                title: "审核分户分组",
                children: [
                  { id: "M_YDFLTSSZ", title: "疑点分类推送规则设置", component: "tsgzsz", params: {}, children: [] },
                  { id: "M_SJTSGWRY", title: "随机推送岗位人员设置", component: "tsrysz", params: {}, children: [] },
                  { id: "M_FZTSQYQD", title: "分组推送企业清册维护", component: "fztswh", params: {}, children: [] },
                  { id: "M_FZTSGWPL", title: "分组推送岗位批量调整", component: "gwpltz", params: {}, children: [] },
                  { id: "M_FZTSGWDH", title: "分组推送岗位查询和修改", component: "fztscxxg", params: {}, children: [] }
                ]
              },
              { id: "M_SBFJDY", title: "申报附件调阅", component: "sbfjyl", params: {}, children: [] },
              {
              	// id: "M_CDGL",
                title: "撤单管理",
                children: [
                  { id: "M_CDDZFXGL", title: "撤单单证放行管理", component: "cddzfxgl", params: {}, children: [] },
                  { id: "M_CDSQZHCX", title: "撤单综合查询", component: "cdzhcx", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_ZMGL",
                title: "证明开具查询",
                children: [
                  { id: "M_DZZMRZCX", title: "电子证明日志查询", component: "dzzmrz", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_SBXXCX",
                title: "申报审核信息查询",
                children: [
                  { id: "M_SCQYSBCX", title: "生产企业申报查询", component: "scqysb", params: {}, children: [] },
                  { id: "M_WMQYSBCX", title: "外贸企业申报查询", component: "wmqysb", params: {}, children: [] },
                  { id: "M_FWMYSBCX", title: "服务贸易申报查询", component: "fwmysb", params: {}, children: [] },
                  { id: "M_WZFQYSBCX", title: "外综服企业申报查询", component: "wzfqysb", params: {}, children: [] },
                  { id: "M_GJZYHWSBCX", title: "其他业务申报查询", component: "gjzyhwsb", params: {}, children: [] },
                  { id: "M_JLJGSCHXCX", title: "进料加工手册核销查询", component: "jljg", params: {}, children: [] },
                  { id: "M_LLJGZMHXCX", title: "来料加工证明核销查询", component: "lljg", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_WSBXXCX",
                title: "未申报信息查询",
                children: [
                  { id: "M_WSBBGDCX", title: "未申报报关单查询", component: "wsbgd", params: {}, children: [] },
                  { id: "M_YQSBSJCX", title: "延期申报数据查询", component: "yqsbsj", params: {}, children: [] },
                  { id: "M_WXXSBSJCX", title: "无信息申报数据查询", component: "wxxsbsj", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_SHENHEXXCX",
                title: "核准办理信息查询",
                children: [
                  { id: "M_CKTSFNQKCX", title: "出口退税返纳情况查询", component: "cktsfn", params: {}, children: [] },
                  { id: "M_ZKSKQKCX", title: "暂扣税款情况查询", component: "zksk", params: {}, children: [] },
                  { id: "M_BYTSQKCX", title: "不予退税情况查询", component: "byts", params: {}, children: [] },
                  { id: "M_CKTSSHSPBCX", title: "出口退税核准办理情况查询", component: "shspb", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_SHOUHUIXXCX",
                title: "收汇信息查询",
                children: [
                  { id: "M_SHSJCX", title: "收汇数据查询", component: "shsj", params: {}, children: [] },
                  { id: "M_YQJHQKCX", title: "远期结汇情况查询", component: "yqjh", params: {}, children: [] },
                  { id: "M_SHSHQKCX", title: "视同收汇情况查询", component: "stsh", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_HDSJCX",
                title: "函调数据查询",
                children: [
                  { id: "M_FHCX", title: "发函查询", component: "fhcx", params: {}, children: [] },
                  { id: "M_JSHSHCX", title: "接收核实函查询", component: "jshsh", params: {}, children: [] },
                  { id: "M_HDQKTJ", title: "函调情况统计", component: "hdqktj", params: {}, children: [] },
                ],
              }
            ]
          },
          fxgl: {
          	id: "M_FXGL",
            title: "风险管理",
            tip: "风险管理",
            icon: "icon-sjtb",
            children: [

              {
                // id: "M_SXYJ",
                title: "三新预警",
                children: [
		              
		              { id: "M_YJXXZHCX", title: "事前预警信息综合查询", component: "yjxxzhcx", params: {}, children: [] },
                  { id: "M_YJPGCL", title: "预警评估处理", component: "yjpg", params: {}, children: [] },
		              { id: "M_YJCSSZ", title: "事前预警指标及参数设置", component: "yjdmcs", params: {}, children: [] },
		              {
		              	// id: "M_JBXXKWH",
		                title: "事前预警信息库维护",
		                children: [
                      { id: "M_YCGHQY", title: "异常供货企业", component: "ycghqywh", params: {}, children: [] },
                      { id: "M_MTSMGKA", title: "外贸出口敏感口岸", component: "wmmtsxxwh", params: {}, children: [] },
                      { id: "M_MDTCJKA", title: "生产企业常见口岸", component: "scmdtkacx", params: {}, children: [] },
                      { id: "M_YCHDXX", title: "异常函调信息", component: "ychdxxkcx", params: {}, children: [] },
                      { id: "M_MGSP", title: "风险商品名单", component: "mgspxxkwh", params: {}, children: [] },
	                    { id: "M_YJBMDWH", title: "预警白名单企业", component: "yjbmdwh", params: {}, children: [] },
                  		{ id: "M_FXYWCS_SP", title: "商品风险出口规则维护", component: "spfxckwh", params: {}, children: [] },
                  		{ id: "M_FXYWCS_GH", title: "商品风险供货维护", component: "spfxghwh", params: {}, children: [] }
		                ]
		              },
		              {
		              	// id: "M_CKSPPJDJCX",
		                title: "出口商品平均单价查询",
		                children: [
		                  { id: "M_SCQYPJDJ", title: "生产企业商品平均单价", component: "scsppjdjcx", params: { type: 1 }, children: [] },
		                  { id: "M_WMQYPJDJ", title: "外贸企业商品平均单价", component: "wmsppjdjcx", params: { type: 2 }, children: [] }
		                ]
		              },
		              { id: "M_SXYJ_MMYLR", title: "每美元利润率统计结果查询", component: "mmylltjcx", params: {}, children: [] },
                      { id: "M_SXYJ_BGDGZXX", title: "报关单关注信息管理", component: "bgdgzxxgl", params: {}, children: [] },
                      { id: "M_SXYJ_FXBGH", title: "总局下发风险报关行", component: "fxbgh", params: {}, children: [] }
                ]
              },
              {
              	// id: 'M_SSZJ',
              	title: '三三智检',
              	children: [
              		{ id: "M_ZHSJZS", title: "出口退（免）税态势感知综合数据展示", component: "tsgzzhsjzs", params: {}, children: [] },
		              // { id: "M_FXJKZL", title: "全省企业风险健康总览", component: "ckqyfxjkxx", params: {}, children: [] },
		              {
		              	// id: "M_ZBCX",
		                title: '风险基础指标查询',
		                children: [
		                  { id: "M_ZBCX_TJJG", title: "出口企业指标统计一户式查询", component: "zbtjjg", params: {}, children: [] },
		                  { id: "M_JCZLCJB", title: "出口企业基础资料采集表查询", component: "jczlcjb", params: {}, children: [] }
		                ]
		              },
		              {
		              	// id: "M_ZHZBSXQ",
                		title: '综合风险指标筛选器',
                		children: [
                  		{ id: "M_DXZBY_SJCXFX", title: "单项指标（元）数据查询分析", component: "dxzbsjcxfx", params: {}, children: [] },
                  		{ id: "M_XSXMGL", title: "筛选项目管理", component: "sxxmgl", params: {}, children: [] },
                  		{ id: "M_GXFACX", title: "共享方案查询", component: "shareFaCx", params: {}, children: [] },
                  		{ id: "M_TYSJCXQ", title: "通用数据查询", component: "tysjcxq", params: {}, children: [] },
                  		{ id: "M_YBQYFX", title: "样本企业分析", component: "ybqyzbfx", params: {}, children: [] }
            		    ]
              		},
              		{
              			// id: "M_JKM",
              			title: '健康码管理',
              			children: [
              				{ id: "M_JKM_CX", title: "健康码查询", component: "jkmcx", params: {}, children: [] },
                  		{ id: "M_JKM_GZ", title: "评分规则配置", component: "pfgz", params: {}, children: [] },
                  		{ id: "M_JKMPD", title: "健康码评定", component: "jkmPd", params: {}, children: [] },
                  		{ id: "M_JKMPD_FH", title: "健康码评定（复核）", component: "jkmPdFh", params: {}, children: [] },
                  		{ id: "M_JKMPDJL_CX", title: "健康码评定记录查询", component: "jkmPdRecord", params: {}, children: [] }
              			]
              		},
              		{ id: "M_QYHXBG", title: "企业画像报告", component: "qyhxbg", params: {}, children: [] },
                  {
              			// id: "M_ZDYSZ",
                  	title: '自定义设置',
                  	children: [
                      { id: "M_ZDYSZ_CSSZ", title: "指标参数设置", component: "zbcssz", params: {}, children: [] },
                      { id: "M_ZDYSZ_FXDQ", title: "风险地区维护", component: "fxdqwh", params: {}, children: [] },
                      { id: "M_ZDYSZ_MGSP", title: "敏感商品维护", component: "mgspwh", params: {}, children: [] },
                      { id: "M_ZDYSZ_FXQY", title: "风险企业维护", component: "fxqywh", params: {}, children: [] },
                      { id: "M_JKM_PFGZ_SZ", title: "健康码评分规则设置", component: "jkmpfgz", params: {}, children: [] }
                  	]
                  },
                  {
                  	// id: "M_ZB",
                  	title: "指标管理",
                  	children: [
                      { id: "M_ZB_ZBY", title: "数据源配置", component: "sjypz", params: {}, children: [] },
                      { id: "M_ZB_TB", title: "数据表配置", component: "sjbpz", params: {}, children: [] },
                      { id: "M_ZB_ZBX", title: "数据项配置", component: "sjxpz", params: {}, children: [] },
                      { id: "M_ZB_ZBU", title: "指标元配置", component: "zbypz", params: {}, children: [] },
                      { id: "M_ZB_PZ", title: "指标配置", component: "zbpz", params: {}, children: [] }
                  	]
                  },
                  {
                  	// id: "M_BLQYGL",
                    title: "不良企业管理",
                    children: [
                      { id: "M_BLQYXXWH", title: "不良企业信息维护", component: "blqyxxwh", params: {}, children: [] },
                      { id: "M_BLQYXXCX", title: "不良企业信息查询", component: "blqyxxcx", params: {}, children: [] }
                    ]
                  },
                  {
                  	// id: "M_YWY",
                		title: "业务员管理",
                		children: [
                  		{ id: "M_YWY_CX", title: "业务员查询", component: "ywyba", params: {}, children: [] },
                  		{ id: "M_YWY_QR", title: "业务员确认", component: "ywyqr", params: {}, children: [] },
                  		{ id: "M_YWY_FX", title: "风险业务员维护", component: "fxywywh", params: {}, children: [] },
                  		{ id: "M_YWYBACX", title: "业务员备案查询", component: "ywybacx", params: {}, children: [] }
                		]
              		}
              	]
              },
              {
              	// id: 'M_FXYD',
              	title: '风险应对管理',
              	children: [
              		{ id: "M_FXYDJG", title: "风险应对结果管理", component: "fxdyjggl", params: {}, children: [] },
              		{ id: "M_FXSJTJ", title: "风险数据统计", component: "fxsjtj", params: {}, children: [] },
              		{ id: "M_HDSJTJ", title: "函调数据统计", component: "hdsjtj", params: {}, children: [] },
                  { id: "M_HDSJTJCX", title: "函调数据查询", component: "hdsjtjMx", params: {}, children: [] },
              		{ id: "M_SDHCTJ", title: "实地核查数据统计", component: "sdjcsjtj", params: {}, children: [] },
                  { id: "M_SDHCTJCX", title: "实地核查数据查询", component: "sdjcsjtjMx", params: {}, children: [] },
              		{ id: "M_JCLATJ", title: "稽查立案数据统计", component: "ckqyjclasjtj", params: {}, children: [] },
                  { id: "M_JCLATJCX", title: "稽查立案数据查询", component: "ckqyjclasjtjMx", params: {}, children: [] },
              		{ id: "M_YZSHWGL", title: "出口应征税货物管理", component: "ckyzshwgl", params: {}, children: [] }
              	]
              },
              {
              	// id: 'M_FXYD',
              	title: '专项日常监管',
              	children: [
              		{ id: "M_ZXJG_ZBPZ", title: "专项监管指标配置", component: "zxjdzbpz", params: {}, children: [] },
              		{ id: "M_ZXJG_ZBCSPZ", title: "专项监管指标参数设置", component: "zxjdzbcssz", params: {}, children: [] },
              		{ id: "M_ZXJG_YDHS", title: "专项日常监管疑点核实", component: "zxrcjdydhs", params: {}, children: [] },
              		{ id: "M_ZXJG_YDTJ", title: "专项日常监管疑点统计", component: "zxrcjdydtj", params: {}, children: [] },
              	]
              },
              {
                title: '案头分析',
                children: [
                  { 
                    id: "M_ATFXTZ", 
                    title: "案头分析台账", 
                    component: "atfxtz", 
                    params: {}, 
                    children: [] 
                  }
                ]
              },
              {
                // id: 'M_FXYD',
                title: '出口链路管理',
                children: [
                  { id: "M_CKLLGL_MXCS", title: "出口链路模型参数查询", component: "ckllgl", params: {}, children: [] },
                  { id: "M_CKLLGL_MXWH", title: "出口链路模型维护", component: "cklmxwh", params: {}, children: [] },
                  { id: "M_CKLLGL_CKYWLL", title: "出口业务物流链路综合管理", component: "ckllzhgl", params: {}, children: [] }
                ]
              }
            ]
          },
          nkgl: {
          	id: "M_NKGL",
            title: "内控管理",
            tip: "内控管理",
            icon: "icon-jzgl",
            children: [
              {
              	// id: "M_ZBRWCX",
                title: "时间进度和风险业务提醒",
                children: [
                  { id: "M_JIXIAOTJ", title: "审核绩效统计", component: "", params: {}, children: [] },
                  { id: "M_JIXIAOMX", title: "审核绩效查询", component: "", params: {}, children: [] },
                  { id: "M_ZBRW_JSCX", title: "金三即将超期审核流程查询（实时）", component: "jszbrw", params: {}, children: [] },
                  { id: "M_CQJQCQCX", title: "出口退税在办审核流程查询（非实时）", component: "cqblyw", params: {}, children: [] },
                  { id: "M_ZBRWCX_HD", title: "函调在办流程查询", component: "hdzbrw", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_NKFXCL",
                title: "内控风险处理",
                children: [
                  { id: "M_ZBPZ", title: "指标配置管理", component: "zbpzgl", params: {}, children: [] },
                  { id: "M_SQTXXX", title: "事前提醒信息管理", component: "sqtxxxgl", params: {}, children: [] },
                  { id: "M_SZYJXX", title: "事中预警信息管理", component: "szyjxxgl", params: {}, children: [] },
                  { id: "M_SHFXXX", title: "事后风险信息管理", component: "nkfxcl", params: {}, children: [] }
                ]
              },
              { id: "M_NKGLTJ", title: "内控成果管理统计", component: "nkgltj", params: {}, children: [] }
            ]
          },
          dxpz: {
            id: "M_DXTX",
            title: "短信提醒",
            tip: "短信提醒",
            icon: "icon-dxtx",
            children: [
              { id: "M_MSGPLAN", title: "短信关联业务查询（每日凌晨更新）", component: "dxtxlcrwcx", params: {}, children: [] },
              { id: "M_MSGPLANUSER", title: "税务机关短信接收人配置", component: "dxjsrpz", params: {}, children: [] },
              { id: "M_JJYQSZ", title: "即将逾期退税审核提醒设置", component: "jjyqtsshtxsz", params: {}, children: [] },
              { id: "M_YQTXSZ", title: "逾期提醒设置", component: "yqtxsz", params: {}, children: [] }
            ]
          },
          xtsz: {
          	id: "M_XTSZ",
            title: "系统设置",
            tip: "系统设置",
            icon: "icon-xtsz",
            children: [
              {
              	// id: "M_YHGL",
                title: "用户和权限",
                children: [
                  { id: "M_JSGL", title: "角色管理", component: "role", params: {}, children: [] },
                  { id: "M_YHGLSUB", title: "用户管理", component: "user", params: {}, children: [] },
                  { id: "M_YHZGL", title: "用户组管理", component: "group", params: {}, children: [] }
                ]
              },
              {
              	// id: "M_BBPZ",
                title: "报表配置",
                children: [
                  { id: "M_TJBBWH", title: "统计报表维护", component: "bbwh", params: {}, children: [] },
                  { id: "M_XNJG", title: "报表虚拟机关维护", component: "virtual", params: {}, children: [] }
                ]
              },
              { id: "M_XGMM", title: "修改密码", component: "changePwd", params: {}, children: [] },
              { id: "M_ZYXZ", title: "资源下载", component: "zyxz", params: {}, children: [] },
              { id: "M_WZBG", title: "画像报告模板维护", component: "wzbg", params: {}, children: [] },
              {
              	// id: "M_XTRZ",
                title: "日志查询",
                children: [
                  { id: "M_XTCZRZ", title: "系统操作日志查询", component: "xtczlog", params: {}, children: [] },
                  { id: "M_XTTBRZ", title: "系统同步日志查询", component: "xttblog", params: {}, children: [] }
                ]
              }
            ]
          },
        },

        ztreeNodes: {
            //国家节点
            gjdata: {},
            //大洲节点
            dqdata: {},
            //经济体节点
            jjtdata: {},
        },
        dataSsny: {
            dataSsnyStart: '',
            dataSsnyEnd: '',
        },
        host: (function () {
            var n = window.location.href.indexOf(":")
            if (n == 4) {
                var h = "http://";
            } else if (n == 5) {
                var h = "https://"
            }
            return h + window.location.host
        })(),
        pllxProgress: 0,
        toggleType: function () {
            $('.header').toggleClass('simple');
            $('.menu').toggleClass('simple');
            $('.main').toggleClass('simple');
        },
        getCountry: function () {
            ajax("GET", "static/country.json", {}).done(function (res) {
                if (res.code == '0') {
                    var data1 = {}, data2 = {}, data3 = {};
                    var data = tools.clone(res.data);
                    data1 = data.contis.concat(data.areas);
                    data2 = data.contis;
                    data3 = data.areas;
                    avalonRoot.ztreeNodes.gjdata = data1;
                    avalonRoot.ztreeNodes.dqdata = data2;
                    avalonRoot.ztreeNodes.jjtdata = data3;
                } else {
                    tools.info(res.msg);
                }
            }).fail(function (err) {
                tools.info(err);
            })
        },
        getCom: function (bbdm) {
            if (bbdm == 'B03101') {
                return "bbmxb03101"
            } else if (bbdm == 'B03102') {
                return "bbmxb03102"
            } else if (bbdm == 'B03104') {
                return "bbmxb03104"
            } else if (bbdm == 'B03105') {
                return "bbmxb03105"
            } else if (bbdm == 'B03106') {
                return "bbmxb03106"
            } else if (bbdm == 'B03109') {
                return "bbmxb03109"
            } else if (bbdm == 'B03112') {
                return "bbmxb03112"
            } else {
                return "bbmx"
            }

        },
        tabs: [//tab页数组
            {
                title: "首　页",
                is: "home",
                tip: "首页",
                params: {

                },
                children: [],
                isActive: true,
                canClose: false
            }
        ],
        index: 0,//暂时没用的属性
        user: {//用户信息
            czryDm: "",
            czrymc: "",
            description: "",
            swjgMc: "",
            swjgDm: "",
            yhlx: "",
            fpglxxs: "",
            roleDm: "",
            roleMc: "",
        },
        vip: {
            type: "vip1",
            jzsj: "已"
        },
        toggleMenu: function (e, el) {//展开菜单，此方法涉及DOM操作
            if(el.name=='tsgz'){ // 直接打开态势感知
                components.home.toJsc();
            }
            if (el.cpFlag) {
                tools.info("该模块正在开发中，敬请期待。");
                return;
            }
            if (!$('.menu').hasClass('open')) {
                $('.menu').addClass('open');
            }
            
            // var menuWidth = ''
            // if ($('.menu').hasClass('open')) {
            //     menuWidth = 251
            // } else {
            //     menuWidth = 39
            // }
            // $('.main>.content').css('padding-left', menuWidth+'px')
            // $('.main>.content>.tabs').css('padding-left', menuWidth+9+'px')
            if (el.component) {//如果为功能菜单
                this.addTab(el);
            } else {
                var target = e.target;
                if (target.nodeName == "DIV") {
                    if ($(target).hasClass('open')) {
                        $(target).removeClass('open');
                        $(target).parent().find('ul').slideUp();
                        $('.menu').css('top', '0px');
                    } else {
                        $(target).addClass('open');
                        $(target).next().slideDown();
                        $(target).parent().siblings().find('div').removeClass('open');
                        $(target).parent().siblings().find('ul').slideUp()
                    }

                } else if (target.nodeName == "SPAN" || target.nodeName == "I") {
                    if ($(target).parent().hasClass('open')) {
                        $(target).parent().removeClass('open');
                        $(target).parent().parent().find('ul').slideUp()
                    } else {
                        $(target).parent().addClass('open');
                        $(target).parent().next().slideDown();
                        $(target).parent().parent().siblings().find('div').removeClass('open');
                        $(target).parent().parent().siblings().find('ul').slideUp()
                    }

                }
            }
        },
        addTab: function (item) {//新增tab页
            if (item.cpFlag) {
                tools.info("该模块正在开发中，敬请期待。");
                return;
            }
            if(item.component=='-1' && item.url){ // 调整到其他页面
                window.open(item.url);
                return;
            }
            var tab = {
                title: item.title,
                tip: item.tip || item.title,//same check的基准，tab的tip
                is: item.component,
                params: item.params,
                isActive: item.isActive == undefined ? true : item.isActive,
                canClose: item.canClose == undefined ? true : item.canClose,//是否允许关闭
                sameCheck: item.sameCheck == undefined ? true : item.sameCheck,//是否可以打开多个
                repeatCheck: item.repeatCheck == undefined ? true : item.repeatCheck//是否可以打开多个
            }
            for (var index = 0; index < this.tabs.length; index++) {
                if (this.tabs[index].tip == tab.tip && tab.sameCheck == true) {
                    this.delTab(index);
                    this.addTab(item);
                    return;
                }
                if (this.tabs[index].is == tab.is && tab.repeatCheck == true) {
                  this.delTab(index);
                  this.addTab(item);
                  return;
              }
            }
            if (this.tabs.length >= 13) {
                tools.info('您打开了过多的标签页，请先关闭一部分')
                return;
            }
            this.tabs.push(tab);
            this.activeTab(this.tabs.length - 1)
        },
        delTab: function (index) {//删除tab页并激活前一tab
            this.tabs.splice(index, 1);
            var at = index - 1;
            this.activeTab(at, true);
        },
        delDQTab: function (item) {//删除tab页并激活前一tab
          for (var index = 0; index < this.tabs.length; index++) {
            if (this.tabs[index].tip == item.title) {
                this.delTab(index);
            }
        }
          
        },
        delCurrent: function (index) { // 激活当前tab，并激活上一级
            if (this.tabs[this.activeTabIndex].is == "hcglbj") {
                this.tabs.splice(this.activeTabIndex, 1);
                var tmpIndex = -1
                this.tabs.forEach((item,index,arr) => {
                    if (item.is == 'hcgl') {
                        tmpIndex = index
                        return false
                    }
                });
                if (tmpIndex >= 0) {
                    this.activeTab(tmpIndex)
                } else {
                    this.activeTab(this.activeTabIndex-1)
                }
            }
        },
        doOther: function(){},
        activeTab: function (index, clickTab) {//激活tab页
            $($('.tabs .tab')[index]).addClass('active').siblings().removeClass('active');
            for (var i = 0; i < this.tabs.length; i++) {
                this.tabs[i].isActive = false;
            }
            this.activeTabIndex = index
            this.tabs[index].isActive = true;
            if (index == 0) {
                try {
                    pageCkbgd.search(1);
                } catch (err) {

                }
            }
            if (this.tabs[index].is == "rwlb") {
                if (rwlb) {
                    rwlb.search(1);
                }
            } else if (this.tabs[index].is == "rwlbMx") {
                if (rwlbMx) {
                    rwlbMx.search(1);
                }
            } else if (this.tabs[index].is == "baml" && clickTab) {
                if (avalonRoot.baml) {
                    avalonRoot.baml.getInfo();
                }
            } 
            if (this.tabs[index].is == 'test' && clickTab) {
                if(avalonRoot.test && avalonRoot.test.isShow)  {
                    $('.model').show()
                }
            } else {
                $('.model').hide()
            }
        },
        logout: function () {
            function ok() {
                ajax("POST", "/bjtssw/logout", {}).done(function (res) {
                    if (res.code == '0') {
                        window.location.href = "./login.html";
                    } else {
                        tools.info(res.msg)
                    }
                }).fail(function (err) {
                    tools.info(err)
                })
            };
            var text = "退出便捷退税局端管理系统？";
            tools.confirm(text, "确定", ok);
        },
        userName: function () {
            var name = this.user.czrymc;
            if (name.length > 20) {
                name = name.substring(0, 20) + "...";
            }
            return name;
        },
        tjbbMenu: function(){
            var self = this;
            var deferred = $.Deferred();
            api.tjbbMenu().done(function (res) {
                if (res.code == '0') {
                    var arr = [
                        {
                            id: "M_DBRWLB",
                            title: "报表生成",
                            component: "rwlb",
                            params: {},
                            children: []
                        }
                    ];
                    for (var i = 0; i < res.data.length; i++) {
                        var bbdm = res.data[i].bbdm;
                        var menuItem = { title: res.data[i].bbmc, component: "bblist", params: tools.clone(res.data[i]), children: [] };
                        if (bbdm == "B01") {
                            menuItem.id = "M_ZJCKTSYBB";
                        } else if (bbdm == "B02") {
                            menuItem.id = "M_ZJZXBB";
                        } else {
                            menuItem.id = "M_SJCKTSYBB";
                        }
                        arr.push(menuItem);
                    }
                    var zdyhb = {
                        id: "M_VDBRWLB",
                        title: "自定义合并（地区）报表",
                        component: "virtualRwlb",
                        params: {},
                        children: []
                    }
                    arr.push(zdyhb)
                    // avalonRoot.menus.tjbb.children = arr;
                    self.setTjbb(arr);
                }
                deferred.resolve();
            }).fail(function(){
                deferred.resolve();
            })
            return deferred.promise()
        },
        setTjbb: function(arr){
            var index = -1;
            for(var i=0; i<avalonRoot.menus.rcgl.children.length; i++){
                var curChild = avalonRoot.menus.rcgl.children[i];
                if(curChild.name=='tjbb') index=i;
            }
            if(index>=0){
                avalonRoot.menus.rcgl.children[index].children = arr;
            }
        },
        addTsgzMenu:function(){ // 登录后态势感知页面可见
            var isHasPermissionLink = !!avalonRoot.menuDict['M_TSGZ_ZHXX'];
            if(!isHasPermissionLink) return

        },
        getAuthMenu: function(){
            var self = this;
            var params = { czry_dm: avalonRoot.user.czryDm };
            api.getAuthMenu(params).done(function (res) {
                if (res.code == '0') {
                    if (res.data && res.data.length > 0) {
                        var len = res.data.length;
                        var obj = {};
                        for (var i = 0; i < len; i++) {
                            obj[res.data[i].code] = res.data[i].name;
                        }
                        avalonRoot.menuDict = obj;
                        self.addTsgzMenu();
                    }
                    function handler(parent, child) {
                        if (parent.cpFlag) return;
                        //保存子菜单被设置成hidden的次数，当count.num = child.length时，即所有子菜单都设置成hidden,那么自身也设置成hidden
                        var count = { num: 0 };
                        var len = child.length;
                        for (var i = 0; i < len; i++) {
                            if (child[i].cpFlag) continue;
                            //有id的菜单，并且该id不在后台返回的字典表里面，则把该菜单设置成hidden
                            if (child[i].id && !avalonRoot.menuDict[child[i].id]) {
                                child[i].hidden = true;
                                count.num++;
                                if (count.num === len) {
                                    parent.hidden = true;
                                    if (arguments[2]) {
                                        arguments[2].num++;
                                    }
                                }
                            } else if (child[i].children && child[i].children.length > 0) {
                                handler(child[i], child[i].children, count);
                                if (count.num === len) {
                                    parent.hidden = true;
                                    if (arguments[2]) {
                                        arguments[2].num++;
                                    }
                                }
                            }
                        }
                    }
                    var menus = tools.clone(avalonRoot.menus);
                    for (var key in menus) {
                        if (menus.hasOwnProperty(key)) {
                            handler(menus[key], menus[key].children);
                        }
                    }
                    self.menus = menus;
                    if (components.home) {
                        components.home.isHasPermissionLink = !!avalonRoot.menuDict['M_ZHXXJSC']
                    }
                }
            })
        },
        getMenuZj: function(){
            var self = this;
            this.tjbbMenu().done(function(){
                self.getAuthMenu();
            })
        },
        jumpToPage(){
            var hash = window.location.hash
            window.location.hash = '';
            if(hash.indexOf('cktms')>-1){
                var hashMatch = hash.match(/#cktms=(\d*)$/);
                avalonRoot.addTab({title:"全省企业风险健康总览",component:"ckqyfxjkxx",params:{
                    swjgDm: hashMatch[1]
                }});
            } else if(hash.indexOf('dxtxlcrwcx')>-1){
                var hashMatch = hash.match(/#dxtxlcrwcx=(\d*)(.*?)(&(.*?))?$/);
                avalonRoot.addTab({title:"短信关联业务查询（每日凌晨更新）",component:"dxtxlcrwcx",params:{
                    swjgDm: hashMatch[1],
                    biztype: hashMatch[4],
                }});
            } else if(hash.indexOf('qyhxbg')>-1){
                var hashMatch = hash.match(/#qyhxbg=(\w*)$/);
                avalonRoot.addTab({title:"企业画像报告",component:"qyhxbg",params:{
                    nsrsbh: hashMatch[1]
                }});
            } else if(hash.indexOf('mgspwh')>-1){
                var hashMatch = hash.match(/#mgspwh=(\w*)$/);
                avalonRoot.addTab({title: "敏感商品维护", component: "mgspwh", params: {
                    swjgDm: hashMatch[1]
                }})
            } else if(hash.indexOf('fxqywh')>-1){
                var hashMatch = hash.match(/#fxqywh=(\w*)$/);
                avalonRoot.addTab({title: "风险企业维护", component: "fxqywh", params: {
                    swjgDm: hashMatch[1]
                }})
            } else if(hash.indexOf('zbtjjg')>-1){
                var hashMatch = hash.match(/#zbtjjg=(\w*)$/);
                avalonRoot.addTab({title: "出口企业指标统计一户式查询", component: "zbtjjg", params: {
                    nsrbs: hashMatch[1]
                }})
            } else if(hash.indexOf('dshywcl')>-1){
              // var hashMatch = hash.match(/#zbtjjg=(\w*)$/);
              avalonRoot.addTab({title: "待审核业务处理", component: "dshywcl", params: {}})
          }

        },
        initHeader(){
            var query = this.getQueryVariable()
            this.hideHeader = false
            if (query['Ww2oP9'] === '1') {
                this.hideHeader = true
            }
        },
        getQueryVariable(){
            var query = window.location.search.substring(1);
            var vars = query && query.split("&") || [];
            let obj = {}
            for (var i=0;i<vars.length;i++) {
                var pair = vars[i].split("=");
                obj[pair[0]] = pair[1]
            }
            return obj
        }
    });
    //入口
    avalonRoot.$watch('onReady', function () {
        this.initHeader()
        var self = this;
        this.activeTab(0);
        var time;
        self.getCountry();
        $('.menu .open-menu').click(function () {
            var $_ = $('.menu');
            $_.toggleClass('open');
            $('.menu .menu-item ul').slideUp();
            $('.menu .menu-item div').removeClass('open');
            // var menuWidth = ''
            // if ($('.menu').hasClass('open')) {
            //     menuWidth = 251
            // } else {
            //     menuWidth = 39
            // }
            // $('.main>.content').css('padding-left', menuWidth+'px')
            // $('.main>.content>.tabs').css('padding-left', menuWidth+9+'px')
        });
        $('.menu').mouseenter(function (e) {
            clearTimeout(time);
        })
        $('.menu').mouseleave(function (e) {
            //判断是否从左边离开，左边离开不收起菜单
            if (e.pageX < 0) {
                return;
            }
            time = setTimeout(function () {
                $('.menu').removeClass('open');
                $('.menu .menu-item ul').slideUp();
                $('.menu .menu-item div').removeClass('open');
                $('.menu').css('top', '0px');
            }, 1500)

        });
        // 菜单鼠标滚轮事件绑定
        $('.menu').on('mousewheel', function(e){
            var menu_top = parseFloat($('.menu').css('top'));
            var isWheelDown = e.originalEvent.wheelDelta < 0; // 是否向下滚动
            var wheel_len = 20; // 滚动距离
            if(isWheelDown){
                var menu_ct_h = $('.menu .content').height(); // 菜单内容高度
                var main_ct_h = $('.main .content').height(); // 右边主体内容高度
                if(menu_ct_h+menu_top-wheel_len>main_ct_h){
                    menu_top = menu_top - wheel_len;
                } else{
                    menu_top = - menu_ct_h + main_ct_h;
                }
            } else{
                menu_top = menu_top + wheel_len;
            }
            if(menu_top>0) menu_top = 0;
            menu_top = menu_top + 'px';
            $('.menu').css('top', menu_top);
        })
        // 三级菜单高度自适应
        var subMenuH = parseInt($('body').css('height')) - parseInt($('.menu .content').css('height')) - 100;
        if(subMenuH>150) $('.menu .content .menu-item li .popMenu').css('max-height', subMenuH);
        var self = this
        api.preLogin().done(function (res) {
            if (res.code == '0') {
                avalonRoot.user = res.data;
                self.jumpToPage();
            }
        }).done(function () {
            self.getMenuZj();
        })

        
    })
    avalon.scan(document.body);
});

