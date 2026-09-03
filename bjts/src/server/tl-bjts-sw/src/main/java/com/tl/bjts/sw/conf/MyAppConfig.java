package com.tl.bjts.sw.conf;

import com.tl.common.conf.TLConfig;

/**
 * 说明：应用配置属性
 * 作者：王兆阳
 * 日期：2017-05-23
 **/
public class MyAppConfig {


    public static String fwzxwapiTopic = "TL_BJTS_API";//服务咨询网API rocketmq的topic
    public static String fwzxwapiTag = "FWZXWAPI_TAG";//服务咨询网API rocketmq的tag

    public static String gateWayTopic = "TL_BJTS_GATEWAY";//网关服务 rocketmq的topic
    public static String gateWayTag = "GATEWAY_TAG";//网关服务

    public static String InnerBjtsswTopic = "TL_BJTS_API";//内网管理平台 的topic
    public static String InnerBjtsswTag = "BJTSSW_REQ_TAG";//内网管理平台 的tag

}
