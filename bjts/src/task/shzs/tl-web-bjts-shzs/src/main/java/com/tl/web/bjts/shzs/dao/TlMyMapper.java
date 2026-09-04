package com.tl.web.bjts.shzs.dao;

import com.tl.web.bjts.shzs.model.YjzbcxVo;
import com.tl.web.bjts.shzs.model.ZbnameVo;
import com.tl.web.bjts.shzs.model.domain.TbDtbsj;
import com.tl.web.bjts.shzs.model.dto.yjxx.YjxxCreateParam;
import com.tl.web.bjts.shzs.model.vo.*;
import com.tl.web.bjts.shzs.model.vo.sbfile.YwblxxVO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Created by Neo Lin on 2017/6/20.
 */
@Repository
public interface TlMyMapper {

    int writeBackFeedbackInfo(FkxxWbVO fkxxWbVO); //回写反馈信息

    List<YjxxVO> getYjxxs(Long sbid);   //获取预警信息

    List<YjxxExcelVO> getYjxxsForExcel(Long sbid); //导出预警信息

    Integer countYjxxs(Long sbid);  //获取预警信息数量

    Long getSbidByLcslid(String lcslid); //根据流程id获取sbid

    int insertTb(TbDtbsj ysfkdtbsj);  //失败时写同步表

    JdfwmsVo getJdfwms(JdfwmsVo jdfwmsVo);  //获取接单范围描述

    String getYjClose(String swjgDm);   //查询当前税务机关是否显示预警信息

    List<YdxxVo> getYdxxs(String lcslid);   //根据申报id获取疑点信息

    SimpleSbxxVo getSbxxInfo(Long id); //根据sbid获取企业名称，所属时期，批次

    String getSbywbDm(Long id);  //获取申报业务表代码

    int updateClMsg(Map paramp);

    int updateSbztTO2A(Long sbid);

    /**
     * 绑定流程的前置校验
     * @param sbid 申报id
     * @param qyhgdm 企业海关代码
     * @param lcswsxDm 流程税务事项代码
     * @return
     */
    int checkBindLcslidBefore(@Param("sbid") Long sbid,@Param("qyhgdm") String qyhgdm,@Param("lcswsxdm") String lcswsxDm);

    /**
     * 根据业务办理事项（登记序号、申报业务表代码、所属时期、申报批次）获取sbid
     * @param ywblxxVO 登记序号、申报业务表代码、所属时期、申报批次
     * @return 申报id
     */
    Long getSbidByYwblxx(YwblxxVO ywblxxVO);

    /**
     * 根据申报id获取登记序号
     * @param sbid 申报id
     * @return 登记序号
     */
    String getDjxhBySbid(Long sbid);

    /**
     * 生成预警信息
     * @param dto
     */
    void yjxxCreate(YjxxCreateParam dto);

    /**
     * 查询企业是否为重点企业
     * @param nsrdzdah
     * @return
     */
    Boolean checkZdQy(@Param("nsrdzdah") BigDecimal nsrdzdah);

    /**
     * 查询预测退税额
     * @param nsrdzdah
     * @param sssq
     * @return
     */
    BigDecimal queryYcTse(@Param("nsrdzdah") BigDecimal nsrdzdah,
                          @Param("sssq") String sssq);

    /**
     * 统计生产企业申报退税额
     * @param djxh
     * @param firstDay
     * @param lastDay
     * @param sbnypc
     * @return
     */
    BigDecimal queryQySbSc(@Param("djxh") String djxh,
                           @Param("firstDay") String firstDay,
                           @Param("lastDay") String lastDay, @Param("sbnypc") String sbnypc);

    /**
     * 统计外贸企业申报退税额
     * @param djxh
     * @param firstDay
     * @param lastDay
     * @param sbnypc
     * @return
     */
    BigDecimal queryQySbWm(@Param("djxh") String djxh,
                           @Param("firstDay") String firstDay,
                           @Param("lastDay") String lastDay, @Param("sbnypc") String sbnypc);

    /**
     * 查询企业的登记序号
     * @param nsrdzdah
     * @return
     */
    TseYcQyInfoVO queryQyDjxh(@Param("nsrdzdah") BigDecimal nsrdzdah);

    /**
     * 查询本批次申报退税额（生产）
     * @param lcslid
     * @return
     */
    BigDecimal querySbTseSc(@Param("lcslid") String lcslid);

    /**
     * 查询本批次申报退税额（外贸）
     * @param lcslid
     * @return
     */
    BigDecimal querySbTseWm(@Param("lcslid") String lcslid);

    /**
     * 查询纳税人电子档案号
     * @param nsrsbh
     * @return
     */
    Long queryNsrdzdahByNsrsbh(@Param("nsrsbh") String nsrsbh);

    SbxxViewVo selectYjxxByLcslid(@Param("lcslid") String lcslid);

    /**
     * 查询预警代码列表
     * @return
     */
    List<YjzbcxVo> selectYjcodeAll();

    List<ZbnameVo> getYjzb(String yjcode);

    BigDecimal selectNsrdzdahByDjxh(@Param("djxh") BigDecimal djxh);

    String selectMainLcslid(@Param("lcslid") String lcslid);
}
