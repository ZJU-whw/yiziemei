package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "TL_ADMIN.DM_DQCODE")
public class DqModel implements Serializable {
    @Id
    @Column(name = "DQ_CODE")
    private String dqCode;

    @Column(name = "DQ_NAME")
    private String dqName;

    @Column(name = "DQ_ENAME")
    private String dqEname;

    @Column(name = "DQ_TYPE")
    private String dqType;

    private static final long serialVersionUID = 1L;

    /**
     * @return DQ_CODE
     */
    public String getDqCode() {
        return dqCode;
    }

    /**
     * @param dqCode
     */
    public void setDqCode(String dqCode) {
        this.dqCode = dqCode == null ? null : dqCode.trim();
    }

    /**
     * @return DQ_NAME
     */
    public String getDqName() {
        return dqName;
    }

    /**
     * @param dqName
     */
    public void setDqName(String dqName) {
        this.dqName = dqName == null ? null : dqName.trim();
    }

    /**
     * @return DQ_ENAME
     */
    public String getDqEname() {
        return dqEname;
    }

    /**
     * @param dqEname
     */
    public void setDqEname(String dqEname) {
        this.dqEname = dqEname == null ? null : dqEname.trim();
    }

    /**
     * @return DQ_TYPE
     */
    public String getDqType() {
        return dqType;
    }

    /**
     * @param dqType
     */
    public void setDqType(String dqType) {
        this.dqType = dqType == null ? null : dqType.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", dqCode=").append(dqCode);
        sb.append(", dqName=").append(dqName);
        sb.append(", dqEname=").append(dqEname);
        sb.append(", dqType=").append(dqType);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}