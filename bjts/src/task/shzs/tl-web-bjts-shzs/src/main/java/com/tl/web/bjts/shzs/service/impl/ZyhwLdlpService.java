package com.tl.web.bjts.shzs.service.impl;

import com.tl.web.bjts.shzs.dao.LdlpMapper;
import com.tl.web.bjts.shzs.model.vo.ldlp.*;
import com.tl.web.bjts.shzs.service.LdlpService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ZyhwLdlpService implements LdlpService{

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    private final LdlpMapper ldlpMapper;

    @Autowired
    public ZyhwLdlpService(LdlpMapper ldlpMapper) {
        this.ldlpMapper = ldlpMapper;
    }

    @Override
    public LdlpListVo getLdlpNos(Long sbid) {
        LdlpListVo ldlpListVo = new LdlpListVo();
        ldlpListVo.setLdlpNos(ldlpMapper.getLdlpNos4Zyhw(sbid));
        return ldlpListVo;
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> T getLdlpInfo(LdlpParamVo ldlpParamVo) {
        Long start = System.currentTimeMillis();

        LdlpInfo4ZyhwVo ldlpInfo4ZyhwVo;
        ldlpInfo4ZyhwVo = getZyhwAmt(ldlpParamVo);
        ldlpInfo4ZyhwVo.setSbid(ldlpParamVo.getSbid());
        ldlpInfo4ZyhwVo.setLdlpNo(ldlpParamVo.getLdlpNo());
        ldlpInfo4ZyhwVo.setZyhwmx(getZyhwmx(ldlpParamVo));
        Long end = System.currentTimeMillis();
        LOGGER.info("【getLdlpInfo4Wzf】 cost {} ms", String.valueOf(end - start));
        return (T)ldlpInfo4ZyhwVo;

    }

    private List<ZyhwmxVo> getZyhwmx(LdlpParamVo ldlpParamVo) {
        return ldlpMapper.getZyhwInfo(ldlpParamVo);
    }


    private LdlpInfo4ZyhwVo getZyhwAmt(LdlpParamVo ldlpParamVo) {
        return ldlpMapper.getZyhwAmt(ldlpParamVo);
    }
}
