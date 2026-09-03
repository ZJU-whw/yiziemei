package com.tl.bjts.sw.model;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2019/11/1.
 * @Description:
 */
public class YxjNode {

    private String pid;

    private String id;

    private Integer yxj;

    private List<YxjNode> children = new ArrayList<>();

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Integer getYxj() {
        return yxj;
    }

    public void setYxj(Integer yxj) {
        this.yxj = yxj;
    }

    public List<YxjNode> getChildren() {
        return children;
    }

    public void setChildren(List<YxjNode> children) {
        this.children = children;
    }
}
