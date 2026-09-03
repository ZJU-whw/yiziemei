package com.tl.bjts.sw.model.domain;





import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_TSSH.JCFX_NSR_BADJ")
public class NsrBadjModel implements Serializable {
    @Id
    @Column(name = "DJXH")
    @JsonSerialize(using=ToStringSerializer.class)
    private BigDecimal djxh;

    @Column(name = "NSRSBH")
    private String nsrsbh;

    @Column(name = "SHXYDM")
    private String shxydm;

    @Column(name = "NSRMC")
    private String nsrmc;

    @Column(name = "QYHGDM")
    private String qyhgdm;

    @Column(name = "CKQYLX")
    private String ckqylx;

    @Column(name = "FLGLCD")
    private String flglcd;

    @Column(name = "DJZCLX")
    private String djzclx;

    @Column(name = "HY")
    private String hy;

    @Column(name = "NSRZT")
    private String nsrzt;

    @Column(name = "NSRLB")
    private String nsrlb;

    @Column(name = "QYFZ")
    private String qyfz;

    @Column(name = "BACHBZ")
    private String bachbz;

    @Column(name = "BACHSJ")
    private Date bachsj;

    @Column(name = "SWJGDM")
    private String swjgdm;

    @Column(name = "KSSWJG_DM")
    private String ksswjgDm;

    @Column(name = "JDXZ_DM")
    private String jdxzDm;

    @Column(name = "NSRDZDAH")
    private BigDecimal nsrdzdah;

    private static final long serialVersionUID = 1L;

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
     * @return SHXYDM
     */
    public String getShxydm() {
        return shxydm;
    }

    /**
     * @param shxydm
     */
    public void setShxydm(String shxydm) {
        this.shxydm = shxydm == null ? null : shxydm.trim();
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
     * @return QYHGDM
     */
    public String getQyhgdm() {
        return qyhgdm;
    }

    /**
     * @param qyhgdm
     */
    public void setQyhgdm(String qyhgdm) {
        this.qyhgdm = qyhgdm == null ? null : qyhgdm.trim();
    }

    /**
     * @return CKQYLX
     */
    public String getCkqylx() {
        return ckqylx;
    }

    /**
     * @param ckqylx
     */
    public void setCkqylx(String ckqylx) {
        this.ckqylx = ckqylx == null ? null : ckqylx.trim();
    }

    /**
     * @return FLGLCD
     */
    public String getFlglcd() {
        return flglcd;
    }

    /**
     * @param flglcd
     */
    public void setFlglcd(String flglcd) {
        this.flglcd = flglcd == null ? null : flglcd.trim();
    }

    /**
     * @return DJZCLX
     */
    public String getDjzclx() {
        return djzclx;
    }

    /**
     * @param djzclx
     */
    public void setDjzclx(String djzclx) {
        this.djzclx = djzclx == null ? null : djzclx.trim();
    }

    /**
     * @return HY
     */
    public String getHy() {
        return hy;
    }

    /**
     * @param hy
     */
    public void setHy(String hy) {
        this.hy = hy == null ? null : hy.trim();
    }

    /**
     * @return NSRZT
     */
    public String getNsrzt() {
        return nsrzt;
    }

    /**
     * @param nsrzt
     */
    public void setNsrzt(String nsrzt) {
        this.nsrzt = nsrzt == null ? null : nsrzt.trim();
    }

    /**
     * @return NSRLB
     */
    public String getNsrlb() {
        return nsrlb;
    }

    /**
     * @param nsrlb
     */
    public void setNsrlb(String nsrlb) {
        this.nsrlb = nsrlb == null ? null : nsrlb.trim();
    }

    /**
     * @return QYFZ
     */
    public String getQyfz() {
        return qyfz;
    }

    /**
     * @param qyfz
     */
    public void setQyfz(String qyfz) {
        this.qyfz = qyfz == null ? null : qyfz.trim();
    }

    /**
     * @return BACHBZ
     */
    public String getBachbz() {
        return bachbz;
    }

    /**
     * @param bachbz
     */
    public void setBachbz(String bachbz) {
        this.bachbz = bachbz == null ? null : bachbz.trim();
    }

    /**
     * @return BACHSJ
     */
    public Date getBachsj() {
        return bachsj;
    }

    /**
     * @param bachsj
     */
    public void setBachsj(Date bachsj) {
        this.bachsj = bachsj;
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
     * @return KSSWJG_DM
     */
    public String getKsswjgDm() {
        return ksswjgDm;
    }

    /**
     * @param ksswjgDm
     */
    public void setKsswjgDm(String ksswjgDm) {
        this.ksswjgDm = ksswjgDm == null ? null : ksswjgDm.trim();
    }

    /**
     * @return JDXZ_DM
     */
    public String getJdxzDm() {
        return jdxzDm;
    }

    /**
     * @param jdxzDm
     */
    public void setJdxzDm(String jdxzDm) {
        this.jdxzDm = jdxzDm == null ? null : jdxzDm.trim();
    }

    /**
     * @return NSRDZDAH
     */
    public BigDecimal getNsrdzdah() {
        return nsrdzdah;
    }

    /**
     * @param nsrdzdah
     */
    public void setNsrdzdah(BigDecimal nsrdzdah) {
        this.nsrdzdah = nsrdzdah;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", djxh=").append(djxh);
        sb.append(", nsrsbh=").append(nsrsbh);
        sb.append(", shxydm=").append(shxydm);
        sb.append(", nsrmc=").append(nsrmc);
        sb.append(", qyhgdm=").append(qyhgdm);
        sb.append(", ckqylx=").append(ckqylx);
        sb.append(", flglcd=").append(flglcd);
        sb.append(", djzclx=").append(djzclx);
        sb.append(", hy=").append(hy);
        sb.append(", nsrzt=").append(nsrzt);
        sb.append(", nsrlb=").append(nsrlb);
        sb.append(", qyfz=").append(qyfz);
        sb.append(", bachbz=").append(bachbz);
        sb.append(", bachsj=").append(bachsj);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", ksswjgDm=").append(ksswjgDm);
        sb.append(", jdxzDm=").append(jdxzDm);
        sb.append(", nsrdzdah=").append(nsrdzdah);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}