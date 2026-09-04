package com.tl.web.bjts.shzs.service;


import com.tl.web.bjts.shzs.dao.TlJsxtMapper;
import com.tl.web.bjts.shzs.dao.TlMyMapper;
import com.tl.web.bjts.shzs.datasource.MultipleDataSourceHolder;
import com.tl.web.bjts.shzs.model.vo.YdxxVo;
import com.tl.web.bjts.shzs.utils.ConstUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class SbYdxxService {

    @Autowired
    private TlJsxtMapper jsxtMapper;

    public List<YdxxVo> getYdxxs(String lcslid, String lcswsxDm){
        try {
            //切换金三系统数据源
            MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.JSXT);
            if(ConstUtil.SBYWB_SCMDT_LCDM.equals(lcswsxDm)){
                return jsxtMapper.getYdxxs4Sc(lcslid);
            }else if(ConstUtil.SBYWB_WMMTS_LCDM.equals(lcswsxDm)){
                return jsxtMapper.getYdxxs4Wm(lcslid);
            }else if(ConstUtil.SBYWB_WZFDBTS_LCDM.equals(lcswsxDm)){
                return jsxtMapper.getYdxxs4Wzf(lcslid);
            }else if(ConstUtil.SBYWB_GJZYHW_LCDM.equals(lcswsxDm)){
                return jsxtMapper.getYdxxs4Gjzy(lcslid);
            }
        }finally {
            MultipleDataSourceHolder.clearDBType();
        }

        return new ArrayList<>();
    }

}
