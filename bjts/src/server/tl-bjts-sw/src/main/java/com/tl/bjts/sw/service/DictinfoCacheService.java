package com.tl.bjts.sw.service;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.dao.TlSjjcMapper;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.model.DictInfoModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

@Service
public class DictinfoCacheService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    TlSjjcMapper  tlSjjcMapper;

    @Autowired
    AppProperties appProperties;

    private LoadingCache<String, Map<String,String>> MAPPING_CACHE = CacheBuilder.newBuilder().
            expireAfterWrite(15, TimeUnit.MINUTES).
            maximumSize(1000).build(
            new CacheLoader<String, Map<String,String>>() {
                @Override
                public Map<String,String> load(String type) throws Exception {
                    return new HashMap<>();
                }
            }
    );


    @PostConstruct
    private void loadMappingCache(){

        if(appProperties.getIsNb()){
            return;
        }

        List<DictInfoModel> mappingModels;
        MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.TSSH);

        mappingModels = tlSjjcMapper.selectDictInfoAll();
        if(!CollectionUtils.isEmpty(mappingModels)){
            transfer2Map(mappingModels);
        }

    }



    private void transfer2Map(List<DictInfoModel> mappingModels) {
        Map<String,String> dmMap = new HashMap();
        Map<String,String> mcMap = new HashMap();
        for (DictInfoModel model : mappingModels) {
           if(model.getColumnName().contains("_DM")){
               dmMap.put(model.getField(),model.getTableName()+"-"+model.getColumnName());
           }else {
               mcMap.put(model.getField(),model.getTableName()+"-"+model.getColumnName());
           }
        }

        MAPPING_CACHE.put("mc",mcMap);
        MAPPING_CACHE.put("dm",dmMap);
    }


    /**
     * 从缓存加载指标代码信息
     * @param type
     * @return
     */
    public Map<String,String> getCacheDictInfoMap(String type){
        try {
            Map<String,String> item = MAPPING_CACHE.get(type);
            //先从缓存中加载数据，并且判断是否存在纳税人识别号，如果没有则加载用户表税号

            if(item==null || item.keySet().size()==0){
                MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.TSSH);
                List<DictInfoModel> mappingModels = tlSjjcMapper.selectDictInfoAll();
                if(!CollectionUtils.isEmpty(mappingModels)){
                    transfer2Map(mappingModels);
                }
                return MAPPING_CACHE.get(type);
            }
            return item;
        } catch (ExecutionException e) {
            logger.error("error",e);
        }
        return null;
    }

    public void refeshCache() {
        MAPPING_CACHE.invalidateAll();
    }

}
