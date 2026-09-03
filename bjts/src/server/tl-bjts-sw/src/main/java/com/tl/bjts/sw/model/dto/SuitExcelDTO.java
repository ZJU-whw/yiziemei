package com.tl.bjts.sw.model.dto;

import com.tl.bjts.sw.model.domain.TjbbTbxx;

import java.util.List;
import java.util.Map;

/**
 * @Author：Mamf
 * @Date: 2019/12/30.
 * @Description:
 */
public class SuitExcelDTO {

    private String ssny;

    private String bbdm;

    List<String> fnameCols;  //导出列

    List<Map> listContent; //导出数据行

    Map<String, String> methodMap; //转译处理公式

    private int startCol, startRow, headCol, headRow,  endRow; //Excel坐标配置信息

    private TjbbTbxx zbxx;

    public String getSsny() {
        return this.ssny;

    }

    public void setSsny(String ssny) {
        this.ssny = ssny;
    }

    public String getBbdm() {
        return bbdm;
    }

    public void setBbdm(String bbdm) {
        this.bbdm = bbdm;
    }

    public List<String> getFnameCols() {
        return fnameCols;
    }

    public void setFnameCols(List<String> fnameCols) {
        this.fnameCols = fnameCols;
    }

    public List<Map> getListContent() {
        return listContent;
    }

    public void setListContent(List<Map> listContent) {
        this.listContent = listContent;
    }

    public Map<String, String> getMethodMap() {
        return methodMap;
    }

    public void setMethodMap(Map<String, String> methodMap) {
        this.methodMap = methodMap;
    }

    public int getStartCol() {
        return startCol;
    }

    public void setStartCol(int startCol) {
        this.startCol = startCol;
    }

    public int getStartRow() {
        return startRow;
    }

    public void setStartRow(int startRow) {
        this.startRow = startRow;
    }

    public int getHeadCol() {
        return headCol;
    }

    public void setHeadCol(int headCol) {
        this.headCol = headCol;
    }

    public int getHeadRow() {
        return headRow;
    }

    public void setHeadRow(int headRow) {
        this.headRow = headRow;
    }

    public int getEndRow() {
        return endRow;
    }

    public void setEndRow(int endRow) {
        this.endRow = endRow;
    }

    public TjbbTbxx getZbxx() {
        return zbxx;
    }

    public void setZbxx(TjbbTbxx zbxx) {
        this.zbxx = zbxx;
    }
}
