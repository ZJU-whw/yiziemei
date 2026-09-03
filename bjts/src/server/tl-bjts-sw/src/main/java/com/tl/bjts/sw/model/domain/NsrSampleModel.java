package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_TSSH.JCFX_NSR_SAMPLE")
public class NsrSampleModel implements Serializable {
    @Id
    @Column(name = "ZID")
    private Long zid;

    @Column(name = "SNAME")
    private String sname;

    @Column(name = "SWJGDM")
    private String swjgdm;

    @Column(name = "SYFW_SWJG")
    private String syfwSwjg;

    @Column(name = "QYBZ")
    private String qybz;

    @Column(name = "XGR")
    private String xgr;

    @Column(name = "XGSJ")
    private Date xgsj;

    private static final long serialVersionUID = 1L;

    /**
     * @return ZID
     */
    public Long getZid() {
        return zid;
    }

    /**
     * @param zid
     */
    public void setZid(Long zid) {
        this.zid = zid;
    }

    /**
     * @return SNAME
     */
    public String getSname() {
        return sname;
    }

    /**
     * @param sname
     */
    public void setSname(String sname) {
        this.sname = sname == null ? null : sname.trim();
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
     * @return SYFW_SWJG
     */
    public String getSyfwSwjg() {
        return syfwSwjg;
    }

    /**
     * @param syfwSwjg
     */
    public void setSyfwSwjg(String syfwSwjg) {
        this.syfwSwjg = syfwSwjg == null ? null : syfwSwjg.trim();
    }

    /**
     * @return QYBZ
     */
    public String getQybz() {
        return qybz;
    }

    /**
     * @param qybz
     */
    public void setQybz(String qybz) {
        this.qybz = qybz == null ? null : qybz.trim();
    }

    /**
     * @return XGR
     */
    public String getXgr() {
        return xgr;
    }

    /**
     * @param xgr
     */
    public void setXgr(String xgr) {
        this.xgr = xgr == null ? null : xgr.trim();
    }

    /**
     * @return XGSJ
     */
    public Date getXgsj() {
        return xgsj;
    }

    /**
     * @param xgsj
     */
    public void setXgsj(Date xgsj) {
        this.xgsj = xgsj;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", zid=").append(zid);
        sb.append(", sname=").append(sname);
        sb.append(", swjgdm=").append(swjgdm);
        sb.append(", syfwSwjg=").append(syfwSwjg);
        sb.append(", qybz=").append(qybz);
        sb.append(", xgr=").append(xgr);
        sb.append(", xgsj=").append(xgsj);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}