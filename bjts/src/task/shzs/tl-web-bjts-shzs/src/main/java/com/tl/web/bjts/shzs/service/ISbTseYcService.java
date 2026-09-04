package com.tl.web.bjts.shzs.service;

import com.tl.web.bjts.shzs.model.dto.tseyc.TseYcBfLogSaveDTO;
import com.tl.web.bjts.shzs.model.dto.tseyc.TseYcInfoQueryDTO;
import com.tl.web.bjts.shzs.model.vo.TseYcInfoQueryVO;

/**
 * @Author whg
 * @create 2024/5/8 17:30
 * @description：
 */
public interface ISbTseYcService {

    /**
     * 保存退税额预测不符的处理日志
     * @param dto
     */
    void saveLog(TseYcBfLogSaveDTO dto);

    /**
     * 查询退税额预测信息
     * @param dto
     * @return
     */
    TseYcInfoQueryVO queryInfo(TseYcInfoQueryDTO dto);
}
