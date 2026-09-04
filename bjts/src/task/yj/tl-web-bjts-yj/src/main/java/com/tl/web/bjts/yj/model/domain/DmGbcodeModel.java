package com.tl.web.bjts.yj.model.domain;

/**
 * @description 国别代码地区表
 * @author: Mamf
 * @date: 2026/5/9 15:42
 */
public class DmGbcodeModel {

    /**
     * 国标代码
     */
    private String gbCode;

    /**
     * 中文名称
     */
    private String gbName;

    /**
     * 英文名称
     */
    private String gbEname;

    /**
     * 区域代码
     */
    private String qycode;

    /**
     * 区域名称
     */
    private String qyname;

    /**
     * 区域备注
     */
    private String qybz;

    public String getGbCode() {
        return this.gbCode;

    }

    public void setGbCode(String gbCode) {
        this.gbCode = gbCode;
    }

    public String getGbName() {
        return this.gbName;

    }

    public void setGbName(String gbName) {
        this.gbName = gbName;
    }

    public String getGbEname() {
        return this.gbEname;

    }

    public void setGbEname(String gbEname) {
        this.gbEname = gbEname;
    }

    public String getQycode() {
        return this.qycode;

    }

    public void setQycode(String qycode) {
        this.qycode = qycode;
    }

    public String getQyname() {
        return this.qyname;

    }

    public void setQyname(String qyname) {
        this.qyname = qyname;
    }

    public String getQybz() {
        return this.qybz;

    }

    public void setQybz(String qybz) {
        this.qybz = qybz;
    }
}
