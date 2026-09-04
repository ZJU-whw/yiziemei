package com.tl.web.bjts.shzs.model;

import java.io.File;

/**
 * 申报文件
 * Created by likun on 2017/6/21.
 */
public class SbfileVo {
    private Long sbid;
    private Long fileSize;
    private String fileUrl;
    private String note;
    private File sbFile;
    private String fileName;

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
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

    public File getSbFile() {
        return sbFile;
    }

    public void setSbFile(File sbFile) {
        this.sbFile = sbFile;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
}
