package com.tl.web.bjts.shzs.model.dto.tseyc;

import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.annotation.NotNull;

import java.math.BigDecimal;

/**
 * @Author whg
 * @create 2024/5/8 9:28
 * @description：
 */
public class TseYcBfLogSaveDTO {

    /**
     * 申报编号
     */
    @NotNull(msg = "申报编号不能为空")
    private Long sbid;

    /**
     * 预测退税额
     */
    private BigDecimal yctse;

    /**
     * 申报退税额
     */
    @NotNull(msg = "申报退税额不能为空")
    private BigDecimal sbtse;

    /**
     * 当月累计申报退税额
     */
    @NotNull(msg = "当月累计申报退税额不能为空")
    private BigDecimal dyljsbtse;

    /**
     * 处理动作：0-放行、1-取消、2-退回
     */
    @NotEmpty(msg = "处理动作不能为空")
    private String cldz;

    /**
     * 原因说明
     */
    private String yysm;

    /**
     * 操作员名称
     */
    private String czymc;

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
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

    public String getCldz() {
        return cldz;
    }

    public void setCldz(String cldz) {
        this.cldz = cldz;
    }

    public String getYysm() {
        return yysm;
    }

    public void setYysm(String yysm) {
        this.yysm = yysm;
    }

    public String getCzymc() {
        return czymc;
    }

    public void setCzymc(String czymc) {
        this.czymc = czymc;
    }
}
