package com.tl.web.bjts.yj.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "tl_admin.YJ_DATA_HIS_SBSJ_CKKA")
public class YjHisCkkaModel implements Serializable {
    @Id
    @Column(name = "NSRDZDAH")
    private BigDecimal nsrdzdah;

    @Id
    @Column(name = "SBYMPC")
    private String sbympc;

    @Id
    @Column(name = "OBJECT")
    private String object;

    @Column(name = "NY")
    private String ny;

    @Column(name = "AMT")
    private BigDecimal amt;

    @Column(name = "TSE")
    private BigDecimal tse;

    private static final long serialVersionUID = 1L;

    /**
     * @return NSRDZDAH
     */
    public BigDecimal getNsrdzdah() {
        return nsrdzdah;
    }

    /**
     * @param nsrdzdah
     */
    public void setNsrdzdah(BigDecimal nsrdzdah) {
        this.nsrdzdah = nsrdzdah;
    }

    /**
     * @return SBYMPC
     */
    public String getSbympc() {
        return sbympc;
    }

    /**
     * @param sbympc
     */
    public void setSbympc(String sbympc) {
        this.sbympc = sbympc == null ? null : sbympc.trim();
    }

    /**
     * @return OBJECT
     */
    public String getObject() {
        return object;
    }

    /**
     * @param object
     */
    public void setObject(String object) {
        this.object = object == null ? null : object.trim();
    }

    /**
     * @return NY
     */
    public String getNy() {
        return ny;
    }

    /**
     * @param ny
     */
    public void setNy(String ny) {
        this.ny = ny == null ? null : ny.trim();
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
     * @return TSE
     */
    public BigDecimal getTse() {
        return tse;
    }

    /**
     * @param tse
     */
    public void setTse(BigDecimal tse) {
        this.tse = tse;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", nsrdzdah=").append(nsrdzdah);
        sb.append(", sbympc=").append(sbympc);
        sb.append(", object=").append(object);
        sb.append(", ny=").append(ny);
        sb.append(", amt=").append(amt);
        sb.append(", tse=").append(tse);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}