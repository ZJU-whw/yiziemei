package com.tl.bjts.sw.model.bo;


import java.math.BigDecimal;
import java.util.Date;

/**
 * @Description: 物流链路二维码参数数据BO
 * @Author: sxf
 * @Date: 2026-07-21
 */
public class CkllfxQrDataBO {

    /** 出口报关单号 */
    private String bgdhgbh;

    /** 车牌号 */
    private String cph;

    /** 起运日 */
    private Date qyrq;

    /** 起运地 */
    private String qydAddr;

    /** 车牌颜色(1：蓝色；2：黄色；3：黄绿色) */
    private String cpysCode;

    /** 纳税人识别号 */
    private String nsrsbh;

    /** 企业名称 */
    private String nsrmc;

    /** 税务机关 */
    private String swjgdm;

    /** 出口日期 */
    private Date ckrq;

    /** 美元离岸价 */
    private BigDecimal mylaj;

    /** 商品代码 */
    private String spDm;

    /** 商品名称 */
    private String spMc;

    /** 运输方式代码 */
    private String ysfsDm;

    /** 境内货源地代码 */
    private String hzdwdqDm;

    /** 离境口岸代码 */
    private String hggqkaDm;

    /** 集装箱号 */
    private String jzxh;

    /** 目的国代码 */
    private String zzmdgdqszDm;

    /** 提运单号 */
    private String tydh;

    /** 供应商税号 */
    private String ghfnsrsbh;

    /** 供应商名称 */
    private String ghfnsrmc;

    /** 供应商主管税务机关 */
    private String ghfnsrswjg;

    /** 发货模式代码(1:整柜；2:散货(拼箱);) */
    private String fhmsDm;

    public String getBgdhgbh() {
        return bgdhgbh;
    }

    public void setBgdhgbh(String bgdhgbh) {
        this.bgdhgbh = bgdhgbh;
    }

    public String getCph() {
        return cph;
    }

    public void setCph(String cph) {
        this.cph = cph;
    }

    public Date getQyrq() {
        return qyrq;
    }

    public void setQyrq(Date qyrq) {
        this.qyrq = qyrq;
    }

    public String getQydAddr() {
        return qydAddr;
    }

    public void setQydAddr(String qydAddr) {
        this.qydAddr = qydAddr;
    }

    public String getCpysCode() {
        return cpysCode;
    }

    public void setCpysCode(String cpysCode) {
        this.cpysCode = cpysCode;
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

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public Date getCkrq() {
        return ckrq;
    }

    public void setCkrq(Date ckrq) {
        this.ckrq = ckrq;
    }

    public BigDecimal getMylaj() {
        return mylaj;
    }

    public void setMylaj(BigDecimal mylaj) {
        this.mylaj = mylaj;
    }

    public String getSpDm() {
        return spDm;
    }

    public void setSpDm(String spDm) {
        this.spDm = spDm;
    }

    public String getSpMc() {
        return spMc;
    }

    public void setSpMc(String spMc) {
        this.spMc = spMc;
    }

    public String getYsfsDm() {
        return ysfsDm;
    }

    public void setYsfsDm(String ysfsDm) {
        this.ysfsDm = ysfsDm;
    }

    public String getHzdwdqDm() {
        return hzdwdqDm;
    }

    public void setHzdwdqDm(String hzdwdqDm) {
        this.hzdwdqDm = hzdwdqDm;
    }

    public String getHggqkaDm() {
        return hggqkaDm;
    }

    public void setHggqkaDm(String hggqkaDm) {
        this.hggqkaDm = hggqkaDm;
    }

    public String getJzxh() {
        return jzxh;
    }

    public void setJzxh(String jzxh) {
        this.jzxh = jzxh;
    }

    public String getZzmdgdqszDm() {
        return zzmdgdqszDm;
    }

    public void setZzmdgdqszDm(String zzmdgdqszDm) {
        this.zzmdgdqszDm = zzmdgdqszDm;
    }

    public String getTydh() {
        return tydh;
    }

    public void setTydh(String tydh) {
        this.tydh = tydh;
    }

    public String getGhfnsrsbh() {
        return ghfnsrsbh;
    }

    public void setGhfnsrsbh(String ghfnsrsbh) {
        this.ghfnsrsbh = ghfnsrsbh;
    }

    public String getGhfnsrmc() {
        return ghfnsrmc;
    }

    public void setGhfnsrmc(String ghfnsrmc) {
        this.ghfnsrmc = ghfnsrmc;
    }

    public String getGhfnsrswjg() {
        return ghfnsrswjg;
    }

    public void setGhfnsrswjg(String ghfnsrswjg) {
        this.ghfnsrswjg = ghfnsrswjg;
    }

    public String getFhmsDm() {
        return fhmsDm;
    }

    public void setFhmsDm(String fhmsDm) {
        this.fhmsDm = fhmsDm;
    }

    @Override
    public String toString() {
        return "CkllfxQrDataBO{" +
                "bgdhgbh='" + bgdhgbh + '\'' +
                ", cph='" + cph + '\'' +
                ", qyrq=" + qyrq +
                ", qydAddr='" + qydAddr + '\'' +
                ", cpysCode='" + cpysCode + '\'' +
                ", nsrsbh='" + nsrsbh + '\'' +
                ", nsrmc='" + nsrmc + '\'' +
                ", swjgdm='" + swjgdm + '\'' +
                ", ckrq=" + ckrq +
                ", mylaj=" + mylaj +
                ", spDm='" + spDm + '\'' +
                ", spMc='" + spMc + '\'' +
                ", ysfsDm='" + ysfsDm + '\'' +
                ", hzdwdqDm='" + hzdwdqDm + '\'' +
                ", hggqkaDm='" + hggqkaDm + '\'' +
                ", jzxh='" + jzxh + '\'' +
                ", zzmdgdqszDm='" + zzmdgdqszDm + '\'' +
                ", tydh='" + tydh + '\'' +
                ", ghfnsrsbh='" + ghfnsrsbh + '\'' +
                ", ghfnsrmc='" + ghfnsrmc + '\'' +
                ", ghfnsrswjg='" + ghfnsrswjg + '\'' +
                ", fhmsDm='" + fhmsDm + '\'' +
                '}';
    }
}
