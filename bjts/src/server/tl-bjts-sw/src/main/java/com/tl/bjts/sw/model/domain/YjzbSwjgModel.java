package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_DIC_YJZBSWJG")
public class YjzbSwjgModel implements Serializable {
    @Id
    @Column(name = "SWJGDM")
    private String swjgdm;

    @Id
    @Column(name = "ZBCODE")
    private String zbcode;

    @Column(name = "P1VAL")
    private BigDecimal p1val;

    @Column(name = "P2VAL")
    private BigDecimal p2val;

    @Column(name = "P3VAL")
    private BigDecimal p3val;

    @Column(name = "P4VAL")
    private BigDecimal p4val;

    @Column(name = "SCORE")
    private Integer score;

    @Column(name = "YXBZ")
    private String yxbz;

    private static final long serialVersionUID = 1L;

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
     * @return ZBCODE
     */
    public String getZbcode() {
        return zbcode;
    }

    /**
     * @param zbcode
     */
    public void setZbcode(String zbcode) {
        this.zbcode = zbcode == null ? null : zbcode.trim();
    }

    /**
     * @return P1VAL
     */
    public BigDecimal getP1val() {
        return p1val;
    }

    /**
     * @param p1val
     */
    public void setP1val(BigDecimal p1val) {
        this.p1val = p1val;
    }

    /**
     * @return P2VAL
     */
    public BigDecimal getP2val() {
        return p2val;
    }

    /**
     * @param p2val
     */
    public void setP2val(BigDecimal p2val) {
        this.p2val = p2val;
    }

    /**
     * @return P3VAL
     */
    public BigDecimal getP3val() {
        return p3val;
    }

    /**
     * @param p3val
     */
    public void setP3val(BigDecimal p3val) {
        this.p3val = p3val;
    }

    /**
     * @return P4VAL
     */
    public BigDecimal getP4val() {
        return p4val;
    }
    /**
     * @param p4val
     */
    public void setP4val(BigDecimal p4val) {
        this.p4val = p4val;
    }

    /**
     * @return SCORE
     */
    public Integer getScore() {
        return score;
    }

    /**
     * @param score
     */
    public void setScore(Integer score) {
        this.score = score;
    }

    /**
     * @return YXBZ
     */
    public String getYxbz() {
        return yxbz;
    }

    /**
     * @param yxbz
     */
    public void setYxbz(String yxbz) {
        this.yxbz = yxbz == null ? null : yxbz.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", zbcode=").append(zbcode);
        sb.append(", p1val=").append(p1val);
        sb.append(", p2val=").append(p2val);
        sb.append(", score=").append(score);
        sb.append(", yxbz=").append(yxbz);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}