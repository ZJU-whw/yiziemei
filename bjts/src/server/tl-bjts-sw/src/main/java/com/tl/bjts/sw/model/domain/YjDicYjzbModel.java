package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_DIC_YJZB")
public class YjDicYjzbModel implements Serializable {
    @Id
    @Column(name = "ZBCODE")
    private String zbcode;

    @Column(name = "YJCODE")
    private String yjcode;

    @Column(name = "YJNAME")
    private String yjname;

    @Column(name = "ZBNAME")
    private String zbname;

    @Column(name = "JSLX")
    private String jslx;

    @Column(name = "P1NAME")
    private String p1name;

    @Column(name = "P1VAL")
    private BigDecimal p1val;

    @Column(name = "P2NAME")
    private String p2name;

    @Column(name = "P2VAL")
    private BigDecimal p2val;

    @Column(name = "P3NAME")
    private String p3name;

    @Column(name = "P3VAL")
    private BigDecimal p3val;

    @Column(name = "P4NAME")
    private String p4name;

    @Column(name = "P4VAL")
    private BigDecimal p4val;

    @Column(name = "SCORE")
    private Integer score;

    @Column(name = "YJMSG")
    private String yjmsg;

    @Column(name = "NOTE")
    private String note;

    @Column(name = "WSQL")
    private String wsql;

    @Column(name = "SYSW")
    private String sysw;

    @Column(name = "SYQY")
    private String syqy;

    private static final long serialVersionUID = 1L;

    public String getP3name() {
        return this.p3name;

    }

    public void setP3name(String p3name) {
        this.p3name = p3name;
    }

    public BigDecimal getP3val() {
        return this.p3val;

    }

    public void setP3val(BigDecimal p3val) {
        this.p3val = p3val;
    }

    public String getP4name() {
        return this.p4name;

    }

    public void setP4name(String p4name) {
        this.p4name = p4name;
    }

    public BigDecimal getP4val() {
        return this.p4val;

    }

    public void setP4val(BigDecimal p4val) {
        this.p4val = p4val;
    }

    public String getSysw() {
        return sysw;
    }

    public void setSysw(String sysw) {
        this.sysw = sysw;
    }

    public String getSyqy() {
        return syqy;
    }

    public void setSyqy(String syqy) {
        this.syqy = syqy;
    }

    /**
     * @return ZBCODE
     */
    public String getZbcode() {
        return zbcode;
    }

    /**
     * @param zbcode
     */
    public void setZbcode(String zbcode) {
        this.zbcode = zbcode == null ? null : zbcode.trim();
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
     * @return ZBNAME
     */
    public String getZbname() {
        return zbname;
    }

    /**
     * @param zbname
     */
    public void setZbname(String zbname) {
        this.zbname = zbname == null ? null : zbname.trim();
    }

    /**
     * @return JSLX
     */
    public String getJslx() {
        return jslx;
    }

    /**
     * @param jslx
     */
    public void setJslx(String jslx) {
        this.jslx = jslx == null ? null : jslx.trim();
    }

    /**
     * @return P1NAME
     */
    public String getP1name() {
        return p1name;
    }

    /**
     * @param p1name
     */
    public void setP1name(String p1name) {
        this.p1name = p1name == null ? null : p1name.trim();
    }

    /**
     * @return P1VAL
     */
    public BigDecimal getP1val() {
        return p1val;
    }

    /**
     * @param p1val
     */
    public void setP1val(BigDecimal p1val) {
        this.p1val = p1val;
    }

    /**
     * @return P2NAME
     */
    public String getP2name() {
        return p2name;
    }

    /**
     * @param p2name
     */
    public void setP2name(String p2name) {
        this.p2name = p2name == null ? null : p2name.trim();
    }

    /**
     * @return P2VAL
     */
    public BigDecimal getP2val() {
        return p2val;
    }

    /**
     * @param p2val
     */
    public void setP2val(BigDecimal p2val) {
        this.p2val = p2val;
    }

    /**
     * @return SCORE
     */
    public Integer getScore() {
        return score;
    }

    /**
     * @param score
     */
    public void setScore(Integer score) {
        this.score = score;
    }

    /**
     * @return YJMSG
     */
    public String getYjmsg() {
        return yjmsg;
    }

    /**
     * @param yjmsg
     */
    public void setYjmsg(String yjmsg) {
        this.yjmsg = yjmsg == null ? null : yjmsg.trim();
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
     * @return WSQL
     */
    public String getWsql() {
        return wsql;
    }

    /**
     * @param wsql
     */
    public void setWsql(String wsql) {
        this.wsql = wsql == null ? null : wsql.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", zbcode=").append(zbcode);
        sb.append(", yjcode=").append(yjcode);
        sb.append(", yjname=").append(yjname);
        sb.append(", zbname=").append(zbname);
        sb.append(", jslx=").append(jslx);
        sb.append(", p1name=").append(p1name);
        sb.append(", p1val=").append(p1val);
        sb.append(", p2name=").append(p2name);
        sb.append(", p2val=").append(p2val);
        sb.append(", score=").append(score);
        sb.append(", yjmsg=").append(yjmsg);
        sb.append(", note=").append(note);
        sb.append(", wsql=").append(wsql);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}