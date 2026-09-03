package com.tl.bjts.sw.interceptor;

import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.utils.Cache;
import com.tl.bjts.sw.utils.TlUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.ibatis.executor.resultset.ResultSetHandler;
import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.reflection.SystemMetaObject;

import java.sql.*;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import java.util.stream.IntStream;

/**
 * @author: Mamf
 * @date: 2021/8/13
 * @description
 */
@Intercepts({
        @Signature(type = ResultSetHandler.class, method = "handleResultSets", args = {Statement.class})})
public class ResultSetMetaDataInterceptor implements Interceptor {

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        // implement pre processing if need
        Object returnObject = invocation.proceed();
        try {
            if (returnObject instanceof List) {
                List list = (List) returnObject;
                if (CollectionUtils.isEmpty(list)) {
                    Statement stmt = (Statement) invocation.getArgs()[0];
                    ResultSetMetaData metaData = stmt.getResultSet().getMetaData();
                    int length = metaData.getColumnCount();
                    String[] columns = new String[length];
                    IntStream.rangeClosed(1, metaData.getColumnCount()).forEach(index -> {
                        try {
                            columns[index - 1] = metaData.getColumnName(index);
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    });

                    boolean isTaskRun = false;
                    for (String column : columns) {
                        if(column.equals("REQPARAM")){
                            isTaskRun = true ;
                        }
                    }

                    if(!isTaskRun){
                        TlUtils.dynnamicColumn.set(columns);
                    }

                }
            }
        } catch (Exception e) {
        }
        return returnObject;
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {

    }

}
