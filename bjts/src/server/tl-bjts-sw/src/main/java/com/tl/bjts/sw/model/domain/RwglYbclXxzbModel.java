package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "RWGL_YBCL_XXZB")
public class RwglYbclXxzbModel implements Serializable {
    @Id
    @Column(name = "RWLX")
    private String rwlx;

    @Id
    @Column(name = "RWHASH")
    private String rwhash;

    @Column(name = "RWNAME")
    private String rwname;

    @Column(name = "RWBW")
    private String rwbw;

    @Column(name = "RWMS")
    private String rwms;

    @Column(name = "RWZT")
    private String rwzt;

    @Column(name = "TQBZ")
    private String tqbz;

    @Column(name = "TQCS")
    private Short tqcs;

    @Column(name = "TQSJ")
    private Date tqsj;

    @Column(name = "FRTIME")
    private Date frtime;

    @Column(name = "FRNUM")
    private Short frnum;

    @Column(name = "READNUM")
    private Short readnum;

    @Column(name = "READTOTAL")
    private Short readtotal;

    @Column(name = "CZRYDM")
    private String czrydm;

    @Column(name = "CZRYMC")
    private String czrymc;

    @Column(name = "CRTIME")
    private Date crtime;

    @Column(name = "SWJGDM")
    private String swjgdm;

    @Column(name = "BZ")
    private String bz;

    private static final long serialVersionUID = 1L;

    /**
     * @return RWLX
     */
    public String getRwlx() {
        return rwlx;
    }

    /**
     * @param rwlx
     */
    public void setRwlx(String rwlx) {
        this.rwlx = rwlx == null ? null : rwlx.trim();
    }

    /**
     * @return RWHASH
     */
    public String getRwhash() {
        return rwhash;
    }

    /**
     * @param rwhash
     */
    public void setRwhash(String rwhash) {
        this.rwhash = rwhash == null ? null : rwhash.trim();
    }

    /**
     * @return RWNAME
     */
    public String getRwname() {
        return rwname;
    }

    /**
     * @param rwname
     */
    public void setRwname(String rwname) {
        this.rwname = rwname == null ? null : rwname.trim();
    }

    /**
     * @return RWBW
     */
    public String getRwbw() {
        return rwbw;
    }

    /**
     * @param rwbw
     */
    public void setRwbw(String rwbw) {
        this.rwbw = rwbw == null ? null : rwbw.trim();
    }

    /**
     * @return RWMS
     */
    public String getRwms() {
        return rwms;
    }

    /**
     * @param rwms
     */
    public void setRwms(String rwms) {
        this.rwms = rwms == null ? null : rwms.trim();
    }

    /**
     * @return RWZT
     */
    public String getRwzt() {
        return rwzt;
    }

    /**
     * @param rwzt
     */
    public void setRwzt(String rwzt) {
        this.rwzt = rwzt == null ? null : rwzt.trim();
    }

    /**
     * @return TQBZ
     */
    public String getTqbz() {
        return tqbz;
    }

    /**
     * @param tqbz
     */
    public void setTqbz(String tqbz) {
        this.tqbz = tqbz == null ? null : tqbz.trim();
    }

    /**
     * @return TQCS
     */
    public Short getTqcs() {
        return tqcs;
    }

    /**
     * @param tqcs
     */
    public void setTqcs(Short tqcs) {
        this.tqcs = tqcs;
    }

    /**
     * @return TQSJ
     */
    public Date getTqsj() {
        return tqsj;
    }

    /**
     * @param tqsj
     */
    public void setTqsj(Date tqsj) {
        this.tqsj = tqsj;
    }

    /**
     * @return FRTIME
     */
    public Date getFrtime() {
        return frtime;
    }

    /**
     * @param frtime
     */
    public void setFrtime(Date frtime) {
        this.frtime = frtime;
    }

    /**
     * @return FRNUM
     */
    public Short getFrnum() {
        return frnum;
    }

    /**
     * @param frnum
     */
    public void setFrnum(Short frnum) {
        this.frnum = frnum;
    }

    /**
     * @return READNUM
     */
    public Short getReadnum() {
        return readnum;
    }

    /**
     * @param readnum
     */
    public void setReadnum(Short readnum) {
        this.readnum = readnum;
    }

    /**
     * @return READTOTAL
     */
    public Short getReadtotal() {
        return readtotal;
    }

    /**
     * @param readtotal
     */
    public void setReadtotal(Short readtotal) {
        this.readtotal = readtotal;
    }

    /**
     * @return CZRYDM
     */
    public String getCzrydm() {
        return czrydm;
    }

    /**
     * @param czrydm
     */
    public void setCzrydm(String czrydm) {
        this.czrydm = czrydm == null ? null : czrydm.trim();
    }

    /**
     * @return CZRYMC
     */
    public String getCzrymc() {
        return czrymc;
    }

    /**
     * @param czrymc
     */
    public void setCzrymc(String czrymc) {
        this.czrymc = czrymc == null ? null : czrymc.trim();
    }

    /**
     * @return CRTIME
     */
    public Date getCrtime() {
        return crtime;
    }

    /**
     * @param crtime
     */
    public void setCrtime(Date crtime) {
        this.crtime = crtime;
    }

    /**
     * @return SWJGDM
     */
    public String getSwjgdm() {
        return swjgdm;
    }

    /**
     * @param swjgdm
     */
    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm == null ? null : swjgdm.trim();
    }

    /**
     * @return BZ
     */
    public String getBz() {
        return bz;
    }

    /**
     * @param bz
     */
    public void setBz(String bz) {
        this.bz = bz == null ? null : bz.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", rwlx=").append(rwlx);
        sb.append(", rwhash=").append(rwhash);
        sb.append(", rwname=").append(rwname);
        sb.append(", rwbw=").append(rwbw);
        sb.append(", rwms=").append(rwms);
        sb.append(", rwzt=").append(rwzt);
        sb.append(", tqbz=").append(tqbz);
        sb.append(", tqcs=").append(tqcs);
        sb.append(", tqsj=").append(tqsj);
        sb.append(", frtime=").append(frtime);
        sb.append(", frnum=").append(frnum);
        sb.append(", readnum=").append(readnum);
        sb.append(", readtotal=").append(readtotal);
        sb.append(", czrydm=").append(czrydm);
        sb.append(", czrymc=").append(czrymc);
        sb.append(", crtime=").append(crtime);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", bz=").append(bz);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}