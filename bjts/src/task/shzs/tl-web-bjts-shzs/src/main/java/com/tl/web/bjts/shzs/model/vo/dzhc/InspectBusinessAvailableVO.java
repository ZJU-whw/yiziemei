package com.tl.web.bjts.shzs.model.vo.dzhc;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @描述: 核查可用出口业务返回（2.0版本）
 * @作者: likun
 * @时间: 2022/2/10 11:27
 */
public class InspectBusinessAvailableVO {
    // 申报业务种类代码
    private String sbywzl;
    // 申报业务种类名称
    private String sbywzlName;
    // 申报年月批次
    private String sbnypc;
    // 18位报关单号
    private String entryId;
    // 出口日期
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date ckrq;
    // 申报日期
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date sbrq;
    // 出口发票号码
    private String ckfpNo;
    // 进货发票号码
    private String jhfpNo;
    // 出口销售金额(美元)
    private BigDecimal je;
     // 退免税额
    private BigDecimal se;
    // 业务类型代码
    private String ywlxCode;
    // 业务类型名称
    private String ywlxName;

    public String getSbywzl() {
        return sbywzl;
    }

    public void setSbywzl(String sbywzl) {
        this.sbywzl = sbywzl;
    }

    public String getSbywzlName() {
        return sbywzlName;
    }

    public void setSbywzlName(String sbywzlName) {
        this.sbywzlName = sbywzlName;
    }

    public String getSbnypc() {
        return sbnypc;
    }

    public void setSbnypc(String sbnypc) {
        this.sbnypc = sbnypc;
    }

    public String getEntryId() {
        return entryId;
    }

    public void setEntryId(String entryId) {
        this.entryId = entryId;
    }

    public Date getCkrq() {
        return ckrq;
    }

    public void setCkrq(Date ckrq) {
        this.ckrq = ckrq;
    }

    public Date getSbrq() {
        return sbrq;
    }

    public void setSbrq(Date sbrq) {
        this.sbrq = sbrq;
    }

    public String getCkfpNo() {
        return ckfpNo;
    }

    public void setCkfpNo(String ckfpNo) {
        this.ckfpNo = ckfpNo;
    }

    public String getJhfpNo() {
        return jhfpNo;
    }

    public void setJhfpNo(String jhfpNo) {
        this.jhfpNo = jhfpNo;
    }

    public BigDecimal getJe() {
        return je;
    }

    public void setJe(BigDecimal je) {
        this.je = je;
    }

    public BigDecimal getSe() {
        return se;
    }

    public void setSe(BigDecimal se) {
        this.se = se;
    }

    public String getYwlxCode() {
        return ywlxCode;
    }

    public void setYwlxCode(String ywlxCode) {
        this.ywlxCode = ywlxCode;
    }

    public String getYwlxName() {
        return ywlxName;
    }

    public void setYwlxName(String ywlxName) {
        this.ywlxName = ywlxName;
    }

    @Override
    public String toString() {
        return "InspectBusinessAvailableVO{" +
                "sbywzl='" + sbywzl + '\'' +
                ", sbywzlName='" + sbywzlName + '\'' +
                ", sbnypc='" + sbnypc + '\'' +
                ", entryId='" + entryId + '\'' +
                ", ckrq=" + ckrq +
                ", sbrq=" + sbrq +
                ", ckfpNo='" + ckfpNo + '\'' +
                ", jhfpNo='" + jhfpNo + '\'' +
                ", je=" + je +
                ", se=" + se +
                ", ywlxCode='" + ywlxCode + '\'' +
                '}';
    }
}
