package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.ExcelSetting;
import com.tl.common.ext.annotation.RegexCheck;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @Description: 出口业务物流链路综合管理返回结果VO
 * @Author: 
 * @Date: 2026-05-13
 */
public class CkllfxListVO {

    private String djxh;
    
    // ==================== 企业基础信息 ====================

    /** 纳税人识别号 */
    @ExcelSetting(colTitleName = "纳税人识别号", isFirst = true, nextColName = "nsrmc")
    private String nsrsbh;

    /** 企业名称 */
    @ExcelSetting(colTitleName = "企业名称", nextColName = "swjgdm")
    private String nsrmc;

    @ExcelSetting(colTitleName = "税务机关", nextColName = "bgdhgbh")
    private String swjgdm;
    
    // ==================== 报关单基本信息 ====================
    
    /** 出口报关单号 */
    @ExcelSetting(colTitleName = "出口报关单号/代理证明号", nextColName = "tmsjsffDm")
    private String bgdhgbh;
    
    /** 代理证明号 */
    private String dlzmh;
    
    /** 退（免）税计算方法代码 */
    @ExcelSetting(colTitleName = "计算方法", nextColName = "ckrq")
    private String tmsjsffDm;
    
    /** 退（免）税计算方法名称 */
    private String tmsjsffMc;
    
    /** 出口日期 */
    @ExcelSetting(colTitleName = "出口日期", nextColName = "mylaj")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date ckrq;
    
    /** 美元离岸价 */
    @ExcelSetting(colTitleName = "美元离岸价(USD)", nextColName = "ysfsMc")
    private BigDecimal mylaj;
    
    /** 运输方式代码 */
    private String ysfsDm;
    
    /** 运输方式名称 */
    @ExcelSetting(colTitleName = "运输方式", nextColName = "hzdwdqMc")
    private String ysfsMc;
    
    /** 境内货源地代码 */
    private String hzdwdqDm;
    
    /** 境内货源地名称 */
    @ExcelSetting(colTitleName = "境内货源地", nextColName = "hggqkaMc")
    private String hzdwdqMc;
    
    /** 离境口岸代码 */
    private String hggqkaDm;
    
    /** 离境口岸名称 */
    @ExcelSetting(colTitleName = "离境口岸", nextColName = "zzmdgdqszMc")
    private String hggqkaMc;
    
    /** 目的国代码 */
    private String zzmdgdqszDm;
    
    /** 目的国名称 */
    @ExcelSetting(colTitleName = "目的国", nextColName = "spdlDm")
    private String zzmdgdqszMc;
    
    // ==================== 商品及物流信息 ====================
    
    /** 商品大类代码 */
    @ExcelSetting(colTitleName = "商品大类", nextColName = "fhmsMc")
    private String spdlDm;
    
    /** 发货模式代码 */
    private String fhmsDm;
    
    /** 发货模式名称 */
    @ExcelSetting(colTitleName = "发货模式", nextColName = "jzxh")
    private String fhmsMc;
    
    /** 集装箱号 */
    @ExcelSetting(colTitleName = "集装箱号", nextColName = "jhpzh")
    private String jzxh;
    
    /** 进货凭证号 */
    @ExcelSetting(colTitleName = "进货凭证号", nextColName = "ghfnsrsbh")
    private String jhpzh;
    
    /** 供应商税号 */
    @ExcelSetting(colTitleName = "供应商税号", nextColName = "ghfnsrmc")
    private String ghfnsrsbh;
    
    /** 供应商名称 */
    @ExcelSetting(colTitleName = "供应商名称", nextColName = "ghfnsrswjg")
    private String ghfnsrmc;
    
    /** 供应商主管税务机关 */
    @ExcelSetting(colTitleName = "供应商主管机关", nextColName = "qycodeHyd")
    private String ghfnsrswjg;
    
    // ==================== 区域代码 ====================
    
    /** 货源地区域代码 */
    @ExcelSetting(colTitleName = "货源地区域代码", nextColName = "qycodeHg")
    private String qycodeHyd;
    
    /** 离境地区域代码 */
    @ExcelSetting(colTitleName = "离境地区域代码", nextColName = "qycodeMdg")
    private String qycodeHg;
    
    /** 目的国区域代码 */
    @ExcelSetting(colTitleName = "目的国区域代码", nextColName = "fxdjZhfxzs")
    private String qycodeMdg;
    
    // ==================== 风险信息 ====================
    
    /** 综合风险指数 */
    @ExcelSetting(colTitleName = "综合概率指数", nextColName = "fxdjDm")
    private BigDecimal fxdjZhfxzs;
    
    /** 风险等级代码 */
    @ExcelSetting(colTitleName = "链路概率等级代码", nextColName = "fxdjMc")
    private String fxdjDm;
    
    /** 风险等级名称 */
    @ExcelSetting(colTitleName = "链路概率等级", nextColName = "fxdjGxrq")
    private String fxdjMc;
    
    /** 风险刷新日期 */
    @ExcelSetting(colTitleName = "数据刷新日期", nextColName = "fxdjTz")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date fxdjGxrq;
    
    /** 风险等级调整 */
    @ExcelSetting(colTitleName = "链路概率等级调整", nextColName = "fzDJTzYY")
    private String fxdjTz;
    
    /** 风险调整原因 */
    @ExcelSetting(colTitleName = "链路概率等级调整原因", nextColName = "wlxxlyMc")
    private String fzdjTzYY;
    
    // ==================== 物流信息要素 ====================
    
    /** 物流信息采集源代码 */
    private String wlxxlyDm;
    
    /** 物流信息采集源名称 */
    @ExcelSetting(colTitleName = "物流信息采集源", nextColName = "ckfph")
    private String wlxxlyMc;
    
    /** 出口发票号 */
    @ExcelSetting(colTitleName = "出口发票号", nextColName = "cph")
    private String ckfph;
    
    /** 车牌号 */
    @ExcelSetting(colTitleName = "车牌号", nextColName = "cpysName")
    private String cph;

    /** 车牌颜色代码（1：蓝色；2：黄色；3：黄绿色） */
    private String cpysCode;

    /** 车牌颜色名称 */
    @ExcelSetting(colTitleName = "车牌颜色", nextColName = "qyrq")
    private String cpysName;
    
    /** 起运日 */
    @ExcelSetting(colTitleName = "起运日", nextColName = "qyd")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date qyrq;
    
    /** 起运地 */
    @ExcelSetting(colTitleName = "起运地", nextColName = "tydh")
    private String qyd;
    
    /** 提运单号 */
    @ExcelSetting(colTitleName = "提运单号", nextColName = "gjemwztdm")
    private String tydh;
    
    /** 起运地行政区划 */
    private String qydXzqh;
    
    /** 提单类型代码 */
    private String tdlxDm;
    
    /** 轨迹二维码生成状态（空/0-未生成，1-已生成） */
    @ExcelSetting(colTitleName = "二维码状态", nextColName = "bz")
    private String gjemwztdm;
    
    /** 备注 */
    @ExcelSetting(colTitleName = "备注", nextColName = "sjgxsj")
    private String bz;
    
    /** 数据修改时间 */
    @ExcelSetting(colTitleName = "数据更新时间")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date sjgxsj;

    public String getSwjgdm() {
        return this.swjgdm;

    }

    public String getDjxh() {
        return this.djxh;

    }

    public void setDjxh(String djxh) {
        this.djxh = djxh;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    // ==================== Getter and Setter ====================
    
    public String getNsrmc() {
        return nsrmc;
    }
    
    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }
    
    public String getNsrsbh() {
        return nsrsbh;
    }
    
    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getBgdhgbh() {
        return bgdhgbh;
    }
    
    public void setBgdhgbh(String bgdhgbh) {
        this.bgdhgbh = bgdhgbh;
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
        // 设置名称
        if ("1".equals(tmsjsffDm)) {
            this.tmsjsffMc = "生产";
        } else if ("2".equals(tmsjsffDm)) {
            this.tmsjsffMc = "外贸";
        }
    }
    
    public String getTmsjsffMc() {
        return tmsjsffMc;
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
    
    public String getYsfsDm() {
        return ysfsDm;
    }
    
    public void setYsfsDm(String ysfsDm) {
        this.ysfsDm = ysfsDm;
    }
    
    public String getYsfsMc() {
        return ysfsMc;
    }
    
    public void setYsfsMc(String ysfsMc) {
        this.ysfsMc = ysfsMc;
    }
    
    public String getHzdwdqDm() {
        return hzdwdqDm;
    }
    
    public void setHzdwdqDm(String hzdwdqDm) {
        this.hzdwdqDm = hzdwdqDm;
    }
    
    public String getHzdwdqMc() {
        return hzdwdqMc;
    }
    
    public void setHzdwdqMc(String hzdwdqMc) {
        this.hzdwdqMc = hzdwdqMc;
    }
    
    public String getHggqkaDm() {
        return hggqkaDm;
    }
    
    public void setHggqkaDm(String hggqkaDm) {
        this.hggqkaDm = hggqkaDm;
    }
    
    public String getHggqkaMc() {
        return hggqkaMc;
    }
    
    public void setHggqkaMc(String hggqkaMc) {
        this.hggqkaMc = hggqkaMc;
    }
    
    public String getZzmdgdqszDm() {
        return zzmdgdqszDm;
    }
    
    public void setZzmdgdqszDm(String zzmdgdqszDm) {
        this.zzmdgdqszDm = zzmdgdqszDm;
    }
    
    public String getZzmdgdqszMc() {
        return zzmdgdqszMc;
    }
    
    public void setZzmdgdqszMc(String zzmdgdqszMc) {
        this.zzmdgdqszMc = zzmdgdqszMc;
    }
    
    public String getSpdlDm() {
        return spdlDm;
    }
    
    public void setSpdlDm(String spdlDm) {
        this.spdlDm = spdlDm;
    }
    
    public String getFhmsDm() {
        return fhmsDm;
    }
    
    public void setFhmsDm(String fhmsDm) {
        this.fhmsDm = fhmsDm;
        // 设置名称
        if ("1".equals(fhmsDm)) {
            this.fhmsMc = "整柜";
        } else if ("2".equals(fhmsDm)) {
            this.fhmsMc = "散货(拼箱)";
        }
    }
    
    public String getFhmsMc() {
        return fhmsMc;
    }
    
    public String getJzxh() {
        return jzxh;
    }
    
    public void setJzxh(String jzxh) {
        this.jzxh = jzxh;
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
    
    public String getGhfnsrswjg() {
        return ghfnsrswjg;
    }
    
    public void setGhfnsrswjg(String ghfnsrswjg) {
        this.ghfnsrswjg = ghfnsrswjg;
    }
    
    public String getQycodeHyd() {
        return qycodeHyd;
    }
    
    public void setQycodeHyd(String qycodeHyd) {
        this.qycodeHyd = qycodeHyd;
    }
    
    public String getQycodeHg() {
        return qycodeHg;
    }
    
    public void setQycodeHg(String qycodeHg) {
        this.qycodeHg = qycodeHg;
    }
    
    public String getQycodeMdg() {
        return qycodeMdg;
    }
    
    public void setQycodeMdg(String qycodeMdg) {
        this.qycodeMdg = qycodeMdg;
    }
    
    public BigDecimal getFxdjZhfxzs() {
        return fxdjZhfxzs;
    }
    
    public void setFxdjZhfxzs(BigDecimal fxdjZhfxzs) {
        this.fxdjZhfxzs = fxdjZhfxzs;
    }
    
    public String getFxdjDm() {
        return fxdjDm;
    }
    
    public void setFxdjDm(String fxdjDm) {
        this.fxdjDm = fxdjDm;
    }
    
    public String getFxdjMc() {
        return fxdjMc;
    }
    
    public void setFxdjMc(String fxdjMc) {
        this.fxdjMc = fxdjMc;
    }
    
    public Date getFxdjGxrq() {
        return fxdjGxrq;
    }
    
    public void setFxdjGxrq(Date fxdjGxrq) {
        this.fxdjGxrq = fxdjGxrq;
    }
    
    public String getFxdjTz() {
        return fxdjTz;
    }
    
    public void setFxdjTz(String fxdjTz) {
        this.fxdjTz = fxdjTz;
    }
    
    public String getFzdjTzYY() {
        return fzdjTzYY;
    }
    
    public void setFzdjTzYY(String fzdjTzYY) {
        this.fzdjTzYY = fzdjTzYY;
    }
    
    public String getWlxxlyDm() {
        return wlxxlyDm;
    }
    
    public void setWlxxlyDm(String wlxxlyDm) {
        this.wlxxlyDm = wlxxlyDm;
    }
    
    public String getWlxxlyMc() {
        return wlxxlyMc;
    }
    
    public void setWlxxlyMc(String wlxxlyMc) {
        this.wlxxlyMc = wlxxlyMc;
    }
    
    public String getCkfph() {
        return ckfph;
    }
    
    public void setCkfph(String ckfph) {
        this.ckfph = ckfph;
    }
    
    public String getCph() {
        return cph;
    }
    
    public void setCph(String cph) {
        this.cph = cph;
    }

    public String getCpysCode() {
        return cpysCode;
    }

    public void setCpysCode(String cpysCode) {
        this.cpysCode = cpysCode;
    }

    public String getCpysName() {
        return cpysName;
    }

    public void setCpysName(String cpysName) {
        this.cpysName = cpysName;
    }

    public Date getQyrq() {
        return qyrq;
    }
    
    public void setQyrq(Date qyrq) {
        this.qyrq = qyrq;
    }
    
    public String getQyd() {
        return qyd;
    }
    
    public void setQyd(String qyd) {
        this.qyd = qyd;
    }
    
    public String getTydh() {
        return tydh;
    }
    
    public void setTydh(String tydh) {
        this.tydh = tydh;
    }
    
    public String getQydXzqh() {
        return qydXzqh;
    }
    
    public void setQydXzqh(String qydXzqh) {
        this.qydXzqh = qydXzqh;
    }
    
    public String getTdlxDm() {
        return tdlxDm;
    }
    
    public void setTdlxDm(String tdlxDm) {
        this.tdlxDm = tdlxDm;
    }
    
    public String getGjemwztdm() {
        return gjemwztdm;
    }
    
    public void setGjemwztdm(String gjemwztdm) {
        this.gjemwztdm = gjemwztdm;
    }
    
    public String getBz() {
        return bz;
    }
    
    public void setBz(String bz) {
        this.bz = bz;
    }
    
    public Date getSjgxsj() {
        return sjgxsj;
    }
    
    public void setSjgxsj(Date sjgxsj) {
        this.sjgxsj = sjgxsj;
    }
}