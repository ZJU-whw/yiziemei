package com.tl.bjts.sw.dao;

import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

@Repository
public interface JsxtMapper {

    /**
     *  统计分析-出口退税和外贸出口情况：获取出口退税额数据本月数据
     * @param map
     */
    List<Map<String,Object>> selectE01001Cktse(Map map);

    /**
     *  统计分析-出口退税和外贸出口情况：获取出口退税额数据上年同期数据
     * @param map
     */
    List<Map<String,Object>> selectE01001Cktse4LastSsny(Map map);

}
