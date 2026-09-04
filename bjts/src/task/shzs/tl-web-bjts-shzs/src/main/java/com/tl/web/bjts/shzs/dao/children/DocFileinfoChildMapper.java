package com.tl.web.bjts.shzs.dao.children;

import com.tl.web.bjts.shzs.model.vo.sbfile.SbfileHzVO;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface DocFileinfoChildMapper {
    /**
     * 根据sbid查询附件列表
     * @param sbid  申报id
     * @return  Map形式的list   map{pt.id,pt.fmcode,pt.title,pt.filesize,kz.clbz,kz.rootpath,kz.filepath}
     */
    List<Map<String,Object>> view(Long sbid);

    /**
     * 查询文件基本信息
     * @param fileId 文件id
     * @return
     */
    Map fileJbxx(Long fileId);

    /**
     * 新增附件扩展表记录
     * @param map
     * @return
     */
    int insertKz(Map map);

    /**
     * 更新附件表记录
     * @param map
     * @return
     */
    int updateKz(Map map);

    /**
     *获取申报文件基本信息
     * @param sbid  申报id
     * @return
     */
    Map<String,Object> sbfileJbxx(Long sbid);

    /**
     * 根据fileId查询扩展表
     * @param fileId 文件id
     * @return
     */
    Map<String,Object> selectKz(Long fileId);

    /**
     *  获取申报文件需要的汇总表信息
     * @param sbid  申报id
     * @return
     */
    SbfileHzVO getSbfileHz(Long sbid);

}