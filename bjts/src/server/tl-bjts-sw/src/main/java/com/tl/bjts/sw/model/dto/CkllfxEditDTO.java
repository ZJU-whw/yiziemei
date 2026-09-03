package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.annotation.MaxLength;
import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.annotation.NotNull;
import com.tl.common.ext.annotation.RegexCheck;

import java.util.Date;

/**
 * @Description: 出口业务物流链路数据修改请求DTO
 * @Author: sxf
 * @Date: 2026-07-21
 */
public class CkllfxEditDTO {

    /** 金三企业登记序号 */
    @NotNull(msg = "登记序号不能为空")
    private String djxh;

    @NotEmpty(msg = "报关单号不能为空")
    /** 出口报关单号（18位） */
    private String bgdhgbh;

    /** 车牌号 */
    @MaxLength(length = 8, msg = "【车牌号】最长8个字符")
    @RegexCheck(pattern = "^[\\u4e00-\\u9fa5a-zA-Z][a-zA-Z0-9]{1,7}$", msg = "【车牌号】格式不正确")
    private String cph;

    /** 车牌颜色代码（1：蓝色；2：黄色；3：黄绿色） */
    @RegexCheck(pattern = "^(1|2|3)$", msg = "【车牌颜色】格式不正确")
    private String cpysCode;

    /** 车牌颜色名称 */
    private String cpysName;

    /** 起运日期（yyyy-MM-dd） */
    private Date qyrq;

    /** 启运地 */
    @MaxLength(length = 100, msg = "【启运地】最长100个字节", isByte = true)
    private String qyd;

    // ==================== Getter and Setter ====================

    public String getDjxh() {
        return djxh;
    }

    public void setDjxh(String djxh) {
        this.djxh = djxh;
    }

    public String getBgdhgbh() {
        return bgdhgbh;
    }

    public void setBgdhgbh(String bgdhgbh) {
        this.bgdhgbh = bgdhgbh;
    }

    public String getCph() {
        return cph;
    }

    public void setCph(String cph) {
        this.cph = cph;
    }

    public String getCpysCode() {
        return cpysCode;
    }

    public void setCpysCode(String cpysCode) {
        this.cpysCode = cpysCode;
    }

    public String getCpysName() {
        return cpysName;
    }

    public void setCpysName(String cpysName) {
        this.cpysName = cpysName;
    }

    public Date getQyrq() {
        return qyrq;
    }

    public void setQyrq(Date qyrq) {
        this.qyrq = qyrq;
    }

    public String getQyd() {
        return qyd;
    }

    public void setQyd(String qyd) {
        this.qyd = qyd;
    }


    @Override
    public String toString() {
        return "CkllfxEditDTO{" +
                "djxh=" + djxh +
                ", bgdhgbh='" + bgdhgbh + '\'' +
                ", cph='" + cph + '\'' +
                ", cpysCode='" + cpysCode + '\'' +
                ", cpysName='" + cpysName + '\'' +
                ", qyrq=" + qyrq +
                ", qyd='" + qyd + '\'' +
                '}';
    }
}
