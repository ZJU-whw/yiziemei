package com.tl.bjts.sw.model.domain;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.common.ext.annotation.MaxLength;
import com.tl.common.ext.annotation.NotEmpty;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_CS_BMD_SUB")
public class YjCsBmdSubModel implements Serializable {
    @Id
    @Column(name = "BSID")
    private Long bsid;

    @Column(name = "BMDID")
    private Long bmdid;

    @Column(name = "YJ_OBJECT")
    @NotEmpty(msg = "【放行对象】不能为空")
    @MaxLength(length = 30,msg = "【放行对象】内容超长，限制30个字符")
    private String yjObject;

    @Column(name = "YJ_OBJNAME")
    @MaxLength(length = 80,msg = "【放行对象名称】内容超长，限制80个字符")
    private String yjObjname;

    @Column(name = "YXBZ")
    private String yxbz;

    @Column(name = "LRR")
    private String lrr;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @Column(name = "LRRQ")
    private Date lrrq;

    @Column(name = "XGR")
    private String xgr;

    @Column(name = "XGRQ")
    private Date xgrq;

    private static final long serialVersionUID = 1L;

    /**
     * @return BSID
     */
    public Long getBsid() {
        return bsid;
    }

    /**
     * @param bsid
     */
    public void setBsid(Long bsid) {
        this.bsid = bsid;
    }

    /**
     * @return BMDID
     */
    public Long getBmdid() {
        return bmdid;
    }

    /**
     * @param bmdid
     */
    public void setBmdid(Long bmdid) {
        this.bmdid = bmdid;
    }

    /**
     * @return YJ_OBJECT
     */
    public String getYjObject() {
        return yjObject;
    }

    /**
     * @param yjObject
     */
    public void setYjObject(String yjObject) {
        this.yjObject = yjObject == null ? null : yjObject.trim();
    }

    /**
     * @return YJ_OBJNAME
     */
    public String getYjObjname() {
        return yjObjname;
    }

    /**
     * @param yjObjname
     */
    public void setYjObjname(String yjObjname) {
        this.yjObjname = yjObjname == null ? null : yjObjname.trim();
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
     * @return LRR
     */
    public String getLrr() {
        return lrr;
    }

    /**
     * @param lrr
     */
    public void setLrr(String lrr) {
        this.lrr = lrr == null ? null : lrr.trim();
    }

    /**
     * @return LRRQ
     */
    public Date getLrrq() {
        return lrrq;
    }

    /**
     * @param lrrq
     */
    public void setLrrq(Date lrrq) {
        this.lrrq = lrrq;
    }

    /**
     * @return XGR
     */
    public String getXgr() {
        return xgr;
    }

    /**
     * @param xgr
     */
    public void setXgr(String xgr) {
        this.xgr = xgr == null ? null : xgr.trim();
    }

    /**
     * @return XGRQ
     */
    public Date getXgrq() {
        return xgrq;
    }

    /**
     * @param xgrq
     */
    public void setXgrq(Date xgrq) {
        this.xgrq = xgrq;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", bsid=").append(bsid);
        sb.append(", bmdid=").append(bmdid);
        sb.append(", yjObject=").append(yjObject);
        sb.append(", yjObjname=").append(yjObjname);
        sb.append(", yxbz=").append(yxbz);
        sb.append(", lrr=").append(lrr);
        sb.append(", lrrq=").append(lrrq);
        sb.append(", xgr=").append(xgr);
        sb.append(", xgrq=").append(xgrq);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}