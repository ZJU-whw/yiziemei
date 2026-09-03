package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_DIC_HGHYD")
public class YjDicHghydModel implements Serializable {
    @Column(name = "ID")
    private Long id;

    @Column(name = "HGHYD_DM")
    private String hghydDm;

    @Column(name = "HGHYD_MC")
    private String hghydMc;

    @Column(name = "XZQH_DM")
    private String xzqhDm;

    @Column(name = "XZQH_MC")
    private String xzqhMc;

    @Column(name = "QYBZ")
    private String qybz;

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
     * @return HGHYD_DM
     */
    public String getHghydDm() {
        return hghydDm;
    }

    /**
     * @param hghydDm
     */
    public void setHghydDm(String hghydDm) {
        this.hghydDm = hghydDm == null ? null : hghydDm.trim();
    }

    /**
     * @return HGHYD_MC
     */
    public String getHghydMc() {
        return hghydMc;
    }

    /**
     * @param hghydMc
     */
    public void setHghydMc(String hghydMc) {
        this.hghydMc = hghydMc == null ? null : hghydMc.trim();
    }

    /**
     * @return XZQH_DM
     */
    public String getXzqhDm() {
        return xzqhDm;
    }

    /**
     * @param xzqhDm
     */
    public void setXzqhDm(String xzqhDm) {
        this.xzqhDm = xzqhDm == null ? null : xzqhDm.trim();
    }

    /**
     * @return XZQH_MC
     */
    public String getXzqhMc() {
        return xzqhMc;
    }

    /**
     * @param xzqhMc
     */
    public void setXzqhMc(String xzqhMc) {
        this.xzqhMc = xzqhMc == null ? null : xzqhMc.trim();
    }

    /**
     * @return QYBZ
     */
    public String getQybz() {
        return qybz;
    }

    /**
     * @param qybz
     */
    public void setQybz(String qybz) {
        this.qybz = qybz == null ? null : qybz.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", hghydDm=").append(hghydDm);
        sb.append(", hghydMc=").append(hghydMc);
        sb.append(", xzqhDm=").append(xzqhDm);
        sb.append(", xzqhMc=").append(xzqhMc);
        sb.append(", qybz=").append(qybz);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}