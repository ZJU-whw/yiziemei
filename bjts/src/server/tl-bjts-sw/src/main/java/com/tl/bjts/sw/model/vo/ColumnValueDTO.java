package com.tl.bjts.sw.model.vo;

/**
 * @Author：Mamf
 * @Date: 2019/12/24.
 * @Description:
 */
public class ColumnValueDTO {

    private String colName;

    private String colValue;

    private String colValueHz;

    public String getColValueHz() {
        return colValueHz;
    }

    public void setColValueHz(String colValueHz) {
        this.colValueHz = colValueHz;
    }

    public String getColName() {
        return colName;
    }

    public void setColName(String colName) {
        this.colName = colName;
    }

    public String getColValue() {
        return colValue;
    }

    public void setColValue(String colValue) {
        this.colValue = colValue;
    }
}
