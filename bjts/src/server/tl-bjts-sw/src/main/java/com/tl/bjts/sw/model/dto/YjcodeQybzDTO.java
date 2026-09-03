package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.model.BaseListDTO;

/**
 * @Author：Mamf
 * @Date: 2019/9/2.
 * @Description:
 */
public class YjcodeQybzDTO{

    @NotEmpty
    private String yjcode;

    @NotEmpty
    private String yxbz;

    private String tsjg;

    public String getTsjg() {
        return tsjg;
    }

    public void setTsjg(String tsjg) {
        this.tsjg = tsjg;
    }

    public String getYjcode() {
        return yjcode;
    }

    public void setYjcode(String yjcode) {
        this.yjcode = yjcode;
    }

    public String getYxbz() {
        return yxbz;
    }

    public void setYxbz(String yxbz) {
        this.yxbz = yxbz;
    }
}
