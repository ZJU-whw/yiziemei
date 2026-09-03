package com.tl.bjts.sw.model;

/**
 * Created by wzy on 12/3/15.
 */
public enum ResultCode {

    OK(0, "Success"),
    SERVICE_BIZ_ERROR(-1,"内部业务异常"),
    RWTJ_REFRESH(100,""),
    AUTHEN_ERROR(401, "未登录"),
    SERVICE_BUSY(500, "服务忙，请稍后再试"),
    SERVICE_ERROR(501, "服务不可用，请稍后再试"),
    REQ_FORMAT_ERROR(600, "请求参数错误"),
    REQ_DATA_ERROR(601,"输入内容有误，请检查"),
    FILE_NOT_EXIST(703,"文件不存在"),
    YUN_DATA_EMPTY(704,"从云端获取数据为空"),

    DATA_PARAM(801, "数据异常"),
    PERMISSION_DENIED(1002, "权限异常"),
    REQUEST_TOO_FREQUENCY(1003, "请求太频繁"),
    REQUEST_ERROR(1004, "请求失败"),
    LOGIN_ERROR(2001, "用户不存在或密码错误"),
    APP_UNKNOWN_ERROR(9001,"未知错误"),
    TJBB_SUBMIT_WARN(7001,"提示型上报"),
    TJBB_SUBMIT_ERROR(7002,"错误型上报");

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
