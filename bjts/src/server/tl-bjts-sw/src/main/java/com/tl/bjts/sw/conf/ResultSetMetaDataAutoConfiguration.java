package com.tl.bjts.sw.conf;

import com.tl.bjts.sw.interceptor.ResultSetMetaDataInterceptor;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.boot.autoconfigure.MybatisAutoConfiguration;
import org.springframework.boot.autoconfigure.AutoConfigureAfter;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.context.annotation.Configuration;

import javax.annotation.PostConstruct;
import java.util.List;

/**
 * @author: Mamf
 * @date: 2021/8/13
 * @description
 */
//@Configuration
//@ConditionalOnBean(SqlSessionFactory.class)
//@AutoConfigureAfter(MybatisAutoConfiguration.class)
public class ResultSetMetaDataAutoConfiguration {

    private List<SqlSessionFactory> sqlSessionFactoryList;

    public ResultSetMetaDataAutoConfiguration(List<SqlSessionFactory> sqlSessionFactoryList) {
        this.sqlSessionFactoryList = sqlSessionFactoryList;
    }

    @PostConstruct
    public void addResultSetMetaDataInterceptor() {
        ResultSetMetaDataInterceptor metaDataInterceptor = new ResultSetMetaDataInterceptor();

        for (SqlSessionFactory sqlSessionFactory : sqlSessionFactoryList) {
            sqlSessionFactory.getConfiguration().addInterceptor(metaDataInterceptor);
        }
    }

}
