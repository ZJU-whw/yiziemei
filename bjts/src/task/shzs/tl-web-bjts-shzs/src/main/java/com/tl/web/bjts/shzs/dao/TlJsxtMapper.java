package com.tl.web.bjts.shzs.dao;


import com.tl.web.bjts.shzs.model.dto.dbwp.DbrwmxVo;
import com.tl.web.bjts.shzs.model.vo.*;
import com.tl.web.bjts.shzs.model.vo.dbwp.LcswsxVo;
import com.tl.web.bjts.shzs.model.vo.dbwp.SwryVo;
import com.tl.web.bjts.shzs.model.vo.sbfile.YwblxxVO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;


import java.util.Date;
import java.util.List;
import java.util.Map;
/**
* 金三系统查询Mapper
 */
@Repository
public interface TlJsxtMapper {


    // 取金三乡镇街道
    Map getXzjdFromJsxt(Map params);

    /**
     * 从金三数据库中获取用户信息
     * @param czryDm
     * @return
     */
    JxUserVO getUserInfoFromJsxt(@Param("czryDm") String czryDm);

    /**
     * 根据流程受理id获取业务办理信息相关数据
     * @param lcslid 流程受理id
     * @return 业务办理信息(登记序号、流程事项、所属时期、申报批次)
     */
    YwblxxVO getYwblxxFormJsxt(@Param("lcslid") String lcslid);

    /**
     *  从金三系统中获取出口岗位在办的出口退税的流程笔数、即将超期的业务笔数
     * @param czryDm 操作人员代码
     * @return
     */
    ItemNoticeVO countCkGwzbFromJsxt(@Param("czryDm") String czryDm);

    /**
     * 从金三系统中,根据20位代理证明号获取21位报关单号
     * @param djxh 登记序号
     * @param dlzmh 代理证明号
     * @return
     */
    String getCkbgdhByDlzmhFromJsxt(@Param("djxh") String djxh,@Param("dlzmh") String dlzmh);

    /**
     * 查询税务人员身份税务机关代码
     * @param sfdm
     * @param swrydm
     * @return
     */
    String querySfswjgDm(@Param("sfdm") String sfdm, @Param("swrydm") String swrydm);

    /**
     * 查询岗位待办任务数量
     * @param xndbrdm
     * @return
     */
    int countGwdbsl(@Param("xndbrdm") String xndbrdm);

    /**
     * 按岗位代码和税务机关代码，查询岗位序号
     * @param gwdm
     * @param swjgdm
     * @return
     */
    String queryGwxh(@Param("gwdm") String gwdm, @Param("swjgdm") String swjgdm);

    /**
     * 查询个人待办任务数量
     * @param gwxh
     * @param sfdm
     * @return
     */
    Integer countGrdbsl(@Param("gwxh") String gwxh, @Param("sfdm") String sfdm);

    Integer countGrzbsl(@Param("gwxh") String gwxh, @Param("sfdm") String sfdm);

    List<DbrwmxVo> queryGwdbmx(@Param("xndbrdm") String xndbrdm, @Param("lcswsxdms") List<String> lcswsxdms, @Param("qybs") String qybs, @Param("sbrqQ") Date sbrqQ, @Param("sbrqZ") Date sbrqZ);

    List<DbrwmxVo> queryGrdbmx(@Param("gwxh") String gwxh, @Param("sfdm") String sfdm);

    List<DbrwmxVo> queryGrzbmx(@Param("gwxh") String gwxh, @Param("sfdm") String sfdm);

    List<SwryVo> querySwrys(@Param("gwxh") String gwxh);

    List<SwryVo> querySwrys4Status(@Param("gwxh") String gwxh);

    void updateDbswryStatus(@Param("sfdm") String sfdm, @Param("gwxh") String gwxh, @Param("status") String status);

    DbrwmxVo queryGwdbmxById(@Param("id") String id);

    Map<String,Object> selectAutoDbrwwp(@Param("swjgDm") String swjgDm, @Param("zjgwdm") String zjgwdm, @Param("nsrsbh") String nsrsbh, @Param("lcswsxDm") String lcswsxDm);

    String queryShzsSwrySfdm(@Param("gwdm") String gwdm, @Param("swrydm") String swrydm);

    List<SwryVo> querySwrysFromShzs(@Param("swjgDm") String swjgDm, @Param("gwxh") String gwxh);

    List<LcswsxVo> selectLcswsxList(@Param("xndbrdm") String xndbrdm);

    SbxxViewVo getSbxxDetail(@Param("lcslid") String lcslid);

    List<YdxxVo> getYdxxs4Sc(@Param("lcslid") String lcslid);

    List<YdxxVo> getYdxxs4Wm(@Param("lcslid") String lcslid);

    List<YdxxVo> getYdxxs4Wzf(@Param("lcslid") String lcslid);

    List<YdxxVo> getYdxxs4Gjzy(@Param("lcslid") String lcslid);

    int countSbcs(@Param("lcslid") String lcslid);

    List<LcswsxVo> selectAllLcswsxList();

    int selectScsbWcqk(@Param("lcslid") String lcslid);

    FetchTaskVo genJsxtYjTask(@Param("lcslid") String lcslid);
}
