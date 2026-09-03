package com.tl.bjts.sw.model.dto;

import com.tl.bjts.sw.model.PageParam;
import com.tl.common.ext.model.BaseListDTO;

import java.util.Date;

/**
 * 外贸敏感口岸信息库维护
 */
public class WmMgkaDTO extends BaseListDTO {
    private String kaCode;//口岸代码
    private String kaName;
    private Date jkDate;//监控日期

    private String spdm;
    private String spmc;

    private String nsrsbh;//企业税号
    private String nsrmc;

    private Boolean isExport=false;


    public Boolean getExport() {
        return isExport;
    }

    public void setExport(Boolean export) {
        isExport = export;
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

    public String getKaCode() {
        return kaCode;
    }

    public void setKaCode(String kaCode) {
        this.kaCode = kaCode;
    }

    public String getKaName() {
        return kaName;
    }

    public void setKaName(String kaName) {
        this.kaName = kaName;
    }

    public Date getJkDate() {
        return jkDate;
    }

    public void setJkDate(Date jkDate) {
        this.jkDate = jkDate;
    }
}
