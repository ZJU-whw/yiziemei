package com.tl.web.bjts.shzs.model.vo.ldlp;

import java.math.BigDecimal;
import java.util.List;

public class LdlpInfo4WzfVo {

    //申报id
    private Long sbid;

    //关联号 sbno
    private String ldlpNo;

    //代办退税明细总数
    private Integer dbtsTotal;

    //代办退税明细合计可退税额
    private BigDecimal dbtsTsAmt;

    //代办退税明细合计税额
    private BigDecimal dbtsSe;

    //[]代办退税明细数组
    private List<DbtsVo> dbtsmx;

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

    public Integer getDbtsTotal() {
        return dbtsTotal;
    }

    public void setDbtsTotal(Integer dbtsTotal) {
        this.dbtsTotal = dbtsTotal;
    }

    public BigDecimal getDbtsTsAmt() {
        return dbtsTsAmt;
    }

    public void setDbtsTsAmt(BigDecimal dbtsTsAmt) {
        this.dbtsTsAmt = dbtsTsAmt;
    }

    public BigDecimal getDbtsSe() {
        return dbtsSe;
    }

    public void setDbtsSe(BigDecimal dbtsSe) {
        this.dbtsSe = dbtsSe;
    }

    public List<DbtsVo> getDbtsmx() {
        return dbtsmx;
    }

    public void setDbtsmx(List<DbtsVo> dbtsmx) {
        this.dbtsmx = dbtsmx;
    }
}
