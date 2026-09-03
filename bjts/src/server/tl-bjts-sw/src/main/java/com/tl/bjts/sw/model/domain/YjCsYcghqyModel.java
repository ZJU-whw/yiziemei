package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_CS_YCGHQY")
public class YjCsYcghqyModel implements Serializable {
    @Id
    @Column(name = "ID")
    private Long id;

    @Column(name = "SWJGFW")
    private String swjgfw;

    @Column(name = "NSRSBH")
    private String nsrsbh;

    @Column(name = "NSRMC")
    private String nsrmc;

    @Column(name = "ZGSWJGMC")
    private String zgswjgmc;

    @Column(name = "QSRQ")
    private Date qsrq;

    @Column(name = "JZRQ")
    private Date jzrq;

    @Column(name = "YYMS")
    private String yyms;

    @Column(name = "LRR")
    private String lrr;

    @Column(name = "LRRQ")
    private Date lrrq;

    @Column(name = "LRSWJGDM")
    private String lrswjgdm;

    @Column(name = "YXBZ")
    private String yxbz;

    private static final long serialVersionUID = 1L;

    /**
     * @return ID
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return SWJGFW
     */
    public String getSwjgfw() {
        return swjgfw;
    }

    /**
     * @param swjgfw
     */
    public void setSwjgfw(String swjgfw) {
        this.swjgfw = swjgfw == null ? null : swjgfw.trim();
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
     * @return ZGSWJGMC
     */
    public String getZgswjgmc() {
        return zgswjgmc;
    }

    /**
     * @param zgswjgmc
     */
    public void setZgswjgmc(String zgswjgmc) {
        this.zgswjgmc = zgswjgmc == null ? null : zgswjgmc.trim();
    }

    /**
     * @return QSRQ
     */
    public Date getQsrq() {
        return qsrq;
    }

    /**
     * @param qsrq
     */
    public void setQsrq(Date qsrq) {
        this.qsrq = qsrq;
    }

    /**
     * @return JZRQ
     */
    public Date getJzrq() {
        return jzrq;
    }

    /**
     * @param jzrq
     */
    public void setJzrq(Date jzrq) {
        this.jzrq = jzrq;
    }

    /**
     * @return YYMS
     */
    public String getYyms() {
        return yyms;
    }

    /**
     * @param yyms
     */
    public void setYyms(String yyms) {
        this.yyms = yyms == null ? null : yyms.trim();
    }

    /**
     * @return LRR
     */
    public String getLrr() {
        return lrr;
    }

    /**
     * @param lrr
     */
    public void setLrr(String lrr) {
        this.lrr = lrr == null ? null : lrr.trim();
    }

    /**
     * @return LRRQ
     */
    public Date getLrrq() {
        return lrrq;
    }

    /**
     * @param lrrq
     */
    public void setLrrq(Date lrrq) {
        this.lrrq = lrrq;
    }

    /**
     * @return LRSWJGDM
     */
    public String getLrswjgdm() {
        return lrswjgdm;
    }

    /**
     * @param lrswjgdm
     */
    public void setLrswjgdm(String lrswjgdm) {
        this.lrswjgdm = lrswjgdm == null ? null : lrswjgdm.trim();
    }

    /**
     * @return YXBZ
     */
    public String getYxbz() {
        return yxbz;
    }

    /**
     * @param yxbz
     */
    public void setYxbz(String yxbz) {
        this.yxbz = yxbz == null ? null : yxbz.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", swjgfw=").append(swjgfw);
        sb.append(", nsrsbh=").append(nsrsbh);
        sb.append(", nsrmc=").append(nsrmc);
        sb.append(", zgswjgmc=").append(zgswjgmc);
        sb.append(", qsrq=").append(qsrq);
        sb.append(", jzrq=").append(jzrq);
        sb.append(", yyms=").append(yyms);
        sb.append(", lrr=").append(lrr);
        sb.append(", lrrq=").append(lrrq);
        sb.append(", lrswjgdm=").append(lrswjgdm);
        sb.append(", yxbz=").append(yxbz);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}