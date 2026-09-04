package com.tl.web.bjts.shzs.service.impl;

import com.tl.web.bjts.shzs.dao.TlMyMapper;
import com.tl.web.bjts.shzs.dao.TlTsshMapper;
import com.tl.web.bjts.shzs.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.vo.ldlp.*;
import com.tl.web.bjts.shzs.service.CommonServiceImpl;
import com.tl.web.bjts.shzs.service.LdlpBaseService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("ldlpBaseServiceImpl")
public class LdlpBaseServiceImpl implements LdlpBaseService {
    private final TlMyMapper tlMyMapper;
    private final TlTsshMapper tlTsshMapper;
    private final CommonServiceImpl commonService;


    @Autowired
    public LdlpBaseServiceImpl(TlMyMapper tlMyMapper, TlTsshMapper tlTsshMapper,CommonServiceImpl commonService) {
        this.tlMyMapper = tlMyMapper;
        this.tlTsshMapper = tlTsshMapper;
        this.commonService = commonService;
    }

    /**
     * @param zyfpNo
     * @return com.tl.web.bjts.shzs.model.vo.ldlp.FpxxVo
     * @Description: 根据发票号码获取发票信息
     * @Author Neo Lin
     * @Date 2017/12/16
     */
    public FpxxVo getZzsFp(String zyfpNo) {
        try {
            //切换审核系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.SZDP);

            return tlTsshMapper.getFpxx4Sdfp(zyfpNo);
        } finally {
            MultipleDataSourceHolder.clearDBType();
        }
    }

    /**
     * @param bgdNo
     * @return com.tl.web.bjts.shzs.model.vo.ldlp.BgdVo
     * @Description: 根据18位的报关单号查询明细
     * @Author Neo Lin
     * @Date 2017/12/16
     */
    public BgdVo getBgdInfo(String bgdNo,Long sbid) {
        try {
            // 根据sbid查询登记序号
            String djxh = tlMyMapper.getDjxhBySbid(sbid);
            if (StringUtils.isBlank(djxh)){
                throw new BusinessException("根据申报id无法获取到登记序号");
            }

            //切换审核系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);

            BgdVo bgdVo = tlTsshMapper.getBgdInfo(djxh,bgdNo);
            if(bgdVo == null){
                return null;
            }
            commonService.convertCode2Name(bgdVo);

            List<BgdItemVo> bgdItemVos = bgdVo.getBgdItems();
            for(BgdItemVo bgdItem : bgdItemVos){
                commonService.convertCode2Name(bgdItem);
            }
            return bgdVo;

        } finally {
            MultipleDataSourceHolder.clearDBType();
        }
    }

    @Override
    public String getSbywbDm(Long sbid) {
        return tlMyMapper.getSbywbDm(sbid);
    }

    @Override
    public BgdMainVO getBgdInfoV2(String bgdNo, String djxh) {

        if (StringUtils.isBlank(djxh)){
            throw new BusinessException("根据申报id无法获取到登记序号");
        }
        try {
            //切换审核系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            // 获取报关单主表数据
            BgdMainVO mainVO = tlTsshMapper.getBgdMain(djxh,bgdNo);
            if(mainVO == null){
                return null;
            }
            // 获取报关单主表数据
            List<BgdMxVO> mxVOS = tlTsshMapper.listBgdMx(djxh,bgdNo);

            /**
             *  代码表转换
             */
            commonService.convertCode2Name(mainVO);
            for(BgdMxVO mxVO : mxVOS){
                commonService.convertCode2Name(mxVO);
            }
            mainVO.setHwxxs(mxVOS);
            return mainVO;
        } finally {
            MultipleDataSourceHolder.clearDBType();
        }
    }
}
