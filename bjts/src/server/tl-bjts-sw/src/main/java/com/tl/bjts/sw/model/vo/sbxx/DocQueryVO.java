package com.tl.bjts.sw.model.vo.sbxx;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.Date;

/**
 * @描述: 附件查询返回vo
 * @作者: likun
 * @时间: 2022/9/6 15:28
 */
public class DocQueryVO {
    private Long id; //文件id（前端隐藏）
    private Long nsrdzdah; // 纳税人电子档案号
    private String title; //文件标题
    private Integer filesize; //文件大小(b)
    private String fmcode; //文件格式
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date yxscrq; // 影像上传时间
    private String note; //备注

    private String nsrsbh;

    public String getNsrsbh() {
        return this.nsrsbh;

    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getFilesize() {
        return filesize;
    }

    public void setFilesize(Integer filesize) {
        this.filesize = filesize;
    }

    public String getFmcode() {
        return fmcode;
    }

    public void setFmcode(String fmcode) {
        this.fmcode = fmcode;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Long getNsrdzdah() {
        return nsrdzdah;
    }

    public void setNsrdzdah(Long nsrdzdah) {
        this.nsrdzdah = nsrdzdah;
    }

    public Date getYxscrq() {
        return yxscrq;
    }

    public void setYxscrq(Date yxscrq) {
        this.yxscrq = yxscrq;
    }

    @Override
    public String toString() {
        return "DocQueryVO{" +
                "id=" + id +
                ", nsrdzdah=" + nsrdzdah +
                ", title='" + title + '\'' +
                ", filesize=" + filesize +
                ", fmcode='" + fmcode + '\'' +
                ", note='" + note + '\'' +
                '}';
    }
}
