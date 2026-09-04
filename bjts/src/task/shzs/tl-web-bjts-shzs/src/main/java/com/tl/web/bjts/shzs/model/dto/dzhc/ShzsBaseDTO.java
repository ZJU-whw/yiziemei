package com.tl.web.bjts.shzs.model.dto.dzhc;

import com.tl.common.ext.annotation.NotEmpty;

/**
 * @描述: 来自审核助手交互的dto对象
 * @作者: likun
 * @时间: 2022/4/22 15:19
 */
public class ShzsBaseDTO {
    @NotEmpty(msg = "请求参数【功能号】不能为空")
    private String funcNo; // 功能号
    private String nsrsbh; // 税号
    @NotEmpty(msg = "请求参数【流水号】不能为空")
    private String transno; // 流水号
    @NotEmpty(msg = "请求参数【报文内容】不能为空")
    private String content; // 请求参数内容
    private String czry; // 操作人员（代码+名称）

    public String getFuncNo() {
        return funcNo;
    }

    public void setFuncNo(String funcNo) {
        this.funcNo = funcNo;
    }

    public String getNsrsbh() {
        return nsrsbh;
    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getTransno() {
        return transno;
    }

    public void setTransno(String transno) {
        this.transno = transno;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCzry() {
        return czry;
    }

    public void setCzry(String czry) {
        this.czry = czry;
    }
}

