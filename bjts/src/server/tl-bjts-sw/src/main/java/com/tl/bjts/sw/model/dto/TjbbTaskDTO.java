package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.annotation.NotEmpty;
import com.tl.common.ext.model.BaseListDTO;

/**
 * @Author：Mamf
 * @Date: 2019/9/29.
 * @Description:
 */
public class TjbbTaskDTO extends BaseListDTO {

    @NotEmpty(msg = "所属年月不能为空")
    private String ssny;

    private String bbdldm;

    private String swjgdm;

    private String bbdm;

    private String qrflag;

    private String swjgDm;

    private String pramHash;

    private String isVir;

    private String location;

    private String bblc;

    public String getBblc() {
        return this.bblc;

    }

    public void setBblc(String bblc) {
        this.bblc = bblc;
    }

    public String getLocation() {
        return this.location;

    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getIsVir() {
        return this.isVir;

    }

    public void setIsVir(String isVir) {
        this.isVir = isVir;
    }

    public String getSwjgDm() {
        return this.swjgDm;
    }

    public void setSwjgDm(String swjgDm) {
        this.swjgDm = swjgDm;
    }

    public String getQrflag() {
        return qrflag;
    }

    public void setQrflag(String qrflag) {
        this.qrflag = qrflag;
    }

    public String getBbdm() {
        return bbdm;
    }

    public void setBbdm(String bbdm) {
        this.bbdm = bbdm;
    }

    public String getSwjgdm() {
        return swjgdm;
    }

    public void setSwjgdm(String swjgdm) {
        this.swjgdm = swjgdm;
    }

    public String getBbdldm() {
        return bbdldm;
    }

    public void setBbdldm(String bbdldm) {
        this.bbdldm = bbdldm;
    }

    public String getSsny() {
        return ssny;
    }

    public void setSsny(String ssny) {
        this.ssny = ssny;
    }

    public String getPramHash() {
        return pramHash;
    }

    public void setPramHash(String pramHash) {
        this.pramHash = pramHash;
    }

}
