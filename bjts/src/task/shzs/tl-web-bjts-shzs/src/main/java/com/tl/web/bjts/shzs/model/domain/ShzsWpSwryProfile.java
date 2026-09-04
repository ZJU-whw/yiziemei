package com.tl.web.bjts.shzs.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "SHZS_WP_SWRY")
public class ShzsWpSwryProfile implements Serializable {
    @Id
    @Column(name = "ID")
    private BigDecimal id;

    @Column(name = "SFDM")
    private String sfdm;

    @Column(name = "SWRYMC")
    private String swrymc;

    @Column(name = "STATUS")
    private String status;

    @Column(name = "REMARK")
    private String remark;

    @Column(name = "CRTIME")
    private Date crtime;

    @Column(name = "UPTIME")
    private Date uptime;

    @Column(name = "GWXH")
    private String gwxh;

    @Column(name = "SWJGDM")
    private String swjgdm;

    @Column(name = "GWDM")
    private String gwdm;

    @Column(name = "SWRYDM")
    private String swrydm;

    @Column(name = "SFSWJGDM")
    private String sfswjgdm;

    private static final long serialVersionUID = 1L;

    /**
     * @return ID
     */
    public BigDecimal getId() {
        return id;
    }

    /**
     * @param id
     */
    public void setId(BigDecimal id) {
        this.id = id;
    }

    /**
     * @return SFDM
     */
    public String getSfdm() {
        return sfdm;
    }

    /**
     * @param sfdm
     */
    public void setSfdm(String sfdm) {
        this.sfdm = sfdm == null ? null : sfdm.trim();
    }

    /**
     * @return SWRYMC
     */
    public String getSwrymc() {
        return swrymc;
    }

    /**
     * @param swrymc
     */
    public void setSwrymc(String swrymc) {
        this.swrymc = swrymc == null ? null : swrymc.trim();
    }

    /**
     * @return STATUS
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status
     */
    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }

    /**
     * @return REMARK
     */
    public String getRemark() {
        return remark;
    }

    /**
     * @param remark
     */
    public void setRemark(String remark) {
        this.remark = remark == null ? null : remark.trim();
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

    /**
     * @return GWXH
     */
    public String getGwxh() {
        return gwxh;
    }

    /**
     * @param gwxh
     */
    public void setGwxh(String gwxh) {
        this.gwxh = gwxh == null ? null : gwxh.trim();
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
     * @return GWDM
     */
    public String getGwdm() {
        return gwdm;
    }

    /**
     * @param gwdm
     */
    public void setGwdm(String gwdm) {
        this.gwdm = gwdm == null ? null : gwdm.trim();
    }

    /**
     * @return SWRYDM
     */
    public String getSwrydm() {
        return swrydm;
    }

    /**
     * @param swrydm
     */
    public void setSwrydm(String swrydm) {
        this.swrydm = swrydm == null ? null : swrydm.trim();
    }

    /**
     * @return SFSWJGDM
     */
    public String getSfswjgdm() {
        return sfswjgdm;
    }

    /**
     * @param sfswjgdm
     */
    public void setSfswjgdm(String sfswjgdm) {
        this.sfswjgdm = sfswjgdm == null ? null : sfswjgdm.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", sfdm=").append(sfdm);
        sb.append(", swrymc=").append(swrymc);
        sb.append(", status=").append(status);
        sb.append(", remark=").append(remark);
        sb.append(", crtime=").append(crtime);
        sb.append(", uptime=").append(uptime);
        sb.append(", gwxh=").append(gwxh);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", gwdm=").append(gwdm);
        sb.append(", swrydm=").append(swrydm);
        sb.append(", sfswjgdm=").append(sfswjgdm);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}