package com.tl.bjts.sw.model.vo.sbxx;


import com.tl.bjts.sw.annotation.ConvertCode;
import com.tl.bjts.sw.utils.TlConst;

import java.math.BigDecimal;

/**
 * @描述: 报关单明细数据vo
 * @作者: likun
 * @时间: 2022/4/26 13:42
 */
public class BgdMxVO {

    private String gNo; // 项号  |
    private String codeTs; // 商品编号   CKSP_DM|
    private String gName; // 商品名称及规格型号  CKSPMC|
    private String gModel; // 商品名称及规格型号  GGXH|
    private BigDecimal qty1; // 数量及单位(第一)  CKSL|
    @ConvertCode(dtype = TlConst.DICT_DWCODE)
    private String unit1Name; // 数量及单位 (第一) DYJLDW_DM|
    private BigDecimal qty2; // 数量及单位(第二)  DECKSL|
    @ConvertCode(dtype = TlConst.DICT_DWCODE)
    private String unit2Name; // 数量及单位(第二)  DEJLDW_DM|
    private BigDecimal gQty; // 数量及单位（成交）SBSL_1  |
    @ConvertCode(dtype = TlConst.DICT_DWCODE)
    private String gUnitName; // 数量及单位（成交）  SBJLDW_DM|
    private BigDecimal declPrice; // 单价  SBDJ|
    private BigDecimal declTotal; // 总价  CJZJ|
    @ConvertCode(dtype = TlConst.DICT_BICODE)
    private String tradeCurrName; // 币制  CJHGHBSZ_DM|
    @ConvertCode(dtype = TlConst.DICT_GBCODE)
    private String cusOriginCountryName; // 原产国（地区） MYGDQSZ_DM |
    @ConvertCode(dtype = TlConst.DICT_GBCODE)
    private String destinationCountryName; // 最终目的国（地区） ZZMDGDQSZ_DM |
    @ConvertCode(dtype = TlConst.DICT_HYDCODE)
    private String districtCodeName; // 境内货源地  HZDWDQ_DM|
    @ConvertCode(dtype = TlConst.DICT_ZMXZCODE)
    private String dutyModeName; // 征免方式  ZMXZ_DM

    public String getgNo() {
        return gNo;
    }

    public void setgNo(String gNo) {
        this.gNo = gNo;
    }

    public String getCodeTs() {
        return codeTs;
    }

    public void setCodeTs(String codeTs) {
        this.codeTs = codeTs;
    }

    public String getgName() {
        return gName;
    }

    public void setgName(String gName) {
        this.gName = gName;
    }

    public String getgModel() {
        return gModel;
    }

    public void setgModel(String gModel) {
        this.gModel = gModel;
    }

    public BigDecimal getQty1() {
        return qty1;
    }

    public void setQty1(BigDecimal qty1) {
        this.qty1 = qty1;
    }

    public String getUnit1Name() {
        return unit1Name;
    }

    public void setUnit1Name(String unit1Name) {
        this.unit1Name = unit1Name;
    }

    public BigDecimal getQty2() {
        return qty2;
    }

    public void setQty2(BigDecimal qty2) {
        this.qty2 = qty2;
    }

    public String getUnit2Name() {
        return unit2Name;
    }

    public void setUnit2Name(String unit2Name) {
        this.unit2Name = unit2Name;
    }

    public BigDecimal getgQty() {
        return gQty;
    }

    public void setgQty(BigDecimal gQty) {
        this.gQty = gQty;
    }

    public String getgUnitName() {
        return gUnitName;
    }

    public void setgUnitName(String gUnitName) {
        this.gUnitName = gUnitName;
    }

    public BigDecimal getDeclPrice() {
        return declPrice;
    }

    public void setDeclPrice(BigDecimal declPrice) {
        this.declPrice = declPrice;
    }

    public BigDecimal getDeclTotal() {
        return declTotal;
    }

    public void setDeclTotal(BigDecimal declTotal) {
        this.declTotal = declTotal;
    }

    public String getTradeCurrName() {
        return tradeCurrName;
    }

    public void setTradeCurrName(String tradeCurrName) {
        this.tradeCurrName = tradeCurrName;
    }

    public String getCusOriginCountryName() {
        return cusOriginCountryName;
    }

    public void setCusOriginCountryName(String cusOriginCountryName) {
        this.cusOriginCountryName = cusOriginCountryName;
    }

    public String getDestinationCountryName() {
        return destinationCountryName;
    }

    public void setDestinationCountryName(String destinationCountryName) {
        this.destinationCountryName = destinationCountryName;
    }

    public String getDistrictCodeName() {
        return districtCodeName;
    }

    public void setDistrictCodeName(String districtCodeName) {
        this.districtCodeName = districtCodeName;
    }

    public String getDutyModeName() {
        return dutyModeName;
    }

    public void setDutyModeName(String dutyModeName) {
        this.dutyModeName = dutyModeName;
    }
}
