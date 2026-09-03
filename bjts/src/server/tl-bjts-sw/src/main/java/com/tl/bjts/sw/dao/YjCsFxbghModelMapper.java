package com.tl.bjts.sw.dao;

import com.tl.bjts.sw.model.domain.YjCsFxbghModel;
import com.tl.bjts.sw.model.dto.YjCsFxbghDTO;
import com.tl.bjts.sw.model.vo.YjCsFxbghVO;
import com.tl.bjts.sw.utils.TlMapper;

import java.util.List;

public interface YjCsFxbghModelMapper extends TlMapper<YjCsFxbghModel> {

    /**
     * 风险报关行信息查询
     * @param dto 查询条件
     * @return 风险报关行列表
     */
    List<YjCsFxbghVO> queryYjCsFxbghList(YjCsFxbghDTO dto);
}