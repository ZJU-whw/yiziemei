package com.tl.web.bjts.shzs.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.Date;

/**
 * Created by Neo Lin on 2017/6/30.
 */
public class YjxxExcelVO {
    private Long id;
    private String yjTypeName;
    private String yjRecord;
    private String yjMsg;
    private String yjObject;
    private String yjAmt;
    private String yjTax;
    private String qyhgdm;
    private String nsrmc;
    private String nsrsbh;

    @JsonFormat(pattern = "yyyy-MM-dd hh:mm:ss",timezone = "GMT+8")
    private Date clDate;// 处理时间 2018 12-19 zhouxi

    private String clMsg; // 处理意见

    public Date getClDate() {
        return clDate;
    }

    public void setClDate(Date clDate) {
        this.clDate = clDate;
    }

    public String getClMsg() {
        return clMsg;
    }

    public void setClMsg(String clMsg) {
        this.clMsg = clMsg;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getYjTypeName() {
        return yjTypeName;
    }

    public void setYjTypeName(String yjTypeName) {
        this.yjTypeName = yjTypeName;
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

    public String getYjObject() {
        return yjObject;
    }

    public void setYjObject(String yjObject) {
        this.yjObject = yjObject;
    }

    public String getYjAmt() {
        return yjAmt;
    }

    public void setYjAmt(String yjAmt) {
        this.yjAmt = yjAmt;
    }

    public String getYjTax() {
        return yjTax;
    }

    public void setYjTax(String yjTax) {
        this.yjTax = yjTax;
    }

    public String getQyhgdm() {
        return qyhgdm;
    }

    public void setQyhgdm(String qyhgdm) {
        this.qyhgdm = qyhgdm;
    }

    public String getNsrmc() {
        return nsrmc;
    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }

    public String getNsrsbh() {
        return nsrsbh;
    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }
}
