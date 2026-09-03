package com.tl.bjts.sw.model.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.tl.common.ext.annotation.MaxLength;
import com.tl.common.ext.annotation.ExcelSetting;
import com.tl.common.ext.annotation.NotEmpty;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_CS_BMD")
public class YjCsBmdModel implements Serializable {
    @Id
    @Column(name = "ID")
    @JsonIgnore
    private Long id;

    @Column(name = "SWJGDM")
    private String swjgdm;
//    @NotEmpty(msg="【企业标识】不能为空")
    @Column(name = "NSRDZDAH")
    private BigDecimal nsrdzdah;
    @NotEmpty(msg="预警代码不能为空")
    @Column(name = "YJCODE")
    @ExcelSetting(colTitleName = "预警代码", nextColName = "yjname")
    private String yjcode;

    @NotEmpty(msg="白名单类型不能为空")
    @Column(name = "OBJFLAG")
    @ExcelSetting(colTitleName = "白名单类型", nextColName = "swjgmc")
    private String objflag;

    @Column(name = "YYMS")
    @MaxLength( length = 255 ,msg="【原因描述】最多不能超过255个字符")
    @ExcelSetting(colTitleName = "原因描述")
    private String yyms;

    @Column(name = "YXBZ")
    private String yxbz;

    @Column(name = "LRR")
    private String lrr;

    @Column(name = "LRRQ")
    private Date lrrq;

    @Column(name = "XGR")
    private String xgr;

    @Column(name = "XGRQ")
    private Date xgrq;

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
     * @return YJCODE
     */
    public String getYjcode() {
        return yjcode;
    }

    /**
     * @param yjcode
     */
    public void setYjcode(String yjcode) {
        this.yjcode = yjcode == null ? null : yjcode.trim();
    }

    /**
     * @return OBJFLAG
     */
    public String getObjflag() {
        return objflag;
    }

    /**
     * @param objflag
     */
    public void setObjflag(String objflag) {
        this.objflag = objflag == null ? null : objflag.trim();
    }

    /**
     * @return YYMS
     */
    public String getYyms() {
        return yyms;
    }

    /**
     * @param yyms
     */
    public void setYyms(String yyms) {
        this.yyms = yyms == null ? null : yyms.trim();
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

    /**
     * @return LRR
     */
    public String getLrr() {
        return lrr;
    }

    /**
     * @param lrr
     */
    public void setLrr(String lrr) {
        this.lrr = lrr == null ? null : lrr.trim();
    }

    /**
     * @return LRRQ
     */
    public Date getLrrq() {
        return lrrq;
    }

    /**
     * @param lrrq
     */
    public void setLrrq(Date lrrq) {
        this.lrrq = lrrq;
    }

    /**
     * @return XGR
     */
    public String getXgr() {
        return xgr;
    }

    /**
     * @param xgr
     */
    public void setXgr(String xgr) {
        this.xgr = xgr == null ? null : xgr.trim();
    }

    /**
     * @return XGRQ
     */
    public Date getXgrq() {
        return xgrq;
    }

    /**
     * @param xgrq
     */
    public void setXgrq(Date xgrq) {
        this.xgrq = xgrq;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", nsrdzdah=").append(nsrdzdah);
        sb.append(", yjcode=").append(yjcode);
        sb.append(", objflag=").append(objflag);
        sb.append(", yyms=").append(yyms);
        sb.append(", yxbz=").append(yxbz);
        sb.append(", lrr=").append(lrr);
        sb.append(", lrrq=").append(lrrq);
        sb.append(", xgr=").append(xgr);
        sb.append(", xgrq=").append(xgrq);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}