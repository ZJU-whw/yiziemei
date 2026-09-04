package com.tl.web.bjts.shzs.model.vo;

/**
 * @描述: 金三用户信息
 * @作者: likun
 * @时间: 2021/6/2 11:32
 */
public class JxUserVO {
    private String swryMc; //税务人员名称
    private String rysfmc; //人员身份名称
    private String zsfbz;
    private String sfswjgDm;//身份税务机关代码

    public String getSwryMc() {
        return swryMc;
    }

    public void setSwryMc(String swryMc) {
        this.swryMc = swryMc;
    }

    public String getRysfmc() {
        return rysfmc;
    }

    public void setRysfmc(String rysfmc) {
        this.rysfmc = rysfmc;
    }

    public String getZsfbz() {
        return zsfbz;
    }

    public void setZsfbz(String zsfbz) {
        this.zsfbz = zsfbz;
    }

    public String getSfswjgDm() {
        return sfswjgDm;
    }

    public void setSfswjgDm(String sfswjgDm) {
        this.sfswjgDm = sfswjgDm;
    }
}
