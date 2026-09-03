package com.tl.bjts.sw.dao;


import com.github.pagehelper.Page;
import com.tl.bjts.sw.model.DictInfoModel;
import com.tl.bjts.sw.model.domain.NsrSampleSubModel;
import com.tl.bjts.sw.model.dto.NsrxxQueryDTO;
import com.tl.bjts.sw.model.vo.SjjcTmsqkVo;
import com.tl.bjts.sw.model.vo.SjjcTswyQkVo;
import com.tl.bjts.sw.model.vo.jcfx.NsrdjxxVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface TlSjjcMapper {

    List<NsrSampleSubModel> selectNsrSampleSubList(@Param("pkid") Long pkid, @Param("swjgDm") String swjgDm);

    List<NsrdjxxVo> getNsrdjxxList(@Param("param") NsrxxQueryDTO param, @Param("swjgDm") String swjgDm);

    Page<SjjcTmsqkVo> selectMdtsTjDataList(@Param("ssnyStart") String ssnyStart, @Param("ssnyEnd") String ssnyEnd, @Param("lastYearSsnyStart") String lastYearSsnyStart, @Param("lastYearSsnyEnd") String lastYearSsnyEnd, @Param("preSwjgdm") String preSwjgdm, @Param("swjgdm")String swjgdm);

    Page<SjjcTswyQkVo> selectTsywTjDataList(@Param("ssnyStart") String ssnyStart, @Param("ssnyEnd") String ssnyEnd, @Param("preSwjgdm") String preSwjgdm, @Param("tsywlxSql") String tsywlxSql);

    List<DictInfoModel> selectDictInfoAll();
}
