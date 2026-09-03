package com.tl.bjts.sw.datasource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

import java.util.Map;


/**
 * Created by wzy on 2016-08-10.
 */
public class MultipleDataSource extends AbstractRoutingDataSource {
    Logger logger = LoggerFactory.getLogger(MultipleDataSource.class);



    @Override
    protected Object determineCurrentLookupKey() {
        logger.debug("datasource:"+MultipleDataSourceHolder.getDBType());
        return MultipleDataSourceHolder.getDBType();
    }

    @Override
    public void setTargetDataSources(Map targetDataSources) {
        super.setTargetDataSources(targetDataSources);
        //重点 必须调用 不然不成功
        super.afterPropertiesSet();
    }
}
