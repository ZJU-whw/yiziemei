package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

/**
 * 报关单关注信息查询DTO
 */
public class YjBgdgzxxDTO extends BaseListDTO {

    private String swjgdm;

    /** 金三企业登记序号 */
    private String djxh;

    /** 出口报关单号 */
    private String ckbgdh;

    /** 企业税号 */
    private String nsrsbh;

    /** 企业名称 */
    private String nsrmc;

    /** 是否作废 */
    private String sfzf;

    /** 操作人代码 */
    private String czrDm;

    /** 操作日期起 */
    private String czrqStart;

    /** 操作日期止 */
    private String czrqEnd;

    public String getSwjgdm() {
        return this.swjgdm;

    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getDjxh() {
        return djxh;
    }

    public void setDjxh(String djxh) {
        this.djxh = djxh;
    }

    public String getCkbgdh() {
        return ckbgdh;
    }

    public void setCkbgdh(String ckbgdh) {
        this.ckbgdh = ckbgdh;
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

    public String getSfzf() {
        return sfzf;
    }

    public void setSfzf(String sfzf) {
        this.sfzf = sfzf;
    }

    public String getCzrDm() {
        return czrDm;
    }

    public void setCzrDm(String czrDm) {
        this.czrDm = czrDm;
    }

    public String getCzrqStart() {
        return czrqStart;
    }

    public void setCzrqStart(String czrqStart) {
        this.czrqStart = czrqStart;
    }

    public String getCzrqEnd() {
        return czrqEnd;
    }

    public void setCzrqEnd(String czrqEnd) {
        this.czrqEnd = czrqEnd;
    }
}
