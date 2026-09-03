package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

import java.util.Date;

/**
 * 地区退税情况
 */
public class DqTsqkDTO extends BaseListDTO {
    private String swjgdm;
    private String qylx;
    private Date sbrqq;
    private Date sbrqz;
    private String qxdm;

    public String getQxdm() {
        return qxdm;
    }

    public void setQxdm(String qxdm) {
        this.qxdm = qxdm;
    }

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getQylx() {
        return qylx;
    }

    public void setQylx(String qylx) {
        this.qylx = qylx;
    }

    public Date getSbrqq() {
        return sbrqq;
    }

    public void setSbrqq(Date sbrqq) {
        this.sbrqq = sbrqq;
    }

    public Date getSbrqz() {
        return sbrqz;
    }

    public void setSbrqz(Date sbrqz) {
        this.sbrqz = sbrqz;
    }
}
