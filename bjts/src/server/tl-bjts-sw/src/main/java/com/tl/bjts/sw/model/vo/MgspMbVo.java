package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.annotation.MaxLength;
import com.tl.common.ext.annotation.ExcelSetting;
import com.tl.common.ext.annotation.NotNull;
import com.tl.common.ext.annotation.RegexCheck;
import com.tl.common.ext.model.RegexPattern;

import java.util.Date;

public class MgspMbVo {
    @NotEmpty(msg = "请填写商品代码")
    @ExcelSetting(colTitleName = "商品代码（必填）")
    @MaxLength(length = 20,msg = "【商品代码】最长为20位")
    @RegexCheck(msg="请填写正确的商品代码格式",pattern = RegexPattern.LETTERS_NUMBERS_PATTERN)
    private String spdm;
    @MaxLength(length = 50,msg = "【商品名称】最长为50位")
    @ExcelSetting(colTitleName = "商品名称")
    private String spmc;
    @RegexCheck(msg="请将起始日期列单元格设置成yyyy-mm-dd以及文本格式",pattern = RegexPattern.REGEX_DATE_STR_YYYYMMDD_LINE)
    @ExcelSetting(colTitleName = "起始日期")
    private String qsrq;
    @RegexCheck(msg="请将截止日期列单元格设置成yyyy-mm-dd以及文本格式",pattern = RegexPattern.REGEX_DATE_STR_YYYYMMDD_LINE)
    @ExcelSetting(colTitleName = "截止日期")
    private String jzrq;
    @MaxLength(length = 255,msg = "【监控原因】最长为255位")
    @ExcelSetting(colTitleName = "监控原因")
    private String yyms;
    @ExcelSetting(colTitleName = "有效标志(Y/N)（必填）")
    @NotEmpty(msg = "请填写有效标志")
    private String yxbz;

    public String getSpdm() {
        return spdm;
    }

    public void setSpdm(String spdm) {
        this.spdm = spdm;
    }

    public String getSpmc() {
        return spmc;
    }

    public void setSpmc(String spmc) {
        this.spmc = spmc;
    }

    public String getQsrq() {
        return qsrq;
    }

    public void setQsrq(String qsrq) {
        this.qsrq = qsrq;
    }

    public String getJzrq() {
        return jzrq;
    }

    public void setJzrq(String jzrq) {
        this.jzrq = jzrq;
    }

    public String getYyms() {
        return yyms;
    }

    public void setYyms(String yyms) {
        this.yyms = yyms;
    }

    public String getYxbz() {
        return yxbz;
    }

    public void setYxbz(String yxbz) {
        this.yxbz = yxbz;
    }
}
