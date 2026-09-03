package com.tl.bjts.sw.dao.sbxx;

import com.tl.bjts.sw.model.domain.doc.DocFileinfo;
import com.tl.bjts.sw.model.dto.sbxx.DocQueryDTO;
import com.tl.bjts.sw.model.dto.sbxx.SbxxQueryDTO;
import com.tl.bjts.sw.model.vo.sbxx.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SbxxMapper {

    /**
     *  查询申报信息列表
     * @param dto SbxxQueryDTO
     * @return
     */
    List<SbxxQueryVO> listSbxx(SbxxQueryDTO dto);

    /**
     *  查询附件列表
     * @param dto DocQueryDTO
     * @return  List<DocQueryVO>
     */
    List<DocQueryVO> listSbxxDoc(DocQueryDTO dto);

    /**
     *  获取附件信息
     *
     * @param nsrsbh
     * @param nsrdzdah 纳税人电子档案号
     * @param fileId 附件id
     * @return
     */
    DocFileinfo getDocFileinfo(@Param("nsrsbh") String nsrsbh, @Param("nsrdzdah") Long nsrdzdah,
                               @Param("fileId") Long fileId,
                               @Param("dbUserBjts") String dbUserBjts);


    FpxxVo getFpxx4Sdfp(@Param("zyfpNo") String zyfpNo);

    /**
     * 获取报关单信息主表
     * @param djxh
     * @param ckbgdh
     * @return
     */
    BgdMainVO getBgdMain(@Param("djxh") String djxh, @Param("ckbgdh") String ckbgdh);

    /**
     * 获取报关单信息明细数据
     * @param djxh
     * @param ckbgdh
     * @return
     */
    List<BgdMxVO> listBgdMx(@Param("djxh") String djxh, @Param("ckbgdh") String ckbgdh);
}