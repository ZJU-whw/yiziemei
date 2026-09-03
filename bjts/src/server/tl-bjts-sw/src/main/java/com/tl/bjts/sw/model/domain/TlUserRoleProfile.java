package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "SYS_CFG_CZRY_ROLE")
public class TlUserRoleProfile implements Serializable {
    @Id
    @Column(name = "ID")
    private Long id;

    @Column(name = "CZRY_DM")
    private String czryDm;

    @Column(name = "ROLE_DM")
    private String roleDm;

    @Column(name = "CRTIME")
    private Date crtime;

    @Column(name = "CRNAME")
    private String crname;

    @Column(name = "UPTIME")
    private Date uptime;

    @Column(name = "UPNAME")
    private String upname;

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
     * @return CZRY_DM
     */
    public String getCzryDm() {
        return czryDm;
    }

    /**
     * @param czryDm
     */
    public void setCzryDm(String czryDm) {
        this.czryDm = czryDm == null ? null : czryDm.trim();
    }

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

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", czryDm=").append(czryDm);
        sb.append(", roleDm=").append(roleDm);
        sb.append(", crtime=").append(crtime);
        sb.append(", crname=").append(crname);
        sb.append(", uptime=").append(uptime);
        sb.append(", upname=").append(upname);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}