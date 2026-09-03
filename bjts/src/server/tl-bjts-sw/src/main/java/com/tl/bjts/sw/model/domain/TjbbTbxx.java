package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TJBB_REPORT_TBXX")
public class TjbbTbxx implements Serializable {
    @Id
    @Column(name = "ID")
    private BigDecimal id;

    @Column(name = "BBDM")
    private String bbdm;

    @Column(name = "SWJGDM")
    private String swjgdm;

    @Column(name = "SWJGMC")
    private String swjgmc;

    @Column(name = "SSNY")
    private String ssny;

    @Column(name = "UNIT")
    private String unit;

    @Column(name = "ZBR")
    private String zbr;

    @Column(name = "ZBDATE")
    private Date zbdate;

    @Column(name = "QT")
    private String qt;


    private static final long serialVersionUID = 1L;

    public String getQt() {
        return qt;
    }

    public void setQt(String qt) {
        this.qt = qt;
    }

    /**
     * @return ID
     */
    public BigDecimal getId() {
        return id;
    }

    /**
     * @param id
     */
    public void setId(BigDecimal id) {
        this.id = id;
    }

    /**
     * @return BBDM
     */
    public String getBbdm() {
        return bbdm;
    }

    /**
     * @param bbdm
     */
    public void setBbdm(String bbdm) {
        this.bbdm = bbdm == null ? null : bbdm.trim();
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
     * @return SWJGMC
     */
    public String getSwjgmc() {
        return swjgmc;
    }

    /**
     * @param swjgmc
     */
    public void setSwjgmc(String swjgmc) {
        this.swjgmc = swjgmc == null ? null : swjgmc.trim();
    }

    /**
     * @return SSNY
     */
    public String getSsny() {
        return ssny;
    }

    /**
     * @param ssny
     */
    public void setSsny(String ssny) {
        this.ssny = ssny == null ? null : ssny.trim();
    }

    /**
     * @return UNIT
     */
    public String getUnit() {
        return unit;
    }

    /**
     * @param unit
     */
    public void setUnit(String unit) {
        this.unit = unit == null ? null : unit.trim();
    }

    /**
     * @return ZBR
     */
    public String getZbr() {
        return zbr;
    }

    /**
     * @param zbr
     */
    public void setZbr(String zbr) {
        this.zbr = zbr == null ? null : zbr.trim();
    }

    /**
     * @return ZBDATE
     */
    public Date getZbdate() {
        return zbdate;
    }

    /**
     * @param zbdate
     */
    public void setZbdate(Date zbdate) {
        this.zbdate = zbdate;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", bbdm=").append(bbdm);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", swjgmc=").append(swjgmc);
        sb.append(", ssny=").append(ssny);
        sb.append(", unit=").append(unit);
        sb.append(", zbr=").append(zbr);
        sb.append(", zbdate=").append(zbdate);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}