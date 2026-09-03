package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TSSH.GC_MTS_YGZ_LSLCK")
public class GcMtsYgzLslck implements Serializable {
    @Id
    private String UUID;

    private String LCSLID;

    private String CPCODE;

    private String LDLP_NO;

    private String DPCODE;

    private String DP_NAME;

    private String SB_YM;

    private String SB_PC;

    private String SB_NO;

    private String CMCODE;

    private String CMNAME;

    private String HT_NO;

    private String JWDW_NAME;

    private String GBCODE;

    private BigDecimal USD_TOTAL;

    private BigDecimal RMB_TOTAL;

    private Long SKPZ_NUM;

    private BigDecimal RMB_AMT;

    private BigDecimal USD_AMT;

    private BigDecimal CKJH_AMT;

    private BigDecimal TSL;

    private BigDecimal TS_AMT;

    private String DZBQ_FLAG;

    private String NOTE;

    private Date SH_TIME;

    private String JBSH_FLAG;

    private String ZHSH_FLAG;

    private String OP_USER;

    private Date OP_DATE;

    private String SHQ_NO;

    private String FLAG;

    private String SWCODE;

    private String BG_USER;

    private Date BG_DATE;

    private String ZH_FLAG;

    private String BY_FLAG;

    @Column(name = "Y_UUID")
    private String y_UUID;

    private String ZH_TYPE;

    private String BY_TYPE;

    private String MTS_FLAG;

    private String MTS_YM;

    private String RGSH_FLAG;

    private String RGSH_PASS;

    private String RGSH_USER;

    private Date RGSH_DATE;

    private String RGSH_INFO;

    private String YWLXCODE;

    private String YWLX;

    private static final long serialVersionUID = 1L;

    /**
     * @return UUID
     */
    public String getUUID() {
        return UUID;
    }

    /**
     * @param UUID
     */
    public void setUUID(String UUID) {
        this.UUID = UUID == null ? null : UUID.trim();
    }

    /**
     * @return LCSLID
     */
    public String getLCSLID() {
        return LCSLID;
    }

    /**
     * @param LCSLID
     */
    public void setLCSLID(String LCSLID) {
        this.LCSLID = LCSLID == null ? null : LCSLID.trim();
    }

    /**
     * @return CPCODE
     */
    public String getCPCODE() {
        return CPCODE;
    }

    /**
     * @param CPCODE
     */
    public void setCPCODE(String CPCODE) {
        this.CPCODE = CPCODE == null ? null : CPCODE.trim();
    }

    /**
     * @return LDLP_NO
     */
    public String getLDLP_NO() {
        return LDLP_NO;
    }

    /**
     * @param LDLP_NO
     */
    public void setLDLP_NO(String LDLP_NO) {
        this.LDLP_NO = LDLP_NO == null ? null : LDLP_NO.trim();
    }

    /**
     * @return DPCODE
     */
    public String getDPCODE() {
        return DPCODE;
    }

    /**
     * @param DPCODE
     */
    public void setDPCODE(String DPCODE) {
        this.DPCODE = DPCODE == null ? null : DPCODE.trim();
    }

    /**
     * @return DP_NAME
     */
    public String getDP_NAME() {
        return DP_NAME;
    }

    /**
     * @param DP_NAME
     */
    public void setDP_NAME(String DP_NAME) {
        this.DP_NAME = DP_NAME == null ? null : DP_NAME.trim();
    }

    /**
     * @return SB_YM
     */
    public String getSB_YM() {
        return SB_YM;
    }

    /**
     * @param SB_YM
     */
    public void setSB_YM(String SB_YM) {
        this.SB_YM = SB_YM == null ? null : SB_YM.trim();
    }

    /**
     * @return SB_PC
     */
    public String getSB_PC() {
        return SB_PC;
    }

    /**
     * @param SB_PC
     */
    public void setSB_PC(String SB_PC) {
        this.SB_PC = SB_PC == null ? null : SB_PC.trim();
    }

    /**
     * @return SB_NO
     */
    public String getSB_NO() {
        return SB_NO;
    }

    /**
     * @param SB_NO
     */
    public void setSB_NO(String SB_NO) {
        this.SB_NO = SB_NO == null ? null : SB_NO.trim();
    }

    /**
     * @return CMCODE
     */
    public String getCMCODE() {
        return CMCODE;
    }

    /**
     * @param CMCODE
     */
    public void setCMCODE(String CMCODE) {
        this.CMCODE = CMCODE == null ? null : CMCODE.trim();
    }

    /**
     * @return CMNAME
     */
    public String getCMNAME() {
        return CMNAME;
    }

    /**
     * @param CMNAME
     */
    public void setCMNAME(String CMNAME) {
        this.CMNAME = CMNAME == null ? null : CMNAME.trim();
    }

    /**
     * @return HT_NO
     */
    public String getHT_NO() {
        return HT_NO;
    }

    /**
     * @param HT_NO
     */
    public void setHT_NO(String HT_NO) {
        this.HT_NO = HT_NO == null ? null : HT_NO.trim();
    }

    /**
     * @return JWDW_NAME
     */
    public String getJWDW_NAME() {
        return JWDW_NAME;
    }

    /**
     * @param JWDW_NAME
     */
    public void setJWDW_NAME(String JWDW_NAME) {
        this.JWDW_NAME = JWDW_NAME == null ? null : JWDW_NAME.trim();
    }

    /**
     * @return GBCODE
     */
    public String getGBCODE() {
        return GBCODE;
    }

    /**
     * @param GBCODE
     */
    public void setGBCODE(String GBCODE) {
        this.GBCODE = GBCODE == null ? null : GBCODE.trim();
    }

    /**
     * @return USD_TOTAL
     */
    public BigDecimal getUSD_TOTAL() {
        return USD_TOTAL;
    }

    /**
     * @param USD_TOTAL
     */
    public void setUSD_TOTAL(BigDecimal USD_TOTAL) {
        this.USD_TOTAL = USD_TOTAL;
    }

    /**
     * @return RMB_TOTAL
     */
    public BigDecimal getRMB_TOTAL() {
        return RMB_TOTAL;
    }

    /**
     * @param RMB_TOTAL
     */
    public void setRMB_TOTAL(BigDecimal RMB_TOTAL) {
        this.RMB_TOTAL = RMB_TOTAL;
    }

    /**
     * @return SKPZ_NUM
     */
    public Long getSKPZ_NUM() {
        return SKPZ_NUM;
    }

    /**
     * @param SKPZ_NUM
     */
    public void setSKPZ_NUM(Long SKPZ_NUM) {
        this.SKPZ_NUM = SKPZ_NUM;
    }

    /**
     * @return RMB_AMT
     */
    public BigDecimal getRMB_AMT() {
        return RMB_AMT;
    }

    /**
     * @param RMB_AMT
     */
    public void setRMB_AMT(BigDecimal RMB_AMT) {
        this.RMB_AMT = RMB_AMT;
    }

    /**
     * @return USD_AMT
     */
    public BigDecimal getUSD_AMT() {
        return USD_AMT;
    }

    /**
     * @param USD_AMT
     */
    public void setUSD_AMT(BigDecimal USD_AMT) {
        this.USD_AMT = USD_AMT;
    }

    /**
     * @return CKJH_AMT
     */
    public BigDecimal getCKJH_AMT() {
        return CKJH_AMT;
    }

    /**
     * @param CKJH_AMT
     */
    public void setCKJH_AMT(BigDecimal CKJH_AMT) {
        this.CKJH_AMT = CKJH_AMT;
    }

    /**
     * @return TSL
     */
    public BigDecimal getTSL() {
        return TSL;
    }

    /**
     * @param TSL
     */
    public void setTSL(BigDecimal TSL) {
        this.TSL = TSL;
    }

    /**
     * @return TS_AMT
     */
    public BigDecimal getTS_AMT() {
        return TS_AMT;
    }

    /**
     * @param TS_AMT
     */
    public void setTS_AMT(BigDecimal TS_AMT) {
        this.TS_AMT = TS_AMT;
    }

    /**
     * @return DZBQ_FLAG
     */
    public String getDZBQ_FLAG() {
        return DZBQ_FLAG;
    }

    /**
     * @param DZBQ_FLAG
     */
    public void setDZBQ_FLAG(String DZBQ_FLAG) {
        this.DZBQ_FLAG = DZBQ_FLAG == null ? null : DZBQ_FLAG.trim();
    }

    /**
     * @return NOTE
     */
    public String getNOTE() {
        return NOTE;
    }

    /**
     * @param NOTE
     */
    public void setNOTE(String NOTE) {
        this.NOTE = NOTE == null ? null : NOTE.trim();
    }

    /**
     * @return SH_TIME
     */
    public Date getSH_TIME() {
        return SH_TIME;
    }

    /**
     * @param SH_TIME
     */
    public void setSH_TIME(Date SH_TIME) {
        this.SH_TIME = SH_TIME;
    }

    /**
     * @return JBSH_FLAG
     */
    public String getJBSH_FLAG() {
        return JBSH_FLAG;
    }

    /**
     * @param JBSH_FLAG
     */
    public void setJBSH_FLAG(String JBSH_FLAG) {
        this.JBSH_FLAG = JBSH_FLAG == null ? null : JBSH_FLAG.trim();
    }

    /**
     * @return ZHSH_FLAG
     */
    public String getZHSH_FLAG() {
        return ZHSH_FLAG;
    }

    /**
     * @param ZHSH_FLAG
     */
    public void setZHSH_FLAG(String ZHSH_FLAG) {
        this.ZHSH_FLAG = ZHSH_FLAG == null ? null : ZHSH_FLAG.trim();
    }

    /**
     * @return OP_USER
     */
    public String getOP_USER() {
        return OP_USER;
    }

    /**
     * @param OP_USER
     */
    public void setOP_USER(String OP_USER) {
        this.OP_USER = OP_USER == null ? null : OP_USER.trim();
    }

    /**
     * @return OP_DATE
     */
    public Date getOP_DATE() {
        return OP_DATE;
    }

    /**
     * @param OP_DATE
     */
    public void setOP_DATE(Date OP_DATE) {
        this.OP_DATE = OP_DATE;
    }

    /**
     * @return SHQ_NO
     */
    public String getSHQ_NO() {
        return SHQ_NO;
    }

    /**
     * @param SHQ_NO
     */
    public void setSHQ_NO(String SHQ_NO) {
        this.SHQ_NO = SHQ_NO == null ? null : SHQ_NO.trim();
    }

    /**
     * @return FLAG
     */
    public String getFLAG() {
        return FLAG;
    }

    /**
     * @param FLAG
     */
    public void setFLAG(String FLAG) {
        this.FLAG = FLAG == null ? null : FLAG.trim();
    }

    /**
     * @return SWCODE
     */
    public String getSWCODE() {
        return SWCODE;
    }

    /**
     * @param SWCODE
     */
    public void setSWCODE(String SWCODE) {
        this.SWCODE = SWCODE == null ? null : SWCODE.trim();
    }

    /**
     * @return BG_USER
     */
    public String getBG_USER() {
        return BG_USER;
    }

    /**
     * @param BG_USER
     */
    public void setBG_USER(String BG_USER) {
        this.BG_USER = BG_USER == null ? null : BG_USER.trim();
    }

    /**
     * @return BG_DATE
     */
    public Date getBG_DATE() {
        return BG_DATE;
    }

    /**
     * @param BG_DATE
     */
    public void setBG_DATE(Date BG_DATE) {
        this.BG_DATE = BG_DATE;
    }

    /**
     * @return ZH_FLAG
     */
    public String getZH_FLAG() {
        return ZH_FLAG;
    }

    /**
     * @param ZH_FLAG
     */
    public void setZH_FLAG(String ZH_FLAG) {
        this.ZH_FLAG = ZH_FLAG == null ? null : ZH_FLAG.trim();
    }

    /**
     * @return BY_FLAG
     */
    public String getBY_FLAG() {
        return BY_FLAG;
    }

    /**
     * @param BY_FLAG
     */
    public void setBY_FLAG(String BY_FLAG) {
        this.BY_FLAG = BY_FLAG == null ? null : BY_FLAG.trim();
    }

    /**
     * @return Y_UUID
     */
    public String getY_UUID() {
        return y_UUID;
    }

    /**
     * @param y_UUID
     */
    public void setY_UUID(String y_UUID) {
        this.y_UUID = y_UUID == null ? null : y_UUID.trim();
    }

    /**
     * @return ZH_TYPE
     */
    public String getZH_TYPE() {
        return ZH_TYPE;
    }

    /**
     * @param ZH_TYPE
     */
    public void setZH_TYPE(String ZH_TYPE) {
        this.ZH_TYPE = ZH_TYPE == null ? null : ZH_TYPE.trim();
    }

    /**
     * @return BY_TYPE
     */
    public String getBY_TYPE() {
        return BY_TYPE;
    }

    /**
     * @param BY_TYPE
     */
    public void setBY_TYPE(String BY_TYPE) {
        this.BY_TYPE = BY_TYPE == null ? null : BY_TYPE.trim();
    }

    /**
     * @return MTS_FLAG
     */
    public String getMTS_FLAG() {
        return MTS_FLAG;
    }

    /**
     * @param MTS_FLAG
     */
    public void setMTS_FLAG(String MTS_FLAG) {
        this.MTS_FLAG = MTS_FLAG == null ? null : MTS_FLAG.trim();
    }

    /**
     * @return MTS_YM
     */
    public String getMTS_YM() {
        return MTS_YM;
    }

    /**
     * @param MTS_YM
     */
    public void setMTS_YM(String MTS_YM) {
        this.MTS_YM = MTS_YM == null ? null : MTS_YM.trim();
    }

    /**
     * @return RGSH_FLAG
     */
    public String getRGSH_FLAG() {
        return RGSH_FLAG;
    }

    /**
     * @param RGSH_FLAG
     */
    public void setRGSH_FLAG(String RGSH_FLAG) {
        this.RGSH_FLAG = RGSH_FLAG == null ? null : RGSH_FLAG.trim();
    }

    /**
     * @return RGSH_PASS
     */
    public String getRGSH_PASS() {
        return RGSH_PASS;
    }

    /**
     * @param RGSH_PASS
     */
    public void setRGSH_PASS(String RGSH_PASS) {
        this.RGSH_PASS = RGSH_PASS == null ? null : RGSH_PASS.trim();
    }

    /**
     * @return RGSH_USER
     */
    public String getRGSH_USER() {
        return RGSH_USER;
    }

    /**
     * @param RGSH_USER
     */
    public void setRGSH_USER(String RGSH_USER) {
        this.RGSH_USER = RGSH_USER == null ? null : RGSH_USER.trim();
    }

    /**
     * @return RGSH_DATE
     */
    public Date getRGSH_DATE() {
        return RGSH_DATE;
    }

    /**
     * @param RGSH_DATE
     */
    public void setRGSH_DATE(Date RGSH_DATE) {
        this.RGSH_DATE = RGSH_DATE;
    }

    /**
     * @return RGSH_INFO
     */
    public String getRGSH_INFO() {
        return RGSH_INFO;
    }

    /**
     * @param RGSH_INFO
     */
    public void setRGSH_INFO(String RGSH_INFO) {
        this.RGSH_INFO = RGSH_INFO == null ? null : RGSH_INFO.trim();
    }

    /**
     * @return YWLXCODE
     */
    public String getYWLXCODE() {
        return YWLXCODE;
    }

    /**
     * @param YWLXCODE
     */
    public void setYWLXCODE(String YWLXCODE) {
        this.YWLXCODE = YWLXCODE == null ? null : YWLXCODE.trim();
    }

    /**
     * @return YWLX
     */
    public String getYWLX() {
        return YWLX;
    }

    /**
     * @param YWLX
     */
    public void setYWLX(String YWLX) {
        this.YWLX = YWLX == null ? null : YWLX.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", UUID=").append(UUID);
        sb.append(", LCSLID=").append(LCSLID);
        sb.append(", CPCODE=").append(CPCODE);
        sb.append(", LDLP_NO=").append(LDLP_NO);
        sb.append(", DPCODE=").append(DPCODE);
        sb.append(", DP_NAME=").append(DP_NAME);
        sb.append(", SB_YM=").append(SB_YM);
        sb.append(", SB_PC=").append(SB_PC);
        sb.append(", SB_NO=").append(SB_NO);
        sb.append(", CMCODE=").append(CMCODE);
        sb.append(", CMNAME=").append(CMNAME);
        sb.append(", HT_NO=").append(HT_NO);
        sb.append(", JWDW_NAME=").append(JWDW_NAME);
        sb.append(", GBCODE=").append(GBCODE);
        sb.append(", USD_TOTAL=").append(USD_TOTAL);
        sb.append(", RMB_TOTAL=").append(RMB_TOTAL);
        sb.append(", SKPZ_NUM=").append(SKPZ_NUM);
        sb.append(", RMB_AMT=").append(RMB_AMT);
        sb.append(", USD_AMT=").append(USD_AMT);
        sb.append(", CKJH_AMT=").append(CKJH_AMT);
        sb.append(", TSL=").append(TSL);
        sb.append(", TS_AMT=").append(TS_AMT);
        sb.append(", DZBQ_FLAG=").append(DZBQ_FLAG);
        sb.append(", NOTE=").append(NOTE);
        sb.append(", SH_TIME=").append(SH_TIME);
        sb.append(", JBSH_FLAG=").append(JBSH_FLAG);
        sb.append(", ZHSH_FLAG=").append(ZHSH_FLAG);
        sb.append(", OP_USER=").append(OP_USER);
        sb.append(", OP_DATE=").append(OP_DATE);
        sb.append(", SHQ_NO=").append(SHQ_NO);
        sb.append(", FLAG=").append(FLAG);
        sb.append(", SWCODE=").append(SWCODE);
        sb.append(", BG_USER=").append(BG_USER);
        sb.append(", BG_DATE=").append(BG_DATE);
        sb.append(", ZH_FLAG=").append(ZH_FLAG);
        sb.append(", BY_FLAG=").append(BY_FLAG);
        sb.append(", y_UUID=").append(y_UUID);
        sb.append(", ZH_TYPE=").append(ZH_TYPE);
        sb.append(", BY_TYPE=").append(BY_TYPE);
        sb.append(", MTS_FLAG=").append(MTS_FLAG);
        sb.append(", MTS_YM=").append(MTS_YM);
        sb.append(", RGSH_FLAG=").append(RGSH_FLAG);
        sb.append(", RGSH_PASS=").append(RGSH_PASS);
        sb.append(", RGSH_USER=").append(RGSH_USER);
        sb.append(", RGSH_DATE=").append(RGSH_DATE);
        sb.append(", RGSH_INFO=").append(RGSH_INFO);
        sb.append(", YWLXCODE=").append(YWLXCODE);
        sb.append(", YWLX=").append(YWLX);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}