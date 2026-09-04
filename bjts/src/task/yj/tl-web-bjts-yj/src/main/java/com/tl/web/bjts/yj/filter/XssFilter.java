package com.tl.web.bjts.yj.filter;

import org.apache.commons.lang3.StringEscapeUtils;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.io.IOException;

/**
 * Created by feng on 1/8/16.
 */
@WebFilter(filterName = "xssFilter",urlPatterns = "/*")
public class XssFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse
            servletResponse, FilterChain filterChain) throws IOException,
            ServletException {
        filterChain.doFilter(new XssHttpServletRequestWrapper(
                (HttpServletRequest) servletRequest), servletResponse);
    }

    @Override
    public void destroy() {

    }

    static class XssHttpServletRequestWrapper extends
            HttpServletRequestWrapper {

        public XssHttpServletRequestWrapper(HttpServletRequest request) {
            super(request);
        }

        @Override
        public String getHeader(String name) {
            return StringEscapeUtils.escapeHtml4(super.getHeader(name));
        }

        @Override
        public String getQueryString() {
            return StringEscapeUtils.escapeHtml4(super.getQueryString());
        }

        @Override
        public String getParameter(String name) {
            return StringEscapeUtils.escapeHtml4(super.getParameter(name));
        }

        @Override
        public String[] getParameterValues(String name) {
            String[] values = super.getParameterValues(name);
            if (values != null) {
                int length = values.length;
                String[] escapseValues = new String[length];
                for (int i = 0; i < length; i++) {
                    escapseValues[i] = StringEscapeUtils.escapeHtml4(values[i]);
                }
                return escapseValues;
            }
            return super.getParameterValues(name);
        }
    }
}
