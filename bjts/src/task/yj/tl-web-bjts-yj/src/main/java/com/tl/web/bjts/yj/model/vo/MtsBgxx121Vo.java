package com.tl.web.bjts.yj.model.vo;

import java.math.BigDecimal;

/**
 * 免退税报关单信息VO - 用于121指标（外贸企业）
 * 接收selectMtsBgxx121 SQL查询结果
 * 比MdtBgxx121Vo多了glh、ghfnsrsbh_1、jhpzh字段
 */
public class MtsBgxx121Vo {

    /** 企业登记序号 */
    private String djxh;

    /** 报关单号（18位归并号） */
    private String bgdhgbh;

    /** 关联号 */
    private String glh;

    /** 代理证明号/领货凭证号 */
    private String dlzmh;

    /** 特殊模式下单方式代码 */
    private String tmsjsffDm;

    /** 免抵退按钮 */
    private BigDecimal mylaj;

    /** 商品大类代码 */
    private String spdlDm;

    /** 出库日期 */
    private String ckrq1;

    /** 运输方式代码 */
    private String ysfsDm;

    /** 收货单位所在 */
    private String hzdwdqDm;

    /** 海关进口口岸代码 */
    private String hggqkaDm;

    /** 征税MD管地所代码 */
    private String zzmdgdqszDm;

    /** 出口发票号 */
    private String ckfph;

    /** 提运单号 */
    private String tydh;

    /** 供货方纳税人识别号 */
    private String ghfnsrsbh1;

    /** 进货凭证号 */
    private String jhpzh;

    private String bz;

    public String getBz() {
        return this.bz;

    }

    public void setBz(String bz) {
        this.bz = bz;
    }

    // Getter and Setter
    public String getDjxh() {
        return djxh;
    }

    public void setDjxh(String djxh) {
        this.djxh = djxh;
    }

    public String getBgdhgbh() {
        return bgdhgbh;
    }

    public void setBgdhgbh(String bgdhgbh) {
        this.bgdhgbh = bgdhgbh;
    }

    public String getGlh() {
        return glh;
    }

    public void setGlh(String glh) {
        this.glh = glh;
    }

    public String getDlzmh() {
        return dlzmh;
    }

    public void setDlzmh(String dlzmh) {
        this.dlzmh = dlzmh;
    }

    public String getTmsjsffDm() {
        return tmsjsffDm;
    }

    public void setTmsjsffDm(String tmsjsffDm) {
        this.tmsjsffDm = tmsjsffDm;
    }

    public BigDecimal getMylaj() {
        return mylaj;
    }

    public void setMylaj(BigDecimal mylaj) {
        this.mylaj = mylaj;
    }

    public String getSpdlDm() {
        return spdlDm;
    }

    public void setSpdlDm(String spdlDm) {
        this.spdlDm = spdlDm;
    }

    public String getCkrq1() {
        return ckrq1;
    }

    public void setCkrq1(String ckrq1) {
        this.ckrq1 = ckrq1;
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

    public String getZzmdgdqszDm() {
        return zzmdgdqszDm;
    }

    public void setZzmdgdqszDm(String zzmdgdqszDm) {
        this.zzmdgdqszDm = zzmdgdqszDm;
    }

    public String getCkfph() {
        return ckfph;
    }

    public void setCkfph(String ckfph) {
        this.ckfph = ckfph;
    }

    public String getTydh() {
        return tydh;
    }

    public void setTydh(String tydh) {
        this.tydh = tydh;
    }

    public String getGhfnsrsbh1() {
        return ghfnsrsbh1;
    }

    public void setGhfnsrsbh1(String ghfnsrsbh1) {
        this.ghfnsrsbh1 = ghfnsrsbh1;
    }

    public String getJhpzh() {
        return jhpzh;
    }

    public void setJhpzh(String jhpzh) {
        this.jhpzh = jhpzh;
    }
}