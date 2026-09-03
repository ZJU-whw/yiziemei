package com.tl.bjts.sw.model.vo;

/**
 * @Description: 物流链路二维码返回VO
 * @Author: sxf
 * @Date: 2026-07-21
 */
public class CkllfxQrVO {

    public CkllfxQrVO() {
    }

    public CkllfxQrVO(String qrBase, String format) {
        this.qrBase = qrBase;
        this.format = format;
    }

    /** 二维码图片base64（PNG格式） */
    private String qrBase;

    /**
     * 二维码图片格式
     */
    private String format;

    public String getQrBase() {
        return qrBase;
    }

    public void setQrBase(String qrBase) {
        this.qrBase = qrBase;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }
}
