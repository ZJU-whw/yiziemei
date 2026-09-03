package com.tl.bjts.sw.biz;


import com.google.gson.Gson;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.conf.TaskProperties;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.domain.JcfxTaskModel;
import com.tl.bjts.sw.model.dto.DynamicQueryDTO;
import com.tl.bjts.sw.model.vo.SjjcDynamicVo;
import com.tl.bjts.sw.service.TaskGainService;
import com.tl.bjts.sw.service.TjbbBasisService;
import com.tl.bjts.sw.utils.GZipUitl;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.IntStream;

/**
 * 说明：预审任务处理线程池
 * 作者：王兆阳
 * 日期：2017-11-17
 **/
@Component
public class DynamicQueryTaskExecutor implements ApplicationListener<ContextRefreshedEvent> {
    private Logger logger = LoggerFactory.getLogger(DynamicQueryTaskExecutor.class);
    private ExecutorService executorService = null;

    @Autowired
    TaskProperties taskProperties;

    @Autowired
    TaskGainService taskGainService;

    @Autowired
    TjbbBasisService tjbbBasisService;

    @Autowired
    AppProperties appProperties;

    @PostConstruct
    public void init() {

    }

    @PreDestroy
    public void destroy() {
        if (executorService != null) {
            executorService.shutdownNow();
        }
    }


    @Override
    public void onApplicationEvent(ContextRefreshedEvent contextRefreshedEvent) {

        if(appProperties.getIsNb()){
            return;
        }

        if (executorService == null) {
            executorService = Executors.newFixedThreadPool(taskProperties.getCorePoolSize());
        }

        IntStream.range(0, taskProperties.getCorePoolSize()).
                forEach(i -> executorService.submit(() -> {
                    Thread.currentThread().setName(TaskGainService.TASK_POOL+(i + 1));
                    //预审开始
                    JcfxTaskModel task=null;
                    while (!Thread.currentThread().isInterrupted()) {
                        Long startTime = System.currentTimeMillis();
                        try {
                            //1，锁定处理任务
                            task = taskGainService.lockTask();
                        }catch (BusinessException e){
                            logger.error(e.getMsg());
                            continue;
                        }catch (Exception e){
                            logger.error("【WARNING】-数据锁定任务出现未知异常",e);
                        }catch (Throwable te){
                            logger.error("【ERROR】-数据锁定任务出现Throwable异常",te);
                        }

                        try {
                            if (task != null) {

                                DynamicQueryDTO dynamicQueryDTO = new Gson().fromJson(task.getReqParam(), DynamicQueryDTO.class);

                                StringBuffer sqltext = new StringBuffer();
                                SjjcDynamicVo sjjcDynamicVo = tjbbBasisService.getDynamicData(task.getId(),dynamicQueryDTO,sqltext);

                                byte[] data = GZipUitl.genZip(new Gson().toJson(sjjcDynamicVo));

                                if(data!=null && data.length>0){
                                    taskGainService.completeTask(task.getId(),data,sqltext);

                                    if((StringUtils.isNotBlank(task.getBbtype()) && !task.getBbtype().startsWith("x")
                                            )||dynamicQueryDTO.getTjbbType().startsWith("XLS")){
                                        taskGainService.processSubTaskQuery(sjjcDynamicVo,dynamicQueryDTO,task);

                                    }


                                }

                            } else {
                                //logger.info("任务队列无数据，休眠 " + TaskConfig.idle + "秒");
                                Thread.sleep(taskProperties.getIdle() * 1000);
                            }

                        } catch (BusinessException e) {
                            logger.error("{}-当前任务执行终止原因：",e );
                            taskGainService.updateErrorTask(task.getId());
                        } catch (Exception e){
                            logger.error("{}-当前任务出现未知异常：",e);
                            taskGainService.updateErrorTask(task.getId());
                        } catch (Throwable te){
                            logger.error("【ERROR】-出现Throwable异常",te);
                            taskGainService.updateErrorTask(task.getId());
                        } finally {
                            if(task==null){
                                continue;
                            }
                            Long end = System.currentTimeMillis();
                            logger.debug("{}-execute {} ms",task.getId(),String.valueOf(end-startTime));
                        }
                    }

                }));
    }

}
