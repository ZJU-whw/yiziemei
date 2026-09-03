package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.ExcelSetting;

import java.math.BigDecimal;
import java.util.Date;

/*
 * @Description: 预警综合信息查询
 * @Author Neo Lin
 * @Date  2019-09-02 14:27
 */
public class YjZhcxListVO {

    //海关代码
    @ExcelSetting(colTitleName = "海关代码", isFirst = true, nextColName = "nsrsbh")
    private String qyhgdm;

    //纳税人识别号
    @ExcelSetting(colTitleName = "纳税人识别号", nextColName = "nsrmc")
    private String nsrsbh;

    //纳税人名称
    @ExcelSetting(colTitleName = "纳税人名称", nextColName = "yjmc")
    private String nsrmc;

    //预警名称代码+名称
    @ExcelSetting(colTitleName = "预警项", nextColName = "yjzb")
    private String yjmc;
    private String yjcode;
    private String yjcodeZh;


    //预警指标代码+名称
    @ExcelSetting(colTitleName = "预警指标", nextColName = "yjMsg")
    private String yjzb;
    private String zbcode;
    private String zbcodeZh;


    //预警信息
    @ExcelSetting(colTitleName = "预警信息", nextColName = "yjObject")
    private String yjMsg;

    //预警对象
    @ExcelSetting(colTitleName = "预警对象", nextColName = "yjCount")
    private String yjObject;

    //预警数量
    @ExcelSetting(colTitleName = "预警数量", nextColName = "yjAmt")
    private Integer yjCount;

    //金额
    @ExcelSetting(colTitleName = "出口销售(USD)", nextColName = "yjTax")
    private BigDecimal yjAmt;

    //税额
    @ExcelSetting(colTitleName = "退税额", nextColName = "yjRecord")
    private BigDecimal yjTax;

    //关联号
    @ExcelSetting(colTitleName = "关联号/申报序号", nextColName = "score")
    private String yjRecord;

    //计分
    @ExcelSetting(colTitleName = "计分", nextColName = "bmdflag")
    private String score;

    @ExcelSetting(colTitleName = "预警标志", nextColName = "sbywbDm")
    private String bmdflag;

    //申报业务代码
    @ExcelSetting(colTitleName = "申报业务代码", nextColName = "sssq")
    private String sbywbDm;

    //所属年月
    @ExcelSetting(colTitleName = "所属年月", nextColName = "sbpc")
    private String sssq;

    //批次
    @ExcelSetting(colTitleName = "批次", nextColName = "sbym")
    private String sbpc;

    //实际申报年月
    @ExcelSetting(colTitleName = "申报年月", nextColName = "swjgJc")
    private String sbym;

    //退税税务机关
    @ExcelSetting(colTitleName = "退税机关", nextColName = "clFlag")
    private String swjgJc;

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

    private  String bsy1Mc;
    private  String bsy2Mc;
    private  String fddbrmc;

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

    public String getBsy1Mc() {
        return bsy1Mc;
    }

    public void setBsy1Mc(String bsy1Mc) {
        this.bsy1Mc = bsy1Mc;
    }

    public String getBsy2Mc() {
        return bsy2Mc;
    }

    public void setBsy2Mc(String bsy2Mc) {
        this.bsy2Mc = bsy2Mc;
    }

    public String getFddbrmc() {
        return fddbrmc;
    }

    public void setFddbrmc(String fddbrmc) {
        this.fddbrmc = fddbrmc;
    }

    public String getQyhgdm() {
        return qyhgdm;
    }

    public void setQyhgdm(String qyhgdm) {
        this.qyhgdm = qyhgdm;
    }

    public String getNsrsbh() {
        return nsrsbh;
    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getNsrmc() {
        return nsrmc;
    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
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

    public Integer getYjCount() {
        return yjCount;
    }

    public void setYjCount(Integer yjCount) {
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

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    public String getSbywbDm() {
        return sbywbDm;
    }

    public void setSbywbDm(String sbywbDm) {
        this.sbywbDm = sbywbDm;
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

    public String getSbym() {
        return sbym;
    }

    public void setSbym(String sbym) {
        this.sbym = sbym;
    }

    public String getSwjgJc() {
        return swjgJc;
    }

    public void setSwjgJc(String swjgJc) {
        this.swjgJc = swjgJc;
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
