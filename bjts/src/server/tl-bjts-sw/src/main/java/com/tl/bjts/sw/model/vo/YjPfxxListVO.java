package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.ExcelSetting;

import java.math.BigDecimal;
import java.util.Date;

public class YjPfxxListVO {

    //实际申报年月
    @ExcelSetting(colTitleName = "申报年月", isFirst = true, nextColName = "sbywbDm")
    private String sbym;

    //申报业务代码
    @ExcelSetting(colTitleName = "申报业务代码", nextColName = "ssnypc")
    private String sbywbDm;

    //所属年月批次sssq+sbpc
    @ExcelSetting(colTitleName = "所属年月批次", nextColName = "yjmc")
    private String ssnypc;
    private String sssq;
    private String sbpc;

    //预警名称(代码+名称)
    @ExcelSetting(colTitleName = "预警项", nextColName = "yjzb")
    private String yjmc;
    private String yjcode;
    private String yjcodeZh;

    //预警指标(代码+名称)
    @ExcelSetting(colTitleName = "预警指标", nextColName = "yjMsg", width = 40)
    private String yjzb;
    private String zbcode;
    private String zbcodeZh;

    //预警信息
    @ExcelSetting(colTitleName = "预警信息", nextColName = "yjObject", width = 40)
    private String yjMsg;

    //预警对象
    @ExcelSetting(colTitleName = "预警对象", nextColName = "yjCount")
    private String yjObject;

    //预警数量
    @ExcelSetting(colTitleName = "预警数量", nextColName = "yjAmt")
    private String yjCount;

    //金额
    @ExcelSetting(colTitleName = "金额", nextColName = "yjTax")
    private BigDecimal yjAmt;

    //税额
    @ExcelSetting(colTitleName = "税额", nextColName = "yjRecord")
    private BigDecimal yjTax;

    //关联号
    @ExcelSetting(colTitleName = "关联号", nextColName = "score")
    private String yjRecord;

    //计分
    @ExcelSetting(colTitleName = "计分", nextColName = "bmdflag")
    private Integer score;

    //计分
    @ExcelSetting(colTitleName = "预警标志", nextColName = "clFlag")
    private String bmdflag;

    //处理标志
    @ExcelSetting(colTitleName = "处理标志", nextColName = "clDate")
    private String clFlag;

    //处理日期
    @ExcelSetting(colTitleName = "处理日期", nextColName = "clUser")
    @JsonFormat(pattern = "yyyy-MM-dd" ,timezone = "GMT+8")
    private Date clDate;

    //处理人
    @ExcelSetting(colTitleName = "处理人", nextColName = "clMsg")
    private String clUser;

    //处理意见
    @ExcelSetting(colTitleName = "处理意见", nextColName = "bz")
    private String clMsg;

    //备注
    @ExcelSetting(colTitleName = "备注")
    private String bz;

    public String getBmdflag() {

        if("0".equals(bmdflag)){
            return "正常预警";
        }
        if("1".equals(bmdflag)){
            return "白名单";
        }
        if("2".equals(bmdflag)){
            return "预警关闭";
        }
        return bmdflag;
    }
    public void setBmdflag(String bmdflag) {
        this.bmdflag = bmdflag;
    }

    public String getSbym() {
        return sbym;
    }

    public void setSbym(String sbym) {
        this.sbym = sbym;
    }

    public String getSbywbDm() {
        return sbywbDm;
    }

    public void setSbywbDm(String sbywbDm) {
        this.sbywbDm = sbywbDm;
    }


    public String getSsnypc() {
        return String.format("%s%s", sssq, sbpc);

    }

    public void setSsnypc(String ssnypc) {
        this.ssnypc = ssnypc;
    }

    public String getSssq() {
        return sssq;
    }

    public void setSssq(String sssq) {
        this.sssq = sssq;
    }

    public String getSbpc() {
        return sbpc;
    }

    public void setSbpc(String sbpc) {
        this.sbpc = sbpc;
    }

    public String getYjmc() {
        return String.format("(%s)%s", yjcode,yjcodeZh);
    }

    public void setYjmc(String yjmc) {
        this.yjmc = yjmc;
    }

    public String getYjcode() {
        return yjcode;
    }

    public void setYjcode(String yjcode) {
        this.yjcode = yjcode;
    }

    public String getYjcodeZh() {
        return yjcodeZh;
    }

    public void setYjcodeZh(String yjcodeZh) {
        this.yjcodeZh = yjcodeZh;
    }

    public String getYjzb() {
        return String.format("(%s)%s", zbcode,zbcodeZh);
    }

    public void setYjzb(String yjzb) {
        this.yjzb = yjzb;
    }

    public String getZbcode() {
        return zbcode;
    }

    public void setZbcode(String zbcode) {
        this.zbcode = zbcode;
    }

    public String getZbcodeZh() {
        return zbcodeZh;
    }

    public void setZbcodeZh(String zbcodeZh) {
        this.zbcodeZh = zbcodeZh;
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

    public String getYjCount() {
        return yjCount;
    }

    public void setYjCount(String yjCount) {
        this.yjCount = yjCount;
    }

    public BigDecimal getYjAmt() {
        return yjAmt;
    }

    public void setYjAmt(BigDecimal yjAmt) {
        this.yjAmt = yjAmt;
    }

    public BigDecimal getYjTax() {
        return yjTax;
    }

    public void setYjTax(BigDecimal yjTax) {
        this.yjTax = yjTax;
    }

    public String getYjRecord() {
        return yjRecord;
    }

    public void setYjRecord(String yjRecord) {
        this.yjRecord = yjRecord;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public String getClFlag() {
        if("0".equals(clFlag)){
            return "未处理";
        }
        if("1".equals(clFlag)){
            return "已处理";
        }
        return clFlag;
    }

    public void setClFlag(String clFlag) {
        this.clFlag = clFlag;
    }

    public Date getClDate() {
        return clDate;
    }

    public void setClDate(Date clDate) {
        this.clDate = clDate;
    }

    public String getClUser() {
        return clUser;
    }

    public void setClUser(String clUser) {
        this.clUser = clUser;
    }

    public String getClMsg() {
        return clMsg;
    }

    public void setClMsg(String clMsg) {
        this.clMsg = clMsg;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }
}
