package com.tl.web.bjts.yj.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "SB_SBXX_SBSJ")
public class SbShxxSbsjProfile implements Serializable {
    @Id
    @Column(name = "ID")
    private Long id;

    @Column(name = "BWGS")
    private String bwgs;

    @Column(name = "BWZY")
    private String bwzy;

    @Column(name = "MWZY")
    private String mwzy;

    @Column(name = "SBBW")
    private byte[] sbbw;

    @Column(name = "BWQM")
    private String bwqm;

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
     * @return BWGS
     */
    public String getBwgs() {
        return bwgs;
    }

    /**
     * @param bwgs
     */
    public void setBwgs(String bwgs) {
        this.bwgs = bwgs == null ? null : bwgs.trim();
    }

    /**
     * @return BWZY
     */
    public String getBwzy() {
        return bwzy;
    }

    /**
     * @param bwzy
     */
    public void setBwzy(String bwzy) {
        this.bwzy = bwzy == null ? null : bwzy.trim();
    }

    /**
     * @return MWZY
     */
    public String getMwzy() {
        return mwzy;
    }

    /**
     * @param mwzy
     */
    public void setMwzy(String mwzy) {
        this.mwzy = mwzy == null ? null : mwzy.trim();
    }

    /**
     * @return SBBW
     */
    public byte[] getSbbw() {
        return sbbw;
    }

    /**
     * @param sbbw
     */
    public void setSbbw(byte[] sbbw) {
        this.sbbw = sbbw;
    }

    /**
     * @return BWQM
     */
    public String getBwqm() {
        return bwqm;
    }

    /**
     * @param bwqm
     */
    public void setBwqm(String bwqm) {
        this.bwqm = bwqm == null ? null : bwqm.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", bwgs=").append(bwgs);
        sb.append(", bwzy=").append(bwzy);
        sb.append(", mwzy=").append(mwzy);
        sb.append(", sbbw=").append(sbbw);
        sb.append(", bwqm=").append(bwqm);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}