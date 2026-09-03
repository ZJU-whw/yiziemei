package com.tl.bjts.sw.model.vo;

import com.tl.bjts.sw.model.domain.YjCsBmdModel;
import com.tl.common.ext.annotation.ExcelSetting;
import com.tl.common.ext.annotation.NotEmpty;

/**
 * @Author：Mamf
 * @Date: 2019/9/3.
 * @Description:
 */
public class YjCsBmdModelVo extends YjCsBmdModel {

    @ExcelSetting(colTitleName = "海关代码" , isFirst = true, nextColName = "shxyno")
    private String qyhgdm;

    @ExcelSetting(colTitleName = "社会信用代码", nextColName = "nsrmc")
    private String shxyno;

    @ExcelSetting(colTitleName = "纳税人名称", nextColName = "yjcode")
    private String nsrmc;

    @ExcelSetting(colTitleName = "预警名称", nextColName = "objflag")
    private String yjname;

    @ExcelSetting(colTitleName = "退税机关名称", nextColName = "yyms")
    private String swjgmc;

    private String bmdid;

    private String objflagBz;

    @NotEmpty
    private String qybs;

    private String yjobject;

    public String getYjobject() {
        return yjobject;
    }

    public void setYjobject(String yjobject) {
        this.yjobject = yjobject;
    }

    public String getObjflagBz() {
        return objflagBz;
    }

    public void setObjflagBz(String objflagBz) {
        this.objflagBz = objflagBz;
    }

    public String getBmdid() {
        return bmdid;
    }

    public void setBmdid(String bmdid) {
        this.bmdid = bmdid;
    }

    public String getQybs() {
        return qybs;
    }

    public void setQybs(String qybs) {
        this.qybs = qybs;
    }

    public String getSwjgmc() {
        return swjgmc;
    }

    public void setSwjgmc(String swjgmc) {
        this.swjgmc = swjgmc;
    }

    public String getQyhgdm() {
        return qyhgdm;
    }

    public void setQyhgdm(String qyhgdm) {
        this.qyhgdm = qyhgdm;
    }

    public String getShxyno() {
        return shxyno;
    }

    public void setShxyno(String shxyno) {
        this.shxyno = shxyno;
    }

    public String getNsrmc() {
        return nsrmc;
    }

    public void setNsrmc(String nsrmc) {
        this.nsrmc = nsrmc;
    }

    public String getYjname() {
        return yjname;
    }

    public void setYjname(String yjname) {
        this.yjname = yjname;
    }
}
