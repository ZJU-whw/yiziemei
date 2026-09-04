package com.tl.web.bjts.shzs.model.vo.ldlp;


import java.math.BigDecimal;
import java.util.List;

public class LdlpInfo4ScVo {

    //申报id
    private Long sbid;

    //关联号 sbno
    private String ldlpNo;

    //出口明细总数
    private Integer mdtsckTotal;

    //出口明细合计退税额
    private BigDecimal mdtsckTsAmt;

    //[]出口明细数组
    private List<MdtsckVo> mdtscks;

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

    public Integer getMdtsckTotal() {
        return mdtsckTotal;
    }

    public void setMdtsckTotal(Integer mdtsckTotal) {
        this.mdtsckTotal = mdtsckTotal;
    }

    public BigDecimal getMdtsckTsAmt() {
        return mdtsckTsAmt;
    }

    public void setMdtsckTsAmt(BigDecimal mdtsckTsAmt) {
        this.mdtsckTsAmt = mdtsckTsAmt;
    }

    public List<MdtsckVo> getMdtscks() {
        return mdtscks;
    }

    public void setMdtscks(List<MdtsckVo> mdtscks) {
        this.mdtscks = mdtscks;
    }
}
