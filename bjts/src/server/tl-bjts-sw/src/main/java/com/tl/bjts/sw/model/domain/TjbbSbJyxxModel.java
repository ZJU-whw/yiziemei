package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "TL_ADMIN.TJBB_SB_JYXX")
public class TjbbSbJyxxModel implements Serializable {
    @Id
    @Column(name = "ID")
    private String id;

    @Column(name = "SWJGDM")
    private String swjgdm;

    @Column(name = "BBDM")
    private String bbdm;

    @Column(name = "MSG")
    private String msg;

    @Column(name = "MSG_TYPE")
    private String msgType;

    @Column(name = "BBDLDM")
    private String bbdldm;

    @Column(name = "MSG_LEVEL")
    private String msgLevel;

    private static final long serialVersionUID = 1L;

    /**
     * @return ID
     */
    public String getId() {
        return id;
    }

    /**
     * @param id
     */
    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    /**
     * @return SWJGDM
     */
    public String getSwjgdm() {
        return swjgdm;
    }

    /**
     * @param swjgdm
     */
    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm == null ? null : swjgdm.trim();
    }

    /**
     * @return BBDM
     */
    public String getBbdm() {
        return bbdm;
    }

    /**
     * @param bbdm
     */
    public void setBbdm(String bbdm) {
        this.bbdm = bbdm == null ? null : bbdm.trim();
    }

    /**
     * @return MSG
     */
    public String getMsg() {
        return msg;
    }

    /**
     * @param msg
     */
    public void setMsg(String msg) {
        this.msg = msg == null ? null : msg.trim();
    }

    /**
     * @return MSG_TYPE
     */
    public String getMsgType() {
        return msgType;
    }

    /**
     * @param msgType
     */
    public void setMsgType(String msgType) {
        this.msgType = msgType == null ? null : msgType.trim();
    }

    /**
     * @return BBDLDM
     */
    public String getBbdldm() {
        return bbdldm;
    }

    /**
     * @param bbdldm
     */
    public void setBbdldm(String bbdldm) {
        this.bbdldm = bbdldm == null ? null : bbdldm.trim();
    }

    /**
     * @return MSG_LEVEL
     */
    public String getMsgLevel() {
        return msgLevel;
    }

    /**
     * @param msgLevel
     */
    public void setMsgLevel(String msgLevel) {
        this.msgLevel = msgLevel == null ? null : msgLevel.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", bbdm=").append(bbdm);
        sb.append(", msg=").append(msg);
        sb.append(", msgType=").append(msgType);
        sb.append(", bbdldm=").append(bbdldm);
        sb.append(", msgLevel=").append(msgLevel);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}