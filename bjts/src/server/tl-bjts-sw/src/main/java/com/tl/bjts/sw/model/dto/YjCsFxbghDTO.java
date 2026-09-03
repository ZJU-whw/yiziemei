package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

/**
 * 风险报关行信息查询DTO
 */
public class YjCsFxbghDTO extends BaseListDTO {

    /** 报关行名称（模糊查询） */
    private String bghmc;

    /** 报关行所在地（精确查询） */
    private String bghdq;

    /** 数据导入月份-起始（包含，格式YYYYMM） */
    private String drnyBegin;

    /** 数据导入月份-截止（包含，格式YYYYMM） */
    private String drnyEnd;


    public String getBghmc() {
        return bghmc;
    }

    public void setBghmc(String bghmc) {
        this.bghmc = bghmc;
    }

    public String getBghdq() {
        return bghdq;
    }

    public void setBghdq(String bghdq) {
        this.bghdq = bghdq;
    }

    public String getDrnyBegin() {
        return drnyBegin;
    }

    public void setDrnyBegin(String drnyBegin) {
        this.drnyBegin = drnyBegin;
    }

    public String getDrnyEnd() {
        return drnyEnd;
    }

    public void setDrnyEnd(String drnyEnd) {
        this.drnyEnd = drnyEnd;
    }

}