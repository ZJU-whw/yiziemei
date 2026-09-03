package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

/**
 * @author: Mamf
 * @date: 2021/11/29
 * @description
 */
public class NsrxxQueryDTO extends BaseListDTO {

    private String nsrsbh;

    private String qyhgdm;

    private String nsrmc;

    private Long zid;

    private String tjbbType;

    public String getTjbbType() {
        return this.tjbbType;

    }

    public void setTjbbType(String tjbbType) {
        this.tjbbType = tjbbType;
    }

    public Long getZid() {
        return this.zid;

    }

    public void setZid(Long zid) {
        this.zid = zid;
    }

    public String getNsrsbh() {
        return this.nsrsbh;

    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getQyhgdm() {
        return this.qyhgdm;

    }

    public void setQyhgdm(String qyhgdm) {
        this.qyhgdm = qyhgdm;
    }

    public String getNsrmc() {
        return this.nsrmc;

    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }
}
