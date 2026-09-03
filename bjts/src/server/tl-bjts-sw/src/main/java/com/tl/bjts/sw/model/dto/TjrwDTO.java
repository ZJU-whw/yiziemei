package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

import java.util.Date;

/**
 * @描述: 统计任务对用的数据传输对象
 * @作者: likun
 * @时间: 2020/8/12 14:05
 */
public class TjrwDTO extends BaseListDTO {
    private String swjg;
    private String tjlx;
    private String tjrq;
    private String tjr;

    public String getSwjg() {
        return swjg;
    }

    public void setSwjg(String swjg) {
        this.swjg = swjg;
    }

    public String getTjlx() {
        return tjlx;
    }

    public void setTjlx(String tjlx) {
        this.tjlx = tjlx;
    }


    public String getTjrq() {
        return tjrq;
    }

    public void setTjrq(String tjrq) {
        this.tjrq = tjrq;
    }

    public String getTjr() {
        return tjr;
    }

    public void setTjr(String tjr) {
        this.tjr = tjr;
    }
}
