package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_TSSH.CKLLFX_CS_FXLLSZ_WM")
public class CkllfxCsFxllszWmModel implements Serializable {
    @Id
    @Column(name = "SWJG_DM")
    private String swjgDm;

    @Id
    @Column(name = "YSFS_DM")
    private String ysfsDm;

    @Id
    @Column(name = "QYCODE_HYD")
    private String qycodeHyd;

    @Id
    @Column(name = "QYCODE_HG")
    private String qycodeHg;

    @Id
    @Column(name = "QYCODE_MDG")
    private String qycodeMdg;

    @Column(name = "YJBZ")
    private String yjbz;

    @Column(name = "YJSCORE")
    private Long yjscore;

    @Column(name = "SZRQ")
    private Date szrq;

    @Column(name = "SZRY")
    private String szry;

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
     * @return YSFS_DM
     */
    public String getYsfsDm() {
        return ysfsDm;
    }

    /**
     * @param ysfsDm
     */
    public void setYsfsDm(String ysfsDm) {
        this.ysfsDm = ysfsDm == null ? null : ysfsDm.trim();
    }

    /**
     * @return QYCODE_HYD
     */
    public String getQycodeHyd() {
        return qycodeHyd;
    }

    /**
     * @param qycodeHyd
     */
    public void setQycodeHyd(String qycodeHyd) {
        this.qycodeHyd = qycodeHyd == null ? null : qycodeHyd.trim();
    }

    /**
     * @return QYCODE_HG
     */
    public String getQycodeHg() {
        return qycodeHg;
    }

    /**
     * @param qycodeHg
     */
    public void setQycodeHg(String qycodeHg) {
        this.qycodeHg = qycodeHg == null ? null : qycodeHg.trim();
    }

    /**
     * @return QYCODE_MDG
     */
    public String getQycodeMdg() {
        return qycodeMdg;
    }

    /**
     * @param qycodeMdg
     */
    public void setQycodeMdg(String qycodeMdg) {
        this.qycodeMdg = qycodeMdg == null ? null : qycodeMdg.trim();
    }

    /**
     * @return YJBZ
     */
    public String getYjbz() {
        return yjbz;
    }

    /**
     * @param yjbz
     */
    public void setYjbz(String yjbz) {
        this.yjbz = yjbz == null ? null : yjbz.trim();
    }

    /**
     * @return YJSCORE
     */
    public Long getYjscore() {
        return yjscore;
    }

    /**
     * @param yjscore
     */
    public void setYjscore(Long yjscore) {
        this.yjscore = yjscore;
    }

    /**
     * @return SZRQ
     */
    public Date getSzrq() {
        return szrq;
    }

    /**
     * @param szrq
     */
    public void setSzrq(Date szrq) {
        this.szrq = szrq;
    }

    /**
     * @return SZRY
     */
    public String getSzry() {
        return szry;
    }

    /**
     * @param szry
     */
    public void setSzry(String szry) {
        this.szry = szry == null ? null : szry.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", swjgDm=").append(swjgDm);
        sb.append(", ysfsDm=").append(ysfsDm);
        sb.append(", qycodeHyd=").append(qycodeHyd);
        sb.append(", qycodeHg=").append(qycodeHg);
        sb.append(", qycodeMdg=").append(qycodeMdg);
        sb.append(", yjbz=").append(yjbz);
        sb.append(", yjscore=").append(yjscore);
        sb.append(", szrq=").append(szrq);
        sb.append(", szry=").append(szry);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}