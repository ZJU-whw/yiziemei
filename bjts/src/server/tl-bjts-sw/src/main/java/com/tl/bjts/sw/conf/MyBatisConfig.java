package com.tl.bjts.sw.conf;

import com.alibaba.druid.pool.DruidDataSourceFactory;
import com.tl.bjts.sw.datasource.MultipleDataSource;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.type.JdbcType;
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
@MapperScan(basePackages = "com.tl.bjts.sw.dao")
@ConfigurationProperties
public class MyBatisConfig {
    public Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    Environment env;

    @Autowired
    AppProperties appProperties;

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
     * 审核系统数据源
     * @return
     */
    public DataSource getShxtDataSource() throws Exception{
        Properties properties = new Properties();
        properties.setProperty(DruidDataSourceFactory.PROP_DRIVERCLASSNAME,env.getProperty("shxt.jdbc.driverClassName"));
        properties.setProperty(DruidDataSourceFactory.PROP_URL,env.getProperty("shxt.jdbc.url"));
        properties.setProperty(DruidDataSourceFactory.PROP_USERNAME,env.getProperty("shxt.jdbc.username"));
        properties.setProperty(DruidDataSourceFactory.PROP_PASSWORD,env.getProperty("shxt.jdbc.password"));
        properties.setProperty(DruidDataSourceFactory.PROP_FILTERS,env.getProperty("shxt.jdbc.filters"));
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

    /**
     * 通览退税审核
     * @return
     */

    public DataSource getTsshDataSource() throws Exception{
        Properties properties = new Properties();
        properties.setProperty(DruidDataSourceFactory.PROP_DRIVERCLASSNAME,env.getProperty("tltssh.jdbc.driverClassName"));
        properties.setProperty(DruidDataSourceFactory.PROP_URL,env.getProperty("tltssh.jdbc.url"));
        properties.setProperty(DruidDataSourceFactory.PROP_USERNAME,env.getProperty("tltssh.jdbc.username"));
        properties.setProperty(DruidDataSourceFactory.PROP_PASSWORD,env.getProperty("tltssh.jdbc.password"));
        properties.setProperty(DruidDataSourceFactory.PROP_FILTERS,env.getProperty("tltssh.jdbc.filters"));
        return DruidDataSourceFactory.createDataSource(properties);
    }

    /**
     * 数字电票数据源
     * @return
     * @throws Exception
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

    @Bean(name = "multds")
    MultipleDataSource multipleDataSource()  throws Exception{
        MultipleDataSource multipleDataSource = new MultipleDataSource();
        Map<String,DataSource> dataSourceMap = new HashMap<>();


        dataSourceMap.put(MultipleDataSourceHolder.SHZS,getDataSource());
        MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.SHZS);

        if(!appProperties.getIsNb()){
            dataSourceMap.put(MultipleDataSourceHolder.SHXT,getShxtDataSource());
            dataSourceMap.put(MultipleDataSourceHolder.JSXT,getJsxtDataSource());
            dataSourceMap.put(MultipleDataSourceHolder.TSSH,getTsshDataSource());
            dataSourceMap.put(MultipleDataSourceHolder.SZDP,getSzdpDataSource());
            MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.SHXT);
            MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.JSXT);
            MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.TSSH);
            MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.SZDP);
        }

        multipleDataSource.setTargetDataSources(dataSourceMap);
        return multipleDataSource;
    }

    /**
     * spring和MyBatis完美整合 会话工程类 省去配置映射文件
     * @return
     */
    @Bean
    public SqlSessionFactory sqlSessionFactory(DataSource ds) throws Exception{
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(ds);
        bean.setTypeAliasesPackage(env.getProperty("mybatis.type-aliases-package"));

        String mapper = env.getProperty("mybatis.mapper-locations");
        if (!StringUtils.isEmpty(mapper)){
            bean.setMapperLocations(new PathMatchingResourcePatternResolver().getResources(mapper));
        }
        bean.getObject().getConfiguration().setJdbcTypeForNull(JdbcType.NULL);
        bean.getObject().getConfiguration().setCallSettersOnNulls(true);
        return bean.getObject();
    }
}
