package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.bjts.swgl.general.annotation.Dict;

import java.util.Date;

/**
 * @描述: 统计任务列表
 * @作者: likun
 * @时间: 2020/8/12 14:09
 */
public class TjrwListVO {
    private String rwlx;
    private String rwhash;
    private String tjlx;
    private String tjlxMc;
    private String tjtj; //统计条件
    private String tjtjMc;
    private String swjg;
    private String tjr;
    @JsonFormat(pattern="yyyy-MM-dd",timezone = "GMT+8")
    private Date tjrq;
    private String bz;

    public String getRwlx() {
        return rwlx;
    }

    public void setRwlx(String rwlx) {
        this.rwlx = rwlx;
    }

    public String getRwhash() {
        return rwhash;
    }

    public void setRwhash(String rwhash) {
        this.rwhash = rwhash;
    }

    public String getTjlx() {
        return tjlx;
    }

    public void setTjlx(String tjlx) {
        this.tjlx = tjlx;
    }

    public String getTjlxMc() {
        return tjlxMc;
    }

    public void setTjlxMc(String tjlxMc) {
        this.tjlxMc = tjlxMc;
    }

    public String getTjtj() {
        return tjtj;
    }

    public void setTjtj(String tjtj) {
        this.tjtj = tjtj;
    }

    public String getTjtjMc() {
        return tjtjMc;
    }

    public void setTjtjMc(String tjtjMc) {
        this.tjtjMc = tjtjMc;
    }

    public String getSwjg() {
        return swjg;
    }

    public void setSwjg(String swjg) {
        this.swjg = swjg;
    }

    public String getTjr() {
        return tjr;
    }

    public void setTjr(String tjr) {
        this.tjr = tjr;
    }

    public Date getTjrq() {
        return tjrq;
    }

    public void setTjrq(Date tjrq) {
        this.tjrq = tjrq;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }
}
