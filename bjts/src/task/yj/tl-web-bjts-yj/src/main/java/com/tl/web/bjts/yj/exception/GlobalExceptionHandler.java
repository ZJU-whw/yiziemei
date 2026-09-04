package com.tl.web.bjts.yj.exception;

import com.tl.web.bjts.yj.model.ResultCode;
import com.tl.web.bjts.yj.model.SimpleResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.sql.SQLException;


/**
 * 说明：控制器增强 此处用作全局异常处理
 * 作者：王兆阳
 * 日期：2017-05-18
 **/

@ControllerAdvice
public class GlobalExceptionHandler {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @ExceptionHandler(SQLException.class)
    public
    @ResponseBody
    SimpleResult handleSQLException(HttpServletRequest request, Exception ex) {
        logger.error("Sql Error",ex);
        SimpleResult rtn = new SimpleResult();
        rtn.setResultCode(ResultCode.SQL_ERROR);
        return rtn;
    }


    @ExceptionHandler(IOException.class)
    public
    @ResponseBody
    SimpleResult handleIOException( Exception ex){
        logger.error("Io Error",ex);
        SimpleResult rtn = new SimpleResult();
        rtn.setResultCode(ResultCode.IO_ERROR);
        return rtn;
    }

    @ExceptionHandler(Exception.class)
    public
    @ResponseBody
    SimpleResult handleException( Exception ex){
        logger.error("Sys Exception Msg",ex);
        SimpleResult rtn = new SimpleResult();
        rtn.setResultCode(ResultCode.UNKNOWN_ERROR);
        return rtn;
    }


    //Add your exception handler
    @ExceptionHandler(BusinessException.class)
    public
    @ResponseBody
    SimpleResult handleBusinessException(BusinessException ex){
        logger.info("Biz info Msg",ex);
        SimpleResult rtn = new SimpleResult();
        rtn.setRetcode(ex.getCode());
        rtn.setRetmsg(ex.getMsg());
        return rtn;
    }
}
