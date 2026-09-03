package com.tl.bjts.sw.model.dto;

import java.math.BigDecimal;

/**
 * @描述: 出口退税审核审批表保存的dto
 * @作者: likun
 * @时间: 2020/11/10 13:52
 */
public class ShspqkSaveDTO {
    private String paramhash;
    private String bblc;
    private String swjgdm;
    private BigDecimal bqtse_fh;
    private BigDecimal ljtse_fh;
    private BigDecimal bqtse_hz;
    private BigDecimal ljtse_hz;
    private BigDecimal bqtse_sp;
    private BigDecimal ljtse_sp;
    private BigDecimal bqtse_kp;
    private BigDecimal ljtse_kp;
    private BigDecimal dqdhztse;
    private BigDecimal dqdsptse;
    private BigDecimal dqdkptse;

    public String getParamhash() {
        return paramhash;
    }

    public void setParamhash(String paramhash) {
        this.paramhash = paramhash;
    }

    public String getBblc() {
        return bblc;
    }

    public void setBblc(String bblc) {
        this.bblc = bblc;
    }

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public BigDecimal getBqtse_fh() {
        return bqtse_fh;
    }

    public void setBqtse_fh(BigDecimal bqtse_fh) {
        this.bqtse_fh = bqtse_fh;
    }

    public BigDecimal getLjtse_fh() {
        return ljtse_fh;
    }

    public void setLjtse_fh(BigDecimal ljtse_fh) {
        this.ljtse_fh = ljtse_fh;
    }

    public BigDecimal getBqtse_hz() {
        return bqtse_hz;
    }

    public void setBqtse_hz(BigDecimal bqtse_hz) {
        this.bqtse_hz = bqtse_hz;
    }

    public BigDecimal getLjtse_hz() {
        return ljtse_hz;
    }

    public void setLjtse_hz(BigDecimal ljtse_hz) {
        this.ljtse_hz = ljtse_hz;
    }

    public BigDecimal getBqtse_sp() {
        return bqtse_sp;
    }

    public void setBqtse_sp(BigDecimal bqtse_sp) {
        this.bqtse_sp = bqtse_sp;
    }

    public BigDecimal getLjtse_sp() {
        return ljtse_sp;
    }

    public void setLjtse_sp(BigDecimal ljtse_sp) {
        this.ljtse_sp = ljtse_sp;
    }

    public BigDecimal getBqtse_kp() {
        return bqtse_kp;
    }

    public void setBqtse_kp(BigDecimal bqtse_kp) {
        this.bqtse_kp = bqtse_kp;
    }

    public BigDecimal getLjtse_kp() {
        return ljtse_kp;
    }

    public void setLjtse_kp(BigDecimal ljtse_kp) {
        this.ljtse_kp = ljtse_kp;
    }

    public BigDecimal getDqdhztse() {
        return dqdhztse;
    }

    public void setDqdhztse(BigDecimal dqdhztse) {
        this.dqdhztse = dqdhztse;
    }

    public BigDecimal getDqdsptse() {
        return dqdsptse;
    }

    public void setDqdsptse(BigDecimal dqdsptse) {
        this.dqdsptse = dqdsptse;
    }

    public BigDecimal getDqdkptse() {
        return dqdkptse;
    }

    public void setDqdkptse(BigDecimal dqdkptse) {
        this.dqdkptse = dqdkptse;
    }
}
