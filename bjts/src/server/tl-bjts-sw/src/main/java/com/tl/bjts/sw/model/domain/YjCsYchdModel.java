package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_CS_YCHD")
public class YjCsYchdModel implements Serializable {
    @Id
    @Column(name = "FHBH")
    private String fhbh;

    @Column(name = "FHRQ")
    private Date fhrq;

    @Column(name = "NSRSBH")
    private String nsrsbh;

    @Column(name = "NSRMC")
    private String nsrmc;

    @Column(name = "ZGSWJGMC")
    private String zgswjgmc;

    @Column(name = "FHNR")
    private String fhnr;

    @Column(name = "TBSJ")
    private Date tbsj;

    @Column(name = "YXBZ")
    private String yxbz;

    private static final long serialVersionUID = 1L;

    /**
     * @return FHBH
     */
    public String getFhbh() {
        return fhbh;
    }

    /**
     * @param fhbh
     */
    public void setFhbh(String fhbh) {
        this.fhbh = fhbh == null ? null : fhbh.trim();
    }

    /**
     * @return FHRQ
     */
    public Date getFhrq() {
        return fhrq;
    }

    /**
     * @param fhrq
     */
    public void setFhrq(Date fhrq) {
        this.fhrq = fhrq;
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
     * @return FHNR
     */
    public String getFhnr() {
        return fhnr;
    }

    /**
     * @param fhnr
     */
    public void setFhnr(String fhnr) {
        this.fhnr = fhnr == null ? null : fhnr.trim();
    }

    /**
     * @return TBSJ
     */
    public Date getTbsj() {
        return tbsj;
    }

    /**
     * @param tbsj
     */
    public void setTbsj(Date tbsj) {
        this.tbsj = tbsj;
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
        sb.append(", fhbh=").append(fhbh);
        sb.append(", fhrq=").append(fhrq);
        sb.append(", nsrsbh=").append(nsrsbh);
        sb.append(", nsrmc=").append(nsrmc);
        sb.append(", zgswjgmc=").append(zgswjgmc);
        sb.append(", fhnr=").append(fhnr);
        sb.append(", tbsj=").append(tbsj);
        sb.append(", yxbz=").append(yxbz);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}