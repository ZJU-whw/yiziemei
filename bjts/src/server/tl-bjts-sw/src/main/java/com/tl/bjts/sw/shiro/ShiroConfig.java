package com.tl.bjts.sw.shiro;

import com.tl.redis.shiro.TLAuthenticationFilter;
import org.apache.shiro.authc.credential.HashedCredentialsMatcher;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

import javax.servlet.Filter;
import java.util.HashMap;
import java.util.Map;

/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2017-06-01
 **/
@Configuration
public class ShiroConfig{

    @Autowired
    Environment evn;


   @Bean
    MyRealm getRealm(){
        MyRealm realm = new MyRealm();
        HashedCredentialsMatcher matcher = new HashedCredentialsMatcher();
        matcher.setHashAlgorithmName("md5");
        matcher.setHashIterations(2);
        realm.setCredentialsMatcher(matcher);
        realm.setName(evn.getProperty("spring.application.name"));
        return realm;
    }

    @Bean
    public ShiroFilterFactoryBean getShiroFilterFactoryBean(DefaultWebSecurityManager securityManager) {

        ShiroFilterFactoryBean shiroFilterFactoryBean = new ShiroFilterFactoryBean();

        securityManager.setRealm(getRealm());
        shiroFilterFactoryBean.setSecurityManager(securityManager);
        // shiroFilterFactoryBean.setLoginUrl("/login");
        //使用自定义的过滤器
        Map<String,Filter> filters = new HashMap<>();
        filters.put("authc",new TLAuthenticationFilter(evn.getProperty("spring.application.name")));
        shiroFilterFactoryBean.setFilters(filters);

        Map<String, String> filterChainDefinitionMap = new HashMap<>();
        filterChainDefinitionMap.put("*.ico", "anon");
        filterChainDefinitionMap.put("/error", "anon");
        filterChainDefinitionMap.put("/login", "anon");
        filterChainDefinitionMap.put("/static/**", "anon");
        filterChainDefinitionMap.put("/druid/**", "anon");
        filterChainDefinitionMap.put("/**", "authc");
        shiroFilterFactoryBean.setFilterChainDefinitionMap(filterChainDefinitionMap);

        return shiroFilterFactoryBean;
    }

}
