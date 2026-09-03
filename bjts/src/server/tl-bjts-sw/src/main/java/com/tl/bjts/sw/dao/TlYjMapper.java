package com.tl.bjts.sw.dao;


import com.tl.bjts.sw.model.dto.YjFxdjszDTO;
import com.tl.bjts.sw.model.dto.YjGbcodeDTO;
import com.tl.bjts.sw.model.dto.YjMmyllDTO;
import com.tl.bjts.sw.model.dto.YjWmllDTO;
import com.tl.bjts.sw.model.dto.YjHgcodeDTO;
import com.tl.bjts.sw.model.dto.YjHghydDTO;
import com.tl.bjts.sw.model.dto.YjPfxxListDTO;
import com.tl.bjts.sw.model.dto.YjZhcxListDTO;
import com.tl.bjts.sw.model.dto.CkllfxListDTO;
import com.tl.bjts.sw.model.dto.CkllfxEditDTO;
import com.tl.bjts.sw.model.dto.YjWmllFxdjtzDTO;
import com.tl.bjts.sw.model.vo.*;
import com.tl.bjts.sw.model.domain.YjDicModel;
import com.tl.bjts.sw.model.dto.YjBmdDTO;
import com.tl.bjts.sw.model.vo.yjzb.ZbSelectVO;
import org.apache.ibatis.annotations.Param;
import com.tl.bjts.sw.model.dto.QspjdjDTO;
import com.tl.bjts.sw.model.bo.CkllfxQrDataBO;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;


@Repository
public interface TlYjMapper {

    //获取企业基础信息和评分信息
    YjPfxxVO getYjPfxx(String nsrsbh);

    //获取企业评分列表
    List<YjPfxxListVO> getYjPfxxList(YjPfxxListDTO dto);

    //获取企业综合查询列表
    List<YjZhcxListVO> getYjZhcxList(YjZhcxListDTO dto);

    //获取企业综合查询的汇总信息
    Map getYjZhcxSum(YjZhcxListDTO dto);

    List<YjDicModel> queryYjcodes(@Param("swjgdm") String swjgDm, @Param("qxdm") String qxdm);

    List<YjDicYjzbModelVo> queryYjzbs(@Param("qxdm")String qxdm,@Param("swjgdm")String swjgDm, @Param("yjcode") String yjcode, @Param("zbcode") String zbcode);

    List<YjDicYjzbModelVo> queryYjzbsQsmr( @Param("yjcode") String yjcode);

    void deleteYjzbSwjg(@Param("swjgdm") String swjgdm,@Param("zbcode") String zbcode);

    List<YjCsBmdModelVo> queryYjBmds(YjBmdDTO dto);

    BigDecimal queryQyxx(String qybs);

    List<PjdjVo> cksppjj4Sc(QspjdjDTO dto);

    List<PjdjVo> cksppjj4Wm(QspjdjDTO dto);

    List<YjzbcxVo> selectYjcodeAll(@Param("qxdm") String qxdm, @Param("swjgdm") String swjgdm);

    List<ZbnameVo> getYjzb(String yjcode);

    String queryQymc(String qybs);

    void updateResetSocre(@Param("nsrdzdah") BigDecimal nsrdzdah, @Param("clr") String clr);

    List<ZbSelectVO> getZbSelect(@Param("yjcode") String yjcode);

    /**
     * 查询默认指标，适用市局和县局
     * @param yjcode
     * @param swjgDm
     * @return
     */
    List<YjDicYjzbModelVo> queryYjzbsQsmr4Sjxj(@Param("yjcode") String yjcode, @Param("swjgDm") String swjgDm);

    /**
     * 海关货源地区域对照表查询
     * @param dto 查询条件
     * @return 海关货源地列表
     */
    List<YjHghydVO> queryYjHghydList(YjHghydDTO dto);

    /**
     * 海关口岸区域对照表查询
     * @param dto 查询条件
     * @return 海关口岸列表
     */
    List<YjHgcodeVO> queryYjHgcodeList(YjHgcodeDTO dto);

    /**
     * 最终目的国区域对照表查询
     * @param dto 查询条件
     * @return 国别列表
     */
    List<YjGbcodeVO> queryYjGbcodeList(YjGbcodeDTO dto);

    /**
     * 出口链路风险等级参数表查询
     * @param dto 查询条件
     * @return 风险等级列表
     */
    List<YjFxdjszVO> queryYjFxdjszList(YjFxdjszDTO dto);

    /**
     * 出口链路异常分析模型（外贸）查询
     * @param dto 查询条件
     * @return 链路列表
     */
    List<YjWmllVO> queryYjWmllList(YjWmllDTO dto);

    /**
     * 每美元利润率分析结果查询
     * @param dto 查询条件
     * @return 利润率列表
     */
    List<YjMmyllVO> queryYjMmyllList(YjMmyllDTO dto);

    /**
     * 出口业务物流链路综合管理查询
     * @param dto 查询条件
     * @return 链路列表
     */
    List<CkllfxListVO> queryCkllfxList(CkllfxListDTO dto);

    /**
     * 保存出口链路风险等级调整（外贸）
     * @param dto 调整信息
     */
    void saveYjWmllFxdjtz(YjWmllFxdjtzDTO dto);

    /**
     * 查询行政区划表
     * @param dto
     * @return
     */
    List<YjHghydVO> selectYjXzqhList(YjHghydDTO dto);

    /**
     * 查询行政区划字典列表（下拉用）
     * @return 区域代码和名称列表
     */
    List<YjHghydVO> queryYjXzqhDicList();

    /**
     * 查询目的国区域字典列表（下拉用）
     * @return 国家区域代码和名称列表
     */
    List<YjGbcodeVO> queryYjGbcodeDicList();

    // ==================== 出口业务物流链路数据修改 ====================

    /**
     * 更新出口业务物流链路数据
     * @param dto 修改参数
     */
    void updateCkllfxData(CkllfxEditDTO dto);

    /**
     * 统计物流链路记录数量（校验是否存在）
     * @param djxh 金三企业登记序号
     * @param bgdhgbh 出口报关单号
     * @return 记录数量
     */
    int countCkllfxRecord(@Param("djxh") BigDecimal djxh, @Param("bgdhgbh") String bgdhgbh, @Param("qxSwjgDm") String qxSwjgDm);

    /**
     * 查询物流链路二维码参数数据
     * @param djxh 金三企业登记序号
     * @param bgdhgbh 出口报关单号
     * @param qxSwjgDm 权限税务机关代码
     * @return 二维码参数数据
     */
    CkllfxQrDataBO queryCkllfxQrData(@Param("djxh") BigDecimal djxh, @Param("bgdhgbh") String bgdhgbh, @Param("qxSwjgDm") String qxSwjgDm);
}
