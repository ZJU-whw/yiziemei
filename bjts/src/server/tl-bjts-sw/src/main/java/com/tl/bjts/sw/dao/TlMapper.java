package com.tl.bjts.sw.dao;



import com.github.pagehelper.Page;
import com.tl.bjts.sw.model.TreeNode;
import com.tl.bjts.sw.model.domain.JcfxTaskModel;
import com.tl.bjts.sw.model.domain.TjbbTaskModel;
import com.tl.bjts.sw.model.domain.TjfxExtraCkts;
import com.tl.bjts.sw.model.vo.jcfx.SelectItemVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Repository
public interface TlMapper {

    void saveExtraCkts(TjfxExtraCkts obj);

    /**
     * 根据类型和代码查找字典表的中文
     * @param dtype  字典类型
     * @param dcode  字典代码
     * @return
     */
    String selectDnameByTypeCode(@Param("dtype") String dtype,@Param("dcode") String dcode);


    String getVirSwjgdmXh(String swjgDm);

    List<TjbbTaskModel> selectVirReceiveTask(@Param("ssny")String ssny, @Param("swjgdm")String swjgdm,
                                             @Param("bbdldm")String bbdldm);

    int countVirswjgSb(@Param("swjgdm")String swjgdm,@Param("ssny")String ssny, @Param("bbdldm")String bbdldm);

    List<TreeNode> getSelectTree(String swjgDm);

    List<String> selectBblcHeader(@Param("bbdm") String bbdm, @Param("x") Integer x);

    List<String> selectTitleHeader(@Param("bbdm") String bbdm, @Param("y") Integer y);

    Page<LinkedHashMap> selectDynamicTableDetails(@Param("sqlScript") String sqlScript);

    int lockDynamicQueryTask(Map map);

    List<JcfxTaskModel> selectDynamicTaskList(Map map);

    List<SelectItemVo> selectZdyZbdm(@Param("zbxmbm") String zbxmbm, @Param("swjgdm") String swjgdm);

    List<String> selectZbxmByZid(@Param("zid") Long zid);

    void updateTaskFish(@Param("up") JcfxTaskModel up);
}
