package com.tl.web.bjts.shzs.model.vo.sbfile;

/**
 * @描述: 审核助手的申报报文vo
 * @作者: likun
 * @时间: 2020/9/21 14:34
 */
public class ShzsSbbwVO {
    private Long sbid; //申报id
    private String sbbw; //申报报文

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public String getSbbw() {
        return sbbw;
    }

    public void setSbbw(String sbbw) {
        this.sbbw = sbbw;
    }
}
