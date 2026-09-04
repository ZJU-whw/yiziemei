package com.tl.web.bjts.shzs.model.vo.sbxx;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.web.bjts.shzs.annotation.ConvertCode;
import com.tl.web.bjts.shzs.utils.ConstUtil;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @描述: 外综服代办退税明细表
 * @作者: likun
 * @时间: 2022/4/22 9:54
 */
public class SbWzfdbtsMxbVO {
    private Long sbid; // 申报id（前端隐藏）
    private String sbxh; // 申报序号
    private String wtqynsrsbh; // 委托企业识别号
    private String ckbgdh; // 报关单号
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date ckrq; // 出口日期
    private String spdm; // 商品代码
    private String spmc; // 商品名称
    private String spdmSb; // 申报商品代码
    private String jldw; // 单位
    private BigDecimal cksl; // 出口数量
    private BigDecimal mylaj; // 美元离岸价
    private String jhpzh; // 代办退税发票号码
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date kprq; // 开票日期
    private BigDecimal jsje; // 计税金额
    private BigDecimal zssl; // 征税率
    private BigDecimal tsl; // 退税率
    private BigDecimal tse; // 应退税额
    private String ywlxmc; // 业务类型
    private String hwlx; // 货物类型
    private String hgcode; // 出口口岸(前端隐藏)
    @ConvertCode(dtype = ConstUtil.DICT_HGCODE)
    private String hgcodeName; // 出口口岸(已转换为中文)
    private String gbcode; // 出口国别(前端隐藏)
    @ConvertCode(dtype = ConstUtil.DICT_GBCODE)
    private String gbcodeName; // 出口国别(已转换为中文)
    private String hzdwdqdm; // 货源地
    @ConvertCode(dtype = ConstUtil.DICT_HYDCODE)
    private String hzdwdqdmName; //货源地(已转换为中文)
    private String bz; // 备注

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public String getSbxh() {
        return sbxh;
    }

    public void setSbxh(String sbxh) {
        this.sbxh = sbxh;
    }

    public String getWtqynsrsbh() {
        return wtqynsrsbh;
    }

    public void setWtqynsrsbh(String wtqynsrsbh) {
        this.wtqynsrsbh = wtqynsrsbh;
    }

    public String getCkbgdh() {
        return ckbgdh;
    }

    public void setCkbgdh(String ckbgdh) {
        this.ckbgdh = ckbgdh;
    }

    public Date getCkrq() {
        return ckrq;
    }

    public void setCkrq(Date ckrq) {
        this.ckrq = ckrq;
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

    public String getSpdmSb() {
        return spdmSb;
    }

    public void setSpdmSb(String spdmSb) {
        this.spdmSb = spdmSb;
    }

    public String getJldw() {
        return jldw;
    }

    public void setJldw(String jldw) {
        this.jldw = jldw;
    }

    public BigDecimal getCksl() {
        return cksl;
    }

    public void setCksl(BigDecimal cksl) {
        this.cksl = cksl;
    }

    public BigDecimal getMylaj() {
        return mylaj;
    }

    public void setMylaj(BigDecimal mylaj) {
        this.mylaj = mylaj;
    }

    public String getJhpzh() {
        return jhpzh;
    }

    public void setJhpzh(String jhpzh) {
        this.jhpzh = jhpzh;
    }

    public Date getKprq() {
        return kprq;
    }

    public void setKprq(Date kprq) {
        this.kprq = kprq;
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

    public String getYwlxmc() {
        return ywlxmc;
    }

    public void setYwlxmc(String ywlxmc) {
        this.ywlxmc = ywlxmc;
    }

    public String getHwlx() {
        return hwlx;
    }

    public void setHwlx(String hwlx) {
        this.hwlx = hwlx;
    }

    public String getHgcode() {
        return hgcode;
    }

    public void setHgcode(String hgcode) {
        this.hgcode = hgcode;
    }

    public String getHgcodeName() {
        return hgcodeName;
    }

    public void setHgcodeName(String hgcodeName) {
        this.hgcodeName = hgcodeName;
    }

    public String getGbcode() {
        return gbcode;
    }

    public void setGbcode(String gbcode) {
        this.gbcode = gbcode;
    }

    public String getGbcodeName() {
        return gbcodeName;
    }

    public void setGbcodeName(String gbcodeName) {
        this.gbcodeName = gbcodeName;
    }

    public String getHzdwdqdm() {
        return hzdwdqdm;
    }

    public void setHzdwdqdm(String hzdwdqdm) {
        this.hzdwdqdm = hzdwdqdm;
    }

    public String getHzdwdqdmName() {
        return hzdwdqdmName;
    }

    public void setHzdwdqdmName(String hzdwdqdmName) {
        this.hzdwdqdmName = hzdwdqdmName;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }
}
