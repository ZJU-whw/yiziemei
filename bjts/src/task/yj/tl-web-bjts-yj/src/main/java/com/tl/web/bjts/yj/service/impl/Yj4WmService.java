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
import com.tl.web.bjts.yj.utils.ConstUtil;
import com.tl.web.bjts.yj.utils.Tools;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.util.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;

/**
 * @Author：Mamf
 * @Date: 2017/12/29.
 * @Description:
 */
@Service
public class Yj4WmService extends IYjService{

    private Logger logger = LoggerFactory.getLogger(Yj4WmService.class);

    @Resource
    YjMapper yjMapper;

    @Resource
    Yj4TssbService yj4TssbService;

    @Resource
    LocalCache localCache;

    @Override
    protected void executeNewYjProcess(TaskVo ysxx, Map<String, String> swjgYjDicCodeMap, Map<String, YjzbItemVo> yjzbItemMap, Map yjBmdMap, Map<String, Long> tbpcMap) {
        boolean isClosedYjBreak = MyAppConfig.isClosedYjBreak;

        yj4TssbService.executeNewYjProcess(ysxx, swjgYjDicCodeMap, yjzbItemMap, yjBmdMap, tbpcMap);

        //新企业首次出口
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


        //2.预警类型(新增供应商)
        if(isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeSupplier))
                ||!isClosedYjBreak){

            ysxx.setYjType(IYjService.YjTypeSupplier);

            logger.info("【执行预警指标：{}】",IYjService.YjTypeSupplier);
            checkGhqy102All(ysxx,tbpcMap,yjBmdMap,yjzbItemMap);

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10203.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z10203.getCode(),YjzbCodeEnum.Z10203.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10203.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10203.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkGhqy10203(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjBmdMap,score);
            }
        }


        //3.预警类型(异常供货商)
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeYcghs))
                ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeYcghs);//用于通过该大类预警代码获取适用企业、适用税务标志

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10701.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z10701.getCode(),YjzbCodeEnum.Z10701.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10701.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10701.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkYcghs10701(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjBmdMap,score);
            }

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10703.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z10703.getCode(),YjzbCodeEnum.Z10703.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10703.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10703.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkYcghs10703(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjBmdMap,score);
            }
        }



        //6.供货企业函调异常
        if(isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeGhqyhd))
                ||!isClosedYjBreak){

            ysxx.setYjType(IYjService.YjTypeGhqyhd);

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z11103.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z11103.getCode(),YjzbCodeEnum.Z11103.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z11103.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z11103.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkGhqyhd11103(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjBmdMap,score);
            }
        }


        //10.预警类型(货源地与供货商税号不一致)
        if(isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeHydGhfshDiffer))
                ||!isClosedYjBreak){

            ysxx.setYjType(IYjService.YjTypeHydGhfshDiffer);

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10401.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z10401.getCode(),YjzbCodeEnum.Z10401.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10401.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10401.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkHydbyz10401(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjBmdMap,score);
            }

        }



        if(isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeSbhtzb))
                ||!isClosedYjBreak){
            ysxx.setYjType(IYjService.YjTypeSbhtzb);//用于通过该大类预警代码获取适用企业、适用税务标志
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z11901.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z11901.getCode(),YjzbCodeEnum.Z11901.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z11901.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z11901.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());
                checkSbhTzb11901(ysxx,tbpcMap,yjBmdMap,score);
            }
        }

        //6,非金华地区义务报关预警
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

        //异地报关指标（海运）
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeYdBg)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeYdBg);

            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16001.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16001.getCode(),YjzbCodeEnum.Z16001.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16001.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16001.getCode());

                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkYdbg16001(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjzbItemVo.getP2val(),yjBmdMap,score);
            }

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

                checkJgdj16101Wm(ysxx,tbpcMap,yjzbItemVo,yjBmdMap,score);
            }

            //16102: 单价>=100元且<10万，近12个月退税>=50万，退税额>=3万，偏差度>=3
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16102.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16102.getCode(),YjzbCodeEnum.Z16102.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16102.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16102.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkJgdj16102Wm(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjzbItemVo.getP2val(),
                        yjzbItemVo.getP3val(),yjzbItemVo.getP4val(),yjBmdMap,score);
            }

            //16103: 单价<100元，近12个月退税>=50万，退税额>=3万，偏差度>=5
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16103.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16103.getCode(),YjzbCodeEnum.Z16103.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16103.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16103.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkJgdj16103Wm(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjzbItemVo.getP2val(),
                        yjzbItemVo.getP3val(),yjzbItemVo.getP4val(),yjBmdMap,score);
            }
        }

        //出口与开票时间间隔指标（外贸专用）
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeCkkpSjjg)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeCkkpSjjg);

            boolean isExist16201 = false;
            //16201: 关联号对应退税额>=3万 且 开票滞后>=90天
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16201.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16201.getCode(),YjzbCodeEnum.Z16201.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16201.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16201.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                isExist16201 = checkCkkpSjjg16201(ysxx, tbpcMap, yjzbItemVo.getP1val(), yjzbItemVo.getP2val(), yjBmdMap, score);
            }

            //16202: 近12个月16201预警次数汇总提醒
            if((isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16202.getCode())) && isExist16201)
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16202.getCode(),YjzbCodeEnum.Z16202.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16202.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16202.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkCkkpSjjg16202(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjBmdMap,score);
            }
        }

        //163、每美元利润率分析指标（外贸专用）
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeWmqyMmylrl)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeWmqyMmylrl);

            //16301: 近12个月退税额>=P1VAL 且 关联号退税额>=P2VAL 且 每美元利润率<P3VAL
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16301.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z16301.getCode(),YjzbCodeEnum.Z16301.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z16301.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z16301.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkWmqyMmylrl163(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjzbItemVo.getP2val(),
                        yjzbItemVo.getP3val(),yjBmdMap,score);
            }
        }

        //164、风险企业调查评估指标（生产和外贸通用）
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

        //121、未申报物流信息指标（外贸企业适用免退税业务）
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeWsbWaxx)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeWsbWaxx);

            logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z12101.getCode(),YjzbCodeEnum.Z12102.getCode());

            checkWsbWaxx12101Wm(ysxx,tbpcMap,yjBmdMap,yjzbItemMap);
        }

        //123、出口商品码多退税率核对预警（外贸专用）
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeYjbmtdtshd)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeYjbmtdtshd);

            //12301: 外贸企业退税率就高申报预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12301.getCode()))
                    ||!isClosedYjBreak){

                logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z12301.getCode(),YjzbCodeEnum.Z12301.getMsg());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12301.getCode())));

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z12301.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                checkYjbmtdtshd12301(ysxx,tbpcMap,yjzbItemVo.getP1val(),yjBmdMap,score);
            }
        }

        //125、换汇成本超阈值预警（外贸专用）
        if((isQyYj(swjgYjDicCodeMap.get(IYjService.YjTypeHkbccb)) ||!isClosedYjBreak)){

            ysxx.setYjType(IYjService.YjTypeHkbccb);

            logger.info("【执行预警指标：{}-{}】",YjzbCodeEnum.Z12501.getCode(),YjzbCodeEnum.Z12502.getCode());

            //12501: 外贸企业换汇成本超上限预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12501.getCode()))
                    ||!isClosedYjBreak){

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z12501.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12501.getCode())));

                checkHkbccb12501(ysxx,tbpcMap,yjzbItemVo,yjBmdMap,score);
            }

            //12502: 外贸企业换汇成本超下限预警
            if(isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12502.getCode()))
                    ||!isClosedYjBreak){

                YjzbItemVo yjzbItemVo = yjzbItemMap.get(YjzbCodeEnum.Z12502.getCode());
                Integer score=Integer.parseInt(yjzbItemVo.getScore());

                ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z12502.getCode())));

                checkHkbccb12502(ysxx,tbpcMap,yjzbItemVo,yjBmdMap,score);
            }
        }

    }


    private void checkGhqy102All(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Map<String, YjzbItemVo> yjzbItemMap) {

        YjzbItemVo yjzb10201ItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10201.getCode());
        YjzbItemVo yjzb10204ItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10204.getCode());
        YjzbItemVo yjzb10205ItemVo = yjzbItemMap.get(YjzbCodeEnum.Z10205.getCode());

        boolean isYjZb10201 = (isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10201.getCode())))||!MyAppConfig.isClosedYjBreak;
        boolean isYjZb10204 = (isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10204.getCode())))||!MyAppConfig.isClosedYjBreak;
        boolean isYjZb10205 = (isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10205.getCode())))||!MyAppConfig.isClosedYjBreak;

        if(!isYjZb10204 && !isYjZb10201 && !isYjZb10205){
            super.clearDBType();
            return;
        }

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setPval1(yjzb10201ItemVo.getP1val());
        pramDTO.setLcslid(ysxx.getLcslid());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        List<YjxxNewVo> list =yjMapper.selectGhqy10201(pramDTO);

        List<YjxxNewVo> yjzb10201list=new ArrayList<>();
        List<YjxxNewVo> yjzb10204list=new ArrayList<>();
        List<YjxxNewVo> yjzb10205list=new ArrayList<>();
        for (YjxxNewVo yjxxNewVo : list) {
            boolean isAbQyGllbDm = Arrays.asList("A", "B").contains(yjxxNewVo.getCkqygllbDm());
            if(isYjZb10204 && isAbQyGllbDm && new BigDecimal(yjxxNewVo.getYj_tax()).compareTo(new BigDecimal(yjzb10204ItemVo.getP1val())) > 0){
                yjxxNewVo.setOffset(yjzb10204ItemVo.getP1val());
                yjzb10204list.add(yjxxNewVo);
            }else if (isYjZb10205 && !isAbQyGllbDm && new BigDecimal(yjxxNewVo.getYj_tax()).compareTo(new BigDecimal(yjzb10205ItemVo.getP1val())) > 0){
                yjxxNewVo.setOffset(yjzb10205ItemVo.getP1val());
                yjzb10205list.add(yjxxNewVo);
            }else if(isYjZb10201){
                yjzb10201list.add(yjxxNewVo);
            }
        }

        if((!yjzb10201list.isEmpty() && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10201.getCode())))
                ||!MyAppConfig.isClosedYjBreak){
            ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10201.getCode())));
            Integer score=Integer.parseInt(yjzb10201ItemVo.getScore());
            super.insertYjDataYjxx(yjzb10201list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z10201.getCode(), score);
        }
        if((!yjzb10204list.isEmpty() && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10204.getCode())))
                ||!MyAppConfig.isClosedYjBreak){
            ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10204.getCode())));
            Integer score=Integer.parseInt(yjzb10204ItemVo.getScore());
            super.insertYjDataYjxx(yjzb10204list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z10204.getCode(), score);
        }

        if((!yjzb10205list.isEmpty() && isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10205.getCode())))
                ||!MyAppConfig.isClosedYjBreak){
            ysxx.setYjzbClosedTemp(!isQyYjZb(yjzbItemMap.get(YjzbCodeEnum.Z10205.getCode())));
            Integer score=Integer.parseInt(yjzb10205ItemVo.getScore());
            super.insertYjDataYjxx(yjzb10205list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z10205.getCode(), score);
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
        List<YjxxNewVo> list = yjMapper.selectGysHdWhh(ysxx.getLcslid());

        super.insertYjDataYjxx(list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16406.getCode(), score);
    }

    /**
     * 未申报物流信息预警 - 12101（外贸企业免退税业务）
     * @param ysxx 任务信息
     * @param tbpcMap 同步批次MAP
     * @param yjBmdMap 预警名单MAP
     * @param yjzbItemMap 预警指标配置
     */
    private void checkWsbWaxx12101Wm(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Map<String, YjzbItemVo> yjzbItemMap) {

        // 1. 查询免退税申报的报关单信息（SQL15）
        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        List<MtsBgxx121Vo> bgdList = yjMapper.selectMtsBgxx121(ysxx.getLcslid());

        if(bgdList == null || bgdList.isEmpty()){
            super.clearDBType();
            logger.info("预警指标：12101，未查询到免退税报关单数据");
            return;
        }

        // 获取企业登记序号
        String djxh = ysxx.getCpcode();
        if(StringUtils.isEmpty(djxh)){
            super.clearDBType();
            logger.warn("预警指标：12101，未查询到登记序号：{}", ysxx.getNsrdjno());
            return;
        }


        super.changeDataSource(MultipleDataSourceHolder.SZDP);
        // 4. 批量预查询：所有出口发票备注
        Map<String, FpjcxxbBzVo> fpBzMap = new java.util.HashMap<>();
        for (MtsBgxx121Vo bgd : bgdList) {
            String fphm = bgd.getCkfph();
            if(StringUtils.isNotEmpty(fphm)){

                FpjcxxbBzVo fpjcxxbBzVo = new FpjcxxbBzVo();
                FphmBzVo bzVo = yjMapper.selectFpbzWlxx(fphm);
                String bz = bzVo==null?null:(bzVo.getBz()==null?"":bzVo.getBz());
                fpjcxxbBzVo.setBz(bz);
                fpBzMap.put(fphm, fpjcxxbBzVo);
            }
        }

        // 5. 批量预查询：所有供应商信息
        Map<String, Map<String, Object>> gysInfoMap = new HashMap<>();
        for (MtsBgxx121Vo bgd : bgdList) {
            String jhpzh = bgd.getJhpzh();
            if(StringUtils.isNotEmpty(jhpzh)){
                Map<String, Object> gysInfo = yjMapper.selectGysxx121(jhpzh);
                if(gysInfo != null){
                    gysInfoMap.put(jhpzh, gysInfo);
                }
            }
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


        // 6. 批量预查询：所有集装箱信息
        Map<String, Map<String, Object>> jzxhMap = new HashMap<>();
        for (String bgdhgbh : bgdhgbhList) {
            Map<String, Object> jzxx = yjMapper.selectJzxh121(bgdhgbh);
            if(jzxx != null){
                jzxhMap.put(bgdhgbh, jzxx);
            }
        }

        // 7. 批量预查询：所有发货模式
        Map<String, Integer> fhmsMap = new java.util.HashMap<>();
        for (String bgdhgbh : bgdhgbhList) {
            int fhms = yjMapper.selectFhms121(bgdhgbh);
            fhmsMap.put(bgdhgbh, fhms);
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

        Map<String, String> xzqhModelMap = localCache.getCodeNameMap(LocalCache.DM_XZQH, DmXzqhModel::getDm, DmXzqhModel::getQycode);
        Map<String, String> hgcodeModelMap = localCache.getCodeNameMap(LocalCache.DM_HGCODE, HgcodeXzqhModel::getHgcode, HgcodeXzqhModel::getXzqhDm);
        Map<String, String> gbcodeModelMap = localCache.getCodeNameMap(LocalCache.DM_GBCODE, DmGbcodeModel::getGbCode, DmGbcodeModel::getQycode);
        // 8. 遍历报关单，处理物流信息和链路记录
        for (MtsBgxx121Vo bgd : bgdList) {
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
                params = buildBgdwlParamsWm(bgd, djxh, cph, yqrq, qyd, wlxxlyDm,
                    ysxx.getSwcode(), gysInfoMap.get(bgd.getJhpzh()), jzxhMap.get(bgdhgbh), fhmsMap.get(bgdhgbh), xzqhModelMap, hgcodeModelMap, gbcodeModelMap);
                params.put("ckfpbz", ckfpbz);
                params.put("ckmxbz", ckmxbz);
                insertList.add(params);
                logger.info("预警指标：12101，收集新增报关单链路信息：BGDHGBH={}", bgdhgbh);
            }else{
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


        // 9. 批量执行插入
        if(!insertList.isEmpty()){
            for (Map<String, Object> params : insertList) {
                yjMapper.insertBgdwl(params);
            }
            logger.info("预警指标：12101，批量新增报关单链路信息：{}条", insertList.size());
        }

        // 10. 批量执行更新
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
     * 构建报关单链路信息参数（外贸企业）
     */
    private Map<String, Object> buildBgdwlParamsWm(MtsBgxx121Vo bgd, String djxh,
                                                   String cph, String yqrq, String qyd,
                                                   String wlxxlyDm, String swjgdm,
                                                   Map<String, Object> gysInfo, Map<String, Object> jzxhMap, Integer fhms, Map<String, String> xzqhModelMap, Map<String, String> hgcodeModelMap, Map<String, String> gbcodeModelMap) {
        Map<String, Object> params = new java.util.HashMap<>();
        params.put("djxh", djxh);
        params.put("bgdhgbh", bgd.getBgdhgbh());
        params.put("dlzmh", bgd.getDlzmh());
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

        params.put("jhpzh", bgd.getJhpzh());

        // 使用预查询的供应商信息
        params.put("ghfnsrmc",   gysInfo==null?null:gysInfo.get("XSFMC"));
        params.put("ghfnsrswjg", gysInfo==null?null:gysInfo.get("XSFZGSWJ_DM"));
        params.put("ghfnsrsbh", bgd.getGhfnsrsbh1());

        // 使用预查询的集装箱信息
        params.put("jzxh", jzxhMap.get("JZXH"));
        params.put("jzxsl", jzxhMap.get("JZXSL"));

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

        // 查询风险等级
        String ysfsDm = bgd.getYsfsDm();
        String spdlDm = bgd.getSpdlDm();

        String qycodeHyd;
        if(gysInfo != null && gysInfo.get("XZQH_DM") != null){
            qycodeHyd = xzqhModelMap.get(gysInfo.get("XZQH_DM"));
        }else {
            qycodeHyd = null;
        }
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
     * 商品单价畸高预警 - 外贸企业16101（单笔>=10万元）
     * @param ysxx
     * @param tbpcMap
     * @param yjzbItemVo 参数
     * @param yjBmdMap
     * @param score
     */
    private void checkJgdj16101Wm(TaskVo ysxx, Map<String, Long> tbpcMap, YjzbItemVo yjzbItemVo, Map yjBmdMap, Integer score) {

        String p1val = yjzbItemVo.getP1val();
        String p2val = yjzbItemVo.getP2val();
        String p3val = yjzbItemVo.getP3val();

        if(StringUtils.isEmpty(p1val)
                || StringUtils.isEmpty(p2val)
                || StringUtils.isEmpty(p3val)
                ){
            logger.warn("预警指标：16101，参数未设置完整，跳过处理");
            return;
        }

        YjPramDTO pramDTO = new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        pramDTO.setPval1(p1val);

        String djxh = ysxx.getCpcode();
        pramDTO.setDjxh(new BigDecimal(djxh));

        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        // 统计企业近12个月退税额
        String needYjCon = yjMapper.selectCheckTsehj(djxh, new BigDecimal(p2val));
        // 判断是否满足退税额阈值
        if(StringUtils.isEmpty(needYjCon)){
            super.clearDBType();
            return;
        }

        List<YjxxNewVo> list = yjMapper.selectWmSpdj161(pramDTO);
        List<YjxxNewVo> resultList = new ArrayList<>();
        for (YjxxNewVo vo : list) {

            // 判断单笔退免税额是否>=3万
            BigDecimal tmse = new BigDecimal(vo.getYj_tax() == null ? "0" : vo.getYj_tax());
            if(tmse.compareTo(new BigDecimal(p3val)) < 0){
                continue;
            }

            BigDecimal spdj = new BigDecimal(vo.getSpdj() == null ? "0" : vo.getSpdj());
            // 判断单价是否>=P1VAL(10万)
            if(spdj.compareTo(new BigDecimal(p1val)) >= 0){
                YjxxNewVo yjxxVo = new YjxxNewVo();
                yjxxVo.setYj_record(vo.getYj_record()); // 关联号
                yjxxVo.setYj_object(vo.getBgdno()); // 报关单号
                yjxxVo.setYj_amt(vo.getYj_amt()); // 美元离岸价
                yjxxVo.setYj_tax(vo.getYj_tax()); // 退税额
                yjxxVo.setCmname(vo.getCmname());
                yjxxVo.setSpdj(vo.getSpdj());
                yjxxVo.setPjdj(p1val);
                yjxxVo.setBgdno(vo.getBgdno());
                resultList.add(yjxxVo);
            }
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16101.getCode(), score);
    }

    /**
     * 商品单价畸高预警 - 外贸企业16102（单价>=100元，偏差度>=3）
     * @param ysxx
     * @param tbpcMap
     * @param p1val 单价阈值（100元）
     * @param p2val 企业近12个月退税额阈值（50万）
     * @param p3val 单笔退免税额阈值（3万）
     * @param p4val 偏差度阈值（3）
     * @param yjBmdMap
     * @param score
     */
    private void checkJgdj16102Wm(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, String p2val,
                                   String p3val, String p4val, Map yjBmdMap, Integer score) {
        if(StringUtils.isEmpty(p1val)
                || StringUtils.isEmpty(p2val)
                || StringUtils.isEmpty(p3val)
                || StringUtils.isEmpty(p4val)){
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

        // 查询外贸企业进货单价信息
        YjPramDTO pramDTO = new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        List<YjxxNewVo> list = yjMapper.selectWmSpdj161(pramDTO);

        List<YjxxNewVo> resultList = new ArrayList<>();
        BigDecimal thresholdP1 = new BigDecimal(p1val);
        BigDecimal thresholdP3 = new BigDecimal(p3val);
        BigDecimal thresholdP4 = new BigDecimal(p4val);

        super.changeDataSource(MultipleDataSourceHolder.TLADMIN);
        for (YjxxNewVo vo : list) {
            // 判断单价是否>=100元
            BigDecimal spdj = new BigDecimal(vo.getSpdj() == null ? "0" : vo.getSpdj());
            if(spdj.compareTo(thresholdP1) < 0){
                continue;
            }
            // 判断单笔退免税额是否>=3万
            BigDecimal tmse = new BigDecimal(vo.getYj_tax() == null ? "0" : vo.getYj_tax());
            if(tmse.compareTo(thresholdP3) < 0){
                continue;
            }

            // 计算偏差度：外贸企业用进货单价与全省外贸企业平均单价比较
            BigDecimal qspjDj = calculateQspjDjWm(vo.getYj_object());
            if(qspjDj.compareTo(BigDecimal.ZERO) <= 0){
                continue;
            }
            BigDecimal pd = spdj.divide(qspjDj, 2, BigDecimal.ROUND_HALF_UP);
            // 判断偏差度是否>=3
            if(pd.compareTo(thresholdP4) >= 0){
                YjxxNewVo yjxxVo = new YjxxNewVo();
                yjxxVo.setYj_record(vo.getYj_record());
                yjxxVo.setYj_object(vo.getBgdno()); // 报关单号
                yjxxVo.setYj_amt(vo.getYj_amt());
                yjxxVo.setYj_tax(vo.getYj_tax());
                yjxxVo.setCmname(vo.getCmname());
                yjxxVo.setSpdj(vo.getSpdj());
                yjxxVo.setPjdj(qspjDj.toString());
                yjxxVo.setOffset(pd.toString());
                yjxxVo.setBgdno(vo.getBgdno());
                resultList.add(yjxxVo);
            }
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16102.getCode(), score);
    }

    /**
     * 商品单价畸高预警 - 外贸企业16103（单价<100元，偏差度>=5）
     * @param ysxx
     * @param tbpcMap
     * @param p1val 单价阈值（100元，条件是<100）
     * @param p2val 企业近12个月退税额阈值（50万）
     * @param p3val 单笔退免税额阈值（3万）
     * @param p4val 偏差度阈值（5）
     * @param yjBmdMap
     * @param score
     */
    private void checkJgdj16103Wm(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, String p2val,
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

        // 查询外贸企业进货单价信息
        YjPramDTO pramDTO = new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        List<YjxxNewVo> list = yjMapper.selectWmSpdj161(pramDTO);

        List<YjxxNewVo> resultList = new ArrayList<>();
        BigDecimal thresholdP1 = new BigDecimal(p1val);
        BigDecimal thresholdP3 = new BigDecimal(p3val);
        BigDecimal thresholdP4 = new BigDecimal(p4val);

        super.clearDBType();
        for (YjxxNewVo vo : list) {
            // 判断单价是否<100元（注意：条件是小于P1VAL，不是大于）
            BigDecimal spdj = new BigDecimal(vo.getSpdj() == null ? "0" : vo.getSpdj());
            if(spdj.compareTo(thresholdP1) >= 0){
                continue;
            }
            // 判断单笔退免税额是否>=3万
            BigDecimal tmse = new BigDecimal(vo.getYj_tax() == null ? "0" : vo.getYj_tax());
            if(tmse.compareTo(thresholdP3) < 0){
                continue;
            }

            // 计算偏差度
            BigDecimal qspjDj = calculateQspjDjWm(vo.getYj_object());
            if(qspjDj.compareTo(BigDecimal.ZERO) <= 0){
                continue;
            }
            BigDecimal pd = spdj.divide(qspjDj, 2, BigDecimal.ROUND_HALF_UP);
            // 判断偏差度是否>=5
            if(pd.compareTo(thresholdP4) >= 0){
                YjxxNewVo yjxxVo = new YjxxNewVo();
                yjxxVo.setYj_record(vo.getYj_record());
                yjxxVo.setYj_object(vo.getBgdno()); // 报关单号
                yjxxVo.setYj_amt(vo.getYj_amt());
                yjxxVo.setYj_tax(vo.getYj_tax());
                yjxxVo.setCmname(vo.getCmname());
                yjxxVo.setSpdj(vo.getSpdj());
                yjxxVo.setPjdj(qspjDj.toString());
                yjxxVo.setOffset(pd.toString());
                yjxxVo.setBgdno(vo.getBgdno());
                resultList.add(yjxxVo);
            }
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16103.getCode(), score);
    }

    /**
     * 出口与开票时间间隔预警 - 16201按关联号预警
     * @param ysxx
     * @param tbpcMap
     * @param p1val 退税额阈值（3万元）
     * @param p2val 滞后天数阈值（90天）
     * @param yjBmdMap
     * @param score
     */
    private boolean checkCkkpSjjg16201(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, String p2val, Map yjBmdMap, Integer score) {
        if(StringUtils.isEmpty(p1val) || StringUtils.isEmpty(p2val)){
            logger.warn("预警指标：16201，参数未设置完整，跳过处理");
            return false;
        }

        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        List<YjxxNewVo> list = yjMapper.selectCkkpSjjg16201(ysxx.getLcslid());
        List<YjxxNewVo> resultList = new ArrayList<>();

        BigDecimal thresholdP1 = new BigDecimal(p1val);
        BigDecimal thresholdP2 = new BigDecimal(p2val);
        for (YjxxNewVo vo : list) {
            BigDecimal tse = new BigDecimal(vo.getYj_tax() == null ? "0" : vo.getYj_tax());
            BigDecimal zhkpts = new BigDecimal(vo.getYj_count() == null ? "0" : vo.getYj_count());

            // 判断退税额>=3万 且 开票滞后>=90天
            if(tse.compareTo(thresholdP1) >= 0 && zhkpts.compareTo(thresholdP2) >= 0){
                YjxxNewVo yjxxVo = new YjxxNewVo();
                yjxxVo.setYj_record(vo.getYj_record());
                yjxxVo.setYj_object(vo.getYj_object()); // /报关单号
                yjxxVo.setYj_tax(vo.getYj_tax()); // 退税额
                yjxxVo.setYj_count(vo.getYj_count()); // 滞后天数
                yjxxVo.setKprq(vo.getKprq()); // 开票日期
                yjxxVo.setYj_amt(vo.getYj_amt());
                yjxxVo.setCkrq(vo.getCkrq());
                resultList.add(yjxxVo);
            }
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16201.getCode(), score);

        return !CollectionUtils.isEmpty(resultList);
    }

    /**
     * 出口与开票时间间隔预警 - 16202近期滞后开票次数提醒
     * @param ysxx
     * @param tbpcMap
     * @param p1val 统计月数（12个月）
     * @param yjBmdMap
     * @param score
     */
    private void checkCkkpSjjg16202(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, Map yjBmdMap, Integer score) {
        if(StringUtils.isEmpty(p1val)){
            logger.warn("预警指标：16202，参数未设置完整，跳过处理");
            return;
        }

        int months = Integer.parseInt(p1val);
        Long nsrdzdah = Long.parseLong(ysxx.getNsrdzdah());

        // 查询近12个月16201预警次数
        int count = yjMapper.selectCkkpSjjgCount16202(nsrdzdah, months);

        List<YjxxNewVo> resultList = new ArrayList<>();
        if(count > 0){
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setYj_count(String.valueOf(count));
            resultList.add(yjxxVo);
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16202.getCode(), score);
    }

    /**
     * 每美元利润率分析预警 - 16301
     * @param ysxx
     * @param tbpcMap
     * @param p1val 企业近12个月退税额阈值
     * @param p2val 关联号退税额阈值
     * @param p3val 每美元利润率预警线阈值
     * @param yjBmdMap
     * @param score
     */
    private void checkWmqyMmylrl163(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, String p2val,
                                    String p3val, Map yjBmdMap, Integer score) {
        if(StringUtils.isEmpty(p1val) || StringUtils.isEmpty(p2val) || StringUtils.isEmpty(p3val)){
            logger.warn("预警指标：16301，参数未设置完整，跳过处理");
            return;
        }

        String djxh = ysxx.getCpcode();

        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        // 统计企业近12个月退税额
        String needYjCon = yjMapper.selectCheckTsehj(djxh, new BigDecimal(p1val));
        // 判断是否满足退税额阈值
        if(StringUtils.isEmpty(needYjCon)){
            super.clearDBType();
            return;
        }

        // 查询关联号每美元利润率信息

        List<YjxxNewVo> list;
        try {
            list = yjMapper.selectWmqyMmylrl163(ysxx.getLcslid());
        } catch (Exception e) {
            logger.error("SQL执行异常,SBID:{}",ysxx.getId(),e);
            return;
        }
        List<YjxxNewVo> resultList = new ArrayList<>();

        BigDecimal thresholdP2 = new BigDecimal(p2val);
        BigDecimal thresholdP3 = new BigDecimal(p3val);
        for (YjxxNewVo vo : list) {
            BigDecimal tse = new BigDecimal(vo.getYj_tax() == null ? "0" : vo.getYj_tax());
            BigDecimal mmylr = new BigDecimal(vo.getOffset() == null ? "0" : vo.getOffset());

            // 判断关联号退税额>=P2VAL 且 每美元利润率<P3VAL
            if(tse.compareTo(thresholdP2) >= 0 && mmylr.compareTo(thresholdP3) < 0){
                YjxxNewVo yjxxVo = new YjxxNewVo();
                yjxxVo.setOffset(vo.getOffset()); //每美元利润率
                yjxxVo.setYj_amt(vo.getYj_amt()); // 美元离岸价
                yjxxVo.setYj_tax(vo.getYj_tax()); // 退税额
                yjxxVo.setYj_object(vo.getYj_object());
                yjxxVo.setYj_record(vo.getYj_record());
                resultList.add(yjxxVo);
            }
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16301.getCode(), score);
    }

    /**
     * 风险企业调查评估 - 16401三三智检红码企业预警
     * @param ysxx
     * @param tbpcMap
     * @param yjBmdMap
     * @param score
     */
    private void checkFxqydcpg16401(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Integer score) {

        String djxh = ysxx.getCpcode();

        super.changeDataSource(MultipleDataSourceHolder.TLTSSH);

        // 查询三三智检红码等级（3表示红码）
        Integer jkmLevel = yjMapper.selectJkmLevel(djxh);

        List<YjxxNewVo> resultList = new ArrayList<>();
        // 如果是红码企业，则预警
        if(jkmLevel != null && jkmLevel == ConstUtil.JKM_RED){
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setYj_object(ysxx.getNsrdjno());
            resultList.add(yjxxVo);
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16401.getCode(), score);
    }

    /**
     * 风险企业调查评估 - 16402日常专项监管疑点企业预警
     * @param ysxx
     * @param tbpcMap
     * @param yjBmdMap
     * @param score
     */
    private void checkFxqydcpg16402(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Integer score) {

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        String djxh = yjMapper.selectDjxhByNsrsbh(ysxx.getNsrdjno());
        if(StringUtils.isEmpty(djxh)){
            super.clearDBType();
            logger.warn("未查询到登记序号：{}",ysxx.getNsrdjno());
            return;
        }

        super.changeDataSource(MultipleDataSourceHolder.TLTSSH);
        // 查询专项监管未核实疑点数量
        Integer whsydCount = yjMapper.selectZxzbWhsydCount(new BigDecimal(djxh));

        List<YjxxNewVo> resultList = new ArrayList<>();
        // 如果存在未核实疑点，则预警
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
     * @param ysxx
     * @param tbpcMap
     * @param p1val 统计月数
     * @param yjBmdMap
     * @param score
     */
    private void checkFxqydcpg16403(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, Map yjBmdMap, Integer score) {
        if(StringUtils.isEmpty(p1val)){
            logger.warn("预警指标：16403，参数未设置，跳过处理");
            return;
        }
        int months = Integer.parseInt(p1val);
        // 查询16404预警未处理数量
        Integer notProcessedCount = yjMapper.select16404NotProcessedCount(ysxx.getCpcode(), months);

        List<YjxxNewVo> resultList = new ArrayList<>();
        // 如果存在未处理预警，则预警
        if(notProcessedCount != null && notProcessedCount > 0){
            YjxxNewVo yjxxVo = new YjxxNewVo();
            yjxxVo.setYj_count(String.valueOf(notProcessedCount));
            resultList.add(yjxxVo);
        }

        super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16403.getCode(), score);
    }

    /**
     * 风险企业调查评估 - 16404三新预警单笔涉税金额超阈值预警
     * @param ysxx
     * @param tbpcMap
     * @param p1val 税额阈值
     * @param yjBmdMap
     * @param score
     */
    private void checkFxqydcpg16404(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, Map yjBmdMap, Integer score) {
        if(StringUtils.isEmpty(p1val)){
            logger.warn("预警指标：16404，参数未设置，跳过处理");
            return;
        }

        BigDecimal threshold = new BigDecimal(p1val);
        // 查询三新预警涉税金额超阈值数据
        List<YjxxNewVo> list = yjMapper.selectSanxinYjOverThreshold(ysxx.getLcslid(), threshold);

        super.insertYjDataYjxx(list, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16404.getCode(), score);
    }

    /**
     * 收汇比例偏低预警 - 16601
     * @param ysxx
     * @param tbpcMap
     * @param yjzbItemVo 收汇比例阈值等参数配置
     * @param yjBmdMap
     * @param score
     */
    private void checkShblpd16601(TaskVo ysxx, Map<String, Long> tbpcMap, YjzbItemVo yjzbItemVo, Map yjBmdMap, Integer score) {
        String p1val = yjzbItemVo.getP1val();
        String p2val = yjzbItemVo.getP2val();
        if(StringUtils.isEmpty(p1val) || StringUtils.isEmpty(p2val)){
            logger.warn("预警指标：16601，未设置预警参数值，跳过处理");
            return;
        }

        String djxh = ysxx.getCpcode();

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


        // 如果上年度无出口额，跳过
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
            yjxxVo.setYj_tax(shMy.toString()); // 外管局收汇（美元）
            yjxxVo.setCmcode(wgjSh.toString());
            yjxxVo.setCmname(rmbSh.toString());
            yjxxVo.setOffset(shbl.setScale(2, BigDecimal.ROUND_HALF_UP).toString()); // 收汇比例（%）
            resultList.add(yjxxVo);

            super.insertYjDataYjxx(resultList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z16601.getCode(), score);
        }
    }

    /**
     * 计算外贸企业偏差度 - 查询全省外贸企业平均单价
     * @param spdm 商品代码
     * @return 全省平均单价
     */
    private BigDecimal calculateQspjDjWm(String spdm) {
        // 取商品代码前8位进行匹配
        String spdmPrefix = spdm.length() >= 8 ? spdm.substring(0, 8) : spdm;
        BigDecimal qspjDj = yjMapper.selectQspjDjWm(spdmPrefix);
        return qspjDj != null ? qspjDj : BigDecimal.ZERO;
    }

    /**
     * 异动报关预警逻辑
     * @param ysxx
     * @param tbpcMap
     * @param p1val
     * @param p2val
     * @param yjBmdMap
     * @param score
     */
    private void checkYdbg16001(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, String p2val, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        pramDTO.setPval1(p1val);
        pramDTO.setPval2(p2val);
        if(StringUtils.isEmpty(p1val)||StringUtils.isEmpty(p2val)){
            logger.warn("预警指标：16001，未设置预警参数值，跳过处理");
            return;
        }

        String djxh = ysxx.getCpcode();
        pramDTO.setDjxh(new BigDecimal(djxh));


        super.changeDataSource(MultipleDataSourceHolder.JSXT);

        /*
         * 1)统计出口企业近12个月退税额，判断退税额合计是否大于等于P1VAL（参数阈值）
         */
        String needYjCon1 = yjMapper.selectCheckTsehj(djxh,new BigDecimal(p1val));
       if(StringUtils.isEmpty(needYjCon1)){
           super.clearDBType();
           return;
       }

        List<CustomsDeclarationVo> retlist = yjMapper.selectDeclarationVos(pramDTO.getLcslid());

        super.changeDataSource(MultipleDataSourceHolder.TLADMIN);
        Map<String, String> xzqhModelMap = localCache.getCodeNameMap(LocalCache.DM_XZQH, DmXzqhModel::getDm, DmXzqhModel::getQycode);
        Map<String, String> hgcodeModelMap = localCache.getCodeNameMap(LocalCache.DM_HGCODE, HgcodeXzqhModel::getHgcode, HgcodeXzqhModel::getXzqhDm);
        Map<String, String> gbcodeModelMap = localCache.getCodeNameMap(LocalCache.DM_GBCODE, DmGbcodeModel::getGbCode, DmGbcodeModel::getQycode);
        List<YjxxNewVo> list = new ArrayList<>();
        for (CustomsDeclarationVo declarationVo : retlist) {
            //美元离岸价是否大于大于等于P2VAL
            if(declarationVo.getMylaj().compareTo(new BigDecimal(p2val))<0){
                continue;
            }
            //是否是水路运输
            String ysfsDm = declarationVo.getYsfsDm();
            if(!ConstUtil.YSFSDM_SLYS.equals(ysfsDm)){
                continue;
            }
            super.changeDataSource(MultipleDataSourceHolder.SZDP);
            String gysxzdm = yjMapper.selectGysxzdm(declarationVo.getJhpzh());

            //商品大类代码
            String spdlDm = declarationVo.getSpdlDm();
            //供应商区域代码
            String gysQycode = xzqhModelMap.get(gysxzdm);

            //启运口岸区域代码
            String hgxzdm = hgcodeModelMap.get(declarationVo.getHggqkaDm());
            String hgkaQycode = xzqhModelMap.get(hgxzdm);

            //目的国区域代码
            String mdgdm = declarationVo.getZzmdgdqszDm();
            String mdgQycode = gbcodeModelMap.get(mdgdm);

            // 检查区域代码是否为空
            if (StringUtils.isEmpty(gysQycode) || StringUtils.isEmpty(hgkaQycode)
                    || StringUtils.isEmpty(mdgQycode) || StringUtils.isEmpty(spdlDm)) {
                continue;
            }

            super.changeDataSource(MultipleDataSourceHolder.TLTSSH);
            // D) 判断是否该链路为低风险链路
            Integer riskCount = yjMapper.checkRiskLink(ysxx.getSwcode(), ysfsDm, spdlDm, gysQycode, hgkaQycode, mdgQycode);

            //低风险链路不存在视为高风险
            if (riskCount == null || riskCount == 0) {
                // 生成预警信息
                YjxxNewVo yjxxNewVo = new YjxxNewVo();
                yjxxNewVo.setYj_record(declarationVo.getGlh());
                yjxxNewVo.setYj_amt(declarationVo.getMylaj().toString());
                yjxxNewVo.setYj_tax(declarationVo.getTse().toString());
                yjxxNewVo.setYjMsg(String.format(
                        "关联号（%s）出口链路【货源地（%s）—启运口岸（%s）—运输方式（%s）—目的国（%s）】为罕见路径或新发路径，请加强审核！",
                        declarationVo.getGlh(),
                        localCache.getNameByCode(LocalCache.DM_XZQH,gysxzdm,  DmXzqhModel::getDm, DmXzqhModel::getMc),
                        localCache.getNameByCode(LocalCache.DM_HGCODE,declarationVo.getHggqkaDm(),  HgcodeXzqhModel::getHgcode, HgcodeXzqhModel::getHgmc),
                        "水陆运输",
                        localCache.getNameByCode(LocalCache.DM_GBCODE,mdgdm,  DmGbcodeModel::getGbCode, DmGbcodeModel::getGbName)
                ));

                list.add(yjxxNewVo);
            }
        }

        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z16001.getCode(),score);

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
        List<YwbgCkeVo> datalist =yjMapper.selectYwBghWm12001(pramDTO);
        super.clearDBType();

        List<YjxxNewVo> list = new ArrayList<>();
        for (YwbgCkeVo ywbgCkeVo : datalist) {
            if(ywbgCkeVo.getLcMylaj().compareTo(BigDecimal.ZERO)>0){
                YjxxNewVo yjxxNewVo = new YjxxNewVo();
                yjxxNewVo.setYj_record(ywbgCkeVo.getLcGlh());

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

    private void checkSbhTzb11901(TaskVo ysxx, Map<String, Long> tbpcMap,Map yjBmdMap, Integer score) {
        List<YjxxNewVo> list=new ArrayList<>();
        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        int cnt =yjMapper.selectSbhTzb11901Wm(ysxx.getLcslid());
        super.clearDBType();
        if(cnt==1){
            YjxxNewVo obj=new YjxxNewVo();
            obj.setYj_record("1");
            list.add(obj);
        }
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11901.getCode(),score);
    }

    private void checkGhqyhd130(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Integer score, String hdjglx) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrsbh(ysxx.getNsrdjno());
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setSwjgdm(ysxx.getSwcode());
        pramDTO.setPval1(hdjglx);

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());
        List<YjxxNewVo> list =yjMapper.selectGhqyhd130(pramDTO);

        String zbcode;
        if("1".equals(hdjglx)){
            zbcode=YjzbCodeEnum.Z13001.getCode();
        }else if("2".equals(hdjglx)) {
            zbcode=YjzbCodeEnum.Z13002.getCode();
        }else{
            zbcode=YjzbCodeEnum.Z13003.getCode();
        }

        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,zbcode,score);
    }


    private void checkFirstTsck10301(TaskVo ysxx, Map<String, Long> tbpcMap,Map yjBmdMap, Integer score) {

        List<YjxxNewVo> list=new ArrayList<>();

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        int cnt =yjMapper.selectFirstTsck10301Wm(ysxx.getLcslid());
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

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectHegs20201Wm(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z20201.getCode(),score);
    }

    private void checkSpmcByz10501(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setPval1(s);

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectSpmcByz10501(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10501.getCode(),score);
    }

    private void checkHydbyz10401(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setPval1(s);

        pramDTO.setLcslid(ysxx.getLcslid());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        List<YjxxNewVo> list =yjMapper.selectHydbyz10401(pramDTO);
        super.clearDBType();
        
        Iterator<YjxxNewVo> iterator = list.iterator();
        while (iterator.hasNext()) {
            YjxxNewVo yjxxNewVo = iterator.next();
            String djxh = yjxxNewVo.getDjxh();
            String ckbgdh = yjxxNewVo.getYj_object();
            YjxxNewVo hisObj = yjMapper.selectHisYjHydbyz(djxh,ckbgdh);
            if(hisObj != null){
                iterator.remove();
            }
        }

        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10401.getCode(),score);
    }

    private void checkBghfs11501(TaskVo ysxx, Map<String, Long> tbpcMap, String s, String s2, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setPval1(s);
        pramDTO.setPval2(s2);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectBghfsWm11501(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11501.getCode(),score);
    }

    private void checkYcdj11302(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setPval1(s);
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectYcdj11302Wm(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11302.getCode(),score);
    }

    private void checkSbckka11201(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setPval1(s);
        pramDTO.setCpcode(ysxx.getCpcode());
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectSbckka11201Wm(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11201.getCode(),score);
    }

    private void checkGhqyhd11101(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setSbympc(ysxx.getYjsbympc());
        pramDTO.setPval1(s);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectGhqyhd11101(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11101.getCode(),score);

    }

    private void checkGhqyhd11102(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setPval1(s);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectGhqyhd11102(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11102.getCode(),score);

    }

    private void checkGhqyhd11103(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setPval1(s);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());
        List<YjxxNewVo> list =yjMapper.selectGhqyhd11103(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11103.getCode(),score);

    }

    private void checkMgckkaWm10902(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setPval1(s);
        pramDTO.setSwjgdm(ysxx.getSwcode());
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectMgCkka10902Wm(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10902.getCode(),score);

    }

    private void checkMgckkaWm10901(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setSbympc(ysxx.getYjsbympc());
        pramDTO.setPval1(s);
        pramDTO.setSwjgdm(ysxx.getSwcode());
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());


        List<YjxxNewVo> list =yjMapper.selectMgCkka10901Wm(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10901.getCode(),score);

    }

    private void checkGfxsp10801(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {
        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setSwjgdm(ysxx.getSwcode());
        pramDTO.setSbympc(ysxx.getYjsbympc());
        pramDTO.setPval1(s);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectGfxspWm10801(pramDTO);
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

        List<YjxxNewVo> list =yjMapper.selectGfxspWm10802(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10802.getCode(),score);
    }


    private void checkYcghs10701(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setSbympc(ysxx.getYjsbympc());
        pramDTO.setSwjgdm(ysxx.getSwcode());
        pramDTO.setPval1(s);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectYcghs10701(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10701.getCode(),score);
    }

    private void checkYcghs10702(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setSwjgdm(ysxx.getSwcode());
        pramDTO.setPval1(s);
        pramDTO.setCpcode(ysxx.getCpcode());
        pramDTO.setSbid(ysxx.getId());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectYcghs10702(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10702.getCode(),score);
    }

    private void checkYcghs10703(TaskVo ysxx, Map<String, Long> tbpcMap, String s, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setPval1(s);
        pramDTO.setSbid(ysxx.getId());
        pramDTO.setCpcode(ysxx.getCpcode());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectYcghs10703(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10703.getCode(),score);
    }

    private void checkCqwsbQrStatus(TaskVo ysxx, Map<String, Long> tbpcMap, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        List<Map<String,String>>  retlist = yjMapper.selectMtsmxByLcslid(pramDTO);
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
                newVo.setYj_record(map.get("GLH"));
                list.add(newVo);
            }
        }
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z11701.getCode(),score);
    }


    private void checkGhqy10203(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, Map yjBmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setPval1(p1val);

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        super.changeDataSource(MultipleDataSourceHolder.TLADMIN);
        List<YjxxNewVo> list =yjMapper.selectGhqy10203(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z10203.getCode(),score);
    }

    private void checkSpdm10102(TaskVo ysxx, Map<String, Long> tbpcMap, String pval1, Map bmdMap, Integer score) {

        YjPramDTO pramDTO=new YjPramDTO();
        pramDTO.setNsrdzdah(Long.parseLong(ysxx.getNsrdzdah()));
        pramDTO.setSbympc(ysxx.getYjsbympc());
        pramDTO.setPval1(pval1);
        pramDTO.setCpcode(ysxx.getCpcode());
        pramDTO.setSbid(ysxx.getId());

        logger.debug("{}-参数：{}",ysxx.getId(),pramDTO.toString());

        List<YjxxNewVo> list =yjMapper.selectSpdmWm10102(pramDTO);
        super.insertYjDataYjxx(list,ysxx,tbpcMap,bmdMap,YjzbCodeEnum.Z10102.getCode(),score);
    }
    /**
     * 12301 外贸企业退税率就高申报预警 - 实现逻辑：
     * 1) 提取退免税额阈值 P1VAL
     * 2) 按批次统计免退税进货明细申报表中 11位商品码+退税率 对应关联号数量、退税额合计
     * 3) 按"企业+商品代码"判断预警信息数据表中是否已存在相同指标，已存在则不再继续判断（避免重复预警）
     * 4) 提取商品码前10位对应出口日期的所有退税率（包括 0、9、13 等）
     * 5) 当11位商品码对应退免税额>阈值，且商品码前10位存在更低退税率时，提示预警信息
     *
     * @param ysxx   任务信息
     * @param tbpcMap 同步批次MAP
     * @param p1val   退免税额阈值
     * @param yjBmdMap 预警白名单MAP
     * @param score   预警分值
     */
    private void checkYjbmtdtshd12301(TaskVo ysxx, Map<String, Long> tbpcMap, String p1val, Map yjBmdMap, Integer score){
        if(StringUtils.isEmpty(p1val)){
            logger.warn("预警指标：12301，参数未设置完整，跳过处理");
            return;
        }

        // 1) 准备参数
        YjPramDTO pramDTO = new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        pramDTO.setPval1(p1val);

        // 2) 查询批次汇总（11位商品码+退税率维度）
        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        List<YjxxNewVo> batchList = yjMapper.selectYjbmtdtshd12301ByBatch(pramDTO);

        // 3) 按"企业+商品代码"判断预警信息数据表中是否已存在相同指标，避免重复预警输出
        super.changeDataSource(MultipleDataSourceHolder.TLADMIN);
        if(batchList != null && !batchList.isEmpty()){
            Iterator<YjxxNewVo> iterator = batchList.iterator();
            while (iterator.hasNext()) {
                YjxxNewVo yjxxVo = iterator.next();
                String nsrdzdah = ysxx.getNsrdzdah();
                String spdm = yjxxVo.getYj_object();
                Integer existFlag = yjMapper.checkExistYj12301(nsrdzdah, spdm, ysxx.getLcslid());
                if(existFlag != null){
                    logger.info("12301预警：企业({})商品代码({})已存在历史预警，跳过", nsrdzdah, spdm);
                    iterator.remove();
                }
            }
        }
        super.insertYjDataYjxx(batchList,ysxx,tbpcMap,yjBmdMap,YjzbCodeEnum.Z12301.getCode(),score);
    }

    /**
     * 12501 - 外贸企业换汇成本超上限预警
     * 条件：退税额合计 >= 超上限预警退税额阈值A 且 换汇成本 >= 换汇成本上限阈值B
     * @param ysxx 任务信息
     * @param tbpcMap 同步批次MAP
     * @param yjzbItemVo 预警指标配置(P1val=退税额阈值A, P2val=换汇成本上限阈值B)
     * @param yjBmdMap 预警名单MAP
     * @param score 预警分值
     */
    private void checkHkbccb12501(TaskVo ysxx, Map<String, Long> tbpcMap, YjzbItemVo yjzbItemVo, Map yjBmdMap, Integer score){
        if(StringUtils.isEmpty(yjzbItemVo.getP1val()) || StringUtils.isEmpty(yjzbItemVo.getP2val())){
            logger.warn("预警指标：12501，参数未设置完整，跳过处理");
            return;
        }

        YjPramDTO pramDTO = new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        pramDTO.setPval1(yjzbItemVo.getP1val());
        pramDTO.setPval2(yjzbItemVo.getP2val());

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        List<YjxxNewVo> batchList = yjMapper.selectHkbccbByBgdhSx(pramDTO);

        super.insertYjDataYjxx(batchList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z12501.getCode(), score);

    }

    /**
     * 12502 - 外贸企业换汇成本超下限预警
     * 条件：退税额合计 >= 超下限预警退税额阈值C 且 换汇成本 <= 换汇成本下限阈值D
     * @param ysxx 任务信息
     * @param tbpcMap 同步批次MAP
     * @param yjzbItemVo 预警指标配置(P1val=退税额阈值C, P2val=换汇成本下限阈值D)
     * @param yjBmdMap 预警名单MAP
     * @param score 预警分值
     */
    private void checkHkbccb12502(TaskVo ysxx, Map<String, Long> tbpcMap, YjzbItemVo yjzbItemVo, Map yjBmdMap, Integer score){
        if(StringUtils.isEmpty(yjzbItemVo.getP1val()) || StringUtils.isEmpty(yjzbItemVo.getP2val())){
            logger.warn("预警指标：12502，参数未设置完整，跳过处理");
            return;
        }

        YjPramDTO pramDTO = new YjPramDTO();
        pramDTO.setLcslid(ysxx.getLcslid());
        pramDTO.setPval1(yjzbItemVo.getP1val());
        pramDTO.setPval2(yjzbItemVo.getP2val());

        super.changeDataSource(MultipleDataSourceHolder.JSXT);
        List<YjxxNewVo> batchList = yjMapper.selectHkbccbByBgdhXx(pramDTO);

        super.insertYjDataYjxx(batchList, ysxx, tbpcMap, yjBmdMap, YjzbCodeEnum.Z12502.getCode(), score);
    }

   @Override
    protected String genNewYjmsg(YjxxNewVo yjxxVo, TaskVo ysxx, String zbcode) {
        String yjMsg = "";
        if(YjzbCodeEnum.Z10201.getCode().equals(zbcode)){
            yjMsg = "新增供货商（"+yjxxVo.getYj_object()+"），本期出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10202.getCode().equals(zbcode)){
            yjMsg = "新增供货商（"+yjxxVo.getYj_object()+"），六个月内累计出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10203.getCode().equals(zbcode)){
            yjMsg = "新增供货商，六个月内累计有（"+yjxxVo.getYj_count()+"）户数，全部出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10204.getCode().equals(zbcode)){
            yjMsg = "新增供货商（"+yjxxVo.getYj_object()+"），本期退税额（"+yjxxVo.getYj_tax()+"）超一、二类限额（"+yjxxVo.getOffset()+"），应开展分析核查。";
        }else if(YjzbCodeEnum.Z10205.getCode().equals(zbcode)){
            yjMsg = "新增供货商（"+yjxxVo.getYj_object()+"），本期退税额（"+yjxxVo.getYj_tax()+"）超其他类限额（"+yjxxVo.getOffset()+"），应开展分析核查。";
        }else if(YjzbCodeEnum.Z10701.getCode().equals(zbcode)){
            yjMsg = "异常供货企业（"+yjxxVo.getYj_object()+"），本期出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10702.getCode().equals(zbcode)){
            yjMsg = "异常供货企业（"+yjxxVo.getYj_object()+"），六个月内累计出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10703.getCode().equals(zbcode)){
            yjMsg = "异常供货企业，六个月内累计有（"+yjxxVo.getYj_count()+"）户数，全部出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10801.getCode().equals(zbcode)){
            yjMsg = "敏感出口商品（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getCmname()+"），本期出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10802.getCode().equals(zbcode)){
            yjMsg = "敏感出口商品（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getCmname()+"），六个月内累计出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10901.getCode().equals(zbcode)){
            yjMsg = "敏感出口口岸（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getHgmc()+"），本期出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10902.getCode().equals(zbcode)){
            yjMsg = "敏感出口口岸（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getHgmc()+"），六个月内累计出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z11101.getCode().equals(zbcode)){
            yjMsg = "供货企业（"+yjxxVo.getYj_object()+"）存在异常函调，本期出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z11102.getCode().equals(zbcode)){
            yjMsg = "供货企业（"+yjxxVo.getYj_object()+"）存在异常函调，六个月内累计出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z11103.getCode().equals(zbcode)){
            yjMsg = "供货企业存在异常函调，六个月内累计有（"+yjxxVo.getYj_count()+"）户数，全部出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z11201.getCode().equals(zbcode)){
            yjMsg = "关联号（"+yjxxVo.getYj_record()+"），申报口岸（"+yjxxVo.getSbka()+"名称"+yjxxVo.getSbkamc()+"）与出口口岸（"+yjxxVo.getYj_object()+"名称"+yjxxVo.getCkkamc()+"）不一致，出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z11302.getCode().equals(zbcode)){
            yjMsg = "商品代码（"+yjxxVo.getYj_object()+"）单价（"+yjxxVo.getSpdj()+"）超过全省平均100%以上，出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z11501.getCode().equals(zbcode)){
            yjMsg = "报关行分散预警，六个月内报关行个数（"+yjxxVo.getBghsl()+"），而报关单明细笔数（"+yjxxVo.getBgdsl()+"）";
        }else if(YjzbCodeEnum.Z20201.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_object()+"），霍尔果斯口岸出口的皮毛类商品（"+yjxxVo.getCmcode()+"），请加强审核！";
        }else if(YjzbCodeEnum.Z10401.getCode().equals(zbcode)){
            yjMsg = "关联号（"+yjxxVo.getYj_record()+")下报关单的货源地（"+yjxxVo.getHzdwdqdm()+yjxxVo.getHzdwdqMc()+"）与供货商（"+yjxxVo.getGhfns_no()+"）不一致，出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z10301.getCode().equals(zbcode)){
            yjMsg = "出口企业首次申报出口退（免）税，实地核查尚未结束。";
        }else if(YjzbCodeEnum.Z10501.getCode().equals(zbcode)){
            yjMsg = "关联号（"+yjxxVo.getYj_record()+")下报关单商品代码（"+yjxxVo.getYj_object()+"）出口商品名称（" +
                    yjxxVo.getHgcmname()+"）与进货商品名称（"+yjxxVo.getCmname()+"）不一致，出口金额（"+yjxxVo.getYj_amt()+"）退税额（"+yjxxVo.getYj_tax()+"）";
        }else if(YjzbCodeEnum.Z13001.getCode().equals(zbcode)){
            yjMsg = "对供货企业（"+yjxxVo.getGhfns_no()+yjxxVo.getYj_object()+"）的发函尚未收到回函（"+yjxxVo.getYj_record()+"）,请加强审核，本次申报涉及不含税金额（" +
                    yjxxVo.getYj_amt()+"元）,退税额（"+yjxxVo.getYj_tax()+"元）。";
        }else if(YjzbCodeEnum.Z13002.getCode().equals(zbcode)){
            yjMsg = "对供货企业（"+yjxxVo.getGhfns_no()+yjxxVo.getYj_object()+"）的回函类型为异常但尚无处理意见（"+yjxxVo.getYj_record()+"）,请加强审核，本次申报涉及不含税金额（" +
                    yjxxVo.getYj_amt()+"元）,退税额（"+yjxxVo.getYj_tax()+"元）。";
        }else if(YjzbCodeEnum.Z13003.getCode().equals(zbcode)){
            yjMsg = "对供货企业（"+yjxxVo.getGhfns_no()+yjxxVo.getYj_object()+"）的复函处理意见存在不予退免税情形（"+yjxxVo.getYj_record()+"）,请结合复函情况加强审核，本次申报涉及不含税金额（" +
                    yjxxVo.getYj_amt()+"元）,退税额（"+yjxxVo.getYj_tax()+"元）。";
        }else if(YjzbCodeEnum.Z11701.getCode().equals(zbcode)){
            yjMsg = "该报关单（"+yjxxVo.getYj_object()+"）已申报征税或免税，请核实是否给予退税";
        }else if(YjzbCodeEnum.Z11901.getCode().equals(zbcode)){
            yjMsg = "外贸企业申报数据存在免退税调整申报表";
        }else if(YjzbCodeEnum.Z16101.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getBgdno()+"）申报商品（"+yjxxVo.getCmname()+"）对应计税依据单价（"+yjxxVo.getSpdj()+"）大于"+yjxxVo.getPjdj()+"，请加强审核！";
        }else if(YjzbCodeEnum.Z16102.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getBgdno()+"）申报商品（"+yjxxVo.getCmname()+"）对应计税依据单价（"+yjxxVo.getSpdj()+"）高于全省平均单价（"+yjxxVo.getPjdj()+"），偏差度（"+yjxxVo.getOffset()+"），请加强审核！";
        }else if(YjzbCodeEnum.Z16103.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getBgdno()+"）申报商品（"+yjxxVo.getCmname()+"）对应计税依据单价（"+yjxxVo.getSpdj()+"）高于全省平均单价（"+yjxxVo.getPjdj()+"），偏差度（"+yjxxVo.getOffset()+"），请加强审核！";
        }else if(YjzbCodeEnum.Z16201.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_object()+"）出口日期（"+yjxxVo.getCkrq()+"）开票日期（"+yjxxVo.getKprq()+"）间隔时间较长，请加强审核！";
        }else if(YjzbCodeEnum.Z16202.getCode().equals(zbcode)){
            yjMsg = "该企业近期出口与开票时间间隔预警（"+yjxxVo.getYj_count()+"）次，请关注！";
        }else if(YjzbCodeEnum.Z16301.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_object()+"）每美元利润率（"+yjxxVo.getOffset()+"）低于预警线，请加强审核！";
        }else if(YjzbCodeEnum.Z16401.getCode().equals(zbcode)){
            yjMsg = "该企业上年度三三智检评定为红码企业，请加强审核！";
        }else if(YjzbCodeEnum.Z16402.getCode().equals(zbcode)){
            yjMsg = "该企业存在日常专项监管疑点“出口日期早于供货企业成立日期”未核实，请加强审核！";
        }else if(YjzbCodeEnum.Z16403.getCode().equals(zbcode)){
            yjMsg = "该企业近期存在（"+yjxxVo.getYj_count()+"）笔建议转调查评估排除疑点数据未作调查评估！";
        }else if(YjzbCodeEnum.Z16406.getCode().equals(zbcode)){
            yjMsg = "供货企业（"+yjxxVo.getYj_object()+"）正在函调尚未回函，请加强审核！";
        }else if(YjzbCodeEnum.Z16601.getCode().equals(zbcode)){
            yjMsg = "该企业上年度出口销售额合计（"+yjxxVo.getYj_amt()+"）美元，外管局收汇（"+yjxxVo.getCmcode()+"）美元，人民币收汇折美元（"+yjxxVo.getCmname()+"），收汇比例（"+yjxxVo.getOffset()+"）偏低。";
        }else if(YjzbCodeEnum.Z12101.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_object()+"）出口日期（"+yjxxVo.getKprq()+"），企业未按要求报送国内物流信息，请注意审核！";
        }else if(YjzbCodeEnum.Z12102.getCode().equals(zbcode)){
            yjMsg = "报关单（"+yjxxVo.getYj_object()+"）出口销售额（"+yjxxVo.getYj_amt()+"），企业填报的出口发票号码（"+yjxxVo.getYj_record()+"）不存在，请注意审核！";
        }else if(YjzbCodeEnum.Z12301.getCode().equals(zbcode)){
            yjMsg = "外贸企业11位商品代码（"+yjxxVo.getYj_object()+"）退税率（"+yjxxVo.getFoo()+"）就高申报，申报笔数（"+yjxxVo.getYj_count()+"），退免税额合计：（"+yjxxVo.getYj_tax()+"）元，请加强审核！";
        }else if(YjzbCodeEnum.Z12501.getCode().equals(zbcode)){
            yjMsg = "报关单号（"+yjxxVo.getYj_object()+"）的换汇成本：（"+yjxxVo.getOffset()+"），超过预警上限：（"+yjxxVo.getSpdj()+"），退税额：（"+yjxxVo.getYj_tax()+"）。";
        }else if(YjzbCodeEnum.Z12502.getCode().equals(zbcode)){
            yjMsg = "报关单号（"+yjxxVo.getYj_object()+"）的换汇成本：（"+yjxxVo.getOffset()+"），超过预警下限：（"+yjxxVo.getSpdj()+"），退税额：（"+yjxxVo.getYj_tax()+"）。";
        }else if(StringUtils.isNotBlank(yjxxVo.getYjMsg())){
            return yjxxVo.getYjMsg();
        }


        return yjMsg;
    }
}
