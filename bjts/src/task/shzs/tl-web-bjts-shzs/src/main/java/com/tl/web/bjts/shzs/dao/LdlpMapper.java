package com.tl.web.bjts.shzs.dao;

import com.tl.web.bjts.shzs.model.vo.ldlp.*;

import java.util.List;

public interface LdlpMapper {

    List<String> getLdlpNos4Wm(Long sbid); //获取某笔申报id对应的所有关联号  外贸

    List<TsjhVo> getTsjhInfo(LdlpParamVo ldlpParamVo);   //根据sbid和关联号获取进货明细 外贸

    TsjhAmtVo getTsjhAmt(LdlpParamVo ldlpParamVo);   //查询进货明细合计项 外贸

    List<TsckVo> getTsckInfo(LdlpParamVo ldlpParamVo);     //根据sbid和关联号获取出口明细 外贸

    TsckAmtVo getTsckAmt(LdlpParamVo ldlpParamVo); //查询出口明细合计项 外贸

    List<String> getLdlpNos4Sc(Long sbid); //获取某笔申报id对应的所有关联号  生产

    List<String> getLdlpNos4Wzf(Long sbid); //获取某笔申报id对应的所有关联号  外综服代办退税

    List<String> getLdlpNos4Zyhw(Long sbid); //获取某笔申报id对应的所有关联号  购进自用货物


    List<MdtsckVo> getMdtsInfo(LdlpParamVo ldlpParamVo);     //查询生产出口明细

    LdlpInfo4ScVo getMdtsckAmt(LdlpParamVo ldlpParamVo); //查询出口明细合计项 生产


    List<DbtsVo> getDbtsInfo(LdlpParamVo ldlpParamVo);   //查询外综服代办退税明细

    LdlpInfo4WzfVo getDbtsAmt(LdlpParamVo ldlpParamVo);   //查询进货明细合计项  购进自用货物


    List<ZyhwmxVo> getZyhwInfo(LdlpParamVo ldlpParamVo);   //根据sbid和关联号获取进货明细  购进自用货物

    LdlpInfo4ZyhwVo getZyhwAmt(LdlpParamVo ldlpParamVo);   //查询进货明细合计项  购进自用货物


}
