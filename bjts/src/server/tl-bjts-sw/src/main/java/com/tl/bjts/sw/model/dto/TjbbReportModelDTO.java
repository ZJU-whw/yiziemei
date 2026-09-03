package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.annotation.NotEmpty;

import java.io.Serializable;
import java.math.BigDecimal;

public class TjbbReportModelDTO implements Serializable {

    private String isAdd;

    @NotEmpty(msg = "报表代码不能为空")
    private String bbdm;

    @NotEmpty(msg = "报表大类代码不能为空")
    private String bbdldm;

    @NotEmpty(msg = "报表名称不能为空")
    private String bbmc;

    private String bbjc;

    private BigDecimal showorder;

    @NotEmpty(msg = "报表类型不能为空")
    private String bbtype;

    private BigDecimal excelcol;

    private BigDecimal excelrow;

    private String hztype;

    private String proc;

    private String prochz;

    private static final long serialVersionUID = 1L;

    public String getProchz() {
        return prochz;
    }

    public void setProchz(String prochz) {
        this.prochz = prochz;
    }

    public String getProc() {
        return proc;
    }

    public void setProc(String proc) {
        this.proc = proc;
    }

    public String getHztype() {
        return hztype;
    }

    public void setHztype(String hztype) {
        this.hztype = hztype;
    }

    public String getIsAdd() {
        return isAdd;
    }

    public void setIsAdd(String isAdd) {
        this.isAdd = isAdd;
    }

    public BigDecimal getExcelcol() {
        return excelcol;
    }

    public void setExcelcol(BigDecimal excelcol) {
        this.excelcol = excelcol;
    }

    public BigDecimal getExcelrow() {
        return excelrow;
    }

    public void setExcelrow(BigDecimal excelrow) {
        this.excelrow = excelrow;
    }

    /**
     * @return BBDM
     */
    public String getBbdm() {
        return bbdm;
    }

    /**
     * @param bbdm
     */
    public void setBbdm(String bbdm) {
        this.bbdm = bbdm == null ? null : bbdm.trim();
    }

    /**
     * @return BBDLDM
     */
    public String getBbdldm() {
        return bbdldm;
    }

    /**
     * @param bbdldm
     */
    public void setBbdldm(String bbdldm) {
        this.bbdldm = bbdldm == null ? null : bbdldm.trim();
    }

    /**
     * @return BBMC
     */
    public String getBbmc() {
        return bbmc;
    }

    /**
     * @param bbmc
     */
    public void setBbmc(String bbmc) {
        this.bbmc = bbmc == null ? null : bbmc.trim();
    }

    /**
     * @return BBJC
     */
    public String getBbjc() {
        return bbjc;
    }

    /**
     * @param bbjc
     */
    public void setBbjc(String bbjc) {
        this.bbjc = bbjc == null ? null : bbjc.trim();
    }


    /**
     * @return SHOWORDER
     */
    public BigDecimal getShoworder() {
        return showorder;
    }

    /**
     * @param showorder
     */
    public void setShoworder(BigDecimal showorder) {
        this.showorder = showorder;
    }

    /**
     * @return BBTYPE
     */
    public String getBbtype() {
        return bbtype;
    }

    /**
     * @param bbtype
     */
    public void setBbtype(String bbtype) {
        this.bbtype = bbtype == null ? null : bbtype.trim();
    }



    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", bbdm=").append(bbdm);
        sb.append(", bbdldm=").append(bbdldm);
        sb.append(", bbmc=").append(bbmc);
        sb.append(", bbjc=").append(bbjc);
        sb.append(", showorder=").append(showorder);
        sb.append(", bbtype=").append(bbtype);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}