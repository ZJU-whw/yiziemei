package com.tl.web.bjts.yj.biz;


import com.tl.web.bjts.yj.dao.YjMapper;
import com.tl.web.bjts.yj.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.yj.exception.BusinessException;
import com.tl.web.bjts.yj.model.vo.FetchTaskVo;
import com.tl.web.bjts.yj.service.BaseProcServcie;
import com.tl.web.bjts.yj.service.RedisLock;
import com.tl.web.bjts.yj.utils.Tools;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;


@Component
public class ScheduledTask {

    private static final String YJ_TASK_LOCK="YJ_TASK_LOCK";

    private org.slf4j.Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource
    private RedisTemplate<String, String> redisTemplate;

    @Resource
    private YjMapper yjMapper;

    @Resource
    private BaseProcServcie baseProcServcie;

    @Resource
    private RedisLock redisLock;



    @Scheduled(cron="0/30 * * * * ?")
    public void executeTask() throws Exception {
        if (redisLock.lock(YJ_TASK_LOCK, 15*60L)) {
            runTask();
        }
    }


    private void runTask() {
        try {
            String sbsj =  yjMapper.selectMaxYjSbsj();

            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            List<FetchTaskVo> fetchTaskVoList = yjMapper.selectJsxtTaskList(Tools.parseString2Date(sbsj,"yyyy-MM-dd HH:mm:ss"));
            MultipleDataSourceHolder.clearDBType();

            /**
             * 为了解决可能存在sbsj未取尽的情况，每次提取采用大于等于的方式提取，所以，如果下次重新提取只提取到一条，认为已经是上次提取最新的记录
             */
            if(fetchTaskVoList.size()==1){
                return;
            }
            logger.info("预警定时任务获取到【{}】条,{} ",fetchTaskVoList.size(),sbsj);

            for (FetchTaskVo fetchTaskVo : fetchTaskVoList) {
                BigDecimal djxh = fetchTaskVo.getDjxh();
                BigDecimal nsrdzdah = yjMapper.selectNsrdzdahByDjxh(djxh);

                if(nsrdzdah==null){
                    logger.warn("DJXH未获取到纳税人电子档案号:{}",djxh);
                    continue;
                }

                try {
                    baseProcServcie.insertYjxx(fetchTaskVo,nsrdzdah);
                } catch (BusinessException e) {
                    logger.info("{}",e.getMsg());
                }
            }
        }catch (Exception e) {
            logger.error("error",e);
        }finally {
            MultipleDataSourceHolder.clearDBType();
            redisLock.unlock(YJ_TASK_LOCK);
        }
    }

}


