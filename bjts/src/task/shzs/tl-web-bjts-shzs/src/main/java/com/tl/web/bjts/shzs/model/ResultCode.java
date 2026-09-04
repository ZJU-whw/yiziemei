package com.tl.web.bjts.shzs.model;

/**
 * Created by wzy on 12/3/15.
 */
public enum ResultCode {

    OK(0, "Success"),
    AUTH_ERROR(400, "未授权"),
    AUTHEN_ERROR(401, "未登录"),
    SERVICE_ERROR(501, "服务不可用，请稍后再试"),
    INVALID_PARAM(1001, "参数错误"),
    DATA_PARAM(801, "数据异常"),
    USER_NOT_EXIST_JS(802, "金三中不存在用户"),
    SHZS_VERSION_LOW(803, "请升级审核助手程序"),
    PERMISSION_DENIED(1002, "权限异常"),
    REQUEST_TOO_FREQUENCY(1003, "请求太频繁"),
    REQUEST_ERROR(1004, "请求失败"),
    RECORD_ERROR(1005, "订单不存在"),
    LOGIN_ERROR(2001, "用户不存在或密码错误"),
    APP_UNKNOWN_ERROR(9001,"未知错误"),
    APP_BIZ_LCSLID_ERROR(3001,"流程异常"),
    UNSUPPORT_LDLP_SERVICE(3002,"暂不支持的查看关联明细的业务"),
    DONOT_EXIST_BGD_INFO(3003,"报关单信息不存在"),
    DONOT_EXIST_FP_INFO(3004,"发票信息不存在"),
    NOT_MATCHED_SBID(3005, "申报id与企业业务不相符"),
    APP_BIZ_ERROR(7001,"业务异常"),
    DATABASE_ERROR(7003,"数据库错误"),
    TOO_MANY_RESULT(7002,"数据库数据异常"),
    NO_SHZS_SLG_PERM(7004,"您不是出口退税受理岗人员，不能执行自动委派操作");

    private int code;

    private String msg;

    ResultCode(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public int getCode() {
        return code;
    }

    public String getMsg() {
        return msg;
    }

}
