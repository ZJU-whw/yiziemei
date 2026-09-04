package com.tl.web.bjts.shzs.interceptor;

import com.tl.common.utils.TlRequestContext;
import com.tl.common.utils.URIs;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.regex.Pattern;

/**
 * 说明：${DESCRIPTION}
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
    public void postHandle(HttpServletRequest request, HttpServletResponse
            response, Object handler, ModelAndView modelAndView) throws
            Exception {

    }


    Pattern incluedeUrl = Pattern.compile("^\\-((index)|(insurance)|(order)|" +
            "(my))\\S*$", Pattern.CASE_INSENSITIVE);

    @Override
    public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response, Object handler,
                                Exception ex) throws Exception {
        try {
            long current = System.currentTimeMillis();
            final long costMs = current - TlRequestContext
                    .getStartTime();
            final String requestUrl = request.getRequestURL().toString();
            String m = request.getRequestURI().replaceAll("/", "-");
            requestLogger.info
                    ("Request:\t{}\t{}\t{}\t{}\t{}\tCost" +
                                    ":{}ms",
                            new String[]{String.valueOf(current),
                                    request.getRequestURI()
                                    , String.valueOf(0)
                                    , URIs.getIp(request)
                                    , request.getHeader("User-Agent")
                                    , String.valueOf(costMs)});


        } catch (Exception e) {
            e.printStackTrace();
        } finally {

        }
    }

}
