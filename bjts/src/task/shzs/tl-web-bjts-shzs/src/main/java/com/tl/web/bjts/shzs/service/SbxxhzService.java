package com.tl.web.bjts.shzs.service;

import com.tl.web.bjts.shzs.model.domain.RulesMainProfile;
import com.tl.web.bjts.shzs.model.domain.TlRwTxb;
import com.tl.web.bjts.shzs.model.domain.TlSbxxProfile;
import com.tl.web.bjts.shzs.model.dto.BaseIdsDTO;
import com.tl.web.bjts.shzs.model.dto.yjxx.YjxxCreateDTO;
import com.tl.web.bjts.shzs.model.dto.yjxx.YjxxUpdateDTO;
import com.tl.web.bjts.shzs.model.dto.sbxx.SbMxbBaseDTO;
import com.tl.web.bjts.shzs.model.vo.*;
import com.tl.web.bjts.shzs.model.vo.sbxx.*;

import java.math.BigDecimal;
import java.util.*;

/**
 * Created by Mamf on 2017/6/20.
 */


public interface SbxxhzService {

    List<Map<String,Object>> getGroupBySbxxList(String czryDm);//获取申报任务汇总信息

    //申报列表分页查询
    Map<String,Object> getSblbxxByPage(String czryDm,String sbywDm,int offset,int size,String type,String cons,String isZzsbb,String orderSql,String flglcd);

    //申报信息明细查询
    List<TlSbxxProfile> getSbxxDetails(Long sbid);

    SbxxViewVo getSbxxDetails2(String lcslid);

    List<RwtxVo> getRwtxList(Map<String,String> paramMap);//根据操作人员代码获取任务提醒信息

    int getRwtxListCount(Map<String,String> paramMap);

    int addRwtxb(TlRwTxb rwTxb);

    BigDecimal getNsrdzdah(Long sbid);

    JdfwmsVo getJdfwms(String czryDm);

    // 自动接单功能
    int updateSbztTO2A(BaseIdsDTO dto);

    /**
     *  生产免抵退税申报明细表查询
     * @param dto  SbMxbBaseDTO
     * @return List<SbMdtsMxbVO>
     */
    List<SbMdtsMxbVO> listScmdtsMxb(SbMxbBaseDTO dto);

    /**
     *  生产免抵退税申报明细表查询-合计
     * @param dto  SbMxbBaseDTO
     * @return SbMdtsMxbSumVO
     */
    SbMdtsMxbSumVO sumScmdtsMxb(SbMxbBaseDTO dto);

    /**
     *  外贸免退税申报明细表数据查询
     * @param dto SbMxbBaseDTO
     * @return List<SbMtsCkmxVO>
     */
    List listWmmtsMxb(SbMxbBaseDTO dto);

    /**
     *  生产免抵退税申报明细表查询-合计
     * @param dto  SbMxbBaseDTO
     * @return SbMtsMxbSumVO
     */
    SbMtsMxbSumVO sumWmmtsMxb(SbMxbBaseDTO dto);

    /**
     *  外综服代办退税明细表数据查询
     * @param dto SbMxbBaseDTO
     * @return List<SbWzfdbtsMxbVO>
     */
    List<SbWzfdbtsMxbVO> listWzfdbts(SbMxbBaseDTO dto);

    /**
     * 外综服代办退税明细表数据查询（合计）
     * @param dto SbMxbBaseDTO
     * @return  SbWzfdbtsMxbSumVO
     */
    SbWzfdbtsMxbSumVO sumWzfdbtsMxb(SbMxbBaseDTO dto);

    /**
     *  购进自用货物明细表数据查询
     * @param dto SbMxbBaseDTO
     * @return List<SbGjzyhwMxbVO>
     */
    List<SbGjzyhwMxbVO> listGjzyhwMxb(SbMxbBaseDTO dto);

    /**
     * 购进自用货物明细表数据查询（合计）
     * @param dto SbMxbBaseDTO
     * @return
     */
    SbGjzyhwMxbSumVO sumGjzyhwMxb(SbMxbBaseDTO dto);

    /**
     * 重要事项提醒
     *  包括审单核查在办任务、出口退税岗位在办、待复函的核实函（待定）
     * @return
     */
    ItemNoticeVO itemsNotice();

    /**
     *  获取出口口岸信息
     * @param kaxx 口岸信息(查询条件)
     * @return
     */
    List<KaxxDictVO> listKaxxDict(String kaxx);

    /**
     * 生成事中指标预警信息
     * @param dto
     * @return
     */
    YjxxCreateVO yjxxCreate(YjxxCreateDTO dto);

    /**
     * 更新事中指标预警信息
     * @param dto
     */
    void yjxxUpdate(YjxxUpdateDTO dto);

    /**
     * 获取所有配置信息
     * @return
     */
    List<RulesMainProfile> getAllKeyList();
}
