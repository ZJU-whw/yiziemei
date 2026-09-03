package com.tl.bjts.sw.model;

/**
 * @author: Mamf
 * @date: 2021/12/31
 * @description 系统配置参数对象
 */
public class ParamModel {

    private String dateCrossYearFlag;  //1,允许跨年  0 不允许跨年

    private String dataSsnyStart;

    private String dataSsnyEnd;

    public String getDateCrossYearFlag() {
        return this.dateCrossYearFlag;

    }

    public void setDateCrossYearFlag(String dateCrossYearFlag) {
        this.dateCrossYearFlag = dateCrossYearFlag;
    }

    public String getDataSsnyStart() {
        return this.dataSsnyStart;

    }

    public void setDataSsnyStart(String dataSsnyStart) {
        this.dataSsnyStart = dataSsnyStart;
    }

    public String getDataSsnyEnd() {
        return this.dataSsnyEnd;

    }

    public void setDataSsnyEnd(String dataSsnyEnd) {
        this.dataSsnyEnd = dataSsnyEnd;
    }
}
