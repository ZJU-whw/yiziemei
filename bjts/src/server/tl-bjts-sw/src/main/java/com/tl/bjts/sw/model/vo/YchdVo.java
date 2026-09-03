package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.ExcelSetting;

import javax.persistence.Column;
import java.util.Date;

public class YchdVo {
    @ExcelSetting(colTitleName = "供货企业税号")
    private String nsrsbh;
    @ExcelSetting(colTitleName = "供货企业名称")
    private String nsrmc;
    @ExcelSetting(colTitleName = "复函编号")
    private String fhbh;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @ExcelSetting(colTitleName = "复函日期")
    private Date fhrq;
    @ExcelSetting(colTitleName = "复函内容")
    private String fhnr;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @ExcelSetting(colTitleName = "同步时间")
    private Date tbsj;
    @ExcelSetting(colTitleName = "有效标志")
    private String yxbz;
    @ExcelSetting(colTitleName = "主管税务机关")
    private String zgswjgmc;

    public String getFhbh() {
        return fhbh;
    }

    public void setFhbh(String fhbh) {
        this.fhbh = fhbh;
    }

    public Date getFhrq() {
        return fhrq;
    }

    public void setFhrq(Date fhrq) {
        this.fhrq = fhrq;
    }

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

    public String getFhnr() {
        return fhnr;
    }

    public void setFhnr(String fhnr) {
        this.fhnr = fhnr;
    }

    public Date getTbsj() {
        return tbsj;
    }

    public void setTbsj(Date tbsj) {
        this.tbsj = tbsj;
    }

    public String getYxbz() {
        return yxbz;
    }

    public void setYxbz(String yxbz) {
        this.yxbz = yxbz;
    }
}
