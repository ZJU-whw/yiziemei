package com.tl.web.bjts.shzs.model.dto.dzhc;

import com.tl.common.ext.annotation.MaxLength;
import com.tl.common.ext.annotation.NotEmpty;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * @描述: 创建核查任务
 * @作者: likun
 * @时间: 2021/4/4 12:48
 */
public class InspectTaskAddDTO {
    @NotEmpty(msg = "社会信用代码不能为空")
    private String nsrsbh;
    @NotEmpty(msg = "单证核查类型范围不能为空")
    private String range;
    @NotEmpty(msg = "出口业务数据不能为空")
    private List<AvailableAddDTO> inspectDatas;

    private Long projectId; // 年度单证核查项目序号

    public String getNsrsbh() {
        return nsrsbh;
    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getRange() {
        return range;
    }

    public void setRange(String range) {
        this.range = range;
    }

    public List<AvailableAddDTO> getInspectDatas() {
        return inspectDatas;
    }

    public void setInspectDatas(List<AvailableAddDTO> inspectDatas) {
        this.inspectDatas = inspectDatas;
    }

    public Long getProjectId() {
        return projectId;
    }

    public void setProjectId(Long projectId) {
        this.projectId = projectId;
    }

    public class AvailableAddDTO {
        @NotEmpty(msg = "【申报业务种类】不能为空")
        @MaxLength(length = 10,msg = "【申报业务种类】最大长度不能超过10位")
        private String sbywzl;
        @NotEmpty(msg = "【申报年月批次】不能为空")
        @MaxLength(length = 15,msg = "【申报年月批次】最大长度不能超过15位")
        private String sbnypc;
        @NotEmpty(msg = "申报日期不能为空")
        private Date sbrq;
        private Date slrq; //受理日期
        @NotEmpty(msg = "【报关单号】不能为空")
        @MaxLength(length = 18,msg = "【报关单号】最大长度不能超过18位")
        private String entryId; //报关单号/代理证明号
        private BigDecimal je;
        private BigDecimal se;
        @MaxLength(length = 30,msg = "【业务类型代码】最大长度不能超过30位")
        private String ywlxCode;

        /**
         * 以下单证备案2.0版本使用
         */
        @MaxLength(length = 3000,msg = "【出口发票】最大长度不能超过3000位")
        private String ckfpNo;  // 出口发票号码
        @MaxLength(length = 3000,msg = "【进货发票】最大长度不能超过3000位")
        private String jhfpNo; // 进货发票号码

        private String range; // 核查类型范围

        private Integer yjsl; // 预警数量

        public String getSbywzl() {
            return sbywzl;
        }

        public void setSbywzl(String sbywzl) {
            this.sbywzl = sbywzl;
        }

        public String getSbnypc() {
            return sbnypc;
        }

        public void setSbnypc(String sbnypc) {
            this.sbnypc = sbnypc;
        }

        public Date getSbrq() {
            return sbrq;
        }

        public void setSbrq(Date sbrq) {
            this.sbrq = sbrq;
        }

        public Date getSlrq() {
            return slrq;
        }

        public void setSlrq(Date slrq) {
            this.slrq = slrq;
        }

        public String getEntryId() {
            return entryId;
        }

        public void setEntryId(String entryId) {
            this.entryId = entryId;
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

        public String getRange() {
            return range;
        }

        public void setRange(String range) {
            this.range = range;
        }

        public Integer getYjsl() {
            return yjsl;
        }

        public void setYjsl(Integer yjsl) {
            this.yjsl = yjsl;
        }
    }
}