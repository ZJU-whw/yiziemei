package com.tl.web.bjts.shzs.model.dto;

import com.tl.web.bjts.shzs.model.domain.TlUserProfile;

/**
 * @描述:
 * @作者: likun
 * @时间: 2021/6/18 14:50
 */
public class LoginDTO extends TlUserProfile{
    /**
     * 当前审核助手版本
     */
    private String shzsVersion;

    public String getShzsVersion() {
        return shzsVersion;
    }

    public void setShzsVersion(String shzsVersion) {
        this.shzsVersion = shzsVersion;
    }
}
