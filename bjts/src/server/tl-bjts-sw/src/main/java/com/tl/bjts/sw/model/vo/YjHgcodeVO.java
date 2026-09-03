package com.tl.bjts.sw.model.vo;

import java.io.Serializable;

/**
 * 海关口岸区域对照表VO
 */
public class YjHgcodeVO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /** 海关口岸代码 */
    private String hgcode;
    
    /** 海关口岸名称 */
    private String hgmc;
    
    /** 行政区划代码 */
    private String xzqhDm;
    
    /** 行政区划名称 */
    private String xzqhMc;
    
    /** 国内区域代码 */
    private String qycode;
    
    /** 国内区域名称 */
    private String qyname;

    public String getHgcode() {
        return hgcode;
    }

    public void setHgcode(String hgcode) {
        this.hgcode = hgcode;
    }

    public String getHgmc() {
        return hgmc;
    }

    public void setHgmc(String hgmc) {
        this.hgmc = hgmc;
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
}