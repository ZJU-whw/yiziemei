package com.tl.web.bjts.yj.exception;


import com.tl.web.bjts.yj.model.ResultCode;

/**
 * Created by Mamf on 2017/6/21.
 */
public class BusinessException extends RuntimeException{

    private static final long serialVersionUID = 2332608236621015980L;

    private String code= ResultCode.APP_BIZ_ERROR.getCode();

    private String msg;

    public BusinessException(String msg) {
        super(msg);
        this.msg=msg;
    }

    public BusinessException(String code,String msg) {
        super(msg);
        this.code=code;
        this.msg=msg;
    }

    public BusinessException(ResultCode rc) {
        super(rc.getMsg());
        this.setCode(rc.getCode());
        this.setMsg(rc.getMsg());
    }


    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
