package com.tl.web.bjts.shzs.model.vo.ldlp;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.web.bjts.shzs.annotation.ConvertCode;
import com.tl.web.bjts.shzs.utils.ConstUtil;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * @Description: 报关单
 * @Author Neo Lin
 * @Date 2017/12/13 17:11
 */
public class BgdVo implements Serializable {

    private static final long serialVersionUID = 451215125132141541L;

    private String bgdNo;
    @ConvertCode(dtype = ConstUtil.DICT_HGCODE)
    private String hgcode;
    private String baNo;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    private Date ljDate;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    private Date sbDate;
    private String jydw;   //=qydm+jydwmc
    private String qydm;
    private String jydwmc;

    @ConvertCode(dtype = ConstUtil.DICT_TRANSTYPE)
    private String ysfs;
    private String tydh;
    private String fhdw; //= hzdw_dm+hzdwmc
    private String hzdwDm;
    private String hzdwmc;

    @ConvertCode(dtype = ConstUtil.DICT_TDCODE)
    private String tdcode;
    private String zmxz;
    @ConvertCode(dtype = ConstUtil.DICT_CJFSCODE)
    private String cjfs;
    private String yf;
    private String yfFlag;
    private String yfbz;
    private BigDecimal yfl;
    private String bf;
    private String bfFlag;
    private String bfbz;
    private BigDecimal bfl;
    private String zf;
    private String zfFlag;
    private String zfbz;
    private BigDecimal zfl;
    @ConvertCode(dtype = ConstUtil.DICT_GBCODE)
    private String gbcode;
    @ConvertCode(dtype = ConstUtil.DICT_ZYGCODE)
    private String zyg;
    @ConvertCode(dtype = ConstUtil.DICT_HYDCODE)
    private String hzdwdqdm;
    private String htxyNo;
    private String jhfs;

    // 境外收货人、运输工具名称及航次、许可证号
    private String xkzh;
    private String ysgjmc;

    private List<BgdItemVo> bgdItems;

    public String getBgdNo() {
        return bgdNo;
    }

    public void setBgdNo(String bgdNo) {
        this.bgdNo = bgdNo;
    }

    public String getHgcode() {
        return hgcode;
    }

    public void setHgcode(String hgcode) {
        this.hgcode = hgcode;
    }

    public String getBaNo() {
        return baNo;
    }

    public void setBaNo(String baNo) {
        this.baNo = baNo;
    }

    public Date getLjDate() {
        return ljDate;
    }

    public void setLjDate(Date ljDate) {
        this.ljDate = ljDate;
    }

    public Date getSbDate() {
        return sbDate;
    }

    public void setSbDate(Date sbDate) {
        this.sbDate = sbDate;
    }

    public String getJydw() {
        return qydm + "  " + jydwmc;
    }

    public void setJydw(String jydw) {
        this.jydw = jydw;
    }

    public String getQydm() {
        return qydm;
    }

    public void setQydm(String qydm) {
        this.qydm = qydm;
    }

    public String getJydwmc() {
        return jydwmc;
    }

    public void setJydwmc(String jydwmc) {
        this.jydwmc = jydwmc;
    }

    public String getYsfs() {
        return ysfs;
    }

    public void setYsfs(String ysfs) {
        this.ysfs = ysfs;
    }

    public String getTydh() {
        return tydh;
    }

    public void setTydh(String tydh) {
        this.tydh = tydh;
    }

    public String getFhdw() {
        return hzdwDm + "  " + hzdwmc;
    }

    public void setFhdw(String fhdw) {
        this.fhdw = fhdw;
    }

    public String getHzdwDm() {
        return hzdwDm;
    }

    public void setHzdwDm(String hzdwDm) {
        this.hzdwDm = hzdwDm;
    }

    public String getHzdwmc() {
        return hzdwmc;
    }

    public void setHzdwmc(String hzdwmc) {
        this.hzdwmc = hzdwmc;
    }

    public String getTdcode() {
        return tdcode;
    }

    public void setTdcode(String tdcode) {
        this.tdcode = tdcode;
    }

    public String getZmxz() {
        return zmxz;
    }

    public void setZmxz(String zmxz) {
        this.zmxz = zmxz;
    }

    public String getCjfs() {
        return cjfs;
    }

    public void setCjfs(String cjfs) {
        this.cjfs = cjfs;
    }

    public String getYf() {
        if (yfFlag != null && yfFlag != "" && !"0".equals(yfFlag)) {
            return String.format("%s/%s/%s", yfFlag, yfbz, yfl.toString());
        }
        return "";
    }

    public void setYf(String yf) {
        this.yf = yf;
    }

    public String getYfFlag() {
        return yfFlag;
    }

    public void setYfFlag(String yfFlag) {
        this.yfFlag = yfFlag;
    }

    public String getYfbz() {
        return yfbz;
    }

    public void setYfbz(String yfbz) {
        this.yfbz = yfbz;
    }

    public BigDecimal getYfl() {
        return yfl;
    }

    public void setYfl(BigDecimal yfl) {
        this.yfl = yfl;
    }

    public String getBf() {
        if (bfFlag != null && bfFlag != "" && !"0".equals(bfFlag)) {
            return String.format("%s/%s/%s", bfFlag, bfbz, bfl.toString());
        }
        return "";
    }

    public void setBf(String bf) {
        this.bf = bf;
    }

    public String getBfFlag() {
        return bfFlag;
    }

    public void setBfFlag(String bfFlag) {
        this.bfFlag = bfFlag;
    }

    public String getBfbz() {
        return bfbz;
    }

    public void setBfbz(String bfbz) {
        this.bfbz = bfbz;
    }

    public BigDecimal getBfl() {
        return bfl;
    }

    public void setBfl(BigDecimal bfl) {
        this.bfl = bfl;
    }

    public String getZf() {
        if (zfFlag != null && zfFlag != "" && !"0".equals(zfFlag)) {
            return String.format("%s/%s/%s", zfFlag, zfbz, zfl.toString());
        }
        return "";
    }

    public void setZf(String zf) {
        this.zf = zf;
    }

    public String getZfFlag() {
        return zfFlag;
    }

    public void setZfFlag(String zfFlag) {
        this.zfFlag = zfFlag;
    }

    public String getZfbz() {
        return zfbz;
    }

    public void setZfbz(String zfbz) {
        this.zfbz = zfbz;
    }

    public BigDecimal getZfl() {
        return zfl;
    }

    public void setZfl(BigDecimal zfl) {
        this.zfl = zfl;
    }

    public String getGbcode() {
        return gbcode;
    }

    public void setGbcode(String gbcode) {
        this.gbcode = gbcode;
    }

    public String getZyg() {
        return zyg;
    }

    public void setZyg(String zyg) {
        this.zyg = zyg;
    }

    public String getHzdwdqdm() {
        return hzdwdqdm;
    }

    public void setHzdwdqdm(String hzdwdqdm) {
        this.hzdwdqdm = hzdwdqdm;
    }

    public String getHtxyNo() {
        return htxyNo;
    }

    public void setHtxyNo(String htxyNo) {
        this.htxyNo = htxyNo;
    }

    public String getJhfs() {
        return jhfs;
    }

    public void setJhfs(String jhfs) {
        this.jhfs = jhfs;
    }

    public List<BgdItemVo> getBgdItems() {
        return bgdItems;
    }

    public void setBgdItems(List<BgdItemVo> bgdItems) {
        this.bgdItems = bgdItems;
    }

    public String getXkzh() {
        return xkzh;
    }

    public void setXkzh(String xkzh) {
        this.xkzh = xkzh;
    }

    public String getYsgjmc() {
        return ysgjmc;
    }

    public void setYsgjmc(String ysgjmc) {
        this.ysgjmc = ysgjmc;
    }
}
