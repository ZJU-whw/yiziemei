package com.tl.web.bjts.shzs.model.vo.ldlp;

import java.math.BigDecimal;

public class TsckAmtVo {
    private Integer tsckTotal;       //出口明细总数

    private BigDecimal tsckTsAmt;     //出口明细合计退税额

    public Integer getTsckTotal() {
        return tsckTotal;
    }

    public void setTsckTotal(Integer tsckTotal) {
        this.tsckTotal = tsckTotal;
    }

    public BigDecimal getTsckTsAmt() {
        return tsckTsAmt;
    }

    public void setTsckTsAmt(BigDecimal tsckTsAmt) {
        this.tsckTsAmt = tsckTsAmt;
    }

}
