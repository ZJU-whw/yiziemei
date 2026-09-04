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
public class WzfLdlpService implements LdlpService {

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    private final LdlpMapper ldlpMapper;


    @Autowired
    public WzfLdlpService(LdlpMapper ldlpMapper) {
        this.ldlpMapper = ldlpMapper;
    }


    @Override
    public LdlpListVo getLdlpNos(Long sbid) {
        LdlpListVo ldlpListVo = new LdlpListVo();
        ldlpListVo.setLdlpNos(ldlpMapper.getLdlpNos4Wzf(sbid));
        return ldlpListVo;
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> T getLdlpInfo(LdlpParamVo ldlpParamVo) {

        Long start = System.currentTimeMillis();

        LdlpInfo4WzfVo ldlpInfo4WzfVo;
        ldlpInfo4WzfVo = getDbtsAmt(ldlpParamVo);
        ldlpInfo4WzfVo.setDbtsmx(getDbtsmx(ldlpParamVo));
        ldlpInfo4WzfVo.setSbid(ldlpParamVo.getSbid());
        ldlpInfo4WzfVo.setLdlpNo(ldlpParamVo.getLdlpNo());
        Long end = System.currentTimeMillis();
        LOGGER.info("【getLdlpInfo4Wzf】 cost {} ms", String.valueOf(end - start));
        return (T)ldlpInfo4WzfVo;
    }

    private List<DbtsVo> getDbtsmx(LdlpParamVo ldlpParamVo) {
        return ldlpMapper.getDbtsInfo(ldlpParamVo);
    }


    private LdlpInfo4WzfVo getDbtsAmt(LdlpParamVo ldlpParamVo) {
        return ldlpMapper.getDbtsAmt(ldlpParamVo);
    }
}
