package com.tl.bjts.sw.model;


import java.math.BigDecimal;

public class ProcParam {

    private String procname;

    private String V_SSNY;

    private String V_SWCODE;

    private String V_BBDLDM;

    private String V_MSG;

    private Integer V_ERROR;


    private BigDecimal P_DJXH;

    private String P_SSSQ;

    private String P_ZBDM;

    public BigDecimal getP_DJXH() {
        return this.P_DJXH;

    }

    public void setP_DJXH(BigDecimal p_DJXH) {
        this.P_DJXH = p_DJXH;
    }

    public String getP_SSSQ() {
        return this.P_SSSQ;

    }

    public void setP_SSSQ(String p_SSSQ) {
        this.P_SSSQ = p_SSSQ;
    }

    public String getP_ZBDM() {
        return this.P_ZBDM;

    }

    public void setP_ZBDM(String p_ZBDM) {
        this.P_ZBDM = p_ZBDM;
    }

    public String getV_BBDLDM() {
        return V_BBDLDM;
    }

    public void setV_BBDLDM(String v_BBDLDM) {
        V_BBDLDM = v_BBDLDM;
    }

    public String getProcname() {
        return procname;
    }

    public void setProcname(String procname) {
        this.procname = procname;
    }

    public String getV_SWCODE() {
        return V_SWCODE;
    }

    public void setV_SWCODE(String v_SWCODE) {
        V_SWCODE = v_SWCODE;
    }

    public String getV_MSG() {
        return V_MSG;
    }

    public void setV_MSG(String v_MSG) {
        V_MSG = v_MSG;
    }

    public Integer getV_ERROR() {
        return V_ERROR;
    }

    public void setV_ERROR(Integer v_ERROR) {
        V_ERROR = v_ERROR;
    }

    public String getV_SSNY() {
        return V_SSNY;
    }

    public void setV_SSNY(String v_SSNY) {
        V_SSNY = v_SSNY;
    }

    @Override
    public String toString() {
        return "ProcParam{" +
                "procname='" + procname + '\'' +
                ", V_SSNY='" + V_SSNY + '\'' +
                ", V_SWCODE='" + V_SWCODE + '\'' +
                ", V_MSG='" + V_MSG + '\'' +
                ", V_ERROR=" + V_ERROR +
                '}';
    }
}
