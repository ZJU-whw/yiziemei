package com.tl.bjts.sw.model.yj;

/**
 * @description 海关货源地代码表实体
 * @author: Mamf
 * @date: 2026/1/22 10:42
 */
public class DmHghyd {

    /** 主键 */
    private Long id;
    /** 海关货源地代码 */
    private String hghydDm;
    /** 海关货源地名称 */
    private String hghydMc;
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

    public Long getId() {
        return this.id;

    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getHghydDm() {
        return this.hghydDm;

    }

    public void setHghydDm(String hghydDm) {
        this.hghydDm = hghydDm;
    }

    public String getHghydMc() {
        return this.hghydMc;

    }

    public void setHghydMc(String hghydMc) {
        this.hghydMc = hghydMc;
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
