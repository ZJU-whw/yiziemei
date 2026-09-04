package com.tl.web.bjts.yj.model;

/**
 * Created by wzy on 12/3/15.
 */
public enum ResultCode {

    OK("000", "Success"),
    YS_FAILED_YUN("600","比对失败"),
    YS_NO_BJTS("601","尚未开通便捷退税申报服务"),
    YS_FAILED_EXCEPTION("602","存储过程调用失败"), //对应老版预审CODE为1000的代码
    CHECK_ZK_USER("603","检查管理系统用户异常"),
    WTD_EXCEPTION("604","写入临时表出现异常"),
    CODE_IN_SHQ("605","企业代码在审核区内"),
    SSSQ_OUT_RANGE("606","所属时期不能晚于当前月份"),
    SQL_ERROR("700","数据库访问错误"),
    APP_BIZ_ERROR("701","业务异常"),
    IO_ERROR("702", "读写错误"),
    INVALID_PARAM("703","参数错误"),
    APP_NO_AUTH("800","应用标识未授权"),
    IP_NO_AUTH("801","客户端IP未授权"),
    ACCOUNT_NO_AUTH("802","帐号或密码错误"),
    SERVICE_NO_AUTH("803","该服务未授权"),
    UNKNOWN_ERROR("999","服务端错误");
    private String code;

    private String msg;

    ResultCode(String code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public String getCode() {
        return code;
    }

    public String getMsg() {
        return msg;
    }

}
