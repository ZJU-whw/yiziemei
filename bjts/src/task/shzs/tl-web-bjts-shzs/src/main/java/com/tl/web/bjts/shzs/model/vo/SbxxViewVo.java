package com.tl.web.bjts.shzs.model.vo;

import com.tl.web.bjts.shzs.utils.TlUtils;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.util.List;

/**
 * Created by Neo Lin on 2017/6/29.
 */
public class SbxxViewVo {

    private BigDecimal djxh;

    private String loginSwjgDm;

    private String nsrsbh;

    private String qyhgdm;

    private String nsrmc;

    private String swjgDm;

    private String swjgMc;

    private String flglcd;

    private String tsjsfsDm;

    private Long sbid;

    private String sbywbDm;

    private String sbywbMc;

    private String sssq;

    private String sbpc;

    private String sbztDm;

    private String sbrq;

    /**
     * 任务优先级标识，999 代表人工触发提权
     */
    private Integer sbcs;

    private String wzhqy;
//    private String sbzlDm;
    private String zsswjgMc;

    private String lxr;

    private String lxrdh;

    private String jdxzmc;  // 乡镇街道  2018 12-19

    private String zzsbb; //2019-03-11 增值税报表状态

    private String tag;  //2019-07-09 新增对美贸易

    /**
     * 无纸化备案 关联tl_admin.edoc_apply表
     */
    private String wzhba;
    // 备案联系人
    private String lxrBa;
    // 备案人联系电话
    private String lxrdhBa;

    private String tqbz;

    private String timeoutFlag;

    private List<String> ywjktx;

    public BigDecimal getDjxh() {
        return this.djxh;

    }

    public void setDjxh(BigDecimal djxh) {
        this.djxh = djxh;
    }

    public String getLoginSwjgDm() {
        return this.loginSwjgDm;

    }

    public void setLoginSwjgDm(String loginSwjgDm) {
        this.loginSwjgDm = loginSwjgDm;
    }

    public void setSbcs(int sbcs) {
        this.sbcs = sbcs;
    }

    public String getTqbz() {
        return this.tqbz;

    }

    public void setTqbz(String tqbz) {
        this.tqbz = tqbz;
    }

    public String getTimeoutFlag() {
        return this.timeoutFlag;

    }

    public void setTimeoutFlag(String timeoutFlag) {
        this.timeoutFlag = timeoutFlag;
    }

    public List<String> getYwjktx() {
        return this.ywjktx;

    }

    public void setYwjktx(List<String> ywjktx) {
        this.ywjktx = ywjktx;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public String getZzsbb() {
        return zzsbb;
    }

    public void setZzsbb(String zzsbb) {
        this.zzsbb = zzsbb;
    }

    public String getJdxzmc() {
        return jdxzmc;
    }

    public void setJdxzmc(String jdxzmc) {
        this.jdxzmc = jdxzmc;
    }

    public String getWzhqy() {
        return wzhqy;
    }

    public void setWzhqy(String wzhqy) {
        this.wzhqy = wzhqy;
    }

    public Integer getSbcs() {
        return sbcs;
    }

    public void setSbcs(Integer sbcs) {
        this.sbcs = sbcs;
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

    public String getSwjgDm() {
        return swjgDm;
    }

    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm;
    }

    public String getSwjgMc() {
        return swjgMc;
    }

    public void setSwjgMc(String swjgMc) {
        this.swjgMc = swjgMc;
    }

    public String getFlglcd() {
        return flglcd;
    }

    public void setFlglcd(String flglcd) {
        this.flglcd = flglcd;
    }

    public String getTsjsfsDm() {
        return tsjsfsDm;
    }

    public void setTsjsfsDm(String tsjsfsDm) {
        this.tsjsfsDm = tsjsfsDm;
    }

    public Long getSbid() {
        return sbid;
    }

    public void setSbid(Long sbid) {
        this.sbid = sbid;
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

    public String getSssq() {
        if(StringUtils.isNotEmpty(sssq) && StringUtils.isNotEmpty(sbpc)){
            return sssq + " " +sbpc;
        }else if(StringUtils.isNotEmpty(sssq) && StringUtils.isEmpty(sbpc)){
            return sssq;
        }else {
            return null;
        }
    }

    public void setSssq(String sssq) {
        this.sssq = sssq;
    }

    public String getSbpc() {
        return sbpc;
    }

    public void setSbpc(String sbpc) {
        this.sbpc = TlUtils.dealSbpc(sbpc);
    }

    public String getSbztDm() {
        return sbztDm;
    }

    public void setSbztDm(String sbztDm) {
        this.sbztDm = sbztDm;
    }

    public String getSbrq() {
        return sbrq;
    }

    public void setSbrq(String sbrq) {
        this.sbrq = sbrq;
    }

    public String getZsswjgMc() {
        return zsswjgMc;
    }

    public void setZsswjgMc(String zsswjgMc) {
        this.zsswjgMc = zsswjgMc;
    }

    public String getLxr() {
        return lxr;
    }

    public void setLxr(String lxr) {
        this.lxr = lxr;
    }

    public String getLxrdh() {
        return lxrdh;
    }

    public void setLxrdh(String lxrdh) {
        this.lxrdh = lxrdh;
    }

    public String getWzhba() {
        return wzhba;
    }

    public void setWzhba(String wzhba) {
        this.wzhba = wzhba;
    }

    public String getNsrsbh() {
        return nsrsbh;
    }

    public void setNsrsbh(String nsrsbh) {
        this.nsrsbh = nsrsbh;
    }

    public String getLxrBa() {
        return lxrBa;
    }

    public void setLxrBa(String lxrBa) {
        this.lxrBa = lxrBa;
    }

    public String getLxrdhBa() {
        return lxrdhBa;
    }

    public void setLxrdhBa(String lxrdhBa) {
        this.lxrdhBa = lxrdhBa;
    }
}
