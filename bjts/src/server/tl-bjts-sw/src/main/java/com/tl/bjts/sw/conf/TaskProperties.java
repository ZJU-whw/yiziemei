package com.tl.bjts.sw.conf;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.stereotype.Component;

/**
 * 说明：预审任务相关配置
 * 作者：王兆阳
 * 日期：2017-11-17
 **/
@Component
@ConfigurationProperties(
        prefix = "task"
)
@RefreshScope
public class TaskProperties {
    //处理任务线程池大小
    private  int corePoolSize = 4;
    //从数据库中一次最大获取任务数
    private  int taskMaxSize = 100;
    //任务锁定最大时长（默认5分）
    private  int lockTimeout = 1;
    //从数据库获取任务周期（s）
    private  int gainPeriod = 6;

    //耗时任务队列连续轮询为空次数
    private  int taskEmpty = 5;

    //处理器线程 获取不到任务时 休眠时长（s）
    private  int idle = 3;

    private  int taskWaitSec = 10;

    public int getTaskWaitSec() {
        return this.taskWaitSec;

    }

    public void setTaskWaitSec(int taskWaitSec) {
        this.taskWaitSec = taskWaitSec;
    }

    public int getIdle() {
        return this.idle;

    }

    public void setIdle(int idle) {
        this.idle = idle;
    }

    public int getCorePoolSize() {
        return this.corePoolSize;

    }

    public void setCorePoolSize(int corePoolSize) {
        this.corePoolSize = corePoolSize;
    }

    public int getTaskMaxSize() {
        return this.taskMaxSize;

    }

    public void setTaskMaxSize(int taskMaxSize) {
        this.taskMaxSize = taskMaxSize;
    }

    public int getLockTimeout() {
        return this.lockTimeout;

    }

    public void setLockTimeout(int lockTimeout) {
        this.lockTimeout = lockTimeout;
    }

    public int getGainPeriod() {
        return this.gainPeriod;

    }

    public void setGainPeriod(int gainPeriod) {
        this.gainPeriod = gainPeriod;
    }

    public int getTaskEmpty() {
        return this.taskEmpty;

    }

    public void setTaskEmpty(int taskEmpty) {
        this.taskEmpty = taskEmpty;
    }
}
