package com.tl.web.bjts.shzs.model.vo.dzhc;

/**
 * @描述: 审核助手:校验日常审单核查任务状态返回
 * @作者: likun
 * @时间: 2022/4/22 15:59
 */
public class ShzsInspectStateCheckVO {
    // 日常审单核查业务序号
    private Long id;
    // 报关单号(18位)
    private String entryId;
    // 核查状态
    private String status;
    // 核查状态(中文)
    private String statusName;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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
}
