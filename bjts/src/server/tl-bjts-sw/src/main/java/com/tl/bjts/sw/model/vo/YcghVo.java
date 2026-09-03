package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.MaxLength;
import com.tl.common.ext.annotation.NotNull;
import com.tl.common.ext.annotation.ExcelSetting;
import com.tl.common.ext.annotation.NotEmpty;

import java.util.Date;

public class YcghVo {
    @MaxLength(length = 20,msg = "【企业税号】最长为20位")
    @ExcelSetting(colTitleName = "企业税号")
    @NotEmpty(msg = "请填写企业税号")
    private String nsrsbh;
    @MaxLength(length = 80,msg = "【企业名称】最长为80位")
    @ExcelSetting(colTitleName = "企业名称")
    private String nsrmc;
    @ExcelSetting(colTitleName = "主管税务机关")
    private String zgswjgmc;
    private Long id;
    private String swjgfw;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @ExcelSetting(colTitleName = "起始日期")
    private Date qsrq;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @ExcelSetting(colTitleName = "截止日期")
    private Date jzrq;
    @MaxLength(length = 255,msg = "【监控原因】最长为255位")
    @ExcelSetting(colTitleName = "监控原因")
    private String yyms;
    @ExcelSetting(colTitleName = "录入人")
    private String lrr;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @ExcelSetting(colTitleName = "录入日期")
    private Date lrrq;
    @ExcelSetting(colTitleName = "有效标志")
    @NotEmpty(msg = "请填写有效标志")
    private String yxbz;
    @ExcelSetting(colTitleName = "录入税务机关")
    private String lrswjgdm;

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

    public String getZgswjgmc() {
        return zgswjgmc;
    }

    public void setZgswjgmc(String zgswjgmc) {
        this.zgswjgmc = zgswjgmc;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSwjgfw() {
        return swjgfw;
    }

    public void setSwjgfw(String swjgfw) {
        this.swjgfw = swjgfw;
    }

    public Date getQsrq() {
        return qsrq;
    }

    public void setQsrq(Date qsrq) {
        this.qsrq = qsrq;
    }

    public Date getJzrq() {
        return jzrq;
    }

    public void setJzrq(Date jzrq) {
        this.jzrq = jzrq;
    }

    public String getYyms() {
        return yyms;
    }

    public void setYyms(String yyms) {
        this.yyms = yyms;
    }

    public String getLrr() {
        return lrr;
    }

    public void setLrr(String lrr) {
        this.lrr = lrr;
    }

    public Date getLrrq() {
        return lrrq;
    }

    public void setLrrq(Date lrrq) {
        this.lrrq = lrrq;
    }

    public String getLrswjgdm() {
        return lrswjgdm;
    }

    public void setLrswjgdm(String lrswjgdm) {
        this.lrswjgdm = lrswjgdm;
    }

    public String getYxbz() {
        return yxbz;
    }

    public void setYxbz(String yxbz) {
        this.yxbz = yxbz;
    }
}
