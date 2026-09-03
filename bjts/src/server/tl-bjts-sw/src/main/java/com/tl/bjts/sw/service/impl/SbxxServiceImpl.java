package com.tl.bjts.sw.service.impl;

import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.dao.sbxx.SbxxMapper;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.datasource.TargetDataSource;
import com.tl.bjts.sw.exception.BusinessException;
import com.tl.bjts.sw.model.ResultCode;
import com.tl.bjts.sw.model.domain.doc.DocFileinfo;
import com.tl.bjts.sw.model.dto.sbxx.DocQueryDTO;
import com.tl.bjts.sw.model.dto.sbxx.DocViewDTO;
import com.tl.bjts.sw.model.dto.sbxx.SbxxQueryDTO;
import com.tl.bjts.sw.model.vo.sbxx.*;
import com.tl.bjts.sw.service.CommonServiceImpl;
import com.tl.bjts.sw.service.ISbxxService;
import com.tl.bjts.sw.service.doc.strategy.StoreStrategyContext;
import com.tl.bjts.sw.utils.TlUtils;
import com.tl.common.ext.utils.BaseController;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.framework.AopContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @描述: 申报信息服务实现类
 * @作者: likun
 * @时间: 2022/9/6 11:42
 */
@Service
public class SbxxServiceImpl implements ISbxxService {
    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private CommonServiceImpl commonService;
    @Autowired
    private SbxxMapper sbxxMapper;
    @Autowired
    private AppProperties appProperties;

    @Override
    public List<SbxxQueryVO> listSbxx(SbxxQueryDTO dto) {
        //设置权限税务机关代码
        if(StringUtils.isBlank(dto.getSwjgdm())){
            dto.setSwjgdm(TlUtils.getPreSwjgdm(commonService.getQxdm()));
        }else {
            dto.setSwjgdm(TlUtils.getPreSwjgdm(dto.getSwjgdm()));
        }

        /**
         *  设置用户空间
         */
        dto.setDbUserBjts(appProperties.getDbUserBjts());
        return sbxxMapper.listSbxx(dto);
    }

    @Override
    public List<DocQueryVO> listSbxxDoc(DocQueryDTO dto) {
        /**
         *  设置用户空间
         */
        dto.setDbUserBjts(appProperties.getDbUserBjts());
        return sbxxMapper.listSbxxDoc(dto);
    }

    @Override
    public String viewSbxxDoc(DocViewDTO dto) {
        // 纳税人电子档案号
        Long nsrdzdah = dto.getNsrdzdah();
        // 附件id
        Long fileId = dto.getFileId();

        /**
         *  设置用户空间
         */
        String dbUserBjts = appProperties.getDbUserBjts();

        /**
         *  查询附件信息，获取云存储路径
         */
        DocFileinfo fileinfo = sbxxMapper.getDocFileinfo(dto.getNsrsbh(),nsrdzdah, fileId, dbUserBjts);
        if (fileinfo == null) {
            LOGGER.error("查看附件-税号:{}不存在附件id:{}的文件", dto.getNsrsbh(), fileId);
            throw new BusinessException(ResultCode.FILE_NOT_EXIST);
        }

        /**
         *  从云存储获取数据，采用策略模式
         */
        byte[] bytes = StoreStrategyContext.getStrategy(appProperties.getStoreType()).
                getYunData(appProperties.getBucketName(),fileinfo.getFilepath());

        if (bytes == null) {
            LOGGER.error("查看附件-税号:{},附件id:{}的文件:{}，从云端获取的数据为空", dto.getNsrsbh(), fileId, fileinfo.toString());
            throw new BusinessException(ResultCode.YUN_DATA_EMPTY);
        }
        return TlUtils.base64Encode(bytes);
    }


    @Override
    @TargetDataSource(name= MultipleDataSourceHolder.SZDP)
    public FpxxVo getSzdp(String zyfpNo) {
        return sbxxMapper.getFpxx4Sdfp(zyfpNo);
    }


    @Override
    @TargetDataSource(name= MultipleDataSourceHolder.JSXT)
    public BgdMainVO getBgdInfo(String ckbgdh, String djxh) {

        BgdMainVO mainVO = sbxxMapper.getBgdMain(djxh, ckbgdh);
        if(mainVO == null){
            throw new BusinessException("不存在的出口报关单");
        }

        commonService.convertCode2Name(mainVO);
        // 获取报关单主表数据
        MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
        List<BgdMxVO> mxVOS = sbxxMapper.listBgdMx(djxh,ckbgdh);
        for (BgdMxVO mxVO : mxVOS) {
            commonService.convertCode2Name(mxVO);
        }

        mainVO.setHwxxs(mxVOS);
        return mainVO;
    }
}
