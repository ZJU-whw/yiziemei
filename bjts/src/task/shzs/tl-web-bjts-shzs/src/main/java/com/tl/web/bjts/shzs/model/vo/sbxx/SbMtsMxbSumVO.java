package com.tl.web.bjts.shzs.model.vo.sbxx;

import java.math.BigDecimal;

/**
 * @描述: 外贸免退税合计信息
 * @作者: likun
 * @时间: 2022/5/18 15:10
 */
public class SbMtsMxbSumVO {
    private BigDecimal mylaj; // 美元离岸价
    private BigDecimal jsje; //计税金额
    private BigDecimal tse; //申报退税额

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
