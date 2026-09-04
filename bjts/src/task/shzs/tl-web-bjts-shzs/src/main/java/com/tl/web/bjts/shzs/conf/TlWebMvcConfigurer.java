package com.tl.web.bjts.shzs.conf;

import com.tl.web.bjts.shzs.interceptor.BaseInterceptor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;

/**
 * 说明：注册过滤器
 * 作者：王兆阳
 * 日期：2017-05-22
 **/
@Configuration
public class TlWebMvcConfigurer extends WebMvcConfigurationSupport implements EnvironmentAware {
    private Environment env;

    @Autowired
    AppProperties appProperties;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 多个拦截器组成一个拦截器链
        // addPathPatterns 用于添加拦截规则
        // excludePathPatterns 用户排除拦截
        registry.addInterceptor(new BaseInterceptor()).addPathPatterns("/**");
        super.addInterceptors(registry);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        String servletpath = this.env.getProperty("server.servlet-path");
        String urlpatern= appProperties.getUrlBase();
        if(!StringUtils.isEmpty(servletpath)){
            urlpatern = urlpatern.replace(servletpath,"");
        }
        registry.addResourceHandler(urlpatern+"**").addResourceLocations("file:"+appProperties.getDir());

        super.addResourceHandlers(registry);
    }

    @Override
    public void setEnvironment(Environment environment) {
        this.env = environment;
    }
}
