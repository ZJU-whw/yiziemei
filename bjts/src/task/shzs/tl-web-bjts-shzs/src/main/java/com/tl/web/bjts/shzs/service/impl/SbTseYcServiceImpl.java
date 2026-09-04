package com.tl.web.bjts.shzs.service.impl;

import com.google.gson.Gson;
import com.tl.common.ext.utils.TlDateUtils;
import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.dao.DcbTsycbfslqkLogProfileMapper;
import com.tl.web.bjts.shzs.dao.DcbWceLimitConfigProfileMapper;
import com.tl.web.bjts.shzs.dao.TlMyMapper;
import com.tl.web.bjts.shzs.dao.TlShSbxxHzProfileMapper;
import com.tl.web.bjts.shzs.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.domain.DcbTsycbfslqkLogProfile;
import com.tl.web.bjts.shzs.model.domain.DcbWceLimitConfigProfile;
import com.tl.web.bjts.shzs.model.domain.TlShSbxxHzProfile;
import com.tl.web.bjts.shzs.model.dto.tseyc.TseYcBfLogSaveDTO;
import com.tl.web.bjts.shzs.model.dto.tseyc.TseYcInfoQueryDTO;
import com.tl.web.bjts.shzs.model.vo.TseYcInfoQueryVO;
import com.tl.web.bjts.shzs.model.vo.TseYcQyInfoVO;
import com.tl.web.bjts.shzs.model.vo.sbfile.YwblxxVO;
import com.tl.web.bjts.shzs.service.CommonServiceImpl;
import com.tl.web.bjts.shzs.service.ISbTseYcService;
import com.tl.web.bjts.shzs.utils.ConstUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Optional;

/**
 * @Author whg
 * @create 2024/5/8 17:31
 * @description：
 */
@Service
public class SbTseYcServiceImpl implements ISbTseYcService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SbTseYcServiceImpl.class);

    @Autowired
    private DcbTsycbfslqkLogProfileMapper logMapper;

    @Autowired
    private CommonServiceImpl commonService;

    @Autowired
    private TlShSbxxHzProfileMapper sbSbxxHzMapper;

    @Autowired
    private TlMyMapper tlMyMapper;

    @Autowired
    private DcbWceLimitConfigProfileMapper wceLimitConfigMapper;

    @Autowired
    private AppProperties appProperties;

    /**
     * 保存退税额预测不符的处理日志
     * @param dto
     */
    @Override
    public void saveLog(TseYcBfLogSaveDTO dto) {
        try{
            //获取nsrdzdah
            TlShSbxxHzProfile sbxx = sbSbxxHzMapper.selectByPrimaryKey(dto.getSbid());
            if(sbxx==null){
                LOGGER.error("saveLog-申报信息不存在");
                throw new BusinessException("未查询到申报ID对应申报信息");
            }
            if (!ConstUtil.SBYWB_WMMTS.equals(sbxx.getSbywbDm()) &&
                    !ConstUtil.SBYWB_SCMDT.equals(sbxx.getSbywbDm())){
                return;
            }
            //申报日期
            SimpleDateFormat df = new SimpleDateFormat("yyyyMM");
            String sbrq = df.format(sbxx.getSbrq());
            DcbTsycbfslqkLogProfile profile = new DcbTsycbfslqkLogProfile();
            BeanUtils.copyProperties(dto,profile);
            profile.setId(commonService.getDBPk("DCB_TSYCBFSLQK_LOG"));
            profile.setNsrdzdah(sbxx.getNsrdzdah());
            profile.setCrtime(new Date());
            profile.setNy(sbrq);
            profile.setSbywbDm(sbxx.getSbywbDm());
            if (ConstUtil.SBYWB_WMMTS.equals(sbxx.getSbywbDm())){
                profile.setSbnypc(sbxx.getSssq() + String.format("%03d",sbxx.getSbpc()));
            }else {
                profile.setSbnypc(sbxx.getSssq());
            }
            logMapper.insertSelective(profile);
        }catch (BusinessException e){
            throw e;
        }catch (Exception e){
            LOGGER.error("保存退税额预测不符的处理日志出错：{}",e.getMessage(),e);
            throw new BusinessException("保存退税额预测不符的处理日志出错");
        }
    }

    /**
     * 查询退税额预测信息
     * @param dto
     * @return
     */
    @Override
    public TseYcInfoQueryVO queryInfo(TseYcInfoQueryDTO dto) {
        TseYcInfoQueryVO vo = new TseYcInfoQueryVO();
        try{
            YwblxxVO ywblxxVO = dto.getYwblxxVO();
            if(ywblxxVO ==null){
                LOGGER.error("saveLog-申报信息不存在");
                throw new BusinessException("未查询到对应申报信息");
            }
            LOGGER.info("流程信息:{}",new Gson().toJson(ywblxxVO));
            if (!ConstUtil.SBYWB_WMMTS_LCDM.equals(ywblxxVO.getLcswsxDm()) &&
                    !ConstUtil.SBYWB_SCMDT_LCDM.equals(ywblxxVO.getLcswsxDm())){
                vo.setYwFlag(false);
                return vo;
            }else {
                vo.setYwFlag(true);
            }

            //查询企业的djxh
            Long nsrdzdahL = getNsrdzdahByNsrsbh(ywblxxVO.getNsrsbh());
            if(nsrdzdahL==null){
                throw new BusinessException("企业信息不存在");
            }
            BigDecimal nsrdzdah = BigDecimal.valueOf(nsrdzdahL);
            TseYcQyInfoVO qyInfo = tlMyMapper.queryQyDjxh(nsrdzdah);
            LOGGER.info("企业信息:{}",new Gson().toJson(qyInfo));
            //查询企业是否是重点企业
            Boolean zdFlag = tlMyMapper.checkZdQy(nsrdzdah);
            LOGGER.info("是否重点企业标志:{}",zdFlag);
            vo.setZdFlag(zdFlag);
            //非重点企业不做预测数和申报数的相符判定
            if (zdFlag){
                //查询预测退税额
                BigDecimal ycTse = tlMyMapper.queryYcTse(nsrdzdah,ywblxxVO.getSssq());
                if (null == ycTse){
                    vo.setXfFlag(false);
                }
                vo.setYctse(ycTse);

                //查询申报退税额
                BigDecimal sbTse;
                try {
                    //切换金三系统数据源
                    MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
                    if(ConstUtil.SBYWB_SCMDT_LCDM.equals(ywblxxVO.getLcswsxDm())){
                        sbTse = tlMyMapper.querySbTseSc(dto.getLcslid());
                    }else {
                        sbTse = tlMyMapper.querySbTseWm(dto.getLcslid());
                    }
                    vo.setSbtse(sbTse);
                }finally {
                    MultipleDataSourceHolder.clearDBType();
                }
                if(sbTse==null){
                    throw new BusinessException("申报退税额信息异常！");
                }
                //查询误差额的上限与下限
                BigDecimal wceUp = appProperties.getWceUp();
                BigDecimal wceDown = appProperties.getWceDown();
                DcbWceLimitConfigProfile profile = wceLimitConfigMapper.selectByPrimaryKey(qyInfo.getSwjgDm());
                if (null != profile){
                    wceUp = profile.getWceUp();
                    wceDown = profile.getWceDown();
                }
                //查询当月累计退税额
                MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
                BigDecimal dyljsbtse;
                //起始时间
                String firstDay = getFirstDayOfMonth(TlDateUtils.format(new Date(),"yyyyMM"));
                //结束时间
                String lastDay = getLastDayOfMonth(TlDateUtils.format(new Date(),"yyyyMM"));

                String sbnypc =ywblxxVO.getSssq() + ywblxxVO.getSbpc();
                if (ConstUtil.SBYWB_SCMDT_LCDM.equals(ywblxxVO.getLcswsxDm())){
                    dyljsbtse = tlMyMapper.queryQySbSc(qyInfo.getDjxh(),firstDay,lastDay,sbnypc);
                }else {
                    dyljsbtse = tlMyMapper.queryQySbWm(qyInfo.getDjxh(),firstDay,lastDay,sbnypc);
                }
                vo.setDyljsbtse(dyljsbtse);

                LOGGER.info("TseYcInfoQueryVO DATA:{}",new Gson().toJson(vo));
                //本月申报退税额
                BigDecimal bySbTse;
                //本批次申报退税额加上本月累计申报退税额
                bySbTse = sbTse.add(Optional.ofNullable(dyljsbtse).orElse(BigDecimal.ZERO));
                if (null != ycTse){
                    //计算预测是否相符
                    BigDecimal wce = bySbTse.subtract(ycTse);
                    if (wce.compareTo(wceDown) >= 0 && wce.compareTo(wceUp) <= 0){
                        vo.setXfFlag(true);
                    }else {
                        vo.setXfFlag(false);
                    }
                }
                //拼接显示信息1
                StringBuilder sb = new StringBuilder();
                sb.append("申报" + bySbTse + "，");
                if (vo.getXfFlag()){
                    sb.append("相符");
                }else {
                    sb.append("不符");
                }
                vo.setMsg1(sb.toString());
                //拼接显示信息2
                vo.setMsg2("本批次申报" + sbTse + "，本月其他批次申报" + dyljsbtse);
            }else {
                vo.setXfFlag(true);
                vo.setMsg1("纳税人非退税预测重点企业");
            }
        }catch (BusinessException e){
            LOGGER.info("业务异常："+e.getMsg());
            throw e;
        }catch (Exception e){
            LOGGER.error("查询退税额预测信息出错:",e);
            throw new BusinessException("查询退税额预测信息出错");
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }
        return vo;
    }

    private Long  getNsrdzdahByNsrsbh(String nsrsbh){
        return  tlMyMapper.queryNsrdzdahByNsrsbh(nsrsbh);
    }

    /**
     * 获取统计年月的第一天
     * @param tjny
     * @return
     */
    private String getFirstDayOfMonth(String tjny){
        LocalDate localDate = LocalDate.of(Integer.valueOf(tjny.substring(0,4)),Integer.valueOf(tjny.substring(4)),1);
        DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return df.format(localDate);
    }

    /**
     * 获取统计年月（下个月）的第一天
     * @param tjny
     * @return
     */
    private String getLastDayOfMonth(String tjny){
        LocalDate localDate = LocalDate.of(Integer.valueOf(tjny.substring(0,4)),Integer.valueOf(tjny.substring(4)),1);
        localDate = LocalDate.of(localDate.getYear(),localDate.getMonthValue(),localDate.lengthOfMonth());
        DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return df.format(localDate);
    }
}
