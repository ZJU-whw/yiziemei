package com.tl.bjts.sw.model.yj;

/**
 * @description 国别代码表实体（客户区域对照表）
 * @author: Mamf
 * @date: 2026/1/22 10:44
 */
public class DmGbcode {

    /** 国别代码 */
    private String gbCode;
    /** 国别名称 */
    private String gbName;
    /** 国别英文名称 */
    private String gbEname;
    /** 对应（国际）区域代码 */
    private String qyCode;
    /** 对应（国际）区域名称 */
    private String qyName;
    /** 启用标志（1=启用，0=禁用） */
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

    public String getQyCode() {
        return this.qyCode;

    }

    public void setQyCode(String qyCode) {
        this.qyCode = qyCode;
    }

    public String getQyName() {
        return this.qyName;

    }

    public void setQyName(String qyName) {
        this.qyName = qyName;
    }

    public String getQybz() {
        return this.qybz;

    }

    public void setQybz(String qybz) {
        this.qybz = qybz;
    }
}
