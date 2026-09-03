package com.tl.bjts.sw.model.dto.sbxx;

import com.tl.common.ext.model.BaseListDTO;

import java.util.Date;

/**
 * @描述: 申报信息查询dto
 * @作者: likun
 * @时间: 2022/9/6 11:39
 */
public class SbxxQueryDTO extends BaseListDTO {
    /**
     *  税务机关代码
     */
    private String swjgdm;

    /**
     *  企业标识
     */
    private String qybs;

    /**
     *  企业类型
     */
    private String qylx;


    /**
     * 所属期起
     */
    private String sssqStart;

    /**
     * 所属期止
     */
    private String sssqEnd;

    /**
     *  局端bjts用户前缀
     */
    private String dbUserBjts;

    /**
     *  申报业务种类代码
     */
    private String sbywb;

    /**
     *  上传日期起
     */
    private Date yxscrqq;

    /**
     *  上传日期止
     */
    private Date yxscrqz;

    /**
     *  附件状态  1：有附件 0：无附件
     */
    private String fjzt;


    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getQybs() {
        return qybs;
    }

    public void setQybs(String qybs) {
        this.qybs = qybs;
    }

    public String getQylx() {
        return qylx;
    }

    public void setQylx(String qylx) {
        this.qylx = qylx;
    }


    public String getSssqStart() {
        return sssqStart;
    }

    public void setSssqStart(String sssqStart) {
        this.sssqStart = sssqStart;
    }

    public String getSssqEnd() {
        return sssqEnd;
    }

    public void setSssqEnd(String sssqEnd) {
        this.sssqEnd = sssqEnd;
    }

    public String getDbUserBjts() {
        return dbUserBjts;
    }

    public void setDbUserBjts(String dbUserBjts) {
        this.dbUserBjts = dbUserBjts;
    }

    public String getSbywb() {
        return sbywb;
    }

    public void setSbywb(String sbywb) {
        this.sbywb = sbywb;
    }

    public Date getYxscrqq() {
        return yxscrqq;
    }

    public void setYxscrqq(Date yxscrqq) {
        this.yxscrqq = yxscrqq;
    }

    public Date getYxscrqz() {
        return yxscrqz;
    }

    public void setYxscrqz(Date yxscrqz) {
        this.yxscrqz = yxscrqz;
    }

    public String getFjzt() {
        return fjzt;
    }

    public void setFjzt(String fjzt) {
        this.fjzt = fjzt;
    }

    @Override
    public String toString() {
        return "SbxxQueryDTO{" +
                "swjgdm='" + swjgdm + '\'' +
                ", qybs='" + qybs + '\'' +
                ", qylx='" + qylx + '\'' +
                ", sssqStart='" + sssqStart + '\'' +
                ", sssqEnd='" + sssqEnd + '\'' +
                ", dbUserBjts='" + dbUserBjts + '\'' +
                ", sbywb='" + sbywb + '\'' +
                ", yxscrqq=" + yxscrqq +
                ", yxscrqz=" + yxscrqz +
                '}';
    }
}
