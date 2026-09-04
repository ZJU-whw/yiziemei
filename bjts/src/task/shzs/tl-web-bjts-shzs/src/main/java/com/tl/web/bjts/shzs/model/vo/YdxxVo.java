package com.tl.web.bjts.shzs.model.vo;

import com.tl.web.bjts.shzs.utils.ConstUtil;

public class YdxxVo {
    private Long id; //序号
    private String errObj;
    private String errLev;
    private String ydcode;
    private String passFlag;
    private String glywb1; // 关联项1
    private String glywb2;
    private String errMsg;
    private String glb; // 关联表

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getErrObj() {
        return errObj;
    }

    public void setErrObj(String errObj) {
        this.errObj = errObj;
    }

    public String getErrLev() {
        if(errLev==null || "".equals(errLev.trim()))
            return ConstUtil.ERR_LEVEL_NORMAL;
        if("E".equals(errLev))
            return ConstUtil.ERR_LEVEL_ERROR;
        if("W".equals(errLev))
            return ConstUtil.ERR_LEVEL_WARNING;

        return "";
    }

    public void setErrLev(String errLev) {
        this.errLev = errLev;
    }

    public String getYdcode() {
        return ydcode;
    }

    public void setYdcode(String ydcode) {
        this.ydcode = ydcode;
    }

    public String getPassFlag() {
        if(passFlag!=null && "0".equals(passFlag.trim())) {
            return ConstUtil.YD_CAN_NOT_PASS_FLAG;
        }else if(passFlag!=null && "1".equals(passFlag.trim())){
            return ConstUtil.YD_CAN_PASS_FLAG;
        }
        return "";
    }

    public void setPassFlag(String passFlag) {
        this.passFlag = passFlag;
    }

    public String getGlywb1() {
        return glywb1;
    }

    public void setGlywb1(String glywb1) {
        this.glywb1 = glywb1;
    }

    public String getGlywb2() {
        return glywb2;
    }

    public void setGlywb2(String glywb2) {
        this.glywb2 = glywb2;
    }

    public String getErrMsg() {
        return errMsg;
    }

    public void setErrMsg(String errMsg) {
        this.errMsg = errMsg;
    }

    public String getGlb() {
        return glb;
    }

    public void setGlb(String glb) {
        this.glb = glb;
    }
}
