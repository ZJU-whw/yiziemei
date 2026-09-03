package com.tl.bjts.sw.model.vo;

import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2019/9/16.
 * @Description:
 */
public class HeadLineVo {

    private List<List<Header>> header;

    private List<List<Header>> liner;

    private List<ColumnProfile> column;

    private List<String> headerFormula;

    private List<String> linerFormula;

    private List<String> bzFormula;

    public List<String> getBzFormula() {
        return bzFormula;
    }

    public void setBzFormula(List<String> bzFormula) {
        this.bzFormula = bzFormula;
    }

    public List<ColumnProfile> getColumn() {
        return column;
    }

    public void setColumn(List<ColumnProfile> column) {
        this.column = column;
    }

    public List<List<Header>> getHeader() {
        return header;
    }

    public void setHeader(List<List<Header>> header) {
        this.header = header;
    }

    public List<List<Header>> getLiner() {
        return liner;
    }

    public void setLiner(List<List<Header>> liner) {
        this.liner = liner;
    }

    public List<String> getHeaderFormula() {
        return headerFormula;
    }

    public void setHeaderFormula(List<String> headerFormula) {
        this.headerFormula = headerFormula;
    }

    public List<String> getLinerFormula() {
        return linerFormula;
    }

    public void setLinerFormula(List<String> linerFormula) {
        this.linerFormula = linerFormula;
    }

    public class Header{

        private String showname;//正表头
        private String dispwidth;
        private String disphight;
        private String w;//宽占格
        private String h;//高占格

        private CssVo css;

        public CssVo getCss() {
            return css;
        }

        public void setCss(CssVo css) {
            this.css = css;
        }

        public String getShowname() {
            return showname;
        }

        public void setShowname(String showname) {
            this.showname = showname;
        }

        public String getDispwidth() {
            return dispwidth==null?"":dispwidth;
        }

        public void setDispwidth(String dispwidth) {
            this.dispwidth = dispwidth;
        }

        public String getDisphight() {
            return disphight==null?"":disphight;
        }

        public void setDisphight(String disphight) {
            this.disphight = disphight;
        }

        public String getW() {
            return w;
        }

        public void setW(String w) {
            this.w = w;
        }

        public String getH() {
            return h;
        }

        public void setH(String h) {
            this.h = h;
        }
    }


    public class ColumnProfile{
        private String fname;
        private String degree;
        private String allowupdate;
        private String note;
        private String align;
        private String allowformula;

        public String getAllowformula() {
            return allowformula;
        }

        public void setAllowformula(String allowformula) {
            this.allowformula = allowformula;
        }

        public String getFname() {
            return fname;
        }

        public void setFname(String fname) {
            this.fname = fname;
        }

        public String getDegree() {
            return degree==null?"":degree;
        }

        public void setDegree(String degree) {
            this.degree = degree;
        }

        public String getAllowupdate() {
            return allowupdate;
        }

        public void setAllowupdate(String allowupdate) {
            this.allowupdate = allowupdate;
        }

        public String getNote() {
            return note;
        }

        public void setNote(String note) {
            this.note = note;
        }

        public String getAlign() {
            return align;
        }

        public void setAlign(String align) {
            this.align = align;
        }
    }
}
