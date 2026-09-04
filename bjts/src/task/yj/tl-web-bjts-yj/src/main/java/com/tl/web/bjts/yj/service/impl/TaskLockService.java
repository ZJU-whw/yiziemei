package com.tl.web.bjts.yj.service.impl;

import com.tl.web.bjts.yj.dao.YsMapper;
import com.tl.web.bjts.yj.datasource.MultipleDataSource;
import com.tl.web.bjts.yj.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.yj.datasource.TargetDataSource;
import com.tl.web.bjts.yj.model.TaskVo;
import com.tl.web.bjts.yj.model.vo.LockSbxxVo;
import com.tl.web.bjts.yj.service.ITaskLockService;
import com.tl.web.bjts.yj.service.TaskGainService;
import com.tl.web.bjts.yj.utils.Cache;
import com.tl.web.bjts.yj.utils.Tools;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.*;

/**
 * 说明：${DESCRIPTION}
 * 作者：王兆阳
 * 日期：2017-11-17
 **/
@Component
public class TaskLockService implements ITaskLockService {



    Logger logger = LoggerFactory.getLogger("yj");

    private static final Object[] locks = new Object[32];
    static {
        for (int i =0;i< locks.length;i++){
            locks[i] = new Object();
        }
    }
    //获取任务服务
    private TaskGainService taskGainService;


    @Autowired
    public TaskLockService(TaskGainService service){
        this.taskGainService = service;
    }

    @Autowired
    private YsMapper ysMapper;


    @Override
    @TargetDataSource(name = MultipleDataSourceHolder.TLADMIN)
    public TaskVo lock4Yj(String threadName) {
        //每次获取多条记录，防止多线程锁定任务时冲突，而导致多次查询数据库
        List<TaskVo> tasks = taskGainService.getSbxxList4Yj(threadName);
        if(CollectionUtils.isEmpty(tasks)){
            return null;
        }
        TaskVo taskVo = null;
        for (TaskVo vo : tasks) {
            taskVo=getLockSbsj4Yj(vo.getId(),vo.getTqbz(),vo.getNsrdzdah(),vo.getTqsj() );
            if(taskVo != null){//锁定成功
                break;
            }
        }
        return taskVo;
    }


    /**
     * 获取锁定申报待预审信息
     * @param id,lastYsbz
     * @return
     */
    public TaskVo getLockSbsj4Yj(Long id,String lastTqbz,String nsrdzdah,Date lastTqsj ) {
        TaskVo ysxx=null;
        Map map=new HashMap<>();
        String tqbz = String.valueOf(System.nanoTime() );
        map.put("tqbz",tqbz);
        map.put("id",id);
        map.put("lastTqbz",lastTqbz);

        int ret ;

        synchronized (locks[Math.abs((int)(Long.parseLong(nsrdzdah)%locks.length))]){
            ret = ysMapper.updateLockSbxx4Yj(map);
        }

        LockSbxxVo sbxxVo=new LockSbxxVo();
        sbxxVo.setTqbz(tqbz);
        sbxxVo.setSbid(id);
        if(ret==1){
            logger.info("{}-【预警锁定数据】-成功",id);

            ysxx=ysMapper.queryYsSbxx4Yj(sbxxVo);
            ysxx.setTqsj(lastTqsj);
            ysxx.setYjsbny(ysxx.getSbym());

            String sbpc="";
            if(!StringUtils.isEmpty(ysxx.getSbpc())){
                sbpc=Tools.getSbpc(Integer.parseInt(ysxx.getSbpc()));
            }
            ysxx.setYjsbympc(ysxx.getSbym()+ sbpc);

            if(!StringUtils.isEmpty(Cache.instance().get("yj_"+nsrdzdah))){
                logger.warn("-{}-【预警处理，数据库锁定机制出现异常】",nsrdzdah);
                Map idMap=new HashMap();
                idMap.put("id",id);
                ysMapper.updateLockYsbz4Yj(map);
                return null;
            }else{
                Cache.instance().put("yj_"+nsrdzdah,nsrdzdah);
            }
        }else{
            logger.debug("{}-【预警锁定数据】-失败",id);
        }

        return ysxx;
    }

}
