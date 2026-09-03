package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "DM_SWJG")
public class TlSWJGProfile implements Serializable {
    @Id
    @Column(name = "SWJG_DM")
    private String swjgDm;

    @Column(name = "SWJG_MC")
    private String swjgMc;

    @Column(name = "SWJG_JC")
    private String swjgJc;

    @Column(name = "SWJG_DM_SJ")
    private String swjgDmSj;

    @Column(name = "YXWS")
    private Long yxws;

    @Column(name = "SWJG_BZ")
    private String swjgBz;

    @Column(name = "QYBZ")
    private String qybz;

    @Column(name = "TSJG_BZ")
    private String tsjgBz;

    private static final long serialVersionUID = 1L;

    /**
     * @return SWJG_DM
     */
    public String getSwjgDm() {
        return swjgDm;
    }

    /**
     * @param swjgDm
     */
    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm == null ? null : swjgDm.trim();
    }

    /**
     * @return SWJG_MC
     */
    public String getSwjgMc() {
        return swjgMc;
    }

    /**
     * @param swjgMc
     */
    public void setSwjgMc(String swjgMc) {
        this.swjgMc = swjgMc == null ? null : swjgMc.trim();
    }

    /**
     * @return SWJG_JC
     */
    public String getSwjgJc() {
        return swjgJc;
    }

    /**
     * @param swjgJc
     */
    public void setSwjgJc(String swjgJc) {
        this.swjgJc = swjgJc == null ? null : swjgJc.trim();
    }

    /**
     * @return SWJG_DM_SJ
     */
    public String getSwjgDmSj() {
        return swjgDmSj;
    }

    /**
     * @param swjgDmSj
     */
    public void setSwjgDmSj(String swjgDmSj) {
        this.swjgDmSj = swjgDmSj == null ? null : swjgDmSj.trim();
    }

    /**
     * @return YXWS
     */
    public Long getYxws() {
        return yxws;
    }

    /**
     * @param yxws
     */
    public void setYxws(Long yxws) {
        this.yxws = yxws;
    }

    /**
     * @return SWJG_BZ
     */
    public String getSwjgBz() {
        return swjgBz;
    }

    /**
     * @param swjgBz
     */
    public void setSwjgBz(String swjgBz) {
        this.swjgBz = swjgBz == null ? null : swjgBz.trim();
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

    /**
     * @return TSJG_BZ
     */
    public String getTsjgBz() {
        return tsjgBz;
    }

    /**
     * @param tsjgBz
     */
    public void setTsjgBz(String tsjgBz) {
        this.tsjgBz = tsjgBz == null ? null : tsjgBz.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", swjgDm=").append(swjgDm);
        sb.append(", swjgMc=").append(swjgMc);
        sb.append(", swjgJc=").append(swjgJc);
        sb.append(", swjgDmSj=").append(swjgDmSj);
        sb.append(", yxws=").append(yxws);
        sb.append(", swjgBz=").append(swjgBz);
        sb.append(", qybz=").append(qybz);
        sb.append(", tsjgBz=").append(tsjgBz);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}