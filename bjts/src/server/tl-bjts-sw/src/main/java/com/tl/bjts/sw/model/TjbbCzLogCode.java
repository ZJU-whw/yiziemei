package com.tl.bjts.sw.model;

/**
 * @Author：Mamf
 * @Date: 2020/1/8.
 * @Description:
 */
public enum TjbbCzLogCode {

    CZ_CODE_MAKE("10", "制表"),
    CZ_CODE_SB("20", "上报"),
    CZ_CODE_CH("30", "撤回"),
    CZ_CODE_CXMAKE("40", "重新制表"),
    CZ_TYPE_TASK("1","任务流程");




    private String code;

    private String msg;

    TjbbCzLogCode(String code, String msg) {
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
