package com.tl.bjts.sw.datasource;

import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2017-08-28
 **/

public class MultipleDataSourceHolder {

    private static final ThreadLocal<String> dataSourceKey = new ThreadLocal<String>();
    private static String currentDataSource ="";
    public static List<String> dataSourceIds = new ArrayList<>();
    public static final String SHZS = "shzsDs";
    public static final String SHXT = "shxtDs";
    public static  final String JSXT = "jsxtDs";
    public static  final String TSSH = "tsshDs";
    public static  final String SZDP = "szdpDs";

    public static void setDBType(String dbType) {
        dataSourceKey.set(dbType);
    }

    public static String getDBType() {
        if (!StringUtils.isBlank(dataSourceKey.get())){
            return dataSourceKey.get();
        }else{
            return SHZS;
        }

    }

    public static void clearDBType() {
        dataSourceKey.remove();
    }

    /**
     * @Description: 判断指定数据源是否存在
     * @Author Neo Lin
     * @param  [dataSourceId]
     * @return  boolean
     * @Date  2017/11/24
     */
    public static boolean containsDataSource(String dataSourceId){
        return dataSourceIds.contains(dataSourceId);
    }

}
