package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_DIC_SWJG")
public class YjDicSwjgModel implements Serializable {
    @Id
    @Column(name = "SWJGDM")
    private String swjgdm;

    @Id
    @Column(name = "YJCODE")
    private String yjcode;

    @Column(name = "QYFLAG")
    private String qyflag;

    private static final long serialVersionUID = 1L;

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

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", yjcode=").append(yjcode);
        sb.append(", qyflag=").append(qyflag);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}