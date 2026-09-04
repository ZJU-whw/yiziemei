package com.tl.web.bjts.shzs.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TL_TSSH.FXNK_RULES_MAIN")
public class RulesMainProfile implements Serializable {
    @Id
    @Column(name = "ID")
    private BigDecimal id;

    @Column(name = "BIZ_KEY")
    private String bizKey;

    @Column(name = "BIZ_DESC")
    private String bizDesc;

    @Column(name = "BIZ_PATH")
    private String bizPath;

    @Column(name = "IS_VALID")
    private String isValid;

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
     * @return BIZ_DESC
     */
    public String getBizDesc() {
        return bizDesc;
    }

    /**
     * @param bizDesc
     */
    public void setBizDesc(String bizDesc) {
        this.bizDesc = bizDesc == null ? null : bizDesc.trim();
    }

    /**
     * @return BIZ_PATH
     */
    public String getBizPath() {
        return bizPath;
    }

    /**
     * @param bizPath
     */
    public void setBizPath(String bizPath) {
        this.bizPath = bizPath == null ? null : bizPath.trim();
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

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", bizKey=").append(bizKey);
        sb.append(", bizDesc=").append(bizDesc);
        sb.append(", bizPath=").append(bizPath);
        sb.append(", isValid=").append(isValid);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}