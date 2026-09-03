package com.tl.bjts.sw.conf;

import com.alibaba.druid.support.http.StatViewServlet;
import com.alibaba.druid.support.http.WebStatFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.core.env.Environment;

/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2017-05-18
 **/
@Configuration
@Profile("dev")
public class DuridStatConfig {
    @Autowired
    Environment evn;

        /**
         * 注册一个StatViewServlet
         * @return
         */
        @Bean
        public ServletRegistrationBean DruidStatViewServle2(){
            //org.springframework.boot.context.embedded.ServletRegistrationBean提供类的进行注册.
            ServletRegistrationBean servletRegistrationBean = new ServletRegistrationBean(new StatViewServlet(),"/druid/*");

            //添加初始化参数：initParams

            servletRegistrationBean.addInitParameter("allow",evn.getProperty("durid.allow","localhost"));
            //登录查看信息的账号密码.
            servletRegistrationBean.addInitParameter("loginUsername",evn.getProperty("durid.user","tonlan"));
            servletRegistrationBean.addInitParameter("loginPassword",evn.getProperty("durid.paswd","tlsoft"));
            //是否能够重置数据.
            servletRegistrationBean.addInitParameter("resetEnable","false");
            return servletRegistrationBean;
        }

        /**
         * 注册一个：filterRegistrationBean
         * @return
         */
        @Bean
        public FilterRegistrationBean zdruidStatFilter2(){
            WebStatFilter zw =  new WebStatFilter();
            FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean(zw);

            //添加过滤规则.
            filterRegistrationBean.addUrlPatterns("/*");


            //添加不需要忽略的格式信息.
            filterRegistrationBean.addInitParameter("exclusions","*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*");

            filterRegistrationBean.addInitParameter("profileEnable","true");
            filterRegistrationBean.addInitParameter("sessionStatEnable","true");
            filterRegistrationBean.addInitParameter("principalCookieName","tl.session");
            return filterRegistrationBean;
        }

}
