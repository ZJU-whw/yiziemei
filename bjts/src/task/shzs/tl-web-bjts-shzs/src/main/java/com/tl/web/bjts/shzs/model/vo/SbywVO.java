package com.tl.web.bjts.shzs.model.vo;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by Neo Lin on 2017/6/19.
 */
public class SbywVO {
    private Long sbid;
    private Date sbsq;
    private Date sbrq;
    private String qyhgdm;
    private String nsrmc;
    private String sbywdm;
    private Integer sbpc;

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public Date getSbsq() {
        return sbsq;
    }

    public void setSbsq(Date sbsq) {
        this.sbsq = sbsq;
    }

    public Date getSbrq() {
        return sbrq;
    }

    public void setSbrq(Date sbrq) {
        this.sbrq = sbrq;
    }

    public String getQyhgdm() {
        return qyhgdm;
    }

    public void setQyhgdm(String qyhgdm) {
        this.qyhgdm = qyhgdm;
    }

    public String getNsrmc() {
        return nsrmc;
    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }

    public String getSbywdm() {
        return sbywdm;
    }

    public void setSbywdm(String sbywdm) {
        this.sbywdm = sbywdm;
    }

    public Integer getSbpc() {
        return sbpc;
    }

    public void setSbpc(Integer sbpc) {
        this.sbpc = sbpc;
    }
}
