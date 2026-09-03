package com.tl.bjts.sw.model.vo.sbxx;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * @Description: 发票中的货物信息
 * @Author Neo Lin
 * @Date 2017/12/13 16:42
 */
public class FpHwxxVo implements Serializable{
    private static final long serialVersionUID = 321548465432145156L;
    private String mxxh;
    private String hwmc;    //商品名称
    private String ggxh;   //规格型号
    private String dw;     //单位
    private BigDecimal sl;  //数量
    private BigDecimal dj;  //单价
    private BigDecimal je;  //金额
    private BigDecimal slv;  //税率
    private BigDecimal se; //税额

    public String getMxxh() {
        return this.mxxh;

    }

    public void setMxxh(String mxxh) {
        this.mxxh = mxxh;
    }

    public String getHwmc() {
        return hwmc;
    }

    public void setHwmc(String hwmc) {
        this.hwmc = hwmc;
    }

    public String getGgxh() {
        return ggxh;
    }

    public void setGgxh(String ggxh) {
        this.ggxh = ggxh;
    }

    public String getDw() {
        return dw;
    }

    public void setDw(String dw) {
        this.dw = dw;
    }

    public BigDecimal getSl() {
        return sl;
    }

    public void setSl(BigDecimal sl) {
        this.sl = sl;
    }

    //保留4位小数
    public BigDecimal getDj() {
        if(dj == null){
            return null;
        }
        return dj.setScale(4,BigDecimal.ROUND_HALF_UP);
    }

    public void setDj(BigDecimal dj) {
        this.dj = dj;
    }

    public BigDecimal getJe() {
        return je;
    }

    public void setJe(BigDecimal je) {
        this.je = je;
    }

    public BigDecimal getSlv() {
        return slv;
    }

    public void setSlv(BigDecimal slv) {
        this.slv = slv;
    }

    public BigDecimal getSe() {
        return se;
    }

    public void setSe(BigDecimal se) {
        this.se = se;
    }
}
