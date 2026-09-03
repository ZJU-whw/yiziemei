package com.tl.bjts.sw.model.dto;

import com.tl.bjts.sw.annotation.NotEmpty;

import java.math.BigDecimal;

/**
 * @Author：Mamf
 * @Date: 2019/9/3.
 * @Description:
 */
public class YjzbcodeQybzDTO {

    @NotEmpty
    private String zbcode; //预警代码
    private BigDecimal p1val ; //    参数1数值
    private BigDecimal p2val;    // 参数2数值
    private BigDecimal p3val ; //    参数3数值
    private BigDecimal p4val;    // 参数4数值
    private Integer score ;  //  分值
    private String swjgdm;//税务机关代码

    @NotEmpty
    private String yxbz ; // Y:启用 N：关闭

    private String tsjg;

    public BigDecimal getP3val() {
        return this.p3val;

    }

    public void setP3val(BigDecimal p3val) {
        this.p3val = p3val;
    }

    public BigDecimal getP4val() {
        return this.p4val;

    }

    public void setP4val(BigDecimal p4val) {
        this.p4val = p4val;
    }

    public String getTsjg() {
        return tsjg;
    }

    public void setTsjg(String tsjg) {
        this.tsjg = tsjg;
    }

    public String getZbcode() {
        return zbcode;
    }

    public void setZbcode(String zbcode) {
        this.zbcode = zbcode;
    }

    public BigDecimal getP1val() {
        return p1val;
    }

    public void setP1val(BigDecimal p1val) {
        this.p1val = p1val;
    }

    public BigDecimal getP2val() {
        return p2val;
    }

    public void setP2val(BigDecimal p2val) {
        this.p2val = p2val;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public String getYxbz() {
        return yxbz;
    }

    public void setYxbz(String yxbz) {
        this.yxbz = yxbz;
    }

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }
}
