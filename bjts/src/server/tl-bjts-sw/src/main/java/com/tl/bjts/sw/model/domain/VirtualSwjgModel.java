package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "DM_SWJG_VIRTUAL")
public class VirtualSwjgModel implements Serializable {
    @Id
    @Column(name = "VIR_SWJGDM")
    private String virSwjgdm;

    @Id
    @Column(name = "SWJG_DM")
    private String swjgDm;

    @Column(name = "VIR_NAME")
    private String virName;

    @Column(name = "YXBZ")
    private String yxbz;

    @Column(name = "VIR_FLAG")
    private String virFlag;

    private static final long serialVersionUID = 1L;

    /**
     * @return VIR_SWJGDM
     */
    public String getVirSwjgdm() {
        return virSwjgdm;
    }

    /**
     * @param virSwjgdm
     */
    public void setVirSwjgdm(String virSwjgdm) {
        this.virSwjgdm = virSwjgdm == null ? null : virSwjgdm.trim();
    }

    /**
     * @return SWJG_DM
     */
    public String getSwjgDm() {
        return swjgDm;
    }

    /**
     * @param swjgDm
     */
    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm == null ? null : swjgDm.trim();
    }

    /**
     * @return VIR_NAME
     */
    public String getVirName() {
        return virName;
    }

    /**
     * @param virName
     */
    public void setVirName(String virName) {
        this.virName = virName == null ? null : virName.trim();
    }

    /**
     * @return YXBZ
     */
    public String getYxbz() {
        return yxbz;
    }

    /**
     * @param yxbz
     */
    public void setYxbz(String yxbz) {
        this.yxbz = yxbz == null ? null : yxbz.trim();
    }

    /**
     * @return VIR_FLAG
     */
    public String getVirFlag() {
        return virFlag;
    }

    /**
     * @param virFlag
     */
    public void setVirFlag(String virFlag) {
        this.virFlag = virFlag == null ? null : virFlag.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", virSwjgdm=").append(virSwjgdm);
        sb.append(", swjgDm=").append(swjgDm);
        sb.append(", virName=").append(virName);
        sb.append(", yxbz=").append(yxbz);
        sb.append(", virFlag=").append(virFlag);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}