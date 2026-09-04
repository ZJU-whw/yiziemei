package com.tl.web.bjts.yj.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "tl_admin.YJ_DATA_YJXX")
public class YjYjxxModel implements Serializable {
    @Id
    @Column(name = "ID")
    private Long id;

    @Column(name = "TBPC")
    private Long tbpc;

    @Column(name = "SBID")
    private Long sbid;

    @Column(name = "NSRDZDAH")
    private BigDecimal nsrdzdah;

    @Column(name = "CJ_DATE")
    private Date cjDate;

    @Column(name = "YJCODE")
    private String yjcode;

    @Column(name = "ZBCODE")
    private String zbcode;

    @Column(name = "YJ_OBJECT")
    private String yjObject;

    @Column(name = "YJ_COUNT")
    private Integer yjCount;

    @Column(name = "YJ_AMT")
    private BigDecimal yjAmt;

    @Column(name = "YJ_TAX")
    private BigDecimal yjTax;

    @Column(name = "YJ_RECORD")
    private String yjRecord;

    @Column(name = "YJ_MSG")
    private String yjMsg;

    @Column(name = "CL_DATE")
    private Date clDate;

    @Column(name = "CL_FLAG")
    private String clFlag;

    @Column(name = "CL_USER")
    private String clUser;

    @Column(name = "CL_MSG")
    private String clMsg;

    @Column(name = "BZ")
    private String bz;

    @Column(name = "SBYM")
    private String sbym;

    @Column(name = "SCORE")
    private Integer score;

    @Column(name = "SWFLAG")
    private String swflag;

    @Column(name = "QYFLAG")
    private String qyflag;

    @Column(name = "BMDFLAG")
    private String bmdflag;

    private static final long serialVersionUID = 1L;

    /**
     * @return ID
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return TBPC
     */
    public Long getTbpc() {
        return tbpc;
    }

    /**
     * @param tbpc
     */
    public void setTbpc(Long tbpc) {
        this.tbpc = tbpc;
    }

    /**
     * @return SBID
     */
    public Long getSbid() {
        return sbid;
    }

    /**
     * @param sbid
     */
    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    /**
     * @return NSRDZDAH
     */
    public BigDecimal getNsrdzdah() {
        return nsrdzdah;
    }

    /**
     * @param nsrdzdah
     */
    public void setNsrdzdah(BigDecimal nsrdzdah) {
        this.nsrdzdah = nsrdzdah;
    }

    /**
     * @return CJ_DATE
     */
    public Date getCjDate() {
        return cjDate;
    }

    /**
     * @param cjDate
     */
    public void setCjDate(Date cjDate) {
        this.cjDate = cjDate;
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
     * @return YJ_OBJECT
     */
    public String getYjObject() {
        return yjObject;
    }

    /**
     * @param yjObject
     */
    public void setYjObject(String yjObject) {
        this.yjObject = yjObject == null ? null : yjObject.trim();
    }

    /**
     * @return YJ_COUNT
     */
    public Integer getYjCount() {
        return yjCount;
    }

    /**
     * @param yjCount
     */
    public void setYjCount(Integer yjCount) {
        this.yjCount = yjCount;
    }

    /**
     * @return YJ_AMT
     */
    public BigDecimal getYjAmt() {
        return yjAmt;
    }

    /**
     * @param yjAmt
     */
    public void setYjAmt(BigDecimal yjAmt) {
        this.yjAmt = yjAmt;
    }

    /**
     * @return YJ_TAX
     */
    public BigDecimal getYjTax() {
        return yjTax;
    }

    /**
     * @param yjTax
     */
    public void setYjTax(BigDecimal yjTax) {
        this.yjTax = yjTax;
    }

    /**
     * @return YJ_RECORD
     */
    public String getYjRecord() {
        return yjRecord;
    }

    /**
     * @param yjRecord
     */
    public void setYjRecord(String yjRecord) {
        this.yjRecord = yjRecord == null ? null : yjRecord.trim();
    }

    /**
     * @return YJ_MSG
     */
    public String getYjMsg() {
        return yjMsg;
    }

    /**
     * @param yjMsg
     */
    public void setYjMsg(String yjMsg) {
        this.yjMsg = yjMsg == null ? null : yjMsg.trim();
    }

    /**
     * @return CL_DATE
     */
    public Date getClDate() {
        return clDate;
    }

    /**
     * @param clDate
     */
    public void setClDate(Date clDate) {
        this.clDate = clDate;
    }

    /**
     * @return CL_FLAG
     */
    public String getClFlag() {
        return clFlag;
    }

    /**
     * @param clFlag
     */
    public void setClFlag(String clFlag) {
        this.clFlag = clFlag == null ? null : clFlag.trim();
    }

    /**
     * @return CL_USER
     */
    public String getClUser() {
        return clUser;
    }

    /**
     * @param clUser
     */
    public void setClUser(String clUser) {
        this.clUser = clUser == null ? null : clUser.trim();
    }

    /**
     * @return CL_MSG
     */
    public String getClMsg() {
        return clMsg;
    }

    /**
     * @param clMsg
     */
    public void setClMsg(String clMsg) {
        this.clMsg = clMsg == null ? null : clMsg.trim();
    }

    /**
     * @return BZ
     */
    public String getBz() {
        return bz;
    }

    /**
     * @param bz
     */
    public void setBz(String bz) {
        this.bz = bz == null ? null : bz.trim();
    }

    /**
     * @return SBYM
     */
    public String getSbym() {
        return sbym;
    }

    /**
     * @param sbym
     */
    public void setSbym(String sbym) {
        this.sbym = sbym == null ? null : sbym.trim();
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
     * @return SWFLAG
     */
    public String getSwflag() {
        return swflag;
    }

    /**
     * @param swflag
     */
    public void setSwflag(String swflag) {
        this.swflag = swflag == null ? null : swflag.trim();
    }

    /**
     * @return QYFLAG
     */
    public String getQyflag() {
        return qyflag;
    }

    /**
     * @param qyflag
     */
    public void setQyflag(String qyflag) {
        this.qyflag = qyflag == null ? null : qyflag.trim();
    }

    /**
     * @return BMDFLAG
     */
    public String getBmdflag() {
        return bmdflag;
    }

    /**
     * @param bmdflag
     */
    public void setBmdflag(String bmdflag) {
        this.bmdflag = bmdflag == null ? null : bmdflag.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", tbpc=").append(tbpc);
        sb.append(", sbid=").append(sbid);
        sb.append(", nsrdzdah=").append(nsrdzdah);
        sb.append(", cjDate=").append(cjDate);
        sb.append(", yjcode=").append(yjcode);
        sb.append(", zbcode=").append(zbcode);
        sb.append(", yjObject=").append(yjObject);
        sb.append(", yjCount=").append(yjCount);
        sb.append(", yjAmt=").append(yjAmt);
        sb.append(", yjTax=").append(yjTax);
        sb.append(", yjRecord=").append(yjRecord);
        sb.append(", yjMsg=").append(yjMsg);
        sb.append(", clDate=").append(clDate);
        sb.append(", clFlag=").append(clFlag);
        sb.append(", clUser=").append(clUser);
        sb.append(", clMsg=").append(clMsg);
        sb.append(", bz=").append(bz);
        sb.append(", sbym=").append(sbym);
        sb.append(", score=").append(score);
        sb.append(", swflag=").append(swflag);
        sb.append(", qyflag=").append(qyflag);
        sb.append(", bmdflag=").append(bmdflag);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}