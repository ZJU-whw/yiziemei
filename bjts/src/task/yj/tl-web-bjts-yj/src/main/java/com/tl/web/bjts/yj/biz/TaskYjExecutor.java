package com.tl.web.bjts.yj.biz;


import com.tl.web.bjts.yj.conf.TaskConfig;
import com.tl.web.bjts.yj.dao.YjYjxxModelMapper;
import com.tl.web.bjts.yj.dao.YsMapper;
import com.tl.web.bjts.yj.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.yj.exception.BusinessException;
import com.tl.web.bjts.yj.model.TaskVo;
import com.tl.web.bjts.yj.model.domain.YjYjxxModel;
import com.tl.web.bjts.yj.service.*;
import com.tl.web.bjts.yj.utils.Cache;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.IntStream;

/**
 * 说明：预审任务处理线程池
 * 作者：王兆阳
 * 日期：2017-11-17
 **/
@ConditionalOnBean(InitApp.class)
@Component
public class TaskYjExecutor implements ApplicationListener<ContextRefreshedEvent> {
    private Logger logger = LoggerFactory.getLogger(TaskYjExecutor.class);
    private ExecutorService executorService = null;

    @Autowired
    ITaskLockService lockService;

    @Autowired
    YsMapper ysMapper;

    @Autowired
    YjYjxxModelMapper yjYjxxModelMapper;

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
        if (executorService == null) {
            executorService = Executors.newFixedThreadPool(TaskConfig.corePoolSize);
        }

        IntStream.range(0, TaskConfig.corePoolSize).
                forEach(i -> executorService.submit(() -> {
                    Thread.currentThread().setName(TaskGainService.YJPOOL+(i + 1));
                    //预审开始
                    TaskVo yjxx;
                    while (!Thread.currentThread().isInterrupted()) {
                        Long startTime = System.currentTimeMillis();
                        try {
                            //1，锁定处理任务
                            yjxx = lockService.lock4Yj(Thread.currentThread().getName());
                        }catch (BusinessException e){
                            logger.error(e.getMsg());
                            continue;
                        }catch (Exception e){
                            logger.error("【WARNING】-预警数据锁定任务出现未知异常",e);
                            yjxx=null;
                        }catch (Throwable te){
                            logger.error("【ERROR】-预警数据锁定任务出现Throwable异常",te);
                            yjxx=null;
                        }
                        try {
                            if (yjxx != null) {

                                MultipleDataSourceHolder.clearDBType();

                                IYjService yjService = getYjService(yjxx.getLcId());

                                if (yjService != null) {
                                    logger.info("{}-预警处理开始： ", yjxx.getId());

                                    //1.删除预警信息
                                    delYjxx(yjxx.getId());

                                    //2.执行预警服务
                                    yjService.executeYj(yjxx);

                                    //3.插入同步预警信息表
                                    String yjztdm="OK";
                                    if(yjxx.isHaveYjxx()){
                                        yjztdm="YJ";
                                        logger.info("{}-存在预警疑点信息，落地执行成功。 ", yjxx.getId());
                                    }
                                    //4.更新预警任务状态
                                    process(yjxx.getId(),yjztdm);
                                }

                            } else {
                                //logger.info("任务队列无数据，休眠 " + TaskConfig.idle + "秒");
                                Thread.sleep(TaskConfig.idle * 1000);
                            }

                        } catch (BusinessException e) {
                            logger.info("{}-当前预警任务执行终止原因："  + e.getMsg(),yjxx.getId());
                        } catch (Exception e){
                            logger.error("当前预警任务出现未知异常：" ,e);
                        } catch (Throwable te){
                            logger.error("【ERROR】-预审出现Throwable异常",te);
                        } finally {
                            //从缓存中移除当前纳税人电子档案号
                            if(yjxx==null){
                                continue;
                            }

                            try{
                                Cache.instance().remove("yj_"+yjxx.getNsrdzdah());
                                logger.info("{}-预警流程走完，移除纳税人电子档案号锁定：{}",yjxx.getId(),yjxx.getNsrdzdah());
                            }catch (Exception e){
                                logger.error("【ERROR】-Cache缓存Nsrdzdah出现未知异常",e);
                            }catch (Throwable te){
                                logger.error("【ERROR】-Cache缓存Nsrdzdah出现Throwable异常",te);
                            }

                            Long end = System.currentTimeMillis();
                            logger.debug("{}-execute yj-{} ms",yjxx.getId(),String.valueOf(end-startTime));
                        }
                    }

                }));
    }


    private IYjService getYjService(String lcid) {
        IYjService yjService;
        //1. 预审支持业务判断
        boolean containsKey = YjServiceFactory.yjTypeMap.containsKey(lcid);
        if (!containsKey) {
            logger.info("{}-执行退税申报预警服务：-", lcid);
            IYjService tssbService = (IYjService) BeanFactory.getApplicationContext().getBean("yj4TssbService");
            return  tssbService;
        }
        yjService = YjServiceFactory.getService(lcid);
        return yjService;
    }

    /**
     * 处理预警后事项
     * @param id
     * @param yjdm
     */
    private void process(Long id,String yjdm){
        Map idMap=new HashMap();
        idMap.put("id",id);
        idMap.put("yjdm",yjdm);
        ysMapper.updateYjComplete(idMap);
    }

    private void delYjxx(Long sbid){
        ysMapper.deleteSbpc(sbid);
    }

}
