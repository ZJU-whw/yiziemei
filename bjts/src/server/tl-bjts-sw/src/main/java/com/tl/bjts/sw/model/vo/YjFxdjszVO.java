package com.tl.bjts.sw.model.vo;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 出口链路风险等级参数表VO
 */
public class YjFxdjszVO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /** 风险等级代码 */
    private String fxdjDm;
    
    /** 风险等级名称 */
    private String fxdjMc;
    
    /** 判定标准 */
    private String fxdjPdbj;
    
    /** 处置方式 */
    private String fxdjCzfs;
    
    /** 阈值(%) */
    private BigDecimal fxdjYz;

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

    public String getFxdjPdbj() {
        return fxdjPdbj;
    }

    public void setFxdjPdbj(String fxdjPdbj) {
        this.fxdjPdbj = fxdjPdbj;
    }

    public String getFxdjCzfs() {
        return fxdjCzfs;
    }

    public void setFxdjCzfs(String fxdjCzfs) {
        this.fxdjCzfs = fxdjCzfs;
    }

    public BigDecimal getFxdjYz() {
        return this.fxdjYz;

    }

    public void setFxdjYz(BigDecimal fxdjYz) {
        this.fxdjYz = fxdjYz;
    }
}