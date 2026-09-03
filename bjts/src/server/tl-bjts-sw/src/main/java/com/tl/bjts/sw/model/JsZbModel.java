package com.tl.bjts.sw.model;

import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2020/3/3.
 * @Description:
 */
public class JsZbModel {

    private String tablename;

    private String paramhash;

    private List<ZbColumn> zblist;

    public String getTablename() {
        return tablename;
    }

    public void setTablename(String tablename) {
        this.tablename = tablename;
    }

    public String getParamhash() {
        return paramhash;
    }

    public void setParamhash(String paramhash) {
        this.paramhash = paramhash;
    }

    public List<ZbColumn> getZblist() {
        return zblist;
    }

    public void setZblist(List<ZbColumn> zblist) {
        this.zblist = zblist;
    }

    public class ZbColumn{

        private String updateColumn;

        private String jsColumn;

        public String getUpdateColumn() {
            return updateColumn;
        }

        public void setUpdateColumn(String updateColumn) {
            this.updateColumn = updateColumn;
        }

        public String getJsColumn() {
            return jsColumn;
        }

        public void setJsColumn(String jsColumn) {
            this.jsColumn = jsColumn;
        }
    }
}
