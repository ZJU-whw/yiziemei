package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TJBB_REPORT_LIST")
public class TjbbReportModel implements Serializable {
    @Id
    @Column(name = "BBDM")
    private String bbdm;

    @Column(name = "BBDLDM")
    private String bbdldm;

    @Column(name = "BBMC")
    private String bbmc;

    @Column(name = "BBJC")
    private String bbjc;

    @Column(name = "FNAME")
    private String fname;

    @Column(name = "SPPY")
    private BigDecimal sppy;

    @Column(name = "CZPY")
    private BigDecimal czpy;

    @Column(name = "SFBL")
    private BigDecimal sfbl;

    @Column(name = "CLASSHZ")
    private String classhz;

    @Column(name = "CLASSCX")
    private String classcx;

    @Column(name = "CLASSSB")
    private String classsb;

    @Column(name = "CLASSZF")
    private String classzf;

    @Column(name = "SHOWORDER")
    private BigDecimal showorder;

    @Column(name = "BBTYPE")
    private String bbtype;

    @Column(name = "QYBJ")
    private String qybj;

    @Column(name = "NOTE")
    private String note;

    @Column(name = "EXCELCOL")
    private BigDecimal excelcol;

    @Column(name = "EXCELROW")
    private BigDecimal excelrow;

    @Column(name = "HEADCOL")
    private BigDecimal headcol;

    @Column(name = "HEADROW")
    private BigDecimal headrow;

    @Column(name = "HZTYPE")
    private String hztype;

    @Column(name = "SWJGMCTYPE")
    private String swjgmctype;

    @Column(name = "ENDCOL")
    private BigDecimal endcol;

    @Column(name = "ENDROW")
    private BigDecimal endrow;

    @Column(name = "PROC")
    private String proc;

    @Column(name = "PROCHZ")
    private String prochz;

    private static final long serialVersionUID = 1L;

    public String getProchz() {
        return prochz;
    }

    public void setProchz(String prochz) {
        this.prochz = prochz;
    }

    public String getProc() {
        return proc;
    }

    public void setProc(String proc) {
        this.proc = proc;
    }

    public BigDecimal getEndcol() {
        return endcol;
    }

    public void setEndcol(BigDecimal endcol) {
        this.endcol = endcol;
    }

    public BigDecimal getEndrow() {
        return endrow;
    }

    public void setEndrow(BigDecimal endrow) {
        this.endrow = endrow;
    }

    public String getSwjgmctype() {
        return swjgmctype;
    }

    public void setSwjgmctype(String swjgmctype) {
        this.swjgmctype = swjgmctype;
    }

    public String getHztype() {
        return hztype;
    }

    public void setHztype(String hztype) {
        this.hztype = hztype;
    }

    public BigDecimal getHeadcol() {
        return headcol;
    }

    public void setHeadcol(BigDecimal headcol) {
        this.headcol = headcol;
    }

    public BigDecimal getHeadrow() {
        return headrow;
    }

    public void setHeadrow(BigDecimal headrow) {
        this.headrow = headrow;
    }

    public BigDecimal getExcelcol() {
        return excelcol;
    }

    public void setExcelcol(BigDecimal excelcol) {
        this.excelcol = excelcol;
    }

    public BigDecimal getExcelrow() {
        return excelrow;
    }

    public void setExcelrow(BigDecimal excelrow) {
        this.excelrow = excelrow;
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
     * @return BBDLDM
     */
    public String getBbdldm() {
        return bbdldm;
    }

    /**
     * @param bbdldm
     */
    public void setBbdldm(String bbdldm) {
        this.bbdldm = bbdldm == null ? null : bbdldm.trim();
    }

    /**
     * @return BBMC
     */
    public String getBbmc() {
        return bbmc;
    }

    /**
     * @param bbmc
     */
    public void setBbmc(String bbmc) {
        this.bbmc = bbmc == null ? null : bbmc.trim();
    }

    /**
     * @return BBJC
     */
    public String getBbjc() {
        return bbjc;
    }

    /**
     * @param bbjc
     */
    public void setBbjc(String bbjc) {
        this.bbjc = bbjc == null ? null : bbjc.trim();
    }

    /**
     * @return FNAME
     */
    public String getFname() {
        return fname;
    }

    /**
     * @param fname
     */
    public void setFname(String fname) {
        this.fname = fname == null ? null : fname.trim();
    }

    /**
     * @return SPPY
     */
    public BigDecimal getSppy() {
        return sppy;
    }

    /**
     * @param sppy
     */
    public void setSppy(BigDecimal sppy) {
        this.sppy = sppy;
    }

    /**
     * @return CZPY
     */
    public BigDecimal getCzpy() {
        return czpy;
    }

    /**
     * @param czpy
     */
    public void setCzpy(BigDecimal czpy) {
        this.czpy = czpy;
    }

    /**
     * @return SFBL
     */
    public BigDecimal getSfbl() {
        return sfbl;
    }

    /**
     * @param sfbl
     */
    public void setSfbl(BigDecimal sfbl) {
        this.sfbl = sfbl;
    }

    /**
     * @return CLASSHZ
     */
    public String getClasshz() {
        return classhz;
    }

    /**
     * @param classhz
     */
    public void setClasshz(String classhz) {
        this.classhz = classhz == null ? null : classhz.trim();
    }

    /**
     * @return CLASSCX
     */
    public String getClasscx() {
        return classcx;
    }

    /**
     * @param classcx
     */
    public void setClasscx(String classcx) {
        this.classcx = classcx == null ? null : classcx.trim();
    }

    /**
     * @return CLASSSB
     */
    public String getClasssb() {
        return classsb;
    }

    /**
     * @param classsb
     */
    public void setClasssb(String classsb) {
        this.classsb = classsb == null ? null : classsb.trim();
    }

    /**
     * @return CLASSZF
     */
    public String getClasszf() {
        return classzf;
    }

    /**
     * @param classzf
     */
    public void setClasszf(String classzf) {
        this.classzf = classzf == null ? null : classzf.trim();
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
     * @return BBTYPE
     */
    public String getBbtype() {
        return bbtype;
    }

    /**
     * @param bbtype
     */
    public void setBbtype(String bbtype) {
        this.bbtype = bbtype == null ? null : bbtype.trim();
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

    /**
     * @return NOTE
     */
    public String getNote() {
        return note;
    }

    /**
     * @param note
     */
    public void setNote(String note) {
        this.note = note == null ? null : note.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", bbdm=").append(bbdm);
        sb.append(", bbdldm=").append(bbdldm);
        sb.append(", bbmc=").append(bbmc);
        sb.append(", bbjc=").append(bbjc);
        sb.append(", fname=").append(fname);
        sb.append(", sppy=").append(sppy);
        sb.append(", czpy=").append(czpy);
        sb.append(", sfbl=").append(sfbl);
        sb.append(", classhz=").append(classhz);
        sb.append(", classcx=").append(classcx);
        sb.append(", classsb=").append(classsb);
        sb.append(", classzf=").append(classzf);
        sb.append(", showorder=").append(showorder);
        sb.append(", bbtype=").append(bbtype);
        sb.append(", qybj=").append(qybj);
        sb.append(", note=").append(note);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}