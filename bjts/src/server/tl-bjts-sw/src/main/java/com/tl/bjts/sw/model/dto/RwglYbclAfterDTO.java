package com.tl.bjts.sw.model.dto;

/**
 * 描述:任务处理-异步处理(后置服务）
 * 作者 likun
 * 时间 2020-05-11 11:13
 */
public class RwglYbclAfterDTO {
    private String code; //代码
    private String rwhash; //任务hash
    private boolean freshFlag;//重新刷新标志
    private String bz; //备注
    private String rwbw; //任务报文

    public String getRwhash() {
        return rwhash;
    }

    public void setRwhash(String rwhash) {
        this.rwhash = rwhash;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Boolean getFreshFlag() {
        return freshFlag;
    }

    public void setFreshFlag(Boolean freshFlag) {
        this.freshFlag = freshFlag;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }

    public boolean isFreshFlag() {
        return freshFlag;
    }

    public void setFreshFlag(boolean freshFlag) {
        this.freshFlag = freshFlag;
    }

    public String getRwbw() {
        return rwbw;
    }

    public void setRwbw(String rwbw) {
        this.rwbw = rwbw;
    }
}
