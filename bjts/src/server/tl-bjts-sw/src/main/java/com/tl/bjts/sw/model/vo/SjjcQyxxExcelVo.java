package com.tl.bjts.sw.model.vo;

import com.tl.common.ext.annotation.ExcelSetting;
import com.tl.common.ext.annotation.MaxLength;
import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.annotation.RegexCheck;
import com.tl.common.ext.model.RegexPattern;

public class SjjcQyxxExcelVo {

    @NotEmpty(msg = "请填写纳税人识别号")
    @ExcelSetting(colTitleName = "纳税人识别号（必填）")
    private String nsrsbh;

    @MaxLength(length = 50,msg = "【纳税人名称】最长为100位")
    @ExcelSetting(colTitleName = "纳税人名称")
    private String nsrmc;


    public String getNsrsbh() {
        return this.nsrsbh;

    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getNsrmc() {
        return this.nsrmc;

    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }
}
