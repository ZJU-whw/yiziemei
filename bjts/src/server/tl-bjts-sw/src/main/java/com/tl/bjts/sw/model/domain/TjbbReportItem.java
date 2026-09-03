package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "TJBB_REPORT_ITEM")
public class TjbbReportItem implements Serializable {
    @Id
    @Column(name = "BBDLDM")
    private String bbdldm;

    @Column(name = "BBDLMC")
    private String bbdlmc;

    @Column(name = "BBDLJC")
    private String bbdljc;

    @Column(name = "NOTE")
    private String note;

    @Column(name = "TYPE")
    private String type;

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
     * @return BBDLMC
     */
    public String getBbdlmc() {
        return bbdlmc;
    }

    /**
     * @param bbdlmc
     */
    public void setBbdlmc(String bbdlmc) {
        this.bbdlmc = bbdlmc == null ? null : bbdlmc.trim();
    }

    /**
     * @return BBDLJC
     */
    public String getBbdljc() {
        return bbdljc;
    }

    /**
     * @param bbdljc
     */
    public void setBbdljc(String bbdljc) {
        this.bbdljc = bbdljc == null ? null : bbdljc.trim();
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

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", bbdldm=").append(bbdldm);
        sb.append(", bbdlmc=").append(bbdlmc);
        sb.append(", bbdljc=").append(bbdljc);
        sb.append(", note=").append(note);
        sb.append(", type=").append(type);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}