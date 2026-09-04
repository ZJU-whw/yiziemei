package com.tl.web.bjts.yj.datasource;

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
    public static List<String> dataSourceIds = new ArrayList<>();

    public static final String JSXT = "jsxtDs";
    public static final String TLADMIN = "tladminDs";
    public static final String TLTSSH = "tlTsshDs";
    public static final String SZDP = "szdpDs";
    public static final String DZDZ = "dzdzDs";


    public static void setDBType(String dbType) {
        dataSourceKey.set(dbType);
    }

    public static String getDBType() {
        if (!StringUtils.isBlank(dataSourceKey.get())){
            return dataSourceKey.get();
        }else{
            return TLADMIN;
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
