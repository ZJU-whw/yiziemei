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
public class ScLdlpService implements LdlpService {

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    private final LdlpMapper ldlpMapper;

    @Autowired
    public ScLdlpService(LdlpMapper ldlpMapper) {
        this.ldlpMapper = ldlpMapper;
    }

    @Override
    public LdlpListVo getLdlpNos(Long sbid) {
        LdlpListVo ldlpListVo = new LdlpListVo();
        ldlpListVo.setLdlpNos(ldlpMapper.getLdlpNos4Sc(sbid));
        return ldlpListVo;
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> T getLdlpInfo(LdlpParamVo ldlpParamVo) {
        Long start = System.currentTimeMillis();

        LdlpInfo4ScVo ldlpInfo4ScVo;
        ldlpInfo4ScVo = getMdtsckAmt(ldlpParamVo);
        ldlpInfo4ScVo.setSbid(ldlpParamVo.getSbid());
        ldlpInfo4ScVo.setLdlpNo(ldlpParamVo.getLdlpNo());
        ldlpInfo4ScVo.setMdtscks(getMdtscks(ldlpParamVo));
        Long end = System.currentTimeMillis();
        LOGGER.info("【getLdlpInfo4Sc】 cost {} ms", String.valueOf(end - start));
        return (T)ldlpInfo4ScVo;
    }


    private List<MdtsckVo> getMdtscks(LdlpParamVo ldlpParamVo) {
        return ldlpMapper.getMdtsInfo(ldlpParamVo);
    }


    private LdlpInfo4ScVo getMdtsckAmt(LdlpParamVo ldlpParamVo) {
        return ldlpMapper.getMdtsckAmt(ldlpParamVo);
    }

}
