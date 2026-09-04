package com.tl.web.bjts.shzs.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_TSSH.FXNK_RULES_MX")
public class RulesMxProfile implements Serializable {
    @Id
    @Column(name = "ID")
    private BigDecimal id;

    @Column(name = "BIZ_KEY")
    private String bizKey;

    @Column(name = "PROP_PATH")
    private String propPath;

    @Column(name = "PROP_NAME")
    private String propName;

    @Column(name = "VALUE_PATH")
    private String valuePath;

    @Column(name = "IS_VALID")
    private String isValid;

    @Column(name = "CRTIME")
    private Date crtime;

    @Column(name = "UPTIME")
    private Date uptime;

    @Column(name = "PARAM_ALIAS")
    private String paramAlias;

    private static final long serialVersionUID = 1L;

    public String getParamAlias() {
        return this.paramAlias;

    }

    public void setParamAlias(String paramAlias) {
        this.paramAlias = paramAlias;
    }

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
     * @return BIZ_KEY
     */
    public String getBizKey() {
        return bizKey;
    }

    /**
     * @param bizKey
     */
    public void setBizKey(String bizKey) {
        this.bizKey = bizKey == null ? null : bizKey.trim();
    }

    /**
     * @return PROP_PATH
     */
    public String getPropPath() {
        return propPath;
    }

    /**
     * @param propPath
     */
    public void setPropPath(String propPath) {
        this.propPath = propPath == null ? null : propPath.trim();
    }

    /**
     * @return PROP_NAME
     */
    public String getPropName() {
        return propName;
    }

    /**
     * @param propName
     */
    public void setPropName(String propName) {
        this.propName = propName == null ? null : propName.trim();
    }

    /**
     * @return VALUE_PATH
     */
    public String getValuePath() {
        return valuePath;
    }

    /**
     * @param valuePath
     */
    public void setValuePath(String valuePath) {
        this.valuePath = valuePath == null ? null : valuePath.trim();
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

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", bizKey=").append(bizKey);
        sb.append(", propPath=").append(propPath);
        sb.append(", propName=").append(propName);
        sb.append(", valuePath=").append(valuePath);
        sb.append(", isValid=").append(isValid);
        sb.append(", crtime=").append(crtime);
        sb.append(", uptime=").append(uptime);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}