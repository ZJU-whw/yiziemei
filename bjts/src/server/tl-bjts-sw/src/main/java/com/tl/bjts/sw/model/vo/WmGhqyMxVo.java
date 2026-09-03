package com.tl.bjts.sw.model.vo;

import com.tl.common.ext.annotation.ExcelSetting;

/**
 * @Author：Mamf
 * @Date: 2020/3/5.
 * @Description:
 */
public class WmGhqyMxVo {

    @ExcelSetting(colTitleName = "供货企业税号")
    private String ghfns_no;

    @ExcelSetting(colTitleName = "纳税人名称")
    private String nsrmc;

    @ExcelSetting(colTitleName = "累计进货金额")
    private String jhamt;

    @ExcelSetting(colTitleName = "上年同期")
    private String jhamt_sq;

    @ExcelSetting(colTitleName = "累计退税额")
    private String tse;

    @ExcelSetting(colTitleName = "上年同期")
    private String tse_sq;

    public String getGhfns_no() {
        return ghfns_no;
    }

    public void setGhfns_no(String ghfns_no) {
        this.ghfns_no = ghfns_no;
    }

    public String getNsrmc() {
        return nsrmc;
    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }

    public String getJhamt() {
        return jhamt;
    }

    public void setJhamt(String jhamt) {
        this.jhamt = jhamt;
    }

    public String getJhamt_sq() {
        return jhamt_sq;
    }

    public void setJhamt_sq(String jhamt_sq) {
        this.jhamt_sq = jhamt_sq;
    }

    public String getTse() {
        return tse;
    }

    public void setTse(String tse) {
        this.tse = tse;
    }

    public String getTse_sq() {
        return tse_sq;
    }

    public void setTse_sq(String tse_sq) {
        this.tse_sq = tse_sq;
    }
}
