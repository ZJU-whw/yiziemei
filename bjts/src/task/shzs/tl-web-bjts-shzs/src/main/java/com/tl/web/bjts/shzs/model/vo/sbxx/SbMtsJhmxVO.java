package com.tl.web.bjts.shzs.model.vo.sbxx;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @描述: 外贸免退税进货明细返回对象
 * @作者: likun
 * @时间: 2022/4/21 16:33
 */
public class SbMtsJhmxVO {
    private String sbxh; // 申报序号
    private String sz; //税种
    private String jhpzh; //进货凭证号
    private String ghfnsrsbh; //供货商税号
    private String ghfnsrmc; //供货商名称
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date kprq; //开票日期
    private String spmcJh; //商品名称
    private BigDecimal sl; //数量
    private BigDecimal jsje; //计税金额
    private BigDecimal zssl; //征税率
    private BigDecimal tsl; //退税率
    private BigDecimal tse; //申报退税额

    private String lcslid;

    public String getLcslid() {
        return this.lcslid;

    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public String getSz() {
        return sz;
    }

    public void setSz(String sz) {
        this.sz = sz;
    }

    public String getJhpzh() {
        return jhpzh;
    }

    public void setJhpzh(String jhpzh) {
        this.jhpzh = jhpzh;
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

    public Date getKprq() {
        return kprq;
    }

    public void setKprq(Date kprq) {
        this.kprq = kprq;
    }

    public String getSpmcJh() {
        return spmcJh;
    }

    public void setSpmcJh(String spmcJh) {
        this.spmcJh = spmcJh;
    }

    public BigDecimal getSl() {
        return sl;
    }

    public void setSl(BigDecimal sl) {
        this.sl = sl;
    }

    public BigDecimal getJsje() {
        return jsje;
    }

    public void setJsje(BigDecimal jsje) {
        this.jsje = jsje;
    }

    public BigDecimal getZssl() {
        return zssl;
    }

    public void setZssl(BigDecimal zssl) {
        this.zssl = zssl;
    }

    public BigDecimal getTsl() {
        return tsl;
    }

    public void setTsl(BigDecimal tsl) {
        this.tsl = tsl;
    }

    public BigDecimal getTse() {
        return tse;
    }

    public void setTse(BigDecimal tse) {
        this.tse = tse;
    }

    public String getSbxh() {
        return sbxh;
    }

    public void setSbxh(String sbxh) {
        this.sbxh = sbxh;
    }
}
