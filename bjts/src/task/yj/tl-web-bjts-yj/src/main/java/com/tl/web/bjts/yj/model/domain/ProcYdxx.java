package com.tl.web.bjts.yj.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "JCK_BJTS.SHQ_SH_ERR_NEW")
public class ProcYdxx implements Serializable {
    @Id
    @Column(name = "MS_ID")
    private Long msId;

    @Column(name = "ERR_OBJ")
    private String errObj;

    @Column(name = "CPCODE")
    private String cpcode;

    @Column(name = "LDLP_NO")
    private String ldlpNo;

    @Column(name = "DPCODE")
    private String dpcode;

    @Column(name = "SB_YM")
    private String sbYm;

    @Column(name = "SB_NO")
    private String sbNo;

    @Column(name = "PASS_FLAG")
    private String passFlag;

    @Column(name = "CLYJDM_CP")
    private String clyjdmCp;

    @Column(name = "CLYJDM")
    private String clyjdm;

    @Column(name = "CLYJSM")
    private String clyjsm;

    @Column(name = "GX_FLAG")
    private String gxFlag;

    @Column(name = "NOTE")
    private String note;

    @Column(name = "FLAG")
    private String flag;

    @Column(name = "SHQ_NO")
    private String shqNo;

    @Column(name = "YDCODE")
    private String ydcode;

    @Column(name = "ERR_LEV")
    private String errLev;

    @Column(name = "ERR_MSG")
    private String errMsg;

    @Column(name = "DETAIL_MSG")
    private String detailMsg;

    @Column(name = "UUID")
    private String uuid;

    private static final long serialVersionUID = 1L;

    /**
     * @return MS_ID
     */
    public Long getMsId() {
        return msId;
    }

    /**
     * @param msId
     */
    public void setMsId(Long msId) {
        this.msId = msId;
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
     * @return LDLP_NO
     */
    public String getLdlpNo() {
        return ldlpNo;
    }

    /**
     * @param ldlpNo
     */
    public void setLdlpNo(String ldlpNo) {
        this.ldlpNo = ldlpNo == null ? null : ldlpNo.trim();
    }

    /**
     * @return DPCODE
     */
    public String getDpcode() {
        return dpcode;
    }

    /**
     * @param dpcode
     */
    public void setDpcode(String dpcode) {
        this.dpcode = dpcode == null ? null : dpcode.trim();
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
     * @return SB_NO
     */
    public String getSbNo() {
        return sbNo;
    }

    /**
     * @param sbNo
     */
    public void setSbNo(String sbNo) {
        this.sbNo = sbNo == null ? null : sbNo.trim();
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
     * @return CLYJDM_CP
     */
    public String getClyjdmCp() {
        return clyjdmCp;
    }

    /**
     * @param clyjdmCp
     */
    public void setClyjdmCp(String clyjdmCp) {
        this.clyjdmCp = clyjdmCp == null ? null : clyjdmCp.trim();
    }

    /**
     * @return CLYJDM
     */
    public String getClyjdm() {
        return clyjdm;
    }

    /**
     * @param clyjdm
     */
    public void setClyjdm(String clyjdm) {
        this.clyjdm = clyjdm == null ? null : clyjdm.trim();
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
     * @return GX_FLAG
     */
    public String getGxFlag() {
        return gxFlag;
    }

    /**
     * @param gxFlag
     */
    public void setGxFlag(String gxFlag) {
        this.gxFlag = gxFlag == null ? null : gxFlag.trim();
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
     * @return FLAG
     */
    public String getFlag() {
        return flag;
    }

    /**
     * @param flag
     */
    public void setFlag(String flag) {
        this.flag = flag == null ? null : flag.trim();
    }

    /**
     * @return SHQ_NO
     */
    public String getShqNo() {
        return shqNo;
    }

    /**
     * @param shqNo
     */
    public void setShqNo(String shqNo) {
        this.shqNo = shqNo == null ? null : shqNo.trim();
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
     * @return DETAIL_MSG
     */
    public String getDetailMsg() {
        return detailMsg;
    }

    /**
     * @param detailMsg
     */
    public void setDetailMsg(String detailMsg) {
        this.detailMsg = detailMsg == null ? null : detailMsg.trim();
    }

    /**
     * @return UUID
     */
    public String getUuid() {
        return uuid;
    }

    /**
     * @param uuid
     */
    public void setUuid(String uuid) {
        this.uuid = uuid == null ? null : uuid.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", msId=").append(msId);
        sb.append(", errObj=").append(errObj);
        sb.append(", cpcode=").append(cpcode);
        sb.append(", ldlpNo=").append(ldlpNo);
        sb.append(", dpcode=").append(dpcode);
        sb.append(", sbYm=").append(sbYm);
        sb.append(", sbNo=").append(sbNo);
        sb.append(", passFlag=").append(passFlag);
        sb.append(", clyjdmCp=").append(clyjdmCp);
        sb.append(", clyjdm=").append(clyjdm);
        sb.append(", clyjsm=").append(clyjsm);
        sb.append(", gxFlag=").append(gxFlag);
        sb.append(", note=").append(note);
        sb.append(", flag=").append(flag);
        sb.append(", shqNo=").append(shqNo);
        sb.append(", ydcode=").append(ydcode);
        sb.append(", errLev=").append(errLev);
        sb.append(", errMsg=").append(errMsg);
        sb.append(", detailMsg=").append(detailMsg);
        sb.append(", uuid=").append(uuid);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}