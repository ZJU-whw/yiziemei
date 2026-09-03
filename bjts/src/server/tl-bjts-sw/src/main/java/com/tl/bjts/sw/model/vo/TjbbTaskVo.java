package com.tl.bjts.sw.model.vo;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.Date;

/**
 * @Author：Mamf
 * @Date: 2019/9/29.
 * @Description:
 */
public class TjbbTaskVo {

    private String bbdldm;

    private String bbdlmc;

    private String swjgdm;

    private String swjgmc;

    private String ny;

    private String status;

    private String statusDm;

    private String sjswjg;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date cjtime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date zbtime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date sbtime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date chtime;

    private String type;

    public String getStatusDm() {
        return statusDm;
    }

    public void setStatusDm(String statusDm) {
        this.statusDm = statusDm;
    }

    public String getSwjgmc() {
        return swjgmc;
    }

    public void setSwjgmc(String swjgmc) {
        this.swjgmc = swjgmc;
    }

    public String getBbdlmc() {
        return bbdlmc;
    }

    public void setBbdlmc(String bbdlmc) {
        this.bbdlmc = bbdlmc;
    }

    public String getBbdldm() {
        return bbdldm;
    }

    public void setBbdldm(String bbdldm) {
        this.bbdldm = bbdldm;
    }

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getNy() {
        return ny;
    }

    public void setNy(String ny) {
        this.ny = ny;
    }

    public String getStatus() {
        switch (status){
            case "00":
                return "创建";
            case "10":
                return "制表";
            case "20":
                return "上报";
            default:
                return status;
        }

    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSjswjg() {
        return sjswjg;
    }

    public void setSjswjg(String sjswjg) {
        this.sjswjg = sjswjg;
    }

    public Date getCjtime() {
        return cjtime;
    }

    public void setCjtime(Date cjtime) {
        this.cjtime = cjtime;
    }

    public Date getZbtime() {
        return zbtime;
    }

    public void setZbtime(Date zbtime) {
        this.zbtime = zbtime;
    }

    public Date getSbtime() {
        return sbtime;
    }

    public void setSbtime(Date sbtime) {
        this.sbtime = sbtime;
    }

    public Date getChtime() {
        return chtime;
    }

    public void setChtime(Date chtime) {
        this.chtime = chtime;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
