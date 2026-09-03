package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TSSH.GC_WZF_TSSB")
public class GcWzfTssb implements Serializable {
    @Id
    private String uuid;

    private String sb_ym;

    private String sb_no;

    private String sb_pc;

    private String wt_nsrdj_no;

    private String bgd_no;

    private Date lj_date;

    private String cmcode;

    private String sb_cmcode;

    private String cmunit;

    private BigDecimal qnt;

    private BigDecimal usd_amt;

    private String zyfp_no;

    private Date kp_date;

    private BigDecimal rmb_amt;

    private BigDecimal se;

    private BigDecimal sl;

    private BigDecimal tsl;

    private BigDecimal ts_amt;

    private String ywlxcode;

    private String ywlx;

    private String note;

    private String op_user;

    private Date op_date;

    private String bg_user;

    private Date bg_date;

    private String lcslid;

    private String swcode;

    private String cpcode;

    private String zh_type;

    private String by_type;

    private String mts_flag;

    private String mts_ym;

    private String zh_flag;

    private String by_flag;

    private String cmname;

    private String sbcmname;

    private BigDecimal sb_id;

    private String hwlxcode;

    private String hwlx;

    private static final long serialVersionUID = 1L;

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getSb_ym() {
        return sb_ym;
    }

    public void setSb_ym(String sb_ym) {
        this.sb_ym = sb_ym;
    }

    public String getSb_no() {
        return sb_no;
    }

    public void setSb_no(String sb_no) {
        this.sb_no = sb_no;
    }

    public String getSb_pc() {
        return sb_pc;
    }

    public void setSb_pc(String sb_pc) {
        this.sb_pc = sb_pc;
    }

    public String getWt_nsrdj_no() {
        return wt_nsrdj_no;
    }

    public void setWt_nsrdj_no(String wt_nsrdj_no) {
        this.wt_nsrdj_no = wt_nsrdj_no;
    }

    public String getBgd_no() {
        return bgd_no;
    }

    public void setBgd_no(String bgd_no) {
        this.bgd_no = bgd_no;
    }

    public Date getLj_date() {
        return lj_date;
    }

    public void setLj_date(Date lj_date) {
        this.lj_date = lj_date;
    }

    public String getCmcode() {
        return cmcode;
    }

    public void setCmcode(String cmcode) {
        this.cmcode = cmcode;
    }

    public String getSb_cmcode() {
        return sb_cmcode;
    }

    public void setSb_cmcode(String sb_cmcode) {
        this.sb_cmcode = sb_cmcode;
    }

    public String getCmunit() {
        return cmunit;
    }

    public void setCmunit(String cmunit) {
        this.cmunit = cmunit;
    }

    public BigDecimal getQnt() {
        return qnt;
    }

    public void setQnt(BigDecimal qnt) {
        this.qnt = qnt;
    }

    public BigDecimal getUsd_amt() {
        return usd_amt;
    }

    public void setUsd_amt(BigDecimal usd_amt) {
        this.usd_amt = usd_amt;
    }

    public String getZyfp_no() {
        return zyfp_no;
    }

    public void setZyfp_no(String zyfp_no) {
        this.zyfp_no = zyfp_no;
    }

    public Date getKp_date() {
        return kp_date;
    }

    public void setKp_date(Date kp_date) {
        this.kp_date = kp_date;
    }

    public BigDecimal getRmb_amt() {
        return rmb_amt;
    }

    public void setRmb_amt(BigDecimal rmb_amt) {
        this.rmb_amt = rmb_amt;
    }

    public BigDecimal getSe() {
        return se;
    }

    public void setSe(BigDecimal se) {
        this.se = se;
    }

    public BigDecimal getSl() {
        return sl;
    }

    public void setSl(BigDecimal sl) {
        this.sl = sl;
    }

    public BigDecimal getTsl() {
        return tsl;
    }

    public void setTsl(BigDecimal tsl) {
        this.tsl = tsl;
    }

    public BigDecimal getTs_amt() {
        return ts_amt;
    }

    public void setTs_amt(BigDecimal ts_amt) {
        this.ts_amt = ts_amt;
    }

    public String getYwlxcode() {
        return ywlxcode;
    }

    public void setYwlxcode(String ywlxcode) {
        this.ywlxcode = ywlxcode;
    }

    public String getYwlx() {
        return ywlx;
    }

    public void setYwlx(String ywlx) {
        this.ywlx = ywlx;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getOp_user() {
        return op_user;
    }

    public void setOp_user(String op_user) {
        this.op_user = op_user;
    }

    public Date getOp_date() {
        return op_date;
    }

    public void setOp_date(Date op_date) {
        this.op_date = op_date;
    }

    public String getBg_user() {
        return bg_user;
    }

    public void setBg_user(String bg_user) {
        this.bg_user = bg_user;
    }

    public Date getBg_date() {
        return bg_date;
    }

    public void setBg_date(Date bg_date) {
        this.bg_date = bg_date;
    }

    public String getLcslid() {
        return lcslid;
    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public String getSwcode() {
        return swcode;
    }

    public void setSwcode(String swcode) {
        this.swcode = swcode;
    }

    public String getCpcode() {
        return cpcode;
    }

    public void setCpcode(String cpcode) {
        this.cpcode = cpcode;
    }

    public String getZh_type() {
        return zh_type;
    }

    public void setZh_type(String zh_type) {
        this.zh_type = zh_type;
    }

    public String getBy_type() {
        return by_type;
    }

    public void setBy_type(String by_type) {
        this.by_type = by_type;
    }

    public String getMts_flag() {
        return mts_flag;
    }

    public void setMts_flag(String mts_flag) {
        this.mts_flag = mts_flag;
    }

    public String getMts_ym() {
        return mts_ym;
    }

    public void setMts_ym(String mts_ym) {
        this.mts_ym = mts_ym;
    }

    public String getZh_flag() {
        return zh_flag;
    }

    public void setZh_flag(String zh_flag) {
        this.zh_flag = zh_flag;
    }

    public String getBy_flag() {
        return by_flag;
    }

    public void setBy_flag(String by_flag) {
        this.by_flag = by_flag;
    }

    public String getCmname() {
        return cmname;
    }

    public void setCmname(String cmname) {
        this.cmname = cmname;
    }

    public String getSbcmname() {
        return sbcmname;
    }

    public void setSbcmname(String sbcmname) {
        this.sbcmname = sbcmname;
    }

    public BigDecimal getSb_id() {
        return sb_id;
    }

    public void setSb_id(BigDecimal sb_id) {
        this.sb_id = sb_id;
    }

    public String getHwlxcode() {
        return hwlxcode;
    }

    public void setHwlxcode(String hwlxcode) {
        this.hwlxcode = hwlxcode;
    }

    public String getHwlx() {
        return hwlx;
    }

    public void setHwlx(String hwlx) {
        this.hwlx = hwlx;
    }
}