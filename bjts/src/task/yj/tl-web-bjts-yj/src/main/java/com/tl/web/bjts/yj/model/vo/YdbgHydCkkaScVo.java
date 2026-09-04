package com.tl.web.bjts.yj.model.vo;

import java.math.BigDecimal;

/**
 * @description 16002/16003预警视图对象
 * @author: Mamf
 * @date: 2026/6/22 13:11
 */
public class YdbgHydCkkaScVo {

    /**
     * 登记序号
     */
    private String djxh;

    /**
     * 出口报告单号
     */
    private String ckbgdh;

    /**
     * 经营活动地代码
     */
    private String jnhydDm;

    /**
     * 行政区划代码
     */
    private String xzqhDm;

    private String xzqhMc;

    /**
     * 海关关区代码
     */
    private String hggqkaDm;

    /**
     * 是否涉税资产 (Y/N)
     */
    private String stzc;

    /**
     * 贸易来源金额
     */
    private BigDecimal mylaj;

    /**
     * 免抵退税额
     */
    private BigDecimal mdtse;

    private String sbxh;

    public String getSbxh() {
        return this.sbxh;

    }

    public void setSbxh(String sbxh) {
        this.sbxh = sbxh;
    }

    public BigDecimal getMdtse() {
        return this.mdtse;

    }

    public void setMdtse(BigDecimal mdtse) {
        this.mdtse = mdtse;
    }

    public String getXzqhMc() {
        return this.xzqhMc;

    }

    public void setXzqhMc(String xzqhMc) {
        this.xzqhMc = xzqhMc;
    }

    public String getDjxh() {
        return this.djxh;

    }

    public void setDjxh(String djxh) {
        this.djxh = djxh;
    }

    public String getCkbgdh() {
        return this.ckbgdh;

    }

    public void setCkbgdh(String ckbgdh) {
        this.ckbgdh = ckbgdh;
    }

    public String getJnhydDm() {
        return this.jnhydDm;

    }

    public void setJnhydDm(String jnhydDm) {
        this.jnhydDm = jnhydDm;
    }

    public String getXzqhDm() {
        return this.xzqhDm;

    }

    public void setXzqhDm(String xzqhDm) {
        this.xzqhDm = xzqhDm;
    }

    public String getHggqkaDm() {
        return this.hggqkaDm;

    }

    public void setHggqkaDm(String hggqkaDm) {
        this.hggqkaDm = hggqkaDm;
    }

    public String getStzc() {
        return this.stzc;

    }

    public void setStzc(String stzc) {
        this.stzc = stzc;
    }

    public BigDecimal getMylaj() {
        return this.mylaj;

    }

    public void setMylaj(BigDecimal mylaj) {
        this.mylaj = mylaj;
    }
}
