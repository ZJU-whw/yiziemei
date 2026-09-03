package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_DIC_CODE")
public class YjDicModel implements Serializable {
    @Id
    @Column(name = "YJCODE")
    private String yjcode;

    @Column(name = "YJNAME")
    private String yjname;

    @Column(name = "YJINFO")
    private String yjinfo;

    @Column(name = "ZXFLAG")
    private String zxflag;

    @Column(name = "YJOBJECT")
    private String yjobject;

    @Column(name = "YXBZ")
    private String yxbz;

    @Column(name = "YJLX")
    private String yjlx;

    @Column(name = "TSYWLX")
    private BigDecimal tsywlx;

    @Column(name = "SWJG_FW")
    private String swjgFw;

    private static final long serialVersionUID = 1L;

    public String getSwjgFw() {
        return this.swjgFw;

    }

    public void setSwjgFw(String swjgFw) {
        this.swjgFw = swjgFw;
    }

    /**
     * @return YJCODE
     */
    public String getYjcode() {
        return yjcode;
    }

    /**
     * @param yjcode
     */
    public void setYjcode(String yjcode) {
        this.yjcode = yjcode == null ? null : yjcode.trim();
    }

    /**
     * @return YJNAME
     */
    public String getYjname() {
        return yjname;
    }

    /**
     * @param yjname
     */
    public void setYjname(String yjname) {
        this.yjname = yjname == null ? null : yjname.trim();
    }

    /**
     * @return YJINFO
     */
    public String getYjinfo() {
        return yjinfo;
    }

    /**
     * @param yjinfo
     */
    public void setYjinfo(String yjinfo) {
        this.yjinfo = yjinfo == null ? null : yjinfo.trim();
    }

    /**
     * @return ZXFLAG
     */
    public String getZxflag() {
        return zxflag;
    }

    /**
     * @param zxflag
     */
    public void setZxflag(String zxflag) {
        this.zxflag = zxflag == null ? null : zxflag.trim();
    }

    /**
     * @return YJOBJECT
     */
    public String getYjobject() {
        return yjobject;
    }

    /**
     * @param yjobject
     */
    public void setYjobject(String yjobject) {
        this.yjobject = yjobject == null ? null : yjobject.trim();
    }

    /**
     * @return YXBZ
     */
    public String getYxbz() {
        return yxbz;
    }

    /**
     * @param yxbz
     */
    public void setYxbz(String yxbz) {
        this.yxbz = yxbz == null ? null : yxbz.trim();
    }

    /**
     * @return YJLX
     */
    public String getYjlx() {
        return yjlx;
    }

    /**
     * @param yjlx
     */
    public void setYjlx(String yjlx) {
        this.yjlx = yjlx == null ? null : yjlx.trim();
    }

    /**
     * @return TSYWLX
     */
    public BigDecimal getTsywlx() {
        return tsywlx;
    }

    /**
     * @param tsywlx
     */
    public void setTsywlx(BigDecimal tsywlx) {
        this.tsywlx = tsywlx;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", yjcode=").append(yjcode);
        sb.append(", yjname=").append(yjname);
        sb.append(", yjinfo=").append(yjinfo);
        sb.append(", zxflag=").append(zxflag);
        sb.append(", yjobject=").append(yjobject);
        sb.append(", yxbz=").append(yxbz);
        sb.append(", yjlx=").append(yjlx);
        sb.append(", tsywlx=").append(tsywlx);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}