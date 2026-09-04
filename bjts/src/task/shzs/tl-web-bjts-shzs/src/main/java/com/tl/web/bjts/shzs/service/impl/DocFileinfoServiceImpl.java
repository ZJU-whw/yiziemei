package com.tl.web.bjts.shzs.service.impl;

import com.tl.web.bjts.shzs.conf.AppProperties;
import com.tl.web.bjts.shzs.dao.children.DocFileinfoChildMapper;
import com.tl.web.bjts.shzs.model.FjxxViewVo;
import com.tl.web.bjts.shzs.model.FjxxVo;
import com.tl.web.bjts.shzs.service.DocFileinfoService;
import com.tl.web.bjts.shzs.service.FjfileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.io.*;
import java.util.*;


/**
 * 附件、申报文件服务实现类
 * Created by likun on 17-6-19.
 */
@Service
public class DocFileinfoServiceImpl implements DocFileinfoService {

    /**
     * 声明日志
     */
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    DocFileinfoChildMapper docFileinfoChildMapper;

    @Autowired
    FjfileService fjfileService;

    @Autowired
    AppProperties appProperties;

    /**
     * 附件列表
     * @param sbid 申报id
     * @return
     */
    public FjxxViewVo view(Long sbid) {
        //根据申报id查询附件基本信息列表
        List<Map<String,Object>> fjMapList = docFileinfoChildMapper.view(sbid);
        //返回的vo
        FjxxViewVo viewVo = new FjxxViewVo();
        viewVo.setSbid(sbid);
        if(fjMapList == null ){
            viewVo.setTotal(0);
            viewVo.setFjxxs(null);
            return viewVo;
        }
        viewVo.setTotal(fjMapList.size());
        //封装附件信息list
        List <FjxxVo> fjxxs = new ArrayList<FjxxVo>();
        for(Map fjMap : fjMapList){
            FjxxVo vo = new FjxxVo();
            vo.setId(((Number) fjMap.get("ID")).longValue());
            vo.setClbz((String)fjMap.get("CLBZ"));
            vo.setFmCode((String) fjMap.get("FMCODE"));
            vo.setFileSize(((Number) fjMap.get("FILESIZE")).intValue());
            vo.setTitle((String) fjMap.get("TITLE"));
            if(fjMap.get("ROOTPATH") != null && fjMap.get("FILEPATH") != null){
                vo.setFileUrl((((String) fjMap.get("ROOTPATH")).equals("root1") ? appProperties.getRootUrlPath() : "") + (String) fjMap.get("FILEPATH"));
            }else{
                vo.setFileUrl("");
            }
            vo.setNote((String)fjMap.get("NOTE"));
            fjxxs.add(vo);
        }
        viewVo.setFjxxs(fjxxs);
        return viewVo;
    }

    /**
     * 下载附件
     * 1.根据文件id查询该文件的基本信息（纳税人识别号，申报也为表代码）
     * 2.通过接入服务器作为代理服务从云端获取文件数据（文件落地）
     * 3.处理文件扩展表（新增/更新）
     * 4.返回vo
     * @param fileId 文件id
     * @return
     */
    public FjxxVo download(Long fileId) {
       //1.根据文件id查询该文件的基本信息（纳税人识别号，申报也为表代码）
        Map fileJbxxMap = docFileinfoChildMapper.fileJbxx(fileId);

       //2.通过接入服务器作为代理服务从云端获取文件数据（文件落地）
        Map fileKzMap = new HashMap();
        FjxxVo vo = new FjxxVo();//返回需要
        try {
            fileKzMap.put("id",fileId);
            fjfileService.downloadFromYun(fileJbxxMap, fileKzMap, vo);

            //查询扩展表是否存在记录
            Map kzMap = docFileinfoChildMapper.selectKz(fileId);
            //扩展表中不存在记录
            // 3.写入文件扩展表 doc_fileinfo_kz

            if(kzMap == null){
                //3.写入文件扩展表 doc_fileinfo_kz
                docFileinfoChildMapper.insertKz(fileKzMap);
            }else{  //更新扩展表
                fileKzMap.put("downloadnum",((Number)fileKzMap.get("downloadnum")).intValue() + 1);
                docFileinfoChildMapper.updateKz(fileKzMap);
            }
        } catch (Exception e) {
            LOGGER.error("下载文件失败,fileId={},msg={}",fileId,e);
        }
        //4.返回vo
        vo.setId(fileId);
        vo.setFmCode((String)fileJbxxMap.get("FMCODE"));
        vo.setTitle((String) fileJbxxMap.get("TITLE"));
        vo.setFileSize(((Number) fileJbxxMap.get("FILESIZE")).intValue());
        vo.setNote((String) fileJbxxMap.get("NOTE"));
        return vo;
    }

}