package com.tl.web.bjts.yj.model.vo;

/**
 * @Author：Mamf
 * @Date: 2019/7/25.
 * @Description:
 */
public class YjzbItemVo {

    private String zbcode;
    private String zbname;
    private String jslx;
    private String p1name;
    private String p1val;
    private String p2name;
    private String p2val;
    private String p3name;
    private String p3val;
    private String p4name;
    private String p4val;
    private String score;
    private String yjmsg;

    private String yxbz;

    private String syqy;

    private String sysw;

    public String getP3name() {
        return this.p3name;

    }

    public void setP3name(String p3name) {
        this.p3name = p3name;
    }

    public String getP3val() {
        return this.p3val;

    }

    public void setP3val(String p3val) {
        this.p3val = p3val;
    }

    public String getP4name() {
        return this.p4name;

    }

    public void setP4name(String p4name) {
        this.p4name = p4name;
    }

    public String getP4val() {
        return this.p4val;

    }

    public void setP4val(String p4val) {
        this.p4val = p4val;
    }

    public String getSyqy() {
        return syqy;
    }

    public void setSyqy(String syqy) {
        this.syqy = syqy;
    }

    public String getSysw() {
        return sysw;
    }

    public void setSysw(String sysw) {
        this.sysw = sysw;
    }

    public String getYxbz() {
        return yxbz;
    }

    public void setYxbz(String yxbz) {
        this.yxbz = yxbz;
    }

    public String getZbcode() {
        return zbcode;
    }

    public void setZbcode(String zbcode) {
        this.zbcode = zbcode;
    }

    public String getZbname() {
        return zbname;
    }

    public void setZbname(String zbname) {
        this.zbname = zbname;
    }

    public String getJslx() {
        return jslx;
    }

    public void setJslx(String jslx) {
        this.jslx = jslx;
    }

    public String getP1name() {
        return p1name;
    }

    public void setP1name(String p1name) {
        this.p1name = p1name;
    }

    public String getP1val() {
        return p1val;
    }

    public void setP1val(String p1val) {
        this.p1val = p1val;
    }

    public String getP2name() {
        return p2name;
    }

    public void setP2name(String p2name) {
        this.p2name = p2name;
    }

    public String getP2val() {
        return p2val;
    }

    public void setP2val(String p2val) {
        this.p2val = p2val;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    public String getYjmsg() {
        return yjmsg;
    }

    public void setYjmsg(String yjmsg) {
        this.yjmsg = yjmsg;
    }

    @Override
    public String toString() {
        return "YjzbItemVo{" +
                "zbcode='" + zbcode + '\'' +
                ", zbname='" + zbname + '\'' +
                ", jslx='" + jslx + '\'' +
                ", p1name='" + p1name + '\'' +
                ", p1val='" + p1val + '\'' +
                ", p2name='" + p2name + '\'' +
                ", p2val='" + p2val + '\'' +
                ", score='" + score + '\'' +
                ", yjmsg='" + yjmsg + '\'' +
                ", yxbz='" + yxbz + '\'' +
                ", syqy='" + syqy + '\'' +
                ", sysw='" + sysw + '\'' +
                '}';
    }
}
