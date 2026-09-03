package com.tl.bjts.sw.model.domain.doc;

/**
 * @描述: 附件信息
 * @作者: likun
 * @时间: 2022/9/6 17:01
 */
public class DocFileinfo {
    /**
     *  文件名称
     */
    private String filename;

    /**
     *  文件后缀
     */
    private String fmcode;

    /**
     *  标题
     */
    private String title;

    /**
     *  文件大小（b）
     */

    private Integer filesize;

    /**
     *  相对路径
     */
    private String rootpath;

    /**
     *  文件路径，云存储文件路径
     */
    private String filepath;

    /**
     *  备注
     */
    private String note;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getFilepath() {
        return filepath;
    }

    public void setFilepath(String filepath) {
        this.filepath = filepath;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public String getFmcode() {
        return fmcode;
    }

    public void setFmcode(String fmcode) {
        this.fmcode = fmcode;
    }

    public Integer getFilesize() {
        return filesize;
    }

    public void setFilesize(Integer filesize) {
        this.filesize = filesize;
    }

    public String getRootpath() {
        return rootpath;
    }

    public void setRootpath(String rootpath) {
        this.rootpath = rootpath;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    @Override
    public String toString() {
        return "DocFileinfo{" +
                "filename='" + filename + '\'' +
                ", fmcode='" + fmcode + '\'' +
                ", title='" + title + '\'' +
                ", filesize=" + filesize +
                ", rootpath='" + rootpath + '\'' +
                ", filepath='" + filepath + '\'' +
                ", note='" + note + '\'' +
                '}';
    }
}
