package com.tl.bjts.sw.model.vo;

import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2019/10/18.
 * @Description:
 */
public class FormulaColumnVo {

    private List<FormulaColumn> cols;

    private List<FormulaColumn> rows;


    public List<FormulaColumn> getCols() {
        return cols;
    }

    public void setCols(List<FormulaColumn> cols) {
        this.cols = cols;
    }

    public List<FormulaColumn> getRows() {
        return rows;
    }

    public void setRows(List<FormulaColumn> rows) {
        this.rows = rows;
    }

    public static class FormulaColumn{

        private String fname;

        private String cname;

        private String bh;

        public String getFname() {
            return fname;
        }

        public void setFname(String fname) {
            this.fname = fname;
        }

        public String getCname() {
            return cname;
        }

        public void setCname(String cname) {
            this.cname = cname;
        }

        public String getBh() {
            return bh;
        }

        public void setBh(String bh) {
            this.bh = bh;
        }
    }
}
