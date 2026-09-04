package com.tl.web.bjts.shzs.model.vo;

import java.util.List;

/**
 * @Author whg
 * @create 2024/4/8 15:33
 * @description：
 */
public class YjxxCreateVO {

    /**
     * 内控业务描述
     */
    private List<String> nkywms;

    /**
     * 流程实例ID
     */
    private String lcslid;

    public List<String> getNkywms() {
        return nkywms;
    }

    public void setNkywms(List<String> nkywms) {
        this.nkywms = nkywms;
    }

    public String getLcslid() {
        return lcslid;
    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }
}
