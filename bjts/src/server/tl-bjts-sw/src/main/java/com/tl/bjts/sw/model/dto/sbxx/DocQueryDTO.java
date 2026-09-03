package com.tl.bjts.sw.model.dto.sbxx;

import com.tl.common.ext.annotation.NotNull;
import com.tl.common.ext.model.BaseListDTO;

/**
 * @描述: 附件查询请求dto
 * @作者: likun
 * @时间: 2022/9/6 15:26
 */
public class DocQueryDTO extends BaseListDTO {
    /**
     *  申报id
     */
    @NotNull(msg = "请求参数错误【申报id不能为空】")
    private Long sbid;

    /**
     *  纳税人电子档案号
     */
    private Long nsrdzdah;


    private String nsrsbh;

    public String getNsrsbh() {
        return this.nsrsbh;

    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    /**
     *  局端bjts用户前缀
     */
    private String dbUserBjts;

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public Long getNsrdzdah() {
        return nsrdzdah;
    }

    public void setNsrdzdah(Long nsrdzdah) {
        this.nsrdzdah = nsrdzdah;
    }

    public String getDbUserBjts() {
        return dbUserBjts;
    }

    public void setDbUserBjts(String dbUserBjts) {
        this.dbUserBjts = dbUserBjts;
    }

    @Override
    public String toString() {
        return "DocQueryDTO{" +
                "sbid=" + sbid +
                ", nsrdzdah=" + nsrdzdah +
                '}';
    }
}
