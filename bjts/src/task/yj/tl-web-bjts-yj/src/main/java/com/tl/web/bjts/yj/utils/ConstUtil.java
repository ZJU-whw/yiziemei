package com.tl.web.bjts.yj.utils;

/**
 * @Author：Mamf
 * @Date: 2017/11/22.
 * @Description:
 */
public class ConstUtil {

    public static final String ysjgPass = "0";//无疑点
    public static final String ysjgPickYes = "1";//警告疑点（疑点可挑过）
    public static final String ysjgPickNo = "2";//疑点（疑点不可挑过）

    public static final String SbfsNetTax = "0"; // 申报方式(网报)
    public static final String SbfsFileReadin = "1"; //申报方式(文件读入)

    public static final String ZSSB_NET_TAX = "2A";//可以进行申报状态（网报方式）
    public static final String ZSSB_FILE_READIN = "2B";//可以进行申报状态（文件读入方式）

    public static final String zzsbbJs = "0"; //增值税申报表（金三系统中已经全申报）
    public static final String zzsbbShxt = "1"; //增值税申报表（审核系统中已经全申报）

    public static final String WM_SBYW = "A0301001"; //外贸业务表代码
    public static final String SC_SBYW = "A0305001"; //生产业务表代码
    public static final String WZF_SBYW = "A0310001"; //外综服业务表代码
    public static final String ZYHW_SBYW = "A0304001"; //购进自用货物
    public static final String YGSB_SBYW = "A0303001"; //出口已使用过的设备
    public static final String TXFS_SBYW = "A0302001"; //出口非自产货物消费税
    public static final String HTFS_SBYW = "A0309001"; //航天发射免退税申报


    public static final String QT_WXGDZXX_SBYW = "A0402001"; //无相关电子信息
    public static final String QT_WGXFP_SBYW = "A0410001"; //误勾选发票业务


    public static final String YjTypeSpdm = "101";   //预警类型(新增商品代码)
    public static final String YjTypeSupplier = "102"; //预警类型(新增供应商)
    public static final String YjTypeEnterprise = "103"; //预警类型(新企业首次出口)
    public static final String YjTypeHydGhfshDiffer = "104"; //预警类型(货源地与供货商税号不一致)
    public static final String YjTypeSpmcDiffer = "105"; //预警类型(商品名称不一致)

    public static final String YjTypeYcghs = "107"; //预警类型(异常供货商)
    public static final String YjTypeGfxsp = "108"; //预警类型(高风险商品)

    public static final String YjTypeCkkaWm = "109"; //预警类型(出口口岸外贸)
    public static final String YjTypeCkkaSc = "110"; //预警类型(出口口岸生产)
    public static final String YjTypeGhqyhd = "111"; //供货企业函调异常
    public static final String YjTypeSbckka = "112"; //申报与出口口岸不一致
    public static final String YjTypeYcdj = "113"; //异常单价
    public static final String YjTypeBgdfs = "115"; //报关行分散
    public static final String YjTypeYwBgd = "120"; //非金华地区义务报关行预警
    public static final String YjTypeYdBg = "160"; //异地报关指标（外贸+海运）
    public static final String YjTypeJgdj = "161"; //商品单价畸高指标
    public static final String YjTypeCkkpSjjg = "162"; //出口与开票时间间隔指标
    public static final String YjTypeWmqyMmylrl = "163"; //每美元利润率分析指标
    public static final String YjTypeFxqydcpg = "164"; //风险企业调查评估指标
    public static final String YjTypeCqwbgd = "165"; //长期未申报报关单指标
    public static final String YjTypeShblpd = "166"; //收汇比例偏低指标
    public static final String YjTypeWsbWaxx = "121"; //未申报物流信息指标
    public static final String YjTypeYjbmtdtshd = "123"; //出口商品码多退税率核对指标
    public static final String YjTypeStzc = "124"; //视同自产货物预警指标
    public static final String YjTypeHkbccb = "125"; //换汇成本超阈值预警指标
    public static final String YjTypeFxbgh = "122"; //总局下发风险报关行预警指标


    public static final String YjTypeGhqyhd_2 = "130"; //供货企业函调异常



    public static final String YjTypeTszh = "201"; //预警类型(退税账号不一致)
    public static final String YjTypeHegs = "202"; //预警类型(霍尔果斯口岸毛皮出口)

    public static final String YjTypeDzba = "116"; //近期申报数据单证备案未完成
    public static final String YjTypeCqwsb = "117"; //长期未申报 已确认征/免税出口业务申报退税
    public static final String YjTypeXbqy = "118"; //新办类出口企业申报退税

    public static final String YjTypeSbhtzb = "119"; //外贸企业申报数据含调整表

    public static final String YSFSDM_SLYS = "2";  //运输方式-水路运输
    public static final int JKM_RED = 3;
}
