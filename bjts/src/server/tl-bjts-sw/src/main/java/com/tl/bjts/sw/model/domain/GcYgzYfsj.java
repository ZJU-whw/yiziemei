package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TSSH.GC_YGZ_YFSJ")
public class GcYgzYfsj implements Serializable {
    @Id
    private String UUID;

    private String LCSLID;

    private String CPCODE;

    private String SB_YM;

    private String SB_NO;

    private String SS_YEAR;

    private Date LJ_DATE;

    private String CMCODE;

    private String CMNAME;

    private String CMUNIT;

    private String HT_NO;

    private String JWDW_NAME;

    private String GBCODE;

    private BigDecimal RMB_TOTAL;

    private BigDecimal USD_HL;

    private BigDecimal USD_TOTAL;

    private Long SKPZ_NUM;

    private BigDecimal SK_RMB_AMT;

    private BigDecimal SK_USD_AMT;

    private BigDecimal RMB_AMT;

    private BigDecimal USD_AMT;

    private BigDecimal ZFJK_AMT;

    private BigDecimal JS_AMT;

    private BigDecimal ZSSL;

    private BigDecimal TSL;

    private BigDecimal ZTSCE;

    private BigDecimal TS_AMT;

    private String MDTS_YM;

    private String JBSH_FLAG;

    private String ZHSH_FLAG;

    private String OP_USER;

    private Date OP_DATE;

    private String NOTE;

    private String RSV_STR;

    private String FLAG;

    private String HX_FLAG;

    private BigDecimal HX_AMT;

    private String ZS_FLAG;

    private String SK_BICODE;

    private BigDecimal SK_YB_AMT;

    private String BICODE;

    private BigDecimal YB_AMT;

    private String BG_USER;

    private Date BG_DATE;

    private String SWCODE;

    private String ZH_FLAG;

    private String BY_FLAG;

    @Column(name = "Y_UUID")
    private String y_UUID;

    private String ZH_TYPE;

    private String BY_TYPE;

    private String RGSH_FLAG;

    private String RGSH_PASS;

    private String RGSH_USER;

    private Date RGSH_DATE;

    private String RGSH_INFO;

    private String NO;

    private String YWLXCODE;

    private String YWLX;

    private String MDTS_FLAG;

    private String BYTS_YM;

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
     * @return SS_YEAR
     */
    public String getSS_YEAR() {
        return SS_YEAR;
    }

    /**
     * @param SS_YEAR
     */
    public void setSS_YEAR(String SS_YEAR) {
        this.SS_YEAR = SS_YEAR == null ? null : SS_YEAR.trim();
    }

    /**
     * @return LJ_DATE
     */
    public Date getLJ_DATE() {
        return LJ_DATE;
    }

    /**
     * @param LJ_DATE
     */
    public void setLJ_DATE(Date LJ_DATE) {
        this.LJ_DATE = LJ_DATE;
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
     * @return CMUNIT
     */
    public String getCMUNIT() {
        return CMUNIT;
    }

    /**
     * @param CMUNIT
     */
    public void setCMUNIT(String CMUNIT) {
        this.CMUNIT = CMUNIT == null ? null : CMUNIT.trim();
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
     * @return USD_HL
     */
    public BigDecimal getUSD_HL() {
        return USD_HL;
    }

    /**
     * @param USD_HL
     */
    public void setUSD_HL(BigDecimal USD_HL) {
        this.USD_HL = USD_HL;
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
     * @return SK_RMB_AMT
     */
    public BigDecimal getSK_RMB_AMT() {
        return SK_RMB_AMT;
    }

    /**
     * @param SK_RMB_AMT
     */
    public void setSK_RMB_AMT(BigDecimal SK_RMB_AMT) {
        this.SK_RMB_AMT = SK_RMB_AMT;
    }

    /**
     * @return SK_USD_AMT
     */
    public BigDecimal getSK_USD_AMT() {
        return SK_USD_AMT;
    }

    /**
     * @param SK_USD_AMT
     */
    public void setSK_USD_AMT(BigDecimal SK_USD_AMT) {
        this.SK_USD_AMT = SK_USD_AMT;
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
     * @return ZFJK_AMT
     */
    public BigDecimal getZFJK_AMT() {
        return ZFJK_AMT;
    }

    /**
     * @param ZFJK_AMT
     */
    public void setZFJK_AMT(BigDecimal ZFJK_AMT) {
        this.ZFJK_AMT = ZFJK_AMT;
    }

    /**
     * @return JS_AMT
     */
    public BigDecimal getJS_AMT() {
        return JS_AMT;
    }

    /**
     * @param JS_AMT
     */
    public void setJS_AMT(BigDecimal JS_AMT) {
        this.JS_AMT = JS_AMT;
    }

    /**
     * @return ZSSL
     */
    public BigDecimal getZSSL() {
        return ZSSL;
    }

    /**
     * @param ZSSL
     */
    public void setZSSL(BigDecimal ZSSL) {
        this.ZSSL = ZSSL;
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
     * @return ZTSCE
     */
    public BigDecimal getZTSCE() {
        return ZTSCE;
    }

    /**
     * @param ZTSCE
     */
    public void setZTSCE(BigDecimal ZTSCE) {
        this.ZTSCE = ZTSCE;
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
     * @return MDTS_YM
     */
    public String getMDTS_YM() {
        return MDTS_YM;
    }

    /**
     * @param MDTS_YM
     */
    public void setMDTS_YM(String MDTS_YM) {
        this.MDTS_YM = MDTS_YM == null ? null : MDTS_YM.trim();
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
     * @return RSV_STR
     */
    public String getRSV_STR() {
        return RSV_STR;
    }

    /**
     * @param RSV_STR
     */
    public void setRSV_STR(String RSV_STR) {
        this.RSV_STR = RSV_STR == null ? null : RSV_STR.trim();
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
     * @return HX_FLAG
     */
    public String getHX_FLAG() {
        return HX_FLAG;
    }

    /**
     * @param HX_FLAG
     */
    public void setHX_FLAG(String HX_FLAG) {
        this.HX_FLAG = HX_FLAG == null ? null : HX_FLAG.trim();
    }

    /**
     * @return HX_AMT
     */
    public BigDecimal getHX_AMT() {
        return HX_AMT;
    }

    /**
     * @param HX_AMT
     */
    public void setHX_AMT(BigDecimal HX_AMT) {
        this.HX_AMT = HX_AMT;
    }

    /**
     * @return ZS_FLAG
     */
    public String getZS_FLAG() {
        return ZS_FLAG;
    }

    /**
     * @param ZS_FLAG
     */
    public void setZS_FLAG(String ZS_FLAG) {
        this.ZS_FLAG = ZS_FLAG == null ? null : ZS_FLAG.trim();
    }

    /**
     * @return SK_BICODE
     */
    public String getSK_BICODE() {
        return SK_BICODE;
    }

    /**
     * @param SK_BICODE
     */
    public void setSK_BICODE(String SK_BICODE) {
        this.SK_BICODE = SK_BICODE == null ? null : SK_BICODE.trim();
    }

    /**
     * @return SK_YB_AMT
     */
    public BigDecimal getSK_YB_AMT() {
        return SK_YB_AMT;
    }

    /**
     * @param SK_YB_AMT
     */
    public void setSK_YB_AMT(BigDecimal SK_YB_AMT) {
        this.SK_YB_AMT = SK_YB_AMT;
    }

    /**
     * @return BICODE
     */
    public String getBICODE() {
        return BICODE;
    }

    /**
     * @param BICODE
     */
    public void setBICODE(String BICODE) {
        this.BICODE = BICODE == null ? null : BICODE.trim();
    }

    /**
     * @return YB_AMT
     */
    public BigDecimal getYB_AMT() {
        return YB_AMT;
    }

    /**
     * @param YB_AMT
     */
    public void setYB_AMT(BigDecimal YB_AMT) {
        this.YB_AMT = YB_AMT;
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
     * @return NO
     */
    public String getNO() {
        return NO;
    }

    /**
     * @param NO
     */
    public void setNO(String NO) {
        this.NO = NO == null ? null : NO.trim();
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

    /**
     * @return MDTS_FLAG
     */
    public String getMDTS_FLAG() {
        return MDTS_FLAG;
    }

    /**
     * @param MDTS_FLAG
     */
    public void setMDTS_FLAG(String MDTS_FLAG) {
        this.MDTS_FLAG = MDTS_FLAG == null ? null : MDTS_FLAG.trim();
    }

    /**
     * @return BYTS_YM
     */
    public String getBYTS_YM() {
        return BYTS_YM;
    }

    /**
     * @param BYTS_YM
     */
    public void setBYTS_YM(String BYTS_YM) {
        this.BYTS_YM = BYTS_YM == null ? null : BYTS_YM.trim();
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
        sb.append(", SB_YM=").append(SB_YM);
        sb.append(", SB_NO=").append(SB_NO);
        sb.append(", SS_YEAR=").append(SS_YEAR);
        sb.append(", LJ_DATE=").append(LJ_DATE);
        sb.append(", CMCODE=").append(CMCODE);
        sb.append(", CMNAME=").append(CMNAME);
        sb.append(", CMUNIT=").append(CMUNIT);
        sb.append(", HT_NO=").append(HT_NO);
        sb.append(", JWDW_NAME=").append(JWDW_NAME);
        sb.append(", GBCODE=").append(GBCODE);
        sb.append(", RMB_TOTAL=").append(RMB_TOTAL);
        sb.append(", USD_HL=").append(USD_HL);
        sb.append(", USD_TOTAL=").append(USD_TOTAL);
        sb.append(", SKPZ_NUM=").append(SKPZ_NUM);
        sb.append(", SK_RMB_AMT=").append(SK_RMB_AMT);
        sb.append(", SK_USD_AMT=").append(SK_USD_AMT);
        sb.append(", RMB_AMT=").append(RMB_AMT);
        sb.append(", USD_AMT=").append(USD_AMT);
        sb.append(", ZFJK_AMT=").append(ZFJK_AMT);
        sb.append(", JS_AMT=").append(JS_AMT);
        sb.append(", ZSSL=").append(ZSSL);
        sb.append(", TSL=").append(TSL);
        sb.append(", ZTSCE=").append(ZTSCE);
        sb.append(", TS_AMT=").append(TS_AMT);
        sb.append(", MDTS_YM=").append(MDTS_YM);
        sb.append(", JBSH_FLAG=").append(JBSH_FLAG);
        sb.append(", ZHSH_FLAG=").append(ZHSH_FLAG);
        sb.append(", OP_USER=").append(OP_USER);
        sb.append(", OP_DATE=").append(OP_DATE);
        sb.append(", NOTE=").append(NOTE);
        sb.append(", RSV_STR=").append(RSV_STR);
        sb.append(", FLAG=").append(FLAG);
        sb.append(", HX_FLAG=").append(HX_FLAG);
        sb.append(", HX_AMT=").append(HX_AMT);
        sb.append(", ZS_FLAG=").append(ZS_FLAG);
        sb.append(", SK_BICODE=").append(SK_BICODE);
        sb.append(", SK_YB_AMT=").append(SK_YB_AMT);
        sb.append(", BICODE=").append(BICODE);
        sb.append(", YB_AMT=").append(YB_AMT);
        sb.append(", BG_USER=").append(BG_USER);
        sb.append(", BG_DATE=").append(BG_DATE);
        sb.append(", SWCODE=").append(SWCODE);
        sb.append(", ZH_FLAG=").append(ZH_FLAG);
        sb.append(", BY_FLAG=").append(BY_FLAG);
        sb.append(", y_UUID=").append(y_UUID);
        sb.append(", ZH_TYPE=").append(ZH_TYPE);
        sb.append(", BY_TYPE=").append(BY_TYPE);
        sb.append(", RGSH_FLAG=").append(RGSH_FLAG);
        sb.append(", RGSH_PASS=").append(RGSH_PASS);
        sb.append(", RGSH_USER=").append(RGSH_USER);
        sb.append(", RGSH_DATE=").append(RGSH_DATE);
        sb.append(", RGSH_INFO=").append(RGSH_INFO);
        sb.append(", NO=").append(NO);
        sb.append(", YWLXCODE=").append(YWLXCODE);
        sb.append(", YWLX=").append(YWLX);
        sb.append(", MDTS_FLAG=").append(MDTS_FLAG);
        sb.append(", BYTS_YM=").append(BYTS_YM);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}