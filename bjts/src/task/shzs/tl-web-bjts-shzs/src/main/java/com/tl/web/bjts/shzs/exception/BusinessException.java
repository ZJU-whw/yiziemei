package com.tl.web.bjts.shzs.exception;


import com.tl.web.bjts.shzs.model.ResultCode;

/**
 * Created by Mamf on 2017/6/21.
 */
public class BusinessException extends RuntimeException{

    private static final long serialVersionUID = 2332608236621015980L;

    private int code= ResultCode.APP_BIZ_ERROR.getCode();

    private String msg;

    public BusinessException(String msg) {
        super(msg);
        this.msg=msg;
    }

    public BusinessException(ResultCode rc) {
        super(rc.getMsg());
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
}
