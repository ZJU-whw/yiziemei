package com.tl.bjts.sw.model.dto;

/**
 * 描述:任务处理-异步处理(前置服务）
 * 作者 likun
 * 时间 2020-05-11 11:13
 */
public class RwglYbclBeforeDTO {
    private String rwlx; //任务类型
    private String rwhash; //任务hash
    private String rwbw; //任务报文
    private String rwms; //任务描述
    private String userRefresh;// 用户点击重新统计

    public String getRwhash() {
        return rwhash;
    }

    public void setRwhash(String rwhash) {
        this.rwhash = rwhash;
    }

    public String getRwbw() {
        return rwbw;
    }

    public void setRwbw(String rwbw) {
        this.rwbw = rwbw;
    }

    public String getRwlx() {
        return rwlx;
    }

    public void setRwlx(String rwlx) {
        this.rwlx = rwlx;
    }
    public String getRwms() {
        return rwms;
    }

    public void setRwms(String rwms) {
        this.rwms = rwms;
    }

    public String getUserRefresh() {
        return userRefresh;
    }

    public void setUserRefresh(String userRefresh) {
        this.userRefresh = userRefresh;
    }
}
