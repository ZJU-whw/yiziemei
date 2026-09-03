package com.tl.bjts.sw.model.vo;

import java.util.List;

/**
 * @author: Mamf
 * @date: 2021/8/12
 * @description 动态明细报表数据返回对象
 */
public class DynamicDataVo {


    private List<String> titles;


    public List<String> getTitles() {
        return this.titles;

    }

    public void setTitles(List<String> titles) {
        this.titles = titles;
    }
}
