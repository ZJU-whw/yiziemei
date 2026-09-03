package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.bjts.sw.annotation.ConvertCode;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 报关单关注信息VO
 */
public class YjBgdgzxxVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 金三企业登记序号 */
    private String djxh;

    /** 出口报关单号 */
    private String ckbgdh;

    /** 企业税号 */
    private String nsrsbh;

    /** 企业名称 */
    private String nsrmc;

    /** 出口日期 */
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date ckrq;

    /** 出口商品代码 */
    private String ckspdm;

    /** 出口商品名称 */
    private String ckspmc;

    /** 出口数量 */
    private BigDecimal cksl;

    /** 美元离岸价 */
    private BigDecimal mylj;

    /** 人民币离岸价 */
    private BigDecimal rmbj;

    /** 参与退税申报记录 */
    private String cytssbjl;

    /** 关注信息 */
    private String gzxx;

    /** 是否作废 */
    private String sfzf;

    /** 操作人代码 */
    private String czrDm;

    /** 操作人名称 */
    private String czrMc;

    /** 操作日期 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date czrq;

    public String getDjxh() {
        return this.djxh;

    }

    public void setDjxh(String djxh) {
        this.djxh = djxh;
    }

    public String getCkbgdh() {
        return ckbgdh;
    }

    public void setCkbgdh(String ckbgdh) {
        this.ckbgdh = ckbgdh;
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

    public Date getCkrq() {
        return ckrq;
    }

    public void setCkrq(Date ckrq) {
        this.ckrq = ckrq;
    }

    public String getCkspdm() {
        return ckspdm;
    }

    public void setCkspdm(String ckspdm) {
        this.ckspdm = ckspdm;
    }

    public String getCkspmc() {
        return ckspmc;
    }

    public void setCkspmc(String ckspmc) {
        this.ckspmc = ckspmc;
    }

    public BigDecimal getCksl() {
        return cksl;
    }

    public void setCksl(BigDecimal cksl) {
        this.cksl = cksl;
    }

    public BigDecimal getMylj() {
        return mylj;
    }

    public void setMylj(BigDecimal mylj) {
        this.mylj = mylj;
    }

    public BigDecimal getRmbj() {
        return rmbj;
    }

    public void setRmbj(BigDecimal rmbj) {
        this.rmbj = rmbj;
    }

    public String getCytssbjl() {
        return this.cytssbjl;

    }

    public void setCytssbjl(String cytssbjl) {
        this.cytssbjl = cytssbjl;
    }

    public String getGzxx() {
        return gzxx;
    }

    public void setGzxx(String gzxx) {
        this.gzxx = gzxx;
    }

    public String getSfzf() {
        return sfzf;
    }

    public void setSfzf(String sfzf) {
        this.sfzf = sfzf;
    }

    public String getCzrDm() {
        return czrDm;
    }

    public void setCzrDm(String czrDm) {
        this.czrDm = czrDm;
    }

    public String getCzrMc() {
        return czrMc;
    }

    public void setCzrMc(String czrMc) {
        this.czrMc = czrMc;
    }

    public Date getCzrq() {
        return czrq;
    }

    public void setCzrq(Date czrq) {
        this.czrq = czrq;
    }
}
