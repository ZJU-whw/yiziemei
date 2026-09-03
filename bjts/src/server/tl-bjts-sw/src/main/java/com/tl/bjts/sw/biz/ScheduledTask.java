package com.tl.bjts.sw.biz;


import com.google.gson.Gson;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.model.dto.NsrsbhDTO;
import com.tl.bjts.sw.model.vo.jcfx.FzHzInitVo;
import com.tl.bjts.sw.service.*;
import com.tl.bjts.sw.utils.TlCalculateUtils;
import com.tl.bjts.sw.utils.TlConst;
import com.tl.bjts.sw.utils.TlUtils;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.List;


/**
 * @Author：Mamf
 * @Date: 2017/9/6.
 * @Description:
 */
@Component
public class ScheduledTask {
    private org.slf4j.Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    TjbbBasisService tjbbBasisService;

    @Autowired
    TjfxService tjfxService;

    @Autowired
    TjbbSpecService tjbbSpecService;

    @Autowired
    RedisDelayService redisDelayService;

    @Autowired
    SjjcQueryService sjjcQueryService;

    @Autowired
    YjService yjService;

    @Autowired
    AppProperties appProperties;

    @PostConstruct
    private void init(){
        try{
            logger.info("定时任务初始化上月数据检查开始");

            String sbqb = TlCalculateUtils.getLastMonthToday("yyyyMM");

            int data = tjbbBasisService.countTaskNum(sbqb);
            if(data==0){
                logger.info("定时任务初始化本月任务列表开始");
                executeTask();

                if(!appProperties.getIsNb()){
                    executeInitE01001DataTask();
                }

                logger.info("定时任务初始化本月任务列表结束");
            }


            if(!appProperties.getIsNb()){

                redisDelayService.removeValueByKey(TlConst.REDIS_DM_CACHE_KEY);

                FzHzInitVo fzHzInitVo = tjbbBasisService.getFzHzInit();

                redisDelayService.putKeyValue(TlConst.REDIS_DM_CACHE_KEY,new Gson().toJson(fzHzInitVo));
            }



        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Scheduled(cron="0 0 3 * * ? ")
    public void loadCacheDicData() throws Exception{

        if(appProperties.getIsNb()){
            return;
        }

        try{

            logger.info("定时任务重新加载检测分析查询初始条件缓存");

            redisDelayService.removeValueByKey(TlConst.REDIS_DM_CACHE_KEY);

            FzHzInitVo fzHzInitVo = tjbbBasisService.getFzHzInit();

            redisDelayService.putKeyValue(TlConst.REDIS_DM_CACHE_KEY,new Gson().toJson(fzHzInitVo));

            logger.info("完成数据加载至Redis缓存中"+TlConst.REDIS_DM_CACHE_KEY);


        }catch (Exception e){
            e.printStackTrace();
        }

    }

    /**
     * 每月1号1点启动
     */
    @Scheduled(cron="0 0 1 1 * ?")
    public void executeTask() throws Exception{
        logger.info("定时任务启动");

        String sbqb = TlCalculateUtils.getLastMonthToday("yyyyMM");
        boolean flg=true;
        boolean isFist=true;
        int i=0;
        do{
            try {

                int data = tjbbBasisService.countTaskNum(sbqb);
                if(data==0){
                    tjbbBasisService.initTaskList(sbqb);
                    flg=false;

                    tjbbSpecService.autoMakeTjbbInit(sbqb);
                }else{
                    flg=false;
                }

            } catch (Exception e) {
                if(isFist){
                    logger.error("定时任务初始化本月任务列表开始出现异常",e);
                }else{
                    logger.error("定时任务初始化本月任务列表开始出现异常");
                }
                Thread.sleep(1000*60*60);
                isFist=false;
            }

        }while(flg&&++i<24);
        logger.info("定时任务结束");
    }


    /**
     * 每天凌晨5点清理缓存
     * 目前现改为不清理统计结果
     */
//    @Scheduled(cron="0 0 5 * * ? ")
    public void executeDelTjfxTask() throws Exception{
        logger.info("清理统计分析缓存临时表数据任务启动");
        boolean flg=true;
        boolean isFist=true;
        int i=0;
        do{
            try {
                tjfxService.delTjfxDataTask();
                flg=false;
            } catch (Exception e) {
                if(isFist){
                    logger.error("定时任务出现异常",e);
                }else{
                    logger.error("定时任务出现异常");
                }
                Thread.sleep(1000*60*60);
                isFist=false;
            }

        }while(flg&&++i<24);
        logger.info("定时清理任务结束");
    }

    /**
     * 每月1号1点启动
     */
    @Scheduled(cron= "0 0 2 1 * ?")
    public void executeInitE01001DataTask() throws Exception{

        if(appProperties.getIsNb()){
            return;
        }

        logger.info("定时任务E01001Data启动");

        String yyyy = TlCalculateUtils.getLastMonthToday("yyyy");
        String month = TlCalculateUtils.getLastMonthToday("MM");

        boolean flg=true;
        boolean isFist=true;
        int i=0;
        do{
            try {
                List<String> list = tjfxService.getSwjddm4E01001();
                for (String swjgdm : list) {
                    List<String> years = tjfxService.getYears4TaskE01001(swjgdm);
                    for(String year:years){
                        if(yyyy.equals(year)){
                            String qxdm = TlUtils.getPreSwjgdm(swjgdm);
                            tjfxService.initE01001Data(yyyy,Integer.parseInt(month),qxdm,swjgdm);
                        }
                    }
                }
                flg=false;
            } catch (Exception e) {
                if(isFist){
                    logger.error("定时任务E01001Data初始化异常",e);
                }else{
                    logger.error("定时任务E01001Data初始化异常");
                }
                Thread.sleep(1000*60*60);
                isFist=false;
            }

        }while(flg&&++i<24);
        logger.info("定时任务E01001Data结束");
    }


    /**
     * 每天执行一次计算健康码
     */
    @Scheduled(cron="0 0 6 * * ? ")
    public void executeJkmTask() throws Exception{

        if(appProperties.getIsNb()){
            return;
        }

        logger.info("计算健康码任务启动");
        boolean flg=true;
        boolean isFist=true;
        int i=0;
        do{
            try {
                NsrsbhDTO nsrsbhDTO = new NsrsbhDTO();
                sjjcQueryService.jkmRefreshProc(nsrsbhDTO);
                flg=false;
            } catch (Exception e) {
                if(isFist){
                    logger.error("定时任务出现异常",e);
                }else{
                    logger.error("定时任务出现异常");
                }
                Thread.sleep(1000*60*60);
                isFist=false;
            }

        }while(flg&&++i<24);
        logger.info("定时清理任务结束");
    }

    /**
     * 每隔15分钟执行报关单关注信息迁移任务
     * 将zj_bjts用户下已转申报的报关单迁移到tl_tssh用户下，并从zj_bjts用户下清除
     * 确保zj_bjts用户下报关单关注信息都是未申报或审核在途的
     * 确保tl_tssh用户下报关单关注信息都是审核结束的
     */
    @Scheduled(cron="0 0 23 * * ? ")
    public void executeBgdgzxxTransferTask(){
        if(appProperties.getIsNb()){
            return;
        }

        logger.info("报关单关注信息迁移任务启动");
        try {
            yjService.transferBgdgzxxToJgb();
            logger.info("报关单关注信息迁移任务完成");
        } catch (Exception e) {
            logger.error("报关单关注信息迁移任务出现异常",e);
        }
    }
}
