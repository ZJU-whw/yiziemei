package com.tl.web.bjts.yj.model.vo;

import java.math.BigDecimal;

/**
 * @description 义务报关出口数据对象
 * @author: Mamf
 * @date: 2026/4/1 10:29
 */
public class YwbgCkeVo {

    private BigDecimal lcMylaj;

    private BigDecimal mylajAll;

    private BigDecimal mylaj3m;

    private String lcSbxh;

    private String lcGlh;


    public String getLcGlh() {
        return this.lcGlh;

    }

    public void setLcGlh(String lcGlh) {
        this.lcGlh = lcGlh;
    }

    public BigDecimal getLcMylaj() {
        return this.lcMylaj;

    }

    public void setLcMylaj(BigDecimal lcMylaj) {
        this.lcMylaj = lcMylaj;
    }

    public BigDecimal getMylajAll() {
        return this.mylajAll;

    }

    public void setMylajAll(BigDecimal mylajAll) {
        this.mylajAll = mylajAll;
    }

    public BigDecimal getMylaj3m() {
        return this.mylaj3m;

    }

    public void setMylaj3m(BigDecimal mylaj3m) {
        this.mylaj3m = mylaj3m;
    }

    public String getLcSbxh() {
        return this.lcSbxh;

    }

    public void setLcSbxh(String lcSbxh) {
        this.lcSbxh = lcSbxh;
    }
}
