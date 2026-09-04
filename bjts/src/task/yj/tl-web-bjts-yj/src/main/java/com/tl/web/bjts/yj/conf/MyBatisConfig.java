package com.tl.web.bjts.yj.conf;

import com.alibaba.druid.pool.DruidDataSourceFactory;
import com.tl.web.bjts.yj.datasource.MultipleDataSource;
import com.tl.web.bjts.yj.datasource.MultipleDataSourceHolder;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.type.JdbcType;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
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
@MapperScan(basePackages = "com.tl.web.bjts.yj.dao")
@ConfigurationProperties
public class MyBatisConfig {
    public Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    Environment env;

    public DataSource getTlAdminDataSource() throws Exception {
        Properties properties = buildDruidProperties("tladmin");
        return DruidDataSourceFactory.createDataSource(properties);
    }

    public DataSource getTsshDataSource() throws Exception {
        Properties properties = buildDruidProperties("tltssh");
        return DruidDataSourceFactory.createDataSource(properties);
    }

    public DataSource getjsDataSource() throws Exception {
        Properties properties = buildDruidProperties("jsxt");
        return DruidDataSourceFactory.createDataSource(properties);
    }

    public DataSource getSzdpDataSource() throws Exception {
        Properties properties = buildDruidProperties("szdp");
        return DruidDataSourceFactory.createDataSource(properties);
    }

    public DataSource getDzdzDataSource() throws Exception {
        Properties properties = buildDruidProperties("dzdz");
        return DruidDataSourceFactory.createDataSource(properties);
    }

    /**
     * 抽取通用 Druid 配置，避免重复代码
     * @param prefix
     * @return
     */
    private Properties buildDruidProperties(String prefix) {
        Properties properties = new Properties();
        properties.setProperty(DruidDataSourceFactory.PROP_DRIVERCLASSNAME, env.getProperty(prefix + ".jdbc.driverClassName"));
        properties.setProperty(DruidDataSourceFactory.PROP_URL, env.getProperty(prefix + ".jdbc.url"));
        properties.setProperty(DruidDataSourceFactory.PROP_USERNAME, env.getProperty(prefix + ".jdbc.username"));
        properties.setProperty(DruidDataSourceFactory.PROP_PASSWORD, env.getProperty(prefix + ".jdbc.password"));
        properties.setProperty(DruidDataSourceFactory.PROP_FILTERS, env.getProperty(prefix + ".jdbc.filters", "stat"));

        // 通用连接池配置
        properties.setProperty(DruidDataSourceFactory.PROP_MAXWAIT, env.getProperty("jdbc.maxWait", "60000"));
        properties.setProperty(DruidDataSourceFactory.PROP_MAXACTIVE, env.getProperty("jdbc.maxActive", "20"));
        properties.setProperty(DruidDataSourceFactory.PROP_INITIALSIZE, env.getProperty("jdbc.initialSize", "4"));
        properties.setProperty(DruidDataSourceFactory.PROP_MINIDLE, env.getProperty("jdbc.minIdle", "3"));
        properties.setProperty(DruidDataSourceFactory.PROP_TIMEBETWEENEVICTIONRUNSMILLIS, env.getProperty("jdbc.timeBetweenEvictionRunsMillis", "30000"));
        properties.setProperty(DruidDataSourceFactory.PROP_MINEVICTABLEIDLETIMEMILLIS, env.getProperty("jdbc.minEvictableIdleTimeMillis", "300000"));
        properties.setProperty(DruidDataSourceFactory.PROP_VALIDATIONQUERY, env.getProperty("jdbc.validationQuery", "select 1 from dual"));
        properties.setProperty(DruidDataSourceFactory.PROP_TESTWHILEIDLE, env.getProperty("jdbc.testWhileIdle", "true"));
        properties.setProperty(DruidDataSourceFactory.PROP_TESTONBORROW, env.getProperty("jdbc.testOnBorrow", "true"));

        properties.setProperty(DruidDataSourceFactory.PROP_POOLPREPAREDSTATEMENTS,env.getProperty("jdbc.poolPreparedStatements","false"));
        properties.setProperty(DruidDataSourceFactory.PROP_MAXOPENPREPAREDSTATEMENTS,env.getProperty("jdbc.maxPoolPreparedStatementPerConnectionSize","20"));

        //开启获取连接时的有效性校验（核心！）
        properties.setProperty(DruidDataSourceFactory.PROP_TESTONRETURN, "true");

        //启用泄露连接检测与清理（避免连接占用过久）
        properties.setProperty(DruidDataSourceFactory.PROP_REMOVEABANDONED, "true");
        properties.setProperty(DruidDataSourceFactory.PROP_REMOVEABANDONEDTIMEOUT, "180");
        return properties;
    }



    @Bean(name = "multds")
    MultipleDataSource multipleDataSource()  throws Exception{
        MultipleDataSource multipleDataSource = new MultipleDataSource();
        Map<String,DataSource> dataSourceMap = new HashMap<>();

        DataSource tladminDs = getTlAdminDataSource();

        // 数据源 key 必须和 MultipleDataSourceHolder 中的常量一致
        dataSourceMap.put(MultipleDataSourceHolder.TLADMIN, tladminDs);
        dataSourceMap.put(MultipleDataSourceHolder.TLTSSH, getTsshDataSource());
        dataSourceMap.put(MultipleDataSourceHolder.JSXT, getjsDataSource());
        dataSourceMap.put(MultipleDataSourceHolder.SZDP, getSzdpDataSource());
        dataSourceMap.put(MultipleDataSourceHolder.DZDZ, getDzdzDataSource());

        // ===== 必须添加这两行 =====
        MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.TLADMIN);
        MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.TLTSSH);
        MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.JSXT);
        MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.SZDP);
        MultipleDataSourceHolder.dataSourceIds.add(MultipleDataSourceHolder.DZDZ);

        // 设置默认数据源
        multipleDataSource.setTargetDataSources(dataSourceMap);
        multipleDataSource.setDefaultTargetDataSource(tladminDs);
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

        org.apache.ibatis.session.Configuration configuration = new org.apache.ibatis.session.Configuration();
        configuration.setJdbcTypeForNull(JdbcType.NULL);
        bean.setConfiguration(configuration);

        String mapper = env.getProperty("mybatis.mapper-locations");
        if (!StringUtils.isEmpty(mapper)){
            bean.setMapperLocations(new PathMatchingResourcePatternResolver().getResources(mapper));
        }
        return bean.getObject();
    }
}
