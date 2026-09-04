package com.tl.web.bjts.shzs.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_ADMIN.DCB_TSYCBFSLQK_LOG")
public class DcbTsycbfslqkLogProfile implements Serializable {
    @Id
    @Column(name = "ID")
    private Long id;

    @Column(name = "NSRDZDAH")
    private BigDecimal nsrdzdah;

    @Column(name = "NY")
    private String ny;

    @Column(name = "YCTSE")
    private BigDecimal yctse;

    @Column(name = "SBYWB_DM")
    private String sbywbDm;

    @Column(name = "SBNYPC")
    private String sbnypc;

    @Column(name = "SBTSE")
    private BigDecimal sbtse;

    @Column(name = "DYLJSBTSE")
    private BigDecimal dyljsbtse;

    @Column(name = "CLDZ")
    private String cldz;

    @Column(name = "YYSM")
    private String yysm;

    @Column(name = "CZYMC")
    private String czymc;

    @Column(name = "CRTIME")
    private Date crtime;

    private static final long serialVersionUID = 1L;

    /**
     * @return ID
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     */
    public void setId(Long id) {
        this.id = id;
    }

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
     * @return YCTSE
     */
    public BigDecimal getYctse() {
        return yctse;
    }

    /**
     * @param yctse
     */
    public void setYctse(BigDecimal yctse) {
        this.yctse = yctse;
    }

    /**
     * @return SBYWB_DM
     */
    public String getSbywbDm() {
        return sbywbDm;
    }

    /**
     * @param sbywbDm
     */
    public void setSbywbDm(String sbywbDm) {
        this.sbywbDm = sbywbDm == null ? null : sbywbDm.trim();
    }

    /**
     * @return SBNYPC
     */
    public String getSbnypc() {
        return sbnypc;
    }

    /**
     * @param sbnypc
     */
    public void setSbnypc(String sbnypc) {
        this.sbnypc = sbnypc == null ? null : sbnypc.trim();
    }

    /**
     * @return SBTSE
     */
    public BigDecimal getSbtse() {
        return sbtse;
    }

    /**
     * @param sbtse
     */
    public void setSbtse(BigDecimal sbtse) {
        this.sbtse = sbtse;
    }

    /**
     * @return DYLJSBTSE
     */
    public BigDecimal getDyljsbtse() {
        return dyljsbtse;
    }

    /**
     * @param dyljsbtse
     */
    public void setDyljsbtse(BigDecimal dyljsbtse) {
        this.dyljsbtse = dyljsbtse;
    }

    /**
     * @return CLDZ
     */
    public String getCldz() {
        return cldz;
    }

    /**
     * @param cldz
     */
    public void setCldz(String cldz) {
        this.cldz = cldz == null ? null : cldz.trim();
    }

    /**
     * @return YYSM
     */
    public String getYysm() {
        return yysm;
    }

    /**
     * @param yysm
     */
    public void setYysm(String yysm) {
        this.yysm = yysm == null ? null : yysm.trim();
    }

    /**
     * @return CZYMC
     */
    public String getCzymc() {
        return czymc;
    }

    /**
     * @param czymc
     */
    public void setCzymc(String czymc) {
        this.czymc = czymc == null ? null : czymc.trim();
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

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", nsrdzdah=").append(nsrdzdah);
        sb.append(", ny=").append(ny);
        sb.append(", yctse=").append(yctse);
        sb.append(", sbywbDm=").append(sbywbDm);
        sb.append(", sbnypc=").append(sbnypc);
        sb.append(", sbtse=").append(sbtse);
        sb.append(", dyljsbtse=").append(dyljsbtse);
        sb.append(", cldz=").append(cldz);
        sb.append(", yysm=").append(yysm);
        sb.append(", czymc=").append(czymc);
        sb.append(", crtime=").append(crtime);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}