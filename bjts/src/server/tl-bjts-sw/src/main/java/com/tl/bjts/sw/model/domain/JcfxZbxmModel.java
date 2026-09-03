package com.tl.bjts.sw.model.domain;

import java.io.Serializable;
import javax.persistence.*;

@Table(name = "TL_TSSH.JCFX_CS_ZBXM")
public class JcfxZbxmModel implements Serializable {
    @Id
    @Column(name = "ZBXMBM")
    private String zbxmbm;

    @Column(name = "ZBDLBM")
    private String zbdlbm;

    @Column(name = "ZBXMMC")
    private String zbxmmc;

    @Column(name = "FIELD")
    private String field;

    @Column(name = "DATATABLE")
    private String datatable;

    @Column(name = "DICTTABLE")
    private String dicttable;

    @Column(name = "ISVALID")
    private String isvalid;

    @Column(name = "FORMAT")
    private String format;

    @Column(name = "ISSHOW")
    private String isshow;

    @Column(name = "PXNO")
    private String pxno;

    private static final long serialVersionUID = 1L;


    public String getIsshow() {
        return this.isshow;

    }

    public void setIsshow(String isshow) {
        this.isshow = isshow;
    }

    public String getPxno() {
        return this.pxno;

    }

    public void setPxno(String pxno) {
        this.pxno = pxno;
    }

    public String getFormat() {
        return this.format;

    }

    public void setFormat(String format) {
        this.format = format;
    }

    public String getIsvalid() {
        return this.isvalid;

    }

    public void setIsvalid(String isvalid) {
        this.isvalid = isvalid;
    }

    /**
     * @return ZBXMBM
     */
    public String getZbxmbm() {
        return zbxmbm;
    }

    /**
     * @param zbxmbm
     */
    public void setZbxmbm(String zbxmbm) {
        this.zbxmbm = zbxmbm == null ? null : zbxmbm.trim();
    }

    /**
     * @return ZBDLBM
     */
    public String getZbdlbm() {
        return zbdlbm;
    }

    /**
     * @param zbdlbm
     */
    public void setZbdlbm(String zbdlbm) {
        this.zbdlbm = zbdlbm == null ? null : zbdlbm.trim();
    }

    /**
     * @return ZBXMMC
     */
    public String getZbxmmc() {
        return zbxmmc;
    }

    /**
     * @param zbxmmc
     */
    public void setZbxmmc(String zbxmmc) {
        this.zbxmmc = zbxmmc == null ? null : zbxmmc.trim();
    }

    /**
     * @return FIELD
     */
    public String getField() {
        return field;
    }

    /**
     * @param field
     */
    public void setField(String field) {
        this.field = field == null ? null : field.trim();
    }

    /**
     * @return DATATABLE
     */
    public String getDatatable() {
        return datatable;
    }

    /**
     * @param datatable
     */
    public void setDatatable(String datatable) {
        this.datatable = datatable == null ? null : datatable.trim();
    }

    /**
     * @return DICTTABLE
     */
    public String getDicttable() {
        return dicttable;
    }

    /**
     * @param dicttable
     */
    public void setDicttable(String dicttable) {
        this.dicttable = dicttable == null ? null : dicttable.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", zbxmbm=").append(zbxmbm);
        sb.append(", zbdlbm=").append(zbdlbm);
        sb.append(", zbxmmc=").append(zbxmmc);
        sb.append(", field=").append(field);
        sb.append(", datatable=").append(datatable);
        sb.append(", dicttable=").append(dicttable);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}