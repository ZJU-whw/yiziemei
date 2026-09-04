package com.tl.web.bjts.yj.model;



/**
 * Created by wzy on 16/7/15.
 */
public class SimpleResult<T> {

    private String retcode;

    private String retmsg;

    private T retdata;

    public SimpleResult() {
        this.retcode = ResultCode.OK.getCode();
        this.retmsg = ResultCode.OK.getMsg();
    }

    public void setResultCode(ResultCode rc){
        this.setRetcode(rc.getCode());
        this.setRetmsg(rc.getMsg());
    }

    public String getRetcode() {
        return retcode;
    }

    public void setRetcode(String retcode) {
        this.retcode = retcode;
    }

    public String getRetmsg() {
        return retmsg;
    }

    public void setRetmsg(String retmsg) {
        this.retmsg = retmsg;
    }

    public T getRetdata() {
        return retdata;
    }

    public void setRetdata(T retdata) {
        this.retdata = retdata;
    }
}
