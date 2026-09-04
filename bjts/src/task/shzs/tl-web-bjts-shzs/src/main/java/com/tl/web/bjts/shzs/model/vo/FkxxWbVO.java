package com.tl.web.bjts.shzs.model.vo;

import java.math.BigDecimal;

/**
 * 反馈信息回写vo
 * Created by Neo Lin on 2017/6/20.
 */

public class FkxxWbVO {

    private Long sbid;
    private String lcslid;
    private String sbztDm;
    private String content;

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public String getLcslid() {
        return lcslid;
    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public String getSbztDm() {
        return sbztDm;
    }

    public void setSbztDm(String sbztDm) {
        this.sbztDm = sbztDm;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    @Override
    public String toString() {
        return "FkxxWbVO{" +
                "sbid=" + sbid +
                ", lcslid='" + lcslid + '\'' +
                ", sbztDm='" + sbztDm + '\'' +
                ", content='" + content + '\'' +
                '}';
    }
}
