package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TJBB_REPORT_DYNAMIC")
public class TjbbReportDynamic implements Serializable {
    @Id
    @Column(name = "BBDM")
    private String bbdm;

    @Id
    @Column(name = "LOCATION")
    private String location;

    @Column(name = "BBLC_NAME")
    private String bblcName;

    @Column(name = "COLUMN_TITLE")
    private String columnTitle;

    @Column(name = "SQL_SCRIPT")
    private String sqlScript;

    @Column(name = "IS_VALID")
    private String isValid;

    @Column(name = "CRTIME")
    private Date crtime;

    @Column(name = "UPTIME")
    private Date uptime;

    @Column(name = "DB_TARGET")
    private String dbTarget;

    @Column(name = "REMARK")
    private String remark;

    private static final long serialVersionUID = 1L;

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
     * @return LOCATION
     */
    public String getLocation() {
        return location;
    }

    /**
     * @param location
     */
    public void setLocation(String location) {
        this.location = location == null ? null : location.trim();
    }

    /**
     * @return BBLC_NAME
     */
    public String getBblcName() {
        return bblcName;
    }

    /**
     * @param bblcName
     */
    public void setBblcName(String bblcName) {
        this.bblcName = bblcName == null ? null : bblcName.trim();
    }

    /**
     * @return COLUMN_TITLE
     */
    public String getColumnTitle() {
        return columnTitle;
    }

    /**
     * @param columnTitle
     */
    public void setColumnTitle(String columnTitle) {
        this.columnTitle = columnTitle == null ? null : columnTitle.trim();
    }

    /**
     * @return SQL_SCRIPT
     */
    public String getSqlScript() {
        return sqlScript;
    }

    /**
     * @param sqlScript
     */
    public void setSqlScript(String sqlScript) {
        this.sqlScript = sqlScript == null ? null : sqlScript.trim();
    }

    /**
     * @return IS_VALID
     */
    public String getIsValid() {
        return isValid;
    }

    /**
     * @param isValid
     */
    public void setIsValid(String isValid) {
        this.isValid = isValid == null ? null : isValid.trim();
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
     * @return DB_TARGET
     */
    public String getDbTarget() {
        return dbTarget;
    }

    /**
     * @param dbTarget
     */
    public void setDbTarget(String dbTarget) {
        this.dbTarget = dbTarget == null ? null : dbTarget.trim();
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

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", bbdm=").append(bbdm);
        sb.append(", location=").append(location);
        sb.append(", bblcName=").append(bblcName);
        sb.append(", columnTitle=").append(columnTitle);
        sb.append(", sqlScript=").append(sqlScript);
        sb.append(", isValid=").append(isValid);
        sb.append(", crtime=").append(crtime);
        sb.append(", uptime=").append(uptime);
        sb.append(", dbTarget=").append(dbTarget);
        sb.append(", remark=").append(remark);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}