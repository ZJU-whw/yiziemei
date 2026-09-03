package com.tl.bjts.sw.service;


import com.tl.bjts.sw.model.dto.sbxx.DocQueryDTO;
import com.tl.bjts.sw.model.dto.sbxx.DocViewDTO;
import com.tl.bjts.sw.model.dto.sbxx.SbxxQueryDTO;
import com.tl.bjts.sw.model.vo.sbxx.BgdMainVO;
import com.tl.bjts.sw.model.vo.sbxx.DocQueryVO;
import com.tl.bjts.sw.model.vo.sbxx.FpxxVo;
import com.tl.bjts.sw.model.vo.sbxx.SbxxQueryVO;

import java.util.List;

/**
 * @描述: 申报信息服务接口
 * @作者: likun
 * @时间: 2022/9/6 11:42
 */
public interface ISbxxService {

    /**
     *  查询申报信息列表
     * @param dto SbxxQueryDTO
     * @return List<SbxxQueryVO>
     */
    List<SbxxQueryVO> listSbxx(SbxxQueryDTO dto);

    /**
     *  查询附件列表
     * @param dto DocQueryDTO
     * @return List<DocQueryVO>
     */
    List<DocQueryVO> listSbxxDoc(DocQueryDTO dto);

    /**
     *  查询附件
     * @param dto {附件id、纳税人电子档案号}
     * @return base64编码的文件流
     */
    String viewSbxxDoc(DocViewDTO dto);

    /**
     * 获取数字电票数据
     * @param zyfpNo
     * @return
     */
    FpxxVo getSzdp(String zyfpNo);

    /**
     * 获取出口报关单数据
     * @param ckbgdh
     * @param djxh
     * @return
     */
    BgdMainVO getBgdInfo(String ckbgdh, String djxh);
}
