package com.tl.bjts.sw.model.vo;


/*
 * @Description: 预警评分信息
 * @Author Neo Lin
 * @Date  2019-09-02 14:29
 */
public class YjPfxxVO {

    //预警总分
    private Integer scoreTotal;

    //海关代码
    private String qyhgdm;

    //纳税人名称
    private String nsrmc;

    //纳税人识别号
    private String nsrsbh;

    //退税税务机关
    private String swjgDm;

    //退税计算方式
    private String tsjsfsDm;

    //退税计算方式
    private String tsjsfsZh;

    //分类管理等级
    private String flgldj;

    //办税人姓名
    private String bsyMc;

    //办税人电话号码
    private String bsyDh;

    //法定代表人姓名
    private String fddbrmc;

    //法定代表人电话号码
    private String frdhhm;

    public Integer getScoreTotal() {
        return scoreTotal;
    }

    public void setScoreTotal(Integer scoreTotal) {
        this.scoreTotal = scoreTotal;
    }

    public String getQyhgdm() {
        return qyhgdm;
    }

    public void setQyhgdm(String qyhgdm) {
        this.qyhgdm = qyhgdm;
    }

    public String getNsrmc() {
        return nsrmc;
    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }

    public String getNsrsbh() {
        return nsrsbh;
    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getSwjgDm() {
        return swjgDm;
    }

    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm;
    }

    public String getTsjsfsDm() {

        return tsjsfsDm;
    }

    public void setTsjsfsDm(String tsjsfsDm) {
        this.tsjsfsDm = tsjsfsDm;
    }

    public String getTsjsfsZh() {
        if("1".equals(tsjsfsDm)){
            return "生产";
        }
        if("2".equals(tsjsfsDm)){
            return "外贸";
        }
        return tsjsfsZh;
    }

    public void setTsjsfsZh(String tsjsfsZh) {
        this.tsjsfsZh = tsjsfsZh;
    }

    public String getBsyMc() {
        return bsyMc;
    }

    public void setBsyMc(String bsyMc) {
        this.bsyMc = bsyMc;
    }

    public String getBsyDh() {
        return bsyDh;
    }

    public void setBsyDh(String bsyDh) {
        this.bsyDh = bsyDh;
    }

    public String getFddbrmc() {
        return fddbrmc;
    }

    public void setFddbrmc(String fddbrmc) {
        this.fddbrmc = fddbrmc;
    }

    public String getFrdhhm() {
        return frdhhm;
    }

    public void setFrdhhm(String frdhhm) {
        this.frdhhm = frdhhm;
    }

    public String getFlgldj() {
        return flgldj;
    }

    public void setFlgldj(String flgldj) {
        this.flgldj = flgldj;
    }
}
