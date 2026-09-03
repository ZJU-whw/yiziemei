package com.tl.bjts.sw.model.dto;

import java.io.Serializable;

/**
 * 出口链路风险等级调整DTO
 */
public class YjWmllFxdjtzDTO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /** 税务机关代码 */
    private String swjgDm;
    
    /** 运输方式代码 */
    private String ysfsDm;
    
    /** 商品大类代码 */
    private String spdlDm;
    
    /** 货源地区域代码 */
    private String qycodeHyd;
    
    /** 启运口岸区域代码 */
    private String qycodeHg;
    
    /** 目的国区域代码 */
    private String qycodeMdg;
    
    /** 调整风险等级代码 */
    private String fxdjTz;
    
    /** 调整人员 */
    private String fxdjTzry;
    
    /** 调整原因 */
    private String fxdjTzYY;

    public String getSwjgDm() {
        return swjgDm;
    }

    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm;
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

    public String getFxdjTz() {
        return fxdjTz;
    }

    public void setFxdjTz(String fxdjTz) {
        this.fxdjTz = fxdjTz;
    }

    public String getFxdjTzry() {
        return fxdjTzry;
    }

    public void setFxdjTzry(String fxdjTzry) {
        this.fxdjTzry = fxdjTzry;
    }

    public String getFxdjTzYY() {
        return fxdjTzYY;
    }

    public void setFxdjTzYY(String fxdjTzYY) {
        this.fxdjTzYY = fxdjTzYY;
    }
}
