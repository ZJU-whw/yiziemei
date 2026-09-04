package com.tl.web.bjts.shzs.model.vo.sbxx;

import java.math.BigDecimal;

/**
 * @描述: 生产免抵退税明细表合计返回
 * @作者: likun
 * @时间: 2022/5/18 15:07
 */
public class SbMdtsMxbSumVO {
    private BigDecimal mylaj; // 美元离岸价
    private BigDecimal rmblaj; // 出口销售额
    private BigDecimal ztsceHw; // 不得免征抵扣税额
    private BigDecimal mdtseHw; // 免抵退税额

    public BigDecimal getMylaj() {
        return mylaj;
    }

    public void setMylaj(BigDecimal mylaj) {
        this.mylaj = mylaj;
    }

    public BigDecimal getRmblaj() {
        return rmblaj;
    }

    public void setRmblaj(BigDecimal rmblaj) {
        this.rmblaj = rmblaj;
    }

    public BigDecimal getZtsceHw() {
        return ztsceHw;
    }

    public void setZtsceHw(BigDecimal ztsceHw) {
        this.ztsceHw = ztsceHw;
    }

    public BigDecimal getMdtseHw() {
        return mdtseHw;
    }

    public void setMdtseHw(BigDecimal mdtseHw) {
        this.mdtseHw = mdtseHw;
    }
}
