package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

/**
 * 每美元利润率分析结果查询DTO
 */
public class YjMmyllDTO extends BaseListDTO {
    
    /** 税务机关代码（精确查询） */
    private String swjgDm;
    
    /** 权限机关代码前缀（用于数据权限过滤） */
    private String qxdm;

    public String getSwjgDm() {
        return swjgDm;
    }

    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm;
    }

    public String getQxdm() {
        return qxdm;
    }

    public void setQxdm(String qxdm) {
        this.qxdm = qxdm;
    }
}