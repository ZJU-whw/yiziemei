package com.tl.web.bjts.shzs.dao;

import com.tl.web.bjts.shzs.model.domain.YjSbxxHzModel;
import com.tl.web.bjts.shzs.utils.TlTKMapper;
import org.apache.ibatis.annotations.Param;

public interface YjSbxxHzModelMapper extends TlTKMapper<YjSbxxHzModel> {

    /**
     * 重置申报次数和提取标志
     * @param id 主键ID
     */
    void resetSbcsAndTqbz(@Param("sbid") Long id);
}