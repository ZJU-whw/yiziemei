package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TJBB_REPORT_HEADER")
public class TjbbHeaderModel implements Serializable {
    @Id
    @Column(name = "BBDM")
    private String bbdm;

    @Id
    @Column(name = "BH")
    private String bh;

    @Id
    @Column(name = "TYPE")
    private String type;

    @Column(name = "SHOWNAME")
    private String showname;

    @Column(name = "ISMERG")
    private String ismerg;

    @Column(name = "DISPWIDTH")
    private String dispwidth;

    @Column(name = "DISPHIGHT")
    private String disphight;

    @Column(name = "H")
    private String h;

    @Column(name = "W")
    private String w;

    @Column(name = "HORDER")
    private BigDecimal horder;

    @Column(name = "VORDER")
    private BigDecimal vorder;

    @Column(name = "QYBJ")
    private String qybj;

    private static final long serialVersionUID = 1L;

    /**
     * @return BBDM
     */
    public String getBbdm() {
        return bbdm;
    }

    /**
     * @param bbdm
     */
    public void setBbdm(String bbdm) {
        this.bbdm = bbdm == null ? null : bbdm.trim();
    }

    /**
     * @return BH
     */
    public String getBh() {
        return bh;
    }

    /**
     * @param bh
     */
    public void setBh(String bh) {
        this.bh = bh == null ? null : bh.trim();
    }

    /**
     * @return TYPE
     */
    public String getType() {
        return type;
    }

    /**
     * @param type
     */
    public void setType(String type) {
        this.type = type == null ? null : type.trim();
    }

    /**
     * @return SHOWNAME
     */
    public String getShowname() {
        return showname;
    }

    /**
     * @param showname
     */
    public void setShowname(String showname) {
        this.showname = showname == null ? null : showname.trim();
    }

    /**
     * @return ISMERG
     */
    public String getIsmerg() {
        return ismerg;
    }

    /**
     * @param ismerg
     */
    public void setIsmerg(String ismerg) {
        this.ismerg = ismerg == null ? null : ismerg.trim();
    }

    /**
     * @return DISPWIDTH
     */
    public String getDispwidth() {
        return dispwidth;
    }

    /**
     * @param dispwidth
     */
    public void setDispwidth(String dispwidth) {
        this.dispwidth = dispwidth == null ? null : dispwidth.trim();
    }

    /**
     * @return DISPHIGHT
     */
    public String getDisphight() {
        return disphight;
    }

    /**
     * @param disphight
     */
    public void setDisphight(String disphight) {
        this.disphight = disphight == null ? null : disphight.trim();
    }

    /**
     * @return H
     */
    public String getH() {
        return h;
    }

    /**
     * @param h
     */
    public void setH(String h) {
        this.h = h == null ? null : h.trim();
    }

    /**
     * @return W
     */
    public String getW() {
        return w;
    }

    /**
     * @param w
     */
    public void setW(String w) {
        this.w = w == null ? null : w.trim();
    }

    /**
     * @return HORDER
     */
    public BigDecimal getHorder() {
        return horder;
    }

    /**
     * @param horder
     */
    public void setHorder(BigDecimal horder) {
        this.horder = horder;
    }

    /**
     * @return VORDER
     */
    public BigDecimal getVorder() {
        return vorder;
    }

    /**
     * @param vorder
     */
    public void setVorder(BigDecimal vorder) {
        this.vorder = vorder;
    }

    /**
     * @return QYBJ
     */
    public String getQybj() {
        return qybj;
    }

    /**
     * @param qybj
     */
    public void setQybj(String qybj) {
        this.qybj = qybj == null ? null : qybj.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", bbdm=").append(bbdm);
        sb.append(", bh=").append(bh);
        sb.append(", type=").append(type);
        sb.append(", showname=").append(showname);
        sb.append(", ismerg=").append(ismerg);
        sb.append(", dispwidth=").append(dispwidth);
        sb.append(", disphight=").append(disphight);
        sb.append(", h=").append(h);
        sb.append(", w=").append(w);
        sb.append(", horder=").append(horder);
        sb.append(", vorder=").append(vorder);
        sb.append(", qybj=").append(qybj);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}