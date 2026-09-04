package com.tl.web.bjts.shzs.model.vo.ldlp;

import java.math.BigDecimal;
import java.util.List;

public class LdlpInfo4ZyhwVo {

    //申报id
    private Long sbid;

    //关联号
    private String ldlpNo;

    //购进自用货物明细总数
    private Integer zyhwTotal;

    //购进自用货物明细合计计税金额
    private BigDecimal zyhwAmt;

    //购进自用货物明细合计税额
    private BigDecimal zyhwSe;

    //购进自用货物明细合计可退税额
    private BigDecimal zyhwTsAmt;

    //[]购进自用货物明细数组
    private List<ZyhwmxVo> zyhwmx;

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
    }

    public String getLdlpNo() {
        return ldlpNo;
    }

    public void setLdlpNo(String ldlpNo) {
        this.ldlpNo = ldlpNo;
    }

    public Integer getZyhwTotal() {
        return zyhwTotal;
    }

    public void setZyhwTotal(Integer zyhwTotal) {
        this.zyhwTotal = zyhwTotal;
    }

    public BigDecimal getZyhwAmt() {
        return zyhwAmt;
    }

    public void setZyhwAmt(BigDecimal zyhwAmt) {
        this.zyhwAmt = zyhwAmt;
    }

    public BigDecimal getZyhwSe() {
        return zyhwSe;
    }

    public void setZyhwSe(BigDecimal zyhwSe) {
        this.zyhwSe = zyhwSe;
    }

    public BigDecimal getZyhwTsAmt() {
        return zyhwTsAmt;
    }

    public void setZyhwTsAmt(BigDecimal zyhwTsAmt) {
        this.zyhwTsAmt = zyhwTsAmt;
    }

    public List<ZyhwmxVo> getZyhwmx() {
        return zyhwmx;
    }

    public void setZyhwmx(List<ZyhwmxVo> zyhwmx) {
        this.zyhwmx = zyhwmx;
    }
}
