package com.tl.bjts.sw.service;


import com.tl.bjts.sw.dao.DictCacheMapper;
import com.tl.bjts.sw.model.Dict;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DictCacheService {

    private final DictCacheMapper dictCacheMapper;

    public DictCacheService(DictCacheMapper dictCacheMapper) {
        this.dictCacheMapper = dictCacheMapper;
    }

    //币种
    public List<Dict> getBicodeDict(){
        return dictCacheMapper.getBicode();
    }
    //计量单位
    public List<Dict> getDwcodeDict(){
        return dictCacheMapper.getDwcode();
    }

    //国别
    public List<Dict> getGbcodeDict(){
        return dictCacheMapper.getGbcode();
    }
    //海关
    public List<Dict> getHgcodeDict(){
        return dictCacheMapper.getHgcode();
    }
    //海关口岸
    public List<Dict> getKacodeDict(){
        return dictCacheMapper.getKacode();
    }
    //货源地
    public List<Dict> getHydcodeDict(){
        return dictCacheMapper.getHydcode();
    }
    //结汇方式
    public List<Dict> getJhtypeCodeDict(){
        return dictCacheMapper.getJhtypeCode();
    }
    //结算方式
    public List<Dict> getJsfsCodeDict(){
        return dictCacheMapper.getJsfsCode();
    }
    //贸易方式
    public List<Dict> getTdcodeDict(){
        return dictCacheMapper.getTdcode();
    }
    //运输方式
    public List<Dict> getTranstypeDict(){
        return dictCacheMapper.getTranstype();
    }
    //指运港
    public List<Dict> getZygcodeDict(){
        return dictCacheMapper.getZygcode();
    }
    //成交方式
    public List<Dict> getCjfscodeDict(){
        return dictCacheMapper.getCjfscode();
    }
    // 征免性质
    public List<Dict> getZmxzCodeDict(){
        return dictCacheMapper.getZmxzcode();
    }
    // 包装种类
    public List<Dict> getBzzlCodeDict(){
        return dictCacheMapper.getBzzlcode();
    }

}
