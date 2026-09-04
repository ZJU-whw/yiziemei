package com.tl.web.bjts.shzs.model.vo;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Created by Neo Lin on 2017/6/20.
 */
public class YjxxVO {
    private Long id;
    private String yjType;
    private String yjTypeName;
    private String yjRecord;
    private String yjMsg;
    private String zbcode;
    private BigDecimal yjAmt; // 金额
    private BigDecimal yjTax; // 退税额
    private Integer ldlpQnt;    //关联明细数量

    private Date clDate;// 处理时间 2018 12-19 zhouxi

    private String clMsg; // 处理意见
    private String yjObject;
    private String swjgFw;

    public String getZbcode() {
        return this.zbcode;

    }

    public void setZbcode(String zbcode) {
        this.zbcode = zbcode;
    }

    public String getSwjgFw() {
        return this.swjgFw;

    }

    public void setSwjgFw(String swjgFw) {
        this.swjgFw = swjgFw;
    }

    public String getClMsg() {
        return clMsg;
    }

    public void setClMsg(String clMsg) {
        this.clMsg = clMsg;
    }

    public Date getClDate() {
        return clDate;
    }

    public void setClDate(Date clDate) {
        this.clDate = clDate;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getYjType() {
        return yjType;
    }

    public void setYjType(String yjType) {
        this.yjType = yjType;
    }

    public String getYjRecord() {
        return yjRecord;
    }

    public void setYjRecord(String yjRecord) {
        this.yjRecord = yjRecord;
    }

    public String getYjMsg() {
        return yjMsg;
    }

    public void setYjMsg(String yjMsg) {
        this.yjMsg = yjMsg;
    }

    public String getYjTypeName() {
        return yjTypeName;
    }

    public void setYjTypeName(String yjTypeName) {
        this.yjTypeName = yjTypeName;
    }

    public BigDecimal getYjAmt() {
        return yjAmt;
    }

    public void setYjAmt(BigDecimal yjAmt) {
        this.yjAmt = yjAmt;
    }

    public Integer getLdlpQnt() {
        return ldlpQnt;
    }

    public void setLdlpQnt(Integer ldlpQnt) {
        this.ldlpQnt = ldlpQnt;
    }

    public String getYjObject() {
        return yjObject;
    }

    public void setYjObject(String yjObject) {
        this.yjObject = yjObject;
    }

    public BigDecimal getYjTax() {
        return yjTax;
    }

    public void setYjTax(BigDecimal yjTax) {
        this.yjTax = yjTax;
    }
}
