package com.tl.web.bjts.shzs.model;

import java.io.Serializable;

/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2017-06-23
 **/

public class UserVo implements Serializable {
    private String name;
    private String password;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}