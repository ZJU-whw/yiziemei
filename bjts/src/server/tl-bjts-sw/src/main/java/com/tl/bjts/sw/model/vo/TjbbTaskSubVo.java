package com.tl.bjts.sw.model.vo;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @Author：Mamf
 * @Date: 2019/9/29.
 * @Description:
 */
public class TjbbTaskSubVo {

    private String bbid;

    private String bbdm;

    private String bbmc;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone="GMT+8")
    private Date hztime;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone="GMT+8")
    private Date xgtime;

    private String ishz;

    private String isxg;

    public String getBbdm() {
        return bbdm;
    }

    public void setBbdm(String bbdm) {
        this.bbdm = bbdm;
    }

    public String getBbmc() {
        return bbmc;
    }

    public void setBbmc(String bbmc) {
        this.bbmc = bbmc;
    }

    public Date getHztime() {
        return hztime;
    }

    public void setHztime(Date hztime) {
        this.hztime = hztime;
    }

    public Date getXgtime() {
        return xgtime;
    }

    public void setXgtime(Date xgtime) {
        this.xgtime = xgtime;
    }

    public String getIshz() {
        return ishz;
    }

    public void setIshz(String ishz) {
        this.ishz = ishz;
    }

    public String getIsxg() {
        return isxg;
    }

    public void setIsxg(String isxg) {
        this.isxg = isxg;
    }

    public String getBbid() {
        return bbid;
    }

    public void setBbid(String bbid) {
        this.bbid = bbid;
    }
}
