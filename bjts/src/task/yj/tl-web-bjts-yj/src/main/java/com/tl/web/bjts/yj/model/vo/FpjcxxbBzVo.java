package com.tl.web.bjts.yj.model.vo;

/**
 * @description 发票备注信息参数视图
 * @author: Mamf
 * @date: 2026/5/25 15:46
 */
public class FpjcxxbBzVo {

    private String bz;

    private boolean isValidBz;

    public String getBz() {
        return this.bz;

    }

    public void setBz(String bz) {
        this.bz = bz;
    }

    public boolean getIsValidBz() {
        return this.isValidBz;

    }

    public void setIsValidBz(boolean validBz) {
        this.isValidBz = validBz;
    }
}
