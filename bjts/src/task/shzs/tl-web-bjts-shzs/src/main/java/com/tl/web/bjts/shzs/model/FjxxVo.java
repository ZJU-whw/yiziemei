package com.tl.web.bjts.shzs.model;

/**
 * 附件
 * Created by likun on 2017/6/20.
 */
public class FjxxVo {
    private Long id;
    private String clbz;
    private String fmCode;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getClbz() {
        return clbz;
    }

    public void setClbz(String clbz) {
        this.clbz = clbz;
    }

    public String getFmCode() {
        return fmCode;
    }

    public void setFmCode(String fmCode) {
        this.fmCode = fmCode;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getFileSize() {
        return fileSize;
    }

    public void setFileSize(Integer fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    private String title;
    private Integer fileSize;
    private String fileUrl;
    private String note;
}
