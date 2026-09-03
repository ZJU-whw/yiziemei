package com.tl.bjts.sw.service;

import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.tl.bjts.sw.conf.AppProperties;
import com.tl.bjts.sw.dao.JcfxZbxmModelMapper;
import com.tl.bjts.sw.datasource.MultipleDataSourceHolder;
import com.tl.bjts.sw.model.domain.JcfxZbxmModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import javax.annotation.PostConstruct;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

@Service
public class ZbItemCacheService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    JcfxZbxmModelMapper jcfxZbxmModelMapper;

    @Autowired
    AppProperties appProperties;

    private LoadingCache<String, JcfxZbxmModel> MAPPING_CACHE = CacheBuilder.newBuilder().
            expireAfterWrite(15, TimeUnit.MINUTES).
            maximumSize(1000).build(
            new CacheLoader<String, JcfxZbxmModel>() {
                @Override
                public JcfxZbxmModel load(String zbdm) throws Exception {
                    return loadDBJcfxZbxmModel(zbdm);
                }
            }
    );


    @PostConstruct
    private void loadMappingCache(){

        if(appProperties.getIsNb()){
            return;
        }

        List<JcfxZbxmModel> mappingModels;
        MultipleDataSourceHolder.setDBType(MultipleDataSourceHolder.TSSH);

        mappingModels = jcfxZbxmModelMapper.selectAll();
        if(!CollectionUtils.isEmpty(mappingModels)){
            transfer2Map(mappingModels);
        }

    }

    /**
     * 从数据库获取
     * @param zbdm
     * @return
     */
    private JcfxZbxmModel loadDBJcfxZbxmModel(String zbdm) {

        return jcfxZbxmModelMapper.selectByPrimaryKey(zbdm);
    }



    private void transfer2Map(List<JcfxZbxmModel> mappingModels) {

        for (JcfxZbxmModel model : mappingModels) {
            MAPPING_CACHE.put(model.getZbxmbm(),model);
        }
    }


    /**
     * 从缓存加载指标代码信息
     * @param zbxmdm
     * @return
     */
    public JcfxZbxmModel getCacheJcfxZbxmModel(String zbxmdm){
        try {
            JcfxZbxmModel item = MAPPING_CACHE.get(zbxmdm);
            //先从缓存中加载数据，并且判断是否存在纳税人识别号，如果没有则加载用户表税号
            if(item==null){
                JcfxZbxmModel data = loadDBJcfxZbxmModel(zbxmdm);
                MAPPING_CACHE.put(zbxmdm,data);
                return data;
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
