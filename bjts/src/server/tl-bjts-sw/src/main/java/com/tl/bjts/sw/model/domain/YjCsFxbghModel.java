package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_CS_FXBGH")
public class YjCsFxbghModel implements Serializable {
    @Id
    @Column(name = "ID")
    private Long id;

    @Column(name = "BGHMC")
    private String bghmc;

    @Column(name = "BGHDQ")
    private String bghdq;

    @Column(name = "DRNY")
    private String drny;

    @Column(name = "YXBZ")
    private String yxbz;

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
     * @return BGHMC
     */
    public String getBghmc() {
        return bghmc;
    }

    /**
     * @param bghmc
     */
    public void setBghmc(String bghmc) {
        this.bghmc = bghmc == null ? null : bghmc.trim();
    }

    /**
     * @return BGHDQ
     */
    public String getBghdq() {
        return bghdq;
    }

    /**
     * @param bghdq
     */
    public void setBghdq(String bghdq) {
        this.bghdq = bghdq == null ? null : bghdq.trim();
    }

    /**
     * @return DRNY
     */
    public String getDrny() {
        return drny;
    }

    /**
     * @param drny
     */
    public void setDrny(String drny) {
        this.drny = drny == null ? null : drny.trim();
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

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", bghmc=").append(bghmc);
        sb.append(", bghdq=").append(bghdq);
        sb.append(", drny=").append(drny);
        sb.append(", yxbz=").append(yxbz);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}