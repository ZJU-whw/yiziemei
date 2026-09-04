package com.tl.web.bjts.shzs.service;

import com.tl.web.bjts.shzs.model.SbfileVo;
import org.springframework.stereotype.Service;

/**
 * @描述: 生成申报文件接口
 * @作者: likun
 * @时间: 2020/9/21 15:05
 */
@Service
public interface ISbfileService {
    /**
     * 下载申报数据数据文件
     * @param sbid
     * @return
     */
    SbfileVo downloadSbsj(Long sbid);

}
