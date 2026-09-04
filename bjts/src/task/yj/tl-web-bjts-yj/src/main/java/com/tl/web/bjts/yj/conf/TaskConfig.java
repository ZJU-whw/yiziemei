package com.tl.web.bjts.yj.conf;

import com.tl.common.conf.TLConfig;

/**
 * 说明：预审任务相关配置
 * 作者：王兆阳
 * 日期：2017-11-17
 **/
@TLConfig
public class TaskConfig {
    //处理任务线程池大小
    public static int corePoolSize = 4;
    //从数据库中一次最大获取任务数
    public static int taskMaxSize = 100;
    //任务锁定最大时长（默认5分）
    public static int lockTimeout = 5;
    //从数据库获取任务周期（s）
    public static int gainPeriod = 6;
    //申报任务大小阈值暂定100K
    public static int taskthreshold = 15000;

    //耗时任务队列连续轮询为空次数
    public static int taskEmpty = 5;

    //预审处理器线程 获取不到任务时 休眠时长（s）
    public static int idle = 3;

    //提取申报任务时的规则
    public static String orderByCaluse = "sbcs desc,sbrq asc";

    public static String lastProcChange="2018-01-01 18:00:00";
}
