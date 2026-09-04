package com.tl.web.bjts.shzs.service;

import com.tl.web.bjts.shzs.model.vo.ldlp.LdlpListVo;
import com.tl.web.bjts.shzs.model.vo.ldlp.LdlpParamVo;

public interface LdlpService{

    LdlpListVo getLdlpNos(Long sbid);  //根据sbid获取关联号列表

    <T> T getLdlpInfo(LdlpParamVo ldlpParamVo); //获取关联明细数据

}
