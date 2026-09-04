package com.tl.web.bjts.shzs.conf;

import com.alibaba.druid.support.http.StatViewServlet;
import com.alibaba.druid.support.http.WebStatFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;

/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2017-05-18
 **/
@Configuration
@Profile("dev")
@Order(2)
public class DuridStatConfig {

        /**
         * 注册一个StatViewServlet
         * @return
         */
        @Bean
        public ServletRegistrationBean DruidStatViewServlet2(){
            //org.springframework.boot.context.embedded.ServletRegistrationBean提供类的进行注册.
            ServletRegistrationBean servletRegistrationBean = new ServletRegistrationBean(new StatViewServlet(),"/druid/*");

            //添加初始化参数：initParams

            //白名单：
            servletRegistrationBean.addInitParameter("allow","127.0.0.1");
            //登录查看信息的账号密码.
            servletRegistrationBean.addInitParameter("loginUsername","admin");
            servletRegistrationBean.addInitParameter("loginPassword","tonlan@hz");
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

            WebStatFilter zebStatFilter = new WebStatFilter();

            FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean(zebStatFilter);

            //添加过滤规则.
            filterRegistrationBean.addUrlPatterns("/*");

            //添加不需要忽略的格式信息.
            filterRegistrationBean.addInitParameter("exclusions","*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*");
            filterRegistrationBean.addInitParameter("principalSessionName","tl.session");
            filterRegistrationBean.addInitParameter("profileEnable","true");
            return filterRegistrationBean;
        }

}
