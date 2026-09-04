package com.tl.web.bjts.shzs.model.vo.ldlp;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;

//购进自用货物明细
public class ZyhwmxVo {
    //申报序号
    private String sbNo;

    //专用发票号码
    private String zyfpNo;

    //自用货物名称
    private String zyCmname;

    //开票日期
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    private Date kpDate;

    //供货方税号
    private String ghfnsNo;

    //单位
    private String unit;

    //数量
    private BigDecimal qnt;

    //单价
    private BigDecimal pri;

    //计税金额
    private BigDecimal amt;

    //征税率
    private BigDecimal zssl;

    //税额
    private BigDecimal se;

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

    public String getZyfpNo() {
        return zyfpNo;
    }

    public void setZyfpNo(String zyfpNo) {
        this.zyfpNo = zyfpNo;
    }

    public String getZyCmname() {
        return zyCmname;
    }

    public void setZyCmname(String zyCmname) {
        this.zyCmname = zyCmname;
    }

    public Date getKpDate() {
        return kpDate;
    }

    public void setKpDate(Date kpDate) {
        this.kpDate = kpDate;
    }

    public String getGhfnsNo() {
        return ghfnsNo;
    }

    public void setGhfnsNo(String ghfnsNo) {
        this.ghfnsNo = ghfnsNo;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getQnt() {
        return qnt;
    }

    public void setQnt(BigDecimal qnt) {
        this.qnt = qnt;
    }

    public BigDecimal getPri() {
        return pri;
    }

    public void setPri(BigDecimal pri) {
        this.pri = pri;
    }

    public BigDecimal getAmt() {
        return amt;
    }

    public void setAmt(BigDecimal amt) {
        this.amt = amt;
    }

    public BigDecimal getZssl() {
        return zssl;
    }

    public void setZssl(BigDecimal zssl) {
        this.zssl = zssl;
    }

    public BigDecimal getSe() {
        return se;
    }

    public void setSe(BigDecimal se) {
        this.se = se;
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
