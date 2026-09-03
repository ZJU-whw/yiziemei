package com.tl.bjts.sw.model.vo.sbxx;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.bjts.sw.utils.TlConst;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * @Description:  发票信息
 * @Author Neo Lin
 * @Date  2017/12/13 17:10
 */
public class FpxxVo implements Serializable{
    private static final long serialVersionUID = 42187641254463215L;
    private String fpdm;
    private String fphm;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    private Date kprq;
    private String fpzt;
    private String gfsbh;
    private String xfsbh;
    private String gfmc;
    private String xfmc;
    private String gfdzdh;
    private String xfdzdh;
    private String gfyhzh;
    private String xfyhzh;
    private BigDecimal je;
    private BigDecimal se;
    private BigDecimal jshj;
    private String bz;
    private String kpr;
    private String skr;
    private String fhr;
    private String zfbz;
    private List<FpHwxxVo> hwxxs;

    public String getFpdm() {
        return fpdm;
    }

    public void setFpdm(String fpdm) {
        this.fpdm = fpdm;
    }

    public String getFphm() {
        return fphm;
    }

    public void setFphm(String fphm) {
        this.fphm = fphm;
    }

    public Date getKprq() {
        return kprq;
    }

    public void setKprq(Date kprq) {
        this.kprq = kprq;
    }

    public String getFpzt() {
        if(fpzt == null || "".equals(fpzt)){
            return "";
        }
        if("0".equals(fpzt)){
            return TlConst.FPZT_NORMAL;
        }
        if("1".equals(fpzt)){
            return TlConst.FPZT_OUT_OF_CONTROL;
        }
        if("2".equals(fpzt)){
            return TlConst.FPZT_INVALID;
        }
        if("3".equals(fpzt) ||"4".equals(fpzt)||"5".equals(fpzt)){
            return TlConst.FPZT_ABNORMAL;
        }
        if("6".equals(fpzt)){
            return TlConst.FPZT_DEFICIT_REDUCE;
        }
        return "";
    }

    public void setFpzt(String fpzt) {
        this.fpzt = fpzt;
    }

    public String getGfsbh() {
        return gfsbh;
    }

    public void setGfsbh(String gfsbh) {
        this.gfsbh = gfsbh;
    }

    public String getXfsbh() {
        return xfsbh;
    }

    public void setXfsbh(String xfsbh) {
        this.xfsbh = xfsbh;
    }

    public String getGfmc() {
        return gfmc;
    }

    public void setGfmc(String gfmc) {
        this.gfmc = gfmc;
    }

    public String getXfmc() {
        return xfmc;
    }

    public void setXfmc(String xfmc) {
        this.xfmc = xfmc;
    }

    public String getGfdzdh() {
        return gfdzdh;
    }

    public void setGfdzdh(String gfdzdh) {
        this.gfdzdh = gfdzdh;
    }

    public String getXfdzdh() {
        return xfdzdh;
    }

    public void setXfdzdh(String xfdzdh) {
        this.xfdzdh = xfdzdh;
    }

    public String getGfyhzh() {
        return gfyhzh;
    }

    public void setGfyhzh(String gfyhzh) {
        this.gfyhzh = gfyhzh;
    }

    public String getXfyhzh() {
        return xfyhzh;
    }

    public void setXfyhzh(String xfyhzh) {
        this.xfyhzh = xfyhzh;
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

    public BigDecimal getJshj() {
        return jshj;
    }

    public void setJshj(BigDecimal jshj) {
        this.jshj = jshj;
    }

    public String getBz() {
        return bz;
    }

    public void setBz(String bz) {
        this.bz = bz;
    }

    public String getKpr() {
        return kpr;
    }

    public void setKpr(String kpr) {
        this.kpr = kpr;
    }

    public String getSkr() {
        return skr;
    }

    public void setSkr(String skr) {
        this.skr = skr;
    }

    public String getFhr() {
        return fhr;
    }

    public void setFhr(String fhr) {
        this.fhr = fhr;
    }

    public List<FpHwxxVo> getHwxxs() {
        return hwxxs;
    }

    public void setHwxxs(List<FpHwxxVo> hwxxs) {
        this.hwxxs = hwxxs;
    }

    public String getZfbz() {
        return zfbz;
    }

    public void setZfbz(String zfbz) {
        this.zfbz = zfbz;
    }
}
