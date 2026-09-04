package com.tl.web.bjts.yj.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "SYS_MSG_NSR")
public class VipUserModel implements Serializable {
    @Id
    @Column(name = "NSRDZDAH")
    private BigDecimal nsrdzdah;

    @Column(name = "NSRSBH")
    private String nsrsbh;

    @Column(name = "ISVALID")
    private String isvalid;

    @Column(name = "CRTIME")
    private Date crtime;

    @Column(name = "UPTIME")
    private Date uptime;

    @Column(name = "TYPE")
    private String type;

    private static final long serialVersionUID = 1L;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
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
     * @return ISVALID
     */
    public String getIsvalid() {
        return isvalid;
    }

    /**
     * @param isvalid
     */
    public void setIsvalid(String isvalid) {
        this.isvalid = isvalid == null ? null : isvalid.trim();
    }

    /**
     * @return CRTIME
     */
    public Date getCrtime() {
        return crtime;
    }

    /**
     * @param crtime
     */
    public void setCrtime(Date crtime) {
        this.crtime = crtime;
    }

    /**
     * @return UPTIME
     */
    public Date getUptime() {
        return uptime;
    }

    /**
     * @param uptime
     */
    public void setUptime(Date uptime) {
        this.uptime = uptime;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", nsrdzdah=").append(nsrdzdah);
        sb.append(", nsrsbh=").append(nsrsbh);
        sb.append(", isvalid=").append(isvalid);
        sb.append(", crtime=").append(crtime);
        sb.append(", uptime=").append(uptime);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}