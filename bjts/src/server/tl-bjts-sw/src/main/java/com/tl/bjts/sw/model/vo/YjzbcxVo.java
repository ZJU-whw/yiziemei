package com.tl.bjts.sw.model.vo;

import java.util.List;

public class YjzbcxVo {
    private String yjcode;
    private String yjname;

    private String yjobject;
    private String yjlx;
    private List<ZbnameVo> yjzb;

    public String getYjobject() {
        return yjobject;
    }

    public void setYjobject(String yjobject) {
        this.yjobject = yjobject;
    }

    public String getYjlx() {
        return yjlx;
    }

    public void setYjlx(String yjlx) {
        this.yjlx = yjlx;
    }

    public String getYjcode() {
        return yjcode;
    }

    public void setYjcode(String yjcode) {
        this.yjcode = yjcode;
    }

    public String getYjname() {
        return yjname;
    }

    public void setYjname(String yjname) {
        this.yjname = yjname;
    }

    public List<ZbnameVo> getYjzb() {
        return yjzb;
    }

    public void setYjzb(List<ZbnameVo> yjzb) {
        this.yjzb = yjzb;
    }
}
