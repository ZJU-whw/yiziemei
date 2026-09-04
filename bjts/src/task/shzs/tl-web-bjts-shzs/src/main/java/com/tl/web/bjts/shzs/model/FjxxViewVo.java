package com.tl.web.bjts.shzs.model;

import com.google.gson.JsonArray;

import java.util.List;
import java.util.Map;

/**
 * 附件列表
 * Created by likun on 2017/6/19.
 */
public class FjxxViewVo {
    private Integer total;
    private Long sbid;
    private List<FjxxVo> fjxxs;

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

    public List<FjxxVo> getFjxxs() {
        return fjxxs;
    }

    public void setFjxxs(List<FjxxVo> fjxxs) {
        this.fjxxs = fjxxs;
    }
}
