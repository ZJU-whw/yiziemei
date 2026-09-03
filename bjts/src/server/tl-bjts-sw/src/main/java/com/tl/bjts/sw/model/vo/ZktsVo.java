package com.tl.bjts.sw.model.vo;

import com.tl.common.ext.annotation.ExcelSetting;

public class ZktsVo {
    @ExcelSetting(colTitleName = "主管税务机关代码", isFirst = true, nextColName = "qydm")
    private String swcode ; //主管税务机关代码  |
    @ExcelSetting(colTitleName = "海关代码",  nextColName = "nsrdj_no")
    private String qydm  ; //海关代码  |
    @ExcelSetting(colTitleName = "社会信用代码",  nextColName = "nsrmc")
    private String nsrdj_no ; //社会信用代码  |
    @ExcelSetting(colTitleName = "纳税人名称",  nextColName = "flglcd")
    private String nsrmc  ; //纳税人名称  |
    @ExcelSetting(colTitleName = "分类管理",  nextColName = "qylx")
    private String flglcd ; //分类管理  |
    @ExcelSetting(colTitleName = "企业类型",  nextColName = "op_date")
    private String qylx  ; //企业类型  |
    @ExcelSetting(colTitleName = "录入日期",  nextColName = "zk_no")
    private String op_date ; //录入日期 |
    @ExcelSetting(colTitleName = "暂扣编号",  nextColName = "zk_xh")
    private String zk_no  ; //暂扣编号  |
    @ExcelSetting(colTitleName = "暂扣序号",  nextColName = "Zk_Code")
    private String zk_xh ; //暂扣序号  |
    @ExcelSetting(colTitleName = "应暂扣退税办理情形",  nextColName = "wsbh")
    private String  zk_code ; //应暂扣退税办理情形  |
    @ExcelSetting(colTitleName = "相应文书编号",  nextColName = "wsbh_name")
    private String wsbh ; //相应文书编号  |
    @ExcelSetting(colTitleName = "相应文书名称",  nextColName = "nzk_ytsje")
    private String wsbh_name  ; //相应文书名称  |
    @ExcelSetting(colTitleName = "拟暂扣应退税金额",  nextColName = "zk_date")
    private String nzk_ytsje ; //拟暂扣应退税金额  |
    @ExcelSetting(colTitleName = "暂扣起始时间",  nextColName = "wzfqy")
    private String zk_date  ; //暂扣起始时间  |
    @ExcelSetting(colTitleName = "是否代办退税",  nextColName = "wt_nsrdj_no")
    private String wzfqy ; //是否代办退税  |
    @ExcelSetting(colTitleName = "生产企业纳税人识别号",  nextColName = "wt_cpname")
    private String  wt_nsrdj_no ; //生产企业纳税人识别号（社会信用代码）  |
    @ExcelSetting(colTitleName = "生产企业名称",  nextColName = "Jczk_No")
    private String  wt_cpname; //生产企业名称  |
    @ExcelSetting(colTitleName = "解除暂扣编号",  nextColName = "Jczk_Reason")
    private String  jczk_no; //解除暂扣编号  |
    @ExcelSetting(colTitleName = "暂扣原因",  nextColName = "Njczk_Amt")
    private String  jczk_reason ; //暂扣原因  |
    @ExcelSetting(colTitleName = "已解除暂扣金额",  nextColName = "Syyzk_Amt")
    private String njczk_amt ; //已解除暂扣金额  |
    @ExcelSetting(colTitleName = "未解除暂扣金额的相关数据", isLast = true)
    private String  syyzk_amt ; //未解除暂扣金额的相关数据  |

    public String getSwcode() {
        return swcode;
    }

    public void setSwcode(String swcode) {
        this.swcode = swcode;
    }

    public String getQydm() {
        return qydm;
    }

    public void setQydm(String qydm) {
        this.qydm = qydm;
    }

    public String getNsrdj_no() {
        return nsrdj_no;
    }

    public void setNsrdj_no(String nsrdj_no) {
        this.nsrdj_no = nsrdj_no;
    }

    public String getNsrmc() {
        return nsrmc;
    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }

    public String getFlglcd() {
        return flglcd;
    }

    public void setFlglcd(String flglcd) {
        this.flglcd = flglcd;
    }

    public String getQylx() {
        return qylx;
    }

    public void setQylx(String qylx) {
        this.qylx = qylx;
    }

    public String getOp_date() {
        return op_date;
    }

    public void setOp_date(String op_date) {
        this.op_date = op_date;
    }

    public String getZk_no() {
        return zk_no;
    }

    public void setZk_no(String zk_no) {
        this.zk_no = zk_no;
    }

    public String getZk_xh() {
        return zk_xh;
    }

    public void setZk_xh(String zk_xh) {
        this.zk_xh = zk_xh;
    }


    public String getWsbh() {
        return wsbh;
    }

    public void setWsbh(String wsbh) {
        this.wsbh = wsbh;
    }

    public String getWsbh_name() {
        return wsbh_name;
    }

    public void setWsbh_name(String wsbh_name) {
        this.wsbh_name = wsbh_name;
    }

    public String getNzk_ytsje() {
        return nzk_ytsje;
    }

    public void setNzk_ytsje(String nzk_ytsje) {
        this.nzk_ytsje = nzk_ytsje;
    }

    public String getZk_date() {
        return zk_date;
    }

    public void setZk_date(String zk_date) {
        this.zk_date = zk_date;
    }

    public String getWzfqy() {
        return wzfqy;
    }

    public void setWzfqy(String wzfqy) {
        this.wzfqy = wzfqy;
    }

    public String getWt_nsrdj_no() {
        return wt_nsrdj_no;
    }

    public void setWt_nsrdj_no(String wt_nsrdj_no) {
        this.wt_nsrdj_no = wt_nsrdj_no;
    }

    public String getWt_cpname() {
        return wt_cpname;
    }

    public void setWt_cpname(String wt_cpname) {
        this.wt_cpname = wt_cpname;
    }

    public String getZk_code() {
        return zk_code;
    }

    public void setZk_code(String zk_code) {
        this.zk_code = zk_code;
    }

    public String getJczk_no() {
        return jczk_no;
    }

    public void setJczk_no(String jczk_no) {
        this.jczk_no = jczk_no;
    }

    public String getJczk_reason() {
        return jczk_reason;
    }

    public void setJczk_reason(String jczk_reason) {
        this.jczk_reason = jczk_reason;
    }

    public String getNjczk_amt() {
        return njczk_amt;
    }

    public void setNjczk_amt(String njczk_amt) {
        this.njczk_amt = njczk_amt;
    }

    public String getSyyzk_amt() {
        return syyzk_amt;
    }

    public void setSyyzk_amt(String syyzk_amt) {
        this.syyzk_amt = syyzk_amt;
    }
}
