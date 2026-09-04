package com.tl.web.bjts.shzs.dao;

import com.tl.web.bjts.shzs.model.vo.ldlp.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface TlTsshMapper {

    List<FpHwxxVo> getHwxx(String zyfpNo);    //<!--查询发票的货物信息-->

    FpxxVo getFpxx(String zyfpNo);   //查询发票的详细信息

    FpxxVo getFpxx4Sdfp(String zyfpNo);   //查询发票的详细信息

    BgdVo getBgdInfo(@Param("djxh") String djxh,@Param("bgdNo") String bgdNo);  //查询报关单信息18位

    /**
     *  获取报关单主表数据
     * @param djxh 登记序号
     * @param bgdNo 18位报关单号
     * @return
     */
    BgdMainVO getBgdMain(@Param("djxh") String djxh, @Param("bgdNo") String bgdNo);  //查询报关单主表信息18位

    /**
     *  获取报关单明细列表数据
     * @param djxh 登记序号
     * @param bgdNo 18位报关单号
     * @return
     */
    List<BgdMxVO> listBgdMx(@Param("djxh") String djxh, @Param("bgdNo") String bgdNo);
}
