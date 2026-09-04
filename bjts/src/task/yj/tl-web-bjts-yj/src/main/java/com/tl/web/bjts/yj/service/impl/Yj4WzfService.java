package com.tl.web.bjts.yj.service.impl;

import com.tl.web.bjts.yj.conf.MyAppConfig;
import com.tl.web.bjts.yj.dao.YjMapper;
import com.tl.web.bjts.yj.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.yj.datasource.TargetDataSource;
import com.tl.web.bjts.yj.model.TaskVo;
import com.tl.web.bjts.yj.model.YjPramDTO;
import com.tl.web.bjts.yj.model.YjzbCodeEnum;
import com.tl.web.bjts.yj.model.vo.YjxxNewVo;
import com.tl.web.bjts.yj.model.vo.YjxxVo;
import com.tl.web.bjts.yj.model.vo.YjzbItemVo;
import com.tl.web.bjts.yj.service.IYjService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author：Mamf
 * @Date: 2017/12/29.
 * @Description:
 */
@Service
public class Yj4WzfService extends IYjService{

    private Logger logger = LoggerFactory.getLogger(Yj4WzfService.class);


    @Autowired
    YjMapper yjMapper;


    @Autowired
    Yj4TssbService yj4TssbService;


    @Override
    protected void executeNewYjProcess(TaskVo ysxx, Map<String, String> swjgYjDicCodeMap, Map<String, YjzbItemVo> yjzbItemMap, Map yjBmdMap, Map<String, Long> tbpcMap) {

        boolean isClosedYjBreak = MyAppConfig.isClosedYjBreak;

        yj4TssbService.executeNewYjProcess(ysxx, swjgYjDicCodeMap, yjzbItemMap, yjBmdMap, tbpcMap);

        if((isQyYj(swjgYjDicCodeMap.get(super.YjTypeHegs))
                ||!isClosedYjBreak) && false){

            ysxx.setYjType(super.YjTypeHegs);//用于通过该大类预警代码获取适用企业、适用税务标志

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z20201.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z20201.getCode(),YjzbCodeEnum.Z20201.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z20201.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z20201.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkHegs20201(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjBmdMap,score);
            }
        }
    }

    private void checkHegs20201(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setPval1(s);

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectHegs20201Wzf(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z20201.getCode(),score);
    }

    @Override
    protected String genNewYjmsg(YjxxNewVo yjxxVo, TaskVo ysxx, String zbcode) {
        String yjMsg = "";
        if(YjzbCodeEnum.Z20201.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_object()+"），霍尔果斯口岸出口的皮毛类商品（"+yjxxVo.getCmcode()+"），请加强审核！";
        }
        return yjMsg;
    }
}
