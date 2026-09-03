package com.tl.bjts.sw.model.vo;

import com.tl.common.ext.model.PageInfo;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @author: Mamf
 * @date: 2021/11/24
 * @description
 */
public class SjjcDynamicVo {

    private List<String> title;

    private PageInfo<List<LinkedHashMap>> list;

    private Map hj;

    private String tips;

    private String pid;

    public String getPid() {
        return this.pid;

    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getTips() {
        return this.tips;

    }

    public void setTips(String tips) {
        this.tips = tips;
    }

    public List<String> getTitle() {
        return this.title;

    }

    public void setTitle(List<String> title) {
        this.title = title;
    }

    public PageInfo<List<LinkedHashMap>> getList() {
        return this.list;

    }

    public void setList(PageInfo<List<LinkedHashMap>> list) {
        this.list = list;
    }

    public Map getHj() {
        return this.hj;

    }

    public void setHj(Map hj) {
        this.hj = hj;
    }
}
