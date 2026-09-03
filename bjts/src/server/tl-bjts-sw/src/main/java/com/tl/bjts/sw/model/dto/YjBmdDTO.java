package com.tl.bjts.sw.model.dto;

import com.tl.common.ext.model.BaseListDTO;

/**
 * @Author：Mamf
 * @Date: 2019/9/3.
 * @Description:
 */
public class YjBmdDTO extends BaseListDTO {

    private String qybs;

    private String qymc;

    private String tsjg;

    private String yjcode;

    private String objflag;

    private String qxdm;

    public String getQxdm() {
        return qxdm;
    }

    public void setQxdm(String qxdm) {
        this.qxdm = qxdm;
    }

    public String getYjcode() {
        return yjcode;
    }

    public void setYjcode(String yjcode) {
        this.yjcode = yjcode;
    }

    public String getObjflag() {
        return objflag;
    }

    public void setObjflag(String objflag) {
        this.objflag = objflag;
    }


    public String getTsjg() {
        return tsjg;
    }

    public void setTsjg(String tsjg) {
        this.tsjg = tsjg;
    }

    public String getQybs() {
        return qybs;
    }

    public void setQybs(String qybs) {
        this.qybs = qybs;
    }

    public String getQymc() {
        return qymc;
    }

    public void setQymc(String qymc) {
        this.qymc = qymc;
    }
}
