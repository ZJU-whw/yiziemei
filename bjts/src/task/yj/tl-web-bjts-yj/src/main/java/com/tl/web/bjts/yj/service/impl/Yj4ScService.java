package com.tl.web.bjts.yj.service.impl;

import com.tl.web.bjts.yj.conf.MyAppConfig;
import com.tl.web.bjts.yj.dao.YjMapper;
import com.tl.web.bjts.yj.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.yj.model.TaskVo;
import com.tl.web.bjts.yj.model.YjPramDTO;
import com.tl.web.bjts.yj.model.YjzbCodeEnum;
import com.tl.web.bjts.yj.model.domain.DmGbcodeModel;
import com.tl.web.bjts.yj.model.domain.DmXzqhModel;
import com.tl.web.bjts.yj.model.domain.HgcodeXzqhModel;
import com.tl.web.bjts.yj.model.vo.*;
import com.tl.web.bjts.yj.service.IYjService;
import com.tl.web.bjts.yj.service.LocalCache;
import com.tl.web.bjts.yj.utils.Tools;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Stream;

/**
 * @Author：Mamf
 * @Date: 2017/12/29.
 * @Description:
 */
@Service
public class Yj4ScService extends IYjService{

    @Resource
    YjMapper yjMapper;
    @Resource
    Yj4TssbService yj4TssbService;
    @Resource
    LocalCache localCache;

    private Logger logger = LoggerFactory.getLogger(Yj4ScService.class);


    @Override
    protected void executeNewYjProcess(TaskVo ysxx,
                                       Map<String, String> swjgYjDicCodeMap,
                                       Map<String, YjzbItemVo> yjzbItemMap,
                                       Map yjBmdMap,
                                       Map<String,Long> tbpcMap) {

        boolean isClosedYjBreak = MyAppConfig.isClosedYjBreak;

        yj4TssbService.executeNewYjProcess(ysxx, swjgYjDicCodeMap, yjzbItemMap, yjBmdMap, tbpcMap);

        //首次出口
        if(isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeEnterprise))
                ||!isClosedYjBreak){

            ysxx.setYjType(IYjService.YjTypeEnterprise);//用于通过该大类预警代码获取适用企业、适用税务标志

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10301.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z10301.getCode(),YjzbCodeEnum.Z10301.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10301.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10301.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkFirstTsck10301(ysxx,tbpcMap,yjBmdMap,score);
            }
        }

        //已确认征/免税出口业务申报退税
        if(isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeCqwsb))
                ||!isClosedYjBreak){

            ysxx.setYjType(IYjService.YjTypeCqwsb);

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z11701.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z11701.getCode(),YjzbCodeEnum.Z11701.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z11701.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z11701.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkCqwsbQrStatus(ysxx,tbpcMap,yjBmdMap,score);
            }
        }

        //6,报关行分散
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeYwBgd)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeYwBgd);

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12001.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z12001.getCode(),YjzbCodeEnum.Z12001.getMsg());


                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12001.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z12001.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkYwBgh12001(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjzbItemVo.getP2val(),yjBmdMap,score);
            }

        }

        // 生产企业货源地预警（16002）、16003——生产企业出口口岸预警
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeYdBg)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeYdBg);

            logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16002.getCode(),YjzbCodeEnum.Z16002.getMsg());

            checkYdbg16002(ysxx,tbpcMap,yjBmdMap,yjzbItemMap);

        }

        //商品单价畸高指标
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeJgdj)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeJgdj);

            //16101: 单笔报关单明细对应商品单价大于等于10万元
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16101.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16101.getCode(),YjzbCodeEnum.Z16101.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16101.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16101.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkJgdj16101Sc(ysxx,tbpcMap,yjzbItemVo,yjBmdMap,score);
            }

            //16102: 单价>=100元且<10万，近12个月退税>=50万，退税额>=3万，偏差度>=3
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16102.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16102.getCode(),YjzbCodeEnum.Z16102.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16102.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16102.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkJgdj16102Sc(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjzbItemVo.getP2val(), yjzbItemVo.getP3val(),yjzbItemVo.getP4val(),yjBmdMap,score);
            }

            //16103: 单价<100元，近12个月退税>=50万，退税额>=3万，偏差度>=5
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16103.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16103.getCode(),YjzbCodeEnum.Z16103.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16103.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16103.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkJgdj16103Sc(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjzbItemVo.getP2val(),
                        yjzbItemVo.getP3val(),yjzbItemVo.getP4val(),yjBmdMap,score);
            }
        }

        //风险企业调查评估指标（生产和外贸通用）
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeFxqydcpg)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeFxqydcpg);

            //16401: 三三智检红码企业预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16401.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16401.getCode(),YjzbCodeEnum.Z16401.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16401.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16401.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkFxqydcpg16401(ysxx,tbpcMap,yjBmdMap,score);
            }

            //16402: 日常专项监管疑点企业预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16402.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16402.getCode(),YjzbCodeEnum.Z16402.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16402.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16402.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkFxqydcpg16402(ysxx,tbpcMap,yjBmdMap,score);
            }

            //16403: 建议调评数据未做调评处理预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16403.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16403.getCode(),YjzbCodeEnum.Z16403.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16403.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16403.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkFxqydcpg16403(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjBmdMap,score);
            }

            //16404: 三新预警单笔涉税金额超阈值预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16404.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16404.getCode(),YjzbCodeEnum.Z16404.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16404.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16404.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkFxqydcpg16404(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjBmdMap,score);
            }

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16406.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16406.getCode(),YjzbCodeEnum.Z16406.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16406.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16406.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkFxqydcpg16406(ysxx,tbpcMap,yjBmdMap,score);
            }
        }

        //长期未申报报关单指标（仅生产企业）
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeCqwbgd)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeCqwbgd);

            //16501: 长期未申报报关单预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16501.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16501.getCode(),YjzbCodeEnum.Z16501.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16501.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16501.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkCqwbgd16501(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjzbItemVo.getP2val(),yjBmdMap,score);
            }
        }

        //166、收汇比例偏低指标（生产和外贸通用）
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeShblpd)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeShblpd);

            //16601: 收汇比例偏低预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16601.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16601.getCode(),YjzbCodeEnum.Z16601.getMsg());


                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16601.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16601.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());
                checkShblpd16601(ysxx,tbpcMap,yjzbItemVo,yjBmdMap,score);
            }
        }

        //121、未申报物流信息指标（生产企业适用免抵退业务）
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeWsbWaxx)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeWsbWaxx);

            logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z12101.getCode(),YjzbCodeEnum.Z12102.getCode());

            checkWsbWaxx12101(ysxx,tbpcMap,yjBmdMap,yjzbItemMap);
        }
        //123、出口商品码多退税率核对预警（生产专用）
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeYjbmtdtshd)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeYjbmtdtshd);

            //12302: 生产企业退税率就低预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12302.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z12302.getCode(),YjzbCodeEnum.Z12302.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12302.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z12302.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkYjbmtdtshd12302(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjBmdMap,score);
            }
        }

        //124、生产企业视同自产货物预警
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeStzc)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeStzc);

            //12401: 生产企业视同自产货物指标
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12401.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z12401.getCode(),YjzbCodeEnum.Z12401.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12401.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z12401.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkStzc12401(ysxx,tbpcMap,yjzbItemVo,yjBmdMap,score);
            }

            //12402: 违规选择视同自产-1业务指标
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12402.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z12402.getCode(),YjzbCodeEnum.Z12402.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12402.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z12402.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkStzc12402(ysxx,tbpcMap,yjzbItemVo,yjBmdMap,score);
            }

            //12403: 存在36个月内出口骗税、虚开发票行为指标
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12403.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z12403.getCode(),YjzbCodeEnum.Z12403.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12403.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z12403.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkStzc12403(ysxx,tbpcMap,yjzbItemVo,yjBmdMap,score);
            }
        }

    }

    /**
     * “供货企业正在函调未回函预警”（16406）
     * @param ysxx
     * @param tbpcMap
     * @param yjBmdMap
     * @param score
     */
    private void checkFxqydcpg16406(TaskVo ysxx, Map<String, Long> tbpcMap,Map yjBmdMap, Integer score) {

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        // 查询供货企业正在函调未回函
        List<YjxxNewVo> list = yjMapper.selectGysHdWhh4Sc(ysxx.getCpcode());

        super.insertYjDataYjxx(list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16406.getCode(), score);
    }

    private void checkYdbg16002(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Map<String, YjzbItemVo> yjzbItemMap) {

        YjzbItemVo yjzb16002ItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16002.getCode());
        YjzbItemVo yjzb16003ItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16003.getCode());

        boolean isYjZb16002 = (isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16002.getCode())))||!MyAppConfig.isClosedYjBreak;
        boolean isYjZb16003 = (isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16003.getCode())))||!MyAppConfig.isClosedYjBreak;

        if(!isYjZb16002 && !isYjZb16003){
            super.clearDBType();
            return;
        }

        Map<String, String> hgcodeModelMap = localCache.getCodeNameMap(LocalCache.DM_HGCODE, HgcodeXzqhModel::getHgcode, HgcodeXzqhModel::getHgmc);

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        pramDTO.setPval1(yjzb16002ItemVo.getP1val());
        /*
         * 1)统计出口企业近12个月退税额，判断退税额合计是否大于等于P1VAL（参数阈值）
         */
        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        isYjZb16002 = isYjZb16002 && StringUtils.isNotBlank(yjzb16002ItemVo.getP1val());
        if(isYjZb16002){
            String needYjCon1 = yjMapper.selectCheckTsehj(ysxx.getCpcode(),new BigDecimal(pramDTO.getPval1()));
            if(StringUtils.isEmpty(needYjCon1)){
                isYjZb16002 = false;
            }
        }
        pramDTO.setLcslid(ysxx.getLcslid());
        pramDTO.setPval2(yjzb16003ItemVo.getP1val());
        isYjZb16003 = isYjZb16003 && StringUtils.isNotBlank(yjzb16003ItemVo.getP1val());
        if(isYjZb16003){
            String needYjCon2 = yjMapper.selectCheckTsehj(ysxx.getCpcode(),new BigDecimal(pramDTO.getPval1()));
            if(StringUtils.isEmpty(needYjCon2)){
                isYjZb16003 = false;
            }
        }

        List<YjxxNewVo> yjzb16002list=new ArrayList<>();
        List<YjxxNewVo> yjzb16003list=new ArrayList<>();
        if(isYjZb16002||isYjZb16003){
            List<YdbgHydCkkaScVo> list =yjMapper.selectHydCkkaYj4Sc(ysxx.getLcslid());
            for (YdbgHydCkkaScVo scVo : list) {
                isYjZb16002 = isYjZb16002 && StringUtils.isNotBlank(yjzb16002ItemVo.getP2val());
                if(isYjZb16002){
                    BigDecimal mylaj = scVo.getMylaj() == null ? BigDecimal.ZERO : scVo.getMylaj();
                    if(mylaj.compareTo(new BigDecimal(yjzb16002ItemVo.getP2val())) >=0){
                        boolean b1 = "N".equals(scVo.getStzc());
                        boolean b2 = !ysxx.getSwcode().substring(1,5).equals(scVo.getXzqhDm());
                        if(b1 && b2){
                            YjxxNewVo yjxxNewVo = new YjxxNewVo();
                            yjxxNewVo.setBgdno(scVo.getCkbgdh());
                            yjxxNewVo.setYj_amt(scVo.getMylaj().toString());
                            yjxxNewVo.setYj_tax(scVo.getMdtse().toString());
                            yjxxNewVo.setYj_object(scVo.getCkbgdh());
                            yjxxNewVo.setYj_record(scVo.getSbxh());
                            yjxxNewVo.setYjMsg(String.format("报关单（%s）货源地（%s）不在本地市，且未申报视同自产，请加强审核！", scVo.getCkbgdh(), scVo.getXzqhMc()));
                            yjzb16002list.add(yjxxNewVo);
                        }
                    }
                }

                isYjZb16003 = isYjZb16003 && StringUtils.isNotBlank(yjzb16003ItemVo.getP2val());
                if(isYjZb16003){
                    BigDecimal mylaj = scVo.getMylaj() == null ? BigDecimal.ZERO : scVo.getMylaj();
                    if(mylaj.compareTo(new BigDecimal(yjzb16003ItemVo.getP2val())) >=0){
                        String prefix = scVo.getHggqkaDm().substring(0, 2);
                        if (Stream.of("22", "29", "31").noneMatch(prefix::equals)) {
                            YjxxNewVo yjxxNewVo = new YjxxNewVo();
                            yjxxNewVo.setBgdno(scVo.getCkbgdh());
                            yjxxNewVo.setYj_amt(scVo.getMylaj().toString());
                            yjxxNewVo.setYj_tax(scVo.getMdtse().toString());
                            yjxxNewVo.setYj_object(scVo.getCkbgdh());
                            yjxxNewVo.setYj_record(scVo.getSbxh());
                            yjxxNewVo.setYjMsg(String.format("报关单（%s）出口口岸（%s）不在本地区常规范围，请加强审核！", scVo.getCkbgdh(), hgcodeModelMap.get(scVo.getHggqkaDm())));
                            yjzb16003list.add(yjxxNewVo);
                        }
                    }
                }
            }
        }

        if((!yjzb16002list.isEmpty() && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16002.getCode())))
                ||!MyAppConfig.isClosedYjBreak){
            ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16002.getCode())));
            Integer score=Integer.parseInt(yjzb16002ItemVo.getScore());
            super.insertYjDataYjxx(yjzb16002list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16002.getCode(), score);
        }
        if((!yjzb16003list.isEmpty() && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16003.getCode())))
                ||!MyAppConfig.isClosedYjBreak){
            ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16003.getCode())));
            Integer score=Integer.parseInt(yjzb16003ItemVo.getScore());
            super.insertYjDataYjxx(yjzb16003list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16003.getCode(), score);
        }

    }

    /**
     * 12302 生产企业退税率就低预警 - 实现框架：
     *
     * @param ysxx   任务信息
     * @param tbpcMap 同步批次MAP
     * @param p1val   退免税额阈值
     * @param yjBmdMap 预警白名单MAP
     * @param score   预警分值
     */
    private void checkYjbmtdtshd12302(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, Map yjBmdMap, Integer score) {
        if(StringUtils.isEmpty(p1val)){
            logger.warn("预警指标：12302，参数未设置完整，跳过处理");
            return;
        }
        // 1) 准备参数
        YjPramDTO pramDTO = new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        pramDTO.setPval1(p1val);

        // 2) 查询批次汇总（11位商品码+退税率维度）
        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        List<YjxxNewVo> batchList = yjMapper.selectYjbmtdtshd12302ByBatch(pramDTO);

        // 3) 按"企业+商品代码"判断预警信息数据表中是否已存在相同指标，避免重复预警输出
        super.changeDataSource(MultipleDataSourceHolder.TLADMIN);
        if(batchList != null && !batchList.isEmpty()){
            Iterator<YjxxNewVo> iterator = batchList.iterator();
            while (iterator.hasNext()) {
                YjxxNewVo yjxxVo = iterator.next();
                String nsrdzdah = ysxx.getNsrdzdah();
                String spdm = yjxxVo.getYj_object();
                Integer existFlag = yjMapper.checkExistYj12302(nsrdzdah, spdm, ysxx.getLcslid());
                if(existFlag != null){
                    logger.info("12302预警：企业({})商品代码({})已存在历史预警，跳过", nsrdzdah, spdm);
                    iterator.remove();
                }
            }
        }

        super.insertYjDataYjxx(batchList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z12302.getCode(), score);
    }

    private void checkCqwsbQrStatus(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        List<Map<String,String>>  retlist = yjMapper.selectMdtmxByLcslid(pramDTO);
        super.clearDBType();

        List<YjxxNewVo> list=new ArrayList<>();
        for (Map<String, String> map : retlist) {
            String djxh = map.get("DJXH");
            String ckbgdh = map.get("CKBGDH");

            int cnt = yjMapper.selectCqwsbConfirmData(djxh,ckbgdh);
            if(cnt>0){
                YjxxNewVo newVo = new YjxxNewVo();
                newVo.setYj_count("1");
                newVo.setYj_object(ckbgdh);
                Object mylajObj = map.get("MYLAJ");
                Object mdtseObj  = map.get("MDTSE");
                newVo.setYj_amt(mylajObj == null ? "0" : mylajObj.toString());
                newVo.setYj_tax(mdtseObj  == null ? "0" : mdtseObj.toString());
                newVo.setYj_record(map.get("SBXH"));
                list.add(newVo);
            }
        }
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11701.getCode(),score);
    }

    private void checkFirstTsck10301(TaskVo ysxx, Map<String, Long> tbpcMap,Map yjBmdMap, Integer score) {

        List<YjxxNewVo> list=new ArrayList<>();

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        int cnt =yjMapper.selectFirstTsck10301Sc(ysxx.getLcslid());
        super.clearDBType();

        if(cnt==1){
            list.add(new YjxxNewVo());
        }

        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10301.getCode(),score);
    }

    private void checkHegs20201(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setPval1(s);
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectHegs20201Sc(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z20201.getCode(),score);
    }

    private void checkBghfs11501(TaskVo ysxx, Map<String, Long> tbpcMap, String s, String s2,
                                                Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setPval1(s);
        pramDTO.setPval2(s2);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectBghfsSc11501(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11501.getCode(),score);
    }

    private void checkYwBgh12001(TaskVo ysxx, Map<String, Long> tbpcMap, String s, String s2,
                                 Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        pramDTO.setPval1(s);
        pramDTO.setPval2(s2);

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        String djxh = yjMapper.selectDjxhByNsrsbh(ysxx.getNsrdjno());
        pramDTO.setDjxh(new BigDecimal(djxh));
        List<YwbgCkeVo> datalist =yjMapper.selectYwBghSc12001(pramDTO);
        super.clearDBType();

        List<YjxxNewVo> list = new ArrayList<>();
        for (YwbgCkeVo ywbgCkeVo : datalist) {
            if(ywbgCkeVo.getLcMylaj().compareTo(BigDecimal.ZERO)>0){
                YjxxNewVo yjxxNewVo = new YjxxNewVo();
                yjxxNewVo.setYj_record(ywbgCkeVo.getLcSbxh());

                if(ywbgCkeVo.getMylaj3m().compareTo(new BigDecimal(pramDTO.getPval1()))>=0){
                    yjxxNewVo.setYj_amt(ywbgCkeVo.getMylaj3m().toString());
                    BigDecimal fmt = ywbgCkeVo.getMylaj3m().divide(new BigDecimal(10000L));
                    yjxxNewVo.setYjMsg("为义乌地区报关行报关出口的货物，近3个月内申报出口额"+fmt+"万美元，增长较快，请加强审核。");
                }else if(ywbgCkeVo.getMylajAll().compareTo(new BigDecimal(pramDTO.getPval2()))>=0){
                    yjxxNewVo.setYj_amt(ywbgCkeVo.getMylajAll().toString());
                    BigDecimal fmt = ywbgCkeVo.getMylajAll().divide(new BigDecimal(10000L));
                    yjxxNewVo.setYjMsg("为义乌地区报关行报关出口的货物，2026年4月1日以来累计申报出口额"+fmt+"万美元，请加强审核。");
                }else {
                    continue;
                }
//                else {
//                    yjxxNewVo.setYj_amt(ywbgCkeVo.getLcMylaj().toString());
//                    BigDecimal fmt = ywbgCkeVo.getMylajAll().divide(new BigDecimal(10000L));
//                    yjxxNewVo.setYjMsg("为义乌地区报关行报关出口的货物，2026年4月1日以来累计申报出口额"+fmt+"万美元。");
//                }

                list.add(yjxxNewVo);
            }
        }
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z12001.getCode(),score);
    }

    /**
     * 风险企业调查评估 - 16401三三智检红码企业预警
     */
    private void checkFxqydcpg16401(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Integer score) {

        String djxh = ysxx.getCpcode();

        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        super.changeDataSource(MultipleDataSourceHolder.TLTSSH);
        Integer jkmLevel = yjMapper.selectJkmLevel(djxh);
        super.clearDBType();

        List<YjxxNewVo> resultList = new ArrayList<>();
        if(jkmLevel != null && jkmLevel == 3){
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setYj_object(ysxx.getNsrdjno());
            resultList.add(yjxxVo);
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16401.getCode(), score);
    }

    /**
     * 风险企业调查评估 - 16402日常专项监管疑点企业预警
     */
    private void checkFxqydcpg16402(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Integer score) {

        String djxh = ysxx.getCpcode();

        super.changeDataSource(MultipleDataSourceHolder.TLTSSH);
        Integer whsydCount = yjMapper.selectZxzbWhsydCount(new BigDecimal(djxh));

        List<YjxxNewVo> resultList = new ArrayList<>();
        if(whsydCount != null && whsydCount > 0){
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setYj_count(String.valueOf(whsydCount));
            yjxxVo.setLcslid(ysxx.getLcslid());
            resultList.add(yjxxVo);
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16402.getCode(), score);
    }

    /**
     * 风险企业调查评估 - 16403建议调评数据未做调评处理预警
     */
    private void checkFxqydcpg16403(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, Map yjBmdMap, Integer score) {
        if(StringUtils.isEmpty(p1val)){
            logger.warn("预警指标：16403，参数未设置，跳过处理");
            return;
        }

        int months = Integer.parseInt(p1val);
        Integer notProcessedCount = yjMapper.select16404NotProcessedCount(ysxx.getCpcode(), months);

        List<YjxxNewVo> resultList = new ArrayList<>();
        if(notProcessedCount != null && notProcessedCount > 0){
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setYj_count(String.valueOf(notProcessedCount));
            resultList.add(yjxxVo);
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16403.getCode(), score);
    }

    /**
     * 风险企业调查评估 - 16404三新预警单笔涉税金额超阈值预警
     */
    private void checkFxqydcpg16404(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, Map yjBmdMap, Integer score) {
        if(StringUtils.isEmpty(p1val)){
            logger.warn("预警指标：16404，参数未设置，跳过处理");
            return;
        }

        BigDecimal threshold = new BigDecimal(p1val);
        List<YjxxNewVo> list = yjMapper.selectSanxinYjOverThreshold(ysxx.getLcslid(), threshold);

        super.insertYjDataYjxx(list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16404.getCode(), score);
    }

    /**
     * 长期未申报报关单 - 16501长期未申报报关单预警
     * @param ysxx 任务信息
     * @param tbpcMap 批次Map
     * @param p1val P1VAL参数（长期未申报报关单数量阈值）
     * @param p2val P2VAL参数（长期未申报报关单金额阈值）
     * @param yjBmdMap 预警白名单Map
     * @param score 风险分值
     */
    private void checkCqwbgd16501(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, String p2val,
                                  Map yjBmdMap, Integer score) {

        String djxh = ysxx.getCpcode();

        super.changeDataSource(MultipleDataSourceHolder.TLTSSH);
        // 查询长期未申报报关单份数和金额
        Map<String, Object> result = yjMapper.selectCqwbgdCountAndAmt(djxh);
        if(result == null){
            return;
        }

        BigDecimal wsbbgdNowNum = new BigDecimal(result.get("B_NUM") == null ? "0" : result.get("B_NUM").toString());
        BigDecimal wsbbgdBeforeNum = new BigDecimal(result.get("D_NUM") == null ? "0" : result.get("D_NUM").toString());

        BigDecimal wsbbgdNowJe = new BigDecimal(result.get("C_RMBLAJ") == null ? "0" : result.get("C_RMBLAJ").toString());
        BigDecimal wsbbgdBeforeJe = new BigDecimal(result.get("E_RMBLAJ") == null ? "0" : result.get("E_RMBLAJ").toString());

        String year = (String)result.get("A_YEAR");

        BigDecimal wsbbgdNum = wsbbgdNowNum.add(wsbbgdBeforeNum);
        BigDecimal wsbbgdRmbaj = wsbbgdNowJe.add(wsbbgdBeforeJe);
        // 判断份数>=P1VAL或金额>=P2VAL
        BigDecimal p1Val = new BigDecimal(StringUtils.isEmpty(p1val) ? "0" : p1val);
        BigDecimal p2Val = new BigDecimal(StringUtils.isEmpty(p2val) ? "0" : p2val);
        if(wsbbgdNum.compareTo(p1Val) > 0 || wsbbgdRmbaj.compareTo(p2Val) > 0){
            List<YjxxNewVo> resultList = new ArrayList<>();
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setYj_count(wsbbgdNum.toString());
            yjxxVo.setYj_amt(wsbbgdRmbaj.toString());
            yjxxVo.setYjMsg(String.format("该企业存在长期未申报报关单未处理及待申报，其中（%s）年度共（%s）份，出口销售额（%s）元，早于（%s）年度报关单共（%s）份，出口销售额（%s）元。", year, wsbbgdNowNum,wsbbgdNowJe,year,wsbbgdBeforeNum,wsbbgdBeforeJe));
            resultList.add(yjxxVo);
            super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16501.getCode(), score);
        }
    }

    /**
     * 收汇比例偏低预警 - 16601
     * @param ysxx
     * @param tbpcMap
     * @param yjzbItemVo 参数
     * @param yjBmdMap
     * @param score
     */
    private void checkShblpd16601(TaskVo ysxx, Map<String, Long> tbpcMap, YjzbItemVo yjzbItemVo, Map yjBmdMap, Integer score) {

        String djxh = ysxx.getCpcode();

        String p1val = yjzbItemVo.getP1val();
        String p2val = yjzbItemVo.getP2val();
        if(StringUtils.isEmpty(p1val) || StringUtils.isEmpty(p2val)){
            logger.warn("预警指标：16601，未设置预警参数值，跳过处理");
            return;
        }
        super.changeDataSource(MultipleDataSourceHolder.JSXT);


        // 查询上年度出口额和收汇额
        Map<String, Object> resultMap = yjMapper.selectShblpd166(djxh);
        super.clearDBType();
        if(resultMap == null){
            logger.warn("未查询到收汇数据：{}",ysxx.getNsrdjno());
            return;
        }

        // CK_MY: 上年度出口美元离岸价
        // SH_MY: 外管局+人民银行收汇美元
        BigDecimal ckMy = resultMap.get("CK_MY") != null ? new BigDecimal(resultMap.get("CK_MY").toString()) : BigDecimal.ZERO;
        BigDecimal shMy = resultMap.get("SH_MY") != null ? new BigDecimal(resultMap.get("SH_MY").toString()) : BigDecimal.ZERO;

        BigDecimal wgjSh = resultMap.get("WGJ_SH") != null ? new BigDecimal(resultMap.get("WGJ_SH").toString()) : BigDecimal.ZERO;
        BigDecimal rmbSh = resultMap.get("RMB_SH") != null ? new BigDecimal(resultMap.get("RMB_SH").toString()) : BigDecimal.ZERO;


        // 如果上年度出口额美元未满足条件
        if(ckMy.compareTo(new BigDecimal(p2val)) <0){
            return;
        }

        // 计算收汇比例 = 收汇额 / 出口额 * 100
        BigDecimal shbl = shMy.divide(ckMy, 4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(100));
        BigDecimal threshold = new BigDecimal(p1val);
        // 判断收汇比例是否低于阈值
        if(shbl.compareTo(threshold) < 0){
            List<YjxxNewVo> resultList = new ArrayList<>();
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setYj_amt(ckMy.toString()); // 上年度出口销售额（美元）
            yjxxVo.setYj_tax(shMy.toString());
            yjxxVo.setCmcode(wgjSh.toString());
            yjxxVo.setCmname(rmbSh.toString());
            yjxxVo.setOffset(shbl.setScale(2, BigDecimal.ROUND_HALF_UP).toString()); // 收汇比例（%）
            resultList.add(yjxxVo);

            super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16601.getCode(), score);
        }
    }

    /**
     * 未申报物流信息预警 - 12101
     * @param ysxx 任务信息
     * @param tbpcMap 同步批次MAP
     * @param yjBmdMap 预警名单MAP
     * @param yjzbItemMap 预警指标配置项
     */
    private void checkWsbWaxx12101(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Map<String, YjzbItemVo> yjzbItemMap) {

        // 1. 查询免抵退申报的报关单信息（SQL14）
        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        List<MdtBgxx121Vo> bgdList = yjMapper.selectMdtBgxx121(ysxx.getLcslid());

        if(bgdList == null || bgdList.isEmpty()){
            super.clearDBType();
            logger.info("预警指标：12101，未查询到免抵退报关单数据");
            return;
        }

        // 获取企业登记序号
        String djxh = ysxx.getCpcode();
        if(StringUtils.isEmpty(djxh)){
            super.clearDBType();
            logger.warn("预警指标：12101，未查询到登记序号：{}", ysxx.getNsrdjno());
            return;
        }

        super.changeDataSource(MultipleDataSourceHolder.TLTSSH);
        // 2. 批量预查询：报关单链路信息
        List<String> bgdhgbhList = bgdList.stream()
            .map(bgd -> bgd.getBgdhgbh())
            .filter(bgdh -> StringUtils.isNotEmpty(bgdh))
            .collect(java.util.stream.Collectors.toList());
        Map<String, Map<String, Object>> existBgdwlMap = new java.util.HashMap<>();
        if(!bgdhgbhList.isEmpty()){
            List<Map<String, Object>> existList = yjMapper.selectBgdwlListByBgdhList(djxh, bgdhgbhList);
            for (Map<String, Object> exist : existList) {
                String bgdh = (String) exist.get("BGDHGBH");
                if(StringUtils.isNotEmpty(bgdh)){
                    existBgdwlMap.put(bgdh, exist);
                }
            }
        }

        // 5. 批量预查询：所有集装箱信息
        Map<String, Map<String, Object>> jzxhMap = new java.util.HashMap<>();
        for (String bgdhgbh : bgdhgbhList) {
            Map<String, Object> jzxx = yjMapper.selectJzxh121(bgdhgbh);
            if(jzxx != null){
                jzxhMap.put(bgdhgbh, jzxx);
            }
        }

        // 6. 批量预查询：所有发货模式
        Map<String, Integer> fhmsMap = new java.util.HashMap<>();
        for (String bgdhgbh : bgdhgbhList) {
            int fhms = yjMapper.selectFhms121(bgdhgbh);
            fhmsMap.put(bgdhgbh, fhms);
        }


        // 4. 批量预查询：所有出口发票备注
        super.changeDataSource(MultipleDataSourceHolder.SZDP);
        Map<String, FpjcxxbBzVo> fpBzMap = new java.util.HashMap<>();
        for (MdtBgxx121Vo bgd : bgdList) {
            String fphm = bgd.getCkfph();
            if(StringUtils.isNotEmpty(fphm)){
                FpjcxxbBzVo fpjcxxbBzVo = new FpjcxxbBzVo();
                FphmBzVo bzVo = yjMapper.selectFpbzWlxx(fphm);
                String bz = bzVo==null?null:(bzVo.getBz()==null?"":bzVo.getBz());
                fpjcxxbBzVo.setBz(bz);
                fpBzMap.put(fphm, fpjcxxbBzVo);
            }
        }

        List<YjxxNewVo> yjResult12101List = new ArrayList<>();
        List<YjxxNewVo> yjResult12102List = new ArrayList<>();
        List<Map<String, Object>> insertList = new ArrayList<>();
        List<Map<String, Object>> updateList = new ArrayList<>();

        YjzbItemVo yjzb12101ItemVo = yjzbItemMap.get(YjzbCodeEnum.Z12101.getCode());
        YjzbItemVo yjzb12102ItemVo = yjzbItemMap.get(YjzbCodeEnum.Z12102.getCode());
        String p1val = yjzb12101ItemVo.getP1val();
        if(StringUtils.isEmpty(p1val)){
            logger.warn("预警指标：12101，未设置预警参数值，跳过处理");
            return;
        }
        BigDecimal threshold = new BigDecimal(p1val);

        super.changeDataSource(MultipleDataSourceHolder.TLTSSH);
        Map<String, String> xzqhModelMap = localCache.getCodeNameMap(LocalCache.DM_XZQH, DmXzqhModel::getDm, DmXzqhModel::getQycode);
        Map<String, String> hgcodeModelMap = localCache.getCodeNameMap(LocalCache.DM_HGCODE, HgcodeXzqhModel::getHgcode, HgcodeXzqhModel::getXzqhDm);
        Map<String, String> gbcodeModelMap = localCache.getCodeNameMap(LocalCache.DM_GBCODE, DmGbcodeModel::getGbCode, DmGbcodeModel::getQycode);
        // 7. 遍历报关单，处理物流信息和链路记录
        for (MdtBgxx121Vo bgd : bgdList) {
            String bgdhgbh = bgd.getBgdhgbh();
            if(StringUtils.isEmpty(bgdhgbh)){
                continue;
            }

            String ckfpbz = null;
            // 尝试从出口发票备注提取物流信息
            String fphm = bgd.getCkfph();
            if(StringUtils.isNotEmpty(fphm)){
                FpjcxxbBzVo fpjcxxbBzVo = fpBzMap.get(fphm);
                if(fpjcxxbBzVo.getBz()==null){
                    YjxxNewVo yjxxVo = new YjxxNewVo();
                    yjxxVo.setYj_record(fphm);
                    yjxxVo.setYj_object(bgdhgbh);
                    yjxxVo.setYj_amt(bgd.getMylaj()==null?"0":bgd.getMylaj().toString());
                    yjResult12102List.add(yjxxVo);
                }else {
                    ckfpbz = fpjcxxbBzVo.getBz();
                }
            }

            //出口明细备注
            String ckmxbz = bgd.getBz();
            //申报数据物流信息来源
            String cph = null;
            String yqrq = null;
            String qyd = null;
            String wlxxlyDm = null;
            if (ckfpbz!=null &&
                    (ckfpbz.contains("车牌号") || ckfpbz.contains("起运日") || ckfpbz.contains("起运地") || ckfpbz.contains("快递单号"))) {
                wlxxlyDm = "1"; // 来源：出口发票
            } else if (ckmxbz!=null &&
                    (ckmxbz.contains("车牌号") || ckmxbz.contains("起运日") || ckmxbz.contains("起运地") || ckmxbz.contains("快递单号"))) {
                wlxxlyDm = "2"; // 来源：申报表
            }

            // 根据是否存在记录决定新增还是更新
            String existWlxxly = null;
            Map<String, Object> params=null;
            Map<String, Object> existBgdwl = existBgdwlMap.get(bgdhgbh);
            if(existBgdwl == null){
                // 不存在记录，收集参数待批量插入
                params = buildBgdwlParamsSc(bgd, djxh, cph, yqrq, qyd, wlxxlyDm,
                    ysxx.getSwcode(), jzxhMap.get(bgdhgbh), fhmsMap.get(bgdhgbh), xzqhModelMap, hgcodeModelMap, gbcodeModelMap);
                params.put("ckfpbz", ckfpbz);
                params.put("ckmxbz", ckmxbz);
                insertList.add(params);
                logger.info("预警指标：12101，收集新增报关单链路信息：BGDHGBH={}", bgdhgbh);
            }else{
                // 存在记录但物流信息为空，且本次有物流信息，则更新
                existWlxxly = (String) existBgdwl.get("WLXXLY_DM");

                if(StringUtils.isEmpty(existWlxxly)){
                    params = new java.util.HashMap<>();
                    params.put("djxh", djxh);
                    params.put("bgdhgbh", bgdhgbh);
                    params.put("wlxxlyDm", wlxxlyDm);
                    params.put("cph", cph);
                    params.put("qyrq", yqrq);
                    params.put("qyd", qyd);
                    params.put("ckfph", fphm);
                    //预警提取数据时保存对应数据来源的完整备注信息
                    params.put("ckfpbz", ckfpbz);
                    params.put("ckmxbz", ckmxbz);
                    params.put("ckrq", Tools.parseString2Date(bgd.getCkrq1(), "yyyy-MM-dd"));
                    params.put("mylaj", bgd.getMylaj());
                    updateList.add(params);
                    logger.info("预警指标：12101，收集更新报关单物流信息：BGDHGBH={}", bgdhgbh);
                }
            }

            // 7.5 决定是否生成预警信息
            if ( StringUtils.isEmpty(existWlxxly) && wlxxlyDm == null && params!=null) {
                processWsbWlxxBgdh(params, yjResult12101List, threshold);
            }
        }

        // 8. 批量执行插入
        if(!insertList.isEmpty()){
            for (Map<String, Object> params : insertList) {
                yjMapper.insertBgdwl(params);
            }
            logger.info("预警指标：12101，批量新增报关单链路信息：{}条", insertList.size());
        }

        // 9. 批量执行更新
        if(!updateList.isEmpty()){
            for (Map<String, Object> params : updateList) {
                yjMapper.updateBgdwlWlxx(params);
            }
            logger.info("预警指标：12101，批量更新报关单物流信息：{}条", updateList.size());
        }


        if((!yjResult12101List.isEmpty() && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12101.getCode())))
                ||!MyAppConfig.isClosedYjBreak){
            ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12101.getCode())));
            Integer score=Integer.parseInt(yjzb12101ItemVo.getScore());
            super.insertYjDataYjxx(yjResult12101List, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z12101.getCode(), score);
        }
        if((!yjResult12102List.isEmpty() && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12102.getCode())))
                ||!MyAppConfig.isClosedYjBreak){
            ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12101.getCode())));
            Integer score=Integer.parseInt(yjzb12102ItemVo.getScore());
            super.insertYjDataYjxx(yjResult12102List, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z12102.getCode(), score);
        }
    }

    /**
     * 查询未申报物流信息的报关单，触发预警
     * @param yjObject
     * @param yjResultList
     * @param threshold
     */
    private void processWsbWlxxBgdh(Map<String, Object> yjObject,List<YjxxNewVo> yjResultList, BigDecimal threshold) {
        String wlxxlyDm = (String)yjObject.get("wlxxlyDm");
        BigDecimal mylaj = (BigDecimal)yjObject.get("mylaj");
        Date ckrq = (Date)yjObject.get("ckrq");

        boolean a1 = StringUtils.isBlank(wlxxlyDm);
        boolean a2 = mylaj != null && mylaj.compareTo(threshold) > 0;

        String formatCkrq = Tools.format(ckrq, "yyyy-MM-dd");
        boolean a3 = formatCkrq.compareTo("2026-05-01")>=0;
        if(a1 && a2 && a3){
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setKprq(formatCkrq);
            yjxxVo.setYj_object((String) yjObject.get("bgdhgbh"));
            yjxxVo.setYj_amt(mylaj.toString());
            yjResultList.add(yjxxVo);
        }
    }

    /**
     * 构建报关单链路信息参数（生产企业）
     */
    private Map<String, Object> buildBgdwlParamsSc(MdtBgxx121Vo bgd, String djxh,
                                                   String cph, String yqrq, String qyd,
                                                   String wlxxlyDm, String swjgdm,
                                                   Map<String, Object> jzxhMap, Integer fhms, Map<String, String> xzqhModelMap, Map<String, String> hgcodeModelMap, Map<String, String> gbcodeModelMap) {
        Map<String, Object> params = new java.util.HashMap<>();
        params.put("djxh", djxh);
        params.put("bgdhgbh", bgd.getBgdhgbh());
        params.put("dlzmh", bgd.getDlckhwzmhm());
        params.put("tmsjsffDm", bgd.getTmsjsffDm());
        params.put("mylaj", bgd.getMylaj());
        params.put("spdlDm", bgd.getSpdlDm());
        params.put("ckrq", Tools.parseString2Date(bgd.getCkrq1(), "yyyy-MM-dd"));
        params.put("ysfsDm", bgd.getYsfsDm());
        params.put("hzdwdqDm", bgd.getHzdwdqDm());
        params.put("hggqkaDm", bgd.getHggqkaDm());
        params.put("zzmdgdqszDm", bgd.getZzmdgdqszDm());
        params.put("ckfph", bgd.getCkfph());
        params.put("tydh", bgd.getTydh());
        params.put("wlxxlyDm", wlxxlyDm);
        params.put("cph", cph);
        params.put("yqrq", Tools.parseString2Date(yqrq, "yyyy-MM-dd"));
        params.put("qyd", qyd);

        params.put("jhpzh", null);
        params.put("ghfnsrsbh", null);
        params.put("ghfnsrmc",null);
        params.put("ghfnsrswjg", null);

        // 使用预查询的集装箱信息
        if(jzxhMap != null){
            params.put("jzxh", jzxhMap.get("JZXH"));
            params.put("jzxsl", jzxhMap.get("JZXSL"));
        }

        // 使用预查询的发货模式
        if(fhms != null){
            if(fhms == 0){
                params.put("fhmsDm", "0");
            }else if(fhms == 1){
                params.put("fhmsDm", "1");
            }else{
                params.put("fhmsDm", "2");
            }
        }

        // 查询风险等级（使用历史出口链路分析模型）
        String ysfsDm = bgd.getYsfsDm();
        String spdlDm = bgd.getSpdlDm();

        String xzqhHyd = yjMapper.selectXzqhHydDm(bgd.getHzdwdqDm());

        String qycodeHyd = xzqhModelMap.get(xzqhHyd);
        params.put("qycodeHyd", qycodeHyd);

        String qycodeHg = xzqhModelMap.get(hgcodeModelMap.get(bgd.getHggqkaDm()));
        params.put("qycodeHg", qycodeHg);

        String qycodeMdg = gbcodeModelMap.get(bgd.getZzmdgdqszDm());
        params.put("qycodeMdg", qycodeMdg);

        Map<String,String> fxdjMap = yjMapper.getRiskInfo(swjgdm, ysfsDm, spdlDm, qycodeHyd, qycodeHg, qycodeMdg);

        params.put("fxdjgxrq", new Date());
        if(fxdjMap != null){
            params.put("fxdjDm", fxdjMap.get("FXDJ"));
            params.put("zhfxzs", fxdjMap.get("ZHFXZS"));
        }else {
            //1	常规  2	低风险 3	中风险 4	中高风险 5高风险
            params.put("fxdjDm","5");
            params.put("zhfxzs", null);
        }


        return params;
    }

    /**
     * 商品单价畸高预警 - 生产企业16101（单笔>=10万元）
     * @param ysxx
     * @param tbpcMap
     * @param yjzbItemVo 参数
     * @param yjBmdMap
     * @param score
     */
    private void checkJgdj16101Sc(TaskVo ysxx, Map<String, Long> tbpcMap, YjzbItemVo yjzbItemVo, Map yjBmdMap, Integer score) {
        String p1val = yjzbItemVo.getP1val();
        String p2val = yjzbItemVo.getP2val();
        String p3val = yjzbItemVo.getP3val();
        if(StringUtils.isEmpty(p1val) || StringUtils.isEmpty(p2val) || StringUtils.isEmpty(p3val)){
            logger.warn("预警指标：16101，参数未设置完整，跳过处理");
            return;
        }

        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        // 统计企业近12个月退税额
        String needYjCon = yjMapper.selectCheckTsehj(ysxx.getCpcode(), new BigDecimal(p2val));
        // 判断是否满足退税额阈值
        if(StringUtils.isEmpty(needYjCon)){
            super.clearDBType();
            return;
        }

        List<YjxxNewVo> list = yjMapper.selectScSpdj161(ysxx.getLcslid());
        super.clearDBType();

        List<YjxxNewVo> resultList = new ArrayList<>();

        for (YjxxNewVo vo : list) {

            // 判断单笔免抵退税额是否>=3万
            BigDecimal tmse = new BigDecimal(vo.getYj_tax() == null ? "0" : vo.getYj_tax());
            if(tmse.compareTo(new BigDecimal(p3val)) < 0){
                continue;
            }

            BigDecimal spdj = new BigDecimal(vo.getSpdj() == null ? "0" : vo.getSpdj());
            // 判断单价是否>=P1VAL(10万)
            if(spdj.compareTo(new BigDecimal(p1val)) >= 0){
                YjxxNewVo yjxxVo = new YjxxNewVo();
                yjxxVo.setYj_record(vo.getYj_record()); //商品代码
                yjxxVo.setYj_object(vo.getBgdno()); // 报关单号
                yjxxVo.setYj_amt(vo.getYj_amt()); // 美元离岸价
                yjxxVo.setYj_tax(vo.getYj_tax()); // 免抵退税额
                yjxxVo.setCmname(vo.getCmname());
                yjxxVo.setPjdj(p1val);
                yjxxVo.setSpdj(spdj.toString());
                yjxxVo.setBgdno(vo.getBgdno());
                resultList.add(yjxxVo);
            }
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16101.getCode(), score);
    }

    /**
     * 商品单价畸高预警 - 生产企业16102（单价>=100元，偏差度>=3）
     * @param ysxx
     * @param tbpcMap
     * @param p1val 单价阈值（100元）
     * @param p2val 企业近12个月退税额阈值（50万）
     * @param p3val 单笔退免税额阈值（3万）
     * @param p4val 偏差度阈值（3）
     * @param yjBmdMap
     * @param score
     */
    private void checkJgdj16102Sc(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, String p2val,
                                  String p3val, String p4val, Map yjBmdMap, Integer score) {
        if(StringUtils.isEmpty(p1val) || StringUtils.isEmpty(p2val) || StringUtils.isEmpty(p3val) || StringUtils.isEmpty(p4val)){
            logger.warn("预警指标：16102，参数未设置完整，跳过处理");
            return;
        }

        String djxh = ysxx.getCpcode();

        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        // 统计企业近12个月退税额
        String needYjCon = yjMapper.selectCheckTsehj(djxh, new BigDecimal(p2val));
        // 判断是否满足退税额阈值
        if(StringUtils.isEmpty(needYjCon)){
            super.clearDBType();
            return;
        }

        //查询生产企业出口商品单价信息（使用人民币单价）
        List<YjxxNewVo> list = yjMapper.selectScSpdj161(ysxx.getLcslid());

        List<YjxxNewVo> resultList = new ArrayList<>();
        BigDecimal thresholdP1 = new BigDecimal(p1val);
        BigDecimal thresholdP3 = new BigDecimal(p3val);
        BigDecimal thresholdP4 = new BigDecimal(p4val);

        for (YjxxNewVo vo : list) {
            // 判断人民币单价是否>=100元
            BigDecimal rmbdj = new BigDecimal(vo.getSpdj() == null ? "0" : vo.getSpdj()); // 人民币单价
            if(rmbdj.compareTo(thresholdP1) < 0){
                continue;
            }
            // 判断单笔免抵退税额是否>=3万
            BigDecimal tmse = new BigDecimal(vo.getYj_tax() == null ? "0" : vo.getYj_tax());
            if(tmse.compareTo(thresholdP3) < 0){
                continue;
            }

            // 计算偏差度：生产企业用出口人民币单价与全省生产企业平均单价比较
            BigDecimal qspjDj = calculateQspjDjSc(vo.getYj_object());
            if(qspjDj.compareTo(BigDecimal.ZERO) <= 0){
                continue;
            }
            BigDecimal pd = new BigDecimal(vo.getMyspdj() == null ? "0" : vo.getMyspdj()).divide(qspjDj, 2, BigDecimal.ROUND_HALF_UP);
            // 判断偏差度是否>=3
            if(pd.compareTo(thresholdP4) >= 0){
                YjxxNewVo yjxxVo = new YjxxNewVo();
                yjxxVo.setYj_record(vo.getYj_record());
                yjxxVo.setYj_object(vo.getBgdno()); // 报关单号
                yjxxVo.setYj_amt(vo.getYj_amt());
                yjxxVo.setYj_tax(vo.getYj_tax());
                yjxxVo.setCmname(vo.getCmname());
                yjxxVo.setSpdj(rmbdj.toString());
                yjxxVo.setPjdj(qspjDj.toString());
                yjxxVo.setOffset(pd.toString());
                yjxxVo.setBgdno(vo.getBgdno());
                resultList.add(yjxxVo);
            }
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16102.getCode(), score);
    }

    /**
     * 商品单价畸高预警 - 生产企业16103（单价<100元，偏差度>=5）
     * @param ysxx
     * @param tbpcMap
     * @param p1val 单价阈值（100元，条件是<100）
     * @param p2val 企业近12个月退税额阈值（50万）
     * @param p3val 单笔退免税额阈值（3万）
     * @param p4val 偏差度阈值（5）
     * @param yjBmdMap
     * @param score
     */
    private void checkJgdj16103Sc(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, String p2val,
                                  String p3val, String p4val, Map yjBmdMap, Integer score) {
        if(StringUtils.isEmpty(p1val) || StringUtils.isEmpty(p2val) || StringUtils.isEmpty(p3val) || StringUtils.isEmpty(p4val)){
            logger.warn("预警指标：16103，参数未设置完整，跳过处理");
            return;
        }

        String djxh = ysxx.getCpcode();

        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        // 统计企业近12个月退税额
        String needYjCon = yjMapper.selectCheckTsehj(djxh, new BigDecimal(p2val));
        // 判断是否满足退税额阈值
        if(StringUtils.isEmpty(needYjCon)){
            super.clearDBType();
            return;
        }

        // 查询生产企业出口商品单价信息
        List<YjxxNewVo> list = yjMapper.selectScSpdj161(ysxx.getLcslid());

        List<YjxxNewVo> resultList = new ArrayList<>();
        BigDecimal thresholdP1 = new BigDecimal(p1val);
        BigDecimal thresholdP3 = new BigDecimal(p3val);
        BigDecimal thresholdP4 = new BigDecimal(p4val);

        super.clearDBType();
        for (YjxxNewVo vo : list) {
            // 判断人民币单价是否<100元（注意：条件是小于P1VAL）
            BigDecimal rmbdj = new BigDecimal(vo.getSpdj() == null ? "0" : vo.getSpdj()); // 人民币单价
            if(rmbdj.compareTo(thresholdP1) >= 0){
                continue;
            }
            // 判断单笔免抵退税额是否>=3万
            BigDecimal tmse = new BigDecimal(vo.getYj_tax() == null ? "0" : vo.getYj_tax());
            if(tmse.compareTo(thresholdP3) < 0){
                continue;
            }

            // 计算偏差度
            BigDecimal qspjDj = calculateQspjDjSc(vo.getYj_object());
            if(qspjDj.compareTo(BigDecimal.ZERO) <= 0){
                continue;
            }
            BigDecimal pd = new BigDecimal(vo.getMyspdj() == null ? "0" : vo.getMyspdj()).divide(qspjDj, 2, BigDecimal.ROUND_HALF_UP);
            // 判断偏差度是否>=5
            if(pd.compareTo(thresholdP4) >= 0){
                YjxxNewVo yjxxVo = new YjxxNewVo();
                yjxxVo.setYj_record(vo.getYj_record());
                yjxxVo.setYj_object(vo.getBgdno()); // 报关单号
                yjxxVo.setYj_amt(vo.getYj_amt());
                yjxxVo.setYj_tax(vo.getYj_tax());
                yjxxVo.setCmname(vo.getCmname());
                yjxxVo.setSpdj(rmbdj.toString());
                yjxxVo.setPjdj(qspjDj.toString());
                yjxxVo.setOffset(pd.toString());
                yjxxVo.setBgdno(vo.getBgdno());
                resultList.add(yjxxVo);
            }
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16103.getCode(), score);
    }

    /**
     * 计算生产企业偏差度 - 查询全省生产企业平均单价
     * @param spdm 商品代码
     * @return 全省平均单价
     */
    private BigDecimal calculateQspjDjSc(String spdm) {
        super.changeDataSource(MultipleDataSourceHolder.TLADMIN);
        // 取商品代码前8位进行匹配
        String spdmPrefix = spdm.length() >= 8 ? spdm.substring(0, 8) : spdm;
        BigDecimal qspjDj = yjMapper.selectQspjDjSc(spdmPrefix);
        return qspjDj != null ? qspjDj : BigDecimal.ZERO;
    }

    private void checkYcdj11301(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setPval1(s);
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectYcdj11301Sc(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11301.getCode(),score);
    }

    private void checkSbckka11201(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setPval1(s);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectSbckka11201Sc(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11201.getCode(),score);
    }

    private void checkMgckkaSc11002(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setPval1(s);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectMgCkka11002Sc(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11002.getCode(),score);

    }

    private void checkMgckkaSc11001(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setSbympc(ysxx.getYjsbympc());
        pramDTO.setPval1(s);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectMgCkka11001Sc(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11001.getCode(),score);

    }


    private void checkGfxsp10801(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setSwjgdm(ysxx.getSwcode());
        pramDTO.setSbympc(ysxx.getYjsbympc());
        pramDTO.setPval1(s);
        pramDTO.setSbid(ysxx.getId());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectGfxspSc10801(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10801.getCode(),score);
    }

    private void checkGfxsp10802(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setSwjgdm(ysxx.getSwcode());
        pramDTO.setPval1(s);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectGfxspSc10802(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10802.getCode(),score);
    }

    /**
     * 12401 - 生产企业视同自产货物指标
     * 
     * 实现逻辑：
     * 1. 按批次统计免抵退出口明细申报表中的业务类型为STZC-*对应申报序号数量、免抵退税额合计
     * 2. 如果每一项STZC-*业务类型对应的免抵退税额合计 >= 阈值A，生成待预警清单
     * 3. 防重复：按"企业+STZC-*"判断是否已存在预警信息
     * 
     * @param ysxx 任务信息
     * @param tbpcMap 同步批次MAP
     * @param yjzbItemVo 预警指标配置(P1val=退免税额阈值A)
     * @param yjBmdMap 预警名单MAP
     * @param score 预警分值
     */
    private void checkStzc12401(TaskVo ysxx, Map<String, Long> tbpcMap, YjzbItemVo yjzbItemVo, Map yjBmdMap, Integer score){
        if(StringUtils.isEmpty(yjzbItemVo.getP1val())){
            logger.warn("预警指标：12401，退免税额阈值未设置，跳过处理");
            return;
        }

        YjPramDTO pramDTO = new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        pramDTO.setPval1(yjzbItemVo.getP1val());

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        
        // 查询视同自产货物数据
        List<YjxxNewVo> batchList = yjMapper.selectStzc12401(pramDTO);

        if(CollectionUtils.isEmpty(batchList)){
            logger.info("预警指标：12401，未查询到视同自产货物数据");
            super.clearDBType();
            return;
        }

        // 防重复：查询企业已存在的预警
        List<String> existedList;
        try {
            super.changeDataSource(MultipleDataSourceHolder.TLADMIN);
            existedList = yjMapper.selectStzc124Existed(ysxx.getNsrdzdah());
        } catch (Exception e) {
            logger.warn("查询已存在预警异常，使用空集合继续：", e);
            existedList = new ArrayList<>();
        }
        Set<String> existedSet = existedList == null ? new HashSet<>() : new HashSet<>(existedList);


        // 过滤：退免税额 >= 阈值 且 不在已存在预警中
        List<YjxxNewVo> resultList = new ArrayList<>();
        for (YjxxNewVo vo : batchList) {
            String nsrdzdah = ysxx.getNsrdzdah();
            String yjObject = vo.getYj_object();  // 业务类型（商品代码+业务类型）
            if(StringUtils.isEmpty(yjObject)) continue;

            // 检查是否已存在预警
            if(existedSet.contains(nsrdzdah + yjObject)) continue;

            resultList.add(vo);
        }

        if(!resultList.isEmpty()){
            super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z12401.getCode(), score);
        }

        super.clearDBType();
    }

    /**
     * 12402 - 违规选择视同自产-1业务指标
     * 
     * 实现逻辑：
     * 1. 在12401查询结果中，判断是否有包含STZC-01的业务类型
     * 2. 如果有STZC-01，则检查以下条件：
     *    a) 增值税一般纳税人资格：免抵退申报企业必为一般纳税人，此项不判断
     *    b) 持续经营2年及以上
     *    c) 纳税信用等级A级
     *    d) 上一年度增值税申报全部销售额合计达到5亿元
     * 3. 任一条件不满足则触发预警
     * 
     * @param ysxx 任务信息
     * @param tbpcMap 同步批次MAP
     * @param yjzbItemVo 预警指标配置(P1val=退免税额阈值B)
     * @param yjBmdMap 预警名单MAP
     * @param score 预警分值
     */
    private void checkStzc12402(TaskVo ysxx, Map<String, Long> tbpcMap, YjzbItemVo yjzbItemVo, Map yjBmdMap, Integer score){
        String djxh = ysxx.getCpcode();
        if(StringUtils.isEmpty(djxh)){
            logger.warn("预警指标：12402，未获取到登记序号");
            return;
        }

        // 先查询12401的数据，判断是否有STZC-01
        YjPramDTO pramDTO = new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());

        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        YjxxNewVo yjxxNewVo = yjMapper.selectStzc12402(pramDTO);
        if(yjxxNewVo == null){
            super.clearDBType();
            return;
        }

        // 有STZC-01业务，检查企业资质
        // 2) 检查持续经营2年及以上
        String kydjDateStr = yjMapper.selectKydjDate(djxh);
        boolean passKysj = true;
        if(StringUtils.isNotEmpty(kydjDateStr)){
            try {
                Date kydjDate = Tools.parseString2Date(kydjDateStr, "yyyyMMdd");
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.add(java.util.Calendar.YEAR, -2);
                java.util.Date twoYearsAgo = cal.getTime();
                if(kydjDate.after(twoYearsAgo)){
                    passKysj = false;
                }
            } catch (Exception e) {
                logger.warn("解析开业日期异常：{}", kydjDateStr, e);
                passKysj = false;
            }
        }

        // 3) 检查纳税信用等级A级
        String nsxydj = yjMapper.selectNsxydj(djxh);
        boolean passNsxy = StringUtils.isNotEmpty(nsxydj) && "A".equals(nsxydj.trim());

        // 4) 检查上一年度销售额5亿元
        BigDecimal lastYearSales = yjMapper.selectLastYearSales(djxh);
        BigDecimal threshold5e = new BigDecimal("500000000");  // 5亿
        boolean passSales = lastYearSales != null && lastYearSales.compareTo(threshold5e) >= 0;

        // 判断违规项（按顺序收集所有不符合项）
        StringBuilder bfhxBuilder = new StringBuilder();
        if(!passKysj){
            if(bfhxBuilder.length() > 0) bfhxBuilder.append("；");
            bfhxBuilder.append("2）持续经营2年及以上");
        }
        if(!passNsxy){
            if(bfhxBuilder.length() > 0) bfhxBuilder.append("；");
            bfhxBuilder.append("3）纳税信用级别A级");
        }
        if(!passSales){
            if(bfhxBuilder.length() > 0) bfhxBuilder.append("；");
            bfhxBuilder.append("4）上一年度销售额5亿元以上");
        }

        String bfhx = bfhxBuilder.toString();
        // 如果有不符合项，触发预警
        if(StringUtils.isNotEmpty(bfhx)){
            List<YjxxNewVo> resultList = new ArrayList<>();
            yjxxNewVo.setYjMsg("生产企业申报违规选择【视同自产-1】，不符合【" + bfhx + "】政策规定，明细笔数：" + yjxxNewVo.getYj_count() + "，退免税额：" + yjxxNewVo.getYj_tax() + "，请加强审核！");
            resultList.add(yjxxNewVo);
            super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z12402.getCode(), score);
        }

        super.clearDBType();
    }

    /**
     * 12403 - 存在36个月内出口骗税、虚开发票行为指标
     * 
     * 实现逻辑：
     * 1. 按批次检查免抵退出口明细申报表中是否存在业务类型包含"STZC"的记录，如果不存在则返回
     * 2. 如果存在"STZC"的申报明细，继续检查出口企业是否存在36个月内因出口骗税、虚开发票等行为被税局处罚的决定书
     * 3. 如果存在处罚记录则触发预警
     * 
     * @param ysxx 任务信息
     * @param tbpcMap 同步批次MAP
     * @param yjzbItemVo 预警指标配置
     * @param yjBmdMap 预警名单MAP
     * @param score 预警分值
     */
    private void checkStzc12403(TaskVo ysxx, Map<String, Long> tbpcMap, YjzbItemVo yjzbItemVo, Map yjBmdMap, Integer score){
        String lcslid = ysxx.getLcslid();
        String djxh = ysxx.getCpcode();
        if(StringUtils.isEmpty(lcslid) || StringUtils.isEmpty(djxh)){
            logger.warn("预警指标：12403，未获取到流程受理ID或登记序号");
            return;
        }

        // 1) 按批次检查免抵退出口明细申报表中是否存在业务类型包含"STZC"的记录
        YjPramDTO pramDTO = new YjPramDTO();
        pramDTO.setLcslid(lcslid);
        
        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        Integer stzcCount = yjMapper.countStzc12403(pramDTO);
        if(stzcCount!=null && stzcCount!=1){
            logger.info("预警指标：12403，未查询到视同自产货物申报数据");
            super.clearDBType();
            return;
        }
        
        // 2) 检查企业是否存在36个月内的出口骗税、虚开发票处罚记录
        Integer pfcfsCount = yjMapper.selectPcfcfsCountForStzc12403(djxh);
        
        if(pfcfsCount != null && pfcfsCount > 0){
            // 存在处罚记录，触发预警
            List<YjxxNewVo> resultList = new ArrayList<>();
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setYj_count(String.valueOf(pfcfsCount));
            yjxxVo.setYjMsg("生产企业申报视同自产，企业存在36个月内被认定出口骗税、虚开发票行为的处罚决定，请加强审核。");
            resultList.add(yjxxVo);
            
            super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z12403.getCode(), score);
        }
        
        super.clearDBType();
    }

    @Override
    protected String genNewYjmsg(YjxxNewVo yjxxVo, TaskVo ysxx,String zbcode) {
        String yjMsg = "";
        if(YjzbCodeEnum.Z10801.getCode().equals(zbcode)){
            yjMsg = "敏感出口商品（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getCmname()+"），本期出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10802.getCode().equals(zbcode)){
            yjMsg = "敏感出口商品（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getCmname()+"），六个月内累计出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z11001.getCode().equals(zbcode)){
            yjMsg = "生产企业不合理出口口岸（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getHgmc()+"），本期出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z11002.getCode().equals(zbcode)){
            yjMsg = "生产企业不合理出口口岸（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getHgmc()+"），六个月内累计出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z11201.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_record()+"），申报口岸（"+yjxxVo.getSbka()+"名称"+yjxxVo.getSbkamc()+"）与出口口岸（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getCkkamc()+"）不一致，出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z11301.getCode().equals(zbcode)){
            yjMsg = "商品代码（"+yjxxVo.getYj_object()+"）单价（"+yjxxVo.getSpdj()+"）超过全省平均100%以上，出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z11501.getCode().equals(zbcode)){
            yjMsg = "报关行分散预警，六个月内报关行个数（"+yjxxVo.getBghsl()+"），而报关单明细笔数（"+yjxxVo.getBgdsl()+"）";
        }else if(YjzbCodeEnum.Z20201.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_object()+"），霍尔果斯口岸出口的皮毛类商品（"+yjxxVo.getCmcode()+"），请加强审核！";
        }else if(YjzbCodeEnum.Z10301.getCode().equals(zbcode)){
            yjMsg = "出口企业首次申报出口退（免）税，实地核查尚未结束。";
        }else if(YjzbCodeEnum.Z11701.getCode().equals(zbcode)){
            yjMsg = "该报关单（"+yjxxVo.getYj_object()+"）已申报征税或免税，请核实是否给予退税";
        }else if(YjzbCodeEnum.Z16101.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getBgdno()+"）申报商品（"+yjxxVo.getCmname()+"）对应计税依据单价（"+yjxxVo.getSpdj()+"元）大于等于"+yjxxVo.getPjdj()+"，请加强审核！";
        }else if(YjzbCodeEnum.Z16102.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getBgdno()+"）申报商品（"+yjxxVo.getCmname()+"）对应计税依据单价（"+yjxxVo.getSpdj()+"元）高于全省平均单价（"+yjxxVo.getPjdj()+"），偏差度（"+yjxxVo.getOffset()+"），请加强审核！";
        }else if(YjzbCodeEnum.Z16103.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getBgdno()+"）申报商品（"+yjxxVo.getCmname()+"）对应计税依据单价（"+yjxxVo.getSpdj()+"元）高于全省平均单价（"+yjxxVo.getPjdj()+"），偏差度（"+yjxxVo.getOffset()+"），请加强审核！";
        }else if(YjzbCodeEnum.Z16401.getCode().equals(zbcode)){
            yjMsg = "该企业上年度三三智检评定为红码企业，请加强审核！";
        }else if(YjzbCodeEnum.Z16402.getCode().equals(zbcode)){
            yjMsg = "该企业存在日常专项监管疑点“出口日期早于供货企业成立日期”未核实，请加强审核！";
        }else if(YjzbCodeEnum.Z16403.getCode().equals(zbcode)){
            yjMsg = "该企业近期存在（"+yjxxVo.getYj_count()+"）笔建议转调查评估排除疑点数据未作调查评估！";
        }else if(YjzbCodeEnum.Z16406.getCode().equals(zbcode)){
            yjMsg = "该企业（"+yjxxVo.getYj_object()+"）正在调查评估未解除，请加强审核！";
        }else if(YjzbCodeEnum.Z16601.getCode().equals(zbcode)){
            yjMsg = "该企业上年度出口销售额合计（"+yjxxVo.getYj_amt()+"）美元，外管局收汇（"+yjxxVo.getCmcode()+"）美元，人民币收汇折美元（"+yjxxVo.getCmname()+"），收汇比例（"+yjxxVo.getOffset()+"）偏低。";
        }else if(YjzbCodeEnum.Z12101.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_object()+"）出口日期（"+yjxxVo.getKprq()+"），企业未按要求报送国内物流信息，请注意审核！";
        }else if(YjzbCodeEnum.Z12102.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_object()+"）出口销售额（"+yjxxVo.getYj_amt()+"），企业填报的出口发票号码（"+yjxxVo.getYj_record()+"）不存在，请注意审核！";
        }else if(YjzbCodeEnum.Z12302.getCode().equals(zbcode)){
            yjMsg = "生产企业11位商品代码（"+yjxxVo.getYj_object()+"）退税率（"+yjxxVo.getFoo()+"）就低申报，申报笔数：（"+yjxxVo.getYj_count()+"），退免税额合计：（"+yjxxVo.getYj_tax()+"）元，请加强审核！";
        }else if(YjzbCodeEnum.Z12401.getCode().equals(zbcode)){
            yjMsg = "生产企业申报视同自产，商品代码：（"+yjxxVo.getCmcode()+"）业务类型：（"+yjxxVo.getFoo()+"）明细笔数：（"+yjxxVo.getYj_count()+"），退免税额：（"+yjxxVo.getYj_tax()+"）元，请加强审核！";
        }else if(YjzbCodeEnum.Z12403.getCode().equals(zbcode)){
            yjMsg = "生产企业申报视同自产，企业存在36个月内被认定出口骗税、虚开发票行为的处罚决定，请加强审核！";
        }else if(StringUtils.isNotBlank(yjxxVo.getYjMsg())){
            return yjxxVo.getYjMsg();
        }
        return yjMsg;
    }
}
