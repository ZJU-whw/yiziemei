package com.tl.web.bjts.yj.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "SB_SBXX_FKSJ")
public class SbxxFksj implements Serializable {
    @Id
    @Column(name = "ID")
    private Long id;

    @Column(name = "BWGS")
    private String bwgs;

    @Column(name = "FKLX")
    private String fklx;

    @Column(name = "FKBW")
    private byte[] fkbw;

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
     * @return FKLX
     */
    public String getFklx() {
        return fklx;
    }

    /**
     * @param fklx
     */
    public void setFklx(String fklx) {
        this.fklx = fklx == null ? null : fklx.trim();
    }

    /**
     * @return FKBW
     */
    public byte[] getFkbw() {
        return fkbw;
    }

    /**
     * @param fkbw
     */
    public void setFkbw(byte[] fkbw) {
        this.fkbw = fkbw;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", bwgs=").append(bwgs);
        sb.append(", fklx=").append(fklx);
        sb.append(", fkbw=").append(fkbw);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}