package com.tl.web.bjts.shzs.model.vo.ldlp;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.web.bjts.shzs.model.vo.ldlp.BgdVo;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @Description:  退税出口
 * @Author Neo Lin
 * @Date  2017/12/13 17:34
 */
public class TsckVo {
    private String bgdNo;
    private String dlzmNo;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    private Date ljDate;
    private String cmcode;
    private String cmname;
    private String cmunit;
    private BigDecimal qnt;
    private BigDecimal usdAmt;
    private BigDecimal ckjhAmt;
    private BigDecimal tsl;
    private BigDecimal zzsTsAmt;
    private BigDecimal xfsTsAmt;
    private String ywlx;
    private String note;
    private BgdVo bgdInfo;

    public String getBgdNo() {
        return bgdNo;
    }

    public void setBgdNo(String bgdNo) {
        this.bgdNo = bgdNo;
    }

    public String getDlzmNo() {
        return dlzmNo;
    }

    public void setDlzmNo(String dlzmNo) {
        this.dlzmNo = dlzmNo;
    }

    public Date getLjDate() {
        return ljDate;
    }

    public void setLjDate(Date ljDate) {
        this.ljDate = ljDate;
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

    public BigDecimal getUsdAmt() {
        return usdAmt;
    }

    public void setUsdAmt(BigDecimal usdAmt) {
        this.usdAmt = usdAmt;
    }

    public BigDecimal getCkjhAmt() {
        return ckjhAmt;
    }

    public void setCkjhAmt(BigDecimal ckjhAmt) {
        this.ckjhAmt = ckjhAmt;
    }

    public BigDecimal getTsl() {
        return tsl;
    }

    public void setTsl(BigDecimal tsl) {
        this.tsl = tsl;
    }

    public BigDecimal getZzsTsAmt() {
        return zzsTsAmt;
    }

    public void setZzsTsAmt(BigDecimal zzsTsAmt) {
        this.zzsTsAmt = zzsTsAmt;
    }

    public BigDecimal getXfsTsAmt() {
        return xfsTsAmt;
    }

    public void setXfsTsAmt(BigDecimal xfsTsAmt) {
        this.xfsTsAmt = xfsTsAmt;
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

    public BgdVo getBgdInfo() {
        return bgdInfo;
    }

    public void setBgdInfo(BgdVo bgdInfo) {
        this.bgdInfo = bgdInfo;
    }
}
