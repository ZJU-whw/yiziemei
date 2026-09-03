package com.tl.bjts.sw.dao;

import com.tl.bjts.sw.model.domain.YjBgdgzxxGcbModel;
import com.tl.bjts.sw.model.vo.YjBgdgzxxDetailVO;
import com.tl.bjts.sw.model.vo.YjBgdgzxxVO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface YjBgdgzxxMapper {

    /**
     * 查询未申报/审核中关注信息列表（GCB表）
     */
    List<YjBgdgzxxVO> listGcb(
            @Param("swjgdm") String swjgdm, @Param("ckbgdh") String ckbgdh,
            @Param("nsrsbh") String nsrsbh,
            @Param("nsrmc") String nsrmc,
            @Param("czrqStart") String czrqStart,
            @Param("czrqEnd") String czrqEnd,
            @Param("orderSql") String orderSql);

    /**
     * 查询审核结束关注信息列表（JGB表）
     */
    List<YjBgdgzxxVO> listJgb(
            @Param("swjgdm") String swjgdm, @Param("ckbgdh") String ckbgdh,
            @Param("nsrsbh") String nsrsbh,
            @Param("nsrmc") String nsrmc,
            @Param("czrqStart") String czrqStart,
            @Param("czrqEnd") String czrqEnd,
            @Param("orderSql") String orderSql);

    /**
     * 根据企业税号和报关单号查询报关单详情
     */
    YjBgdgzxxDetailVO getBgdDetailByNsrsbh(@Param("nsrsbh") String nsrsbh, @Param("ckbgdh") String ckbgdh, @Param("qxdm") String qxdm);

    /**
     * 查询zj_bjts用户下需要迁移的报关单列表（已转申报的）
     */
    List<YjBgdgzxxGcbModel> listGcb4Transfer();

    /**
     * 插入数据到tl_tssh用户下的JGB表
     */
    void insertToJgb(@Param("djxh") java.math.BigDecimal djxh,
                     @Param("ckbgdh") String ckbgdh,
                     @Param("gzxx") String gzxx,
                     @Param("czrDm") String czrDm,
                     @Param("czrq") Date czrq);

    /**
     * 从zj_bjts用户下的GCB表批量删除数据
     */
    void batchDeleteFromGcb(@Param("list") List<YjBgdgzxxGcbModel> list);
}
