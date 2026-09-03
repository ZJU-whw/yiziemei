package com.tl.bjts.sw.model.vo;

import com.tl.common.ext.annotation.ExcelSetting;

import javax.persistence.Column;
import javax.persistence.Id;

public class MGkaScVo {

    @ExcelSetting(colTitleName = "口岸代码")
    private String kacode;
    @ExcelSetting(colTitleName = "口岸名称")
    private String kaname;
    @ExcelSetting(colTitleName = "所在省份")
    private String sheng;
    @ExcelSetting(colTitleName = "有效标志")
    private String yxbz;

    public String getKacode() {
        return kacode;
    }

    public void setKacode(String kacode) {
        this.kacode = kacode;
    }

    public String getKaname() {
        return kaname;
    }

    public void setKaname(String kaname) {
        this.kaname = kaname;
    }

    public String getSheng() {
        return sheng;
    }

    public void setSheng(String sheng) {
        this.sheng = sheng;
    }

    public String getYxbz() {
        return yxbz;
    }

    public void setYxbz(String yxbz) {
        this.yxbz = yxbz;
    }
}
