package com.tl.web.bjts.yj.dao;

import com.tl.web.bjts.yj.model.TssbBankVo;
import com.tl.web.bjts.yj.model.YjPramDTO;
import com.tl.web.bjts.yj.model.YjProcParamModel;
import com.tl.web.bjts.yj.model.domain.DmGbcodeModel;
import com.tl.web.bjts.yj.model.domain.DmXzqhModel;
import com.tl.web.bjts.yj.model.domain.HgcodeXzqhModel;
import com.tl.web.bjts.yj.model.vo.*;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by Mamf on 2017/6/20.
 */
public interface YjMapper {




    /**
     * 查询审核系统的退税账户信息
     * @param nsrdjno
     * @return
     */
    TssbBankVo selectTsshBank4Yj(String nsrdjno);

    /**
     * 查询金山系统的退税账户信息
     * @param nsrdjno
     * @return
     */
    TssbBankVo selectJsxtBank4Yj(String nsrdjno);


    String selectJsxtQyfr(String nsrdjno);

    List<YjBmdVo> selectYjBmd(@Param("nsrdzdah")Long nsrdzdah, @Param("swjgdm")String swjgdm);

    List<DmYjxxVo> selectSwjgYjcodeDic(String swjgdm);

    List<YjzbItemVo> selectYjzbItem(String swjgdm);

    List<YjxxNewVo> selectSpdmSc10101(YjPramDTO pramDTO);

    List<YjxxNewVo> selectSpdmWm10101(YjPramDTO pramDTO);

    List<YjxxNewVo> selectSpdmSc10102(YjPramDTO pramDTO);

    List<YjxxNewVo> selectSpdmWm10102(YjPramDTO pramDTO);

    List<YjxxNewVo> selectGhqy10201(YjPramDTO pramDTO);

    List<YjxxNewVo> selectGhqy10202(YjPramDTO pramDTO);

    List<YjxxNewVo> selectYcghs10701(YjPramDTO pramDTO);

    List<YjxxNewVo> selectYcghs10702(YjPramDTO pramDTO);
    
    List<YjxxNewVo> selectYcghs10703(YjPramDTO pramDTO);

    List<YjxxNewVo> selectGfxspSc10801(YjPramDTO pramDTO);

    List<YjxxNewVo> selectGfxspWm10801(YjPramDTO pramDTO);

    List<YjxxNewVo> selectGfxspSc10802(YjPramDTO pramDTO);

    List<YjxxNewVo> selectGfxspWm10802(YjPramDTO pramDTO);

    List<YjxxNewVo> selectMgCkka11002Sc(YjPramDTO pramDTO);

    List<YjxxNewVo> selectMgCkka11001Sc(YjPramDTO pramDTO);

    List<YjxxNewVo> selectMgCkka10902Wm(YjPramDTO pramDTO);

    List<YjxxNewVo> selectMgCkka10901Wm(YjPramDTO pramDTO);

    List<YjxxNewVo> selectGhqyhd11102(YjPramDTO pramDTO);

    List<YjxxNewVo> selectGhqyhd11101(YjPramDTO pramDTO);

    List<YjxxNewVo> selectGhqyhd11103(YjPramDTO pramDTO);

    List<YjxxNewVo> selectSbckka11201Sc(YjPramDTO pramDTO);

    List<YjxxNewVo> selectSbckka11201Wm(YjPramDTO pramDTO);

    List<YjxxNewVo> selectYcdj11301Sc(YjPramDTO pramDTO);

    List<YjxxNewVo> selectYcdj11302Wm(YjPramDTO pramDTO);

    List<YjxxNewVo> selectBghfsSc11501(YjPramDTO pramDTO);

    List<YjxxNewVo> selectBghfsWm11501(YjPramDTO pramDTO);

    List<YjxxNewVo> selectHydbyz10401(YjPramDTO pramDTO);

    List<YjxxNewVo> selectSpmcByz10501(YjPramDTO pramDTO);

    List<YjxxNewVo> selectHegs20201Sc(YjPramDTO pramDTO);

    List<YjxxNewVo> selectHegs20201Wm(YjPramDTO pramDTO);

    List<YjxxNewVo> selectHegs20201Wzf(YjPramDTO pramDTO);

    String selectDjxhByNsrsbh(String nsrsbh);

    int selectFirstTsck10301Sc(@Param("lcslid") String lcslid);

    int selectFirstTsck10301Wm(@Param("lcslid") String lcslid);

    List<YjxxNewVo> selectGhqy10203(YjPramDTO pramDTO);

    BigDecimal selectSbmtse(@Param("sbid") Long sbid);

    List<YjxxNewVo> selectGhqyhd130(YjPramDTO pramDTO);

    String selectMaxYjSbsj();

    List<FetchTaskVo> selectJsxtTaskList(@Param("sbsj") Date sbsj);

    BigDecimal selectNsrdzdahByDjxh(@Param("djxh") BigDecimal djxh);

    int selectDzabWwc11601(@Param("djxh") String djxh);

    List<Map<String, String>> selectMtsmxByLcslid(YjPramDTO pramDTO);

    int selectCqwsbConfirmData(@Param("djxh") String djxh, @Param("ckbgdh") String ckbgdh);

    List<Map<String, String>> selectMdtmxByLcslid(YjPramDTO pramDTO);

    void callProcedureCheckXblqy(YjProcParamModel yjParamSet);

    int selectSbhTzb11901Wm(@Param("lcslid") String lcslid);

    List<YwbgCkeVo> selectYwBghSc12001(YjPramDTO pramDTO);

    List<YwbgCkeVo> selectYwBghWm12001(YjPramDTO pramDTO);

    String selectCheckTsehj(@Param("djxh") String djxh, @Param("pv1") BigDecimal pv1);

    List<CustomsDeclarationVo> selectDeclarationVos(@Param("lcslid") String lcslid);

    List<DmXzqhModel> selectDmXzqhModels();

    List<HgcodeXzqhModel> selectHgcodeXzqhModels();

    String selectGysxzdm(@Param("jhpzh") String jhpzh);

    List<DmGbcodeModel> selectGbcodeXzqhModels();

    Integer checkRiskLink(@Param("swjgdm") String swjgdm, @Param("ysfsDm") String ysfsDm, @Param("spdlDm") String spdlDm,
                          @Param("gysQycode") String gysQycode, @Param("hgkaQycode") String hgkaQycode, @Param("mdgQycode") String mdgQycode);

    /**
     * 查询出口企业近12个月退税额合计
     * @param djxh 登记序号
     * @param pv1 参数阈值（判断是否大于等于该阈值）
     * @return 退税额合计
     */
    String selectCheckTsehj161(@Param("djxh") String djxh, @Param("pv1") BigDecimal pv1);

    /**
     * 生产企业出口商品单价信息
     * @param lcslid 流程受理ID
     * @return 商品单价信息
     */
    List<YjxxNewVo> selectScSpdj161(@Param("lcslid") String lcslid);

    /**
     * 外贸企业进货单价信息（生产企业不需要）
     * @param pramDTO 查询参数
     * @return 进货单价信息
     */
    List<YjxxNewVo> selectWmSpdj161(YjPramDTO pramDTO);

    /**
     * 查询外贸企业全省平均单价
     * @param spdm 商品代码（取前8位）
     * @return 全省平均单价
     */
    BigDecimal selectQspjDjWm(@Param("spdm") String spdm);

    /**
     * 查询生产企业全省平均单价
     * @param spdm 商品代码（取前8位）
     * @return 全省平均单价
     */
    BigDecimal selectQspjDjSc(@Param("spdm") String spdm);

    /**
     * 出口与开票时间间隔预警 - 查询关联号开票滞后信息
     * @param lcslid 流程受理ID
     * @return 开票滞后信息列表
     */
    List<YjxxNewVo> selectCkkpSjjg16201(@Param("lcslid") String lcslid);

    /**
     * 出口与开票时间间隔预警 - 查询近12个月16201预警次数
     * @param nsrdzdah 纳税人电子档案号
     * @param months 统计月数
     * @return 预警次数
     */
    int selectCkkpSjjgCount16202(@Param("nsrdzdah") Long nsrdzdah, @Param("months") int months);


    /**
     * 每美元利润率分析预警 - 查询关联号每美元利润率信息
     * @param lcslid 流程受理ID
     * @return 每美元利润率信息列表
     */
    List<YjxxNewVo> selectWmqyMmylrl163(@Param("lcslid") String lcslid);

    /**
     * 风险企业调查评估 - 查询三三智检红码等级
     * @param djxh 登记序号
     * @return 红码等级（3表示红码）
     */
    Integer selectJkmLevel(@Param("djxh") String djxh);

    /**
     * 风险企业调查评估 - 查询专项监管未核实疑点数量
     * @param djxh 纳税人电子档案号
     * @return 未核实疑点数量
     */
    Integer selectZxzbWhsydCount(@Param("djxh") BigDecimal djxh);

    /**
     * 风险企业调查评估 - 查询16404预警未处理数量
     * @param cpcode 产品代码
     * @param months 月数
     * @return 未处理预警数量
     */
    Integer select16404NotProcessedCount(@Param("cpcode") String cpcode, @Param("months") int months);

    /**
     * 风险企业调查评估 - 查询三新预警涉税金额超阈值数据
     * @param lcslid 流程受理ID
     * @param pval 税额阈值
     * @return 超阈值预警数据列表
     */
    List<YjxxNewVo> selectSanxinYjOverThreshold(@Param("lcslid") String lcslid, @Param("pval") BigDecimal pval);

    /**
     * 长期未申报报关单 - 查询未申报报关单份数和金额
     * @param djxh 登记序号
     * @return 未申报报关单份数和金额
     */
    Map<String, Object> selectCqwbgdCountAndAmt(@Param("djxh") String djxh);


    /**
     * 收汇比例偏低预警 - 查询上年度出口额和收汇额
     * @param djxh 登记序号
     * @return 包含上年度出口美元离岸价、外管局收汇美元、人民银行收汇折美元
     */
    Map<String, Object> selectShblpd166(@Param("djxh") String djxh);

    /**
     * 未申报物流信息 - 免抵退申报提取报关单信息
     * @param lcslid 流程受理ID
     * @return 报关单信息列表
     */
    List<MdtBgxx121Vo> selectMdtBgxx121(@Param("lcslid") String lcslid);

    /**
     * 未申报物流信息 - 免退税申报提取报关单信息
     * @param lcslid 流程受理ID
     * @return 报关单信息列表
     */
    List<MtsBgxx121Vo> selectMtsBgxx121(@Param("lcslid") String lcslid);

    /**
     * 未申报物流信息 - 查询集装箱号和数量
     * @param bgdhgbh 18位报关单号
     * @return 包含jzxh和jzxsl
     */
    Map<String, Object> selectJzxh121(@Param("bgdhgbh") String bgdhgbh);

    /**
     * 未申报物流信息 - 查询发货模式
     * @param bgdhgbh 18位报关单号
     * @return 发货模式数量
     */
    int selectFhms121(@Param("bgdhgbh") String bgdhgbh);

    /**
     * 未申报物流信息 - 查询供应商信息
     * @param fphm 发票号码
     * @return 供应商信息
     */
    Map<String, Object> selectGysxx121(@Param("fphm") String fphm);

    /**
     * 未申报物流信息 - 查询报关单物流信息是否为空
     * @param djxh 登记序号
     * @param bgdhgbh 报关单号
     * @return 报关单链路信息
     */
    Map<String, Object> selectBgdwlByBgdh(@Param("djxh") String djxh, @Param("bgdhgbh") String bgdhgbh);

    /**
     * 未申报物流信息 - 批量查询报关单链路信息
     * @param djxh 登记序号
     * @param bgdhgbhList 报关单号列表
     * @return 报关单链路信息列表
     */
    List<Map<String, Object>> selectBgdwlListByBgdhList(@Param("djxh") String djxh, @Param("bgdhgbhList") List<String> bgdhgbhList);

    /**
     * 未申报物流信息 - 从申报明细备注提取物流信息
     * @param djxh 登记序号
     * @param bgdhLike 报关单号模糊匹配
     * @param tmsjsffDm 退免税计算方法代码
     * @return 备注信息
     */
    String selectSbmxbzWlxx(@Param("djxh") String djxh, @Param("bgdhLike") String bgdhLike, @Param("tmsjsffDm") String tmsjsffDm);

    /**
     * 未申报物流信息 - 从发票备注提取物流信息
     * @param fphm 发票号码
     * @return 备注信息
     */
    FphmBzVo selectFpbzWlxx(@Param("fphm") String fphm);

    /**
     * 未申报物流信息 - 新增报关单链路信息
     * @param params 报关单链路信息
     */
    void insertBgdwl(Map<String, Object> params);

    /**
     * 未申报物流信息 - 更新报关单物流信息
     * @param params 报关单物流信息
     */
    void updateBgdwlWlxx(Map<String, Object> params);

    /**
     * 未申报物流信息 - 查询未申报物流信息的报关单
     * @param djxh 登记序号
     * @param p1val 出口额阈值
     * @return 未申报物流信息的报关单列表
     */
    List<Map<String, Object>> selectWsbWlxxBgdh(@Param("djxh") String djxh, @Param("p1val") BigDecimal p1val);

    /**
     * 获取风险等级信息
     * @param swjgdm
     * @param ysfsDm
     * @param spdlDm
     * @param qycodeHyd
     * @param qycodeHg
     * @param qycodeMdg
     * @return
     */
    Map<String, String> getRiskInfo(@Param("swjgdm") String swjgdm, @Param("ysfsDm") String ysfsDm, @Param("spdlDm") String spdlDm,
                                    @Param("qycodeHyd") String qycodeHyd, @Param("qycodeHg") String qycodeHg, @Param("qycodeMdg") String qycodeMdg);

    String selectXzqhHydDm(@Param("hghydDm") String hghydDm);

    List<YdbgHydCkkaScVo> selectHydCkkaYj4Sc(@Param("lcslid") String lcslid);

    /**
     * 出口企业调查评估未解除预警
     * @param lcslid
     * @param djxh
     * @return
     */
    Integer selectDcbpWjcCnt4ScWm(@Param("lcslid") String lcslid, @Param("djxh") String djxh);

    /**
     * 供货企业正在函调未回函
     * @param lcslid
     * @return
     */
    List<YjxxNewVo> selectGysHdWhh(@Param("lcslid") String lcslid);

    /**
     * 出口企业正在稽查
     * @param djxh
     * @return
     */
    Integer selectCkqyZzjc4ScWm(@Param("djxh") String djxh);

    /**
     * 查询报关单关注信息数据
     * @param lcslid
     * @return
     */
    List<YjxxNewVo> selectBgdGzxxList(@Param("lcslid") String lcslid);

    /**
     * 断2年以上重新申报出口退税
     * @param lcslid
     * @param p1val
     * @return
     */
    Integer selectFirstTsck10302ScWm(@Param("lcslid") String lcslid, @Param("p1val") int p1val);

    /**
     * 查询历史预警是否货源地不一致预警
     * @param djxh
     * @param ckbgdh
     * @return
     */
    YjxxNewVo selectHisYjHydbyz(@Param("djxh") String djxh, @Param("ckbgdh") String ckbgdh);

    /**
     * 出口企业调查评估未解除预警(外贸)
     * @param lcslid
     * @return
     */
    List<YjxxNewVo> selectDcbpWjcList4Wm(@Param("lcslid") String lcslid);

    /**
     * 供货企业正在函调未回函(生产)
     * @param djxh
     * @return
     */
    List<YjxxNewVo> selectGysHdWhh4Sc(@Param("djxh") String djxh);

    // ===== 12301 外贸企业退税率就高申报预警 =====
    /**
     * 12301 - 按批次汇总免退税进货明细（11位商品码+退税率维度）
     * @param pramDTO 包含 lcslid 和 pval1（退免税额阈值）
     * @return 候选预警数据
     */
    List<YjxxNewVo> selectYjbmtdtshd12301ByBatch(YjPramDTO pramDTO);

    /**
     * 12301 - 检查历史预警信息表中是否已存在相同企业+商品代码的预警
     * 用于避免重复预警输出
     * @param nsrdzdah 纳税人电子档案号
     * @param spdm 11位商品代码
     * @param lcslid 当前流程受理ID（排除当前申报记录）
     * @return 存在返回1，不存在返回null
     */
    Integer checkExistYj12301(@Param("nsrdzdah") String nsrdzdah, @Param("spdm") String spdm, @Param("lcslid") String lcslid);

    /**
     * 12302 - 检查历史预警信息表中是否已存在相同企业+商品代码的预警
     * 用于避免重复预警输出
     * @param nsrdzdah 纳税人电子档案号
     * @param spdm 11位商品代码
     * @param lcslid 当前流程受理ID（排除当前申报记录）
     * @return 存在返回1，不存在返回null
     */
    Integer checkExistYj12302(@Param("nsrdzdah") String nsrdzdah, @Param("spdm") String spdm, @Param("lcslid") String lcslid);


    // ===== 12302 生产企业退税率就低预警 =====
    /**
     * 12302 - 按批次汇总免抵退进货明细（11位商品码+退税率维度）
     * @param pramDTO 包含 lcslid 和 pval1（退免税额阈值）
     * @return 候选预警数据
     */
    List<YjxxNewVo> selectYjbmtdtshd12302ByBatch(YjPramDTO pramDTO);

    // ===== 12501/12502 外贸企业换汇成本超阈值预警 =====
    /**
     * 上限
     * 12501/12502 - 按18位报关单号汇总计算退税额和换汇成本
     * 换汇成本 = 人民币出口成本 / 美元出口销售额
     * 人民币出口成本 = 进货计税金额(JSJE) + 征税额 - 退税额(TSE)
     * 征税额 = JSJE * ZSSL / 100
     * @param pramDTO 包含 lcslid
     * @return 报关单号、退税额合计、换汇成本等
     */
    List<YjxxNewVo> selectHkbccbByBgdhSx(YjPramDTO pramDTO);

    /**
     * 下限
     * @param pramDTO
     * @return
     */
    List<YjxxNewVo> selectHkbccbByBgdhXx(YjPramDTO pramDTO);

    /**
     * 12201 - 生产企业：查询申报明细及报关单电子信息中的申报单位名称（JSXT数据源）
     * 数据源：HX_CKTS.CKTS_SB_MDT_TSSB_GCB + HX_CKTS.CKTS_WBSJ_HG_BGD201
     * @param pramDTO 包含 lcslid 和 pval1（退免税额阈值）
     * @return 报关单号、申报单位名称、退税额等
     */
    List<YjxxNewVo> selectFxbghSbdw12201Sc(YjPramDTO pramDTO);

    /**
     * 12201 - 外贸企业：查询申报明细及报关单电子信息中的申报单位名称（JSXT数据源）
     * 数据源：HX_CKTS.CKTS_SB_MTS_TSSB_GCB + HX_CKTS.CKTS_WBSJ_HG_BGD201
     * @param pramDTO 包含 lcslid 和 pval1（退免税额阈值）
     * @return 报关单号、申报单位名称、退税额等
     */
    List<YjxxNewVo> selectFxbghSbdw12201Wm(YjPramDTO pramDTO);

    /**
     * 12201 - 查询风险报关行配置表中的报关行名称列表（TLADMIN数据源）
     * 数据源：TL_ADMIN.YJ_CS_FXBGH
     * @return 风险报关行名称列表
     */
    List<String> selectFxbghList12201();

    /**
     * 12401 - 按批次统计免抵退出口明细申报表中的业务类型为STZC-*的申报序号数量、免抵退税额合计
     * 数据源：HX_CKTS.CKTS_SB_MDT_TSSB_GCB
     * @param pramDTO 包含 lcslid
     * @return 业务类型、退税额合计等
     */
    List<YjxxNewVo> selectStzc12401(YjPramDTO pramDTO);

    /**
     * 12401/12402 - 查询企业已存在的视同自产货物预警（用于防重复预警）
     * 数据源：TL_ADMIN.YJ_DATA_YJXX
     * @param nsrdzdah 纳税人电子档案号
     * @return 已存在预警的企业+业务类型组合列表
     */
    List<String> selectStzc124Existed(@Param("nsrdzdah") String nsrdzdah);

    /**
     * 12402 - 查询企业开业登记日期
     * 数据源：HX_DJ.DJ_NSRXX
     * @param djxh 登记序号
     * @return 开业登记日期
     */
    String selectKydjDate(@Param("djxh") String djxh);

    /**
     * 12402 - 查询企业纳税信用等级
     * 数据源：FXNK_JC2B_NSXYPJ
     * @param djxh 登记序号
     * @return 纳税信用等级（A/B/C/D/M）
     */
    String selectNsxydj(@Param("djxh") String djxh);

    /**
     * 12402 - 查询企业上一年度增值税申报全部销售额合计
     * 数据源：HX_SB.SB_ZZS_YBNSR
     * @param djxh 登记序号
     * @return 销售额合计
     */
    BigDecimal selectLastYearSales(@Param("djxh") String djxh);

    /**
     * 返回一行或0行数据，如果返回1行数据
     * @param pramDTO
     * @return
     */
    YjxxNewVo selectStzc12402(YjPramDTO pramDTO);

    /**
     * 12403 - 查询36个月内出口骗税、虚开发票处罚决定书数量
     * 数据源：税务稽查/处罚相关表（TODO: 待确认具体数据源）
     * @param djxh 登记序号
     * @return 处罚决定书数量
     */
    Integer selectPcfcfsCountForStzc12403(@Param("djxh") String djxh);


    /**
     * 按批次检查免抵退出口明细申报表中是否存在业务类型包含“STZC”的记录
     * @param pramDTO
     * @return
     */
    Integer countStzc12403(YjPramDTO pramDTO);
}
