package com.tl.bjts.sw.model.vo;

import java.io.Serializable;

/**
 * 出口链路异常分析模型（外贸）VO
 */
public class YjWmllVO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /** 运输方式代码 */
    private String ysfsDm;
    
    /** 运输方式名称 */
    private String ysfsMc;
    
    /** 商品大类代码 */
    private String spdlDm;
    
    /** 商品大类名称 */
    private String spdlMc;
    
    /** 货源地区域代码 */
    private String qycodeHyd;
    
    /** 货源地区域名称 */
    private String qynameHyd;
    
    /** 启运口岸区域代码 */
    private String qycodeHg;
    
    /** 启运口岸区域名称 */
    private String qynameHg;
    
    /** 目的国区域代码 */
    private String qycodeMdg;
    
    /** 目的国区域名称 */
    private String qynameMdg;
    
    /** 企业户数 */
    private Integer qyhsAll;
    
    /** 企业占比 */
    private Double qyzbAll;
    
    /** 报关单份数 */
    private Integer bgdfsAll;
    
    /** 报关单占比 */
    private Double bgdzbAll;
    
    /** 出口额美元 */
    private Double mylajAll;
    
    /** 出口额占比 */
    private Double myzbAll;

    /** 企业户数(规模以上) */
    private Integer qyhsSx;

    /** 企业占比(规模以上) */
    private Double qyzbSx;

    /** 报关单份数(规模以上) */
    private Integer bgdfsSx;

    /** 报关单占比(规模以上) */
    private Double bgdzbSx;

    /** 出口额美元(规模以上) */
    private Double mylajSx;

    /** 出口额占比(规模以上) */
    private Double myzbSx;
    
    /** 综合风险指数 */
    private Double fxdjZhfxzs;
    
    /** 系统风险等级代码 */
    private String fxdjDm;
    
    /** 系统风险等级名称 */
    private String fxdjMc;
    
    /** 调整风险等级 */
    private String fxdjDz;

    /**
     * 风险等级调整代码
     */
    private String fxdjDzDm;

    /**
     * 风险等级调整原因
     */
    private String fxdjDzYy;

    public String getFxdjDzYy() {
        return this.fxdjDzYy;

    }

    public void setFxdjDzYy(String fxdjDzYy) {
        this.fxdjDzYy = fxdjDzYy;
    }

    public String getFxdjDzDm() {
        return this.fxdjDzDm;

    }

    public void setFxdjDzDm(String fxdjDzDm) {
        this.fxdjDzDm = fxdjDzDm;
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

    public String getSpdlDm() {
        return spdlDm;
    }

    public void setSpdlDm(String spdlDm) {
        this.spdlDm = spdlDm;
    }

    public String getSpdlMc() {
        return spdlMc;
    }

    public void setSpdlMc(String spdlMc) {
        this.spdlMc = spdlMc;
    }

    public String getQycodeHyd() {
        return qycodeHyd;
    }

    public void setQycodeHyd(String qycodeHyd) {
        this.qycodeHyd = qycodeHyd;
    }

    public String getQynameHyd() {
        return qynameHyd;
    }

    public void setQynameHyd(String qynameHyd) {
        this.qynameHyd = qynameHyd;
    }

    public String getQycodeHg() {
        return qycodeHg;
    }

    public void setQycodeHg(String qycodeHg) {
        this.qycodeHg = qycodeHg;
    }

    public String getQynameHg() {
        return qynameHg;
    }

    public void setQynameHg(String qynameHg) {
        this.qynameHg = qynameHg;
    }

    public String getQycodeMdg() {
        return qycodeMdg;
    }

    public void setQycodeMdg(String qycodeMdg) {
        this.qycodeMdg = qycodeMdg;
    }

    public String getQynameMdg() {
        return qynameMdg;
    }

    public void setQynameMdg(String qynameMdg) {
        this.qynameMdg = qynameMdg;
    }

    public Integer getQyhsAll() {
        return qyhsAll;
    }

    public void setQyhsAll(Integer qyhsAll) {
        this.qyhsAll = qyhsAll;
    }

    public Double getQyzbAll() {
        return qyzbAll;
    }

    public void setQyzbAll(Double qyzbAll) {
        this.qyzbAll = qyzbAll;
    }

    public Integer getBgdfsAll() {
        return bgdfsAll;
    }

    public void setBgdfsAll(Integer bgdfsAll) {
        this.bgdfsAll = bgdfsAll;
    }

    public Double getBgdzbAll() {
        return bgdzbAll;
    }

    public void setBgdzbAll(Double bgdzbAll) {
        this.bgdzbAll = bgdzbAll;
    }

    public Double getMylajAll() {
        return mylajAll;
    }

    public void setMylajAll(Double mylajAll) {
        this.mylajAll = mylajAll;
    }

    public Double getMyzbAll() {
        return myzbAll;
    }

    public void setMyzbAll(Double myzbAll) {
        this.myzbAll = myzbAll;
    }

    public Integer getQyhsSx() {
        return qyhsSx;
    }

    public void setQyhsSx(Integer qyhsSx) {
        this.qyhsSx = qyhsSx;
    }

    public Double getQyzbSx() {
        return qyzbSx;
    }

    public void setQyzbSx(Double qyzbSx) {
        this.qyzbSx = qyzbSx;
    }

    public Integer getBgdfsSx() {
        return bgdfsSx;
    }

    public void setBgdfsSx(Integer bgdfsSx) {
        this.bgdfsSx = bgdfsSx;
    }

    public Double getBgdzbSx() {
        return bgdzbSx;
    }

    public void setBgdzbSx(Double bgdzbSx) {
        this.bgdzbSx = bgdzbSx;
    }

    public Double getMylajSx() {
        return mylajSx;
    }

    public void setMylajSx(Double mylajSx) {
        this.mylajSx = mylajSx;
    }

    public Double getMyzbSx() {
        return myzbSx;
    }

    public void setMyzbSx(Double myzbSx) {
        this.myzbSx = myzbSx;
    }

    public Double getFxdjZhfxzs() {
        return fxdjZhfxzs;
    }

    public void setFxdjZhfxzs(Double fxdjZhfxzs) {
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

    public String getFxdjDz() {
        return fxdjDz;
    }

    public void setFxdjDz(String fxdjDz) {
        this.fxdjDz = fxdjDz;
    }
}