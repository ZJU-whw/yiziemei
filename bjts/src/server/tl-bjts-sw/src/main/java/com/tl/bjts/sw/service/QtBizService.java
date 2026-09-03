package com.tl.bjts.sw.service;

import com.github.pagehelper.PageHelper;
import com.tl.bjts.sw.dao.GcTyzZyhwMapper;
import com.tl.bjts.sw.dao.TjfxExtraCktsMapper;
import com.tl.bjts.sw.dao.TlMapper;
import com.tl.bjts.sw.model.domain.GcTyzZyhw;
import com.tl.bjts.sw.model.domain.TjfxExtraCkts;
import com.tl.bjts.sw.model.vo.*;
import com.tl.bjts.sw.utils.TlUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * @Author：Mamf
 * @Date: 2019/8/1.
 * @Description:
 */

@Service
public class QtBizService {

    @Autowired
    TlMapper tlMapper;

    @Autowired
    CommonServiceImpl commonService;

    @Autowired
    TjfxExtraCktsMapper tjfxExtraCktsMapper;


    public List<TjfxExtraCkts> extraCx(String year) {

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        Example example=new Example(TjfxExtraCkts.class);
        Example.Criteria criteria = example.createCriteria();
        criteria.andEqualTo("swcode",swjgDm);
        criteria.andEqualTo("nd",new BigDecimal(year));
        example.setOrderByClause("m_type");

        return tjfxExtraCktsMapper.selectByExample(example);

    }

    public void saveExtraCkts(List<TjfxExtraCkts> revList) {

        String swjgDm = commonService.getCurrentUser().getSwjgDm();

        for(TjfxExtraCkts ckts:revList){
            ckts.setSwcode(swjgDm);
            tlMapper.saveExtraCkts(ckts);
        }
    }

    public List<TjfxExtraCktsVo> tjHzCx(String year) {

        List<TjfxExtraCktsVo> retList=new ArrayList<>();

        List<TjfxExtraCkts> tjfxExtraCkts = extraCx(year);

        int i = Integer.parseInt(year);
        List<TjfxExtraCkts> tjfxExtraCkts_tb = extraCx(i+"");

        for(TjfxExtraCkts obj:tjfxExtraCkts){
            String m_type = obj.getM_type();
            for(TjfxExtraCkts obj_tb:tjfxExtraCkts_tb){
                if(obj_tb.getM_type().equals(m_type)){
                    TjfxExtraCktsVo cktsVo = new TjfxExtraCktsVo();
                    BeanUtils.copyProperties(obj,cktsVo);

                    cktsVo.setM1_tb(obj_tb.getM1());
                    cktsVo.setM2_tb(obj_tb.getM2());
                    cktsVo.setM3_tb(obj_tb.getM3());
                    cktsVo.setM4_tb(obj_tb.getM4());
                    cktsVo.setM5_tb(obj_tb.getM5());
                    cktsVo.setM6_tb(obj_tb.getM6());
                    cktsVo.setM7_tb(obj_tb.getM7());
                    cktsVo.setM8_tb(obj_tb.getM8());
                    cktsVo.setM9_tb(obj_tb.getM9());
                    cktsVo.setM10_tb(obj_tb.getM10());
                    cktsVo.setM11_tb(obj_tb.getM11());
                    cktsVo.setM12_tb(obj_tb.getM12());

                    retList.add(cktsVo);
                }
            }
        }
        return retList;
    }

}
