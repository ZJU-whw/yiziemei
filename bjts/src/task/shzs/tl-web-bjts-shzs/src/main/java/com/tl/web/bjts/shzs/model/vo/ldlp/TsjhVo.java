package com.tl.web.bjts.shzs.model.vo.ldlp;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.web.bjts.shzs.model.vo.ldlp.FpxxVo;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @Description: 退税进货
 * @Author Neo Lin
 * @Date  2017/12/13 17:35
 */
public class TsjhVo {
    private String sz;
    private String zyfpNo;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    private Date kpdate;
    private String cmcode;
    private String cmname;
    private String cmunit;
    private BigDecimal qnt;
    private BigDecimal amt;
    private BigDecimal sl;
    private BigDecimal se;
    private BigDecimal tsl;
    private BigDecimal tsAmt;
    private String ywlx;
    private String note;
    private FpxxVo zzsfp;

    public String getSz() {
        return sz;
    }

    public void setSz(String sz) {
        this.sz = sz;
    }

    public String getZyfpNo() {
        return zyfpNo;
    }

    public void setZyfpNo(String zyfpNo) {
        this.zyfpNo = zyfpNo;
    }

    public Date getKpdate() {
        return kpdate;
    }

    public void setKpdate(Date kpdate) {
        this.kpdate = kpdate;
    }

    public String getCmcode() {
        return cmcode;
    }

    public void setCmcode(String cmcode) {
        this.cmcode = cmcode;
    }

    public String getCmname() {
        return cmname;
    }

    public void setCmname(String cmname) {
        this.cmname = cmname;
    }

    public String getCmunit() {
        return cmunit;
    }

    public void setCmunit(String cmunit) {
        this.cmunit = cmunit;
    }

    public BigDecimal getQnt() {
        return qnt;
    }

    public void setQnt(BigDecimal qnt) {
        this.qnt = qnt;
    }

    public BigDecimal getAmt() {
        return amt;
    }

    public void setAmt(BigDecimal amt) {
        this.amt = amt;
    }

    public BigDecimal getSl() {
        return sl;
    }

    public void setSl(BigDecimal sl) {
        this.sl = sl;
    }

    public BigDecimal getSe() {
        return se;
    }

    public void setSe(BigDecimal se) {
        this.se = se;
    }

    public BigDecimal getTsl() {
        return tsl;
    }

    public void setTsl(BigDecimal tsl) {
        this.tsl = tsl;
    }

    public BigDecimal getTsAmt() {
        return tsAmt;
    }

    public void setTsAmt(BigDecimal tsAmt) {
        this.tsAmt = tsAmt;
    }

    public String getYwlx() {
        return ywlx;
    }

    public void setYwlx(String ywlx) {
        this.ywlx = ywlx;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public FpxxVo getZzsfp() {
        return zzsfp;
    }

    public void setZzsfp(FpxxVo zzsfp) {
        this.zzsfp = zzsfp;
    }
}
