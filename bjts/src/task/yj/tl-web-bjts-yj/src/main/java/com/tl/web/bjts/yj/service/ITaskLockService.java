package com.tl.web.bjts.yj.service;

import com.tl.web.bjts.yj.model.TaskVo;

/**
 * 说明：锁定待预警任务接口
 * 参数：锁定的任务对象 并传递到外部
 * 返回值：null锁定失败
 **/
public interface ITaskLockService {

    TaskVo lock4Yj(String threadName);
}
