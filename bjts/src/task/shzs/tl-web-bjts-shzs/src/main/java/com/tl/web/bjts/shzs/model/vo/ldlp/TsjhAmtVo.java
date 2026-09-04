package com.tl.web.bjts.shzs.model.vo.ldlp;

import java.math.BigDecimal;

public class TsjhAmtVo {

    private Integer tsjhTotal;   //进货明细总数

    private  BigDecimal tsjhAmt;   //进货明细合计计税金额
    private  BigDecimal tsjhTsAmt;   //进货明细合计可退税额
    private  BigDecimal tsjhSe;   //进货明细合计税额

    public Integer getTsjhTotal() {
        return tsjhTotal;
    }

    public void setTsjhTotal(Integer tsjhTotal) {
        this.tsjhTotal = tsjhTotal;
    }

    public BigDecimal getTsjhAmt() {
        return tsjhAmt;
    }

    public void setTsjhAmt(BigDecimal tsjhAmt) {
        this.tsjhAmt = tsjhAmt;
    }

    public BigDecimal getTsjhTsAmt() {
        return tsjhTsAmt;
    }

    public void setTsjhTsAmt(BigDecimal tsjhTsAmt) {
        this.tsjhTsAmt = tsjhTsAmt;
    }

    public BigDecimal getTsjhSe() {
        return tsjhSe;
    }

    public void setTsjhSe(BigDecimal tsjhSe) {
        this.tsjhSe = tsjhSe;
    }
}
