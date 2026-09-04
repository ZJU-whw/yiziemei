package com.tl.web.bjts.shzs.dao;

import com.tl.web.bjts.shzs.model.domain.TlSbxxProfile;
import com.tl.web.bjts.shzs.model.dto.dbwp.LoggeQueryDTO;
import com.tl.web.bjts.shzs.model.dto.dzhc.InspectQueryDTO;
import com.tl.web.bjts.shzs.model.dto.sbxx.SbMxbBaseDTO;
import com.tl.web.bjts.shzs.model.vo.CompanyInfVO;
import com.tl.web.bjts.shzs.model.vo.RwtxVo;
import com.tl.web.bjts.shzs.model.vo.SbxxViewVo;
import com.tl.web.bjts.shzs.model.vo.dzhc.InspectQueryVO;
import com.tl.web.bjts.shzs.model.vo.sbxx.*;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Created by Mamf on 2017/6/20.
 */
public interface TlLinkedMapper {

     int updateToNextVal(String tblname);//更新主键

     Long selectCurvalue(String tblname);//获取主键

     int updateToNextVal4Admin(String tbName);

     Long selectCurvalue4Admin(String tbName);

     List<Map<String, String>> getFpglXx(String czryDM); //获取分片管理信息按照操作人代码

     List<Map<String,String>> getGroupBySbywxxByType(String ywzlType);//按照业务种类代码获取申报业务信息

     List<Map<String,String>> getGroupBySbywzlxx();//获取分组业务种类信息

     List<TlSbxxProfile> getSblbxxByPage(Map map);//获取申报列表分页查询

     List<Map<String,Object>> getSbywxx(String czryDM);//获取申报列表分页查询

     List<TlSbxxProfile> getSbxxDetails(Long sbid);//获取申报信息明细

     SbxxViewVo getSbxxDetails2(Long sbid);

     List<RwtxVo> getRwtxList(Map map); //根据操作人员代码获取税企交互任务信息

     int getRwtxListCount(Map map); //根据操作人员代码获取税企交互任务信息


     CompanyInfVO getCompanyInfoBySbid(Long sbid);

     /**
      *  更新街道乡镇名称
      * @param map
      * @return
      */
     int updateJdxzmc(Map map);

     /**
      *  根据税号查询单证备案登记表记录数
      * @param nsrsbh
      * @return
      */
     Map getEdocApplyByNsrsbh(String nsrsbh);

     /**
      * 生产免抵退税申报明细表查询
      * @param dto SbMxbBaseDTO
      * @return
      */
     List<SbMdtsMxbVO> listScmdtsMxb(SbMxbBaseDTO dto);

     /**
      *  生产免抵退税申报明细表查询-合计
      * @param dto SbMxbBaseDTO
      * @return
      */
     SbMdtsMxbSumVO sumScmdtsMxb(SbMxbBaseDTO dto);

     /**
      * 外贸免退税出口明细与进货明细数据查询
      * @param dto SbMxbBaseDTO
      * @return
      */
     List<SbMtsCkmxVO> listWmmtsMxb(SbMxbBaseDTO dto);

     /**
      * 外贸免退税出口明细与进货明细数据查询（合计）
      * @param dto SbMxbBaseDTO
      * @return SbMtsMxbSumVO
      */
     SbMtsMxbSumVO sumWmmtsMxb(SbMxbBaseDTO dto);

     /**
      *  根据申报id和关联号查询外贸进货明细数据
      * @param sbid 申报id
      * @param glh 关联号
      * @param ghfnsrsbh 供货方纳税人识别号
      * @return
      */
     List<SbMtsJhmxVO> listWmmtsJhmxBySbidGlh(@Param("sbid") Long sbid,@Param("glh") String glh, @Param("ghfnsrsbh") String ghfnsrsbh);

     /**
      *  外综服代办退税申报明细数据
      * @param dto SbMxbBaseDTO
      * @return List<SbWzfdbtsMxbVO>
      */
     List<SbWzfdbtsMxbVO> listWzfdbts(SbMxbBaseDTO dto);

     /**
      *  外综服代办退税申报明细数据（合计）
      * @param dto
      * @return
      */
     SbWzfdbtsMxbSumVO sumWzfdbtsMxb(SbMxbBaseDTO dto);

     /**
      *  购进自用货物申报明细数据
      * @param dto SbMxbBaseDTO
      * @return  List<SbGjzyhwMxbVO>
      */
     List<SbGjzyhwMxbVO> listGjzyhwMxb(SbMxbBaseDTO dto);

     /**
      * 购进自用货物申报明细数据（汇总）
      * @param dto
      * @return
      */
     SbGjzyhwMxbSumVO sumGjzyhwMxb(SbMxbBaseDTO dto);

     /**
      * 从管理系统用户表中获取操作人联系电话
      * @param czryDm 操作人员代码
      * @return 操作人员联系电话
      */
     String getLxrdhFromGlxt(@Param("czryDm") String czryDm);

     /**
      *   查询日常审单核查列表
      * @param dto InspectQueryDTO
      * @return
      */
     List<InspectQueryVO> listInspectDaily(InspectQueryDTO dto);

     /**
      *  校验操作员是否有日常审单核查权限
      * @param czryDm 登录名
      * @return
      */
     Integer countInspectDailyAuth(@Param("czryDm") String czryDm);

     /**
      *  审单核查在办任务数量
      * @param swjgdm 税务机关代码
      * @param releaser 下达人
      * @return
      */
     Integer countInspectWorking( @Param("swjgdm") String swjgdm, @Param("releaser") String releaser);

     /**
      * 获取联系人、联系电话、企业分组名称、税务机关名称、标签
      * @param nsrsbh
      * @return
      */
     SbxxViewVo queryLxrxx(@Param("nsrsbh") String nsrsbh);

    List queryLoggerList(@Param("dto") LoggeQueryDTO loggeQueryDTO, @Param("swjgDm") String swjgDm);

    String selectQygzxx(@Param("djxh") BigDecimal djxh);
}
