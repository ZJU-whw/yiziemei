package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TJBB_REPORT_FORMULA")
public class TjbbReportFormula implements Serializable {
    @Id
    @Column(name = "ID")
    private BigDecimal id;

    @Column(name = "BBDM")
    private String bbdm;

    @Column(name = "TYPE")
    private String type;

    @Column(name = "FORMULA")
    private String formula;

    @Column(name = "YXJ")
    private BigDecimal yxj;

    @Column(name = "QYBZ")
    private String qybz;

    @Column(name = "ISHZJS")
    private String ishzjs;

    private static final long serialVersionUID = 1L;

    public String getIshzjs() {
        return ishzjs;
    }

    public void setIshzjs(String ishzjs) {
        this.ishzjs = ishzjs;
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
     * @return TYPE
     */
    public String getType() {
        return type;
    }

    /**
     * @param type
     */
    public void setType(String type) {
        this.type = type == null ? null : type.trim();
    }

    /**
     * @return FORMULA
     */
    public String getFormula() {
        return formula;
    }

    /**
     * @param formula
     */
    public void setFormula(String formula) {
        this.formula = formula == null ? null : formula.trim();
    }

    /**
     * @return YXJ
     */
    public BigDecimal getYxj() {
        return yxj;
    }

    /**
     * @param yxj
     */
    public void setYxj(BigDecimal yxj) {
        this.yxj = yxj;
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
        sb.append(", id=").append(id);
        sb.append(", bbdm=").append(bbdm);
        sb.append(", type=").append(type);
        sb.append(", formula=").append(formula);
        sb.append(", yxj=").append(yxj);
        sb.append(", qybz=").append(qybz);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}