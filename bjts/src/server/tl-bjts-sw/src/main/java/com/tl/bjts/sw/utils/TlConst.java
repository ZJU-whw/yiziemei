package com.tl.bjts.sw.utils;

import java.util.HashMap;
import java.util.Map;


/**
 * 自定义常量类
 */
public class TlConst {

    public static final String FPZT_NORMAL = "正常";
    public static final String FPZT_OUT_OF_CONTROL = "失控";
    public static final String FPZT_INVALID = "作废";
    public static final String FPZT_ABNORMAL = "异常";
    public static final String FPZT_DEFICIT_REDUCE = "冲红";

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

    /**
     * 指标大类编码
     */
    public static final String ZBDL_QT = "0";

    public static final String ZBDL_HZ_DJ = "1";

    public static final String ZBDL_HZ_CK = "2";

    public static final String ZBDL_HZ_TS = "5";

    public static final String ZBDL_HZ_BL = "6";

    public static final String ZBDL_FZ_DJ = "1";

    public static final String ZBDL_FZ_CK = "7";

    public static final String ZBDL_FZ_CW = "8";

    public static final String ZBDL_FZ_TS = "9";


    public static final String SJJC_TJBB_TYPE_01 = "01";

    public static final String SJJC_TJBB_TYPE_02 = "02"; //出口退免税情况总表

    public static final String SJJC_TJBB_TYPE_03 = "03";

    public static final String SJJC_TJBB_TYPE_04 = "04";

    public static final String SJJC_TJBB_TYPE_05 = "05";

    public static final String SJJC_TJBB_TYPE_06 = "06";

    public static final String SJJC_TJBB_TYPE_07 = "07"; //特殊业务情况表

    public static final String SJJC_TJBB_HZTYPE_TS = "hzItemsTs"; //退税类

    public static final String SJJC_TJBB_HZTYPE_CK = "hzItemsCk"; //出口类

    private TlConst() {
    }

    public static final String REDIS_DM_CACHE_KEY = "SJJC_DATA_CACHE";

    public static final String SB_CHECK_PROC = "PRO_TJBB_CHECK_DTBB";

    public static final String VIP_YUN_BIZID_TSTZ = "vip.tstz";

    public static final String AUTHORCACHE = "tl-fwzx-author";

    public static final String TL_KEY = "21412565437v4g3!";

    public static final String CALLBACK = "<script>parent.callback(\"%s\", \"%s\");</script>";

    public static final String QYLX_SC ="12";

    public static final String QYLX_WM ="21";

    public static final String RWLX_TJFX ="01"; //任务类型：统计分析
    public static final String RWLX_BBFW ="02"; //任务类型：报表服务

    public static final String RWZT_DCL ="0"; //任务状态：待处理
    public static final String RWZT_ZZCL ="1"; //任务状态：正在处理
    public static final String RWZT_CLWB ="2"; //任务状态：处理完毕

    public static final String QYLX_JC_SC ="1"; //企业类型-简称：生产
    public static final String QYLX_JC_WM ="2"; //企业类型-简称：外贸
    public static final String QYLX_JC_WZF ="3"; //企业类型-简称：外综服

    public static final String EXCUTE_TASK_KEY = "SC&WM";

    public static final int  TJFX_RWZT_DCL =101; //统计分析-任务状态-待处理
    public static final int  TJFX_RWZT_CLZ =102; //统计分析-任务状态-处理中
    public static final int  TJFX_RWZT_CLWB =103; //统计分析-任务状态-处理完毕
    public static final int  TJFX_RWZT_CLWB_REFRESH =100; //统计分析-任务状态-处理完毕（需要刷新）

    public static final String SF4YES = "Y"; //是
    public static final String SF4NO = "N"; //否

    /**
     * 物流链路二维码功能标识
     */
    public static final String QR_YSY_FUNC_ID = "yy-gnwlcx";

    /**
     * 二维码参数版本V2（管道分隔，首位置为版本号）
     */
    public static final String QR_PARAM_VERSION_V1 = "v1";

    /**
     * 二维码参数分隔符（管道符）
     * 单个值经URLEncode后，原始|变为%7C，不会与分隔符冲突
     */
    public static final String QR_PARAM_DELIMITER = "|";

    /**
     *  云存储类型
     */
    public static final String STORETYPE_ALIYUN_OSS = "oss"; // 阿里云oss
    public static final String STORETYPE_HUAWEIYUN_OBS = "obs"; // 华为云obs
    public static Map<Integer,String> monthMap=new HashMap<>();

    static {
        monthMap.put(1,"JAN");
        monthMap.put(2,"FEB");
        monthMap.put(3,"MAR");
        monthMap.put(4,"APR");
        monthMap.put(5,"MAY");
        monthMap.put(6,"JUN");
        monthMap.put(7,"JUL");
        monthMap.put(8,"AUG");
        monthMap.put(9,"SEP");
        monthMap.put(10,"OCT");
        monthMap.put(11,"NOV");
        monthMap.put(12,"DEC");
    }



}
