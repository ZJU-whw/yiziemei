package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.annotation.ExcelSetting;
import com.tl.common.ext.annotation.MaxLength;
import com.tl.common.ext.annotation.NotNull;
import com.tl.common.ext.annotation.RegexCheck;
import com.tl.common.ext.model.RegexPattern;

import java.util.Date;

public class MgkaWmMbVo {
    @MaxLength(length = 4,msg = "【口岸代码】最长为4位")
    @ExcelSetting(colTitleName = "口岸代码(必填)")
    @NotEmpty(msg = "请填写口岸代码")
    @RegexCheck(msg="请填写正确的口岸代码格式",pattern = RegexPattern.LETTERS_NUMBERS_PATTERN)
    private String kacode;
    @ExcelSetting(colTitleName = "口岸名称")
    @MaxLength(length = 50,msg = "【口岸名称】最长为50位")
    private String kaname;
    private Long id;
    private String swjgfw;
    @RegexCheck(msg="请将起始日期列单元格设置成yyyy-mm-dd以及文本格式",pattern = RegexPattern.REGEX_DATE_STR_YYYYMMDD_LINE)
    @ExcelSetting(colTitleName = "起始日期")
    private String qsrq;
    @RegexCheck(msg="请将截止日期列单元格设置成yyyy-mm-dd以及文本格式",pattern = RegexPattern.REGEX_DATE_STR_YYYYMMDD_LINE)
    @ExcelSetting(colTitleName = "截止日期")
    private String jzrq;
    @MaxLength(length = 255,msg = "【监控原因】最长为255位")
    @ExcelSetting(colTitleName = "监控原因")
    private String yyms;
    @NotEmpty(msg = "请选择有效标志")
    @ExcelSetting(colTitleName = "有效标志（Y/N）(必填)")
    private String yxbz;

    public String getKacode() {
        return kacode;
    }

    public void setKacode(String kacode) {
        this.kacode = kacode;
    }

    public String getKaname() {
        return kaname;
    }

    public void setKaname(String kaname) {
        this.kaname = kaname;
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
