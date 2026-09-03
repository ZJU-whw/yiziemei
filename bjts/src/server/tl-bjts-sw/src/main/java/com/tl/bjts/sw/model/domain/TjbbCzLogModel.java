package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TJBB_CZ_LOG")
public class TjbbCzLogModel implements Serializable {
    @Id
    @Column(name = "ID")
    private String id;

    @Column(name = "SWJGDM")
    private String swjgdm;

    @Column(name = "CZRY")
    private String czry;

    @Column(name = "CZTIME")
    private Date cztime;

    @Column(name = "CZCODE")
    private String czcode;

    @Column(name = "CZTYPE")
    private String cztype;

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
     * @return CZRY
     */
    public String getCzry() {
        return czry;
    }

    /**
     * @param czry
     */
    public void setCzry(String czry) {
        this.czry = czry == null ? null : czry.trim();
    }

    /**
     * @return CZTIME
     */
    public Date getCztime() {
        return cztime;
    }

    /**
     * @param cztime
     */
    public void setCztime(Date cztime) {
        this.cztime = cztime;
    }

    /**
     * @return CZCODE
     */
    public String getCzcode() {
        return czcode;
    }

    /**
     * @param czcode
     */
    public void setCzcode(String czcode) {
        this.czcode = czcode == null ? null : czcode.trim();
    }

    /**
     * @return CZTYPE
     */
    public String getCztype() {
        return cztype;
    }

    /**
     * @param cztype
     */
    public void setCztype(String cztype) {
        this.cztype = cztype == null ? null : cztype.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", czry=").append(czry);
        sb.append(", cztime=").append(cztime);
        sb.append(", czcode=").append(czcode);
        sb.append(", cztype=").append(cztype);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}