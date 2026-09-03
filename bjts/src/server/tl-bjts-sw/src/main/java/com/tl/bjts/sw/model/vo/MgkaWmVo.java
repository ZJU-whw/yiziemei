package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.*;
import com.tl.common.ext.model.RegexPattern;

import javax.persistence.Column;
import javax.persistence.Id;
import java.util.Date;

/**
 * 敏感口岸与敏感商品公用vo
 */
public class MgkaWmVo {
    @NotEmpty(msg = "请填写口岸代码")
    @MaxLength(length = 4,msg = "【口岸代码】最长为4位")
    @ExcelSetting(colTitleName = "口岸代码")
    @RegexCheck(msg="请填写正确的口岸代码格式",pattern = RegexPattern.LETTERS_NUMBERS_PATTERN)
    private String kacode;
    @ExcelSetting(colTitleName = "口岸名称")
    @MaxLength(length = 50,msg = "【口岸名称】最长为50位")
    private String kaname;
    private Long id;
    private String swjgfw;

    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @ExcelSetting(colTitleName = "起始日期")
    private Date qsrq;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @ExcelSetting(colTitleName = "截止日期")
    private Date jzrq;
    @MaxLength(length = 255,msg = "【监控原因】最长为255位")
    @NotNull(msg = "请填写监控原因")
    @ExcelSetting(colTitleName = "监控原因")
    private String yyms;
    @ExcelSetting(colTitleName = "录入人")
    private String lrr;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @ExcelSetting(colTitleName = "录入日期")
    private Date lrrq;
    @ExcelSetting(colTitleName = "录入税务机关")
    private String lrswjgdm;
    @NotEmpty(msg = "请选择有效标志")
    @ExcelSetting(colTitleName = "有效标志")
    private String yxbz;



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
