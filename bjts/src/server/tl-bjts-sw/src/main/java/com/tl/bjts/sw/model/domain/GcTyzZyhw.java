package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TSSH.GC_TYZ_ZYHW")
public class GcTyzZyhw implements Serializable {
    @Id
    private String uuid;

    private String lcslid;

    private String cpcode;

    private String sb_ym;

    private String sb_no;

    private String zy_cmname;

    private String zyfp_no;

    private String unit;

    private BigDecimal qnt;

    private BigDecimal pri;

    private BigDecimal amt;

    private BigDecimal zssl;

    private BigDecimal se;

    private BigDecimal ts_amt;

    private String fkpz_no;

    private String ywlxcode;

    private String ywlx;

    private String note;

    private String op_user;

    private Date op_date;

    private String xxbq_flag;

    private String mdts_ym;

    private String bg_user;

    private Date bg_date;

    private String swcode;

    private String zh_flag;

    private String by_flag;

    @Column(name = "Y_UUID")
    private String y_uuid;

    private String zh_type;

    private String by_type;

    private String ts_flag;

    private String rgsh_flag;

    private String rgsh_pass;

    private String rgsh_user;

    private Date rgsh_date;

    private String rgsh_info;

    private Date kp_date;

    private String ghfns_no;

    private String fp_flag;

    private static final long serialVersionUID = 1L;

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getLcslid() {
        return lcslid;
    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public String getCpcode() {
        return cpcode;
    }

    public void setCpcode(String cpcode) {
        this.cpcode = cpcode;
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

    public String getZy_cmname() {
        return zy_cmname;
    }

    public void setZy_cmname(String zy_cmname) {
        this.zy_cmname = zy_cmname;
    }

    public String getZyfp_no() {
        return zyfp_no;
    }

    public void setZyfp_no(String zyfp_no) {
        this.zyfp_no = zyfp_no;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getQnt() {
        return qnt;
    }

    public void setQnt(BigDecimal qnt) {
        this.qnt = qnt;
    }

    public BigDecimal getPri() {
        return pri;
    }

    public void setPri(BigDecimal pri) {
        this.pri = pri;
    }

    public BigDecimal getAmt() {
        return amt;
    }

    public void setAmt(BigDecimal amt) {
        this.amt = amt;
    }

    public BigDecimal getZssl() {
        return zssl;
    }

    public void setZssl(BigDecimal zssl) {
        this.zssl = zssl;
    }

    public BigDecimal getSe() {
        return se;
    }

    public void setSe(BigDecimal se) {
        this.se = se;
    }

    public BigDecimal getTs_amt() {
        return ts_amt;
    }

    public void setTs_amt(BigDecimal ts_amt) {
        this.ts_amt = ts_amt;
    }

    public String getFkpz_no() {
        return fkpz_no;
    }

    public void setFkpz_no(String fkpz_no) {
        this.fkpz_no = fkpz_no;
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

    public String getXxbq_flag() {
        return xxbq_flag;
    }

    public void setXxbq_flag(String xxbq_flag) {
        this.xxbq_flag = xxbq_flag;
    }

    public String getMdts_ym() {
        return mdts_ym;
    }

    public void setMdts_ym(String mdts_ym) {
        this.mdts_ym = mdts_ym;
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

    public String getSwcode() {
        return swcode;
    }

    public void setSwcode(String swcode) {
        this.swcode = swcode;
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

    public String getY_uuid() {
        return y_uuid;
    }

    public void setY_uuid(String y_uuid) {
        this.y_uuid = y_uuid;
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

    public String getTs_flag() {
        return ts_flag;
    }

    public void setTs_flag(String ts_flag) {
        this.ts_flag = ts_flag;
    }

    public String getRgsh_flag() {
        return rgsh_flag;
    }

    public void setRgsh_flag(String rgsh_flag) {
        this.rgsh_flag = rgsh_flag;
    }

    public String getRgsh_pass() {
        return rgsh_pass;
    }

    public void setRgsh_pass(String rgsh_pass) {
        this.rgsh_pass = rgsh_pass;
    }

    public String getRgsh_user() {
        return rgsh_user;
    }

    public void setRgsh_user(String rgsh_user) {
        this.rgsh_user = rgsh_user;
    }

    public Date getRgsh_date() {
        return rgsh_date;
    }

    public void setRgsh_date(Date rgsh_date) {
        this.rgsh_date = rgsh_date;
    }

    public String getRgsh_info() {
        return rgsh_info;
    }

    public void setRgsh_info(String rgsh_info) {
        this.rgsh_info = rgsh_info;
    }

    public Date getKp_date() {
        return kp_date;
    }

    public void setKp_date(Date kp_date) {
        this.kp_date = kp_date;
    }

    public String getGhfns_no() {
        return ghfns_no;
    }

    public void setGhfns_no(String ghfns_no) {
        this.ghfns_no = ghfns_no;
    }

    public String getFp_flag() {
        return fp_flag;
    }

    public void setFp_flag(String fp_flag) {
        this.fp_flag = fp_flag;
    }
}