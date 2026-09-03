package com.tl.bjts.sw.model.vo;

/**
 * @Author：Mamf
 * @Date: 2019/12/12.
 * @Description:
 */
public class HzTypeVo {

    private String tblc;

    private String bblc;

    private String zbcol;

    private String formula;

    private String formulaHz;

    private String fmCol;  //分母字段

    public String getFormulaHz() {
        return formulaHz;
    }

    public void setFormulaHz(String formulaHz) {
        this.formulaHz = formulaHz;
    }

    public String getFmCol() {
        return fmCol;
    }

    public void setFmCol(String fmCol) {
        this.fmCol = fmCol;
    }

    public String getZbcol() {
        return zbcol;
    }

    public void setZbcol(String zbcol) {
        this.zbcol = zbcol;
    }

    public String getFormula() {
        return formula;
    }

    public void setFormula(String formula) {
        this.formula = formula;
    }

    public String getTblc() {
        return tblc;
    }

    public void setTblc(String tblc) {
        this.tblc = tblc;
    }

    public String getBblc() {
        return bblc;
    }

    public void setBblc(String bblc) {
        this.bblc = bblc;
    }
}
