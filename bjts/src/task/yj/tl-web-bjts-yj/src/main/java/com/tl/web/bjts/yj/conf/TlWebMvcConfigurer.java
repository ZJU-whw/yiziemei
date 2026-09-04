package com.tl.web.bjts.yj.conf;

import com.tl.web.bjts.yj.interceptor.BaseInterceptor;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

/**
 * 说明：注册过滤器
 * 作者：王兆阳
 * 日期：2017-05-22
 **/
@Configuration
public class TlWebMvcConfigurer extends WebMvcConfigurerAdapter   implements EnvironmentAware {
    private Environment env;


    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 多个拦截器组成一个拦截器链
        // addPathPatterns 用于添加拦截规则
        // excludePathPatterns 用户排除拦截
        registry.addInterceptor(new BaseInterceptor()).addPathPatterns("/**");


        super.addInterceptors(registry);
    }

    /*@Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        String servletpath = this.env.getProperty("server.servlet-path");
        String urlpatern= FileConfig.urlBase;
        if(!StringUtils.isEmpty(servletpath)){
            urlpatern = urlpatern.replace(servletpath,"");
        }
        registry.addResourceHandler(urlpatern+"**").addResourceLocations("file:"+FileConfig.dir);

        super.addResourceHandlers(registry);
    }*/



    @Override
    public void setEnvironment(Environment environment) {
        this.env = environment;
    }
}
