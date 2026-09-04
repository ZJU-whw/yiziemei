package com.tl.web.bjts.shzs.model.vo;

import java.math.BigDecimal;

/**
 * @Author whg
 * @create 2024/5/14 16:59
 * @description：
 */
public class TseYcInfoQueryVO {

    /**
     * 申报业务表代码为：外贸免退税申报或生产免抵退申报
     */
    private Boolean ywFlag;

    /**
     * 重点企业标志
     */
    private Boolean zdFlag;

    /**
     * 相符标志
     */
    private Boolean xfFlag;

    /**
     * 显示信息1
     */
    private String msg1;

    /**
     * 显示信息2（非重点企业不显示）
     */
    private String msg2;

    /**
     * 预测退税额
     */
    private BigDecimal yctse;

    /**
     * 申报退税额
     */
    private BigDecimal sbtse;

    /**
     * 当月累计退税额
     */
    private BigDecimal dyljsbtse;

    public Boolean getYwFlag() {
        return ywFlag;
    }

    public void setYwFlag(Boolean ywFlag) {
        this.ywFlag = ywFlag;
    }

    public Boolean getZdFlag() {
        return zdFlag;
    }

    public void setZdFlag(Boolean zdFlag) {
        this.zdFlag = zdFlag;
    }

    public Boolean getXfFlag() {
        return xfFlag;
    }

    public void setXfFlag(Boolean xfFlag) {
        this.xfFlag = xfFlag;
    }

    public String getMsg1() {
        return msg1;
    }

    public void setMsg1(String msg1) {
        this.msg1 = msg1;
    }

    public String getMsg2() {
        return msg2;
    }

    public void setMsg2(String msg2) {
        this.msg2 = msg2;
    }

    public BigDecimal getYctse() {
        return yctse;
    }

    public void setYctse(BigDecimal yctse) {
        this.yctse = yctse;
    }

    public BigDecimal getSbtse() {
        return sbtse;
    }

    public void setSbtse(BigDecimal sbtse) {
        this.sbtse = sbtse;
    }

    public BigDecimal getDyljsbtse() {
        return dyljsbtse;
    }

    public void setDyljsbtse(BigDecimal dyljsbtse) {
        this.dyljsbtse = dyljsbtse;
    }

    @Override
    public String toString() {
        return super.toString();
    }
}
