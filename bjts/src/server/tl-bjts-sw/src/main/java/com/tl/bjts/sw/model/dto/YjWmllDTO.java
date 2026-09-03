package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

/**
 * 出口链路异常分析模型（外贸）查询DTO
 */
public class YjWmllDTO extends BaseListDTO {

    private String swjgdm;
    
    /** 运输方式代码 */
    private String ysfsDm;
    
    /** 商品大类代码 */
    private String spdlDm;
    
    /** 供应商区域代码（货源地区域） */
    private String qycodeHyd;
    
    /** 启运区域代码（海关口岸区域） */
    private String qycodeHg;
    
    /** 贸易区域代码（目的国区域） */
    private String qycodeMdg;
    
    /** 企业占比上限值 */
    private Double qyzbUpper;
    
    /** 企业占比下限值 */
    private Double qyzbLower;
    
    /** 关单统计上限值 */
    private Integer bgdfsUpper;
    
    /** 关单统计下限值 */
    private Integer bgdfsLower;
    
    /** 出口统计上限值 */
    private Double mylajUpper;
    
    /** 出口统计下限值 */
    private Double mylajLower;

    /** 企业占比(规模以上)上限值 */
    private Double qyzbSxUpper;

    /** 企业占比(规模以上)下限值 */
    private Double qyzbSxLower;

    /** 报关单占比(规模以上)上限值 */
    private Double bgdzbSxUpper;

    /** 报关单占比(规模以上)下限值 */
    private Double bgdzbSxLower;

    /** 出口额占比(规模以上)上限值 */
    private Double myzbSxUpper;

    /** 出口额占比(规模以上)下限值 */
    private Double myzbSxLower;
    
    /** 系统风险等级代码 */
    private String fxdjDm;
    
    /** 调整风险等级 */
    private String fxdjDz;

    public String getSwjgdm() {
        return this.swjgdm;

    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getYsfsDm() {
        return ysfsDm;
    }

    public void setYsfsDm(String ysfsDm) {
        this.ysfsDm = ysfsDm;
    }

    public String getSpdlDm() {
        return spdlDm;
    }

    public void setSpdlDm(String spdlDm) {
        this.spdlDm = spdlDm;
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

    public Double getQyzbUpper() {
        return qyzbUpper;
    }

    public void setQyzbUpper(Double qyzbUpper) {
        this.qyzbUpper = qyzbUpper;
    }

    public Double getQyzbLower() {
        return qyzbLower;
    }

    public void setQyzbLower(Double qyzbLower) {
        this.qyzbLower = qyzbLower;
    }

    public Integer getBgdfsUpper() {
        return bgdfsUpper;
    }

    public void setBgdfsUpper(Integer bgdfsUpper) {
        this.bgdfsUpper = bgdfsUpper;
    }

    public Integer getBgdfsLower() {
        return bgdfsLower;
    }

    public void setBgdfsLower(Integer bgdfsLower) {
        this.bgdfsLower = bgdfsLower;
    }

    public Double getMylajUpper() {
        return mylajUpper;
    }

    public void setMylajUpper(Double mylajUpper) {
        this.mylajUpper = mylajUpper;
    }

    public Double getMylajLower() {
        return mylajLower;
    }

    public void setMylajLower(Double mylajLower) {
        this.mylajLower = mylajLower;
    }

    public Double getQyzbSxUpper() {
        return qyzbSxUpper;
    }

    public void setQyzbSxUpper(Double qyzbSxUpper) {
        this.qyzbSxUpper = qyzbSxUpper;
    }

    public Double getQyzbSxLower() {
        return qyzbSxLower;
    }

    public void setQyzbSxLower(Double qyzbSxLower) {
        this.qyzbSxLower = qyzbSxLower;
    }

    public Double getBgdzbSxUpper() {
        return bgdzbSxUpper;
    }

    public void setBgdzbSxUpper(Double bgdzbSxUpper) {
        this.bgdzbSxUpper = bgdzbSxUpper;
    }

    public Double getBgdzbSxLower() {
        return bgdzbSxLower;
    }

    public void setBgdzbSxLower(Double bgdzbSxLower) {
        this.bgdzbSxLower = bgdzbSxLower;
    }

    public Double getMyzbSxUpper() {
        return myzbSxUpper;
    }

    public void setMyzbSxUpper(Double myzbSxUpper) {
        this.myzbSxUpper = myzbSxUpper;
    }

    public Double getMyzbSxLower() {
        return myzbSxLower;
    }

    public void setMyzbSxLower(Double myzbSxLower) {
        this.myzbSxLower = myzbSxLower;
    }

    public String getFxdjDm() {
        return fxdjDm;
    }

    public void setFxdjDm(String fxdjDm) {
        this.fxdjDm = fxdjDm;
    }

    public String getFxdjDz() {
        return fxdjDz;
    }

    public void setFxdjDz(String fxdjDz) {
        this.fxdjDz = fxdjDz;
    }
}