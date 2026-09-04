package com.tl.web.bjts.shzs.model.vo.ldlp;

public class BgdParamVo {
    private String bgdNo; // 18位报关单号
    private Long sbid; // 申报id

    private String lcslid;

    public String getLcslid() {
        return this.lcslid;

    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public String getBgdNo() {
        return bgdNo;
    }

    public void setBgdNo(String bgdNo) {
        this.bgdNo = bgdNo;
    }

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }
}
