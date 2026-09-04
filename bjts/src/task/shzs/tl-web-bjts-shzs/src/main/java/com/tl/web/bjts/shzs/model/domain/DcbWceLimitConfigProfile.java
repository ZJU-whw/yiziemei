package com.tl.web.bjts.shzs.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Table(name = "TL_ADMIN.DCB_WCE_LIMIT_CONFIG")
public class DcbWceLimitConfigProfile implements Serializable {
    @Id
    @Column(name = "SWJG_DM")
    private String swjgDm;

    @Column(name = "WCE_UP")
    private BigDecimal wceUp;

    @Column(name = "WCE_DOWN")
    private BigDecimal wceDown;

    private static final long serialVersionUID = 1L;

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
     * @return WCE_UP
     */
    public BigDecimal getWceUp() {
        return wceUp;
    }

    /**
     * @param wceUp
     */
    public void setWceUp(BigDecimal wceUp) {
        this.wceUp = wceUp;
    }

    /**
     * @return WCE_DOWN
     */
    public BigDecimal getWceDown() {
        return wceDown;
    }

    /**
     * @param wceDown
     */
    public void setWceDown(BigDecimal wceDown) {
        this.wceDown = wceDown;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", swjgDm=").append(swjgDm);
        sb.append(", wceUp=").append(wceUp);
        sb.append(", wceDown=").append(wceDown);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}