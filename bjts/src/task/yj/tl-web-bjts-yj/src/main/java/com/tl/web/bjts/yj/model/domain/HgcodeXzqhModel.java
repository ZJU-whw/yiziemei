package com.tl.web.bjts.yj.model.domain;

/**
 * @description 海关行政区划代码表
 * @author: Mamf
 * @date: 2026/5/9 15:09
 */
public class HgcodeXzqhModel {

    /**
     * HGCODE - 海关代码
     */
    private String hgcode;

    /**
     * HGMC - 海关名称
     */
    private String hgmc;

    /**
     * XZQH_DM - 行政区划代码
     */
    private String xzqhDm;

    /**
     * XZQH_MC - 行政区划名称
     */
    private String xzqhMc;

    /**
     * QYBZ - 启用标志
     */
    private String qybz;

    public String getHgcode() {
        return this.hgcode;

    }

    public void setHgcode(String hgcode) {
        this.hgcode = hgcode;
    }

    public String getHgmc() {
        return this.hgmc;

    }

    public void setHgmc(String hgmc) {
        this.hgmc = hgmc;
    }

    public String getXzqhDm() {
        return this.xzqhDm;

    }

    public void setXzqhDm(String xzqhDm) {
        this.xzqhDm = xzqhDm;
    }

    public String getXzqhMc() {
        return this.xzqhMc;

    }

    public void setXzqhMc(String xzqhMc) {
        this.xzqhMc = xzqhMc;
    }

    public String getQybz() {
        return this.qybz;

    }

    public void setQybz(String qybz) {
        this.qybz = qybz;
    }
}
