package com.tl.bjts.sw.interceptor;

import com.tl.common.utils.TlRequestContext;
import com.tl.common.utils.URIs;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * 说明：基础拦截器
 * 作用：记录接口访问的信息及消耗时长
 * 作者：王兆阳
 * 日期：2017-05-22
 **/


public class BaseInterceptor extends HandlerInterceptorAdapter {
    private final static Logger LOGGER = LoggerFactory.getLogger
            (BaseInterceptor.class);

    private final static Logger requestLogger = LoggerFactory.getLogger
            ("request");


    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse
            response, Object handler) throws Exception {
        TlRequestContext.init();
        return super.preHandle(request, response, handler);
    }

    @Override
    public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response, Object handler,
                                Exception ex) throws Exception {
        try {
            long current = System.currentTimeMillis();
            final long costMs = current - TlRequestContext
                    .getStartTime();
            requestLogger.info
                    ("Request:\t{}\t{}\t{}\t{}\t{}\tCost:{}ms"
                            ,current
                            ,request.getRequestURI()
                            ,request.getParameter("method")
                            , URIs.getIp(request)
                            , request.getHeader("User-Agent")
                            , costMs);
        } catch (Exception e) {
            requestLogger.error(e.getMessage());
        }
    }

}
