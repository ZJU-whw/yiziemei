package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.annotation.MaxLength;
import com.tl.common.ext.annotation.NotNull;
import com.tl.common.ext.annotation.ExcelSetting;
import com.tl.common.ext.annotation.RegexCheck;
import com.tl.common.ext.model.RegexPattern;

import java.util.Date;

public class YcghMbVo {
    @MaxLength(length = 20,msg = "【企业税号】最长为20位")
    @ExcelSetting(colTitleName = "企业税号(必填)")
    @NotEmpty(msg = "请填写企业税号")
    @RegexCheck(msg="请填写正确的企业税号格式",pattern = RegexPattern.TAXPAYER_CODE_PATTERN)
    private String nsrsbh;
    @MaxLength(length = 80,msg = "【企业名称】最长为80位")
    @ExcelSetting(colTitleName = "供货企业名称")
    private String nsrmc;
    @MaxLength(length = 50,msg = "【主管税务机关】最长为50位")
    @ExcelSetting(colTitleName = "主管税务机关")
    private String zgswjgmc;
    @RegexCheck(msg="请将起始日期列单元格设置成yyyy-mm-dd以及文本格式",pattern = RegexPattern.REGEX_DATE_STR_YYYYMMDD_LINE)
    @ExcelSetting(colTitleName = "起始日期")
    private String qsrq;
    @RegexCheck(msg="请将截止日期列单元格设置成yyyy-mm-dd以及文本格式",pattern = RegexPattern.REGEX_DATE_STR_YYYYMMDD_LINE)
    @ExcelSetting(colTitleName = "截止日期")
    private String jzrq;
    @MaxLength(length = 255,msg = "【监控原因】最长为255位")
    @ExcelSetting(colTitleName = "监控原因")
    private String yyms;
    @NotEmpty(msg = "请填写有效标志")
    @ExcelSetting(colTitleName = "有效标志(Y/N)(必填)")
    private String yxbz;
/*    @ExcelSetting(colTitleName = "（注意：请将两个日期的单元格格式设置成文本格式）")
    private String var1;*/

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
