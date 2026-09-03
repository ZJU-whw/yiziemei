package com.tl.bjts.sw.model.domain;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_TSSH.JCFX_TASK")
public class JcfxTaskModel implements Serializable {
    @Id
    @Column(name = "ID")
    private String id;

    @Column(name = "CZRY_DM")
    private String czryDm;

    @Column(name = "REQ_PARAM")
    private String reqParam;

    @Column(name = "TASK_FLAG")
    private String taskFlag;

    @Column(name = "TQBZ")
    private String tqbz;

    @Column(name = "TQSJ")
    private Date tqsj;

    @Column(name = "WCSJ")
    private Date wcsj;

    @Column(name = "TQCS")
    private BigDecimal tqcs;

    @Column(name = "CRTIME")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date crtime;

    @Column(name = "RESP_DATA")
    private byte[] respData;

    @Column(name = "TITLE")
    private String title;

    @Column(name = "SQLTEXT")
    private String sqltext;

    @Column(name = "SWJGDM")
    private String swjgdm;

    @Column(name = "BBTYPE")
    private String bbtype;

    private static final long serialVersionUID = 1L;

    public String getBbtype() {
        return this.bbtype;

    }

    public void setBbtype(String bbtype) {
        this.bbtype = bbtype;
    }

    public String getSwjgdm() {
        return this.swjgdm;

    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getTitle() {
        return this.title;

    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSqltext() {
        return this.sqltext;

    }

    public void setSqltext(String sqltext) {
        this.sqltext = sqltext;
    }

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
     * @return CZRY_DM
     */
    public String getCzryDm() {
        return czryDm;
    }

    /**
     * @param czryDm
     */
    public void setCzryDm(String czryDm) {
        this.czryDm = czryDm == null ? null : czryDm.trim();
    }

    /**
     * @return REQ_PARAM
     */
    public String getReqParam() {
        return reqParam;
    }

    /**
     * @param reqParam
     */
    public void setReqParam(String reqParam) {
        this.reqParam = reqParam == null ? null : reqParam.trim();
    }

    /**
     * @return TASK_FLAG
     */
    public String getTaskFlag() {
        return taskFlag;
    }

    /**
     * @param taskFlag
     */
    public void setTaskFlag(String taskFlag) {
        this.taskFlag = taskFlag == null ? null : taskFlag.trim();
    }

    /**
     * @return TQBZ
     */
    public String getTqbz() {
        return tqbz;
    }

    /**
     * @param tqbz
     */
    public void setTqbz(String tqbz) {
        this.tqbz = tqbz == null ? null : tqbz.trim();
    }

    /**
     * @return TQSJ
     */
    public Date getTqsj() {
        return tqsj;
    }

    /**
     * @param tqsj
     */
    public void setTqsj(Date tqsj) {
        this.tqsj = tqsj;
    }

    /**
     * @return WCSJ
     */
    public Date getWcsj() {
        return wcsj;
    }

    /**
     * @param wcsj
     */
    public void setWcsj(Date wcsj) {
        this.wcsj = wcsj;
    }

    /**
     * @return TQCS
     */
    public BigDecimal getTqcs() {
        return tqcs;
    }

    /**
     * @param tqcs
     */
    public void setTqcs(BigDecimal tqcs) {
        this.tqcs = tqcs;
    }

    /**
     * @return CRTIME
     */
    public Date getCrtime() {
        return crtime;
    }

    /**
     * @param crtime
     */
    public void setCrtime(Date crtime) {
        this.crtime = crtime;
    }

    /**
     * @return RESP_DATA
     */
    public byte[] getRespData() {
        return respData;
    }

    /**
     * @param respData
     */
    public void setRespData(byte[] respData) {
        this.respData = respData;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", czryDm=").append(czryDm);
        sb.append(", reqParam=").append(reqParam);
        sb.append(", taskFlag=").append(taskFlag);
        sb.append(", tqbz=").append(tqbz);
        sb.append(", tqsj=").append(tqsj);
        sb.append(", wcsj=").append(wcsj);
        sb.append(", tqcs=").append(tqcs);
        sb.append(", crtime=").append(crtime);
        sb.append(", respData=").append(respData);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}