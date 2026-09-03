package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TSSH.GC_MTS_TSHZB")
public class GcMtsTshzbModel implements Serializable {
    @Id
    private String uuid;

    private String lcslid;

    private BigDecimal no_1;

    private Date rq;

    private String cpcode;

    private String sb_ym;

    private String sb_pc;

    private Long cksqb_num;

    private Long ckjl_num;

    private Long inv_num;

    private BigDecimal ck_amt;

    private Long bgd_num;

    private Long dlzm_num;

    private Long hxd_num;

    private BigDecimal sh_amt;

    private Long yq_num;

    private Long qtck_num;

    private Long jhsqb_num;

    private Long jhjl_num;

    private Long zysp_num;

    private Long zyfp_num;

    private Short fskfp_num;

    private Short nxdkfp_num;

    private Short btsfp_num;

    private Short ptfp_num;

    private Short qtjh_num;

    private BigDecimal amt;

    private BigDecimal se;

    private BigDecimal zzs_se;

    private BigDecimal xfs_se;

    private BigDecimal ts_amt;

    private BigDecimal zzs_ts_amt;

    private BigDecimal xfs_ts_amt;

    private Long dlck_num;

    private Long dlck_rec;

    private Long dljk_num;

    private Long dljk_rec;

    private Long jljg_num;

    private Long jljg_rec;

    private BigDecimal ydk_amt;

    private Long znx_num;

    private Long znx_rec;

    private Long lljg_num;

    private Long lljg_rec;

    private Long bbgd_num;

    private Long bbgd_rec;

    private Long bhxd_num;

    private Long bhxd_rec;

    private Long bdlzm_num;

    private Long bdlzm_rec;

    private Long dz1_num;

    private Long dz1_rec;

    private Long dz2_num;

    private Long dz2_rec;

    private String note;

    private String flag;

    private String op_user;

    private Date op_date;

    private String qr_user;

    private Date qr_date;

    private Long zzjk_num;

    private Long xfjk_num;

    private Long fpd_num;

    private BigDecimal byss_amt;

    private BigDecimal bnss_amt;

    private BigDecimal byzz_amt;

    private BigDecimal bnzz_amt;

    private BigDecimal byxf_amt;

    private BigDecimal bnxf_amt;

    private Long lljghx_num;

    private Long lljghx_rec;

    private Long tgbs_num;

    private Long tgbs_rec;

    private Long hjcp_num;

    private Long hjcp_rec;

    private BigDecimal amt_hw;

    private BigDecimal amt_fw;

    private BigDecimal zzs_se_hw;

    private BigDecimal zzs_se_fw;

    private BigDecimal zzs_ts_hw;

    private BigDecimal zzs_ts_fw;

    private BigDecimal byzz_hw;

    private BigDecimal byzz_fw;

    private BigDecimal bnzz_hw;

    private BigDecimal bnzz_fw;

    private String swcode;

    private String bg_user;

    private Date bg_date;

    private String is_wzh;

    private String flglcd;

    private static final Long serialVersionUID = 1L;

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

    public BigDecimal getNo_1() {
        return no_1;
    }

    public void setNo_1(BigDecimal no_1) {
        this.no_1 = no_1;
    }

    public Date getRq() {
        return rq;
    }

    public void setRq(Date rq) {
        this.rq = rq;
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

    public String getSb_pc() {
        return sb_pc;
    }

    public void setSb_pc(String sb_pc) {
        this.sb_pc = sb_pc;
    }

    public Long getCksqb_num() {
        return cksqb_num;
    }

    public void setCksqb_num(Long cksqb_num) {
        this.cksqb_num = cksqb_num;
    }

    public Long getCkjl_num() {
        return ckjl_num;
    }

    public void setCkjl_num(Long ckjl_num) {
        this.ckjl_num = ckjl_num;
    }

    public Long getInv_num() {
        return inv_num;
    }

    public void setInv_num(Long inv_num) {
        this.inv_num = inv_num;
    }

    public BigDecimal getCk_amt() {
        return ck_amt;
    }

    public void setCk_amt(BigDecimal ck_amt) {
        this.ck_amt = ck_amt;
    }

    public Long getBgd_num() {
        return bgd_num;
    }

    public void setBgd_num(Long bgd_num) {
        this.bgd_num = bgd_num;
    }

    public Long getDlzm_num() {
        return dlzm_num;
    }

    public void setDlzm_num(Long dlzm_num) {
        this.dlzm_num = dlzm_num;
    }

    public Long getHxd_num() {
        return hxd_num;
    }

    public void setHxd_num(Long hxd_num) {
        this.hxd_num = hxd_num;
    }

    public BigDecimal getSh_amt() {
        return sh_amt;
    }

    public void setSh_amt(BigDecimal sh_amt) {
        this.sh_amt = sh_amt;
    }

    public Long getYq_num() {
        return yq_num;
    }

    public void setYq_num(Long yq_num) {
        this.yq_num = yq_num;
    }

    public Long getQtck_num() {
        return qtck_num;
    }

    public void setQtck_num(Long qtck_num) {
        this.qtck_num = qtck_num;
    }

    public Long getJhsqb_num() {
        return jhsqb_num;
    }

    public void setJhsqb_num(Long jhsqb_num) {
        this.jhsqb_num = jhsqb_num;
    }

    public Long getJhjl_num() {
        return jhjl_num;
    }

    public void setJhjl_num(Long jhjl_num) {
        this.jhjl_num = jhjl_num;
    }

    public Long getZysp_num() {
        return zysp_num;
    }

    public void setZysp_num(Long zysp_num) {
        this.zysp_num = zysp_num;
    }

    public Long getZyfp_num() {
        return zyfp_num;
    }

    public void setZyfp_num(Long zyfp_num) {
        this.zyfp_num = zyfp_num;
    }

    public Short getFskfp_num() {
        return fskfp_num;
    }

    public void setFskfp_num(Short fskfp_num) {
        this.fskfp_num = fskfp_num;
    }

    public Short getNxdkfp_num() {
        return nxdkfp_num;
    }

    public void setNxdkfp_num(Short nxdkfp_num) {
        this.nxdkfp_num = nxdkfp_num;
    }

    public Short getBtsfp_num() {
        return btsfp_num;
    }

    public void setBtsfp_num(Short btsfp_num) {
        this.btsfp_num = btsfp_num;
    }

    public Short getPtfp_num() {
        return ptfp_num;
    }

    public void setPtfp_num(Short ptfp_num) {
        this.ptfp_num = ptfp_num;
    }

    public Short getQtjh_num() {
        return qtjh_num;
    }

    public void setQtjh_num(Short qtjh_num) {
        this.qtjh_num = qtjh_num;
    }

    public BigDecimal getAmt() {
        return amt;
    }

    public void setAmt(BigDecimal amt) {
        this.amt = amt;
    }

    public BigDecimal getSe() {
        return se;
    }

    public void setSe(BigDecimal se) {
        this.se = se;
    }

    public BigDecimal getZzs_se() {
        return zzs_se;
    }

    public void setZzs_se(BigDecimal zzs_se) {
        this.zzs_se = zzs_se;
    }

    public BigDecimal getXfs_se() {
        return xfs_se;
    }

    public void setXfs_se(BigDecimal xfs_se) {
        this.xfs_se = xfs_se;
    }

    public BigDecimal getTs_amt() {
        return ts_amt;
    }

    public void setTs_amt(BigDecimal ts_amt) {
        this.ts_amt = ts_amt;
    }

    public BigDecimal getZzs_ts_amt() {
        return zzs_ts_amt;
    }

    public void setZzs_ts_amt(BigDecimal zzs_ts_amt) {
        this.zzs_ts_amt = zzs_ts_amt;
    }

    public BigDecimal getXfs_ts_amt() {
        return xfs_ts_amt;
    }

    public void setXfs_ts_amt(BigDecimal xfs_ts_amt) {
        this.xfs_ts_amt = xfs_ts_amt;
    }

    public Long getDlck_num() {
        return dlck_num;
    }

    public void setDlck_num(Long dlck_num) {
        this.dlck_num = dlck_num;
    }

    public Long getDlck_rec() {
        return dlck_rec;
    }

    public void setDlck_rec(Long dlck_rec) {
        this.dlck_rec = dlck_rec;
    }

    public Long getDljk_num() {
        return dljk_num;
    }

    public void setDljk_num(Long dljk_num) {
        this.dljk_num = dljk_num;
    }

    public Long getDljk_rec() {
        return dljk_rec;
    }

    public void setDljk_rec(Long dljk_rec) {
        this.dljk_rec = dljk_rec;
    }

    public Long getJljg_num() {
        return jljg_num;
    }

    public void setJljg_num(Long jljg_num) {
        this.jljg_num = jljg_num;
    }

    public Long getJljg_rec() {
        return jljg_rec;
    }

    public void setJljg_rec(Long jljg_rec) {
        this.jljg_rec = jljg_rec;
    }

    public BigDecimal getYdk_amt() {
        return ydk_amt;
    }

    public void setYdk_amt(BigDecimal ydk_amt) {
        this.ydk_amt = ydk_amt;
    }

    public Long getZnx_num() {
        return znx_num;
    }

    public void setZnx_num(Long znx_num) {
        this.znx_num = znx_num;
    }

    public Long getZnx_rec() {
        return znx_rec;
    }

    public void setZnx_rec(Long znx_rec) {
        this.znx_rec = znx_rec;
    }

    public Long getLljg_num() {
        return lljg_num;
    }

    public void setLljg_num(Long lljg_num) {
        this.lljg_num = lljg_num;
    }

    public Long getLljg_rec() {
        return lljg_rec;
    }

    public void setLljg_rec(Long lljg_rec) {
        this.lljg_rec = lljg_rec;
    }

    public Long getBbgd_num() {
        return bbgd_num;
    }

    public void setBbgd_num(Long bbgd_num) {
        this.bbgd_num = bbgd_num;
    }

    public Long getBbgd_rec() {
        return bbgd_rec;
    }

    public void setBbgd_rec(Long bbgd_rec) {
        this.bbgd_rec = bbgd_rec;
    }

    public Long getBhxd_num() {
        return bhxd_num;
    }

    public void setBhxd_num(Long bhxd_num) {
        this.bhxd_num = bhxd_num;
    }

    public Long getBhxd_rec() {
        return bhxd_rec;
    }

    public void setBhxd_rec(Long bhxd_rec) {
        this.bhxd_rec = bhxd_rec;
    }

    public Long getBdlzm_num() {
        return bdlzm_num;
    }

    public void setBdlzm_num(Long bdlzm_num) {
        this.bdlzm_num = bdlzm_num;
    }

    public Long getBdlzm_rec() {
        return bdlzm_rec;
    }

    public void setBdlzm_rec(Long bdlzm_rec) {
        this.bdlzm_rec = bdlzm_rec;
    }

    public Long getDz1_num() {
        return dz1_num;
    }

    public void setDz1_num(Long dz1_num) {
        this.dz1_num = dz1_num;
    }

    public Long getDz1_rec() {
        return dz1_rec;
    }

    public void setDz1_rec(Long dz1_rec) {
        this.dz1_rec = dz1_rec;
    }

    public Long getDz2_num() {
        return dz2_num;
    }

    public void setDz2_num(Long dz2_num) {
        this.dz2_num = dz2_num;
    }

    public Long getDz2_rec() {
        return dz2_rec;
    }

    public void setDz2_rec(Long dz2_rec) {
        this.dz2_rec = dz2_rec;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public String getOp_user() {
        return op_user;
    }

    public void setOp_user(String op_user) {
        this.op_user = op_user;
    }

    public String getQr_user() {
        return qr_user;
    }

    public void setQr_user(String qr_user) {
        this.qr_user = qr_user;
    }


    public Long getZzjk_num() {
        return zzjk_num;
    }

    public void setZzjk_num(Long zzjk_num) {
        this.zzjk_num = zzjk_num;
    }

    public Long getXfjk_num() {
        return xfjk_num;
    }

    public void setXfjk_num(Long xfjk_num) {
        this.xfjk_num = xfjk_num;
    }

    public Long getFpd_num() {
        return fpd_num;
    }

    public void setFpd_num(Long fpd_num) {
        this.fpd_num = fpd_num;
    }

    public BigDecimal getByss_amt() {
        return byss_amt;
    }

    public void setByss_amt(BigDecimal byss_amt) {
        this.byss_amt = byss_amt;
    }

    public BigDecimal getBnss_amt() {
        return bnss_amt;
    }

    public void setBnss_amt(BigDecimal bnss_amt) {
        this.bnss_amt = bnss_amt;
    }

    public BigDecimal getByzz_amt() {
        return byzz_amt;
    }

    public void setByzz_amt(BigDecimal byzz_amt) {
        this.byzz_amt = byzz_amt;
    }

    public BigDecimal getBnzz_amt() {
        return bnzz_amt;
    }

    public void setBnzz_amt(BigDecimal bnzz_amt) {
        this.bnzz_amt = bnzz_amt;
    }

    public BigDecimal getByxf_amt() {
        return byxf_amt;
    }

    public void setByxf_amt(BigDecimal byxf_amt) {
        this.byxf_amt = byxf_amt;
    }

    public BigDecimal getBnxf_amt() {
        return bnxf_amt;
    }

    public void setBnxf_amt(BigDecimal bnxf_amt) {
        this.bnxf_amt = bnxf_amt;
    }

    public Long getLljghx_num() {
        return lljghx_num;
    }

    public void setLljghx_num(Long lljghx_num) {
        this.lljghx_num = lljghx_num;
    }

    public Long getLljghx_rec() {
        return lljghx_rec;
    }

    public void setLljghx_rec(Long lljghx_rec) {
        this.lljghx_rec = lljghx_rec;
    }

    public Long getTgbs_num() {
        return tgbs_num;
    }

    public void setTgbs_num(Long tgbs_num) {
        this.tgbs_num = tgbs_num;
    }

    public Long getTgbs_rec() {
        return tgbs_rec;
    }

    public void setTgbs_rec(Long tgbs_rec) {
        this.tgbs_rec = tgbs_rec;
    }

    public Long getHjcp_num() {
        return hjcp_num;
    }

    public void setHjcp_num(Long hjcp_num) {
        this.hjcp_num = hjcp_num;
    }

    public Long getHjcp_rec() {
        return hjcp_rec;
    }

    public void setHjcp_rec(Long hjcp_rec) {
        this.hjcp_rec = hjcp_rec;
    }

    public BigDecimal getAmt_hw() {
        return amt_hw;
    }

    public void setAmt_hw(BigDecimal amt_hw) {
        this.amt_hw = amt_hw;
    }

    public BigDecimal getAmt_fw() {
        return amt_fw;
    }

    public void setAmt_fw(BigDecimal amt_fw) {
        this.amt_fw = amt_fw;
    }

    public BigDecimal getZzs_se_hw() {
        return zzs_se_hw;
    }

    public void setZzs_se_hw(BigDecimal zzs_se_hw) {
        this.zzs_se_hw = zzs_se_hw;
    }

    public BigDecimal getZzs_se_fw() {
        return zzs_se_fw;
    }

    public void setZzs_se_fw(BigDecimal zzs_se_fw) {
        this.zzs_se_fw = zzs_se_fw;
    }

    public BigDecimal getZzs_ts_hw() {
        return zzs_ts_hw;
    }

    public void setZzs_ts_hw(BigDecimal zzs_ts_hw) {
        this.zzs_ts_hw = zzs_ts_hw;
    }

    public BigDecimal getZzs_ts_fw() {
        return zzs_ts_fw;
    }

    public void setZzs_ts_fw(BigDecimal zzs_ts_fw) {
        this.zzs_ts_fw = zzs_ts_fw;
    }

    public BigDecimal getByzz_hw() {
        return byzz_hw;
    }

    public void setByzz_hw(BigDecimal byzz_hw) {
        this.byzz_hw = byzz_hw;
    }

    public BigDecimal getByzz_fw() {
        return byzz_fw;
    }

    public void setByzz_fw(BigDecimal byzz_fw) {
        this.byzz_fw = byzz_fw;
    }

    public BigDecimal getBnzz_hw() {
        return bnzz_hw;
    }

    public void setBnzz_hw(BigDecimal bnzz_hw) {
        this.bnzz_hw = bnzz_hw;
    }

    public BigDecimal getBnzz_fw() {
        return bnzz_fw;
    }

    public void setBnzz_fw(BigDecimal bnzz_fw) {
        this.bnzz_fw = bnzz_fw;
    }

    public String getSwcode() {
        return swcode;
    }

    public void setSwcode(String swcode) {
        this.swcode = swcode;
    }

    public String getBg_user() {
        return bg_user;
    }

    public void setBg_user(String bg_user) {
        this.bg_user = bg_user;
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

    public Date getOp_date() {
        return op_date;
    }

    public void setOp_date(Date op_date) {
        this.op_date = op_date;
    }

    public Date getQr_date() {
        return qr_date;
    }

    public void setQr_date(Date qr_date) {
        this.qr_date = qr_date;
    }

    public Date getBg_date() {
        return bg_date;
    }

    public void setBg_date(Date bg_date) {
        this.bg_date = bg_date;
    }
}