package com.tl.web.bjts.shzs.service.impl;

import com.tl.web.bjts.shzs.dao.LdlpMapper;
import com.tl.web.bjts.shzs.model.vo.ldlp.*;
import com.tl.web.bjts.shzs.service.LdlpService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("wmLdlpService")
public class WmLdlpService implements LdlpService {

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    private final LdlpMapper ldlpMapper;


    @Autowired
    public WmLdlpService(LdlpMapper ldlpMapper) {
        this.ldlpMapper = ldlpMapper;
    }

    @Override
    public LdlpListVo getLdlpNos(Long sbid) {
        LdlpListVo ldlpListVo = new LdlpListVo();
        ldlpListVo.setLdlpNos(ldlpMapper.getLdlpNos4Wm(sbid));
        return ldlpListVo;
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> T getLdlpInfo(LdlpParamVo ldlpParamVo) {
        Long start = System.currentTimeMillis();
        TsckAmtVo tsckAmtVo = getTsckAmt(ldlpParamVo);
        TsjhAmtVo tsjhAmtVo = getTsjhAmt(ldlpParamVo);
        LdlpInfoVo ldlpInfoVo = new LdlpInfoVo();
        BeanUtils.copyProperties(tsckAmtVo, ldlpInfoVo);
        BeanUtils.copyProperties(tsjhAmtVo, ldlpInfoVo);
        ldlpInfoVo.setTscks(getTscks(ldlpParamVo));
        ldlpInfoVo.setTsjhs(getTsjhs(ldlpParamVo));
        ldlpInfoVo.setSbid(ldlpParamVo.getSbid());
        ldlpInfoVo.setLdlpNo(ldlpParamVo.getLdlpNo());
        Long end = System.currentTimeMillis();
        LOGGER.info("【getLdlpInfoWm】 cost {} ms", String.valueOf(end - start));
        return (T)ldlpInfoVo;
    }


    private List<TsckVo> getTscks(LdlpParamVo ldlpParamVo) {
        return ldlpMapper.getTsckInfo(ldlpParamVo);
    }


    private List<TsjhVo> getTsjhs(LdlpParamVo ldlpParamVo) {
        return ldlpMapper.getTsjhInfo(ldlpParamVo);
    }


    private TsckAmtVo getTsckAmt(LdlpParamVo ldlpParamVo) {
        return ldlpMapper.getTsckAmt(ldlpParamVo);
    }


    private TsjhAmtVo getTsjhAmt(LdlpParamVo ldlpParamVo) {
        return ldlpMapper.getTsjhAmt(ldlpParamVo);
    }
}
