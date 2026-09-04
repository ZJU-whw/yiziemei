package com.tl.web.bjts.shzs.model.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.ExcelSetting;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "SHZS_WP_TASK")
public class ShzsWpTaskProfile implements Serializable {
    @Id
    @Column(name = "ID")
    private String id;

    @Column(name = "SWJGDM")
    private String swjgdm;

    @Column(name = "SSQPC")
    private String ssqpc;

    @ExcelSetting(colTitleName = "委派时间")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @Column(name = "WPSJ")
    private Date wpsj;

    @ExcelSetting(colTitleName = "委派对象代码")
    @Column(name = "WPSFDM")
    private String wpsfdm;

    @ExcelSetting(colTitleName = "委派对象名称")
    @Column(name = "WPDX")
    private String wpdx;

    @ExcelSetting(colTitleName = "状态")
    @Column(name = "STATUS")
    private String status;

    @ExcelSetting(colTitleName = "委派结果")
    @Column(name = "WPJG")
    private String wpjg;

    @ExcelSetting(colTitleName = "纳税人识别号")
    @Column(name = "NSRSBH")
    private String nsrsbh;

    @ExcelSetting(colTitleName = "纳税人名称")
    @Column(name = "NSRMC")
    private String nsrmc;

    @ExcelSetting(colTitleName = "税务事项代码")
    @Column(name = "SWSXDM")
    private String swsxdm;

    @ExcelSetting(colTitleName = "申报日期")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @Column(name = "SBRQ")
    private Date sbrq;

    @ExcelSetting(colTitleName = "接单方式")
    @Column(name = "JDMODE")
    private String jdmode;

    @ExcelSetting(colTitleName = "企业分组")
    @Column(name = "WPDXQYFZ")
    private String wpdxqyfz;

    @ExcelSetting(colTitleName = "委派人")
    @Column(name = "WPR")
    private String wpr;

    @ExcelSetting(colTitleName = "流程实例ID")
    @Column(name = "LCSLID")
    private String lcslid;

    private static final long serialVersionUID = 1L;

    public String getStatus() {
        return this.status;

    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getId() {
        return this.id;

    }

    public void setId(String id) {
        this.id = id;
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
     * @return SWSXDM
     */
    public String getSwsxdm() {
        return swsxdm;
    }

    /**
     * @param swsxdm
     */
    public void setSwsxdm(String swsxdm) {
        this.swsxdm = swsxdm == null ? null : swsxdm.trim();
    }

    /**
     * @return SSQPC
     */
    public String getSsqpc() {
        return ssqpc;
    }

    /**
     * @param ssqpc
     */
    public void setSsqpc(String ssqpc) {
        this.ssqpc = ssqpc == null ? null : ssqpc.trim();
    }

    /**
     * @return SBRQ
     */
    public Date getSbrq() {
        return sbrq;
    }

    /**
     * @param sbrq
     */
    public void setSbrq(Date sbrq) {
        this.sbrq = sbrq;
    }

    /**
     * @return WPSJ
     */
    public Date getWpsj() {
        return wpsj;
    }

    /**
     * @param wpsj
     */
    public void setWpsj(Date wpsj) {
        this.wpsj = wpsj;
    }

    /**
     * @return WPSFDM
     */
    public String getWpsfdm() {
        return wpsfdm;
    }

    /**
     * @param wpsfdm
     */
    public void setWpsfdm(String wpsfdm) {
        this.wpsfdm = wpsfdm == null ? null : wpsfdm.trim();
    }

    /**
     * @return WPDX
     */
    public String getWpdx() {
        return wpdx;
    }

    /**
     * @param wpdx
     */
    public void setWpdx(String wpdx) {
        this.wpdx = wpdx == null ? null : wpdx.trim();
    }

    /**
     * @return WPJG
     */
    public String getWpjg() {
        return wpjg;
    }

    /**
     * @param wpjg
     */
    public void setWpjg(String wpjg) {
        this.wpjg = wpjg == null ? null : wpjg.trim();
    }

    /**
     * @return WPR
     */
    public String getWpr() {
        return wpr;
    }

    /**
     * @param wpr
     */
    public void setWpr(String wpr) {
        this.wpr = wpr == null ? null : wpr.trim();
    }

    /**
     * @return WPDXQYFZ
     */
    public String getWpdxqyfz() {
        return wpdxqyfz;
    }

    /**
     * @param wpdxqyfz
     */
    public void setWpdxqyfz(String wpdxqyfz) {
        this.wpdxqyfz = wpdxqyfz == null ? null : wpdxqyfz.trim();
    }

    /**
     * @return LCSLID
     */
    public String getLcslid() {
        return lcslid;
    }

    /**
     * @param lcslid
     */
    public void setLcslid(String lcslid) {
        this.lcslid = lcslid == null ? null : lcslid.trim();
    }

    /**
     * @return JDMODE
     */
    public String getJdmode() {
        return jdmode;
    }

    /**
     * @param jdmode
     */
    public void setJdmode(String jdmode) {
        this.jdmode = jdmode == null ? null : jdmode.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", nsrsbh=").append(nsrsbh);
        sb.append(", nsrmc=").append(nsrmc);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", swsxdm=").append(swsxdm);
        sb.append(", ssqpc=").append(ssqpc);
        sb.append(", sbrq=").append(sbrq);
        sb.append(", wpsj=").append(wpsj);
        sb.append(", wpsfdm=").append(wpsfdm);
        sb.append(", wpdx=").append(wpdx);
        sb.append(", wpjg=").append(wpjg);
        sb.append(", wpr=").append(wpr);
        sb.append(", wpdxqyfz=").append(wpdxqyfz);
        sb.append(", lcslid=").append(lcslid);
        sb.append(", jdmode=").append(jdmode);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}