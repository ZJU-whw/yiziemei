package com.tl.bjts.sw.model.vo.jcfx;

import java.util.List;

/**
 * @author: Mamf
 * @date: 2021/11/9
 * @description 指标项显示对象
 */
public class ZbItemVo {


    private String zbxmbm;

    private String zbxmmc;

    private String isTree; //0-列表 1-树

    private List<SelectItemVo> values;

    public String getZbxmbm() {
        return this.zbxmbm;

    }

    public void setZbxmbm(String zbxmbm) {
        this.zbxmbm = zbxmbm;
    }

    public String getZbxmmc() {
        return this.zbxmmc;

    }

    public void setZbxmmc(String zbxmmc) {
        this.zbxmmc = zbxmmc;
    }


    public List<SelectItemVo> getValues() {
        return this.values;

    }

    public void setValues(List<SelectItemVo> values) {
        this.values = values;
    }


    public String getIsTree() {
        return this.isTree;

    }

    public void setIsTree(String isTree) {
        this.isTree = isTree;
    }
}
