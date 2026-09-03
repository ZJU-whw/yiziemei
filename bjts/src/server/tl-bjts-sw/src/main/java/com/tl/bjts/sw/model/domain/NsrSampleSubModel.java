package com.tl.bjts.sw.model.domain;

import com.tl.common.ext.annotation.ExcelSetting;
import com.tl.common.ext.annotation.MaxLength;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TL_TSSH.JCFX_NSR_SAMPLE_SUB")
public class NsrSampleSubModel implements Serializable {
    @Id
    @Column(name = "ID")
    private Long id;

    @Column(name = "ZID")
    private Long zid;


    @ExcelSetting(colTitleName = "纳税人识别号（必填）")
    @Column(name = "NSRSBH")
    private String nsrsbh;

    @ExcelSetting(colTitleName = "纳税人名称")
    @Column(name = "NSRMC")
    private String nsrmc;

    @Column(name = "QYBZ")
    private String qybz;

    @Column(name = "DJXH")
    private BigDecimal djxh;

    private static final long serialVersionUID = 1L;

    public BigDecimal getDjxh() {
        return this.djxh;

    }

    public void setDjxh(BigDecimal djxh) {
        this.djxh = djxh;
    }

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
     * @return ZID
     */
    public Long getZid() {
        return zid;
    }

    /**
     * @param zid
     */
    public void setZid(Long zid) {
        this.zid = zid;
    }

    /**
     * @return NSRSBH
     */
    public String getNsrsbh() {
        return nsrsbh;
    }

    /**
     * @param nsrsbh
     */
    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh == null ? null : nsrsbh.trim();
    }

    /**
     * @return NSRMC
     */
    public String getNsrmc() {
        return nsrmc;
    }

    /**
     * @param nsrmc
     */
    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc == null ? null : nsrmc.trim();
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
        sb.append(", zid=").append(zid);
        sb.append(", nsrsbh=").append(nsrsbh);
        sb.append(", nsrmc=").append(nsrmc);
        sb.append(", qybz=").append(qybz);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}