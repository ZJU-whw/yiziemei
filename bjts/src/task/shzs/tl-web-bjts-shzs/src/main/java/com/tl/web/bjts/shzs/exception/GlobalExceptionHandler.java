package com.tl.web.bjts.shzs.exception;

import com.tl.common.ext.exception.TlBusinessException;
import com.tl.common.utils.SpringContextUtil;
import com.tl.web.bjts.shzs.model.ResultCode;
import com.tl.web.bjts.shzs.model.SimpleResult;
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.exceptions.TooManyResultsException;
import org.apache.shiro.authz.UnauthenticatedException;
import org.mybatis.spring.MyBatisSystemException;
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
    SimpleResult  handleSQLException(HttpServletRequest request, Exception ex) {
        logger.error("Sql Error",ex);
        SimpleResult rtn = new SimpleResult();
        rtn.setResultCode(ResultCode.DATA_PARAM);
        return rtn;
    }

    @ExceptionHandler({UnauthenticatedException.class})
    @ResponseBody
    public SimpleResult processUnauthenticatedException( Exception ex) {
        logger.error("Unauthenticated Error",ex);
        SimpleResult rtn = new SimpleResult();
        rtn.setResultCode(ResultCode.AUTHEN_ERROR);
        return rtn;
    }

    @ExceptionHandler(IOException.class)
    public
    @ResponseBody
    SimpleResult handleIOException( Exception ex){
        logger.error("Io Error",ex);
        SimpleResult rtn = new SimpleResult();
        rtn.setResultCode(ResultCode.REQUEST_ERROR);
        return rtn;
    }

    @ExceptionHandler(Exception.class)
    public
    @ResponseBody
    SimpleResult handleException( Exception ex){
        logger.error("Sys Exception Msg",ex);
        SimpleResult rtn = new SimpleResult();
        rtn.setResultCode(ResultCode.APP_UNKNOWN_ERROR);
        return rtn;
    }

    @ExceptionHandler(MyBatisSystemException.class)
    public
    @ResponseBody
    SimpleResult handleTooManyResultsException( MyBatisSystemException ex){
        logger.error("MyBatisSystemException Msg:"+ex.getMessage(),ex);
        SimpleResult rtn = new SimpleResult();
        rtn.setResultCode(ResultCode.DATABASE_ERROR);
        if(ex.getCause() instanceof TooManyResultsException){
            rtn.setResultCode(ResultCode.TOO_MANY_RESULT);
        }

        return rtn;
    }


    //Add your exception handler
    @ExceptionHandler(BusinessException.class)
    public
    @ResponseBody
    SimpleResult handleBusinessException(BusinessException ex){
        logger.info("Biz info Msg",ex);
        SimpleResult rtn = new SimpleResult();
        rtn.setCode(ex.getCode());
        rtn.setMsg(ex.getMsg());
        return rtn;
    }

    @ExceptionHandler(TlBusinessException.class)
    public
    @ResponseBody
    SimpleResult handleTlBusinessException(HttpServletRequest request,TlBusinessException ex){
        SimpleResult rtn = new SimpleResult();
        rtn.setCode(ex.getCode());
        rtn.setMsg((StringUtils.isBlank(ex.getSubMsg())) ? ex.getMsg() : ex.getSubMsg());
        return rtn;
    }
}
