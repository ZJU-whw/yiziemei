package com.tl.web.bjts.shzs.model.dto.dbwp;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.ExcelSetting;

import java.util.Date;

/**
 * @description 待办任务明细试图对象
 * @author: Mamf
 * @date: 2024/9/18 17:09
 */
public class DbrwmxVo {

    @ExcelSetting(colTitleName = "申报日期")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date rwfqsj;

    @ExcelSetting(colTitleName = "任务名称")
    private String rwmc;

    @ExcelSetting(colTitleName = "事项名称")
    private String lcswsxMc;

    @ExcelSetting(colTitleName = "所属期")
    private String sssq;

    @ExcelSetting(colTitleName = "环节")
    private String lzhj;

    @ExcelSetting(colTitleName = "企业名称")
    private String nsrmc;

    @ExcelSetting(colTitleName = "分类管理")
    private String flglcd;

    @ExcelSetting(colTitleName = "企业分组")
    private String wpdxqyfz;

    @ExcelSetting(colTitleName = "委派对象")
    private String wpdx;

    @ExcelSetting(colTitleName = "委派结果")
    private String wpjg;

    @ExcelSetting(colTitleName = "岗位名称")
    private String gwmc;

    @ExcelSetting(colTitleName = "流程实例ID")
    private String lcslid;

    @ExcelSetting(colTitleName = "录入人代码")
    private String rwfqrmc;

    private String lcswsxDm;


    private String nsrsbh;

    private String jdmode;

    private String gzxid;


    public String getLzhj() {
        return this.lzhj;

    }

    public void setLzhj(String lzhj) {
        this.lzhj = lzhj;
    }

    public String getFlglcd() {
        return this.flglcd;

    }

    public void setFlglcd(String flglcd) {
        this.flglcd = flglcd;
    }

    public String getRwmc() {
        return this.rwmc;

    }

    public void setRwmc(String rwmc) {
        this.rwmc = rwmc;
    }

    public String getJdmode() {
        return this.jdmode;

    }

    public void setJdmode(String jdmode) {
        this.jdmode = jdmode;
    }

    public String getWpdxqyfz() {
        return this.wpdxqyfz;

    }

    public void setWpdxqyfz(String wpdxqyfz) {
        this.wpdxqyfz = wpdxqyfz;
    }

    public String getWpdx() {
        return this.wpdx;

    }

    public void setWpdx(String wpdx) {
        this.wpdx = wpdx;
    }

    public String getWpjg() {
        return this.wpjg;

    }

    public void setWpjg(String wpjg) {
        this.wpjg = wpjg;
    }

    public Date getRwfqsj() {
        return this.rwfqsj;

    }

    public void setRwfqsj(Date rwfqsj) {
        this.rwfqsj = rwfqsj;
    }

    public String getLcswsxDm() {
        return this.lcswsxDm;

    }

    public void setLcswsxDm(String lcswsxDm) {
        this.lcswsxDm = lcswsxDm;
    }

    public String getLcswsxMc() {
        return this.lcswsxMc;

    }

    public void setLcswsxMc(String lcswsxMc) {
        this.lcswsxMc = lcswsxMc;
    }

    public String getSssq() {
        return this.sssq;

    }

    public void setSssq(String sssq) {
        this.sssq = sssq;
    }

    public String getNsrmc() {
        return this.nsrmc;

    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }

    public String getNsrsbh() {
        return this.nsrsbh;

    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getGwmc() {
        return this.gwmc;

    }

    public void setGwmc(String gwmc) {
        this.gwmc = gwmc;
    }

    public String getLcslid() {
        return this.lcslid;

    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public String getRwfqrmc() {
        return this.rwfqrmc;

    }

    public void setRwfqrmc(String rwfqrmc) {
        this.rwfqrmc = rwfqrmc;
    }

    public String getGzxid() {
        return this.gzxid;

    }

    public void setGzxid(String gzxid) {
        this.gzxid = gzxid;
    }
}
