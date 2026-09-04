package com.tl.web.bjts.shzs.conf;

import com.alibaba.druid.pool.DruidDataSourceFactory;
import com.tl.web.bjts.shzs.datasource.MultipleDataSource;
import com.tl.web.bjts.shzs.datasource.MultipleDataSourceHolder;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.util.StringUtils;
import tk.mybatis.spring.annotation.MapperScan;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2017-05-04
 **/
@Configuration
@EnableTransactionManagement
@MapperScan(basePackages = "com.tl.web.bjts.shzs.dao")
@ConfigurationProperties
public class MyBatisConfig {
    public Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    Environment env;

    /**
     * 审核助手数据源
     * @return
     */
    public DataSource getDataSource() throws Exception{
        Properties properties = new Properties();
        properties.setProperty(DruidDataSourceFactory.PROP_DRIVERCLASSNAME,env.getProperty("jdbc.driverClassName"));
        properties.setProperty(DruidDataSourceFactory.PROP_URL,env.getProperty("jdbc.url"));
        properties.setProperty(DruidDataSourceFactory.PROP_USERNAME,env.getProperty("jdbc.username"));
        properties.setProperty(DruidDataSourceFactory.PROP_PASSWORD,env.getProperty("jdbc.password"));
        properties.setProperty(DruidDataSourceFactory.PROP_FILTERS,env.getProperty("jdbc.filters"));
        return DruidDataSourceFactory.createDataSource(properties);
    }

    /**
     * 单证备案数据源
     * @return
     */
    public DataSource getSzdpDataSource() throws Exception{
        Properties properties = new Properties();
        properties.setProperty(DruidDataSourceFactory.PROP_DRIVERCLASSNAME,env.getProperty("szdp.jdbc.driverClassName"));
        properties.setProperty(DruidDataSourceFactory.PROP_URL,env.getProperty("szdp.jdbc.url"));
        properties.setProperty(DruidDataSourceFactory.PROP_USERNAME,env.getProperty("szdp.jdbc.username"));
        properties.setProperty(DruidDataSourceFactory.PROP_PASSWORD,env.getProperty("szdp.jdbc.password"));
        properties.setProperty(DruidDataSourceFactory.PROP_FILTERS,env.getProperty("szdp.jdbc.filters"));
        return DruidDataSourceFactory.createDataSource(properties);
    }


    /**
     * 金三系统数据源
     * @return
     */

    public DataSource getJsxtDataSource() throws Exception{
        Properties properties = new Properties();
        properties.setProperty(DruidDataSourceFactory.PROP_DRIVERCLASSNAME,env.getProperty("jsxt.jdbc.driverClassName"));
        properties.setProperty(DruidDataSourceFactory.PROP_URL,env.getProperty("jsxt.jdbc.url"));
        properties.setProperty(DruidDataSourceFactory.PROP_USERNAME,env.getProperty("jsxt.jdbc.username"));
        properties.setProperty(DruidDataSourceFactory.PROP_PASSWORD,env.getProperty("jsxt.jdbc.password"));
        properties.setProperty(DruidDataSourceFactory.PROP_FILTERS,env.getProperty("jsxt.jdbc.filters"));
        return DruidDataSourceFactory.createDataSource(properties);
    }

    @Bean(name = "multds")
    MultipleDataSource multipleDataSource()  throws Exception{
        MultipleDataSource multipleDataSource = new MultipleDataSource();
        Map<String,DataSource> dataSourceMap = new HashMap<>();

        DataSource defaultSource = getDataSource();

        dataSourceMap.put(MultipleDataSourceHolder.SHZS, defaultSource);
        dataSourceMap.put(MultipleDataSourceHolder.SZDP,getSzdpDataSource());
        dataSourceMap.put(MultipleDataSourceHolder.JSXT,getJsxtDataSource());


        MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.SHZS);
        MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.SZDP);
        MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.JSXT);


        multipleDataSource.setTargetDataSources(dataSourceMap);
        multipleDataSource.setDefaultTargetDataSource(defaultSource);

        return multipleDataSource;
    }

    /**
     * spring和MyBatis完美整合 会话工程类 省去配置映射文件
     * @return
     */
    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception{
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(multipleDataSource());
        bean.setTypeAliasesPackage(env.getProperty("mybatis.type-aliases-package"));
        String mapper = env.getProperty("mybatis.mapper-locations");
        if (!StringUtils.isEmpty(mapper)){
            bean.setMapperLocations(new PathMatchingResourcePatternResolver().getResources(mapper));
        }
        return bean.getObject();
    }
}
