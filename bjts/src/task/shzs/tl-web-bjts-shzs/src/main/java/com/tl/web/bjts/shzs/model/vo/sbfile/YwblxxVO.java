package com.tl.web.bjts.shzs.model.vo.sbfile;

/**
 * @描述: 业务办理信息
 * @作者: likun
 * @时间: 2021/11/26 14:17
 */
public class YwblxxVO {
    private String djxh; // 登记序号
    private String lcswsxDm; // 流程事项
    private String sssq; // 所属时期
    private String sbpc; // 申报批次
    private String sbywbDm; // 申报业务表代码
    private Integer sbpcI; //申报批次
    private String nsrsbh;

    public String getNsrsbh() {
        return this.nsrsbh;

    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getDjxh() {
        return djxh;
    }

    public void setDjxh(String djxh) {
        this.djxh = djxh;
    }

    public String getLcswsxDm() {
        return lcswsxDm;
    }

    public void setLcswsxDm(String lcswsxDm) {
        this.lcswsxDm = lcswsxDm;
    }

    public String getSssq() {
        return sssq;
    }

    public void setSssq(String sssq) {
        this.sssq = sssq;
    }

    public String getSbpc() {
        return sbpc==null?"":sbpc;
    }

    public void setSbpc(String sbpc) {
        this.sbpc = sbpc;
    }

    public String getSbywbDm() {
        return sbywbDm;
    }

    public void setSbywbDm(String sbywbDm) {
        this.sbywbDm = sbywbDm;
    }

    public Integer getSbpcI() {
        return sbpcI;
    }

    public void setSbpcI(Integer sbpcI) {
        this.sbpcI = sbpcI;
    }

    @Override
    public String toString() {
        return "YwblxxVO{" +
                "djxh='" + djxh + '\'' +
                ", lcswsxDm='" + lcswsxDm + '\'' +
                ", sssq='" + sssq + '\'' +
                ", sbpc='" + sbpc + '\'' +
                ", sbywbDm='" + sbywbDm + '\'' +
                ", sbpcI=" + sbpcI +
                '}';
    }
}
