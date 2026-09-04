package com.tl.web.bjts.shzs.shiro;

import com.tl.redis.shiro.TLAuthenticationFilter;
import com.tl.web.bjts.shzs.conf.AppProperties;
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
    private AppProperties appProperties;

    @Autowired
    private Environment evn;

    @Bean
    MyRealm getRealm(){
        MyRealm realm = new MyRealm();
        HashedCredentialsMatcher matcher = new HashedCredentialsMatcher();
        matcher.setHashAlgorithmName("md5");
        matcher.setHashIterations(2);
        realm.setCredentialsMatcher(matcher);

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
        filterChainDefinitionMap.put("/shzs/error", "anon");
        filterChainDefinitionMap.put("/shzs/login", "anon");
        filterChainDefinitionMap.put("/shzs/download/**", "anon");
        filterChainDefinitionMap.put("/shzs/static/**", "anon");
        filterChainDefinitionMap.put("/shzs/update/**", "anon");
        filterChainDefinitionMap.put("/shzs/template/**", "anon");
        filterChainDefinitionMap.put("/shzs/hello", "anon");
        filterChainDefinitionMap.put("/druid/**", "anon");
        filterChainDefinitionMap.put("/shzs/app/**", "anon");
        filterChainDefinitionMap.put("/shzs/jolokia/**", "anon");
        filterChainDefinitionMap.put("/jolokia/**", "anon");
        // 根据环境配置过滤器：测试环境不过滤，生产环境需要认证
        if (appProperties.isTest()) {
            filterChainDefinitionMap.put("/**", "anon");
        } else {
            filterChainDefinitionMap.put("/**", "authc");
        }
        shiroFilterFactoryBean.setFilterChainDefinitionMap(filterChainDefinitionMap);

        return shiroFilterFactoryBean;
    }

}

