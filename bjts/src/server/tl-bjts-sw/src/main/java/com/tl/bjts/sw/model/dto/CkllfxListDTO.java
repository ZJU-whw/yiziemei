package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

import java.util.Date;

/**
 * @Description: 出口业务物流链路综合管理查询条件DTO
 * @Author: 
 * @Date: 2026-05-13
 */
public class CkllfxListDTO extends BaseListDTO {
    
    // ==================== 主查询条件 ====================
    
    /** 税务机关代码 */
    private String swjgDm;
    
    /** 风险刷新日期起 */
    private Date fxdjGxrqQ;
    
    /** 风险刷新日期止 */
    private Date fxdjGxrqZ;
    
    /** 风险等级代码 */
    private String fxdjDm;
    
    /** 发货模式代码（1整柜/2散货(拼箱)） */
    private String fhmsDm;
    
    /** 运输方式代码 */
    private String ysfsDm;
    
    // ==================== 扩展查询条件 ====================
    
    /** 退税计算方式代码（1生产/2外贸） */
    private String tmsjsffDm;
    
    /** 企业标识（税号/名称），支持模糊查询 */
    private String qybs;

    /** 供应商标识（税号/名称），支持模糊查询 */
    private String gybs;
    
    /** 报关单号，18位出口报关单主号，少于18位时按尾号模糊检索 */
    private String bgdhgbh;
    
    /** 出口日期起 */
    private Date ckrqQ;
    
    /** 出口日期止 */
    private Date ckrqZ;
    
    /** 集装箱号，模糊检索 */
    private String jzxh;
    
    /** 车牌号，模糊检索 */
    private String cph;

    /** 出口发票号，模糊检索 */
    private String ckfph;
    
    // ==================== 排序字段 ====================
    /** 美元离岸价排序 */
    private String mylajOrder;
    
    /** 出口日期排序 */
    private String ckrqOrder;
    
    /** 风险刷新日期排序 */
    private String fxdjGxrqOrder;
    
    // ==================== 分页导出标识 ====================
    /** 导出标识，true时不分页 */
    private boolean export;
    
    // Getter and Setter
    public String getSwjgDm() {
        return swjgDm;
    }
    
    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm;
    }
    
    public Date getFxdjGxrqQ() {
        return fxdjGxrqQ;
    }
    
    public void setFxdjGxrqQ(Date fxdjGxrqQ) {
        this.fxdjGxrqQ = fxdjGxrqQ;
    }
    
    public Date getFxdjGxrqZ() {
        return fxdjGxrqZ;
    }
    
    public void setFxdjGxrqZ(Date fxdjGxrqZ) {
        this.fxdjGxrqZ = fxdjGxrqZ;
    }
    
    public String getFxdjDm() {
        return fxdjDm;
    }
    
    public void setFxdjDm(String fxdjDm) {
        this.fxdjDm = fxdjDm;
    }
    
    public String getFhmsDm() {
        return fhmsDm;
    }
    
    public void setFhmsDm(String fhmsDm) {
        this.fhmsDm = fhmsDm;
    }
    
    public String getYsfsDm() {
        return ysfsDm;
    }
    
    public void setYsfsDm(String ysfsDm) {
        this.ysfsDm = ysfsDm;
    }
    
    public String getTmsjsffDm() {
        return tmsjsffDm;
    }
    
    public void setTmsjsffDm(String tmsjsffDm) {
        this.tmsjsffDm = tmsjsffDm;
    }
    
    public String getQybs() {
        return qybs;
    }
    
    public void setQybs(String qybs) {
        this.qybs = qybs;
    }

    public String getGybs() {
        return gybs;
    }

    public void setGybs(String gybs) {
        this.gybs = gybs;
    }
    
    public String getBgdhgbh() {
        return bgdhgbh;
    }
    
    public void setBgdhgbh(String bgdhgbh) {
        this.bgdhgbh = bgdhgbh;
    }
    
    public Date getCkrqQ() {
        return ckrqQ;
    }
    
    public void setCkrqQ(Date ckrqQ) {
        this.ckrqQ = ckrqQ;
    }
    
    public Date getCkrqZ() {
        return ckrqZ;
    }
    
    public void setCkrqZ(Date ckrqZ) {
        this.ckrqZ = ckrqZ;
    }
    
    public String getJzxh() {
        return jzxh;
    }
    
    public void setJzxh(String jzxh) {
        this.jzxh = jzxh;
    }
    
    public String getCph() {
        return cph;
    }
    
    public void setCph(String cph) {
        this.cph = cph;
    }

    public String getCkfph() {
        return ckfph;
    }

    public void setCkfph(String ckfph) {
        this.ckfph = ckfph;
    }
    
    public String getMylajOrder() {
        return mylajOrder;
    }
    
    public void setMylajOrder(String mylajOrder) {
        this.mylajOrder = mylajOrder;
    }
    
    public String getCkrqOrder() {
        return ckrqOrder;
    }
    
    public void setCkrqOrder(String ckrqOrder) {
        this.ckrqOrder = ckrqOrder;
    }
    
    public String getFxdjGxrqOrder() {
        return fxdjGxrqOrder;
    }
    
    public void setFxdjGxrqOrder(String fxdjGxrqOrder) {
        this.fxdjGxrqOrder = fxdjGxrqOrder;
    }
    
    public boolean isExport() {
        return export;
    }
    
    public void setExport(boolean export) {
        this.export = export;
    }
}
