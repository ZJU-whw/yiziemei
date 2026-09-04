package com.tl.web.bjts.shzs.model.vo.ldlp;

import java.math.BigDecimal;
import java.util.List;

public class LdlpInfoVo {
    private Long sbid;
    private String ldlpNo;

    //    外贸
    private Integer tsckTotal;       //出口明细总数
    private BigDecimal tsckTsAmt;     //出口明细合计退税额
    private Integer tsjhTotal;   //进货明细总数
    private  BigDecimal tsjhAmt;   //进货明细合计计税金额
    private  BigDecimal tsjhTsAmt;   //进货明细合计可退税额
    private  BigDecimal tsjhSe;   //进货明细合计税额
    private List<TsckVo> tscks;
    private List<TsjhVo> tsjhs;



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

    public List<TsckVo> getTscks() {
        return tscks;
    }

    public void setTscks(List<TsckVo> tscks) {
        this.tscks = tscks;
    }

    public List<TsjhVo> getTsjhs() {
        return tsjhs;
    }

    public void setTsjhs(List<TsjhVo> tsjhs) {
        this.tsjhs = tsjhs;
    }

    public Integer getTsckTotal() {
        return tsckTotal;
    }

    public void setTsckTotal(Integer tsckTotal) {
        this.tsckTotal = tsckTotal;
    }

    public BigDecimal getTsckTsAmt() {
        return tsckTsAmt;
    }

    public void setTsckTsAmt(BigDecimal tsckTsAmt) {
        this.tsckTsAmt = tsckTsAmt;
    }

    public Integer getTsjhTotal() {
        return tsjhTotal;
    }

    public void setTsjhTotal(Integer tsjhTotal) {
        this.tsjhTotal = tsjhTotal;
    }

    public BigDecimal getTsjhAmt() {
        return tsjhAmt;
    }

    public void setTsjhAmt(BigDecimal tsjhAmt) {
        this.tsjhAmt = tsjhAmt;
    }

    public BigDecimal getTsjhTsAmt() {
        return tsjhTsAmt;
    }

    public void setTsjhTsAmt(BigDecimal tsjhTsAmt) {
        this.tsjhTsAmt = tsjhTsAmt;
    }

    public BigDecimal getTsjhSe() {
        return tsjhSe;
    }

    public void setTsjhSe(BigDecimal tsjhSe) {
        this.tsjhSe = tsjhSe;
    }
}
