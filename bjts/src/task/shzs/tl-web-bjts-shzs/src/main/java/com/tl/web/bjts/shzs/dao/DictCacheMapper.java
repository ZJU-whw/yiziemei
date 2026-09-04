package com.tl.web.bjts.shzs.dao;

import com.tl.web.bjts.shzs.model.Dict;
import com.tl.web.bjts.shzs.model.vo.sbxx.KaxxDictVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DictCacheMapper {

    List<Dict> getBicode(); //币种  tl_bjts 数据源
    List<Dict> getDwcode(); //计量单位
    List<Dict> getGbcode(); //国别
    List<Dict> getHgcode(); //海关
    List<Dict> getKacode(); //海关口岸select * from bicode
    List<Dict> getHydcode(); //货源地  tl_bjts 数据源
    List<Dict> getJhtypeCode(); //结汇方式
    List<Dict> getJsfsCode(); //结算方式
    List<Dict> getTdcode(); //贸易方式
    List<Dict> getTranstype(); //运输方式
    List<Dict> getZygcode(); //指运港
    List<Dict> getCjfscode(); //成交方式
    List<Dict> getZmxzcode(); //征免性质
    List<Dict> getBzzlcode(); //包装种类

    List<KaxxDictVO> listKaxxDict(@Param("kaxx") String kaxx); //获取口岸信息列表
}
