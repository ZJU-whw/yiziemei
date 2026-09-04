package com.tl.web.bjts.shzs.model.vo;

/**
 * @Author：Mamf
 * @Date: 2017/8/7.
 * @Description:
 */
public class RwtxVo {

    private String id;

    private String qyhgdm;

    private String nsrmc;

    private String sbywbDm;

    private String sbywbMc;

    private String sbzlDm;

    private String sbzlMc;

    private String sssq;

    private String sbpc;

    private String rwbt;

    private String rwnr;

    private String jzrq;

    private String swryDm;

    private String swryMc;

    private String lxdh;

    private String cjrq;//下达日期

    private String wcrq;//反馈日期

    private String rwztDm;

    private String rwztMc;

    private String thyy;



    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public String getSbywbDm() {
        return sbywbDm;
    }

    public void setSbywbDm(String sbywbDm) {
        this.sbywbDm = sbywbDm;
    }

    public String getSbywbMc() {
        return sbywbMc;
    }

    public void setSbywbMc(String sbywbMc) {
        this.sbywbMc = sbywbMc;
    }

    public String getSbzlDm() {
        return sbzlDm;
    }

    public void setSbzlDm(String sbzlDm) {
        this.sbzlDm = sbzlDm;
    }

    public String getSbzlMc() {
        return sbzlMc;
    }

    public void setSbzlMc(String sbzlMc) {
        this.sbzlMc = sbzlMc;
    }

    public String getSssq() {
        return sssq;
    }

    public void setSssq(String sssq) {
        this.sssq = sssq;
    }

    public String getSbpc() {
        return sbpc;
    }

    public void setSbpc(String sbpc) {
        this.sbpc = sbpc;
    }

    public String getRwbt() {
        return rwbt;
    }

    public void setRwbt(String rwbt) {
        this.rwbt = rwbt;
    }

    public String getRwnr() {
        return rwnr;
    }

    public void setRwnr(String rwnr) {
        this.rwnr = rwnr;
    }

    public String getJzrq() {
        return jzrq;
    }

    public void setJzrq(String jzrq) {
        this.jzrq = jzrq;
    }

    public String getSwryDm() {
        return swryDm;
    }

    public void setSwryDm(String swryDm) {
        this.swryDm = swryDm;
    }

    public String getSwryMc() {
        return swryMc;
    }

    public void setSwryMc(String swryMc) {
        this.swryMc = swryMc;
    }

    public String getLxdh() {
        return lxdh;
    }

    public void setLxdh(String lxdh) {
        this.lxdh = lxdh;
    }

    public String getCjrq() {
        if(cjrq!=null){
            return cjrq.trim().replaceFirst("\\.0","");
        }
        return cjrq;
    }

    public void setCjrq(String cjrq) {
        this.cjrq = cjrq;
    }

    public String getWcrq() {
        if(wcrq!=null){
            return wcrq.trim().replaceFirst("\\.0","");
        }
        return wcrq;
    }

    public void setWcrq(String wcrq) {
        this.wcrq = wcrq;
    }

    public String getRwztDm() {
        return rwztDm;
    }

    public void setRwztDm(String rwztDm) {
        this.rwztDm = rwztDm;
    }

    public String getRwztMc() {
        return rwztMc;
    }

    public void setRwztMc(String rwztMc) {
        this.rwztMc = rwztMc;
    }

    public String getThyy() {
        return thyy;
    }

    public void setThyy(String thyy) {
        this.thyy = thyy;
    }
}
