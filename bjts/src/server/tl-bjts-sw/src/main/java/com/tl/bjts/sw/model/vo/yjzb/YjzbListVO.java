package com.tl.bjts.sw.model.vo.yjzb;

import com.tl.common.ext.model.PageInfo;

/**
 * 描述:预警指标列表返回第项
 * 作者 likun
 * 时间 2020-07-21 15:42
 */
public class YjzbListVO {
    private PageInfo qsmr; //全省默认
    private PageInfo yhsz; //用户设置

    public PageInfo getQsmr() {
        return qsmr;
    }

    public void setQsmr(PageInfo qsmr) {
        this.qsmr = qsmr;
    }

    public PageInfo getYhsz() {
        return yhsz;
    }

    public void setYhsz(PageInfo yhsz) {
        this.yhsz = yhsz;
    }
}
