package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "SYS_CFG_ROLE_SERVICE")
public class TlRoleServiceProfile implements Serializable {
    @Id
    @Column(name = "ID")
    private Long id;

    @Column(name = "ROLE_DM")
    private String roleDm;

    @Column(name = "SERVICE_DM")
    private String serviceDm;

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
        sb.append(", roleDm=").append(roleDm);
        sb.append(", serviceDm=").append(serviceDm);
        sb.append(", crtime=").append(crtime);
        sb.append(", crname=").append(crname);
        sb.append(", uptime=").append(uptime);
        sb.append(", upname=").append(upname);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}