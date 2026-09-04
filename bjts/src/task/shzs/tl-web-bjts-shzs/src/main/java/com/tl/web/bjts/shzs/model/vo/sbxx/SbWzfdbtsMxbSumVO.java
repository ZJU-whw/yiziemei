package com.tl.web.bjts.shzs.model.vo.sbxx;

import java.math.BigDecimal;

/**
 * @描述: 外综服代办退税明细合计返回
 * @作者: likun
 * @时间: 2022/5/18 15:29
 */
public class SbWzfdbtsMxbSumVO {
    private BigDecimal mylaj; // 美元离岸价
    private BigDecimal jsje; // 计税金额
    private BigDecimal tse; // 应退税额

    public BigDecimal getMylaj() {
        return mylaj;
    }

    public void setMylaj(BigDecimal mylaj) {
        this.mylaj = mylaj;
    }

    public BigDecimal getJsje() {
        return jsje;
    }

    public void setJsje(BigDecimal jsje) {
        this.jsje = jsje;
    }

    public BigDecimal getTse() {
        return tse;
    }

    public void setTse(BigDecimal tse) {
        this.tse = tse;
    }
}
