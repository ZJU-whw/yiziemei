package com.tl.bjts.sw.model;

/**
 * @author: Mamf
 * @date: 2021/12/28
 * @description 数据字段表信息映射
 */
public class DictInfoModel {

    private String field;

    private String tableName;

    private String columnName;

    public String getField() {
        return this.field;

    }

    public void setField(String field) {
        this.field = field;
    }

    public String getTableName() {
        return this.tableName;

    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getColumnName() {
        return this.columnName;

    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }
}
