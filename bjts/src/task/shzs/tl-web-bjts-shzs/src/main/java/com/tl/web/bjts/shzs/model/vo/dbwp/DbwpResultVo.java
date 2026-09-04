package com.tl.web.bjts.shzs.model.vo.dbwp;

/**
 * @description 预分配委派对象视图
 * @author: Mamf
 * @date: 2024/9/19 17:43
 */
public class DbwpResultVo {

    private String gzxid;

    private String wpdxqyfz;

    private String wpdx;

    private String wpsfdm;

    private String jdmode;

    private String gwdm;

    private String sfswjgdm;  //身份税务机关代码

    private String swrydm;  //税务人员代码

    private String xndbrdm;

    private String errorMsg;

    public String getSfswjgdm() {
        return this.sfswjgdm;

    }

    public void setSfswjgdm(String sfswjgdm) {
        this.sfswjgdm = sfswjgdm;
    }

    public String getSwrydm() {
        return this.swrydm;

    }

    public void setSwrydm(String swrydm) {
        this.swrydm = swrydm;
    }

    public String getXndbrdm() {
        return this.xndbrdm;

    }

    public void setXndbrdm(String xndbrdm) {
        this.xndbrdm = xndbrdm;
    }

    public String getGwdm() {
        return this.gwdm;

    }

    public void setGwdm(String gwdm) {
        this.gwdm = gwdm;
    }

    public String getErrorMsg() {
        return this.errorMsg;

    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }

    public String getGzxid() {
        return this.gzxid;

    }

    public void setGzxid(String gzxid) {
        this.gzxid = gzxid;
    }

    public String getWpdxqyfz() {
        return this.wpdxqyfz;

    }

    public void setWpdxqyfz(String wpdxqyfz) {
        this.wpdxqyfz = wpdxqyfz;
    }

    public String getWpdx() {
        return this.wpdx;

    }

    public void setWpdx(String wpdx) {
        this.wpdx = wpdx;
    }

    public String getWpsfdm() {
        return this.wpsfdm;

    }

    public void setWpsfdm(String wpsfdm) {
        this.wpsfdm = wpsfdm;
    }

    public String getJdmode() {
        return this.jdmode;

    }

    public void setJdmode(String jdmode) {
        this.jdmode = jdmode;
    }
}
