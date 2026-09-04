package com.tl.web.bjts.yj.model;

import java.math.BigDecimal;

/**
 * @Author：Mamf
 * @Date: 2019/7/29.
 * @Description:
 */
public class YjPramDTO {

    private Long sbid;

    private String nsrsbh;

    private Long nsrdzdah;

    private String sbympc;

    private String swjgdm;

    private String pval1;

    private String pval2;

    private String cpcode;

    private String lcslid;

    private BigDecimal djxh;

    public BigDecimal getDjxh() {
        return this.djxh;

    }

    public void setDjxh(BigDecimal djxh) {
        this.djxh = djxh;
    }

    public String getLcslid() {
        return this.lcslid;

    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public String getNsrsbh() {
        return this.nsrsbh;

    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getCpcode() {
        return this.cpcode;

    }

    public void setCpcode(String cpcode) {
        this.cpcode = cpcode;
    }

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public Long getNsrdzdah() {
        return nsrdzdah;
    }

    public void setNsrdzdah(Long nsrdzdah) {
        this.nsrdzdah = nsrdzdah;
    }

    public String getSbympc() {
        return sbympc;
    }

    public void setSbympc(String sbympc) {
        this.sbympc = sbympc;
    }

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getPval1() {
        return pval1;
    }

    public void setPval1(String pval1) {
        this.pval1 = pval1;
    }

    public String getPval2() {
        return pval2;
    }

    public void setPval2(String pval2) {
        this.pval2 = pval2;
    }

    @Override
    public String toString() {
        return "YjPramDTO{" +
                "sbid=" + sbid +
                ", nsrdzdah=" + nsrdzdah +
                ", sbympc='" + sbympc + '\'' +
                ", swjgdm='" + swjgdm + '\'' +
                ", pval1='" + pval1 + '\'' +
                ", pval2='" + pval2 + '\'' +
                '}';
    }
}
