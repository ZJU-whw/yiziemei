package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TL_TSSH.SYS_PARAM")
public class SysParamModel implements Serializable {
    @Id
    @Column(name = "ID")
    private BigDecimal id;

    @Column(name = "DCODE")
    private String dcode;

    @Column(name = "DVALUE")
    private String dvalue;

    @Column(name = "DTYPE")
    private String dtype;

    @Column(name = "REMARK")
    private String remark;

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
     * @return DCODE
     */
    public String getDcode() {
        return dcode;
    }

    /**
     * @param dcode
     */
    public void setDcode(String dcode) {
        this.dcode = dcode == null ? null : dcode.trim();
    }

    /**
     * @return DVALUE
     */
    public String getDvalue() {
        return dvalue;
    }

    /**
     * @param dvalue
     */
    public void setDvalue(String dvalue) {
        this.dvalue = dvalue == null ? null : dvalue.trim();
    }

    /**
     * @return DTYPE
     */
    public String getDtype() {
        return dtype;
    }

    /**
     * @param dtype
     */
    public void setDtype(String dtype) {
        this.dtype = dtype == null ? null : dtype.trim();
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
        sb.append(", id=").append(id);
        sb.append(", dcode=").append(dcode);
        sb.append(", dvalue=").append(dvalue);
        sb.append(", dtype=").append(dtype);
        sb.append(", remark=").append(remark);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}