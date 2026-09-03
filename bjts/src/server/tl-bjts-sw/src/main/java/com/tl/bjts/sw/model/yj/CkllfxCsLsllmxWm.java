package com.tl.bjts.sw.model.yj;

/**
 * @description 历史数据出口链路分析表
 * @author: Mamf
 * @date: 2026/1/23 11:40
 */
public class CkllfxCsLsllmxWm {

    /** 运输方式代码 */
    private String ysfsDm;
    /** 货源地区域代码 */
    private String qycodeHyd;
    /** 启运口岸区域代码 */
    private String qycodeHg;
    /** 目的国区域代码 */
    private String qycodeMdg;
    /** 报关单份数 */
    private Integer bgdfs;
    /** 占比（%） */
    private Double zb;
    /** 是否预警（是/否） */
    private String isWarn;
    /** 货源地区域名称 */
    private String qyNameHyd;
    /** 启运口岸区域名称 */
    private String qyNameHg;
    /** 目的国区域名称 */
    private String qyNameMdg;

    public String getYsfsDm() {
        return this.ysfsDm;

    }

    public void setYsfsDm(String ysfsDm) {
        this.ysfsDm = ysfsDm;
    }

    public String getQycodeHyd() {
        return this.qycodeHyd;

    }

    public void setQycodeHyd(String qycodeHyd) {
        this.qycodeHyd = qycodeHyd;
    }

    public String getQycodeHg() {
        return this.qycodeHg;

    }

    public void setQycodeHg(String qycodeHg) {
        this.qycodeHg = qycodeHg;
    }

    public String getQycodeMdg() {
        return this.qycodeMdg;

    }

    public void setQycodeMdg(String qycodeMdg) {
        this.qycodeMdg = qycodeMdg;
    }

    public Integer getBgdfs() {
        return this.bgdfs;

    }

    public void setBgdfs(Integer bgdfs) {
        this.bgdfs = bgdfs;
    }

    public Double getZb() {
        return this.zb;

    }

    public void setZb(Double zb) {
        this.zb = zb;
    }

    public String getIsWarn() {
        return this.isWarn;

    }

    public void setIsWarn(String isWarn) {
        this.isWarn = isWarn;
    }

    public String getQyNameHyd() {
        return this.qyNameHyd;

    }

    public void setQyNameHyd(String qyNameHyd) {
        this.qyNameHyd = qyNameHyd;
    }

    public String getQyNameHg() {
        return this.qyNameHg;

    }

    public void setQyNameHg(String qyNameHg) {
        this.qyNameHg = qyNameHg;
    }

    public String getQyNameMdg() {
        return this.qyNameMdg;

    }

    public void setQyNameMdg(String qyNameMdg) {
        this.qyNameMdg = qyNameMdg;
    }
}
