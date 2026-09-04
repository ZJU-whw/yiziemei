package com.tl.web.bjts.yj.conf;

import com.tl.common.conf.TLConfig;

/**
 * 说明：应用配置属性
 * 作者：王兆阳
 * 日期：2017-05-23
 **/

@TLConfig
public class MyAppConfig {
    public static boolean LOCALTEST = false; //此参数控制是否调用浙科存储过程

    public static String YjTaskDm = "20";

    public static int cacheTimeOut = 60;//单位：分钟

    public static String tokenMode = "local";//token存储的模式 local是使用本地缓存 redis分布式缓

    public static boolean isClosedYjBreak=true;

}
