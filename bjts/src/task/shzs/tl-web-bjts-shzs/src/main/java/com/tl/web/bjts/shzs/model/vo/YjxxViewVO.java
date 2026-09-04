package com.tl.web.bjts.shzs.model.vo;

import java.util.List;

/**
 * Created by Neo Lin on 2017/6/20.
 */
public class YjxxViewVO {

    private Integer total;
    private Long sbid;
    private Integer yjclose;

    private String status;
    List<YjxxVO> yjxxs;

    public String getStatus() {
        return this.status;

    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public List<YjxxVO> getYjxxs() {
        return yjxxs;
    }

    public void setYjxxs(List<YjxxVO> yjxxs) {
        this.yjxxs = yjxxs;
    }

    public Integer getYjclose() {
        return yjclose;
    }

    public void setYjclose(Integer yjclose) {
        this.yjclose = yjclose;
    }
}
