package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "DM_SERVICE")
public class TlServiceProfile implements Serializable {
    @Id
    @Column(name = "SERVICE_DM")
    private String serviceDm;

    @Column(name = "SERVICE_MC")
    private String serviceMc;

    @Column(name = "DESCRIPTION")
    private String description;

    @Column(name = "MENU_SET")
    private String menuSet;

    @Column(name = "CRTIME")
    private Date crtime;

    @Column(name = "CRNAME")
    private String crname;

    @Column(name = "UPTIME")
    private Date uptime;

    @Column(name = "UPNAME")
    private String upname;

    @Column(name = "QYBZ")
    private String qybz;

    private static final long serialVersionUID = 1L;

    /**
     * @return SERVICE_DM
     */
    public String getServiceDm() {
        return serviceDm;
    }

    /**
     * @param serviceDm
     */
    public void setServiceDm(String serviceDm) {
        this.serviceDm = serviceDm == null ? null : serviceDm.trim();
    }

    /**
     * @return SERVICE_MC
     */
    public String getServiceMc() {
        return serviceMc;
    }

    /**
     * @param serviceMc
     */
    public void setServiceMc(String serviceMc) {
        this.serviceMc = serviceMc == null ? null : serviceMc.trim();
    }

    /**
     * @return DESCRIPTION
     */
    public String getDescription() {
        return description;
    }

    /**
     * @param description
     */
    public void setDescription(String description) {
        this.description = description == null ? null : description.trim();
    }

    /**
     * @return MENU_SET
     */
    public String getMenuSet() {
        return menuSet;
    }

    /**
     * @param menuSet
     */
    public void setMenuSet(String menuSet) {
        this.menuSet = menuSet == null ? null : menuSet.trim();
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
     * @return CRNAME
     */
    public String getCrname() {
        return crname;
    }

    /**
     * @param crname
     */
    public void setCrname(String crname) {
        this.crname = crname == null ? null : crname.trim();
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

    /**
     * @return UPNAME
     */
    public String getUpname() {
        return upname;
    }

    /**
     * @param upname
     */
    public void setUpname(String upname) {
        this.upname = upname == null ? null : upname.trim();
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
        sb.append(", serviceDm=").append(serviceDm);
        sb.append(", serviceMc=").append(serviceMc);
        sb.append(", description=").append(description);
        sb.append(", menuSet=").append(menuSet);
        sb.append(", crtime=").append(crtime);
        sb.append(", crname=").append(crname);
        sb.append(", uptime=").append(uptime);
        sb.append(", upname=").append(upname);
        sb.append(", qybz=").append(qybz);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}