package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

public class QspjdjDTO extends BaseListDTO {
    private String spdm;
    private String spmc;
    private String djq;
    private String djz;

    private String type;  //1.生成 2.外贸

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
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

    public String getDjq() {
        return djq;
    }

    public void setDjq(String djq) {
        this.djq = djq;
    }

    public String getDjz() {
        return djz;
    }

    public void setDjz(String djz) {
        this.djz = djz;
    }
}
