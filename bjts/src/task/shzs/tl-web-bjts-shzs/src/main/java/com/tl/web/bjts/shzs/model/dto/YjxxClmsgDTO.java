package com.tl.web.bjts.shzs.model.dto;

/**
 * 作者:     zhouxi
 * 创建时间： 2018-12-19
 * 描述：     批量处理预警信息
 */
public class YjxxClmsgDTO {

    private String lcslid;

    private Long sbid;

    private String[] ids;  //批量处理的预警id 集合

    private String clMsg; // 处理意见

    public String[] getIds() {
        return ids;
    }

    public String getLcslid() {
        return this.lcslid;

    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public void setIds(String[] ids) {
        this.ids = ids;
    }

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public String getClMsg() {
        return clMsg;
    }

    public void setClMsg(String clMsg) {
        this.clMsg = clMsg;
    }
}
