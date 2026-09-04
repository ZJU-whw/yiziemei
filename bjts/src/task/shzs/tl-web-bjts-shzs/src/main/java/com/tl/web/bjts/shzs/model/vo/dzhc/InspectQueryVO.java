package com.tl.web.bjts.shzs.model.vo.dzhc;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.Date;

/**
 * @描述: 日常审单核查查询返回
 * @作者: likun
 * @时间: 2022/4/24 17:05
 */
public class InspectQueryVO {
    private Long id;
    private String sbnypc;
    private String entryId;
    private String status;
    private String statusName;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date releaseTime;
    private String yjbz; // 预警标志
    private Integer backCount; // 退回次数

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSbnypc() {
        return sbnypc;
    }

    public void setSbnypc(String sbnypc) {
        this.sbnypc = sbnypc;
    }

    public String getEntryId() {
        return entryId;
    }

    public void setEntryId(String entryId) {
        this.entryId = entryId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    public Date getReleaseTime() {
        return releaseTime;
    }

    public void setReleaseTime(Date releaseTime) {
        this.releaseTime = releaseTime;
    }

    public String getYjbz() {
        return yjbz;
    }

    public void setYjbz(String yjbz) {
        this.yjbz = yjbz;
    }

    public Integer getBackCount() {
        return backCount;
    }

    public void setBackCount(Integer backCount) {
        this.backCount = backCount;
    }
}
