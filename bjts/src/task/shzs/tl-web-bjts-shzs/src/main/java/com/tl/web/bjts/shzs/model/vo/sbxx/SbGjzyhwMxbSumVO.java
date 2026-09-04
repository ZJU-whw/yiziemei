package com.tl.web.bjts.shzs.model.vo.sbxx;

import java.math.BigDecimal;

/**
 * @描述: 购进自用货物合计返回vo
 * @作者: likun
 * @时间: 2022/5/18 15:40
 */
public class SbGjzyhwMxbSumVO {
    private BigDecimal jsje; // 计税金额
    private BigDecimal se; // 税额
    private BigDecimal tse; // 申报退税额

    public BigDecimal getJsje() {
        return jsje;
    }

    public void setJsje(BigDecimal jsje) {
        this.jsje = jsje;
    }

    public BigDecimal getSe() {
        return se;
    }

    public void setSe(BigDecimal se) {
        this.se = se;
    }

    public BigDecimal getTse() {
        return tse;
    }

    public void setTse(BigDecimal tse) {
        this.tse = tse;
    }
}
