package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "DM_ROLE")
public class TlRoleProfile implements Serializable {
    @Id
    @Column(name = "ROLE_DM")
    private String roleDm;

    @Column(name = "ROLE_MC")
    private String roleMc;

    @Column(name = "DESCRIPTION")
    private String description;

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
     * @return ROLE_DM
     */
    public String getRoleDm() {
        return roleDm;
    }

    /**
     * @param roleDm
     */
    public void setRoleDm(String roleDm) {
        this.roleDm = roleDm == null ? null : roleDm.trim();
    }

    /**
     * @return ROLE_MC
     */
    public String getRoleMc() {
        return roleMc;
    }

    /**
     * @param roleMc
     */
    public void setRoleMc(String roleMc) {
        this.roleMc = roleMc == null ? null : roleMc.trim();
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
        sb.append(", roleDm=").append(roleDm);
        sb.append(", roleMc=").append(roleMc);
        sb.append(", description=").append(description);
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