package com.tl.web.bjts.shzs.service;

import com.tl.web.bjts.shzs.dao.TlMyMapper;
import com.tl.web.bjts.shzs.dao.TlShSbxxHzProfileMapper;
import com.tl.web.bjts.shzs.exception.BusinessException;
import com.tl.web.bjts.shzs.model.domain.TbDtbsj;
import com.tl.web.bjts.shzs.model.domain.TlShSbxxHzProfile;
import com.tl.web.bjts.shzs.model.domain.TlShSbxxHzProfileExample;
import com.tl.web.bjts.shzs.model.vo.FkxxWbSbyyVo;
import com.tl.web.bjts.shzs.model.vo.FkxxWbVO;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by Neo Lin on 2017/6/19.
 */
@Service
public class SbWbService {

    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private TlMyMapper mapper;

    @Autowired
    private TlShSbxxHzProfileMapper sbxxHzProfileMapper;

    /**
     * @param
     * @Description: 回写反馈信息
     * @Date 2017/6/22
     */
    @Transactional
    public void writeBackFeedbackInfo(FkxxWbVO fkxxWbVO) {
        try {
            LOGGER.info("【writeBackFeedbackInfo】" + fkxxWbVO.toString());
            mapper.writeBackFeedbackInfo(fkxxWbVO);
            Set<String> set = new HashSet<>();
            set.add("41");
            set.add("40");
            if (!StringUtils.isBlank(fkxxWbVO.getSbztDm()) && set.contains(fkxxWbVO.getSbztDm())) {
                LOGGER.info("【insertDtbsj】" + fkxxWbVO.toString());
                insertDtbsj(fkxxWbVO.getSbid(), "onlySbxxToYun");
            }
        }catch (Exception e){
            LOGGER.error("writebackFKXX-fail,sbid:" + fkxxWbVO.getSbid(),e);
            throw new BusinessException("回写反馈信息失败");
        }
    }

    public void writeBackSbyyInfo(FkxxWbSbyyVo fkxxWbSbyyVo) {
        try {
            LOGGER.info("【writeBackSbyyInfo】" + fkxxWbSbyyVo.toString());
            TlShSbxxHzProfile profile = new TlShSbxxHzProfile();
            profile.setId(fkxxWbSbyyVo.getSbid());
            profile.setSbyy(fkxxWbSbyyVo.getSbyy());
            sbxxHzProfileMapper.updateByPrimaryKeySelective(profile);
        } catch (Exception e) {
            LOGGER.error("writeBackSbyyInfo-fail,sbid:" + fkxxWbSbyyVo.getSbid(),e);
            throw new BusinessException("回写失败原因失败");
        }

    }

    /**
     * 同步数据
     * 获奖状态变动的数据同步到云端
     *
     * @param mainid
     * @param tblx
     */
    public int insertDtbsj(Long mainid, String tblx) {
        TbDtbsj ysfkdtbsj = new TbDtbsj();
        ysfkdtbsj.setMainid(mainid);
        ysfkdtbsj.setTblxDm(tblx);
        ysfkdtbsj.setCjsj(new Date());
        ysfkdtbsj.setTbcs(0);
        ysfkdtbsj.setYxj(0);//优先级设置为0：表示最优先
        return mapper.insertTb(ysfkdtbsj);
    }

}
