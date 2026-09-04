package com.tl.web.bjts.yj.model;

import com.tl.web.bjts.yj.model.domain.ShYdxx;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2017-11-17
 **/

public class TaskVo {

    private Date yswcsj;

    private Date ystqsj;

    //预审标志，时间戳
    private String ysbz;

    private String qyhgdm;

    //申报id
    private Long id;

    //申报类型(YSB、ZSSB)
    private String sbType;

    //纳税人电子档案号
    private String nsrdzdah;

    //申报种类代码
    private String sbzlDm;

    //预审类型
    private String ysType;

    //申报年月,所属时期？
    private String sbym;

    //预审结果
    private String ysjg;

    //流程实例id
    private String lcslid;

    //增值税报表是否已申报
    private String zzssbb;

    //申报次数
    private Integer sbcs;

    //预审提取次数
    private Integer ystqcs;


    //申报状态代码
    private String sbztDm;

    //申报业务表代码
    private String lcId;


    //报文摘要
    private String bwzy;

    //明文摘要
    private String mwzy;

    //申报批次
    private String sbpc;

    private String sbfs;

//    private BLOB sbbw;
    //申报报文
    private byte[] sbbw;

    //报文格式
    private String bwgs;

    //报文签名
    private String bwqm;


    //纳税人识别号
    private String nsrdjno;

    //海关代码
    private String cpcode;

    //税务机关代码
    private String swcode;

    //企业类型代码
    private String qylxDm;


    private Map<String,String> sbbws;

    private String ac_nsrsbh;

    private String ac_ysid;

    private String ac_yslb;

    private String ysFist;

    private String[] yslbMiddle = new String[]{};

    private String ysLast;

    private boolean sbqr;

    private boolean syncToYun;
    private String lzhj;
    private String fkxx;
    private String mdtsbId;

    private String sbyy;

    private Date fkrq;

    private Date sbsj;

    private String zzsbb;


    private List<ShYdxx> ydxxs;

    private Long tbpc;
    private String yjType;

    private String  qxswjgdm;

    private boolean isHaveYjxx;

    private boolean isSaveData2Bjts;

    private boolean isSaveData2Shzs;

    private Integer fileSize;

    private String wbjkYwlxCode;


    //以下两字段在预警2.0版本改造时使用 2019.07.24
    private String yjsbympc;

    private String yjsbny;

    private boolean isYjzbClosedTemp;
    //预警标志
    private String tqbz;
    private Date tqsj;
    //预警提取次数
    private Integer tqcs;

    public String getQyhgdm() {
        return this.qyhgdm;

    }

    public void setQyhgdm(String qyhgdm) {
        this.qyhgdm = qyhgdm;
    }

    public Date getTqsj() {
        return tqsj;
    }

    public void setTqsj(Date tqsj) {
        this.tqsj = tqsj;
    }

    public Integer getTqcs() {
        return tqcs;
    }

    public void setTqcs(Integer tqcs) {
        this.tqcs = tqcs;
    }

    public String getTqbz() {
        return tqbz;
    }

    public void setTqbz(String tqbz) {
        this.tqbz = tqbz;
    }

    public boolean isYjzbClosedTemp() {
        return isYjzbClosedTemp;
    }

    public void setYjzbClosedTemp(boolean yjzbClosedTemp) {
        isYjzbClosedTemp = yjzbClosedTemp;
    }

    public String getYjsbympc() {
        return yjsbympc;
    }

    public void setYjsbympc(String yjsbympc) {
        this.yjsbympc = yjsbympc;
    }

    public String getYjsbny() {
        return yjsbny;
    }

    public void setYjsbny(String yjsbny) {
        this.yjsbny = yjsbny;
    }

    public String getWbjkYwlxCode() {
        return wbjkYwlxCode;
    }

    public void setWbjkYwlxCode(String wbjkYwlxCode) {
        this.wbjkYwlxCode = wbjkYwlxCode;
    }

    public Date getYswcsj() {
        return yswcsj;
    }

    public void setYswcsj(Date yswcsj) {
        this.yswcsj = yswcsj;
    }

    public Date getYstqsj() {
        return ystqsj;
    }

    public void setYstqsj(Date ystqsj) {
        this.ystqsj = ystqsj;
    }

    public boolean isSaveData2Shzs() {
        return isSaveData2Shzs;
    }

    public void setSaveData2Shzs(boolean saveData2Shzs) {
        isSaveData2Shzs = saveData2Shzs;
    }

    public boolean isSaveData2Bjts() {
        return isSaveData2Bjts;
    }

    public void setSaveData2Bjts(boolean saveData2Bjts) {
        isSaveData2Bjts = saveData2Bjts;
    }

    public boolean isHaveYjxx() {
        return isHaveYjxx;
    }

    public void setHaveYjxx(boolean haveYjxx) {
        isHaveYjxx = haveYjxx;
    }

    public String getQxswjgdm() {
        return qxswjgdm;
    }

    public void setQxswjgdm(String qxswjgdm) {
        this.qxswjgdm = qxswjgdm;
    }

    public String getYjType() {
        return yjType;
    }

    public void setYjType(String yjType) {
        this.yjType = yjType;
    }

    public Long getTbpc() {
        return tbpc;
    }

    public void setTbpc(Long tbpc) {
        this.tbpc = tbpc;
    }

    public List<ShYdxx> getYdxxs() {
        return ydxxs;
    }

    public void setYdxxs(List<ShYdxx> ydxxs) {
        this.ydxxs = ydxxs;
    }

    public String getZzsbb() {
        return zzsbb;
    }

    public void setZzsbb(String zzsbb) {
        this.zzsbb = zzsbb;
    }

    public Date getSbsj() {
        return sbsj;
    }

    public void setSbsj(Date sbsj) {
        this.sbsj = sbsj;
    }

    public String getSbyy() {
        return sbyy;
    }

    public void setSbyy(String sbyy) {
        this.sbyy = sbyy;
    }

    public Date getFkrq() {
        return fkrq;
    }

    public void setFkrq(Date fkrq) {
        this.fkrq = fkrq;
    }

    public String getSbfs() {
        return sbfs;
    }

    public void setSbfs(String sbfs) {
        this.sbfs = sbfs;
    }

    public String getMdtsbId() {
        return mdtsbId;
    }

    public void setMdtsbId(String mdtsbId) {
        this.mdtsbId = mdtsbId;
    }

    public String getNsrdzdah() {
        return nsrdzdah;
    }

    public void setNsrdzdah(String nsrdzdah) {
        this.nsrdzdah = nsrdzdah;
    }

    public String getLcslid() {
        return lcslid;
    }

    public void setLcslid(String lcslid) {
        this.lcslid = lcslid;
    }

    public String getZzssbb() {
        return zzssbb;
    }

    public void setZzssbb(String zzssbb) {
        this.zzssbb = zzssbb;
    }

    public Integer getSbcs() {
        return sbcs;
    }

    public void setSbcs(Integer sbcs) {
        this.sbcs = sbcs;
    }

    public Integer getYstqcs() {
        return ystqcs;
    }

    public void setYstqcs(Integer ystqcs) {
        this.ystqcs = ystqcs;
    }

    public String getBwgs() {
        return bwgs;
    }

    public void setBwgs(String bwgs) {
        this.bwgs = bwgs;
    }

    public String getBwqm() {
        return bwqm;
    }

    public void setBwqm(String bwqm) {
        this.bwqm = bwqm;
    }

    public String getYsbz() {
        return ysbz;
    }

    public void setYsbz(String ysbz) {
        this.ysbz = ysbz;
    }

    public String getSbzlDm() {
        return sbzlDm;
    }

    public void setSbzlDm(String sbzlDm) {
        this.sbzlDm = sbzlDm;
    }

    public String getLzhj() {
        return lzhj;
    }

    public void setLzhj(String lzhj) {
        this.lzhj = lzhj;
    }

    public String getFkxx() {
        return fkxx;
    }

    public void setFkxx(String fkxx) {
        this.fkxx = fkxx;
    }

    public boolean isSyncToYun() {
        return syncToYun;
    }

    public void setSyncToYun(boolean syncToYun) {
        this.syncToYun = syncToYun;
    }

    public boolean isSbqr() {
        return sbqr;
    }

    public void setSbqr(boolean sbqr) {
        this.sbqr = sbqr;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSbType() {
        return sbType;
    }

    public void setSbType(String sbType) {
        this.sbType = sbType;
    }

    public String getYsType() {
        return ysType;
    }

    public void setYsType(String ysType) {
        this.ysType = ysType;
    }

    public String getSbym() {
        return sbym;
    }

    public void setSbym(String sbym) {
        this.sbym = sbym;
    }

    public String getCpcode() {
        return cpcode;
    }

    public void setCpcode(String cpcode) {
        this.cpcode = cpcode;
    }

    public String getQylxDm() {
        return qylxDm;
    }

    public void setQylxDm(String qylxDm) {
        this.qylxDm = qylxDm;
    }

    public String getYsjg() {
        return ysjg;
    }

    public void setYsjg(String ysjg) {
        this.ysjg = ysjg;
    }

    public String getSwcode() {
        return swcode;
    }

    public void setSwcode(String swcode) {
        this.swcode = swcode;
    }

    public String getSbztDm() {
        return sbztDm;
    }

    public void setSbztDm(String sbztDm) {
        this.sbztDm = sbztDm;
    }

    public String getNsrdjno() {
        return nsrdjno;
    }

    public void setNsrdjno(String nsrdjno) {
        this.nsrdjno = nsrdjno;
    }

    public String getBwzy() {
        return bwzy;
    }

    public void setBwzy(String bwzy) {
        this.bwzy = bwzy;
    }

    public String getMwzy() {
        return mwzy;
    }

    public void setMwzy(String mwzy) {
        this.mwzy = mwzy;
    }

    public String getLcId() {
        return lcId;
    }

    public void setLcId(String lcId) {
        this.lcId = lcId;
    }

    public String getSbpc() {
        return sbpc;
    }

    public void setSbpc(String sbpc) {
        this.sbpc = sbpc;
    }

    public byte[] getSbbw() {
        return sbbw;
    }

    public void setSbbw(byte[] sbbw) {
        this.sbbw = sbbw;
    }

    public Map<String, String> getSbbws() {
        return sbbws;
    }

    public void setSbbws(Map<String, String> sbbws) {
        this.sbbws = sbbws;
    }

    public String getAc_nsrsbh() {
        return ac_nsrsbh;
    }

    public void setAc_nsrsbh(String ac_nsrsbh) {
        this.ac_nsrsbh = ac_nsrsbh;
    }

    public String getAc_ysid() {
        return ac_ysid;
    }

    public void setAc_ysid(String ac_ysid) {
        this.ac_ysid = ac_ysid;
    }

    public String getAc_yslb() {
        return ac_yslb;
    }

    public void setAc_yslb(String ac_yslb) {
        this.ac_yslb = ac_yslb;
    }

    public String getYsFist() {
        return ysFist;
    }

    public void setYsFist(String ysFist) {
        this.ysFist = ysFist;
    }

    public String[] getYslbMiddle() {
        return yslbMiddle;
    }

    public void setYslbMiddle(String[] yslbMiddle) {
        this.yslbMiddle = yslbMiddle;
    }

    public String getYsLast() {
        return ysLast;
    }

    public void setYsLast(String ysLast) {
        this.ysLast = ysLast;
    }

    public Integer getFileSize() {
        return fileSize;
    }

    public void setFileSize(Integer fileSize) {
        this.fileSize = fileSize;
    }
}
