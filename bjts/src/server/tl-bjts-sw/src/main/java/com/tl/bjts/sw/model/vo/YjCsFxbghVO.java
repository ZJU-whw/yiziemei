package com.tl.bjts.sw.model.vo;

import com.tl.common.ext.annotation.ExcelSetting;

import java.io.Serializable;

/**
 * 风险报关行信息VO
 */
public class YjCsFxbghVO implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 主键ID */
    private Long id;

    @ExcelSetting(colTitleName = "风险报关行名称" , isFirst = true, nextColName = "bghdq")
    /** 风险报关行名称 */
    private String bghmc;

    /** 报关行所在地 */
    @ExcelSetting(colTitleName = "报关行所在地" , nextColName = "drny")
    private String bghdq;

    /** 数据导入月份（格式YYYYMM） */
    @ExcelSetting(colTitleName = "数据导入月份" , nextColName = "yxbz")
    private String drny;

    /** 有效标志（Y/N） */
    @ExcelSetting(colTitleName = "有效标志")
    private String yxbz;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

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

    public String getDrny() {
        return drny;
    }

    public void setDrny(String drny) {
        this.drny = drny;
    }

    public String getYxbz() {
        return yxbz;
    }

    public void setYxbz(String yxbz) {
        this.yxbz = yxbz;
    }
}