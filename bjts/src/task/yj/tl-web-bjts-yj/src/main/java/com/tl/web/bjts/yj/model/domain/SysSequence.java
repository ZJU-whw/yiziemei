package com.tl.web.bjts.yj.model.domain;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;

@Table(name = "SYS_SEQUENCE")
public class SysSequence implements Serializable {
    @Id
    @Column(name = "TBLNAME")
    private String tblname;

    @Column(name = "CURVALUE")
    private Long curvalue;

    private static final long serialVersionUID = 1L;

    /**
     * @return TBLNAME
     */
    public String getTblname() {
        return tblname;
    }

    /**
     * @param tblname
     */
    public void setTblname(String tblname) {
        this.tblname = tblname == null ? null : tblname.trim();
    }

    /**
     * @return CURVALUE
     */
    public Long getCurvalue() {
        return curvalue;
    }

    /**
     * @param curvalue
     */
    public void setCurvalue(Long curvalue) {
        this.curvalue = curvalue;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", tblname=").append(tblname);
        sb.append(", curvalue=").append(curvalue);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}