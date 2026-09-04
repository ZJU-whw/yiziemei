package com.tl.web.bjts.shzs.model.vo.dzhc;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @描述: 打开核查任务
 * @作者: likun
 * @时间: 2021/3/29 14:30
 */
public class InspectTaskOpenVO {
    private InspectOpenNsrxxVO nsrxx; //纳税人基本信息
    private String range; //核查单证类型范围
    private InspectOpenBusinessVO business;// 业务数据
    private InspectOpenExtraVO extra;//其他信息

    public InspectOpenNsrxxVO getNsrxx() {
        return nsrxx;
    }

    public void setNsrxx(InspectOpenNsrxxVO nsrxx) {
        this.nsrxx = nsrxx;
    }

    public String getRange() {
        return range;
    }

    public void setRange(String range) {
        this.range = range;
    }


    public InspectOpenExtraVO getExtra() {
        return extra;
    }

    public void setExtra(InspectOpenExtraVO extra) {
        this.extra = extra;
    }

    public InspectOpenBusinessVO getBusiness() {
        return business;
    }

    public void setBusiness(InspectOpenBusinessVO business) {
        this.business = business;
    }

    public class InspectOpenExtraVO{
        private String remark; //备注
        private String inspectResult;//审核结果
        private String resultState;//审核意见

        private String balx; // 备案类型（前端根据此参数用于控制按钮(查看单证)是否显示）

        /**
         * 以下为单证备案2.0接口返回
         */
        private String note; // 备注
        private String examineResult; // 审核结果
        private String examineNote; // 审核意见

        public String getRemark() {
            return remark;
        }

        public void setRemark(String remark) {
            this.remark = remark;
        }

        public String getInspectResult() {
            return inspectResult;
        }

        public void setInspectResult(String inspectResult) {
            this.inspectResult = inspectResult;
        }


        public String getResultState() {
            return resultState;
        }

        public void setResultState(String resultState) {
            this.resultState = resultState;
        }

        public String getNote() {
            return note;
        }

        public void setNote(String note) {
            this.note = note;
        }

        public String getExamineResult() {
            return examineResult;
        }

        public void setExamineResult(String examineResult) {
            this.examineResult = examineResult;
        }

        public String getExamineNote() {
            return examineNote;
        }

        public void setExamineNote(String examineNote) {
            this.examineNote = examineNote;
        }

        public String getBalx() {
            return balx;
        }

        public void setBalx(String balx) {
            this.balx = balx;
        }
    }

    public class InspectOpenNsrxxVO{
        private String nsrsbh;
        private String nsrmc;
        private String qyhgdm;
        private String tsjsfs;
        private String tsjsfsName;
        private String gllb;
        private String jydz;
        private String lxr;
        private String lxrDh;

        public String getNsrsbh() {
            return nsrsbh;
        }

        public void setNsrsbh(String nsrsbh) {
            this.nsrsbh = nsrsbh;
        }

        public String getNsrmc() {
            return nsrmc;
        }

        public void setNsrmc(String nsrmc) {
            this.nsrmc = nsrmc;
        }

        public String getQyhgdm() {
            return qyhgdm;
        }

        public void setQyhgdm(String qyhgdm) {
            this.qyhgdm = qyhgdm;
        }

        public String getTsjsfs() {
            return tsjsfs;
        }

        public void setTsjsfs(String tsjsfs) {
            this.tsjsfs = tsjsfs;
        }

        public String getGllb() {
            return gllb;
        }

        public void setGllb(String gllb) {
            this.gllb = gllb;
        }

        public String getJydz() {
            return jydz;
        }

        public void setJydz(String jydz) {
            this.jydz = jydz;
        }

        public String getLxr() {
            return lxr;
        }

        public void setLxr(String lxr) {
            this.lxr = lxr;
        }

        public String getLxrDh() {
            return lxrDh;
        }

        public void setLxrDh(String lxrDh) {
            this.lxrDh = lxrDh;
        }

        public String getTsjsfsName() {
            return tsjsfsName;
        }

        public void setTsjsfsName(String tsjsfsName) {
            this.tsjsfsName = tsjsfsName;
        }
    }

    public class InspectOpenBusinessVO{
        private String sbnypc; //申报年月批次
        private BigDecimal tmse; //退免税额
        private String entryId; //报关单/代理证明号
        @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
        private Date eDate; //出口日期
        private String supvModeCodeName; //贸易方式
        private String contrNo;//合同号
        private String manualNo;//备案号
        private String cusTrafModeName;//运输方式
        private String trafName;//运输工具
        private String billNo;//提运单号
        private String cusTradeNationCodeName;//贸易国


        public String getSbnypc() {
            return sbnypc;
        }

        public void setSbnypc(String sbnypc) {
            this.sbnypc = sbnypc;
        }

        public BigDecimal getTmse() {
            return tmse;
        }

        public void setTmse(BigDecimal tmse) {
            this.tmse = tmse;
        }

        public String getEntryId() {
            return entryId;
        }

        public void setEntryId(String entryId) {
            this.entryId = entryId;
        }

        public Date geteDate() {
            return eDate;
        }

        public void seteDate(Date eDate) {
            this.eDate = eDate;
        }

        public String getSupvModeCodeName() {
            return supvModeCodeName;
        }

        public void setSupvModeCodeName(String supvModeCodeName) {
            this.supvModeCodeName = supvModeCodeName;
        }

        public String getContrNo() {
            return contrNo;
        }

        public void setContrNo(String contrNo) {
            this.contrNo = contrNo;
        }

        public String getManualNo() {
            return manualNo;
        }

        public void setManualNo(String manualNo) {
            this.manualNo = manualNo;
        }

        public String getCusTrafModeName() {
            return cusTrafModeName;
        }

        public void setCusTrafModeName(String cusTrafModeName) {
            this.cusTrafModeName = cusTrafModeName;
        }

        public String getTrafName() {
            return trafName;
        }

        public void setTrafName(String trafName) {
            this.trafName = trafName;
        }

        public String getBillNo() {
            return billNo;
        }

        public void setBillNo(String billNo) {
            this.billNo = billNo;
        }

        public String getCusTradeNationCodeName() {
            return cusTradeNationCodeName;
        }

        public void setCusTradeNationCodeName(String cusTradeNationCodeName) {
            this.cusTradeNationCodeName = cusTradeNationCodeName;
        }
    }



}
