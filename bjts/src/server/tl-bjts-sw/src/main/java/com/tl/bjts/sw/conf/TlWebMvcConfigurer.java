package com.tl.bjts.sw.conf;


import com.tl.bjts.sw.biz.TLParamArgumentResolver;
import com.tl.bjts.sw.interceptor.BaseInterceptor;
import com.tl.bjts.sw.interceptor.RecordInterceptor;
import com.tl.bjts.sw.interceptor.RwglYbclInterceptor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import java.util.List;

/**
 * 说明：注册过滤器
 * 作者：王兆阳
 * 日期：2017-05-22
 **/
@Configuration
public class TlWebMvcConfigurer extends WebMvcConfigurerAdapter  implements EnvironmentAware {
    private Environment env;

    @Autowired
    private RecordInterceptor recordInterceptor;

    @Autowired
    RwglYbclInterceptor rwglYbclInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 多个拦截器组成一个拦截器链
        // addPathPatterns 用于添加拦截规则
        // excludePathPatterns 用户排除拦截
        registry.addInterceptor(new BaseInterceptor()).addPathPatterns("/**");
        registry.addInterceptor(recordInterceptor).addPathPatterns("/**/export/**").excludePathPatterns("/**/export/readtree")
                .addPathPatterns("yj/zhcx/export").addPathPatterns("yj/pfxx/export").addPathPatterns("yj/ckll/export");
        registry.addInterceptor(rwglYbclInterceptor).addPathPatterns("/**");
        super.addInterceptors(registry);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        String servletpath = this.env.getProperty("server.servlet-path");
        String urlpatern= FileConfig.urlBase;
        if(!StringUtils.isEmpty(servletpath)){
            urlpatern = urlpatern.replace(servletpath,"");
        }
        registry.addResourceHandler(urlpatern+"**").addResourceLocations("file:"+FileConfig.dir);

        super.addResourceHandlers(registry);
    }


    @Override
    public void setEnvironment(Environment environment) {
        this.env = environment;
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
        argumentResolvers.add(new TLParamArgumentResolver());
    }
}
