package com.tl.web.bjts.yj.service;

import com.tl.web.bjts.yj.biz.InitApp;
import com.tl.web.bjts.yj.conf.MyAppConfig;
import com.tl.web.bjts.yj.conf.TaskConfig;
import com.tl.web.bjts.yj.dao.YsMapper;
import com.tl.web.bjts.yj.model.TaskVo;
import com.tl.web.bjts.yj.model.vo.GainDataVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

/**
 * 说明：从数据库获取任务服务
 * 作者：王兆阳
 * 日期：2017-11-17
 **/
@Service
@ConditionalOnBean(InitApp.class)
public class TaskGainService {

    public static String YJPOOL = "yj-pool-";
    private static String YJTHREADONE = "yj-pool-1";
    private static String YJTHREADTWO = "yj-pool-2";
    private static String YJTHREADTHREE = "yj-pool-3";
    private static String YJTHREADFOUR = "yj-pool-4";

    private static Map<String,Integer> poolYjTask = new HashMap<>();

    Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private YsMapper ysMapper;

    static {
        poolYjTask.put(YJTHREADONE,0);
        poolYjTask.put(YJTHREADTWO,0);
        poolYjTask.put(YJTHREADTHREE,0);
        poolYjTask.put(YJTHREADFOUR,0);
    }


    public List<TaskVo> getSbxxList4Yj(String threadName){
        List<TaskVo> tasks =new ArrayList<>();
        List<TaskVo> sbxxHzlist ;

        GainDataVo gainDataVo = new GainDataVo();
        gainDataVo.setSbztDm(MyAppConfig.YjTaskDm);

        //  map.put("size",);
        gainDataVo.setSize(TaskConfig.taskthreshold);
        if(threadName.equals(YJTHREADONE) || threadName.equals(YJTHREADTWO)){
            gainDataVo.setLess("1");
        }else if(threadName.equals(YJTHREADTHREE)){
            //小任务连续空闲TaskConfig.taskEmpty次，转为处理大任务
            if(poolYjTask.get(threadName) > TaskConfig.taskEmpty){
                gainDataVo.setLess("0");
                poolYjTask.put(threadName,0);
            }else{
                gainDataVo.setLess("1");
            }
        }else{
            gainDataVo.setLess("0");
        }

        double time=TaskConfig.lockTimeout/(24.0*60.0);
        BigDecimal delayTime = new BigDecimal(time);

        gainDataVo.setDelay(delayTime);
        gainDataVo.setStart("0");
        gainDataVo.setEnd(String.valueOf(TaskConfig.taskMaxSize));
        gainDataVo.setOrderByCaluse(TaskConfig.orderByCaluse);   //排序规则 优先预审重新申报的和申报日期早的


        //logger.debug("获取预警任务-->是否大任务处理线程："+gainDataVo.getLess()+",阈值："+TaskConfig.taskthreshold);
        sbxxHzlist=ysMapper.gainSbhzxx4Yj(gainDataVo);
        //logger.debug("获取到任务条数："+sbxxHzlist.size());

        Stream<TaskVo> stream = sbxxHzlist.stream();

        stream.forEach((sbxxHz)->{
            TaskVo vo = new TaskVo();
            vo.setFileSize(sbxxHz.getSbbw()==null?0:sbxxHz.getSbbw().length);
            vo.setId(sbxxHz.getId());
            vo.setTqbz(sbxxHz.getTqbz());
            vo.setNsrdzdah(sbxxHz.getNsrdzdah());
            vo.setTqsj(sbxxHz.getTqsj());
            tasks.add(vo);
        });
        if(CollectionUtils.isEmpty(tasks)){
            //任务空闲加+1
            poolYjTask.put(threadName,poolYjTask.get(threadName) + 1);
        }
        return tasks;
    }

}
