package com.tl.web.bjts.shzs.service;

import com.tl.web.bjts.shzs.model.vo.ldlp.BgdMainVO;
import com.tl.web.bjts.shzs.model.vo.ldlp.BgdVo;
import com.tl.web.bjts.shzs.model.vo.ldlp.FpxxVo;

public interface LdlpBaseService {

    FpxxVo getZzsFp(String zyfpNo); //根据发票号码获取发票信息

    BgdVo getBgdInfo(String bgdNo,Long sbid); //根据18位的报关单号查询明细

    String getSbywbDm(Long sbid); //根据sbid获取业务类型代码

    BgdMainVO getBgdInfoV2(String bgdNo, String djxh); //根据18位的报关单号查询明细
}
