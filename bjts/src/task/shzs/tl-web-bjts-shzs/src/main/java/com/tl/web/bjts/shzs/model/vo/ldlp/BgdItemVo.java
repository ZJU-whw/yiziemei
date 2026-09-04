package com.tl.web.bjts.shzs.model.vo.ldlp;

import com.tl.web.bjts.shzs.annotation.ConvertCode;
import com.tl.web.bjts.shzs.utils.ConstUtil;

import java.io.Serializable;
import java.math.BigDecimal;

public class BgdItemVo implements Serializable{
    private static final long serialVersionUID = 548653211451453486L;
    private String cmcode;

    private String hgcmname;

    private String sldw;   //a little egg pain = bgQnt+dwcode+\n+bgQnt2+dwcode2

    private BigDecimal bgQnt;

    @ConvertCode(dtype = ConstUtil.DICT_DWCODE)
    private String dwcode;

    private BigDecimal bgQnt2;

    @ConvertCode(dtype = ConstUtil.DICT_DWCODE)
    private String dwcode2;

    @ConvertCode(dtype = ConstUtil.DICT_GBCODE)
    private String zzmdg;

    private BigDecimal usdAmt;

    @ConvertCode(dtype = ConstUtil.DICT_BICODE)
    private String cjbz;



    public String getCmcode() {
        return cmcode;
    }

    public void setCmcode(String cmcode) {
        this.cmcode = cmcode;
    }


    public String getHgcmname() {
        return hgcmname;
    }

    public void setHgcmname(String hgcmname) {
        this.hgcmname = hgcmname;
    }


    public String getSldw() {
        String sldw1 = "";
        String sldw2 = "";
        if (bgQnt != null && !bgQnt.toString().equals("0")) {
            sldw1 = String.format("%s %s", bgQnt.toString(), dwcode);
        }
        if (bgQnt2 != null && !bgQnt2.toString().equals("0")) {
            sldw2 = String.format("%s %s", bgQnt2.toString(), dwcode2);
        }
        return sldw2 == null ? sldw1 : String.format("%s<br>%s",sldw1,sldw2);
    }

    public void setSldw(String sldw) {
        this.sldw = sldw;
    }

    public BigDecimal getBgQnt() {
        return bgQnt;
    }

    public void setBgQnt(BigDecimal bgQnt) {
        this.bgQnt = bgQnt;
    }

    public String getDwcode() {
        return dwcode;
    }

    public void setDwcode(String dwcode) {
        this.dwcode = dwcode;
    }

    public BigDecimal getBgQnt2() {
        return bgQnt2;
    }

    public void setBgQnt2(BigDecimal bgQnt2) {
        this.bgQnt2 = bgQnt2;
    }

    public String getDwcode2() {
        return dwcode2;
    }

    public void setDwcode2(String dwcode2) {
        this.dwcode2 = dwcode2;
    }

    public String getZzmdg() {
        return zzmdg;
    }

    public void setZzmdg(String zzmdg) {
        this.zzmdg = zzmdg;
    }

    public BigDecimal getUsdAmt() {
        return usdAmt;
    }

    public void setUsdAmt(BigDecimal usdAmt) {
        this.usdAmt = usdAmt;
    }

    public String getCjbz() {
        return cjbz;
    }

    public void setCjbz(String cjbz) {
        this.cjbz = cjbz;
    }
}
