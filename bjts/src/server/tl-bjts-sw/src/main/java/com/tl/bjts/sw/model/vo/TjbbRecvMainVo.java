package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.Date;

/**
 * @Author：Mamf
 * @Date: 2019/9/29.
 * @Description:
 */
public class TjbbRecvMainVo {

    private String ssny;

    private String bbdm;

    private String swjgdm;

    private String swjgmc;

    @JsonFormat(pattern = "yyyy-MM-dd hh:mm:ss", timezone = "GMT+8")
    private Date sbtime;

    private String sbr;

    public String getSsny() {
        return ssny;
    }

    public void setSsny(String ssny) {
        this.ssny = ssny;
    }

    public String getBbdm() {
        return bbdm;
    }

    public void setBbdm(String bbdm) {
        this.bbdm = bbdm;
    }

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getSwjgmc() {
        return swjgmc;
    }

    public void setSwjgmc(String swjgmc) {
        this.swjgmc = swjgmc;
    }

    public Date getSbtime() {
        return sbtime;
    }

    public void setSbtime(Date sbtime) {
        this.sbtime = sbtime;
    }

    public String getSbr() {
        return sbr;
    }

    public void setSbr(String sbr) {
        this.sbr = sbr;
    }
}
