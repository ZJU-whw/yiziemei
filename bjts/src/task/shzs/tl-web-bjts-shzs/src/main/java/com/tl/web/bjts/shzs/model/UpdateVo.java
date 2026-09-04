package com.tl.web.bjts.shzs.model;

/**
 * 说明：模版数据
 * 作者：王兆阳
 * 日期：2017-06-19
 **/

public class UpdateVo {


    private String md5;
    private Long fileSize;
    private String fileName;
    private String fileType;
    private String url;


    public String getMd5() {
        return md5;
    }

    public void setMd5(String md5) {
        this.md5 = md5;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
