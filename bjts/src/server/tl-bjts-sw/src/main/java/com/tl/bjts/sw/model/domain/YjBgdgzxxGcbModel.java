package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "ZJ_BJTS.YJ_BGDGZXX_GCB")
public class YjBgdgzxxGcbModel implements Serializable {
    @Id
    @Column(name = "DJXH")
    private BigDecimal djxh;

    @Id
    @Column(name = "CKBGDH")
    private String ckbgdh;

    @Column(name = "GZXX")
    private String gzxx;

    @Column(name = "CZR_DM")
    private String czrDm;

    @Column(name = "CZRQ")
    private Date czrq;

    private static final long serialVersionUID = 1L;

    /**
     * @return DJXH
     */
    public BigDecimal getDjxh() {
        return djxh;
    }

    /**
     * @param djxh
     */
    public void setDjxh(BigDecimal djxh) {
        this.djxh = djxh;
    }

    /**
     * @return CKBGDH
     */
    public String getCkbgdh() {
        return ckbgdh;
    }

    /**
     * @param ckbgdh
     */
    public void setCkbgdh(String ckbgdh) {
        this.ckbgdh = ckbgdh == null ? null : ckbgdh.trim();
    }

    /**
     * @return GZXX
     */
    public String getGzxx() {
        return gzxx;
    }

    /**
     * @param gzxx
     */
    public void setGzxx(String gzxx) {
        this.gzxx = gzxx == null ? null : gzxx.trim();
    }

    /**
     * @return CZR_DM
     */
    public String getCzrDm() {
        return czrDm;
    }

    /**
     * @param czrDm
     */
    public void setCzrDm(String czrDm) {
        this.czrDm = czrDm == null ? null : czrDm.trim();
    }

    /**
     * @return CZRQ
     */
    public Date getCzrq() {
        return czrq;
    }

    /**
     * @param czrq
     */
    public void setCzrq(Date czrq) {
        this.czrq = czrq;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", djxh=").append(djxh);
        sb.append(", ckbgdh=").append(ckbgdh);
        sb.append(", gzxx=").append(gzxx);
        sb.append(", czrDm=").append(czrDm);
        sb.append(", czrq=").append(czrq);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}