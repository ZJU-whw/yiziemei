package com.tl.bjts.sw.model.vo.sbxx;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.bjts.swgl.general.annotation.Dict;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @描述: 申报信息查询返回vo
 * @作者: likun
 * @时间: 2022/9/6 11:40
 */
public class SbxxQueryVO {
    private Long sbid; //申报id(前端隐藏)
    private Long nsrdzdah; //纳税人电子档案号(前端隐藏)
    private String swjgdm; //税务机关代码
    private String swjgmc; //税务机关名称
    private String nsrsbh; //纳税人识别号
    private String qyhgdm; //企业海关代码
    private String nsrmc; //纳税人名称
    private String qylx; //企业类型(前端隐藏)
    @Dict("qylx_dm")
    private String qylxZh; //企业类型(已转换为中文)
    private String sbywb; //申报业务代码(前端隐藏)
    @Dict("ywlx_dm")
    private String sbywbZh; //申报业务名称(已转换为中文)
    private String sssq; //所属期
    private String sbpc; //申报批次
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date sbrq; //申报提交日期
    private String sbzt; //申报状态代码(前端隐藏)
    @Dict("sbzt_dm")
    private String sbztZh; //申报状态(已转换为中文)
    private String fkxx; //反馈信息
    private String lyZh; // 来源(单一窗口、出口退税)
    private Integer fjsl; //附件数量

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

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getSwjgmc() {
        return swjgmc;
    }

    public void setSwjgmc(String swjgmc) {
        this.swjgmc = swjgmc;
    }

    public String getNsrsbh() {
        return nsrsbh;
    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getQyhgdm() {
        return qyhgdm;
    }

    public void setQyhgdm(String qyhgdm) {
        this.qyhgdm = qyhgdm;
    }

    public String getNsrmc() {
        return nsrmc;
    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }

    public String getQylx() {
        return qylx;
    }

    public void setQylx(String qylx) {
        this.qylx = qylx;
    }

    public String getQylxZh() {
        return qylxZh;
    }

    public void setQylxZh(String qylxZh) {
        this.qylxZh = qylxZh;
    }

    public String getLyZh() {
        return lyZh;
    }

    public void setLyZh(String lyZh) {
        this.lyZh = lyZh;
    }

    public String getSbywb() {
        return sbywb;
    }

    public void setSbywb(String sbywb) {
        this.sbywb = sbywb;
    }

    public String getSbywbZh() {
        return sbywbZh;
    }

    public void setSbywbZh(String sbywbZh) {
        this.sbywbZh = sbywbZh;
    }

    public String getSssq() {
        return sssq;
    }

    public void setSssq(String sssq) {
        this.sssq = sssq;
    }

    public String getSbpc() {
        return sbpc;
    }

    public void setSbpc(String sbpc) {
        this.sbpc = sbpc;
    }

    public Date getSbrq() {
        return sbrq;
    }

    public void setSbrq(Date sbrq) {
        this.sbrq = sbrq;
    }

    public String getSbzt() {
        return sbzt;
    }

    public void setSbzt(String sbzt) {
        this.sbzt = sbzt;
    }

    public String getSbztZh() {
        return sbztZh;
    }

    public void setSbztZh(String sbztZh) {
        this.sbztZh = sbztZh;
    }

    public String getFkxx() {
        return fkxx;
    }

    public void setFkxx(String fkxx) {
        this.fkxx = fkxx;
    }

    public Integer getFjsl() {
        return fjsl;
    }

    public void setFjsl(Integer fjsl) {
        this.fjsl = fjsl;
    }

    @Override
    public String toString() {
        return "SbxxQueryVO{" +
                "sbid=" + sbid +
                ", nsrdzdah=" + nsrdzdah +
                ", swjgdm='" + swjgdm + '\'' +
                ", swjgmc='" + swjgmc + '\'' +
                ", nsrsbh='" + nsrsbh + '\'' +
                ", qyhgdm='" + qyhgdm + '\'' +
                ", nsrmc='" + nsrmc + '\'' +
                ", qylx='" + qylx + '\'' +
                ", qylxZh='" + qylxZh + '\'' +
                ", sbywb='" + sbywb + '\'' +
                ", sbywbZh='" + sbywbZh + '\'' +
                ", sssq='" + sssq + '\'' +
                ", sbpc='" + sbpc + '\'' +
                ", sbrq=" + sbrq +
                ", sbzt='" + sbzt + '\'' +
                ", sbztZh='" + sbztZh + '\'' +
                ", fkxx='" + fkxx + '\'' +
                ", lyZh='" + lyZh + '\'' +
                ", fjsl=" + fjsl +
                '}';
    }
}
