package com.tl.bjts.sw.model.vo;

import com.tl.common.ext.annotation.ExcelSetting;
import org.apache.commons.lang3.StringUtils;

public class PjdjVo {
    @ExcelSetting(colTitleName = "商品代码")
    private String spdm;
    @ExcelSetting(colTitleName = "商品名称")
    private String spmc;
    @ExcelSetting(colTitleName = "数量")
    private String qnt;
    @ExcelSetting(colTitleName = "出口销售额")
    private String amt;
    @ExcelSetting(colTitleName = "平均单价")
    private String dj;
    @ExcelSetting(colTitleName = "企业户数")
    private String qyhs;

    public String getQyhs() {
        return this.qyhs;

    }

    public void setQyhs(String qyhs) {
        this.qyhs = qyhs;
    }

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

    public String getQnt() {

        if(StringUtils.isNotBlank(qnt) && qnt.startsWith(".")) {
            return "0" + qnt;
        }

        return qnt;
    }

    public void setQnt(String qnt) {
        this.qnt = qnt;
    }

    public String getAmt() {

        if(StringUtils.isNotBlank(amt) && amt.startsWith(".")) {
            return "0" + amt;
        }

        return amt;
    }

    public void setAmt(String amt) {
        this.amt = amt;
    }

    public String getDj() {
        if(StringUtils.isNotBlank(dj) && dj.startsWith(".")){
            return "0"+dj;
        }
        return dj;
    }

    public void setDj(String dj) {
        this.dj = dj;
    }
}
