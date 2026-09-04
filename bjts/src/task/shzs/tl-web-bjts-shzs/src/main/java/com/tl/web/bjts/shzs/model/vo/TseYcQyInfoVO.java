package com.tl.web.bjts.shzs.model.vo;

/**
 * @Author whg
 * @create 2024/5/24 10:59
 * @description：
 */
public class TseYcQyInfoVO {

    /**
     * 登记序号
     */
    private String djxh;

    /**
     * 税务机关代码
     */
    private String swjgDm;

    public String getDjxh() {
        return djxh;
    }

    public void setDjxh(String djxh) {
        this.djxh = djxh;
    }

    public String getSwjgDm() {
        return swjgDm;
    }

    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm;
    }

    @Override
    public String toString() {
        return super.toString();
    }
}
