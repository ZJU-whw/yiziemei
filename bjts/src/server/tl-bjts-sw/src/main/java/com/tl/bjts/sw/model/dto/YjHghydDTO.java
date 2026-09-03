package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

/**
 * 海关货源地区域对照表查询DTO
 */
public class YjHghydDTO extends BaseListDTO {
    
    /** 货源地代码 */
    private String hghydDm;
    
    /** 货源地名称 */
    private String hghydMc;
    
    /** 行政区划代码 */
    private String xzqhDm;
    
    /** 行政区划名称 */
    private String xzqhMc;
    
    /** 国内区域代码 */
    private String qycode;
    
    /** 国内区域名称 */
    private String qyname;
    
    /** 是否导出 */
    private boolean export;

    public String getHghydDm() {
        return hghydDm;
    }

    public void setHghydDm(String hghydDm) {
        this.hghydDm = hghydDm;
    }

    public String getHghydMc() {
        return hghydMc;
    }

    public void setHghydMc(String hghydMc) {
        this.hghydMc = hghydMc;
    }

    public String getXzqhDm() {
        return xzqhDm;
    }

    public void setXzqhDm(String xzqhDm) {
        this.xzqhDm = xzqhDm;
    }

    public String getXzqhMc() {
        return xzqhMc;
    }

    public void setXzqhMc(String xzqhMc) {
        this.xzqhMc = xzqhMc;
    }

    public String getQycode() {
        return qycode;
    }

    public void setQycode(String qycode) {
        this.qycode = qycode;
    }

    public String getQyname() {
        return qyname;
    }

    public void setQyname(String qyname) {
        this.qyname = qyname;
    }

    public boolean isExport() {
        return export;
    }

    public void setExport(boolean export) {
        this.export = export;
    }
}