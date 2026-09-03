package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

/**
 * @Author：Mamf
 * @Date: 2019/9/4.
 * @Description:
 */
public class IdDTO extends BaseListDTO {

    private Long id;

    private String yjcode;

    private String tsjg;

    private String zbcode;

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

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getZbcode() {
        return zbcode;
    }

    public void setZbcode(String zbcode) {
        this.zbcode = zbcode;
    }
}
