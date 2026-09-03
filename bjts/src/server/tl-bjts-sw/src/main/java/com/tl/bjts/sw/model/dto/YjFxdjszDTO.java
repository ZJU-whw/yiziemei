package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

/**
 * 出口链路风险等级参数表查询DTO
 */
public class YjFxdjszDTO extends BaseListDTO {
    
    /** 风险等级代码 */
    private String fxdjDm;
    
    /** 风险等级名称 */
    private String fxdjMc;

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
}