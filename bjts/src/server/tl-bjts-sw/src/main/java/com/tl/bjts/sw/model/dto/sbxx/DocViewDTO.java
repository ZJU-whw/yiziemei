package com.tl.bjts.sw.model.dto.sbxx;

import com.tl.common.ext.annotation.NotNull;

/**
 * @描述: 查看附件请求dto
 * @作者: likun
 * @时间: 2022/9/6 16:53
 */
public class DocViewDTO {
    /**
     *  纳税人电子档案号
     */
    private Long nsrdzdah;

    /**
     *  文件id
     */
    @NotNull(msg = "请求参数错误【文件id不能为空】")
    private Long fileId;

    private String nsrsbh;

    public String getNsrsbh() {
        return this.nsrsbh;

    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public Long getNsrdzdah() {
        return nsrdzdah;
    }

    public void setNsrdzdah(Long nsrdzdah) {
        this.nsrdzdah = nsrdzdah;
    }

    public Long getFileId() {
        return fileId;
    }

    public void setFileId(Long fileId) {
        this.fileId = fileId;
    }

    @Override
    public String toString() {
        return "DocViewDTO{" +
                "nsrdzdah=" + nsrdzdah +
                ", fileId=" + fileId +
                '}';
    }
}
