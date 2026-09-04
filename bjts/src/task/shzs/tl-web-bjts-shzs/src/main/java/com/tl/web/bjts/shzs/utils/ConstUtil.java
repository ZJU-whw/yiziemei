package com.tl.web.bjts.shzs.utils;

public class ConstUtil {

    public static final String FPZT_NORMAL = "正常";
    public static final String FPZT_OUT_OF_CONTROL = "失控";
    public static final String FPZT_INVALID = "作废";
    public static final String FPZT_ABNORMAL = "异常";
    public static final String FPZT_DEFICIT_REDUCE = "冲红";

    public static final String ERR_LEVEL_ERROR = "错误";
    public static final String ERR_LEVEL_WARNING = "警告";
    public static final String ERR_LEVEL_NORMAL = "一般";


    public static final String YD_CAN_NOT_PASS_FLAG = "不可";  //疑点不可挑过
    public static final String YD_CAN_PASS_FLAG = "可以"; //疑点可挑过


    //字典表
    public static final String DICT_BICODE = "bicode";  //币种
    public static final String DICT_DWCODE = "dwcode";  //计量单位
    public static final String DICT_GBCODE = "gbcode";  //国别
    public static final String DICT_HGCODE = "hgcode";  //海关
    public static final String DICT_KACODE = "kacode";  //海关口岸
    public static final String DICT_HYDCODE = "hydcode";   //货源地
    public static final String DICT_JHTYPECODE = "jhtype_code";   //结汇方式
    public static final String DICT_JSFSCODE = "jsfs_code";    //结算方式
    public static final String DICT_TDCODE = "tdcode";  //贸易方式
    public static final String DICT_TRANSTYPE = "transtype";  //运输方式
    public static final String DICT_ZYGCODE = "zygcode"; //指运港
    public static final String DICT_CJFSCODE = "cjfscode";  //成交方式
    public static final String DICT_ZMXZCODE = "zmxz_code";  //征免性质
    public static final String DICT_BZZLCODE = "bzzl_code";  //包装种类

    //标识符
    public final static String IDENTIFIER_UNDERLINE = "_";

    /**
     * 申报成功的状态开头代码
     */
    public final static String SBZTDM_SUCCESS_START = "3";

    /**
     * 调用sb-service服务用语下载申报报文的地址
     */
    public final static String URL_SHZS_GETSBBW = "shzs/getSbbw";

    /**
     * 用户表中用户类型
     */
    public final static String DMCZRY_YHLX_PTCZY = "00"; //普通操作员

    /**
     * 用户表中用户状态
     */
    public final static String DMCZRY_USRSTATE = "3"; //正常状态

    /**
     * 是否标志
     */
    public final static String WHETHER_YES = "Y"; //是
    public final static String WHETHER_NO = "N"; //否

    /**
     * 是否标志
     */
    public final static String WHETHER_YES_CN = "是";
    public final static String WHETHER_NO_CN = "否";

    /**
     *  申报明细数据查询类型
     */
    public final static String QUERYTYPE_SBXX = "1"; // 申报信息
    public final static String QUERYTYPE_YDXX = "2"; // 从疑点页面进入
    public final static String QUERYTYPE_YJXX = "3"; // 从预警页面进入

    /**
     *  申报业务表代码
     */
    public final static String SBYWB_WMMTS = "A0301001"; // 外贸免退税
    public final static String SBYWB_GJZYHW = "A0304001"; // 购进自用货物
    public final static String SBYWB_SCMDT = "A0305001"; // 生产免抵退
    public final static String SBYWB_WZFDBTS = "A0310001"; // 外综服代办退税

    public final static String SBYWB_WMMTS_LCDM = "LCSXA081039001"; // 外贸免退税
    public final static String SBYWB_GJZYHW_LCDM = "LCSXA081042002"; // 购进自用货物
    public final static String SBYWB_SCMDT_LCDM = "LCSXA081038001"; // 生产免抵退
    public final static String SBYWB_WZFDBTS_LCDM = "LCSXA081040001"; // 外综服代办退税

    public static final String GLXT_DZBA_URL = "/bjts/shzs"; //与管理系统单证备案进行数据交互的路径
    public static final String GLXT_AUTH_TOKEN_URL = "/login/token"; //与管理系统用户服务交互-token登录
    public static final String GLXT_AUTH_TOKENG_URL = "/login/token/get"; //与管理系统用户服务交互-获取token

    /**
     *  审核助手与管理系统-单证备案服务交互功能号
     */
    public final static String SZHZ_FUNCNO_STATE_CHECK = "100"; // 校验出口业务审单核查状态
    public final static String SZHZ_FUNCNO_INSPECT_VIEW = "101"; // 查看日常审单核查业务
    public final static String SZHZ_FUNCNO_BUSINESS_LIST = "102"; // 获取出口业务数据
    public final static String SZHZ_FUNCNO_INSPECT_RANGE = "103"; // 获取单证核查类型树(单证类型核查范围)
    public final static String SZHZ_FUNCNO_INSPECT_GENERATE = "104"; // 生成日常审单核查任务
    public final static String SZHZ_FUNCNO_INSPECT_RELEASE = "105"; // 下达日常审单核查任务

    public final static String SZHZ_FUNCNO_GLXT_LOGIN_CHECK = "111"; // 校验管理系统登录状态

    /**
     * 核查任务状态代码
     */
    public static final String INSPECT_STATUS_RELEASE_NOT = "0";//未下达
    public static final String INSPECT_STATUS_RELEASE_YES= "1";//已下达（已退回）
    public static final String INSPECT_STATUS_ACCEPT= "2";//企业已收讫（退回已收讫）
    public static final String INSPECT_STATUS_REPORT = "3";//已上报
    public static final String INSPECT_STATUS_VERITY = "4";//已审核

    /**
     * 核查任务状态名称
     */
    public static final String INSPECT_STATUS_NAME_RELEASE_NOT = "未下达";//未下达
    public static final String INSPECT_STATUS_NAME_RELEASE_YES= "已下达";//已下达
    public static final String INSPECT_STATUS_NAME_BACK= "已退回";//已退回
    public static final String INSPECT_STATUS_NAME_ACCEPT= "（企业）已收讫";//（企业）已收讫
    public static final String INSPECT_STATUS_NAME_REPORT = "已上报";//已上报
    public static final String INSPECT_STATUS_NAME_VERITY = "已审核";//已审核

    /**
     * 事中风险处理动作
     */
    public static final String NBFXDMX_SZ_CLDZ_HL = "0";//忽略
    public static final String NBFXDMX_SZ_CLDZ_ZD = "1";//中断

    public static final String SPLIT_RULES_PATH = "\\.";

    public static final String TIME_OUT_FLAG = "1";
}
