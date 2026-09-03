package com.tl.bjts.sw.model.yj;

/**
 * @description 海关口岸代码表实体
 * @author: Mamf
 * @date: 2026/1/22 10:43
 */
public class DmHgcode {
    /** 海关口岸代码 */
    private String hgcode;
    /** 海关口岸名称 */
    private String hgmc;
    /** 对应行政区划代码 */
    private String xzqhDm;
    /** 对应行政区划名称 */
    private String xzqhMc;
    /** 启用标志（1=启用，0=禁用） */
    private String qybz;
    /**
     * 区域代码
     */
    private String qyCode;

    /**
     * 区域名称
     */
    private String qyName;

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

    public String getQyCode() {
        return this.qyCode;

    }

    public void setQyCode(String qyCode) {
        this.qyCode = qyCode;
    }

    public String getQyName() {
        return this.qyName;

    }

    public void setQyName(String qyName) {
        this.qyName = qyName;
    }
}
