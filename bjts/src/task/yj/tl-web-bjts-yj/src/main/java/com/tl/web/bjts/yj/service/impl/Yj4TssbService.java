package com.tl.web.bjts.yj.service.impl;

import com.tl.web.bjts.yj.conf.MyAppConfig;
import com.tl.web.bjts.yj.dao.YjMapper;
import com.tl.web.bjts.yj.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.yj.model.*;
import com.tl.web.bjts.yj.model.vo.YjxxNewVo;
import com.tl.web.bjts.yj.model.vo.YjzbItemVo;
import com.tl.web.bjts.yj.service.IYjService;
import com.tl.web.bjts.yj.utils.ConstUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @Author：Mamf
 * @Date: 2017/12/29.
 * @Description:
 */
@Service
public class Yj4TssbService extends IYjService {

    private Logger logger = LoggerFactory.getLogger(Yj4TssbService.class);

    @Autowired
    YjMapper yjMapper;

    @Override
    protected void executeNewYjProcess(TaskVo ysxx, Map<String, String> swjgYjDicCodeMap, Map<String, YjzbItemVo> yjzbItemMap, Map yjBmdMap, Map<String, Long> tbpcMap) {

        /**
         * 此处处理一些多业务公用的预警
         */
        if(!"TSSB".equals(ysxx.getSbzlDm())){
            logger.info("{}-非TSSB业务跳过退税申报预警服务：", ysxx.getId());
            return;
        }

        yjxxMapThread.set(swjgYjDicCodeMap);
        yjzbMapThread.set(yjzbItemMap);

        boolean isClosedYjBreak = MyAppConfig.isClosedYjBreak;

        if(isQyYj(swjgYjDicCodeMap.get(super.YjTypeDzba))
                ||!isClosedYjBreak){

            ysxx.setYjType(super.YjTypeDzba);

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z11601.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z11601.getCode(),YjzbCodeEnum.Z11601.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z11601.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z11601.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkDzabWwc11601(ysxx,tbpcMap,yjBmdMap,score);

            }

        }


        if(isQyYj(swjgYjDicCodeMap.get(super.YjTypeXbqy))
                ||!isClosedYjBreak){

            ysxx.setYjType(super.YjTypeXbqy);

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z11801.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z11801.getCode(),YjzbCodeEnum.Z11801.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z11801.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z11801.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkXbqy11801(ysxx,tbpcMap,yjBmdMap,score);

            }

        }

        boolean isSC2wm = ConstUtil.SC_SBYW.equals(ysxx.getLcId()) || ConstUtil.WM_SBYW.equals(ysxx.getLcId());
        if(isSC2wm && (isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeFxqydcpg)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeFxqydcpg);

            //16405: 三新预警单笔涉税金额超阈值预警
            boolean isWm = ConstUtil.WM_SBYW.equals(ysxx.getLcId());
            if((isWm && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16405.getCode()))) ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16405.getCode(),YjzbCodeEnum.Z16405.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16405.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16405.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkFxqydcpg16405(ysxx,tbpcMap,yjBmdMap,score);
            }

            //16407: 出口企业正在接受稽查预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16407.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16407.getCode(),YjzbCodeEnum.Z16407.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16407.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16407.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkFxqydcpg16407(ysxx,tbpcMap,yjBmdMap,score);
            }

            //16407: 出口数据被关注预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16408.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16408.getCode(),YjzbCodeEnum.Z16408.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16408.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16408.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkFxqydcpg16408(ysxx,tbpcMap,yjBmdMap,score);
            }
        }

        /*
         * 101: 新增商品代码预警
         */
        if(isSC2wm && (isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeSpdm)) ||!isClosedYjBreak)){
            ysxx.setYjType(IYjService.YjTypeSpdm);//用于通过该大类预警代码获取适用企业、适用税务标志

            logger.info("【执行预警指标：{}】",IYjService.YjTypeSpdm);
            checkSpdm101All(ysxx,tbpcMap,yjBmdMap,yjzbItemMap);
        }

        /*
         * 103:首次申报出口退税预警
         */
        if(isSC2wm && (isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeEnterprise)) ||!isClosedYjBreak)){
            ysxx.setYjType(IYjService.YjTypeEnterprise);

            logger.info("【执行预警指标：{}】",IYjService.YjTypeEnterprise);
            checkFirstTsckAll(ysxx,tbpcMap,yjBmdMap,yjzbItemMap);
        }

        /*
         * 122:总局下发风险报关行预警
         */
        if(isSC2wm && (isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeFxbgh)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeFxbgh);

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12201.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z12201.getCode(),YjzbCodeEnum.Z12201.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12201.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z12201.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkFxbgh12201(ysxx,tbpcMap,yjzbItemVo,yjBmdMap,score);
            }
        }

    }

    /**
     * 首次申报出口退税预警
     * @param ysxx
     * @param tbpcMap
     * @param yjBmdMap
     * @param yjzbItemMap
     */
    private void checkFirstTsckAll(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Map<String, YjzbItemVo> yjzbItemMap) {

        YjzbItemVo yjzb10302ItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10302.getCode());
        boolean isYjZb10302 = (isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10302.getCode())))||!MyAppConfig.isClosedYjBreak;

        if(!isYjZb10302){
            super.clearDBType();
            return;
        }

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setPval1(yjzb10302ItemVo.getP1val());
        pramDTO.setLcslid(ysxx.getLcslid());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        Integer cnt =yjMapper.selectFirstTsck10302ScWm(ysxx.getLcslid(),-1*Integer.parseInt(yjzb10302ItemVo.getP1val()));

        List<YjxxNewVo> list=new ArrayList<>();
        if(cnt!=null && cnt==1){
            list.add(new YjxxNewVo());
        }

        if((!list.isEmpty() && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10302.getCode())))
                ||!MyAppConfig.isClosedYjBreak){
            ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10302.getCode())));
            Integer score=Integer.parseInt(yjzb10302ItemVo.getScore());
            super.insertYjDataYjxx(list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z10302.getCode(), score);
        }

    }

    /**
     * 新增商品代码预警
     * @param ysxx
     * @param tbpcMap
     * @param yjBmdMap
     * @param yjzbItemMap
     */
    private void checkSpdm101All(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Map<String, YjzbItemVo> yjzbItemMap) {

        YjzbItemVo yjzb10101ItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10101.getCode());
        YjzbItemVo yjzb10104ItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10104.getCode());
        YjzbItemVo yjzb10105ItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10105.getCode());

        boolean isYjZb10101 = (isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10101.getCode())))||!MyAppConfig.isClosedYjBreak;
        boolean isYjZb10104 = (isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10104.getCode())))||!MyAppConfig.isClosedYjBreak;
        boolean isYjZb10105 = (isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10105.getCode())))||!MyAppConfig.isClosedYjBreak;

        if(!isYjZb10104 && !isYjZb10101 && !isYjZb10105){
            super.clearDBType();
            return;
        }

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setPval1(yjzb10101ItemVo.getP1val());
        pramDTO.setLcslid(ysxx.getLcslid());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        List<YjxxNewVo> list;
        if(ConstUtil.SC_SBYW.equals(ysxx.getLcId())){
            list =yjMapper.selectSpdmSc10101(pramDTO);
        }else {
            list =yjMapper.selectSpdmWm10101(pramDTO);
        }


        List<YjxxNewVo> yjzb10101list=new ArrayList<>();
        List<YjxxNewVo> yjzb10104list=new ArrayList<>();
        List<YjxxNewVo> yjzb10105list=new ArrayList<>();
        for (YjxxNewVo yjxxNewVo : list) {
            boolean isAbQyGllbDm = Arrays.asList("A", "B").contains(yjxxNewVo.getCkqygllbDm());
            if(isYjZb10104 && isAbQyGllbDm && new BigDecimal(yjxxNewVo.getYj_tax()).compareTo(new BigDecimal(yjzb10104ItemVo.getP1val())) > 0){
                yjxxNewVo.setOffset(yjzb10104ItemVo.getP1val());
                yjzb10104list.add(yjxxNewVo);
            }else if (isYjZb10105 && !isAbQyGllbDm && new BigDecimal(yjxxNewVo.getYj_tax()).compareTo(new BigDecimal(yjzb10105ItemVo.getP1val())) > 0){
                yjxxNewVo.setOffset(yjzb10105ItemVo.getP1val());
                yjzb10105list.add(yjxxNewVo);
            }else if(isYjZb10101){
                yjzb10101list.add(yjxxNewVo);
            }
        }

        if((!yjzb10101list.isEmpty() && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10101.getCode())))
                ||!MyAppConfig.isClosedYjBreak){
            ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10101.getCode())));
            Integer score=Integer.parseInt(yjzb10101ItemVo.getScore());
            super.insertYjDataYjxx(yjzb10101list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z10101.getCode(), score);
        }
        if((!yjzb10104list.isEmpty() && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10104.getCode())))
                ||!MyAppConfig.isClosedYjBreak){
            ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10104.getCode())));
            Integer score=Integer.parseInt(yjzb10104ItemVo.getScore());
            super.insertYjDataYjxx(yjzb10104list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z10104.getCode(), score);
        }

        if((!yjzb10105list.isEmpty() && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10105.getCode())))
                ||!MyAppConfig.isClosedYjBreak){
            ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10105.getCode())));
            Integer score=Integer.parseInt(yjzb10105ItemVo.getScore());
            super.insertYjDataYjxx(yjzb10105list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z10105.getCode(), score);
        }

    }

    /**
     * 出口数据被关注预警
     * @param ysxx
     * @param tbpcMap
     * @param yjBmdMap
     * @param score
     */
    private void checkFxqydcpg16408(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Integer score) {
        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        // 查询被关注的出口数据
        List<YjxxNewVo> list = yjMapper.selectBgdGzxxList(ysxx.getLcslid());

        super.insertYjDataYjxx(list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16408.getCode(), score);
    }

    /**
     * 出口企业正在接受稽查预警
     * @param ysxx
     * @param tbpcMap
     * @param yjBmdMap
     * @param score
     */
    private void checkFxqydcpg16407(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Integer score) {
        String djxh = ysxx.getCpcode();

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        Integer cnt = yjMapper.selectCkqyZzjc4ScWm(djxh);

        List<YjxxNewVo> resultList = new ArrayList<>();
        if(cnt != null && cnt > 0){
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setYj_count(String.valueOf(cnt));
            yjxxVo.setLcslid(ysxx.getLcslid());
            yjxxVo.setYjMsg("该企业因涉嫌骗税、虚开正在接受稽查，请加强审核！");
            resultList.add(yjxxVo);
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16407.getCode(), score);
    }

    private void checkFxqydcpg16405(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Integer score) {

        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        List<YjxxNewVo> list = yjMapper.selectDcbpWjcList4Wm(ysxx.getLcslid());

        List<YjxxNewVo> resultList = new ArrayList<>();
        for (YjxxNewVo yjxxNewVo : list) {
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setYj_object(yjxxNewVo.getYj_object());
            yjxxVo.setYjMsg("该企业（"+yjxxVo.getYj_object()+"）正在调查评估未解除，请加强审核！");
            resultList.add(yjxxVo);
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16405.getCode(), score);
    }

    private void checkXbqy11801(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Integer score) {
        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        String djxh = yjMapper.selectDjxhByNsrsbh(ysxx.getNsrdjno());
        super.clearDBType();

        if(StringUtils.isEmpty(djxh)){
            logger.warn("未查询到登记序号：{}",ysxx.getNsrdjno());
            return;
        }

        YjProcParamModel yjParamSet=new YjProcParamModel();
        yjParamSet.setDjxh(djxh);
        yjParamSet.setSwjgdm(ysxx.getSwcode());

        yjMapper.callProcedureCheckXblqy(yjParamSet);

        List<YjxxNewVo> list=new ArrayList<>();
        if(!"00".equals(yjParamSet.getOutmsg())){
            YjxxNewVo obj=new YjxxNewVo();
            obj.setYjMsg(yjParamSet.getOutmsg());
            list.add(obj);
        }

        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11801.getCode(),score);
    }


    private void checkDzabWwc11601(TaskVo ysxx, Map<String, Long> tbpcMap,Map yjBmdMap, Integer score){

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        String djxh = yjMapper.selectDjxhByNsrsbh(ysxx.getNsrdjno());

        super.clearDBType();

        if(StringUtils.isEmpty(djxh)){
            logger.warn("未查询到登记序号：{}",ysxx.getNsrdjno());
            return;
        }

        List<YjxxNewVo> list=new ArrayList<>();
        int cnt =yjMapper.selectDzabWwc11601(djxh);
        super.clearDBType();

        if(cnt>0){
            YjxxNewVo obj=new YjxxNewVo();
            obj.setYj_record("1");
            list.add(obj);
        }

        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11601.getCode(),score);
    }

    /**
     * 
     * 12201 - 总局下发风险报关行预警
     * 实现逻辑：
     * 1. 在 JSXT 数据源查询申报明细+报关单电子信息，提取申报单位名称(SBDWMC)
     * 2. 在 TLADMIN 数据源查询风险报关行配置表，获取风险报关行名称列表
     * 3. 比对申报单位名称是否在风险报关行名称列表中
     * 4. 筛选退免税额 >= 阈值的数据触发预警
     *
     * @param ysxx 任务信息
     * @param tbpcMap 同步批次MAP
     * @param yjzbItemVo 预警指标配置(P1val=退免税额阈值)
     * @param yjBmdMap 预警名单MAP
     * @param score 预警分值
     */
    private void checkFxbgh12201(TaskVo ysxx, Map<String, Long> tbpcMap, YjzbItemVo yjzbItemVo, Map yjBmdMap, Integer score){
        if(StringUtils.isEmpty(yjzbItemVo.getP1val())){
            logger.warn("预警指标：12201，退免税额阈值未设置，跳过处理");
            return;
        }

        YjPramDTO pramDTO = new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        pramDTO.setPval1(yjzbItemVo.getP1val());

        // 步骤1：在 JSXT 数据源查询申报明细及报关单电子信息中的申报单位名称
        // 根据企业类型调用不同的SQL（阈值判断已在SQL HAVING子句中处理）
        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        List<YjxxNewVo> sbdwList;
        if(ConstUtil.SC_SBYW.equals(ysxx.getLcId())){
            // 生产企业
            sbdwList = yjMapper.selectFxbghSbdw12201Sc(pramDTO);
        }else if(ConstUtil.WM_SBYW.equals(ysxx.getLcId())){
            // 外贸企业
            sbdwList = yjMapper.selectFxbghSbdw12201Wm(pramDTO);
        }else{
            logger.info("预警指标：12201，企业类型[{}]不在生产/外贸范围内，跳过处理", ysxx.getLcId());
            super.clearDBType();
            return;
        }

        if(sbdwList == null || sbdwList.isEmpty()){
            logger.info("预警指标：12201，未查询到报关单申报数据");
            super.clearDBType();
            return;
        }

        // 步骤2：在 TLADMIN 数据源查询风险报关行配置表
        super.changeDataSource(MultipleDataSourceHolder.TLADMIN);
        List<String> fxbghList = yjMapper.selectFxbghList12201();

        if(fxbghList == null || fxbghList.isEmpty()){
            logger.info("预警指标：12201，未查询到风险报关行配置数据");
            super.clearDBType();
            return;
        }

        // 将风险报关行名称转换为 Set 用于快速匹配
        Set<String> fxbghSet = new HashSet<>();
        for(String bghmc : fxbghList){
            if(StringUtils.isNotEmpty(bghmc)){
                fxbghSet.add(bghmc.trim());
            }
        }

        // 步骤3：遍历申报数据，比对申报单位名称是否在风险报关行名称列表中
        List<YjxxNewVo> resultList = new ArrayList<>();
        for(YjxxNewVo vo : sbdwList){
            String sbdwmc = vo.getHgmc();  // 使用 hgmc 字段存储申报单位名称
            if(StringUtils.isEmpty(sbdwmc)){
                continue;
            }
            sbdwmc = sbdwmc.trim();

            // 检查申报单位名称是否匹配风险报关行
            boolean isFxbgh = false;
            for(String fxbghName : fxbghSet){
                if(sbdwmc.contains(fxbghName) || fxbghName.contains(sbdwmc)){
                    isFxbgh = true;
                    break;
                }
            }

            if(isFxbgh){
                YjxxNewVo resultVo = new YjxxNewVo();
                resultVo.setDjxh(vo.getDjxh());
                resultVo.setLcslid(vo.getLcslid());
                resultVo.setYj_object(vo.getYj_object());
                resultVo.setYj_record(vo.getYj_record());
                resultVo.setYj_count(vo.getYj_count());
                resultVo.setYj_amt(vo.getYj_amt());
                resultVo.setYj_tax(vo.getYj_tax());
                resultList.add(resultVo);
            }
        }

        // 步骤4：插入预警数据
        if(!resultList.isEmpty()){
            super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z12201.getCode(), score);
            logger.info("预警指标：12201，触发预警 {} 条", resultList.size());
        }

        super.clearDBType();
    }

    @Override
    protected String genNewYjmsg(YjxxNewVo yjxxVo, TaskVo ysxx, String zbcode) {

        String yjMsg;

        if(YjzbCodeEnum.Z10101.getCode().equals(zbcode)){
            yjMsg = "新增出口商品（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getCmname()+"），本期出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10102.getCode().equals(zbcode)){
            yjMsg = "新增出口商品（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getCmname()+"），六个月内累计出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10104.getCode().equals(zbcode)){
            yjMsg = "新增出口商品（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getCmname()+"），本期退税额（"+yjxxVo.getYj_tax()+"）超一、二类限额（"+yjxxVo.getOffset()+"），应开展分析核查。";
        }else if(YjzbCodeEnum.Z10105.getCode().equals(zbcode)){
            yjMsg = "新增出口商品（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getCmname()+"），本期退税额（"+yjxxVo.getYj_tax()+"）超其他类限额（"+yjxxVo.getOffset()+"），应开展分析核查。";
        }else if(YjzbCodeEnum.Z10302.getCode().equals(zbcode)){
            yjMsg = "企业中断2年以上重新申报出口退（免）税，实地核查尚未结束！";
        }else if(YjzbCodeEnum.Z11601.getCode().equals(zbcode)){
            yjMsg = "该企业存在近期申报数据单证备案未完成，请关注！";
        }else if(YjzbCodeEnum.Z11801.getCode().equals(zbcode)){
            yjMsg = yjxxVo.getYjMsg();
        }else if(YjzbCodeEnum.Z16408.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_object()+"）存在（"+yjxxVo.getYj_record()+"）人工标记的关注事项，请加强审核！";
        }else if(YjzbCodeEnum.Z12201.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_object()+"），退免税额（"+yjxxVo.getYj_tax()+"），为总局下发疑点报关行报关数据，请加强审核！";
        }else if(StringUtils.isNotBlank(yjxxVo.getYjMsg())){
            return yjxxVo.getYjMsg();
        }else {
            String accMsg="";
            String qyfrMsg="";

            if(StringUtils.isNotBlank(yjxxVo.getYhzh())){
                accMsg="【退税账户】（"+yjxxVo.getYhzh()+"）";
            }
            if(StringUtils.isNotBlank(yjxxVo.getQyfr())){
                qyfrMsg="【法人】("+yjxxVo.getQyfr()+")";
            }
            yjMsg =  "征管系统"+accMsg+" "+qyfrMsg+",与审核系统不一致，请纳税人及时做备案变更调整，以免影响税款退库进度。";
        }
        return yjMsg;
    }

}
