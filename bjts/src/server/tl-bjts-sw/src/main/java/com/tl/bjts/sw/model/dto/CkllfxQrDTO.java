package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.annotation.NotNull;

/**
 * @Description: 物流链路二维码生成请求DTO
 * @Author: sxf
 * @Date: 2026-07-21
 */
public class CkllfxQrDTO {

    /** 金三企业登记序号 */
    @NotNull(msg = "登记序号不能为空")
    private String djxh;

    /** 出口报关单号（18位） */
    @NotEmpty(msg = "报关单号不能为空")
    private String bgdhgbh;

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

    @Override
    public String toString() {
        return "CkllfxQrDTO{" +
                "djxh=" + djxh +
                ", bgdhgbh='" + bgdhgbh + '\'' +
                '}';
    }
}
