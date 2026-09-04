package com.tl.web.bjts.shzs.model.vo.ldlp;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.tl.web.bjts.shzs.annotation.ConvertCode;
import com.tl.web.bjts.shzs.utils.ConstUtil;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * @描述: 报关单主表数据vo
 * @作者: likun
 * @时间: 2022/4/26 13:42
 */
public class BgdMainVO {
    private String entryId; // 海关编号  CKBGDH|
    private String incode; // 业务编号  |
    private String cnsnTradeScc; // 境内发货人  hgqy_dm|
    private String consignorCname; // 境内发货人  jydwmc|
    private String iEPort; // 出境关别  HGGQKA_DM|
    @ConvertCode(dtype = ConstUtil.DICT_HGCODE)
    private String iEPortName; // 出境关别  |
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    private Date iEDate; // 出口日期  CKRQ_1|
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+8")
    private Date dDate; // 申报日期  HGCKHWBGDSBRQ|
    private String manualNo; // 备案号  BAH|
    private String consigneeEname; // 境外收货人  |
    private String cusTrafMode; // 运输方式  YSFS_DM|
    @ConvertCode(dtype = ConstUtil.DICT_TRANSTYPE)
    private String cusTrafModeName; // 运输方式  |
    private String trafName ; // 运输工具名称及航次  YSGJMC + HCH|
    private String billNo; // 提运单号  TYDH|
    private String ownerScc; // 生产销售单位  HZDWDM|
    private String ownerName; // 生产销售单位  HZDWMC|
    private String supvModeCdde; // 监管方式  JGFS_DM|
    @ConvertCode(dtype = ConstUtil.DICT_TDCODE)
    private String supvModeCddeName; // 监管方式  |
    private String cutMode; // 征免性质  ZMXZ_DM|
    @ConvertCode(dtype = ConstUtil.DICT_ZMXZCODE)
    private String cutModeName; // 征免性质
    private String licenseNo; // 许可证号  XKZH|
    private String contrNo; // 合同协议号  CKHTH|
    private String cusTradeNationCode; // 贸易国（地区） MYGDQSZ_DM |
    @ConvertCode(dtype = ConstUtil.DICT_GBCODE)
    private String cusTradeNationCodeName; // 贸易国（地区）  |
    private String cusTradeCountry; // 运抵国（地区） ZZMDGDQSZ_DM |
    @ConvertCode(dtype = ConstUtil.DICT_GBCODE)
    private String cusTradeCountryName; // 运抵国（地区）  |
    private String distinatePort; // 指运港  ZYG_DM|
    @ConvertCode(dtype = ConstUtil.DICT_ZYGCODE)
    private String distinatePortName; // 指运港  |
    private String despPortCode; // 出境口岸  HGGQKA_DM|
    @ConvertCode(dtype = ConstUtil.DICT_HGCODE)
    private String despPortCodeName; // 出境口岸  |
    private String wrapType; // 包装种类  HGBZZL_DM|
    @ConvertCode(dtype = ConstUtil.DICT_BZZLCODE)
    private String wrapTypeName; // 包装种类
    private String packNo; // 件数  JS_1|
    private BigDecimal grossWt; // 毛重（千克） MZ_2 |
    private BigDecimal netWt; // 净重（千克） JZ |
    private String transMode; // 成交方式 CJHGHBSZ_DM |
    @ConvertCode(dtype = ConstUtil.DICT_CJFSCODE)
    private String transModeName; // 成交方式  |
    private String yfZh; // 运费  YFHGHBSZ_DM + YFHL|
    private String bfZh; // 保费  BFHGHBSZ_DM + BFHL|
    private String zfZh; // 杂费  ZFHGHBSZ_DM + ZFHL|
    private String attaDocuCdstr; // 随附单证  |
    private String markNo; // 标记唛码及备注 BSM |
    private String noteS; // 标记唛码及备注  LXBZ |
    private List<BgdMxVO> hwxxs; // 货物信息数组

    public String getEntryId() {
        return entryId;
    }

    public void setEntryId(String entryId) {
        this.entryId = entryId;
    }

    public String getIncode() {
        return incode;
    }

    public void setIncode(String incode) {
        this.incode = incode;
    }

    public String getCnsnTradeScc() {
        return cnsnTradeScc;
    }

    public void setCnsnTradeScc(String cnsnTradeScc) {
        this.cnsnTradeScc = cnsnTradeScc;
    }

    public String getConsignorCname() {
        return consignorCname;
    }

    public void setConsignorCname(String consignorCname) {
        this.consignorCname = consignorCname;
    }

    public String getiEPort() {
        return iEPort;
    }

    public void setiEPort(String iEPort) {
        this.iEPort = iEPort;
    }

    public String getiEPortName() {
        return iEPortName;
    }

    public void setIEPortName(String iEPortName) {
        this.iEPortName = iEPortName;
    }

    public String getIEPortName() {
        return iEPortName;
    }

    public void setiEPortName(String iEPortName) {
        this.iEPortName = iEPortName;
    }

    public Date getiEDate() {
        return iEDate;
    }

    public void setiEDate(Date iEDate) {
        this.iEDate = iEDate;
    }

    public Date getdDate() {
        return dDate;
    }

    public void setdDate(Date dDate) {
        this.dDate = dDate;
    }

    public String getManualNo() {
        return manualNo;
    }

    public void setManualNo(String manualNo) {
        this.manualNo = manualNo;
    }

    public String getConsigneeEname() {
        return consigneeEname;
    }

    public void setConsigneeEname(String consigneeEname) {
        this.consigneeEname = consigneeEname;
    }

    public String getCusTrafMode() {
        return cusTrafMode;
    }

    public void setCusTrafMode(String cusTrafMode) {
        this.cusTrafMode = cusTrafMode;
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

    public String getOwnerScc() {
        return ownerScc;
    }

    public void setOwnerScc(String ownerScc) {
        this.ownerScc = ownerScc;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getSupvModeCdde() {
        return supvModeCdde;
    }

    public void setSupvModeCdde(String supvModeCdde) {
        this.supvModeCdde = supvModeCdde;
    }

    public String getSupvModeCddeName() {
        return supvModeCddeName;
    }

    public void setSupvModeCddeName(String supvModeCddeName) {
        this.supvModeCddeName = supvModeCddeName;
    }

    public String getCutMode() {
        return cutMode;
    }

    public void setCutMode(String cutMode) {
        this.cutMode = cutMode;
    }

    public String getCutModeName() {
        return cutModeName;
    }

    public void setCutModeName(String cutModeName) {
        this.cutModeName = cutModeName;
    }

    public String getLicenseNo() {
        return licenseNo;
    }

    public void setLicenseNo(String licenseNo) {
        this.licenseNo = licenseNo;
    }

    public String getContrNo() {
        return contrNo;
    }

    public void setContrNo(String contrNo) {
        this.contrNo = contrNo;
    }

    public String getCusTradeNationCode() {
        return cusTradeNationCode;
    }

    public void setCusTradeNationCode(String cusTradeNationCode) {
        this.cusTradeNationCode = cusTradeNationCode;
    }

    public String getCusTradeNationCodeName() {
        return cusTradeNationCodeName;
    }

    public void setCusTradeNationCodeName(String cusTradeNationCodeName) {
        this.cusTradeNationCodeName = cusTradeNationCodeName;
    }

    public String getCusTradeCountry() {
        return cusTradeCountry;
    }

    public void setCusTradeCountry(String cusTradeCountry) {
        this.cusTradeCountry = cusTradeCountry;
    }

    public String getCusTradeCountryName() {
        return cusTradeCountryName;
    }

    public void setCusTradeCountryName(String cusTradeCountryName) {
        this.cusTradeCountryName = cusTradeCountryName;
    }

    public String getDistinatePort() {
        return distinatePort;
    }

    public void setDistinatePort(String distinatePort) {
        this.distinatePort = distinatePort;
    }

    public String getDistinatePortName() {
        return distinatePortName;
    }

    public void setDistinatePortName(String distinatePortName) {
        this.distinatePortName = distinatePortName;
    }

    public String getDespPortCode() {
        return despPortCode;
    }

    public void setDespPortCode(String despPortCode) {
        this.despPortCode = despPortCode;
    }

    public String getDespPortCodeName() {
        return despPortCodeName;
    }

    public void setDespPortCodeName(String despPortCodeName) {
        this.despPortCodeName = despPortCodeName;
    }

    public String getWrapType() {
        return wrapType;
    }

    public void setWrapType(String wrapType) {
        this.wrapType = wrapType;
    }

    public String getWrapTypeName() {
        return wrapTypeName;
    }

    public void setWrapTypeName(String wrapTypeName) {
        this.wrapTypeName = wrapTypeName;
    }

    public String getPackNo() {
        return packNo;
    }

    public void setPackNo(String packNo) {
        this.packNo = packNo;
    }

    public BigDecimal getGrossWt() {
        return grossWt;
    }

    public void setGrossWt(BigDecimal grossWt) {
        this.grossWt = grossWt;
    }

    public BigDecimal getNetWt() {
        return netWt;
    }

    public void setNetWt(BigDecimal netWt) {
        this.netWt = netWt;
    }

    public String getTransMode() {
        return transMode;
    }

    public void setTransMode(String transMode) {
        this.transMode = transMode;
    }

    public String getTransModeName() {
        return transModeName;
    }

    public void setTransModeName(String transModeName) {
        this.transModeName = transModeName;
    }

    public String getYfZh() {
        return yfZh;
    }

    public void setYfZh(String yfZh) {
        this.yfZh = yfZh;
    }

    public String getBfZh() {
        return bfZh;
    }

    public void setBfZh(String bfZh) {
        this.bfZh = bfZh;
    }

    public String getZfZh() {
        return zfZh;
    }

    public void setZfZh(String zfZh) {
        this.zfZh = zfZh;
    }

    public String getAttaDocuCdstr() {
        return attaDocuCdstr;
    }

    public void setAttaDocuCdstr(String attaDocuCdstr) {
        this.attaDocuCdstr = attaDocuCdstr;
    }

    public String getMarkNo() {
        return markNo;
    }

    public void setMarkNo(String markNo) {
        this.markNo = markNo;
    }

    public String getNoteS() {
        return noteS;
    }

    public void setNoteS(String noteS) {
        this.noteS = noteS;
    }

    public List<BgdMxVO> getHwxxs() {
        return hwxxs;
    }

    public void setHwxxs(List<BgdMxVO> hwxxs) {
        this.hwxxs = hwxxs;
    }
}
