package com.tl.web.bjts.yj.model.vo;

import java.math.BigDecimal;

/**
 * @description 海关报关单数据视图对象
 * @author: Mamf
 * @date: 2026/5/9 12:40
 */
public class CustomsDeclarationVo{

    /**
     * 流程实例ID
     */
    private String lcslid;

    /**
     * 登记序号
     */
    private String djxh;

    /**
     * 关联号
     */
    private String glh;

    /**
     * 购货方纳税人识别号
     */
    private String ghfnsrsbh1;

    /**
     * 进货凭证号码
     */
    private String jhpzh;

    /**
     * 计税金额
     */
    private BigDecimal jsje;

    /**
     * 美元离岸价
     */
    private BigDecimal mylaj;

    /**
     * 退税额
     */
    private BigDecimal tse;

    /**
     * 商品大类代码
     */
    private String spdlDm;

    /**
     * 运输方式代码
     */
    private String ysfsDm;


    private String zzmdgdqszDm;

    /**
     * 海关口岸代码
     */
    private String hggqkaDm;

    public BigDecimal getTse() {
        return this.tse;

    }

    public void setTse(BigDecimal tse) {
        this.tse = tse;
    }

    public String getLcslid() {
        return this.lcslid;

    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public String getDjxh() {
        return this.djxh;

    }

    public void setDjxh(String djxh) {
        this.djxh = djxh;
    }

    public String getGlh() {
        return this.glh;

    }

    public void setGlh(String glh) {
        this.glh = glh;
    }

    public String getGhfnsrsbh1() {
        return this.ghfnsrsbh1;

    }

    public void setGhfnsrsbh1(String ghfnsrsbh1) {
        this.ghfnsrsbh1 = ghfnsrsbh1;
    }

    public String getJhpzh() {
        return this.jhpzh;

    }

    public void setJhpzh(String jhpzh) {
        this.jhpzh = jhpzh;
    }

    public BigDecimal getJsje() {
        return this.jsje;

    }

    public void setJsje(BigDecimal jsje) {
        this.jsje = jsje;
    }

    public BigDecimal getMylaj() {
        return this.mylaj;

    }

    public void setMylaj(BigDecimal mylaj) {
        this.mylaj = mylaj;
    }

    public String getSpdlDm() {
        return this.spdlDm;

    }

    public void setSpdlDm(String spdlDm) {
        this.spdlDm = spdlDm;
    }

    public String getYsfsDm() {
        return this.ysfsDm;

    }

    public void setYsfsDm(String ysfsDm) {
        this.ysfsDm = ysfsDm;
    }

    public String getZzmdgdqszDm() {
        return this.zzmdgdqszDm;

    }

    public void setZzmdgdqszDm(String zzmdgdqszDm) {
        this.zzmdgdqszDm = zzmdgdqszDm;
    }

    public String getHggqkaDm() {
        return this.hggqkaDm;

    }

    public void setHggqkaDm(String hggqkaDm) {
        this.hggqkaDm = hggqkaDm;
    }
}
