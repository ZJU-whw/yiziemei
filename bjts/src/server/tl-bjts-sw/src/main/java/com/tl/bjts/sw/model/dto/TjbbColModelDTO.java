package com.tl.bjts.sw.model.dto;

import com.tl.bjts.sw.annotation.NotEmpty;

import java.math.BigDecimal;

/**
 * @Author：Mamf
 * @Date: 2019/10/16.
 * @Description:
 */
public class TjbbColModelDTO {

    private BigDecimal id;

    private String isAdd;

    @NotEmpty
    private String bbdm;

    @NotEmpty
    private String fname;

    private String cname;

    private String fnamehz;

    @NotEmpty
    private String ftype;

    @NotEmpty
    private BigDecimal maxlen;

    private BigDecimal degree;

    private String defval;

    private String nullable;

    private String fmt;

    private BigDecimal showorder;

    private String xlscol;

    @NotEmpty
    private String allowupdate;

    private String note;

    private String qybj;

    private String align;

    private String allowformula;

    private String allowsum;

    private String hztype;

    private String hzobj;

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

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public String getIsAdd() {
        return isAdd;
    }

    public void setIsAdd(String isAdd) {
        this.isAdd = isAdd;
    }

    public String getBbdm() {
        return bbdm;
    }

    public void setBbdm(String bbdm) {
        this.bbdm = bbdm;
    }

    public String getFname() {
        return fname;
    }

    public void setFname(String fname) {
        this.fname = fname;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getFnamehz() {
        return fnamehz;
    }

    public void setFnamehz(String fnamehz) {
        this.fnamehz = fnamehz;
    }

    public String getFtype() {
        return ftype;
    }

    public void setFtype(String ftype) {
        this.ftype = ftype;
    }

    public BigDecimal getMaxlen() {
        return maxlen;
    }

    public void setMaxlen(BigDecimal maxlen) {
        this.maxlen = maxlen;
    }

    public BigDecimal getDegree() {
        return degree;
    }

    public void setDegree(BigDecimal degree) {
        this.degree = degree;
    }

    public String getDefval() {
        return defval;
    }

    public void setDefval(String defval) {
        this.defval = defval;
    }

    public String getNullable() {
        return nullable;
    }

    public void setNullable(String nullable) {
        this.nullable = nullable;
    }

    public String getFmt() {
        return fmt;
    }

    public void setFmt(String fmt) {
        this.fmt = fmt;
    }

    public BigDecimal getShoworder() {
        return showorder;
    }

    public void setShoworder(BigDecimal showorder) {
        this.showorder = showorder;
    }

    public String getXlscol() {
        return xlscol;
    }

    public void setXlscol(String xlscol) {
        this.xlscol = xlscol;
    }

    public String getAllowupdate() {
        return allowupdate;
    }

    public void setAllowupdate(String allowupdate) {
        this.allowupdate = allowupdate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getQybj() {
        return qybj;
    }

    public void setQybj(String qybj) {
        this.qybj = qybj;
    }

    public String getAlign() {
        return align;
    }

    public void setAlign(String align) {
        this.align = align;
    }

    public String getAllowformula() {
        return allowformula;
    }

    public void setAllowformula(String allowformula) {
        this.allowformula = allowformula;
    }
}
