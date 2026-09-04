package com.tl.web.bjts.yj.model;

/**
 * @Author：Mamf
 * @Date: 2017/11/23.
 * @Description:
 */
public enum StatusCode {

    INIT("20","已提交申报状态"),
    ZSSB_NET_TAX("2A","网报方式"),//可以进行申报状态（网报方式）
    ZSSB_FILE_READIN("2B","文件读入方式"),//可以进行申报状态（文件读入方式）
    ACCEPT("21","申报通过"), //申报通过(成功进入龙图审核系统)
    ENTER_SUCCESS("30","申报成功"), //申报成功(在审核系统中进行流转)
    FINAL_SUCCESS("39","成功处理"), //申报成功处理(成功最终的状态)
    BACK("40","人工退回"), //人工退回
    ERROR("41","申报异常"), //申报异常
    PRE_SUCCESS("42","比对通过"), //预审通过
    PRE_DOUBT("43","比对有疑点"),//预审有疑点
    PRE_DELAY_2A("1A","2A任务挂起"),
    PRE_DELAY_2B("1B","2B任务挂起");//预审有疑点

    private String code;

    private String msg;

    StatusCode(String code, String msg) {
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
