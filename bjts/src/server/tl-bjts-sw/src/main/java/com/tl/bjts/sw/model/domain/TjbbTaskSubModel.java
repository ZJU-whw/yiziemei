package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TJBB_TASK_SUB")
public class TjbbTaskSubModel implements Serializable {
    @Id
    @Column(name = "BBID")
    private String bbid;

    @Column(name = "BBDM")
    private String bbdm;

    @Column(name = "SWJGDM")
    private String swjgdm;

    @Column(name = "NY")
    private String ny;

    @Column(name = "HZTIME")
    private Date hztime;

    @Column(name = "HZR")
    private String hzr;

    @Column(name = "XGTIME")
    private Date xgtime;

    @Column(name = "XGR")
    private String xgr;

    @Column(name = "BBDLDM")
    private String bbdldm;

    private static final long serialVersionUID = 1L;

    public String getBbid() {
        return bbid;
    }

    public void setBbid(String bbid) {
        this.bbid = bbid;
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
     * @return NY
     */
    public String getNy() {
        return ny;
    }

    /**
     * @param ny
     */
    public void setNy(String ny) {
        this.ny = ny == null ? null : ny.trim();
    }

    /**
     * @return HZTIME
     */
    public Date getHztime() {
        return hztime;
    }

    /**
     * @param hztime
     */
    public void setHztime(Date hztime) {
        this.hztime = hztime;
    }

    /**
     * @return HZR
     */
    public String getHzr() {
        return hzr;
    }

    /**
     * @param hzr
     */
    public void setHzr(String hzr) {
        this.hzr = hzr == null ? null : hzr.trim();
    }

    /**
     * @return XGTIME
     */
    public Date getXgtime() {
        return xgtime;
    }

    /**
     * @param xgtime
     */
    public void setXgtime(Date xgtime) {
        this.xgtime = xgtime;
    }

    /**
     * @return XGR
     */
    public String getXgr() {
        return xgr;
    }

    /**
     * @param xgr
     */
    public void setXgr(String xgr) {
        this.xgr = xgr == null ? null : xgr.trim();
    }

    /**
     * @return BBDLDM
     */
    public String getBbdldm() {
        return bbdldm;
    }

    /**
     * @param bbdldm
     */
    public void setBbdldm(String bbdldm) {
        this.bbdldm = bbdldm == null ? null : bbdldm.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", bbid=").append(bbid);
        sb.append(", bbdm=").append(bbdm);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", ny=").append(ny);
        sb.append(", hztime=").append(hztime);
        sb.append(", hzr=").append(hzr);
        sb.append(", xgtime=").append(xgtime);
        sb.append(", xgr=").append(xgr);
        sb.append(", bbdldm=").append(bbdldm);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}