package com.tl.bjts.sw.model;

import com.tl.bjts.sw.annotation.NotEmpty;

/**
 * Created by wzy on 16/7/15.
 */
public class SimpleResult<T> {

    private int code;

    private String msg;

    @NotEmpty
    private T data;

    public SimpleResult() {
        this.code = ResultCode.OK.getCode();
        this.msg = ResultCode.OK.getMsg();
    }

    public void setResultCode(ResultCode rc){
        this.setCode(rc.getCode());
        this.setMsg(rc.getMsg());
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
