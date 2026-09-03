package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TJBB_HEADER_COLS")
public class TjbbColModel implements Serializable {
    @Id
    @Column(name = "ID")
    private BigDecimal id;

    @Column(name = "BBDM")
    private String bbdm;

    @Column(name = "FNAME")
    private String fname;

    @Column(name = "CNAME")
    private String cname;

    @Column(name = "FNAMEHZ")
    private String fnamehz;

    @Column(name = "FTYPE")
    private String ftype;

    @Column(name = "MAXLEN")
    private BigDecimal maxlen;

    @Column(name = "DEGREE")
    private BigDecimal degree;

    @Column(name = "DEFVAL")
    private String defval;

    @Column(name = "NULLABLE")
    private String nullable;

    @Column(name = "FMT")
    private String fmt;

    @Column(name = "SHOWORDER")
    private BigDecimal showorder;

    @Column(name = "XLSCOL")
    private String xlscol;

    @Column(name = "ALLOWUPDATE")
    private String allowupdate;

    @Column(name = "NOTE")
    private String note;

    @Column(name = "QYBJ")
    private String qybj;

    @Column(name = "ALIGN")
    private String align;

    @Column(name = "ALLOWFORMULA")
    private String allowformula;

    @Column(name = "ALLOWSUM")
    private String allowsum;

    @Column(name = "HZTYPE")
    private String hztype;

    @Column(name = "HZOBJ")
    private String hzobj;

    private static final long serialVersionUID = 1L;

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

    public String getAllowsum() {
        return allowsum;
    }

    public void setAllowsum(String allowsum) {
        this.allowsum = allowsum;
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
     * @return CNAME
     */
    public String getCname() {
        return cname;
    }

    /**
     * @param cname
     */
    public void setCname(String cname) {
        this.cname = cname == null ? null : cname.trim();
    }

    /**
     * @return FNAMEHZ
     */
    public String getFnamehz() {
        return fnamehz;
    }

    /**
     * @param fnamehz
     */
    public void setFnamehz(String fnamehz) {
        this.fnamehz = fnamehz == null ? null : fnamehz.trim();
    }

    /**
     * @return FTYPE
     */
    public String getFtype() {
        return ftype;
    }

    /**
     * @param ftype
     */
    public void setFtype(String ftype) {
        this.ftype = ftype == null ? null : ftype.trim();
    }

    /**
     * @return MAXLEN
     */
    public BigDecimal getMaxlen() {
        return maxlen;
    }

    /**
     * @param maxlen
     */
    public void setMaxlen(BigDecimal maxlen) {
        this.maxlen = maxlen;
    }

    /**
     * @return DEGREE
     */
    public BigDecimal getDegree() {
        return degree;
    }

    /**
     * @param degree
     */
    public void setDegree(BigDecimal degree) {
        this.degree = degree;
    }

    /**
     * @return DEFVAL
     */
    public String getDefval() {
        return defval;
    }

    /**
     * @param defval
     */
    public void setDefval(String defval) {
        this.defval = defval == null ? null : defval.trim();
    }

    /**
     * @return NULLABLE
     */
    public String getNullable() {
        return nullable;
    }

    /**
     * @param nullable
     */
    public void setNullable(String nullable) {
        this.nullable = nullable == null ? null : nullable.trim();
    }

    /**
     * @return FMT
     */
    public String getFmt() {
        return fmt;
    }

    /**
     * @param fmt
     */
    public void setFmt(String fmt) {
        this.fmt = fmt == null ? null : fmt.trim();
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
     * @return XLSCOL
     */
    public String getXlscol() {
        return xlscol;
    }

    /**
     * @param xlscol
     */
    public void setXlscol(String xlscol) {
        this.xlscol = xlscol == null ? null : xlscol.trim();
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
     * @return ALIGN
     */
    public String getAlign() {
        return align;
    }

    /**
     * @param align
     */
    public void setAlign(String align) {
        this.align = align == null ? null : align.trim();
    }

    /**
     * @return ALLOWFORMULA
     */
    public String getAllowformula() {
        return allowformula;
    }

    /**
     * @param allowformula
     */
    public void setAllowformula(String allowformula) {
        this.allowformula = allowformula == null ? null : allowformula.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", bbdm=").append(bbdm);
        sb.append(", fname=").append(fname);
        sb.append(", cname=").append(cname);
        sb.append(", fnamehz=").append(fnamehz);
        sb.append(", ftype=").append(ftype);
        sb.append(", maxlen=").append(maxlen);
        sb.append(", degree=").append(degree);
        sb.append(", defval=").append(defval);
        sb.append(", nullable=").append(nullable);
        sb.append(", fmt=").append(fmt);
        sb.append(", showorder=").append(showorder);
        sb.append(", xlscol=").append(xlscol);
        sb.append(", allowupdate=").append(allowupdate);
        sb.append(", note=").append(note);
        sb.append(", qybj=").append(qybj);
        sb.append(", align=").append(align);
        sb.append(", allowformula=").append(allowformula);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}