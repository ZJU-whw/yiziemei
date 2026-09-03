package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "TL_ADMIN.DM_SPML")
public class SpmlModel implements Serializable {
    @Id
    @Column(name = "SPML")
    private String spml;

    @Column(name = "MLMC")
    private String mlmc;

    @Column(name = "MLDM")
    private String mldm;

    private static final long serialVersionUID = 1L;

    /**
     * @return SPML
     */
    public String getSpml() {
        return spml;
    }

    /**
     * @param spml
     */
    public void setSpml(String spml) {
        this.spml = spml == null ? null : spml.trim();
    }

    /**
     * @return MLMC
     */
    public String getMlmc() {
        return mlmc;
    }

    /**
     * @param mlmc
     */
    public void setMlmc(String mlmc) {
        this.mlmc = mlmc == null ? null : mlmc.trim();
    }

    /**
     * @return MLDM
     */
    public String getMldm() {
        return mldm;
    }

    /**
     * @param mldm
     */
    public void setMldm(String mldm) {
        this.mldm = mldm == null ? null : mldm.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", spml=").append(spml);
        sb.append(", mlmc=").append(mlmc);
        sb.append(", mldm=").append(mldm);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}