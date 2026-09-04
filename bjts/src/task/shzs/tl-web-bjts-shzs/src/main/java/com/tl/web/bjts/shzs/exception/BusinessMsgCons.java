package com.tl.web.bjts.shzs.exception;

/**
 * Created by Mamf on 2017/6/21.
 */
public class BusinessMsgCons {

    private BusinessMsgCons(){}

    public static final String CONTROLLER_SHZS_UNLOGIN = "此操作需先登录系统";

    public static final String FILECONTROLLER_SBFILE_DOWNLOAD = "文件下载申请人与申报任务绑定操作人不匹配";

    public static final String FILECONTROLLER_SBID_EMPTY= "申报id为空";

    public static final String SBYJXXCONTROLLER_SBFILE_EXPORTEXCEL = "预警信息";
    public static final String YDXX_FILENAME = "疑点信息";

    public static final String SBYJXXCONTROLLER_SBFILE_EXPORTEXCEL_ERROR = "生成下载文件出错";

    public static final String SBYJXXCONTROLLER_SBFILE_EXPORTEXCEL_EMPTY = "列表无数据";

    public static final String CONTROLLER_SBFILE_GENERATOR = "生成申报文件出错";

    public static final String SERVICE_SBXXHZ_RWTXPK = "新增失败，请重新尝试";
    public static final String CONTROLLER_SBFILE_DOWNLOADEMPTY = "未查询到数据";
    public static final String CONTROLLER_REPORTEXCEL_DOWNLOADERROR = "生成下载文件出错";

    public static final String GET_SBID_EMPTY = "未查询到流程";

}
