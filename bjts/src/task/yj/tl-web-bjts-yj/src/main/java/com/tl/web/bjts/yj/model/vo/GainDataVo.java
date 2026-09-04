package com.tl.web.bjts.yj.model.vo;

import java.math.BigDecimal;

public class GainDataVo {

    private String sbztDm;

    private BigDecimal delay;   //允许重新获取已加锁的申报信息的时间

    private String start;

    private String end;

    private byte[] sbbw;

    private String orderByCaluse;

    private String less;

    //报文大小
    private Integer size;

    public String getLess() {
        return less;
    }

    public void setLess(String less) {
        this.less = less;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }

    public byte[] getSbbw() {
        return sbbw;
    }

    public void setSbbw(byte[] sbbw) {
        this.sbbw = sbbw;
    }

    public String getSbztDm() {
        return sbztDm;
    }

    public void setSbztDm(String sbztDm) {
        this.sbztDm = sbztDm;
    }

    public BigDecimal getDelay() {
        return delay;
    }

    public void setDelay(BigDecimal delay) {
        this.delay = delay;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public String getOrderByCaluse() {
        return orderByCaluse;
    }

    public void setOrderByCaluse(String orderByCaluse) {
        this.orderByCaluse = orderByCaluse;
    }
}
