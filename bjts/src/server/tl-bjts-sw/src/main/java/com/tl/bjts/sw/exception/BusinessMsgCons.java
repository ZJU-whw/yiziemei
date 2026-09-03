package com.tl.bjts.sw.exception;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by Mamf on 2017/6/21.
 */
public class BusinessMsgCons {

    private BusinessMsgCons(){}

    public static final String CONTROLLER_SHZS_UNLOGIN = "此操作需先登录系统";

    public static final String SERVICE_USER_ADDROLE = "该用户此角色已经存在";

    public static final String CONTROLLER_LOGIN_EMPTYUSER = "用户不存在";

    public static final String CONTROLLER_LOGIN_TRYMUCH = "尝试错误次数过多";

    public static final String CONTROLLER_LOGIN_NO = "用户或密码错误";

    public static final String CONTROLLER_LOGIN_FAILED = "登录失败";

    public static final String CONTROLLER_LOGIN_OVERDUE = "用户凭证过期";

    public static final String CONTROLLER_APPSYSY_USERNULL = "该用户信息不存，不允许此操作";

    public static final String CONTROLLER_ADDFPGLXX_REDUP= "添加失败，该用户已存在相应分片管理信息";

    public static final String POST_FAILD = "操作失败";

    public static final String CONTROLLER_REPORTEXCEL_FILENAME = "统计汇总";

    public static final String CONTROLLER_REPORTEXCEL_DOWNLOADERROR = "生成下载文件出错";

    public static final String CONTROLLER_REPORTEXCEL_DATAEMPTY = "列表无数据";

    public static final String CONTROLLER_REPORTEXCEL_TOOBIG = "导出数据量太大，最大支持2万条数据";

    public static final String SERVICE_PK_EXIST = "新增失败，请重新尝试";

    public static final String NO_EMPTY = "请选择要删除的选项";
    public static final String EXIST_FHBH = "该复函编号已存在";
    public static final String EXIST_KACODE= "该口岸编号已存在";
    public static final String ONLY_XLS= "仅限上传xls格式的文件";

    public static String getLoggerInfo(Class clz,String method,String loggerInfo){
        return "【"+clz.getName()+"->"+method+":"
                +new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date())+"】："+loggerInfo;
    }

}
