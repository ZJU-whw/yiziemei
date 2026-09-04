package com.tl.web.bjts.yj.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "LS_SH_YDXX")
public class ShYdxx implements Serializable {
    @Id
    @Column(name = "ID")
    private Long id;

    @Id
    @Column(name = "SBID")
    private Long sbid;

    @Column(name = "CPCODE")
    private String cpcode;

    @Column(name = "SB_YM")
    private String sbYm;

    @Column(name = "SB_PC")
    private String sbPc;

    @Column(name = "ERR_LY")
    private String errLy;

    @Column(name = "ERR_OBJ")
    private String errObj;

    @Column(name = "GLYWB1")
    private String glywb1;

    @Column(name = "GLYWB2")
    private String glywb2;

    @Column(name = "GLYWB3")
    private String glywb3;

    @Column(name = "GLYWZ1")
    private String glywz1;

    @Column(name = "GLYWZ2")
    private String glywz2;

    @Column(name = "YDCODE")
    private String ydcode;

    @Column(name = "ERR_LEV")
    private String errLev;

    @Column(name = "ERR_MSG")
    private String errMsg;

    @Column(name = "PASS_FLAG")
    private String passFlag;

    @Column(name = "CRTIME")
    private Date crtime;

    @Column(name = "YDTG_FLAG")
    private String ydtgFlag;

    @Column(name = "CLYJSM")
    private String clyjsm;

    @Column(name = "TG_USER")
    private String tgUser;

    @Column(name = "TG_DATE")
    private Date tgDate;

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
     * @return CPCODE
     */
    public String getCpcode() {
        return cpcode;
    }

    /**
     * @param cpcode
     */
    public void setCpcode(String cpcode) {
        this.cpcode = cpcode == null ? null : cpcode.trim();
    }

    /**
     * @return SB_YM
     */
    public String getSbYm() {
        return sbYm;
    }

    /**
     * @param sbYm
     */
    public void setSbYm(String sbYm) {
        this.sbYm = sbYm == null ? null : sbYm.trim();
    }

    /**
     * @return SB_PC
     */
    public String getSbPc() {
        return sbPc;
    }

    /**
     * @param sbPc
     */
    public void setSbPc(String sbPc) {
        this.sbPc = sbPc == null ? null : sbPc.trim();
    }

    /**
     * @return ERR_LY
     */
    public String getErrLy() {
        return errLy;
    }

    /**
     * @param errLy
     */
    public void setErrLy(String errLy) {
        this.errLy = errLy == null ? null : errLy.trim();
    }

    /**
     * @return ERR_OBJ
     */
    public String getErrObj() {
        return errObj;
    }

    /**
     * @param errObj
     */
    public void setErrObj(String errObj) {
        this.errObj = errObj == null ? null : errObj.trim();
    }

    /**
     * @return GLYWB1
     */
    public String getGlywb1() {
        return glywb1;
    }

    /**
     * @param glywb1
     */
    public void setGlywb1(String glywb1) {
        this.glywb1 = glywb1 == null ? null : glywb1.trim();
    }

    /**
     * @return GLYWB2
     */
    public String getGlywb2() {
        return glywb2;
    }

    /**
     * @param glywb2
     */
    public void setGlywb2(String glywb2) {
        this.glywb2 = glywb2 == null ? null : glywb2.trim();
    }

    /**
     * @return GLYWB3
     */
    public String getGlywb3() {
        return glywb3;
    }

    /**
     * @param glywb3
     */
    public void setGlywb3(String glywb3) {
        this.glywb3 = glywb3 == null ? null : glywb3.trim();
    }

    /**
     * @return GLYWZ1
     */
    public String getGlywz1() {
        return glywz1;
    }

    /**
     * @param glywz1
     */
    public void setGlywz1(String glywz1) {
        this.glywz1 = glywz1 == null ? null : glywz1.trim();
    }

    /**
     * @return GLYWZ2
     */
    public String getGlywz2() {
        return glywz2;
    }

    /**
     * @param glywz2
     */
    public void setGlywz2(String glywz2) {
        this.glywz2 = glywz2 == null ? null : glywz2.trim();
    }

    /**
     * @return YDCODE
     */
    public String getYdcode() {
        return ydcode;
    }

    /**
     * @param ydcode
     */
    public void setYdcode(String ydcode) {
        this.ydcode = ydcode == null ? null : ydcode.trim();
    }

    /**
     * @return ERR_LEV
     */
    public String getErrLev() {
        return errLev;
    }

    /**
     * @param errLev
     */
    public void setErrLev(String errLev) {
        this.errLev = errLev == null ? null : errLev.trim();
    }

    /**
     * @return ERR_MSG
     */
    public String getErrMsg() {
        return errMsg;
    }

    /**
     * @param errMsg
     */
    public void setErrMsg(String errMsg) {
        this.errMsg = errMsg == null ? null : errMsg.trim();
    }

    /**
     * @return PASS_FLAG
     */
    public String getPassFlag() {
        return passFlag;
    }

    /**
     * @param passFlag
     */
    public void setPassFlag(String passFlag) {
        this.passFlag = passFlag == null ? null : passFlag.trim();
    }

    /**
     * @return CRTIME
     */
    public Date getCrtime() {
        return crtime;
    }

    /**
     * @param crtime
     */
    public void setCrtime(Date crtime) {
        this.crtime = crtime;
    }

    /**
     * @return YDTG_FLAG
     */
    public String getYdtgFlag() {
        return ydtgFlag;
    }

    /**
     * @param ydtgFlag
     */
    public void setYdtgFlag(String ydtgFlag) {
        this.ydtgFlag = ydtgFlag == null ? null : ydtgFlag.trim();
    }

    /**
     * @return CLYJSM
     */
    public String getClyjsm() {
        return clyjsm;
    }

    /**
     * @param clyjsm
     */
    public void setClyjsm(String clyjsm) {
        this.clyjsm = clyjsm == null ? null : clyjsm.trim();
    }

    /**
     * @return TG_USER
     */
    public String getTgUser() {
        return tgUser;
    }

    /**
     * @param tgUser
     */
    public void setTgUser(String tgUser) {
        this.tgUser = tgUser == null ? null : tgUser.trim();
    }

    /**
     * @return TG_DATE
     */
    public Date getTgDate() {
        return tgDate;
    }

    /**
     * @param tgDate
     */
    public void setTgDate(Date tgDate) {
        this.tgDate = tgDate;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", sbid=").append(sbid);
        sb.append(", cpcode=").append(cpcode);
        sb.append(", sbYm=").append(sbYm);
        sb.append(", sbPc=").append(sbPc);
        sb.append(", errLy=").append(errLy);
        sb.append(", errObj=").append(errObj);
        sb.append(", glywb1=").append(glywb1);
        sb.append(", glywb2=").append(glywb2);
        sb.append(", glywb3=").append(glywb3);
        sb.append(", glywz1=").append(glywz1);
        sb.append(", glywz2=").append(glywz2);
        sb.append(", ydcode=").append(ydcode);
        sb.append(", errLev=").append(errLev);
        sb.append(", errMsg=").append(errMsg);
        sb.append(", passFlag=").append(passFlag);
        sb.append(", crtime=").append(crtime);
        sb.append(", ydtgFlag=").append(ydtgFlag);
        sb.append(", clyjsm=").append(clyjsm);
        sb.append(", tgUser=").append(tgUser);
        sb.append(", tgDate=").append(tgDate);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}