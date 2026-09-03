package com.tl.bjts.sw.model.dto;

import java.math.BigDecimal;
import java.util.List;

/**
 * @author: Mamf
 * @date: 2021/11/29
 * @description
 */
public class SjjcSamplePramDTO {

    private Long zid;

    private List<BigDecimal> djxhs;

    private List<BigDecimal> ids;

    public List<BigDecimal> getIds() {
        return this.ids;

    }

    public void setIds(List<BigDecimal> ids) {
        this.ids = ids;
    }

    public Long getZid() {
        return this.zid;

    }

    public void setZid(Long zid) {
        this.zid = zid;
    }

    public List<BigDecimal> getDjxhs() {
        return this.djxhs;

    }

    public void setDjxhs(List<BigDecimal> djxhs) {
        this.djxhs = djxhs;
    }
}
