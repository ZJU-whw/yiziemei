package com.tl.bjts.sw.exception;


import com.tl.bjts.sw.model.ResultCode;

/**
 * Created by Mamf on 2017/6/21.
 */
public class BusinessException extends RuntimeException {

    private static final long serialVersionUID = 2332608236621015980L;

    private  int code;

    private  String msg;

    private final String subMsg;


    public BusinessException(ResultCode rc) {
        super(rc.getMsg());
        this.code = rc.getCode();
        this.msg = rc.getMsg();
        this.subMsg = "";
    }

    public BusinessException(int code ,String msg) {
        super(msg);
        this.code = code ;
        this.msg = msg;
        this.subMsg = "";
    }

    public BusinessException(String msg) {
        super(msg);
        this.code = ResultCode.SERVICE_BIZ_ERROR.getCode();
        this.msg = msg;
        this.subMsg = "";
    }

    public BusinessException(ResultCode rc, String subMsg) {
        super(rc.getMsg() + subMsg);
        this.code = rc.getCode();
        this.msg = rc.getMsg() + " " +subMsg;
        this.subMsg = subMsg;
    }


    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public String getSubMsg() {
        return subMsg;
    }
}
