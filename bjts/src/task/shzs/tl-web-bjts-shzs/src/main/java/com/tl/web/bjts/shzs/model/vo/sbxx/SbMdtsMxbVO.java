package com.tl.web.bjts.shzs.model.vo.sbxx;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.web.bjts.shzs.annotation.ConvertCode;
import com.tl.web.bjts.shzs.utils.ConstUtil;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @描述: 生产免抵退税明细表返回vo
 * @作者: likun
 * @时间: 2022/4/20 17:03
 */
public class SbMdtsMxbVO {

    private String djxh;

    private Long sbid; // 申报id（前端隐藏）
    private String sbxh; // 申报序号
    private String ckfph; // 出口发票号
    private String ckbgdh; // 报关单号
    private String dlzmh; // 代理证明号
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date ckrq; // 出口日期
    private String spdm; // 商品代码
    private String spmc; // 商品名称
    private String spdmSb; // 申报商品代码
    private String jldw; // 单位
    private BigDecimal cksl; // 出口数量
    private BigDecimal mylaj; // 美元离岸价
    private BigDecimal rmblaj; // 出口销售额
    private BigDecimal zssl; // 征税率
    private BigDecimal tsl; // 退税率
    private String jgmysch; // 进料登记册号
    private BigDecimal fplvJh; // 计划分配率
    private BigDecimal ztsceHw; // 不得免征抵扣税额
    private BigDecimal mdtseHw; // 免抵退税额
    private String ywlxmc; // 业务类型
    private String jckhth; // 先退后核合同号
    private String hgcode; // 出口口岸(前端隐藏)
    @ConvertCode(dtype = ConstUtil.DICT_HGCODE)
    private String hgcodeName; // 出口口岸(已转换为中文)
    private String gbcode; // 出口国别(前端隐藏)
    @ConvertCode(dtype = ConstUtil.DICT_GBCODE)
    private String gbcodeName; // 出口国别(已转换为中文)
    private String bz; // 备注
    private String gzxx; // 关注信息


    public String getDjxh() {
        return this.djxh;

    }

    public void setDjxh(String djxh) {
        this.djxh = djxh;
    }

    public String getGzxx() {
        return this.gzxx;

    }

    public void setGzxx(String gzxx) {
        this.gzxx = gzxx;
    }

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

    public String getCkfph() {
        return ckfph;
    }

    public void setCkfph(String ckfph) {
        this.ckfph = ckfph;
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

    public BigDecimal getRmblaj() {
        return rmblaj;
    }

    public void setRmblaj(BigDecimal rmblaj) {
        this.rmblaj = rmblaj;
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

    public String getJgmysch() {
        return jgmysch;
    }

    public void setJgmysch(String jgmysch) {
        this.jgmysch = jgmysch;
    }

    public BigDecimal getFplvJh() {
        return fplvJh;
    }

    public void setFplvJh(BigDecimal fplvJh) {
        this.fplvJh = fplvJh;
    }

    public BigDecimal getZtsceHw() {
        return ztsceHw;
    }

    public void setZtsceHw(BigDecimal ztsceHw) {
        this.ztsceHw = ztsceHw;
    }

    public BigDecimal getMdtseHw() {
        return mdtseHw;
    }

    public void setMdtseHw(BigDecimal mdtseHw) {
        this.mdtseHw = mdtseHw;
    }

    public String getYwlxmc() {
        return ywlxmc;
    }

    public void setYwlxmc(String ywlxmc) {
        this.ywlxmc = ywlxmc;
    }

    public String getJckhth() {
        return jckhth;
    }

    public void setJckhth(String jckhth) {
        this.jckhth = jckhth;
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

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }

    public String getDlzmh() {
        return dlzmh;
    }

    public void setDlzmh(String dlzmh) {
        this.dlzmh = dlzmh;
    }
}
