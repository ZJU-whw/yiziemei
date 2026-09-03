package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

import java.math.BigDecimal;

public class YjZhcxListDTO extends BaseListDTO {
    private String preSwjgdm; //权限税务机关代码

    // 企业标识
    private String qybs;

    // 企业名称
    private String qymc;

    // 预警代码
    private String yjcode;

    // 预警指标
    private String zbcode;

    // 白名单标志
    private String bmdflag;

    // 处理标志
    private String clFlag;

    // 退税机关
    private String swjgJc;//commonservice里面如果没传就回去取登录人的swjgdm，所以这里改成swjgJC

    // 申报业务代码
    private String sbywbDm;

    // 申报年月（选择YYYY或YYYYMM)
    private String sbym;

    // 预警对象
    private String yjObject;

    // 金额起
    private BigDecimal yjAmtStart;

    // 金额止
    private BigDecimal yjAmtEnd;
    //处理日期起
    private String clrqq;

    private String clrqz;

    private String swjgDm;

    public String getSwjgDm() {
        return swjgDm;
    }

    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm;
    }

    public String getClrqq() {
        return clrqq;
    }

    public void setClrqq(String clrqq) {
        this.clrqq = clrqq;
    }

    public String getClrqz() {
        return clrqz;
    }

    public void setClrqz(String clrqz) {
        this.clrqz = clrqz;
    }

    public String getPreSwjgdm() {
        return preSwjgdm;
    }

    public void setPreSwjgdm(String preSwjgdm) {
        this.preSwjgdm = preSwjgdm;
    }

    public String getQybs() {
        return qybs;
    }

    public void setQybs(String qybs) {
        this.qybs = qybs;
    }

    public String getQymc() {
        return qymc;
    }

    public void setQymc(String qymc) {
        this.qymc = qymc;
    }

    public String getYjcode() {
        return yjcode;
    }

    public void setYjcode(String yjcode) {
        this.yjcode = yjcode;
    }

    public String getZbcode() {
        return zbcode;
    }

    public void setZbcode(String zbcode) {
        this.zbcode = zbcode;
    }

    public String getBmdflag() {
        return bmdflag;
    }

    public void setBmdflag(String bmdflag) {
        this.bmdflag = bmdflag;
    }

    public String getClFlag() {
        return clFlag;
    }

    public void setClFlag(String clFlag) {
        this.clFlag = clFlag;
    }

    public String getSwjgJc() {
        return swjgJc;
    }

    public void setSwjgJc(String swjgJc) {
        this.swjgJc = swjgJc;
    }

    public String getSbywbDm() {
        return sbywbDm;
    }

    public void setSbywbDm(String sbywbDm) {
        this.sbywbDm = sbywbDm;
    }

    public String getSbym() {
        return sbym;
    }

    public void setSbym(String sbym) {
        this.sbym = sbym;
    }

    public String getYjObject() {
        return yjObject;
    }

    public void setYjObject(String yjObject) {
        this.yjObject = yjObject;
    }

    public BigDecimal getYjAmtStart() {
        return yjAmtStart;
    }

    public void setYjAmtStart(BigDecimal yjAmtStart) {
        this.yjAmtStart = yjAmtStart;
    }

    public BigDecimal getYjAmtEnd() {
        return yjAmtEnd;
    }

    public void setYjAmtEnd(BigDecimal yjAmtEnd) {
        this.yjAmtEnd = yjAmtEnd;
    }
}
