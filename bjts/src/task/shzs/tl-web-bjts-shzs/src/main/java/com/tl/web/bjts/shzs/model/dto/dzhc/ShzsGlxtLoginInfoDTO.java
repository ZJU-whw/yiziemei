package com.tl.web.bjts.shzs.model.dto.dzhc;

/**
 * @描述: 审核助手登录管理系统信息dto
 * @作者: likun
 * @时间: 2022/4/24 13:46
 */
public class ShzsGlxtLoginInfoDTO {
    // 登录名
    private String loginName;
    // 登录token凭证
    private String token;

    public String getLoginName() {
        return loginName;
    }

    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}
