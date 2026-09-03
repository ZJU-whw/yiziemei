package com.tl.bjts.sw.model;

import com.tl.common.ext.model.PageInfo;

/**
 * 描述:包含合计的页面元素
 * 作者 likun
 * 时间 2020-05-07 15:52
 */
public class PageInfoIncludeSum<T> extends PageInfo {
    private T sumData;

    public T getSumData() {
        return sumData;
    }

    public void setSumData(T sumData) {
        this.sumData = sumData;
    }
}
