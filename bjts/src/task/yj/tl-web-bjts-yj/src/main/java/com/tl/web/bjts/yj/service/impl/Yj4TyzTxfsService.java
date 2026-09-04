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
public class Yj4TyzTxfsService extends IYjService{

    @Autowired
    YjMapper yjMapper;

    @Autowired
    Yj4TssbService yj4TssbService;


    @Override
    protected void executeNewYjProcess(TaskVo ysxx, Map<String, String> swjgYjDicCodeMap, Map<String, YjzbItemVo> yjzbItemMap, Map yjBmdMap, Map<String, Long> tbpcMap) {
        boolean isClosedYjBreak = MyAppConfig.isClosedYjBreak;

        yj4TssbService.executeNewYjProcess(ysxx, swjgYjDicCodeMap, yjzbItemMap, yjBmdMap, tbpcMap);

//        if(isQyYj(swjgYjDicCodeMap.get(super.YjTypeHegs))
//                ||!isClosedYjBreak){
//
//            if(isQyYj(yjzbItemMap.get(YjzbCodeEnum.Z20201.getCode()))
//                    ||!isClosedYjBreak){
//
//                ysxx.setYjzbClosedTemp(!isQyYj(yjzbItemMap.get(YjzbCodeEnum.Z20201.getCode())));
//
//                String s = yjzbItemMap.get(YjzbCodeEnum.Z20201.getCode());
//                String[] split = s.split(":");
//
//                Integer score=Integer.parseInt(split[3]);
//
//                ysxx.setYjType(super.YjTypeHegs);//用于通过该大类预警代码获取适用企业、适用税务标志
//                checkHegs20201(ysxx,tbpcMap,split[1],yjBmdMap,score);
//            }
//
//        }
    }

    private void checkHegs20201(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setPval1(s);

        List<YjxxNewVo> list =yjMapper.selectMgCkka11001Sc(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11001.getCode(),score);

    }

    @Override
    protected String genNewYjmsg(YjxxNewVo yjxxVo, TaskVo ysxx, String zbcode) {
        return null;
    }
}
