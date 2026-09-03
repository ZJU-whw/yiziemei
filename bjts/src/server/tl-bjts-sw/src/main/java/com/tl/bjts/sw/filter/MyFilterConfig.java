package com.tl.bjts.sw.filter;

import com.tl.common.filter.RepeatAccessHttpWrapperFilter;
import com.tl.common.xss.MyXssFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Arrays;

/**
 * @Description:添加自定义的防跨站脚本攻击过滤器
 * @Author 王兆阳
 * @Date 2023/10/10 10:54
 * @Version 1.0
 */

@Configuration
public class MyFilterConfig {
    /**
     * Gzip压缩报文解压的过滤器，仅在GzipFilter启用的服务中启用，其他服务删除或注释掉
     * @return
     */
    /*@Bean
    public FilterRegistrationBean gzipFilterRegistration() {
        FilterRegistrationBean registration = new FilterRegistrationBean();
        registration.setFilter(new GzipFilter());
        registration.addUrlPatterns("*//*");//过滤所有路径
        registration.setName("gzipFilter");//过滤器名称
        return registration;
    }*/

    /**
     * 防止跨站脚本攻击的过滤器 全部服务必须启用
     * @return
     */
    @Bean
    public FilterRegistrationBean xssFilterRegistration() {
        FilterRegistrationBean registration = new FilterRegistrationBean();
        registration.setFilter(new MyXssFilter(
        ));
        registration.addUrlPatterns("/*");//过滤所有路径
        registration.setName("xssFilter");//过滤器名称
        registration.setOrder(Integer.MAX_VALUE - 1);//优先级，越低越优先
        return registration;
    }

    /**
     * 可重复读取请求流的过滤器
     * HttpWrapperFilter 有效时使用，否则删除或注释掉
     * @return
     */
    //@Bean
    public FilterRegistrationBean RepeatAccessFilterRegistration() {
        FilterRegistrationBean registration = new FilterRegistrationBean();
        registration.setFilter(new RepeatAccessHttpWrapperFilter());
        registration.addUrlPatterns("/*");//过滤所有路径
        registration.setName("zRepeatAccesshttpWrapperFilter");//过滤器名称
        registration.setOrder(Integer.MAX_VALUE);//优先级，越低越优先
        return registration;
    }
}
