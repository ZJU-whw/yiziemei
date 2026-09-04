package com.tl.web.bjts.shzs.model.vo.ldlp;


import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;

//外综服企业代办退税明细
public class DbtsVo {
    //申报no
    private String sbNo;

    //委托方纳税人税号
    private String wtNsrdjNo;

    //报关单号
    private String bgdNo;

    //出口日期
    @JsonFormat(pattern = "yyyy-MM-dd",timezone="GMT+8")
    private Date ljDate;

    //商品代码
    private String cmcode;

    //商品名称
    private String cmname;

    //单位
    private String cmunit;

    //申报商品代码
    private String sbcmcode;

    //出口数量
    private BigDecimal qnt;

    //美元离岸价
    private BigDecimal usdAmt;

    //代办专用发票
    private String zyfpNo;

    //开票日期
    @JsonFormat(pattern = "yyyy-MM-dd", timezone="GMT+8")
    private Date kpDate;

    //开票金额
    private BigDecimal rmbAmt;

    //征税率
    private BigDecimal sl;

    //税额
    private BigDecimal se;

    //退税率
    private BigDecimal tsl;

    //可退税额
    private BigDecimal tsAmt;

    //业务类型
    private String ywlx;

    public String getSbNo() {
        return sbNo;
    }

    public void setSbNo(String sbNo) {
        this.sbNo = sbNo;
    }

    public String getWtNsrdjNo() {
        return wtNsrdjNo;
    }

    public void setWtNsrdjNo(String wtNsrdjNo) {
        this.wtNsrdjNo = wtNsrdjNo;
    }

    public String getBgdNo() {
        return bgdNo;
    }

    public void setBgdNo(String bgdNo) {
        this.bgdNo = bgdNo;
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

    public String getSbcmcode() {
        return sbcmcode;
    }

    public void setSbcmcode(String sbcmcode) {
        this.sbcmcode = sbcmcode;
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

    public String getZyfpNo() {
        return zyfpNo;
    }

    public void setZyfpNo(String zyfpNo) {
        this.zyfpNo = zyfpNo;
    }

    public Date getKpDate() {
        return kpDate;
    }

    public void setKpDate(Date kpDate) {
        this.kpDate = kpDate;
    }

    public BigDecimal getRmbAmt() {
        return rmbAmt;
    }

    public void setRmbAmt(BigDecimal rmbAmt) {
        this.rmbAmt = rmbAmt;
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
}
