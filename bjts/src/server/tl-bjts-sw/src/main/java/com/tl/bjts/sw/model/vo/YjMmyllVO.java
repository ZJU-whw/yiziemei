package com.tl.bjts.sw.model.vo;

import java.io.Serializable;

/**
 * 每美元利润率分析结果查询VO
 */
public class YjMmyllVO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /** 税务机关代码 */
    private String swjgDm;
    
    /** 税务机关简称 */
    private String swjgMc;
    
    /** 申报企业户数 */
    private Integer sbqyhs;
    
    /** 申报业务笔数 */
    private Integer sbywbs;
    
    /** 最小值 */
    private Double mmylllMin;
    
    /** 最大值 */
    private Double mmylllMax;
    
    /** 中位数 */
    private Double mmylllMid;
    
    /** 平均值 */
    private Double mmylllAvg;
    
    /** 标准差 */
    private Double mmylllStd;
    
    /** 预警线 */
    private Double mmylllYjx;

    public String getSwjgDm() {
        return swjgDm;
    }

    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm;
    }

    public String getSwjgMc() {
        return swjgMc;
    }

    public void setSwjgMc(String swjgMc) {
        this.swjgMc = swjgMc;
    }

    public Integer getSbqyhs() {
        return sbqyhs;
    }

    public void setSbqyhs(Integer sbqyhs) {
        this.sbqyhs = sbqyhs;
    }

    public Integer getSbywbs() {
        return sbywbs;
    }

    public void setSbywbs(Integer sbywbs) {
        this.sbywbs = sbywbs;
    }

    public Double getMmylllMin() {
        return mmylllMin;
    }

    public void setMmylllMin(Double mmylllMin) {
        this.mmylllMin = mmylllMin;
    }

    public Double getMmylllMax() {
        return mmylllMax;
    }

    public void setMmylllMax(Double mmylllMax) {
        this.mmylllMax = mmylllMax;
    }

    public Double getMmylllMid() {
        return mmylllMid;
    }

    public void setMmylllMid(Double mmylllMid) {
        this.mmylllMid = mmylllMid;
    }

    public Double getMmylllAvg() {
        return mmylllAvg;
    }

    public void setMmylllAvg(Double mmylllAvg) {
        this.mmylllAvg = mmylllAvg;
    }

    public Double getMmylllStd() {
        return mmylllStd;
    }

    public void setMmylllStd(Double mmylllStd) {
        this.mmylllStd = mmylllStd;
    }

    public Double getMmylllYjx() {
        return mmylllYjx;
    }

    public void setMmylllYjx(Double mmylllYjx) {
        this.mmylllYjx = mmylllYjx;
    }
}