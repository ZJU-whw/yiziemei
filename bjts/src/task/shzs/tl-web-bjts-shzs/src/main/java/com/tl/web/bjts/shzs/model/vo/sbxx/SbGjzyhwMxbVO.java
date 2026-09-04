package com.tl.web.bjts.shzs.model.vo.sbxx;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @描述: 购进自用货物明细表
 * @作者: likun
 * @时间: 2022/4/22 10:53
 */
public class SbGjzyhwMxbVO {

    private Long sbid; // 申报id（前端隐藏）
    private String sbxh; // 申报序号
    private String gjzyhwmc; // 购进自用货物名称
    private String pzzldm; // 进货凭证种类
    private String jhpzh; // 进货凭证号码
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date kprq; // 开票日期
    private String ghfnsrsbh; // 供货方税号
    private String jldw; // 单位
    private BigDecimal sl; // 数量
    private BigDecimal dj; // 单价
    private BigDecimal jsje; // 计税金额
    private BigDecimal se; // 税额
    private BigDecimal zssl; // 征税率
    private BigDecimal tse; // 申报退税额
    private String fkpzh; // 付款凭证码
    private String ywlxmc; // 业务类型
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

    public String getGjzyhwmc() {
        return gjzyhwmc;
    }

    public void setGjzyhwmc(String gjzyhwmc) {
        this.gjzyhwmc = gjzyhwmc;
    }

    public String getPzzldm() {
        return pzzldm;
    }

    public void setPzzldm(String pzzldm) {
        this.pzzldm = pzzldm;
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

    public String getGhfnsrsbh() {
        return ghfnsrsbh;
    }

    public void setGhfnsrsbh(String ghfnsrsbh) {
        this.ghfnsrsbh = ghfnsrsbh;
    }

    public String getJldw() {
        return jldw;
    }

    public void setJldw(String jldw) {
        this.jldw = jldw;
    }

    public BigDecimal getSl() {
        return sl;
    }

    public void setSl(BigDecimal sl) {
        this.sl = sl;
    }

    public BigDecimal getDj() {
        return dj;
    }

    public void setDj(BigDecimal dj) {
        this.dj = dj;
    }

    public BigDecimal getJsje() {
        return jsje;
    }

    public void setJsje(BigDecimal jsje) {
        this.jsje = jsje;
    }

    public BigDecimal getSe() {
        return se;
    }

    public void setSe(BigDecimal se) {
        this.se = se;
    }

    public BigDecimal getZssl() {
        return zssl;
    }

    public void setZssl(BigDecimal zssl) {
        this.zssl = zssl;
    }

    public BigDecimal getTse() {
        return tse;
    }

    public void setTse(BigDecimal tse) {
        this.tse = tse;
    }

    public String getFkpzh() {
        return fkpzh;
    }

    public void setFkpzh(String fkpzh) {
        this.fkpzh = fkpzh;
    }

    public String getYwlxmc() {
        return ywlxmc;
    }

    public void setYwlxmc(String ywlxmc) {
        this.ywlxmc = ywlxmc;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }
}
