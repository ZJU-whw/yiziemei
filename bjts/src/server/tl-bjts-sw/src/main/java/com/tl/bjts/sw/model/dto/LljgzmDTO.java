package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

import java.util.Date;

public class LljgzmDTO extends BaseListDTO {
    private String swjgdm ; //主管税务机关代码  |
    private String hgdm ; //海关代码  |
    private String shxydm ; // 社会信用代码    |
    private String nsrmc     ; // 企业名称    |
    private Date sbrqq ; //申报日期起  |
    private Date sbrqz ; // 申报日期止    |
    private String lldjzmno ; //来料登记册号  |
    private String sbzmno ; //申报证明号  |
    private String yhxbz ; //已核销标志  |
    private String qylx;
    private String qxdm;

    public String getQxdm() {
        return qxdm;
    }

    public void setQxdm(String qxdm) {
        this.qxdm = qxdm;
    }

    public String getQylx() {
        return qylx;
    }

    public void setQylx(String qylx) {
        this.qylx = qylx;
    }

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getHgdm() {
        return hgdm;
    }

    public void setHgdm(String hgdm) {
        this.hgdm = hgdm;
    }

    public String getShxydm() {
        return shxydm;
    }

    public void setShxydm(String shxydm) {
        this.shxydm = shxydm;
    }

    public String getNsrmc() {
        return nsrmc;
    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }

    public Date getSbrqq() {
        return sbrqq;
    }

    public void setSbrqq(Date sbrqq) {
        this.sbrqq = sbrqq;
    }

    public Date getSbrqz() {
        return sbrqz;
    }

    public void setSbrqz(Date sbrqz) {
        this.sbrqz = sbrqz;
    }

    public String getLldjzmno() {
        return lldjzmno;
    }

    public void setLldjzmno(String lldjzmno) {
        this.lldjzmno = lldjzmno;
    }

    public String getSbzmno() {
        return sbzmno;
    }

    public void setSbzmno(String sbzmno) {
        this.sbzmno = sbzmno;
    }

    public String getYhxbz() {
        return yhxbz;
    }

    public void setYhxbz(String yhxbz) {
        this.yhxbz = yhxbz;
    }
}
