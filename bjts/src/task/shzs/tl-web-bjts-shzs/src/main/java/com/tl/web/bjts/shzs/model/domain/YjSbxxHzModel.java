package com.tl.web.bjts.shzs.model.domain;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Table(name = "TL_ADMIN.YJ_SBXX_HZ")
public class YjSbxxHzModel implements Serializable {
    @Id
    @Column(name = "ID")
    private Long id;

    @Column(name = "NSRDZDAH")
    private BigDecimal nsrdzdah;

    @Column(name = "SBYWB_DM")
    private String sbywbDm;

    @Column(name = "SSSQ")
    private String sssq;

    @Column(name = "SBPC")
    private Integer sbpc;

    @Column(name = "SBRQ")
    private Date sbrq;

    @Column(name = "SBZT_DM")
    private String sbztDm;

    @Column(name = "LZHJ")
    private String lzhj;

    @Column(name = "FKRQ")
    private Date fkrq;

    @Column(name = "FKXX")
    private String fkxx;

    @Column(name = "BZ")
    private String bz;

    @Column(name = "CJRQ")
    private Date cjrq;

    @Column(name = "XGRQ")
    private Date xgrq;

    @Column(name = "TQBZ")
    private String tqbz;

    @Column(name = "TQSJ")
    private Date tqsj;

    @Column(name = "TQCS")
    private Integer tqcs;

    @Column(name = "SBYY")
    private String sbyy;

    @Column(name = "YXJ")
    private Integer yxj;

    @Column(name = "SBSJ")
    private Date sbsj;

    @Column(name = "TBSJ")
    private Date tbsj;

    @Column(name = "LCSLID")
    private String lcslid;

    @Column(name = "TBCS")
    private Integer tbcs;

    @Column(name = "SBZL_DM")
    private String sbzlDm;

    @Column(name = "SBTYPE")
    private String sbtype;

    @Column(name = "YSBZ")
    private String ysbz;

    @Column(name = "YSTQSJ")
    private Date ystqsj;

    @Column(name = "YSWCSJ")
    private Date yswcsj;

    @Column(name = "YSTQCS")
    private Integer ystqcs;

    @Column(name = "BWZY")
    private String bwzy;

    @Column(name = "YSJG")
    private String ysjg;

    @Column(name = "SBR")
    private String sbr;

    @Column(name = "SBFS")
    private String sbfs;

    @Column(name = "SBCS")
    private Integer sbcs;

    @Column(name = "ZZSBB")
    private String zzsbb;

    @Column(name = "UUID")
    private String uuid;

    private static final long serialVersionUID = 1L;

    /**
     * @return ID
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return NSRDZDAH
     */
    public BigDecimal getNsrdzdah() {
        return nsrdzdah;
    }

    /**
     * @param nsrdzdah
     */
    public void setNsrdzdah(BigDecimal nsrdzdah) {
        this.nsrdzdah = nsrdzdah;
    }

    /**
     * @return SBYWB_DM
     */
    public String getSbywbDm() {
        return sbywbDm;
    }

    /**
     * @param sbywbDm
     */
    public void setSbywbDm(String sbywbDm) {
        this.sbywbDm = sbywbDm == null ? null : sbywbDm.trim();
    }

    /**
     * @return SSSQ
     */
    public String getSssq() {
        return sssq;
    }

    /**
     * @param sssq
     */
    public void setSssq(String sssq) {
        this.sssq = sssq == null ? null : sssq.trim();
    }

    /**
     * @return SBPC
     */
    public Integer getSbpc() {
        return sbpc;
    }

    /**
     * @param sbpc
     */
    public void setSbpc(Integer sbpc) {
        this.sbpc = sbpc;
    }

    /**
     * @return SBRQ
     */
    public Date getSbrq() {
        return sbrq;
    }

    /**
     * @param sbrq
     */
    public void setSbrq(Date sbrq) {
        this.sbrq = sbrq;
    }

    /**
     * @return SBZT_DM
     */
    public String getSbztDm() {
        return sbztDm;
    }

    /**
     * @param sbztDm
     */
    public void setSbztDm(String sbztDm) {
        this.sbztDm = sbztDm == null ? null : sbztDm.trim();
    }

    /**
     * @return LZHJ
     */
    public String getLzhj() {
        return lzhj;
    }

    /**
     * @param lzhj
     */
    public void setLzhj(String lzhj) {
        this.lzhj = lzhj == null ? null : lzhj.trim();
    }

    /**
     * @return FKRQ
     */
    public Date getFkrq() {
        return fkrq;
    }

    /**
     * @param fkrq
     */
    public void setFkrq(Date fkrq) {
        this.fkrq = fkrq;
    }

    /**
     * @return FKXX
     */
    public String getFkxx() {
        return fkxx;
    }

    /**
     * @param fkxx
     */
    public void setFkxx(String fkxx) {
        this.fkxx = fkxx == null ? null : fkxx.trim();
    }

    /**
     * @return BZ
     */
    public String getBz() {
        return bz;
    }

    /**
     * @param bz
     */
    public void setBz(String bz) {
        this.bz = bz == null ? null : bz.trim();
    }

    /**
     * @return CJRQ
     */
    public Date getCjrq() {
        return cjrq;
    }

    /**
     * @param cjrq
     */
    public void setCjrq(Date cjrq) {
        this.cjrq = cjrq;
    }

    /**
     * @return XGRQ
     */
    public Date getXgrq() {
        return xgrq;
    }

    /**
     * @param xgrq
     */
    public void setXgrq(Date xgrq) {
        this.xgrq = xgrq;
    }

    /**
     * @return TQBZ
     */
    public String getTqbz() {
        return tqbz;
    }

    /**
     * @param tqbz
     */
    public void setTqbz(String tqbz) {
        this.tqbz = tqbz == null ? null : tqbz.trim();
    }

    /**
     * @return TQSJ
     */
    public Date getTqsj() {
        return tqsj;
    }

    /**
     * @param tqsj
     */
    public void setTqsj(Date tqsj) {
        this.tqsj = tqsj;
    }

    /**
     * @return TQCS
     */
    public Integer getTqcs() {
        return tqcs;
    }

    /**
     * @param tqcs
     */
    public void setTqcs(Integer tqcs) {
        this.tqcs = tqcs;
    }

    /**
     * @return SBYY
     */
    public String getSbyy() {
        return sbyy;
    }

    /**
     * @param sbyy
     */
    public void setSbyy(String sbyy) {
        this.sbyy = sbyy == null ? null : sbyy.trim();
    }

    /**
     * @return YXJ
     */
    public Integer getYxj() {
        return yxj;
    }

    /**
     * @param yxj
     */
    public void setYxj(Integer yxj) {
        this.yxj = yxj;
    }

    /**
     * @return SBSJ
     */
    public Date getSbsj() {
        return sbsj;
    }

    /**
     * @param sbsj
     */
    public void setSbsj(Date sbsj) {
        this.sbsj = sbsj;
    }

    /**
     * @return TBSJ
     */
    public Date getTbsj() {
        return tbsj;
    }

    /**
     * @param tbsj
     */
    public void setTbsj(Date tbsj) {
        this.tbsj = tbsj;
    }

    /**
     * @return LCSLID
     */
    public String getLcslid() {
        return lcslid;
    }

    /**
     * @param lcslid
     */
    public void setLcslid(String lcslid) {
        this.lcslid = lcslid == null ? null : lcslid.trim();
    }

    /**
     * @return TBCS
     */
    public Integer getTbcs() {
        return tbcs;
    }

    /**
     * @param tbcs
     */
    public void setTbcs(Integer tbcs) {
        this.tbcs = tbcs;
    }

    /**
     * @return SBZL_DM
     */
    public String getSbzlDm() {
        return sbzlDm;
    }

    /**
     * @param sbzlDm
     */
    public void setSbzlDm(String sbzlDm) {
        this.sbzlDm = sbzlDm == null ? null : sbzlDm.trim();
    }

    /**
     * @return SBTYPE
     */
    public String getSbtype() {
        return sbtype;
    }

    /**
     * @param sbtype
     */
    public void setSbtype(String sbtype) {
        this.sbtype = sbtype == null ? null : sbtype.trim();
    }

    /**
     * @return YSBZ
     */
    public String getYsbz() {
        return ysbz;
    }

    /**
     * @param ysbz
     */
    public void setYsbz(String ysbz) {
        this.ysbz = ysbz == null ? null : ysbz.trim();
    }

    /**
     * @return YSTQSJ
     */
    public Date getYstqsj() {
        return ystqsj;
    }

    /**
     * @param ystqsj
     */
    public void setYstqsj(Date ystqsj) {
        this.ystqsj = ystqsj;
    }

    /**
     * @return YSWCSJ
     */
    public Date getYswcsj() {
        return yswcsj;
    }

    /**
     * @param yswcsj
     */
    public void setYswcsj(Date yswcsj) {
        this.yswcsj = yswcsj;
    }

    /**
     * @return YSTQCS
     */
    public Integer getYstqcs() {
        return ystqcs;
    }

    /**
     * @param ystqcs
     */
    public void setYstqcs(Integer ystqcs) {
        this.ystqcs = ystqcs;
    }

    /**
     * @return BWZY
     */
    public String getBwzy() {
        return bwzy;
    }

    /**
     * @param bwzy
     */
    public void setBwzy(String bwzy) {
        this.bwzy = bwzy == null ? null : bwzy.trim();
    }

    /**
     * @return YSJG
     */
    public String getYsjg() {
        return ysjg;
    }

    /**
     * @param ysjg
     */
    public void setYsjg(String ysjg) {
        this.ysjg = ysjg == null ? null : ysjg.trim();
    }

    /**
     * @return SBR
     */
    public String getSbr() {
        return sbr;
    }

    /**
     * @param sbr
     */
    public void setSbr(String sbr) {
        this.sbr = sbr == null ? null : sbr.trim();
    }

    /**
     * @return SBFS
     */
    public String getSbfs() {
        return sbfs;
    }

    /**
     * @param sbfs
     */
    public void setSbfs(String sbfs) {
        this.sbfs = sbfs == null ? null : sbfs.trim();
    }

    /**
     * @return SBCS
     */
    public Integer getSbcs() {
        return sbcs;
    }

    /**
     * @param sbcs
     */
    public void setSbcs(Integer sbcs) {
        this.sbcs = sbcs;
    }

    /**
     * @return ZZSBB
     */
    public String getZzsbb() {
        return zzsbb;
    }

    /**
     * @param zzsbb
     */
    public void setZzsbb(String zzsbb) {
        this.zzsbb = zzsbb == null ? null : zzsbb.trim();
    }

    /**
     * @return UUID
     */
    public String getUuid() {
        return uuid;
    }

    /**
     * @param uuid
     */
    public void setUuid(String uuid) {
        this.uuid = uuid == null ? null : uuid.trim();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(getClass().getSimpleName());
        sb.append(" [");
        sb.append("Hash = ").append(hashCode());
        sb.append(", id=").append(id);
        sb.append(", nsrdzdah=").append(nsrdzdah);
        sb.append(", sbywbDm=").append(sbywbDm);
        sb.append(", sssq=").append(sssq);
        sb.append(", sbpc=").append(sbpc);
        sb.append(", sbrq=").append(sbrq);
        sb.append(", sbztDm=").append(sbztDm);
        sb.append(", lzhj=").append(lzhj);
        sb.append(", fkrq=").append(fkrq);
        sb.append(", fkxx=").append(fkxx);
        sb.append(", bz=").append(bz);
        sb.append(", cjrq=").append(cjrq);
        sb.append(", xgrq=").append(xgrq);
        sb.append(", tqbz=").append(tqbz);
        sb.append(", tqsj=").append(tqsj);
        sb.append(", tqcs=").append(tqcs);
        sb.append(", sbyy=").append(sbyy);
        sb.append(", yxj=").append(yxj);
        sb.append(", sbsj=").append(sbsj);
        sb.append(", tbsj=").append(tbsj);
        sb.append(", lcslid=").append(lcslid);
        sb.append(", tbcs=").append(tbcs);
        sb.append(", sbzlDm=").append(sbzlDm);
        sb.append(", sbtype=").append(sbtype);
        sb.append(", ysbz=").append(ysbz);
        sb.append(", ystqsj=").append(ystqsj);
        sb.append(", yswcsj=").append(yswcsj);
        sb.append(", ystqcs=").append(ystqcs);
        sb.append(", bwzy=").append(bwzy);
        sb.append(", ysjg=").append(ysjg);
        sb.append(", sbr=").append(sbr);
        sb.append(", sbfs=").append(sbfs);
        sb.append(", sbcs=").append(sbcs);
        sb.append(", zzsbb=").append(zzsbb);
        sb.append(", uuid=").append(uuid);
        sb.append(", serialVersionUID=").append(serialVersionUID);
        sb.append("]");
        return sb.toString();
    }
}