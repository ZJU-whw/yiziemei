package com.tl.web.bjts.shzs.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "ZJ_BJTS.FXNK_NBFXDMX_SZ")
public class FxnkZjBjtsSzProfile implements Serializable {
    @Column(name = "UUID")
    private String uuid;

    @Column(name = "SWJGDM")
    private String swjgdm;

    @Column(name = "DJXH")
    private BigDecimal djxh;

    @Column(name = "NSRSBH")
    private String nsrsbh;

    @Column(name = "NSRMC")
    private String nsrmc;

    @Column(name = "LCSWSX_DM")
    private String lcswsxDm;

    @Column(name = "LCSLID")
    private String lcslid;

    @Column(name = "CFRY")
    private String cfry;

    @Column(name = "CFSJ")
    private Date cfsj;

    @Column(name = "NKZBBH")
    private String nkzbbh;

    @Column(name = "NKJE")
    private BigDecimal nkje;

    @Column(name = "NKSE")
    private BigDecimal nkse;

    @Column(name = "NKYWMS")
    private String nkywms;

    @Column(name = "HXCZSM")
    private String hxczsm;

    private static final long serialVersionUID = 1L;

    /**
     * @return UUID
     */
    public String getUuid() {
        return uuid;
    }

    /**
     * @param uuid
     */
    public void setUuid(String uuid) {
        this.uuid = uuid == null ? null : uuid.trim();
    }

    /**
     * @return SWJGDM
     */
    public String getSwjgdm() {
        return swjgdm;
    }

    /**
     * @param swjgdm
     */
    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm == null ? null : swjgdm.trim();
    }

    /**
     * @return DJXH
     */
    public BigDecimal getDjxh() {
        return djxh;
    }

    /**
     * @param djxh
     */
    public void setDjxh(BigDecimal djxh) {
        this.djxh = djxh;
    }

    /**
     * @return NSRSBH
     */
    public String getNsrsbh() {
        return nsrsbh;
    }

    /**
     * @param nsrsbh
     */
    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh == null ? null : nsrsbh.trim();
    }

    /**
     * @return NSRMC
     */
    public String getNsrmc() {
        return nsrmc;
    }

    /**
     * @param nsrmc
     */
    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc == null ? null : nsrmc.trim();
    }

    /**
     * @return LCSWSX_DM
     */
    public String getLcswsxDm() {
        return lcswsxDm;
    }

    /**
     * @param lcswsxDm
     */
    public void setLcswsxDm(String lcswsxDm) {
        this.lcswsxDm = lcswsxDm == null ? null : lcswsxDm.trim();
    }

    /**
     * @return LCSLID
     */
    public String getLcslid() {
        return lcslid;
    }

    /**
     * @param lcslid
     */
    public void setLcslid(String lcslid) {
        this.lcslid = lcslid == null ? null : lcslid.trim();
    }

    /**
     * @return CFRY
     */
    public String getCfry() {
        return cfry;
    }

    /**
     * @param cfry
     */
    public void setCfry(String cfry) {
        this.cfry = cfry == null ? null : cfry.trim();
    }

    /**
     * @return CFSJ
     */
    public Date getCfsj() {
        return cfsj;
    }

    /**
     * @param cfsj
     */
    public void setCfsj(Date cfsj) {
        this.cfsj = cfsj;
    }

    /**
     * @return NKZBBH
     */
    public String getNkzbbh() {
        return nkzbbh;
    }

    /**
     * @param nkzbbh
     */
    public void setNkzbbh(String nkzbbh) {
        this.nkzbbh = nkzbbh == null ? null : nkzbbh.trim();
    }

    /**
     * @return NKJE
     */
    public BigDecimal getNkje() {
        return nkje;
    }

    /**
     * @param nkje
     */
    public void setNkje(BigDecimal nkje) {
        this.nkje = nkje;
    }

    /**
     * @return NKSE
     */
    public BigDecimal getNkse() {
        return nkse;
    }

    /**
     * @param nkse
     */
    public void setNkse(BigDecimal nkse) {
        this.nkse = nkse;
    }

    /**
     * @return NKYWMS
     */
    public String getNkywms() {
        return nkywms;
    }

    /**
     * @param nkywms
     */
    public void setNkywms(String nkywms) {
        this.nkywms = nkywms == null ? null : nkywms.trim();
    }

    /**
     * @return HXCZSM
     */
    public String getHxczsm() {
        return hxczsm;
    }

    /**
     * @param hxczsm
     */
    public void setHxczsm(String hxczsm) {
        this.hxczsm = hxczsm == null ? null : hxczsm.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", uuid=").append(uuid);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", djxh=").append(djxh);
        sb.append(", nsrsbh=").append(nsrsbh);
        sb.append(", nsrmc=").append(nsrmc);
        sb.append(", lcswsxDm=").append(lcswsxDm);
        sb.append(", lcslid=").append(lcslid);
        sb.append(", cfry=").append(cfry);
        sb.append(", cfsj=").append(cfsj);
        sb.append(", nkzbbh=").append(nkzbbh);
        sb.append(", nkje=").append(nkje);
        sb.append(", nkse=").append(nkse);
        sb.append(", nkywms=").append(nkywms);
        sb.append(", hxczsm=").append(hxczsm);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}