package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "DM_CZRY")
public class TlUserProfile implements Serializable {
    @Id
    @Column(name = "CZRY_DM")
    private String czryDm;

    @Column(name = "CZRY_MC")
    private String czryMc;

    @Column(name = "PASSWORD")
    private String password;

    @Column(name = "SWJG_DM")
    private String swjgDm;

    @Column(name = "CZRY_DM_ZG")
    private String czryDmZg;

    @Column(name = "YHLX")
    private String yhlx;

    @Column(name = "USRSTATE")
    private String usrstate;

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

    @Column(name = "LXDH")
    private String lxdh;

    @Column(name = "QX_SWJG")
    private String qxSwjg;

    private static final long serialVersionUID = 1L;

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
     * @return CZRY_MC
     */
    public String getCzryMc() {
        return czryMc;
    }

    /**
     * @param czryMc
     */
    public void setCzryMc(String czryMc) {
        this.czryMc = czryMc == null ? null : czryMc.trim();
    }

    /**
     * @return PASSWORD
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param password
     */
    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }

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
     * @return CZRY_DM_ZG
     */
    public String getCzryDmZg() {
        return czryDmZg;
    }

    /**
     * @param czryDmZg
     */
    public void setCzryDmZg(String czryDmZg) {
        this.czryDmZg = czryDmZg == null ? null : czryDmZg.trim();
    }

    /**
     * @return YHLX
     */
    public String getYhlx() {
        return yhlx;
    }

    /**
     * @param yhlx
     */
    public void setYhlx(String yhlx) {
        this.yhlx = yhlx == null ? null : yhlx.trim();
    }

    /**
     * @return USRSTATE
     */
    public String getUsrstate() {
        return usrstate;
    }

    /**
     * @param usrstate
     */
    public void setUsrstate(String usrstate) {
        this.usrstate = usrstate == null ? null : usrstate.trim();
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

    /**
     * @return LXDH
     */
    public String getLxdh() {
        return lxdh;
    }

    /**
     * @param lxdh
     */
    public void setLxdh(String lxdh) {
        this.lxdh = lxdh == null ? null : lxdh.trim();
    }

    /**
     * @return QX_SWJG
     */
    public String getQxSwjg() {
        return qxSwjg;
    }

    /**
     * @param qxSwjg
     */
    public void setQxSwjg(String qxSwjg) {
        this.qxSwjg = qxSwjg == null ? null : qxSwjg.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", czryDm=").append(czryDm);
        sb.append(", czryMc=").append(czryMc);
        sb.append(", password=").append(password);
        sb.append(", swjgDm=").append(swjgDm);
        sb.append(", czryDmZg=").append(czryDmZg);
        sb.append(", yhlx=").append(yhlx);
        sb.append(", usrstate=").append(usrstate);
        sb.append(", description=").append(description);
        sb.append(", crtime=").append(crtime);
        sb.append(", crname=").append(crname);
        sb.append(", uptime=").append(uptime);
        sb.append(", upname=").append(upname);
        sb.append(", qybz=").append(qybz);
        sb.append(", lxdh=").append(lxdh);
        sb.append(", qxSwjg=").append(qxSwjg);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}