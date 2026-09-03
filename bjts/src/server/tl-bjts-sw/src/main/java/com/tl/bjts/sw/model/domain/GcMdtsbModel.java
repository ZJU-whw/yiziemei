package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TSSH.GC_MDTSB")
public class GcMdtsbModel implements Serializable {
    @Id
    private String uuid;

    private String lcslid;

    private String cpcode;

    private String sb_ym;

    private BigDecimal usd_amt;

    private BigDecimal rmb_amt;

    private BigDecimal rmb_ce;

    private BigDecimal dqdzbq_amt;

    private BigDecimal dqdzqq_amt;

    private BigDecimal qqdzsq_amt;

    private BigDecimal qqxxsq_amt;

    private BigDecimal qqdzqq_amt;

    private BigDecimal ms_usd_amt;

    private BigDecimal ms_rmb_amt;

    private BigDecimal dzqq_ms_amt;

    private BigDecimal dzbq_ms_amt;

    private BigDecimal qqdzqq_ms_amt;

    private BigDecimal qqxxqq_ms_amt;

    private BigDecimal bymdt_amt;

    private BigDecimal ztsce;

    private BigDecimal sqbmzdkdje;

    private BigDecimal bmzdkdje;

    private BigDecimal bmzdkse;

    private BigDecimal bmzdkse_ce;

    private BigDecimal jzbmzdkdje;

    private BigDecimal ts_amt;

    private BigDecimal sqjzmdtdje;

    private BigDecimal mdtdje;

    private BigDecimal mdtse;

    private BigDecimal jzmdtdje;

    private BigDecimal qmldse;

    private BigDecimal jsqmldse;

    private BigDecimal ytse;

    private BigDecimal mdse;

    private String note;

    private String sb_rsv;

    private String flag;

    private String jbsh_flag;

    private String zhsh_flag;

    private String sh_user;

    private Date sh_date;

    private String qp_user;

    private Date qp_date;

    private String op_user;

    private Date op_date;

    private String rsv_flag;

    private String ysjccode;

    private String lsgx;

    private String qylx;

    private String js_mode;

    private String bbtj;

    private BigDecimal usd_amt_lw;

    private BigDecimal usd_amt_hw;

    private BigDecimal rmb_amt_lw;

    private BigDecimal rmb_amt_zf;

    private BigDecimal rmb_amt_hw;

    private BigDecimal dqdzbq_lw;

    private BigDecimal dqdzqq_lw;

    private BigDecimal dzqq_amt_lw;

    private BigDecimal ztsce_lw;

    private BigDecimal ztsce_hw;

    private BigDecimal ts_amt_lw;

    private BigDecimal ts_amt_hw;

    private BigDecimal ytse_lw;

    private BigDecimal ytse_hw;

    private BigDecimal mdse_lw;

    private BigDecimal mdse_hw;

    private BigDecimal qqdzqq_lw;

    private String bg_user;

    private Date bg_date;

    private String swcode;

    private BigDecimal zh_amt;

    private BigDecimal byts_amt;

    private String is_wzh;

    private String flglcd;

    private BigDecimal usdamtlj;

    private BigDecimal usdamthwlj;

    private BigDecimal usdamtlwlj;

    private BigDecimal mdtckxselj;

    private BigDecimal rmbamtzflj;

    private BigDecimal rmbamtlj;

    private BigDecimal dqdzbqamtlj;

    private BigDecimal dqdzqqamtlj;

    private BigDecimal dqdzqqlwlj;

    private BigDecimal dqdzbqlwlj;

    private BigDecimal qqdzsq_amtlj;

    private BigDecimal qqdzqqlwlj;

    private BigDecimal dqdzqqamtqblj;

    private BigDecimal qbdzysjsamtlj;

    private BigDecimal msusdamtlj;

    private BigDecimal msrmbamtlj;

    private BigDecimal usdamtqblj;

    private BigDecimal rmbamtqblj;

    private BigDecimal bymdtamtlj;

    private BigDecimal ztscelj;

    private BigDecimal ztscehwlj;

    private BigDecimal ztscelwlj;

    private BigDecimal sqbmzdkdjelj;

    private BigDecimal bmzdkdjelj;

    private BigDecimal bmzdkselj;

    private BigDecimal jzbmzdkdjelj;

    private BigDecimal tsamtlj;

    private BigDecimal tsamthwlj;

    private BigDecimal tsamtlwlj;

    private BigDecimal sqjzmdtdjelj;

    private BigDecimal mdtdjelj;

    private BigDecimal mdtselj;

    private BigDecimal jzmdtdjelj;

    private BigDecimal qmldselj;

    private BigDecimal jsqmldselj;

    private BigDecimal ytselj;

    private BigDecimal mdselj;

    private BigDecimal tzmdtse;

    private BigDecimal tzbmzdkse;

    private BigDecimal zzsbddklj;

    private BigDecimal zzsxselj;

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

    public BigDecimal getUsd_amt() {
        return usd_amt;
    }

    public void setUsd_amt(BigDecimal usd_amt) {
        this.usd_amt = usd_amt;
    }

    public BigDecimal getRmb_amt() {
        return rmb_amt;
    }

    public void setRmb_amt(BigDecimal rmb_amt) {
        this.rmb_amt = rmb_amt;
    }

    public BigDecimal getRmb_ce() {
        return rmb_ce;
    }

    public void setRmb_ce(BigDecimal rmb_ce) {
        this.rmb_ce = rmb_ce;
    }

    public BigDecimal getDqdzbq_amt() {
        return dqdzbq_amt;
    }

    public void setDqdzbq_amt(BigDecimal dqdzbq_amt) {
        this.dqdzbq_amt = dqdzbq_amt;
    }

    public BigDecimal getDqdzqq_amt() {
        return dqdzqq_amt;
    }

    public void setDqdzqq_amt(BigDecimal dqdzqq_amt) {
        this.dqdzqq_amt = dqdzqq_amt;
    }

    public BigDecimal getQqdzsq_amt() {
        return qqdzsq_amt;
    }

    public void setQqdzsq_amt(BigDecimal qqdzsq_amt) {
        this.qqdzsq_amt = qqdzsq_amt;
    }

    public BigDecimal getQqxxsq_amt() {
        return qqxxsq_amt;
    }

    public void setQqxxsq_amt(BigDecimal qqxxsq_amt) {
        this.qqxxsq_amt = qqxxsq_amt;
    }

    public BigDecimal getQqdzqq_amt() {
        return qqdzqq_amt;
    }

    public void setQqdzqq_amt(BigDecimal qqdzqq_amt) {
        this.qqdzqq_amt = qqdzqq_amt;
    }

    public BigDecimal getMs_usd_amt() {
        return ms_usd_amt;
    }

    public void setMs_usd_amt(BigDecimal ms_usd_amt) {
        this.ms_usd_amt = ms_usd_amt;
    }

    public BigDecimal getMs_rmb_amt() {
        return ms_rmb_amt;
    }

    public void setMs_rmb_amt(BigDecimal ms_rmb_amt) {
        this.ms_rmb_amt = ms_rmb_amt;
    }

    public BigDecimal getDzqq_ms_amt() {
        return dzqq_ms_amt;
    }

    public void setDzqq_ms_amt(BigDecimal dzqq_ms_amt) {
        this.dzqq_ms_amt = dzqq_ms_amt;
    }

    public BigDecimal getDzbq_ms_amt() {
        return dzbq_ms_amt;
    }

    public void setDzbq_ms_amt(BigDecimal dzbq_ms_amt) {
        this.dzbq_ms_amt = dzbq_ms_amt;
    }

    public BigDecimal getQqdzqq_ms_amt() {
        return qqdzqq_ms_amt;
    }

    public void setQqdzqq_ms_amt(BigDecimal qqdzqq_ms_amt) {
        this.qqdzqq_ms_amt = qqdzqq_ms_amt;
    }

    public BigDecimal getQqxxqq_ms_amt() {
        return qqxxqq_ms_amt;
    }

    public void setQqxxqq_ms_amt(BigDecimal qqxxqq_ms_amt) {
        this.qqxxqq_ms_amt = qqxxqq_ms_amt;
    }

    public BigDecimal getBymdt_amt() {
        return bymdt_amt;
    }

    public void setBymdt_amt(BigDecimal bymdt_amt) {
        this.bymdt_amt = bymdt_amt;
    }

    public BigDecimal getZtsce() {
        return ztsce;
    }

    public void setZtsce(BigDecimal ztsce) {
        this.ztsce = ztsce;
    }

    public BigDecimal getSqbmzdkdje() {
        return sqbmzdkdje;
    }

    public void setSqbmzdkdje(BigDecimal sqbmzdkdje) {
        this.sqbmzdkdje = sqbmzdkdje;
    }

    public BigDecimal getBmzdkdje() {
        return bmzdkdje;
    }

    public void setBmzdkdje(BigDecimal bmzdkdje) {
        this.bmzdkdje = bmzdkdje;
    }

    public BigDecimal getBmzdkse() {
        return bmzdkse;
    }

    public void setBmzdkse(BigDecimal bmzdkse) {
        this.bmzdkse = bmzdkse;
    }

    public BigDecimal getBmzdkse_ce() {
        return bmzdkse_ce;
    }

    public void setBmzdkse_ce(BigDecimal bmzdkse_ce) {
        this.bmzdkse_ce = bmzdkse_ce;
    }

    public BigDecimal getJzbmzdkdje() {
        return jzbmzdkdje;
    }

    public void setJzbmzdkdje(BigDecimal jzbmzdkdje) {
        this.jzbmzdkdje = jzbmzdkdje;
    }

    public BigDecimal getTs_amt() {
        return ts_amt;
    }

    public void setTs_amt(BigDecimal ts_amt) {
        this.ts_amt = ts_amt;
    }

    public BigDecimal getSqjzmdtdje() {
        return sqjzmdtdje;
    }

    public void setSqjzmdtdje(BigDecimal sqjzmdtdje) {
        this.sqjzmdtdje = sqjzmdtdje;
    }

    public BigDecimal getMdtdje() {
        return mdtdje;
    }

    public void setMdtdje(BigDecimal mdtdje) {
        this.mdtdje = mdtdje;
    }

    public BigDecimal getMdtse() {
        return mdtse;
    }

    public void setMdtse(BigDecimal mdtse) {
        this.mdtse = mdtse;
    }

    public BigDecimal getJzmdtdje() {
        return jzmdtdje;
    }

    public void setJzmdtdje(BigDecimal jzmdtdje) {
        this.jzmdtdje = jzmdtdje;
    }

    public BigDecimal getQmldse() {
        return qmldse;
    }

    public void setQmldse(BigDecimal qmldse) {
        this.qmldse = qmldse;
    }

    public BigDecimal getJsqmldse() {
        return jsqmldse;
    }

    public void setJsqmldse(BigDecimal jsqmldse) {
        this.jsqmldse = jsqmldse;
    }

    public BigDecimal getYtse() {
        return ytse;
    }

    public void setYtse(BigDecimal ytse) {
        this.ytse = ytse;
    }

    public BigDecimal getMdse() {
        return mdse;
    }

    public void setMdse(BigDecimal mdse) {
        this.mdse = mdse;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getSb_rsv() {
        return sb_rsv;
    }

    public void setSb_rsv(String sb_rsv) {
        this.sb_rsv = sb_rsv;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
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

    public String getSh_user() {
        return sh_user;
    }

    public void setSh_user(String sh_user) {
        this.sh_user = sh_user;
    }

    public Date getSh_date() {
        return sh_date;
    }

    public void setSh_date(Date sh_date) {
        this.sh_date = sh_date;
    }

    public String getQp_user() {
        return qp_user;
    }

    public void setQp_user(String qp_user) {
        this.qp_user = qp_user;
    }

    public Date getQp_date() {
        return qp_date;
    }

    public void setQp_date(Date qp_date) {
        this.qp_date = qp_date;
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

    public String getRsv_flag() {
        return rsv_flag;
    }

    public void setRsv_flag(String rsv_flag) {
        this.rsv_flag = rsv_flag;
    }

    public String getYsjccode() {
        return ysjccode;
    }

    public void setYsjccode(String ysjccode) {
        this.ysjccode = ysjccode;
    }

    public String getLsgx() {
        return lsgx;
    }

    public void setLsgx(String lsgx) {
        this.lsgx = lsgx;
    }

    public String getQylx() {
        return qylx;
    }

    public void setQylx(String qylx) {
        this.qylx = qylx;
    }

    public String getJs_mode() {
        return js_mode;
    }

    public void setJs_mode(String js_mode) {
        this.js_mode = js_mode;
    }

    public String getBbtj() {
        return bbtj;
    }

    public void setBbtj(String bbtj) {
        this.bbtj = bbtj;
    }

    public BigDecimal getUsd_amt_lw() {
        return usd_amt_lw;
    }

    public void setUsd_amt_lw(BigDecimal usd_amt_lw) {
        this.usd_amt_lw = usd_amt_lw;
    }

    public BigDecimal getUsd_amt_hw() {
        return usd_amt_hw;
    }

    public void setUsd_amt_hw(BigDecimal usd_amt_hw) {
        this.usd_amt_hw = usd_amt_hw;
    }

    public BigDecimal getRmb_amt_lw() {
        return rmb_amt_lw;
    }

    public void setRmb_amt_lw(BigDecimal rmb_amt_lw) {
        this.rmb_amt_lw = rmb_amt_lw;
    }

    public BigDecimal getRmb_amt_zf() {
        return rmb_amt_zf;
    }

    public void setRmb_amt_zf(BigDecimal rmb_amt_zf) {
        this.rmb_amt_zf = rmb_amt_zf;
    }

    public BigDecimal getRmb_amt_hw() {
        return rmb_amt_hw;
    }

    public void setRmb_amt_hw(BigDecimal rmb_amt_hw) {
        this.rmb_amt_hw = rmb_amt_hw;
    }

    public BigDecimal getDqdzbq_lw() {
        return dqdzbq_lw;
    }

    public void setDqdzbq_lw(BigDecimal dqdzbq_lw) {
        this.dqdzbq_lw = dqdzbq_lw;
    }

    public BigDecimal getDqdzqq_lw() {
        return dqdzqq_lw;
    }

    public void setDqdzqq_lw(BigDecimal dqdzqq_lw) {
        this.dqdzqq_lw = dqdzqq_lw;
    }

    public BigDecimal getDzqq_amt_lw() {
        return dzqq_amt_lw;
    }

    public void setDzqq_amt_lw(BigDecimal dzqq_amt_lw) {
        this.dzqq_amt_lw = dzqq_amt_lw;
    }

    public BigDecimal getZtsce_lw() {
        return ztsce_lw;
    }

    public void setZtsce_lw(BigDecimal ztsce_lw) {
        this.ztsce_lw = ztsce_lw;
    }

    public BigDecimal getZtsce_hw() {
        return ztsce_hw;
    }

    public void setZtsce_hw(BigDecimal ztsce_hw) {
        this.ztsce_hw = ztsce_hw;
    }

    public BigDecimal getTs_amt_lw() {
        return ts_amt_lw;
    }

    public void setTs_amt_lw(BigDecimal ts_amt_lw) {
        this.ts_amt_lw = ts_amt_lw;
    }

    public BigDecimal getTs_amt_hw() {
        return ts_amt_hw;
    }

    public void setTs_amt_hw(BigDecimal ts_amt_hw) {
        this.ts_amt_hw = ts_amt_hw;
    }

    public BigDecimal getYtse_lw() {
        return ytse_lw;
    }

    public void setYtse_lw(BigDecimal ytse_lw) {
        this.ytse_lw = ytse_lw;
    }

    public BigDecimal getYtse_hw() {
        return ytse_hw;
    }

    public void setYtse_hw(BigDecimal ytse_hw) {
        this.ytse_hw = ytse_hw;
    }

    public BigDecimal getMdse_lw() {
        return mdse_lw;
    }

    public void setMdse_lw(BigDecimal mdse_lw) {
        this.mdse_lw = mdse_lw;
    }

    public BigDecimal getMdse_hw() {
        return mdse_hw;
    }

    public void setMdse_hw(BigDecimal mdse_hw) {
        this.mdse_hw = mdse_hw;
    }

    public BigDecimal getQqdzqq_lw() {
        return qqdzqq_lw;
    }

    public void setQqdzqq_lw(BigDecimal qqdzqq_lw) {
        this.qqdzqq_lw = qqdzqq_lw;
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

    public BigDecimal getZh_amt() {
        return zh_amt;
    }

    public void setZh_amt(BigDecimal zh_amt) {
        this.zh_amt = zh_amt;
    }

    public BigDecimal getByts_amt() {
        return byts_amt;
    }

    public void setByts_amt(BigDecimal byts_amt) {
        this.byts_amt = byts_amt;
    }

    public String getIs_wzh() {
        return is_wzh;
    }

    public void setIs_wzh(String is_wzh) {
        this.is_wzh = is_wzh;
    }

    public String getFlglcd() {
        return flglcd;
    }

    public void setFlglcd(String flglcd) {
        this.flglcd = flglcd;
    }

    public BigDecimal getUsdamtlj() {
        return usdamtlj;
    }

    public void setUsdamtlj(BigDecimal usdamtlj) {
        this.usdamtlj = usdamtlj;
    }

    public BigDecimal getUsdamthwlj() {
        return usdamthwlj;
    }

    public void setUsdamthwlj(BigDecimal usdamthwlj) {
        this.usdamthwlj = usdamthwlj;
    }

    public BigDecimal getUsdamtlwlj() {
        return usdamtlwlj;
    }

    public void setUsdamtlwlj(BigDecimal usdamtlwlj) {
        this.usdamtlwlj = usdamtlwlj;
    }

    public BigDecimal getMdtckxselj() {
        return mdtckxselj;
    }

    public void setMdtckxselj(BigDecimal mdtckxselj) {
        this.mdtckxselj = mdtckxselj;
    }

    public BigDecimal getRmbamtzflj() {
        return rmbamtzflj;
    }

    public void setRmbamtzflj(BigDecimal rmbamtzflj) {
        this.rmbamtzflj = rmbamtzflj;
    }

    public BigDecimal getRmbamtlj() {
        return rmbamtlj;
    }

    public void setRmbamtlj(BigDecimal rmbamtlj) {
        this.rmbamtlj = rmbamtlj;
    }

    public BigDecimal getDqdzbqamtlj() {
        return dqdzbqamtlj;
    }

    public void setDqdzbqamtlj(BigDecimal dqdzbqamtlj) {
        this.dqdzbqamtlj = dqdzbqamtlj;
    }

    public BigDecimal getDqdzqqamtlj() {
        return dqdzqqamtlj;
    }

    public void setDqdzqqamtlj(BigDecimal dqdzqqamtlj) {
        this.dqdzqqamtlj = dqdzqqamtlj;
    }

    public BigDecimal getDqdzqqlwlj() {
        return dqdzqqlwlj;
    }

    public void setDqdzqqlwlj(BigDecimal dqdzqqlwlj) {
        this.dqdzqqlwlj = dqdzqqlwlj;
    }

    public BigDecimal getDqdzbqlwlj() {
        return dqdzbqlwlj;
    }

    public void setDqdzbqlwlj(BigDecimal dqdzbqlwlj) {
        this.dqdzbqlwlj = dqdzbqlwlj;
    }

    public BigDecimal getQqdzsq_amtlj() {
        return qqdzsq_amtlj;
    }

    public void setQqdzsq_amtlj(BigDecimal qqdzsq_amtlj) {
        this.qqdzsq_amtlj = qqdzsq_amtlj;
    }

    public BigDecimal getQqdzqqlwlj() {
        return qqdzqqlwlj;
    }

    public void setQqdzqqlwlj(BigDecimal qqdzqqlwlj) {
        this.qqdzqqlwlj = qqdzqqlwlj;
    }

    public BigDecimal getDqdzqqamtqblj() {
        return dqdzqqamtqblj;
    }

    public void setDqdzqqamtqblj(BigDecimal dqdzqqamtqblj) {
        this.dqdzqqamtqblj = dqdzqqamtqblj;
    }

    public BigDecimal getQbdzysjsamtlj() {
        return qbdzysjsamtlj;
    }

    public void setQbdzysjsamtlj(BigDecimal qbdzysjsamtlj) {
        this.qbdzysjsamtlj = qbdzysjsamtlj;
    }

    public BigDecimal getMsusdamtlj() {
        return msusdamtlj;
    }

    public void setMsusdamtlj(BigDecimal msusdamtlj) {
        this.msusdamtlj = msusdamtlj;
    }

    public BigDecimal getMsrmbamtlj() {
        return msrmbamtlj;
    }

    public void setMsrmbamtlj(BigDecimal msrmbamtlj) {
        this.msrmbamtlj = msrmbamtlj;
    }

    public BigDecimal getUsdamtqblj() {
        return usdamtqblj;
    }

    public void setUsdamtqblj(BigDecimal usdamtqblj) {
        this.usdamtqblj = usdamtqblj;
    }

    public BigDecimal getRmbamtqblj() {
        return rmbamtqblj;
    }

    public void setRmbamtqblj(BigDecimal rmbamtqblj) {
        this.rmbamtqblj = rmbamtqblj;
    }

    public BigDecimal getBymdtamtlj() {
        return bymdtamtlj;
    }

    public void setBymdtamtlj(BigDecimal bymdtamtlj) {
        this.bymdtamtlj = bymdtamtlj;
    }

    public BigDecimal getZtscelj() {
        return ztscelj;
    }

    public void setZtscelj(BigDecimal ztscelj) {
        this.ztscelj = ztscelj;
    }

    public BigDecimal getZtscehwlj() {
        return ztscehwlj;
    }

    public void setZtscehwlj(BigDecimal ztscehwlj) {
        this.ztscehwlj = ztscehwlj;
    }

    public BigDecimal getZtscelwlj() {
        return ztscelwlj;
    }

    public void setZtscelwlj(BigDecimal ztscelwlj) {
        this.ztscelwlj = ztscelwlj;
    }

    public BigDecimal getSqbmzdkdjelj() {
        return sqbmzdkdjelj;
    }

    public void setSqbmzdkdjelj(BigDecimal sqbmzdkdjelj) {
        this.sqbmzdkdjelj = sqbmzdkdjelj;
    }

    public BigDecimal getBmzdkdjelj() {
        return bmzdkdjelj;
    }

    public void setBmzdkdjelj(BigDecimal bmzdkdjelj) {
        this.bmzdkdjelj = bmzdkdjelj;
    }

    public BigDecimal getBmzdkselj() {
        return bmzdkselj;
    }

    public void setBmzdkselj(BigDecimal bmzdkselj) {
        this.bmzdkselj = bmzdkselj;
    }

    public BigDecimal getJzbmzdkdjelj() {
        return jzbmzdkdjelj;
    }

    public void setJzbmzdkdjelj(BigDecimal jzbmzdkdjelj) {
        this.jzbmzdkdjelj = jzbmzdkdjelj;
    }

    public BigDecimal getTsamtlj() {
        return tsamtlj;
    }

    public void setTsamtlj(BigDecimal tsamtlj) {
        this.tsamtlj = tsamtlj;
    }

    public BigDecimal getTsamthwlj() {
        return tsamthwlj;
    }

    public void setTsamthwlj(BigDecimal tsamthwlj) {
        this.tsamthwlj = tsamthwlj;
    }

    public BigDecimal getTsamtlwlj() {
        return tsamtlwlj;
    }

    public void setTsamtlwlj(BigDecimal tsamtlwlj) {
        this.tsamtlwlj = tsamtlwlj;
    }

    public BigDecimal getSqjzmdtdjelj() {
        return sqjzmdtdjelj;
    }

    public void setSqjzmdtdjelj(BigDecimal sqjzmdtdjelj) {
        this.sqjzmdtdjelj = sqjzmdtdjelj;
    }

    public BigDecimal getMdtdjelj() {
        return mdtdjelj;
    }

    public void setMdtdjelj(BigDecimal mdtdjelj) {
        this.mdtdjelj = mdtdjelj;
    }

    public BigDecimal getMdtselj() {
        return mdtselj;
    }

    public void setMdtselj(BigDecimal mdtselj) {
        this.mdtselj = mdtselj;
    }

    public BigDecimal getJzmdtdjelj() {
        return jzmdtdjelj;
    }

    public void setJzmdtdjelj(BigDecimal jzmdtdjelj) {
        this.jzmdtdjelj = jzmdtdjelj;
    }

    public BigDecimal getQmldselj() {
        return qmldselj;
    }

    public void setQmldselj(BigDecimal qmldselj) {
        this.qmldselj = qmldselj;
    }

    public BigDecimal getJsqmldselj() {
        return jsqmldselj;
    }

    public void setJsqmldselj(BigDecimal jsqmldselj) {
        this.jsqmldselj = jsqmldselj;
    }

    public BigDecimal getYtselj() {
        return ytselj;
    }

    public void setYtselj(BigDecimal ytselj) {
        this.ytselj = ytselj;
    }

    public BigDecimal getMdselj() {
        return mdselj;
    }

    public void setMdselj(BigDecimal mdselj) {
        this.mdselj = mdselj;
    }

    public BigDecimal getTzmdtse() {
        return tzmdtse;
    }

    public void setTzmdtse(BigDecimal tzmdtse) {
        this.tzmdtse = tzmdtse;
    }

    public BigDecimal getTzbmzdkse() {
        return tzbmzdkse;
    }

    public void setTzbmzdkse(BigDecimal tzbmzdkse) {
        this.tzbmzdkse = tzbmzdkse;
    }

    public BigDecimal getZzsbddklj() {
        return zzsbddklj;
    }

    public void setZzsbddklj(BigDecimal zzsbddklj) {
        this.zzsbddklj = zzsbddklj;
    }

    public BigDecimal getZzsxselj() {
        return zzsxselj;
    }

    public void setZzsxselj(BigDecimal zzsxselj) {
        this.zzsxselj = zzsxselj;
    }
}