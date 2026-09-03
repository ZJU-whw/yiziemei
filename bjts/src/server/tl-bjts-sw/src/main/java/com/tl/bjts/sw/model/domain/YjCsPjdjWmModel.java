package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_CS_QSPJDJ_WM")
public class YjCsPjdjWmModel implements Serializable {
    @Id
    @Column(name = "SPDM")
    private String spdm;

    @Column(name = "SPMC")
    private String spmc;

    @Column(name = "QNT")
    private BigDecimal qnt;

    @Column(name = "AMT")
    private BigDecimal amt;

    @Column(name = "DJ")
    private BigDecimal dj;

    private static final long serialVersionUID = 1L;

    /**
     * @return SPDM
     */
    public String getSpdm() {
        return spdm;
    }

    /**
     * @param spdm
     */
    public void setSpdm(String spdm) {
        this.spdm = spdm == null ? null : spdm.trim();
    }

    /**
     * @return SPMC
     */
    public String getSpmc() {
        return spmc;
    }

    /**
     * @param spmc
     */
    public void setSpmc(String spmc) {
        this.spmc = spmc == null ? null : spmc.trim();
    }

    /**
     * @return QNT
     */
    public BigDecimal getQnt() {
        return qnt;
    }

    /**
     * @param qnt
     */
    public void setQnt(BigDecimal qnt) {
        this.qnt = qnt;
    }

    /**
     * @return AMT
     */
    public BigDecimal getAmt() {
        return amt;
    }

    /**
     * @param amt
     */
    public void setAmt(BigDecimal amt) {
        this.amt = amt;
    }

    /**
     * @return DJ
     */
    public BigDecimal getDj() {
        return dj;
    }

    /**
     * @param dj
     */
    public void setDj(BigDecimal dj) {
        this.dj = dj;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", spdm=").append(spdm);
        sb.append(", spmc=").append(spmc);
        sb.append(", qnt=").append(qnt);
        sb.append(", amt=").append(amt);
        sb.append(", dj=").append(dj);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}