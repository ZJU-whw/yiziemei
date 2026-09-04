package com.tl.web.bjts.shzs.model.vo.sbxx;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.web.bjts.shzs.annotation.ConvertCode;
import com.tl.web.bjts.shzs.utils.ConstUtil;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * @描述: 外贸免退税出口明细返回对象
 * @作者: likun
 * @时间: 2022/4/21 16:29
 */
public class SbMtsCkmxVO {

    private String lcslid;

    private String djxh;

    private Long sbid; // 申报id（前端隐藏）
    private String sbxh; // 申报序号
    private String glh; // 关联号
    private String ckfph; // 出口发票号
    private String ckbgdh; // 报关单号
    private String dlzmh; // 代理证明号
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date ckrq; // 出口日期
    private String spdm; // 商品代码
    private String spmc; // 商品名称
    private String jldw; // 单位
    private BigDecimal cksl; // 出口数量
    private BigDecimal mylaj; // 美元离岸价
    private String ywlxmc; // 业务类型
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
    private List<SbMtsJhmxVO> jhmx; // 进货明细

    //以下为进货明细部分
    private String sbxhJh; // 申报序号
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

    private String gzxx; // 关注信息

    private BigDecimal zrmbxse;

    private BigDecimal mmyllr;

    public BigDecimal getZrmbxse() {
        return this.zrmbxse;

    }

    public void setZrmbxse(BigDecimal zrmbxse) {
        this.zrmbxse = zrmbxse;
    }

    public BigDecimal getMmyllr() {
        return this.mmyllr;

    }

    public void setMmyllr(BigDecimal mmyllr) {
        this.mmyllr = mmyllr;
    }

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

    public String getLcslid() {
        return this.lcslid;

    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public String getSbxhJh() {
        return this.sbxhJh;

    }

    public void setSbxhJh(String sbxhJh) {
        this.sbxhJh = sbxhJh;
    }

    public String getSz() {
        return this.sz;

    }

    public void setSz(String sz) {
        this.sz = sz;
    }

    public String getJhpzh() {
        return this.jhpzh;

    }

    public void setJhpzh(String jhpzh) {
        this.jhpzh = jhpzh;
    }

    public String getGhfnsrsbh() {
        return this.ghfnsrsbh;

    }

    public void setGhfnsrsbh(String ghfnsrsbh) {
        this.ghfnsrsbh = ghfnsrsbh;
    }

    public String getGhfnsrmc() {
        return this.ghfnsrmc;

    }

    public void setGhfnsrmc(String ghfnsrmc) {
        this.ghfnsrmc = ghfnsrmc;
    }

    public Date getKprq() {
        return this.kprq;

    }

    public void setKprq(Date kprq) {
        this.kprq = kprq;
    }

    public String getSpmcJh() {
        return this.spmcJh;

    }

    public void setSpmcJh(String spmcJh) {
        this.spmcJh = spmcJh;
    }

    public BigDecimal getSl() {
        return this.sl;

    }

    public void setSl(BigDecimal sl) {
        this.sl = sl;
    }

    public BigDecimal getJsje() {
        return this.jsje;

    }

    public void setJsje(BigDecimal jsje) {
        this.jsje = jsje;
    }

    public BigDecimal getZssl() {
        return this.zssl;

    }

    public void setZssl(BigDecimal zssl) {
        this.zssl = zssl;
    }

    public BigDecimal getTsl() {
        return this.tsl;

    }

    public void setTsl(BigDecimal tsl) {
        this.tsl = tsl;
    }

    public BigDecimal getTse() {
        return this.tse;

    }

    public void setTse(BigDecimal tse) {
        this.tse = tse;
    }

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public String getGlh() {
        return glh;
    }

    public void setGlh(String glh) {
        this.glh = glh;
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

    public String getDlzmh() {
        return dlzmh;
    }

    public void setDlzmh(String dlzmh) {
        this.dlzmh = dlzmh;
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

    public String getYwlxmc() {
        return ywlxmc;
    }

    public void setYwlxmc(String ywlxmc) {
        this.ywlxmc = ywlxmc;
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

    public List<SbMtsJhmxVO> getJhmx() {
        return jhmx;
    }

    public void setJhmx(List<SbMtsJhmxVO> jhmx) {
        this.jhmx = jhmx;
    }

    public String getSbxh() {
        return sbxh;
    }

    public void setSbxh(String sbxh) {
        this.sbxh = sbxh;
    }
}
