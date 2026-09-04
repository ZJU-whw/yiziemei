package com.tl.web.bjts.shzs.model.vo.ldlp;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;

//免抵退税出口明细
public class MdtsckVo {

    //申报序号
    private String sbNo;

    //出口发票号
    private String invNo;

    //记销售日期
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    private Date jxsDate;

    //报关单号
    private String bgdNo;

    //出口日期
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
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

    //出口销售rmb
    private BigDecimal rmbAmt;

    //征收税率
    private BigDecimal zssl;

    //退税率
    private BigDecimal tsl;

    //征退税差额
    private BigDecimal ztsce;

    //应退税额
    private BigDecimal tsAmt;

    //进料登记册号
    private String hgdjcNo;

    //业务类型
    private String ywlx;

    public String getSbNo() {
        return sbNo;
    }

    public void setSbNo(String sbNo) {
        this.sbNo = sbNo;
    }

    public String getInvNo() {
        return invNo;
    }

    public void setInvNo(String invNo) {
        this.invNo = invNo;
    }

    public Date getJxsDate() {
        return jxsDate;
    }

    public void setJxsDate(Date jxsDate) {
        this.jxsDate = jxsDate;
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

    public BigDecimal getRmbAmt() {
        return rmbAmt;
    }

    public void setRmbAmt(BigDecimal rmbAmt) {
        this.rmbAmt = rmbAmt;
    }

    public BigDecimal getZssl() {
        return zssl;
    }

    public void setZssl(BigDecimal zssl) {
        this.zssl = zssl;
    }

    public BigDecimal getTsl() {
        return tsl;
    }

    public void setTsl(BigDecimal tsl) {
        this.tsl = tsl;
    }

    public BigDecimal getZtsce() {
        return ztsce;
    }

    public void setZtsce(BigDecimal ztsce) {
        this.ztsce = ztsce;
    }

    public BigDecimal getTsAmt() {
        return tsAmt;
    }

    public void setTsAmt(BigDecimal tsAmt) {
        this.tsAmt = tsAmt;
    }

    public String getHgdjcNo() {
        return hgdjcNo;
    }

    public void setHgdjcNo(String hgdjcNo) {
        this.hgdjcNo = hgdjcNo;
    }

    public String getYwlx() {
        return ywlx;
    }

    public void setYwlx(String ywlx) {
        this.ywlx = ywlx;
    }
}
