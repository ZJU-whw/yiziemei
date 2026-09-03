package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

import java.util.Date;

public class YchdDTO extends BaseListDTO {

    private String nsrsbh;//企业税号
    private String nsrmc;
    private Date fhrqq;
    private Date fhrqz;
    private Boolean isExport =false;


    public Boolean getExport() {
        return isExport;
    }

    public void setExport(Boolean export) {
        isExport = export;
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

    public Date getFhrqq() {
        return fhrqq;
    }

    public void setFhrqq(Date fhrqq) {
        this.fhrqq = fhrqq;
    }

    public Date getFhrqz() {
        return fhrqz;
    }

    public void setFhrqz(Date fhrqz) {
        this.fhrqz = fhrqz;
    }
}
