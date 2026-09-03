package com.tl.bjts.sw.dao;


import com.tl.bjts.sw.model.JsZbModel;
import com.tl.bjts.sw.model.dto.InitBgdDataDTO;
import com.tl.bjts.sw.model.dto.ShspqkSaveDTO;
import com.tl.bjts.sw.model.dto.TjfxMainDTO;
import com.tl.bjts.sw.model.vo.StateVo;
import com.tl.bjts.sw.model.vo.WmGhqyMxVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Map;


@Repository
public interface TlTjfxMapper {

    List<StateVo.State> selectStatesByDq(String dqCode);

    List<StateVo.State> selectStates();

    void updateDynZbJs(JsZbModel jsZbModel);

    void updateDynZbJsD01007(JsZbModel jsZbModel);

    void updateDynZbJsD01010(JsZbModel jsZbModel);

    int selectExistHashRecord(@Param("pramHash") String pramHash, @Param("tablename") String tablename);

    List<Map> selectDyncTableData(@Param("paramhash") String paramhash, @Param("tablename") String tablename);

    List<Map<String,Object>> selectTjbbCxCktsshspqk(@Param("pramHash") String pramHash);

    List<Map> selectD01003(String pramHash);

    List<Map> selectD01007(String pramHash);

    List<Map> selectD01010(String pramHash);

    void insertInitD01003Data(TjfxMainDTO tjfxMainDTO);

    void insertInitD01004Data4Gb(TjfxMainDTO mainDTO);

    void insertInitD01004Data4Dq(TjfxMainDTO mainDTO);

    void insertInitD01005Data(TjfxMainDTO mainDTO);

    void insertInitD01006Data(TjfxMainDTO mainDTO);

    void insertInitD01007Data(TjfxMainDTO mainDTO);

    void insertInitHyD01007Data(TjfxMainDTO mainDTO);

    void insertInitD01008Data(TjfxMainDTO mainDTO);

    void insertInitD01009Data(TjfxMainDTO mainDTO);

    void insertInitD01010Data(TjfxMainDTO mainDTO);

    void insertInitCX10001Data(TjfxMainDTO mainDTO);

    void insertInitSjXzqhD01010Data(TjfxMainDTO mainDTO);


    List<WmGhqyMxVo> getWmghqymx(TjfxMainDTO mainDTO);

    List<String> getYears(String swjgdm);

    void updateBgdData(Map map);

    void updateE01001Cktse(Map map);

    void insertInitD01002Data(TjfxMainDTO mainDTO);

    void insertInitD01002Data4Mdbz(Map map);

    Map selectMdbzData(TjfxMainDTO mainDTO);

    List<String> getSwjgdms4E01001();

    List<Map<String,Object>> getShspb1(@Param("swjgdm") String swjgdm, @Param("rqq") Date rqq, @Param("rqz") Date rqz);

    List<Map<String,Object>> getShspb2(@Param("swjgdm") String swjgdm);

    List<Map<String,Object>> getShspb3(@Param("swjgdm") String swjgdm);

    int insertShspb(ShspqkSaveDTO dto);

    void deleteTempData(TjfxMainDTO mainDTO);
}
