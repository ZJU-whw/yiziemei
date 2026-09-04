package com.tl.web.bjts.shzs.model.vo;

public class FkxxWbSbyyVo {
    private Long sbid;
    private String sbyy;

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public String getSbyy() {
        return sbyy;
    }

    public void setSbyy(String sbyy) {
        this.sbyy = sbyy;
    }

    @Override
    public String toString() {
        return "FkxxWbSbyyVo{" +
                "sbid=" + sbid +
                ", sbyy='" + sbyy + '\'' +
                '}';
    }
}
