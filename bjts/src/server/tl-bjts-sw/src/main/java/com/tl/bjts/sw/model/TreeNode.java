package com.tl.bjts.sw.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.ArrayList;
import java.util.List;

@JsonIgnoreProperties(value={"sjSwjgDm"})
public class TreeNode {
    private String id;

    private String text;

    private List<TreeNode> item = new ArrayList<>();

    private String sjSwjgDm;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public List<TreeNode> getItem() {
        return item;
    }

    public void setItem(List<TreeNode> item) {
        this.item = item;
    }

    public String getSjSwjgDm() {
        return sjSwjgDm;
    }

    public void setSjSwjgDm(String sjSwjgDm) {
        this.sjSwjgDm = sjSwjgDm;
    }
}
