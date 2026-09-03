package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TJBB_LINE_ITEM")
public class TjbbLineItemModel implements Serializable {
    @Id
    @Column(name = "BBDM")
    private String bbdm;

    @Id
    @Column(name = "BBLC")
    private String bblc;

    @Column(name = "LCMC")
    private String lcmc;

    @Column(name = "SHOWORDER")
    private BigDecimal showorder;

    @Column(name = "XLSROW")
    private String xlsrow;

    @Column(name = "ALLOWUPDATE")
    private String allowupdate;

    @Column(name = "QYBJ")
    private String qybj;

    @Column(name = "HZTYPE")
    private String hztype;

    @Column(name = "HZOBJ")
    private String hzobj;

    @Column(name = "ALLOWFORMULA")
    private String allowformula;

    private static final long serialVersionUID = 1L;

    public String getAllowformula() {
        return allowformula;
    }

    public void setAllowformula(String allowformula) {
        this.allowformula = allowformula;
    }

    public String getHztype() {
        return hztype;
    }

    public void setHztype(String hztype) {
        this.hztype = hztype;
    }

    public String getHzobj() {
        return hzobj;
    }

    public void setHzobj(String hzobj) {
        this.hzobj = hzobj;
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
     * @return BBLC
     */
    public String getBblc() {
        return bblc;
    }

    /**
     * @param bblc
     */
    public void setBblc(String bblc) {
        this.bblc = bblc == null ? null : bblc.trim();
    }

    /**
     * @return LCMC
     */
    public String getLcmc() {
        return lcmc;
    }

    /**
     * @param lcmc
     */
    public void setLcmc(String lcmc) {
        this.lcmc = lcmc == null ? null : lcmc.trim();
    }

    /**
     * @return SHOWORDER
     */
    public BigDecimal getShoworder() {
        return showorder;
    }

    /**
     * @param showorder
     */
    public void setShoworder(BigDecimal showorder) {
        this.showorder = showorder;
    }

    /**
     * @return XLSROW
     */
    public String getXlsrow() {
        return xlsrow;
    }

    /**
     * @param xlsrow
     */
    public void setXlsrow(String xlsrow) {
        this.xlsrow = xlsrow == null ? null : xlsrow.trim();
    }

    /**
     * @return ALLOWUPDATE
     */
    public String getAllowupdate() {
        return allowupdate;
    }

    /**
     * @param allowupdate
     */
    public void setAllowupdate(String allowupdate) {
        this.allowupdate = allowupdate == null ? null : allowupdate.trim();
    }

    /**
     * @return QYBJ
     */
    public String getQybj() {
        return qybj;
    }

    /**
     * @param qybj
     */
    public void setQybj(String qybj) {
        this.qybj = qybj == null ? null : qybj.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", bbdm=").append(bbdm);
        sb.append(", bblc=").append(bblc);
        sb.append(", lcmc=").append(lcmc);
        sb.append(", showorder=").append(showorder);
        sb.append(", xlsrow=").append(xlsrow);
        sb.append(", allowupdate=").append(allowupdate);
        sb.append(", qybj=").append(qybj);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}