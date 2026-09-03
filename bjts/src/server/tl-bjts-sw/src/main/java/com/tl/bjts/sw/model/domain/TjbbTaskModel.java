package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TJBB_TASK")
public class TjbbTaskModel implements Serializable {
    @Id
    @Column(name = "BBDLDM")
    private String bbdldm;

    @Id
    @Column(name = "SWJGDM")
    private String swjgdm;

    @Id
    @Column(name = "NY")
    private String ny;

    @Column(name = "STATUS")
    private String status;

    @Column(name = "SJSWJG")
    private String sjswjg;

    @Column(name = "CJTIME")
    private Date cjtime;

    @Column(name = "CJR")
    private String cjr;

    @Column(name = "ZBTIME")
    private Date zbtime;

    @Column(name = "ZBR")
    private String zbr;

    @Column(name = "SBTIME")
    private Date sbtime;

    @Column(name = "SBR")
    private String sbr;

    @Column(name = "CHTIME")
    private Date chtime;

    @Column(name = "CHR")
    private String chr;

    @Column(name = "TYPE")
    private String type;

    @Column(name = "SWJGMC")
    private String swjgmc;

    @Column(name = "SWJGJC")
    private String swjgjc;

    @Column(name = "NOTE")
    private String note;

    private static final long serialVersionUID = 1L;

    /**
     * @return BBDLDM
     */
    public String getBbdldm() {
        return bbdldm;
    }

    /**
     * @param bbdldm
     */
    public void setBbdldm(String bbdldm) {
        this.bbdldm = bbdldm == null ? null : bbdldm.trim();
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
     * @return NY
     */
    public String getNy() {
        return ny;
    }

    /**
     * @param ny
     */
    public void setNy(String ny) {
        this.ny = ny == null ? null : ny.trim();
    }

    /**
     * @return STATUS
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status
     */
    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }

    /**
     * @return SJSWJG
     */
    public String getSjswjg() {
        return sjswjg;
    }

    /**
     * @param sjswjg
     */
    public void setSjswjg(String sjswjg) {
        this.sjswjg = sjswjg == null ? null : sjswjg.trim();
    }

    /**
     * @return CJTIME
     */
    public Date getCjtime() {
        return cjtime;
    }

    /**
     * @param cjtime
     */
    public void setCjtime(Date cjtime) {
        this.cjtime = cjtime;
    }

    /**
     * @return CJR
     */
    public String getCjr() {
        return cjr;
    }

    /**
     * @param cjr
     */
    public void setCjr(String cjr) {
        this.cjr = cjr == null ? null : cjr.trim();
    }

    /**
     * @return ZBTIME
     */
    public Date getZbtime() {
        return zbtime;
    }

    /**
     * @param zbtime
     */
    public void setZbtime(Date zbtime) {
        this.zbtime = zbtime;
    }

    /**
     * @return ZBR
     */
    public String getZbr() {
        return zbr;
    }

    /**
     * @param zbr
     */
    public void setZbr(String zbr) {
        this.zbr = zbr == null ? null : zbr.trim();
    }

    /**
     * @return SBTIME
     */
    public Date getSbtime() {
        return sbtime;
    }

    /**
     * @param sbtime
     */
    public void setSbtime(Date sbtime) {
        this.sbtime = sbtime;
    }

    /**
     * @return SBR
     */
    public String getSbr() {
        return sbr;
    }

    /**
     * @param sbr
     */
    public void setSbr(String sbr) {
        this.sbr = sbr == null ? null : sbr.trim();
    }

    /**
     * @return CHTIME
     */
    public Date getChtime() {
        return chtime;
    }

    /**
     * @param chtime
     */
    public void setChtime(Date chtime) {
        this.chtime = chtime;
    }

    /**
     * @return CHR
     */
    public String getChr() {
        return chr;
    }

    /**
     * @param chr
     */
    public void setChr(String chr) {
        this.chr = chr == null ? null : chr.trim();
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
     * @return SWJGMC
     */
    public String getSwjgmc() {
        return swjgmc;
    }

    /**
     * @param swjgmc
     */
    public void setSwjgmc(String swjgmc) {
        this.swjgmc = swjgmc == null ? null : swjgmc.trim();
    }

    /**
     * @return SWJGJC
     */
    public String getSwjgjc() {
        return swjgjc;
    }

    /**
     * @param swjgjc
     */
    public void setSwjgjc(String swjgjc) {
        this.swjgjc = swjgjc == null ? null : swjgjc.trim();
    }

    /**
     * @return NOTE
     */
    public String getNote() {
        return note;
    }

    /**
     * @param note
     */
    public void setNote(String note) {
        this.note = note == null ? null : note.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", bbdldm=").append(bbdldm);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", ny=").append(ny);
        sb.append(", status=").append(status);
        sb.append(", sjswjg=").append(sjswjg);
        sb.append(", cjtime=").append(cjtime);
        sb.append(", cjr=").append(cjr);
        sb.append(", zbtime=").append(zbtime);
        sb.append(", zbr=").append(zbr);
        sb.append(", sbtime=").append(sbtime);
        sb.append(", sbr=").append(sbr);
        sb.append(", chtime=").append(chtime);
        sb.append(", chr=").append(chr);
        sb.append(", type=").append(type);
        sb.append(", swjgmc=").append(swjgmc);
        sb.append(", swjgjc=").append(swjgjc);
        sb.append(", note=").append(note);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}