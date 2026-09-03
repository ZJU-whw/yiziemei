package com.tl.bjts.sw.dao;


import com.tl.bjts.sw.model.DateHashMap;
import com.tl.bjts.sw.model.ProcParam;
import com.tl.bjts.sw.model.domain.TjbbColModel;
import com.tl.bjts.sw.model.domain.TjbbHeaderModel;
import com.tl.bjts.sw.model.domain.TjbbSbJyxxModel;
import com.tl.bjts.sw.model.domain.TjbbTaskSubModel;
import com.tl.bjts.sw.model.dto.SuitExcelDTO;
import com.tl.bjts.sw.model.dto.TjrwDTO;
import com.tl.bjts.sw.model.vo.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Repository
public interface TlTjbbMapper {

    List<Map> loaddata(@Param("bbdm") String bbdm,@Param("ssny") String ssny,
                                          @Param("fname") String fname, @Param("swjgdm") String swjgdm);

    List<DateHashMap> loaddataMxAll(@Param("bbdm") String bbdm, @Param("ssny") String ssny, @Param("fname") String fname,
                                    @Param("swjgdm") String swjgDm, @Param("isDs") boolean isDs, @Param("bbdldm") String bbdldm);

    List<Map> loaddataMx(@Param("bbdm") String bbdm, @Param("ssny") String ssny, @Param("fname") String fname,
                         @Param("swjgdm") String swjgDm, @Param("preSwjgdm") String preSwjgdm, @Param("bbdldm") String bbdldm);

    List<Map> loaddataBySwjgdm(@Param("bbdm") String bbdm,@Param("ssny") String ssny,
                                                  @Param("fname") String fname, @Param("curSwjgdm") String curSwjgdm,
                                                  @Param("swjgdm") String swjgdm);

    List<Map> loaddataBySwjgdmMx(@Param("bbdm") String bbdm,@Param("ssny") String ssny,
                                                  @Param("fname") String fname,
                                                  @Param("swjgdm") String swjgdm);

    List<TjbbHeaderModel> initLineItem(String bbdm);

    List<TjbbHeaderModel> getHeadLineFormula(String bbdm);

    String getColByXlscol(@Param("bbdm") String bbdm, @Param("colsNum") String colsNum);

    List<TjbbTaskVo> getTaskList(@Param("swjgDm")String swjgDm, @Param("ssny")String ssny);

    List<TjbbTaskSubVo> getTaskSubList(@Param("swjgdm")String swjgDm, @Param("ssny")String ssny,
                                       @Param("bbdldm")String bbdldm);

    List<TjbbItemVo> getTjbbItemList();

    List<TjbbRecvMainVo> getTjbbRecvMain(@Param("bbdm")String bbdm, @Param("swjgdm")String swjgDm,
                                         @Param("isJc")boolean isJc);

    List<TjbbRecvMainVo> getTjbbRecvMainByNy( @Param("ssny")String ssny, @Param("bbdm")String bbdm,
                                              @Param("swjgdm")String swjgDm,@Param("isJc")boolean isJc);


    void insertSaveTjbb(Map sqlPram);

    int updateSaveTjbb(Map sqlPram);

    void dyncCreateTable(@Param("tablename") String tablename);

    void dyncCreateTablePk(@Param("tablename")String tablename,@Param("pkname")String pkname);

    void dyncCreateTable4Tjfx(@Param("tablename") String tablename);

    void dyncCreateTablePk4Tjfx(@Param("tablename")String tablename,@Param("pkname")String pkname);

    void insertDyncTableColumn(@Param("list")List<TjbbColModel> dataList);

    void dyncAddTableColumn(@Param("tablename")String tablename,
                            @Param("fname")String fname,
                            @Param("ftype")String ftype);

    List<FormulaColumnVo.FormulaColumn> loadFormulaCols(String bbdm);

    List<FormulaColumnVo.FormulaColumn> loadFormulaRows(String bbdm);

    int countDataTables(@Param("tablename")String tablename);

    int countColumnByBbdm(@Param("bbdm")String bbdm);

    List<ColumnTypeVo> selectColumnType(@Param("tablename") String tablename);

    void insertInitTjbbLine(Map sqlPram);

    void insertSubTaskList(Map sqlPram);

    void dyncAddTableColumnComment(@Param("tablename")String tablename,
                                   @Param("fname")String fname,
                                   @Param("comment") String comment);

    void insertHzTjbb4Sum(Map pramMap);

    void insertHzTjbb4Type5(Map pramMap);

    void deleteHzTjbbData(Map pramMap);

    void deleteTjfxData(Map pramMap);

    void deleteTaskSub(Map pMap);

    void excuteProcedure(ProcParam param);

    void insertTbDataList4Lines(Map p);

    List<HzTypeVo> getTbHzItems(@Param("bbdm")String bbdm);

    void updateTbDataList4Cols(Map pp);

    void updateZbDataList4Cols(Map pp);

    void updateZbFormulaDataList4Cols(Map pp);

    List<HzTypeVo> getTbHzCols(@Param("bbdm")String bbdm);

    List<HzTypeVo> getZbHzCols(@Param("bbdm")String bbdm);

    List<HzTypeVo> getZbFormulaHzCols(@Param("bbdm")String bbdm);

    List<ProfileFormulaVo> selectLineProfileFormula(@Param("bbdm")String bbdm);

    void jsProfileLineFormula(Map updateObj);

    String selectColumnValue(Map p);

    String selectColumnValueHz(Map p);

    List<SuitExcelDTO> getBbdmBYdl(String bbdldm);

    List<TjbbSbJyxxModel> selectJyxxList(@Param("bbdldm") String bbdldm, @Param("swjgDm") String swjgDm, @Param("msgLevel") String msgLevel);

    List<TjrwListVO> selectTjrwList(TjrwDTO tjrwDTO);

    int deleteTjrw(@Param("rwlx") String rwlx,@Param("rwhash") String rwhash);

    void excuteProcedureCheck(ProcParam param);

    List<SwjgDispVo> selectAllSubArea(@Param("swjgDm") String swjgDm);

    void excuteJkglProcedure(ProcParam param);
}
