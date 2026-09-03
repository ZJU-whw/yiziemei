package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TSSH.GC_YGZ_GJYS")
public class GcYgzGjys implements Serializable {
    @Id
    private String uuid;

    private String lcslid;

    private String cpcode;

    private String sb_ym;

    private String sb_no;

    private String ss_year;

    private Date lj_date;

    private String cmcode;

    private String cmname;

    private String cmunit;

    private Integer yscs_num;

    private Integer zycd_num;

    private Integer zytd_num;

    private BigDecimal rmb_amt;

    private BigDecimal usd_hl;

    private BigDecimal usd_amt;

    private BigDecimal zfjk_amt;

    private BigDecimal js_amt;

    private BigDecimal zssl;

    private BigDecimal tsl;

    private BigDecimal ztsce;

    private BigDecimal ts_amt;

    private String mdts_ym;

    private String jbsh_flag;

    private String zhsh_flag;

    private String op_user;

    private Date op_Date;

    private String note;

    private String rsv_str;

    private String flag;

    private String bicode;

    private BigDecimal yb_amt;

    private String ht_no;

    private String bg_user;

    private Date bg_Date;

    private String swcode;

    private String zh_flag;

    private String by_flag;

    @Column(name = "Y_UUID")
    private String y_uuid;

    private String zh_type;

    private String by_type;

    private String rgsh_flag;

    private String rgsh_pass;

    private String rgsh_user;

    private Date rgsh_date;

    private String rgsh_info;

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

    public String getSs_year() {
        return ss_year;
    }

    public void setSs_year(String ss_year) {
        this.ss_year = ss_year;
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

    public String getCmname() {
        return cmname;
    }

    public void setCmname(String cmname) {
        this.cmname = cmname;
    }

    public String getCmunit() {
        return cmunit;
    }

    public void setCmunit(String cmunit) {
        this.cmunit = cmunit;
    }

    public Integer getYscs_num() {
        return yscs_num;
    }

    public void setYscs_num(Integer yscs_num) {
        this.yscs_num = yscs_num;
    }

    public Integer getZycd_num() {
        return zycd_num;
    }

    public void setZycd_num(Integer zycd_num) {
        this.zycd_num = zycd_num;
    }

    public Integer getZytd_num() {
        return zytd_num;
    }

    public void setZytd_num(Integer zytd_num) {
        this.zytd_num = zytd_num;
    }

    public BigDecimal getRmb_amt() {
        return rmb_amt;
    }

    public void setRmb_amt(BigDecimal rmb_amt) {
        this.rmb_amt = rmb_amt;
    }

    public BigDecimal getUsd_hl() {
        return usd_hl;
    }

    public void setUsd_hl(BigDecimal usd_hl) {
        this.usd_hl = usd_hl;
    }

    public BigDecimal getUsd_amt() {
        return usd_amt;
    }

    public void setUsd_amt(BigDecimal usd_amt) {
        this.usd_amt = usd_amt;
    }

    public BigDecimal getZfjk_amt() {
        return zfjk_amt;
    }

    public void setZfjk_amt(BigDecimal zfjk_amt) {
        this.zfjk_amt = zfjk_amt;
    }

    public BigDecimal getJs_amt() {
        return js_amt;
    }

    public void setJs_amt(BigDecimal js_amt) {
        this.js_amt = js_amt;
    }

    public BigDecimal getZssl() {
        return zssl;
    }

    public void setZssl(BigDecimal zssl) {
        this.zssl = zssl;
    }

    public BigDecimal getTsl() {
        return tsl;
    }

    public void setTsl(BigDecimal tsl) {
        this.tsl = tsl;
    }

    public BigDecimal getZtsce() {
        return ztsce;
    }

    public void setZtsce(BigDecimal ztsce) {
        this.ztsce = ztsce;
    }

    public BigDecimal getTs_amt() {
        return ts_amt;
    }

    public void setTs_amt(BigDecimal ts_amt) {
        this.ts_amt = ts_amt;
    }

    public String getMdts_ym() {
        return mdts_ym;
    }

    public void setMdts_ym(String mdts_ym) {
        this.mdts_ym = mdts_ym;
    }

    public String getJbsh_flag() {
        return jbsh_flag;
    }

    public void setJbsh_flag(String jbsh_flag) {
        this.jbsh_flag = jbsh_flag;
    }

    public String getZhsh_flag() {
        return zhsh_flag;
    }

    public void setZhsh_flag(String zhsh_flag) {
        this.zhsh_flag = zhsh_flag;
    }

    public String getOp_user() {
        return op_user;
    }

    public void setOp_user(String op_user) {
        this.op_user = op_user;
    }

    public Date getOp_Date() {
        return op_Date;
    }

    public void setOp_Date(Date op_Date) {
        this.op_Date = op_Date;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getRsv_str() {
        return rsv_str;
    }

    public void setRsv_str(String rsv_str) {
        this.rsv_str = rsv_str;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public String getBicode() {
        return bicode;
    }

    public void setBicode(String bicode) {
        this.bicode = bicode;
    }

    public BigDecimal getYb_amt() {
        return yb_amt;
    }

    public void setYb_amt(BigDecimal yb_amt) {
        this.yb_amt = yb_amt;
    }

    public String getHt_no() {
        return ht_no;
    }

    public void setHt_no(String ht_no) {
        this.ht_no = ht_no;
    }

    public String getBg_user() {
        return bg_user;
    }

    public void setBg_user(String bg_user) {
        this.bg_user = bg_user;
    }

    public Date getBg_Date() {
        return bg_Date;
    }

    public void setBg_Date(Date bg_Date) {
        this.bg_Date = bg_Date;
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
}