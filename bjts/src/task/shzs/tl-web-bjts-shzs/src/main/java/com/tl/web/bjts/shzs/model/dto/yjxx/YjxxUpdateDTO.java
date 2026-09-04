package com.tl.web.bjts.shzs.model.dto.yjxx;

import com.tl.common.ext.annotation.NotEmpty;

/**
 * @Author whg
 * @create 2024/4/8 16:07
 * @description：
 */
public class YjxxUpdateDTO {

    /**
     * 流程实例ID
     */
    @NotEmpty(msg = "流程实例ID不能为空")
    private String lcslid;

    /**
     * 处理动作：0-忽略、1-中断
     */
    @NotEmpty(msg = "处理动作不能为空")
    private String cldz;

    /**
     * 后续操作说明
     */
    private String hxczsm;

    public String getLcslid() {
        return lcslid;
    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public String getCldz() {
        return cldz;
    }

    public void setCldz(String cldz) {
        this.cldz = cldz;
    }

    public String getHxczsm() {
        return hxczsm;
    }

    public void setHxczsm(String hxczsm) {
        this.hxczsm = hxczsm;
    }

    @Override
    public String toString() {
        return super.toString();
    }
}
