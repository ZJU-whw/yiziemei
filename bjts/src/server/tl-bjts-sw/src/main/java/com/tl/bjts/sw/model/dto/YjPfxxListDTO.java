package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.model.BaseListDTO;

import java.math.BigDecimal;

/*
 * @Description: 预警评分信息列表
 * @Author Neo Lin
 * @Date  2019-09-02 14:31
 */
public class YjPfxxListDTO extends BaseListDTO {

    @NotEmpty(msg="纳税人识别号不可为空")
    private String nsrsbh;

    // 预警代码（选择）
    private String yjcode;

    // 指标代码（选择）
    private String zbcode;

    // 处理标志（选择）
    private String clFlag;

    // 预警对象
    private String yjObject;

    // 金额（起）
    private BigDecimal yjAmtStart;

    // 金额（止）
    private BigDecimal yjAmtEnd;

    // 备注
    private String bz;

    public String getNsrsbh() {
        return nsrsbh;
    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getYjcode() {
        return yjcode;
    }

    public void setYjcode(String yjcode) {
        this.yjcode = yjcode;
    }

    public String getZbcode() {
        return zbcode;
    }

    public void setZbcode(String zbcode) {
        this.zbcode = zbcode;
    }

    public String getClFlag() {
        return clFlag;
    }

    public void setClFlag(String clFlag) {
        this.clFlag = clFlag;
    }

    public String getYjObject() {
        return yjObject;
    }

    public void setYjObject(String yjObject) {
        this.yjObject = yjObject;
    }

    public BigDecimal getYjAmtStart() {
        return yjAmtStart;
    }

    public void setYjAmtStart(BigDecimal yjAmtStart) {
        this.yjAmtStart = yjAmtStart;
    }

    public BigDecimal getYjAmtEnd() {
        return yjAmtEnd;
    }

    public void setYjAmtEnd(BigDecimal yjAmtEnd) {
        this.yjAmtEnd = yjAmtEnd;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }
}
